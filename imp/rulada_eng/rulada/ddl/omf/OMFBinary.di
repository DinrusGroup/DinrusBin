/**
	Support for loading of OMF Binary data.
	
	Authors: Eric Anderton
	License: BSD Derivative (see source for details)
	Copyright: 2006 Eric Anderton
*/
module ddl.omf.OMFBinary;


private import ddl.FileBuffer;
private import ddl.DDLReader;
private import ddl.DDLException;
private import ddl.Utils;
private import ddl.ExpContainer;

private import ddl.omf.OMFException;
private import ddl.omf.OMFReader;

debug private import std.gc;
debug private import gcstats;

/**
	(COMENT subrecord)
	This record describes the imported names for a module.
**/
struct IMPDEF{
	LString internalName;
	LString moduleName;
	LString entryName;
	ushort entryOrdinal;
	
	void parse(OMFReader reader);
}

void parse(inout IMPDEF[] imps,OMFReader reader);

/**
	(COMENT subrecord)
	This record marks a set of external names as "weak," and for every weak extern,
	the record associates another external name to use as the default resolution.
**/
struct WKEXT{
	VByte weakIndex;
	VByte resolutionIndex;
			
	void parse(OMFReader reader);
}

void parse(inout WKEXT[] externs,OMFReader reader);

/**
	The EXTDEF record contains a list of symbolic external references that is, references
	to symbols defined in other object modules. The linker resolves external references by 
	matching the symbols declared in EXTDEF records with symbols declared in PUBDEF records.
**/
struct EXTDEF{
	LString name;
	OMFIndex typeIndex;
	
	void parse(OMFReader reader);
}

void parse(inout EXTDEF[] externs,inout LString[] externNames,OMFReader reader);

/**
	The PUBDEF record contains a list of public names. It makes items defined in this object 
	module available to satisfy external references in other modules with which it is bound 
	or linked. The symbols are also available for export if so indicated in an EXPDEF 
	comment record.
**/
struct PUBDEF{
	OMFIndex groupIndex;
	OMFIndex segmentIndex;
	LString name;
	VWord offset;
	OMFIndex typeIndex;	
	
	public void parse(OMFReader reader);
}

void parse(inout PUBDEF[] publics,OMFReader reader);

/**
	The LINNUM record relates line numbers in source code to addresses in object code.
**/
struct LINNUM{
	OMFIndex groupIndex;
	OMFIndex segmentIndex;
	ushort lineNumber;
	VWord segmentOffset;
	
	void parse(OMFReader reader);
}

void parse(inout LINNUM[] lineNumbers,OMFReader reader);

/**
	The SEGDEF record describes a logical segment in an object module. 
	It defines the segment's name, length, and	alignment, and the way the segment can be 
	combined with other logical segments at bind, link, or load time.
	
	Object records that follow a SEGDEF record can refer to it to identify a particular 
	segment. The SEGDEF records are ordered by occurrence, and are referenced by segment 
	indexes (starting from 1) in subsequent records.
**/
struct SEGDEF{
	VWord dataLength;
	OMFIndex nameIndex;
	OMFIndex classNameIndex;
	OMFIndex overlayIndex;
	uint byteAlignment;
	ubyte combination;
	
	// combination constants
	enum: ubyte{
		PRIVATE = 0,
		PUBLIC = 4,
		STACK = 5,
		COMMON = 7
	}
	
	char[] getCombination();
	
	void parse(OMFReader reader);
}

void parse(inout SEGDEF[] segments,OMFReader reader);

/**
	This record causes the program segments identified by SEGDEF records to be collected 
	together (grouped). For OS/2, the segments are combined into a logical segment that 
	is to be addressed through a single selector. For MS-DOS, the segments are combined 
	within the same 64K frame in the run-time memory map.
**/
struct GRPDEF{
	OMFIndex nameIndex;
	OMFIndex[] segments;
	ubyte[] segmentTypes;
}

void parse(inout GRPDEF[] groups,OMFReader reader);

