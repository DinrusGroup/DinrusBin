// Written in the D programming language.

/**
 * Read/write data in the $(LINK2 http://www.info-_zip.org, zip archive) format.
 * Makes use of the std.auxc.zlib compression library.
 *
 * Bugs: 
 *	$(UL
 *	$(LI Multi-disk zips not supported.)
 *	$(LI Only Zip version 20 formats are supported.)
 *	$(LI Only supports compression modes 0 (no compression) and 8 (deflate).)
 *	$(LI Does not support encryption.)
 *	$(LI $(BUGZILLA 592))
 *	$(LI $(BUGZILLA 1832))
 *	$(LI $(BUGZILLA 2137))
 *	$(LI $(BUGZILLA 2138))
 *	)
 *
 * Macros:
 *	WIKI = Phobos/StdZip
 */

module std.zip;

private import std.zlib;
private import std.date;
private import std.intrinsic;

//debug=print;

/** Thrown on error.
 */
class ZipException : Exception
{
    this(string msg)
    {
	super("ZipException: " ~ msg);
    }
}
alias ZlibException ИсклЗип;
/**
 * A member of the ZipArchive.
 */
 alias ArchiveMember ЧленАрхива;
 
class ArchiveMember
{
alias flags флаги;
alias compressionMethod методСжатия;
alias time время;
alias crc32 кс32;
alias compressedSize сжатыйРазмер;
alias expandedSize расжатыйРазмер;
alias diskNumber номерДиска;
alias internalAttributes внутренниеАтры;
alias externalAttributes внешниеАтры; 
alias name имя;
alias extra экстра;
alias compressedData сжатыеДанные;
alias expandedData расжатыеДанные;

    ushort madeVersion = 20;	/// Read Only
    ushort extractVersion = 20;	/// Read Only
    ushort flags;		/// Read/Write: normally set to 0
    ushort compressionMethod;	/// Read/Write: 0 for compression, 8 for deflate
    std.date.DosFileTime time;	/// Read/Write: Last modified time of the member. It's in the DOS date/time format.
    uint crc32;			/// Read Only: cyclic redundancy check (CRC) value
    uint compressedSize;	/// Read Only: size of data of member in compressed form.
    uint expandedSize;		/// Read Only: size of data of member in expanded form.
    ushort diskNumber;		/// Read Only: should be 0.
    ushort internalAttributes;	/// Read/Write
    uint externalAttributes;	/// Read/Write

    private uint offset;

    /**
     * Read/Write: Usually the file name of the archive member; it is used to
     * index the archive directory for the member. Each member must have a unique
     * name[]. Do not change without removing member from the directory first.
     */
    string name;

    ubyte[] extra;		/// Read/Write: extra data for this member.
    string comment;		/// Read/Write: comment associated with this member.
    ubyte[] compressedData;	/// Read Only: data of member in compressed form.
    ubyte[] expandedData;	/// Read/Write: data of member in uncompressed form.

    debug(print)
    {
    void print()
    {
	printf("name = '%.*s'\n", name);
	printf("\tcomment = '%.*s'\n", comment);
	printf("\tmadeVersion = x%04x\n", madeVersion);
	printf("\textractVersion = x%04x\n", extractVersion);
	printf("\tflags = x%04x\n", flags);
	printf("\tcompressionMethod = %d\n", compressionMethod);
	printf("\ttime = %d\n", time);
	printf("\tcrc32 = x%08x\n", crc32);
	printf("\texpandedSize = %d\n", expandedSize);
	printf("\tcompressedSize = %d\n", compressedSize);
	printf("\tinternalAttributes = x%04x\n", internalAttributes);
	printf("\texternalAttributes = x%08x\n", externalAttributes);
    }
    }
}

/**
 * Object representing the entire archive.
 * ZipArchives are collections of ArchiveMembers.
 */
alias ZipArchive ЗипАрхив;
class ZipArchive
{
alias data данные;
alias endrecOffset смещкКонцуЗап;
alias diskNumber номерДиска;
//alias diskStartDir 
alias numEntries числоЗаписей;
alias totalEntries всегоЗаписей;
alias comment комментарий;
alias directory папка;
alias addMember добавитьЧлен;
alias deleteMember удалитьЧлен;
alias build построить;
alias expand развернуть;

    ubyte[] data;	/// Read Only: array representing the entire contents of the archive.
    uint endrecOffset;