/**
	The FIXUPP record contains information that allows the linker to resolve (fix up) 
	and eventually relocate	references between object modules. FIXUPP records describe 
	the LOCATION of each address value to be fixed up, the TARGET address to which the 
	fixup refers, and the FRAME relative to which the address computation is performed.
**/
struct FIXUPP{
	bool isSegmentRelative; // is this a segment relative fixup (true=add address of segment, false=use actual address)
	uint destSegmentIndex;
	uint destOffset;
	uint destNameIndex; // symbol name of referenced COMDAT
	uint targetIndex; // external reference
	bool isExternStyleFixup; // true if this uses an external index as a target, false if it is a segment index
	
	void parse(OMFReader reader);
}

alias ExpContainer!(FIXUPP) FIXUPPSet;

/**
	Temporary record used to store FIXUPP TARGET and FRAME information
**/
struct FixupThread{
	uint method;
	ushort index;	
}

/**
	Temporary record usd to store LIDATA, LEDATA and COMDAT address information for
	subsequent use by FIXUPP records
	
	TODO: fashion a "Fixup Source" that optionally references COMDAT symbol by name
	so 
	
**/
struct FixupData{
	uint groupIndex;
	uint segmentIndex;
	uint offset;
	OMFIndex destNameIndex;
	FixupThread[4] frameThreads;
	FixupThread[4] targetThreads;	
}

/**
	FixupSet parse routine.
**/
void parse(inout FIXUPPSet fixups,inout FixupData fixupData, OMFReader reader);


/**
	This record provides contiguous binary data-executable code or program data that is 
	part of a program segment. The data is eventually copied into the program's executable 
	binary image by the linker.  
	
	The data bytes may be subject to relocation or fixing up as determined by the presence 
	of a subsequent FIXUPP record, but otherwise they require no expansion when mapped to 
	memory at run time.
**/
struct LIDATA{
	OMFIndex segmentIndex;
	VWord offset;
	void[] data;
	
	void parse(OMFReader reader);
}

void parse(inout LIDATA[] iteratedData,inout FixupData fixupData,OMFReader reader);

ubyte[] parseIteratedData(OMFReader reader);	
		
/**
	Like the LEDATA record, the LIDATA record contains binary data-executable code or 
	program data. The data in an LIDATA record, however, is specified as a repeating 
	pattern (iterated), rather than by explicit enumeration.
	
	The data in an LIDATA record can be modified by the linker if the LIDATA record is 
	followed by a FIXUPP record, although this is not recommended.
**/
struct LEDATA{
	OMFIndex segmentIndex;
	VWord offset;
	void[] data;
	
	void parse(OMFReader reader);
}

void parse(inout LEDATA[] enumeratedData,inout FixupData fixupData,OMFReader reader);

/**
	The COMDEF record is an extension to the basic set of 8086 object record types. 
	It declares a list of one or more communal variables (uninitialized static data 
	or data that may match initialized static data in another compilation unit).
	
	The size of such a variable is the maximum size defined in any module naming the 
	variable as communal or public. The placement of communal variables is determined 
	by the data type using established conventions (noted below).
**/
struct COMDEF{
	LString communalName;
	VByte typeIndex;
	ubyte length;
	ubyte dataType;
			
	void parse(OMFReader reader);
	
	uint parseCOMDEFValue(OMFReader reader);
}

void parse(inout COMDEF[] commonDefinitions,inout LString[] externNames,OMFReader reader);

/**
	This record serves the same purpose as the EXTDEF record described earlier. However,
	the symbol named is referred to through a Logical Name Index field. Such a Logical 
	Name Index field is defined through an LNAMES or LLNAMES record.
**/
struct CEXTDEF{
	OMFIndex nameIndex;
	OMFIndex typeIndex;
	
	void parse(OMFReader reader);
}

void parse(inout CEXTDEF[] commonExterns,inout LString[] externNames,LString[] names,OMFReader reader);