    uint diskNumber;	/// Read Only: 0 since multi-disk zip archives are not supported.
    uint diskStartDir;	/// Read Only: 0 since multi-disk zip archives are not supported.
    uint numEntries;	/// Read Only: number of ArchiveMembers in the directory.
    uint totalEntries;	/// Read Only: same as totalEntries.
    string comment;	/// Read/Write: the archive comment. Must be less than 65536 bytes in length.

    /**
     * Read Only: array indexed by the name of each member of the archive.
     * Пример:
     *  All the members of the archive can be accessed with a foreach loop:
     * --------------------
     * ZipArchive archive = new ZipArchive(data);
     * foreach (ArchiveMember am; archive.directory)
     * {
     *     writefln("member name is '%s'", am.name);
     * }
     * --------------------
     */
    ArchiveMember[string] directory;

    debug (print)
    {
    void print()
    {
	printf("\tdiskNumber = %u\n", diskNumber);
	printf("\tdiskStartDir = %u\n", diskStartDir);
	printf("\tnumEntries = %u\n", numEntries);
	printf("\ttotalEntries = %u\n", totalEntries);
	printf("\tcomment = '%.*s'\n", comment);
    }
    }

    /* ============ Creating a new archive =================== */

    /** Constructor to use when creating a new archive.
     */
    this()
    {
    }

    /** Add de to the archive.
     */
    void addMember(ArchiveMember de);

    /** Delete de from the archive.
     */
    void deleteMember(ArchiveMember de);

    /**
     * Construct an archive out of the current members of the archive.
     *
     * Fills in the properties data[], diskNumber, diskStartDir, numEntries,
     * totalEntries, and directory[].
     * For each ArchiveMember, fills in properties crc32, compressedSize,
     * compressedData[].
     *
     * Возвращает: array representing the entire archive.
     */
    void[] build();

    /* ============ Reading an existing archive =================== */

    /**
     * Constructor to use when reading an existing archive.
     *
     * Fills in the properties data[], diskNumber, diskStartDir, numEntries,
     * totalEntries, comment[], and directory[].
     * For each ArchiveMember, fills in
     * properties madeVersion, extractVersion, flags, compressionMethod, time,
     * crc32, compressedSize, expandedSize, compressedData[], diskNumber,
     * internalAttributes, externalAttributes, name[], extra[], comment[].
     * Use expand() to get the expanded data for each ArchiveMember.
     *
     * Параметры:
     *	buffer = the entire contents of the archive.
     */

    this(void[] buffer)
    {	int iend;
	int i;
	int endcommentlength;
	uint directorySize;
	uint directoryOffset;

	this.data = cast(ubyte[]) buffer;

	// Find 'end record index' by searching backwards for signature
	iend = data.length - 66000;
	if (iend < 0)
	    iend = 0;
	for (i = data.length - 22; 1; i--)
	{
	    if (i < iend)
		throw new ZipException("no end record");

	    if (data[i .. i + 4] == cast(ubyte[])"PK\x05\x06")
	    {
		endcommentlength = getUshort(i + 20);
		if (i + 22 + endcommentlength > data.length)
		    continue;
		comment = cast(string)(data[i + 22 .. i + 22 + endcommentlength]);
		endrecOffset = i;
		break;
	    }
	}

	// Read end record data
	diskNumber = getUshort(i + 4);
	diskStartDir = getUshort(i + 6);

	numEntries = getUshort(i + 8);
	totalEntries = getUshort(i + 10);

	if (numEntries != totalEntries)
	    throw new ZipException("multiple disk zips not supported");

	directorySize = getUint(i + 12);
	directoryOffset = getUint(i + 16);

	if (directoryOffset + directorySize > i)
	    throw new ZipException("corrupted directory");

	i = directoryOffset;
	for (int n = 0; n < numEntries; n++)
	{
	    /* The format of an entry is:
	     *	'PK' 1, 2
	     *	directory info
	     *	path
	     *	extra data
	     *	comment
	     */

	    uint offset;
	    uint namelen;
	    uint extralen;
	    uint commentlen;

	    if (data[i .. i + 4] != cast(ubyte[])"PK\x01\x02")
		throw new ZipException("invalid directory entry 1");
	    ArchiveMember de = new ArchiveMember();
	    de.madeVersion = getUshort(i + 4);
	    de.extractVersion = getUshort(i + 6);
	    de.flags = getUshort(i + 8);
	    de.compressionMethod = getUshort(i + 10);
	    de.time = cast(DosFileTime)getUint(i + 12);
	    de.crc32 = getUint(i + 16);
	    de.compressedSize = getUint(i + 20);
	    de.expandedSize = getUint(i + 24);
	    namelen = getUshort(i + 28);
	    extralen = getUshort(i + 30);
	    commentlen = getUshort(i + 32);
	    de.diskNumber = getUshort(i + 34);
	    de.internalAttributes = getUshort(i + 36);
	    de.externalAttributes = getUint(i + 38);
	    de.offset = getUint(i + 42);
	    i += 46;

	    if (i + namelen + extralen + commentlen > directoryOffset + directorySize)
		throw new ZipException("invalid directory entry 2");

	    de.name = cast(string)(data[i .. i + namelen]);
	    i += namelen;
	    de.extra = data[i .. i + extralen];
	    i += extralen;
	    de.comment = cast(string)(data[i .. i + commentlen]);
	    i += commentlen;

	    directory[de.name] = de;
	}
	if (i != directoryOffset + directorySize)
	    throw new ZipException("invalid directory entry 3");
    }