/**
	The purpose of the COMDAT record is to combine logical blocks of code and data that 
	may be duplicated across a number of compiled modules.
**/
struct COMDAT{
	bool isContinuation; // do we extend the previous COMDAT?
	OMFIndex nameIndex;
	VWord enumDataOffset; // offset relative to start of referenced public
	OMFIndex typeIndex;
	OMFIndex groupIndex; 
	OMFIndex segmentIndex;
	void[] data;
	
	void parse(OMFReader reader);
}

void parse(inout COMDAT[] commonData,inout FixupData fixupData,OMFReader reader);

/**
	This record will be used to output line numbers for functions specified through COMDAT 
	records. Each LINSYM record is associated with a preceding COMDAT record.
**/
struct LINSYM{
	bool isContinuation; // do we extend the previous COMDAT?
	OMFIndex nameIndex;
	ushort lineNumber;
	VWord baseOffset;
	
	void parse(OMFReader reader);
}

void parse(inout LINSYM[] lineNumbers,OMFReader reader);

/**
	Abstraction of an OMFRecord.  Provides support for record checksums and determining
	word and byte width.
**/
struct OMFRecord{
	ubyte type;
	ushort length;
	ubyte recordType;
	ubyte[] data;
	ubyte checksum;
	
	void doRecordChecksum();
	
	void parse(DDLReader reader);
	
	OMFReader getOMFReader();
}

struct OMFBinary{
	// records
	IMPDEF[] impdefs;
	WKEXT[] weakExterns;
	EXTDEF[] externs;
	PUBDEF[] publics;
	LINNUM[] lineNumbers;
	SEGDEF[] segments;
	GRPDEF[] groups;
	FIXUPPSet fixups;
	LIDATA[] iteratedData;
	LEDATA[] enumeratedData;
	COMDEF[] communalDefinitions;
	CEXTDEF[] communalExterns;
	COMDAT[] communalData;
	LINSYM[] comdatLineNumbers;
	
	//data
	LString libraryName;
	LString[] names;
	LString[] externNames;
	
	// comment sub data
	char[][] defaultLibSearch;
	
	static char[][uint] recordNameLookup;
	
	static this(){
		recordNameLookup[0x80] =  "THEADR";
		recordNameLookup[0x82] =  "LHEADR";
		recordNameLookup[0x88] =  "COMENT";
		recordNameLookup[0x8A] =  "MODEND";
		recordNameLookup[0x8C] =  "EXTDEF";
		recordNameLookup[0x90] =  "PUBDEF";
		recordNameLookup[0x94] =  "LINNUM";
		recordNameLookup[0x96] =  "LNAMES";
		recordNameLookup[0x98] =  "SEGDEF";
		recordNameLookup[0x9A] =  "GRPDEF";
		recordNameLookup[0x9C] =  "FIXUPP";
		recordNameLookup[0xA0] =  "LEDATA";
		recordNameLookup[0xA2] =  "LIDATA";
		recordNameLookup[0xB0] =  "COMDEF";
		recordNameLookup[0xB2] =  "BAKPAT";
		recordNameLookup[0xB4] =  "LEXTDEF";
		recordNameLookup[0xB6] =  "LPUBDEF";
		recordNameLookup[0xB8] =  "LCOMDEF";
		recordNameLookup[0xBC] =  "CEXTDEF";
		recordNameLookup[0xC2] =  "COMDAT";
		recordNameLookup[0xC4] =  "LINSYM";
		recordNameLookup[0xC6] =  "ALIAS";
		recordNameLookup[0xC8] =  "NBKPAT";
		recordNameLookup[0xCA] =  "LLNAMES";
		recordNameLookup[0xCC] =  "VERNUM";
		recordNameLookup[0xCE] =  "VENDEXT";		
	}
	
	void parse(DDLReader mainReader);
	
	void parseTHEADR(OMFReader reader);
	
	void parseCOMENT(OMFReader reader);
	
	void parseNames(OMFReader reader);
		
	public char[] toString();
}