    /*****
     * Decompress the contents of archive member de and return the expanded
     * data.
     *
     * Fills in properties extractVersion, flags, compressionMethod, time,
     * crc32, compressedSize, expandedSize, expandedData[], name[], extra[].
     */
    ubyte[] expand(ArchiveMember de)
    {	uint namelen;
	uint extralen;

	if (data[de.offset .. de.offset + 4] != cast(ubyte[])"PK\x03\x04")
	    throw new ZipException("invalid directory entry 4");

	// These values should match what is in the main zip archive directory
	de.extractVersion = getUshort(de.offset + 4);
	de.flags = getUshort(de.offset + 6);
	de.compressionMethod = getUshort(de.offset + 8);
	de.time = cast(DosFileTime)getUint(de.offset + 10);
	de.crc32 = getUint(de.offset + 14);
	de.compressedSize = getUint(de.offset + 18);
	de.expandedSize = getUint(de.offset + 22);
	namelen = getUshort(de.offset + 26);
	extralen = getUshort(de.offset + 28);

	debug(print)
	{
	    printf("\t\texpandedSize = %d\n", de.expandedSize);
	    printf("\t\tcompressedSize = %d\n", de.compressedSize);
	    printf("\t\tnamelen = %d\n", namelen);
	    printf("\t\textralen = %d\n", extralen);
	}

	if (de.flags & 1)
	    throw new ZipException("encryption not supported");

	int i;
	i = de.offset + 30 + namelen + extralen;
	if (i + de.compressedSize > endrecOffset)
	    throw new ZipException("invalid directory entry 5");

	de.compressedData = data[i .. i + de.compressedSize];
	debug(print) arrayPrint(de.compressedData);

	switch (de.compressionMethod)
	{
	    case 0:
		de.expandedData = de.compressedData;
		return de.expandedData;

	    case 8:
		// -15 is a magic value used to decompress zip files.
		// It has the effect of not requiring the 2 byte header
		// and 4 byte trailer.
		de.expandedData = cast(ubyte[])std.zlib.uncompress(cast(void[])de.compressedData, de.expandedSize, -15);
		return de.expandedData;

	    default:
		throw new ZipException("unsupported compression method");
	}
    }

    /* ============ Utility =================== */

    ushort getUshort(int i)
    {
	version (LittleEndian)
	{
	    return *cast(ushort *)&data[i];
	}
	else
	{
	    ubyte b0 = data[i];
	    ubyte b1 = data[i + 1];
	    return (b1 << 8) | b0;
	}
    }

    uint getUint(int i)
    {
	version (LittleEndian)
	{
	    return *cast(uint *)&data[i];
	}
	else
	{
	    return bswap(*cast(uint *)&data[i]);
	}
    }

    void putUshort(int i, ushort us)
    {
	version (LittleEndian)
	{
	    *cast(ushort *)&data[i] = us;
	}
	else
	{
	    data[i] = cast(ubyte)us;
	    data[i + 1] = cast(ubyte)(us >> 8);
	}
    }

    void putUint(int i, uint ui)
    {
	version (BigEndian)
	{
	    ui = bswap(ui);
	}
	*cast(uint *)&data[i] = ui;
    }
}

debug(print)
{
    void arrayPrint(ubyte[] array)
    {
	printf("array %p,%d\n", cast(void*)array, array.length);
	for (int i = 0; i < array.length; i++)
	{
	    printf("%02x ", array[i]);
	    if (((i + 1) & 15) == 0)
		printf("\n");
	}
	printf("\n");
    }
}
