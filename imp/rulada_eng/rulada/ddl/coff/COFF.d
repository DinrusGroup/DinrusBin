/+
	Copyright (c) 2005, 2006 J Duncan, Eric Anderton
        
	Permission is hereby granted, free of charge, to any person
	obtaining a copy of this software and associated documentation
	files (the "Software"), to deal in the Software without
	restriction, including without limitation the rights to use,
	copy, modify, merge, publish, distribute, sublicense, and/or
	sell copies of the Software, and to permit persons to whom the
	Software is furnished to do so, subject to the following
	conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
	OTHER DEALINGS IN THE SOFTWARE.
+/
/**
	Microsoft PE-COFF data structures & constants

	Authors: J Duncan, Eric Anderton
	License: BSD Derivative (see source for details)
	Copyright: 2005, 2006 J Duncan, Eric Anderton
*/

module ddl.coff.COFF;

private import std.string;
private import std.stdio;
private import std.stream;
private import std.date;
private import std.conv;
private import std.c;


extern (C)
{
	void * memcpy (void *dst, void *src, uint);
}    


// PE-COFF constants
const int PECOFF_MAGIC_PE				= 0x10B;
const int PECOFF_MAGIC_PEPLUS			= 0x20B;
const char[8] COFF_LIBRARY_SIGNATURE	= "!<arch>\n";
const char[2] COFF_LIBRARY_MEMBER_EOH	= "`\n";

// coff machine type constants
enum
{
	COFF_MACHINE_UNKNOWN	= 0,
	COFF_MACHINE_ALPHA		= 0x184,
	COFF_MACHINE_ARM		= 0x1c0,
	COFF_MACHINE_ALPHA64	= 0x284,
	COFF_MACHINE_I386		= 0x14c,
	COFF_MACHINE_IA64		= 0x200,
	COFF_MACHINE_M68K		= 0x268,
	COFF_MACHINE_MIPS16		= 0x266,
	COFF_MACHINE_MIPSFPU	= 0x366,
	COFF_MACHINE_MIPSFPU16	= 0x466,
	COFF_MACHINE_POWERPC	= 0x1f0,
	COFF_MACHINE_R3000		= 0x162,
	COFF_MACHINE_R4000		= 0x166,
	COFF_MACHINE_R10000		= 0x168,
	COFF_MACHINE_SH3		= 0x1a2,
	COFF_MACHINE_SH4		= 0x1a6,
	COFF_MACHINE_THUMB		= 0x1c2
}

// coff file characteristics flags
enum : ushort
{
	COFF_FLAGS_RELOCS_STRIPPED			= 0x0001,
	COFF_FLAGS_EXECUTABLE_IMAGE			= 0x0002,
	COFF_FLAGS_LINE_NUMS_STRIPPED		= 0x0004,
	COFF_FLAGS_LOCAL_SYMS_STRIPPED		= 0x0008,
	COFF_FLAGS_AGGRESSIVE_WS_TRIM		= 0x0010,
	COFF_FLAGS_LARGE_ADDRESS_AWARE		= 0x0020,
	COFF_FLAGS_16BIT_MACHINE			= 0x0040,
	COFF_FLAGS_BYTES_REVERSED_LO		= 0x0080,
	COFF_FLAGS_32BIT_MACHINE			= 0x0100,
	COFF_FLAGS_DEBUG_STRIPPED			= 0x0200,
	COFF_FLAGS_REMOVABLE_RUN_FROM_SWAP	= 0x0400,
	COFF_FLAGS_SYSTEM					= 0x1000,
	COFF_FLAGS_DLL						= 0x2000,
	COFF_FLAGS_UP_SYSTEM_ONLY			= 0x4000,
	COFF_FLAGS_BYTES_REVERSED_HI		= 0x8000
}

// coff section characteristics flags
enum : uint
{
	COFF_SECTION_TYPE_REG				= 0x00000000,	//	Reserved for future use.
	COFF_SECTION_TYPE_DSECT				= 0x00000001,	//	Reserved for future use.
	COFF_SECTION_TYPE_NOLOAD			= 0x00000002,	//	Reserved for future use.
	COFF_SECTION_TYPE_GROUP				= 0x00000004,	//	Reserved for future use.
	COFF_SECTION_TYPE_NO_PAD			= 0x00000008,	//	Section should not be padded to next boundary. This is obsolete and replaced by IMAGE_SCN_ALIGN_1BYTES. This is valid for object files only.
	COFF_SECTION_TYPE_COPY				= 0x00000010,	//	Reserved for future use.
	COFF_SECTION_CNT_CODE				= 0x00000020,	//	Section contains executable code.
	COFF_SECTION_CNT_INITIALIZED_DATA	= 0x00000040,	//	Section contains initialized data.
	COFF_SECTION_CNT_UNINITIALIZED_DATA	= 0x00000080,	//	Section contains uninitialized data.
	COFF_SECTION_LNK_OTHER				= 0x00000100,	//	Reserved for future use.
	COFF_SECTION_LNK_INFO				= 0x00000200,	//	Section contains comments or other information. The .drectve section has this type. This is valid for object files only.
	COFF_SECTION_TYPE_OVER				= 0x00000400,	//	Reserved for future use.
	COFF_SECTION_LNK_REMOVE				= 0x00000800,	//	Section will not become part of the image. This is valid for object files only.
	COFF_SECTION_LNK_COMDAT				= 0x00001000,	//	Section contains COMDAT data. See Section 5.5.6, "COMDAT Sections," for more information. This is valid for object files only.
	COFF_SECTION_MEM_FARDATA			= 0x00008000,	//	Reserved for future use.
	COFF_SECTION_MEM_PURGEABLE			= 0x00020000,	//	Reserved for future use.
	COFF_SECTION_MEM_16BIT				= 0x00020000,	//	Reserved for future use.
	COFF_SECTION_MEM_LOCKED				= 0x00040000,	//	Reserved for future use.
	COFF_SECTION_MEM_PRELOAD			= 0x00080000,	//	Reserved for future use.
	COFF_SECTION_ALIGN_1BYTES			= 0x00100000,	//	Align data on a 1-byte boundary. This is valid for object files only.
	COFF_SECTION_ALIGN_2BYTES			= 0x00200000,	//	Align data on a 2-byte boundary. This is valid for object files only.
	COFF_SECTION_ALIGN_4BYTES			= 0x00300000,	//	Align data on a 4-byte boundary. This is valid for object files only.
	COFF_SECTION_ALIGN_8BYTES			= 0x00400000,	//	Align data on a 8-byte boundary. This is valid for object files only.
	COFF_SECTION_ALIGN_16BYTES			= 0x00500000,	//	Align data on a 16-byte boundary. This is valid for object files only.
	COFF_SECTION_ALIGN_32BYTES			= 0x00600000,	//	Align data on a 32-byte boundary. This is valid for object files only.
	COFF_SECTION_ALIGN_64BYTES			= 0x00700000,	//	Align data on a 64-byte boundary. This is valid for object files only.
	COFF_SECTION_ALIGN_128BYTES			= 0x00800000,	//	Align data on a 128-byte boundary. This is valid for object files only.
	COFF_SECTION_ALIGN_256BYTES			= 0x00900000,	//	Align data on a 256-byte boundary. This is valid for object files only.
	COFF_SECTION_ALIGN_512BYTES			= 0x00a00000,	//	Align data on a 512-byte boundary. This is valid for object files only.
	COFF_SECTION_ALIGN_1024BYTES		= 0x00b00000,	//	Align data on a 1024-byte boundary. This is valid for object files only.
	COFF_SECTION_ALIGN_2048BYTES		= 0x00c00000,	//	Align data on a 2048-byte boundary. This is valid for object files only.
	COFF_SECTION_ALIGN_4096BYTES		= 0x00d00000,	//	Align data on a 4096-byte boundary. This is valid for object files only.
	COFF_SECTION_ALIGN_8192BYTES		= 0x00e00000,	//	Align data on a 8192-byte boundary. This is valid for object files only.
	COFF_SECTION_LNK_NRELOC_OVFL		= 0x01000000,	//	Section contains extended relocations.
	COFF_SECTION_MEM_DISCARDABLE		= 0x02000000,	//	Section can be discarded as needed.
	COFF_SECTION_MEM_NOT_CACHED			= 0x04000000,	//	Section cannot be cached.
	COFF_SECTION_MEM_NOT_PAGED			= 0x08000000,	//	Section is not pageable.
	COFF_SECTION_MEM_SHARED				= 0x10000000,	//	Section can be shared in memory.
	COFF_SECTION_MEM_EXECUTE			= 0x20000000,	//	Section can be executed as code.
	COFF_SECTION_MEM_READ				= 0x40000000,	//	Section can be read.
	COFF_SECTION_MEM_WRITE				= 0x80000000	//  Section can be written to.
}

// relocation type
enum : ushort
{
	COFF_REL_I386_ABSOLUTE		= 0x0000,	// This relocation is ignored.
	COFF_REL_I386_DIR16			= 0x0001, 	// Not supported.
	COFF_REL_I386_REL16			= 0x0002,	// Not supported.
	COFF_REL_I386_DIR32			= 0x0006,	// The target's 32-bit virtual address.
	COFF_REL_I386_DIR32NB		= 0x0007,	// The target's 32-bit relative virtual address.
	COFF_REL_I386_SEG12			= 0x0009,	// Not supported.
	COFF_REL_I386_SECTION		= 0x000a,	// The 16-bit-section index of the section containing the target. This is used to support debugging information.
	COFF_REL_I386_SECREL		= 0x000b,	// The 32-bit offset of the target from the beginning of its section. This is used to support debugging information as well as static thread local storage.
	COFF_REL_I386_REL32			= 0x0014	// The 32-bit relative displacement to the target. This supports the x86 relative branch and call instructions.
}

// symbol storage class
enum : byte
{
	COFF_SYM_CLASS_END_OF_FUNCTION	= -1,	// (0xFF)	Special symbol representing end of function, for debugging purposes.
	COFF_SYM_CLASS_NULL				= 0,	// 	No storage class assigned.
	COFF_SYM_CLASS_AUTOMATIC		= 1,	// 	Automatic (stack) variable. The Value field specifies stack frame offset.
	COFF_SYM_CLASS_EXTERNAL			= 2,	// 	Used by Microsoft tools for external symbols. The Value field indicates the size if the section number is COFF_SYM_UNDEFINED (0). If the section number is not 0, then the Value field specifies the offset within the section.
	COFF_SYM_CLASS_STATIC			= 3,	// 	The Value field specifies the offset of the symbol within the section. If the Value is 0, then the symbol represents a section name.
	COFF_SYM_CLASS_REGISTER			= 4,	// 	Register variable. The Value field specifies register number.
	COFF_SYM_CLASS_EXTERNAL_DEF		= 5,	// 	Symbol is defined externally.
	COFF_SYM_CLASS_LABEL			= 6,	// 	Code label defined within the module. The Value field specifies the offset of the symbol within the section.
	COFF_SYM_CLASS_UNDEFINED_LABEL	= 7,	// 	Reference to a code label not defined.
	COFF_SYM_CLASS_MEMBER_OF_STRUCT	= 8,	// 	Structure member. The Value field specifies nth member.
	COFF_SYM_CLASS_ARGUMENT			= 9,	// 	Formal argument (parameter)of a function. The Value field specifies nth argument.
	COFF_SYM_CLASS_STRUCT_TAG		= 10,	// 	Structure tag-name entry.
	COFF_SYM_CLASS_MEMBER_OF_UNION	= 11,	// 	Union member. The Value field specifies nth member.
	COFF_SYM_CLASS_UNION_TAG		= 12,	// 	Union tag-name entry.
	COFF_SYM_CLASS_TYPE_DEFINITION	= 13,	// 	Typedef entry.
	COFF_SYM_CLASS_UNDEFINED_STATIC	= 14,	// 	Static data declaration.
	COFF_SYM_CLASS_ENUM_TAG			= 15,	// 	Enumerated type tagname entry.
	COFF_SYM_CLASS_MEMBER_OF_ENUM	= 16,	// 	Member of enumeration. Value specifies nth member.
	COFF_SYM_CLASS_REGISTER_PARAM	= 17,	// 	Register parameter.
	COFF_SYM_CLASS_BIT_FIELD		= 18,	// 	Bit-field reference. Value specifies nth bit in the bit field.
	COFF_SYM_CLASS_BLOCK			= 100,	// 	A .bb (beginning of block) or .eb (end of block) record. Value is the relocatable address of the code location.
	COFF_SYM_CLASS_FUNCTION			= 101,	// 	Used by Microsoft tools for symbol records that define the extent of a function: begin function (named .bf), end function (.ef), and lines in function (.lf). For .lf records, Value gives the number of source lines in the function. For .ef records, Value gives the size of function code.
	COFF_SYM_CLASS_END_OF_STRUCT	= 102,	// 	End of structure entry.
	COFF_SYM_CLASS_FILE				= 103,	// Used by Microsoft tools, as well as traditional COFF format, for the source-file symbol record. The symbol is followed by auxiliary records that name the file.
	COFF_SYM_CLASS_SECTION		 	= 104,	// 	Definition of a section (Microsoft tools use STATIC storage class instead).
	COFF_SYM_CLASS_WEAK_EXTERNAL	= 105,	// 	Weak external. See Section 5.5.3, "Auxiliary Format 3: Weak Externals," for more information.
}

// symbol section constants
const int COFF_SYMBOL_UNDEFINED = 0;
const int COFF_SYMBOL_ABSOLUTE 	= -1;
const int COFF_SYMBOL_DEBUG 	= -2;

// coff symbol type MSB - microsoft only uses FUNCTION
enum : byte
{
	COFF_SYM_DTYPE_UNKNOWN	= 0x00,		// No derived type; the symbol is a simple scalar variable.
	COFF_SYM_DTYPE_POINTER	= 0x10,		// Pointer to base type.
	COFF_SYM_DTYPE_FUNCTION = 0x20,		// function
	COFF_SYM_DTYPE_ARRAY	= 0x30		// Array of base type.
}

// COFF symbol type LSB - unused by microsoft tools
enum : byte
{
	COFF_SYM_TYPE_NULL		= 0,		// No type information or unknown base type. Microsoft tools use this setting.
	COFF_SYM_TYPE_VOID		= 1,		// No valid type; used with void pointers and functions.
	COFF_SYM_TYPE_CHAR		= 2,		// Character (signed byte).
	COFF_SYM_TYPE_SHORT		= 3,		// Two-byte signed integer.
	COFF_SYM_TYPE_INT		= 4,		// Natural integer type (normally four bytes in Windows NT).
	COFF_SYM_TYPE_LONG		= 5,		// Four-byte signed integer.
	COFF_SYM_TYPE_FLOAT		= 6,		// Four-byte floating-point number.
	COFF_SYM_TYPE_DOUBLE	= 7,		// Eight-byte floating-point number.
	COFF_SYM_TYPE_STRUCT	= 8,		// Structure.
	COFF_SYM_TYPE_UNION		= 9,		// Union.
	COFF_SYM_TYPE_ENUM		= 10,		// Enumerated type.
	COFF_SYM_TYPE_MOE		= 11,		// Member of enumeration (a specific value).
	COFF_SYM_TYPE_BYTE		= 12,		// Byte; unsigned one-byte integer.
	COFF_SYM_TYPE_WORD		= 13,		// Word; unsigned two-byte integer.
	COFF_SYM_TYPE_UINT		= 14,		// Unsigned integer of natural size (normally, four bytes).
	COFF_SYM_TYPE_DWORD		= 15,		// Unsigned four-byte integer.
}

// coff library import flags
enum
{
	COFF_IMPORT_CODE			= 0,
	COFF_IMPORT_DATA			= 1,
	COFF_IMPORT_CONST			= 2,

	COFF_IMPORT_ORDINAL			= 0,
	COFF_IMPORT_NAME			= 1,
	COFF_IMPORT_NOPREFIX		= 2,
	COFF_IMPORT_NAME_UNDECORATE = 3
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// internal COFF structures
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// COFF object header
align(1) struct COFFHeader
{
	ushort	machine;				// COFF_MACHINE enum
	ushort	NumberOfSections;
	uint	TimeStamp;
	uint	PointerToSymbolTable;
	uint	NumberOfSymbols;
	ushort	SizeOfOptionalHeader;
	ushort	Characteristics;
}

// COFF section header
align(1) struct COFFSectionHeader
{
	char	Name[8];
	uint	VirtualSize;
	uint	VirtualAddress;
	uint	SizeOfRawData;
	uint	PointerToRawData;
	uint	PointerToRelocations;
	uint	PointerToLineNumbers;
	ushort	NumberOfRelocations;
	ushort	NumberOfLineNumbers;
	uint	Characteristics;
}

// relocation record
align(1) struct COFFRelocationRecord
{
	uint	virtualAddress;		// Address of the item to which relocation is applied: this is the offset from the beginning of the section, plus the value of the section's RVA/Offset field (see Section 4, "Section Table."). For example, if the first byte of the section has an address of 0x10, the third byte has an address of 0x12.
	uint	symbolTableIndex;	// A zero-based index into the symbol table. This symbol gives the address to be used for the relocation. If the specified symbol has section storage class, then the symbol's address is the address with the first section of the same name.
	ushort	type;				// A value indicating what kind of relocation should be performed. Valid relocation types depend on machine type. See Section 5.2.1, "Type Indicators."
}

// line number record
align(1) struct COFFLineRecord
{
	union
	{
		uint symbolTableIndex;		// Used when Linenumber is 0: index to symbol table entry for a function. This format is used to indicate the function that a group of line-number records refer to.
		int virtualAddress;			// Used when Linenumber is non-zero: relative virtual address of the executable code that corresponds to the source line indicated. In an object file, this contains the virtual address within the section.
	}
	ushort lineNumber;	// When nonzero, this field specifies a one-based line number. When zero, the Type field is interpreted as a Symbol Table Index for a function.
}

// standard symbol record
align(1) struct COFFSymbolRecord
{
	union
	{
		char[8]	name;				//	Name of the symbol, represented by union of three structures. An array of eight bytes is used if the name is not more than eight bytes long.
		struct
		{
			uint zeros;
			uint offset;
		}
	}
	uint	value;				//	Value associated with the symbol. The interpretation of this field depends on Section Number and Storage Class. A typical meaning is the relocatable address.
	ushort	sectionNumber;		// 	Signed integer identifying the section, using a one-based index into the Section Table. Some values have special meaning defined in "Section Number Values."
	ushort	type;				//	A number representing type. Microsoft tools set this field to 0x20 (function) or 0x0 (not a function). See Section 5.4.3, "Type Representation," for more information.
	byte	storageClass;		//	Enumerated value representing storage class. See Section 5.4.4, "Storage Class," for more information.
	byte	numberOfAuxSymbols;	//	Number of auxiliary symbol table entries that follow this record.
}

// aux symbol records

// function symbol
align(1) struct COFFAuxSymbolFunction
{
	uint	TagIndex;				//	Symbol-table index of the corresponding .bf (begin function) symbol record.
	uint	TotalSize;				//	Size of the executable code for the function itself. If the function is in its own section, the Size of Raw Data in the section header will be greater or equal to this field, depending on alignment considerations.
	uint	PointerToLinenumber;	//	File offset of the first COFF line-number entry for the function, or zero if none exists. See Section 5.3, "COFF Line Numbers," for more information.
	uint	PointerToNextFunction;	//	Symbol-table index of the record for the next function. If the function is the last in the symbol table, this field is set to zero.
	ushort	Unused;
}

align(1) struct COFFAuxSymbolBEFunction
{
	uint	unused0;				//
	ushort	Linenumber;				//	Actual ordinal line number (1, 2, 3, etc.) within source file, corresponding to the .bf or .ef record.
	uint	unused1;				//
	ushort	unused2;				//
	uint	PointerToNextFunction;	//	Symbol-table index of the next .bf symbol record. If the function is the last in the symbol table, this field is set to zero. Not used for .ef records.
	ushort	unused3;				//
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// pefile optional headers
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

align(1) struct PEHeader
{
	ushort	Magic;
	byte	LinkerMajor;
	byte	LinkerMinor;
	uint	SizeOfCode;
	uint	SizeOfInitializedData;
	uint	SizeOfUninitializedData;
	uint	AddressOfEntryPoint;
	uint	BaseOfCode;
	uint	BaseOfData;
}

align(1) struct PEPlusHeader
{
	ushort	Magic;
	byte	LinkerMajor;
	byte	LinkerMinor;
	uint	SizeOfCode;
	uint	SizeOfInitializedData;
	uint	SizeOfUninitializedData;
	uint	AddressOfEntryPoint;
	uint	BaseOfCode;
}

align(1) struct PEWindowsHeader
{
	uint	ImageBase;
	uint	SectionAlignment;
	uint	FileAlignment;
	ushort	OperatingSystemMajor;
	ushort	OperatingSystemMinor;
	ushort	ImageVersionMajor;
	ushort	ImageVersionMinor;
	ushort	SubsystemMajor;
	ushort	SubsystemMinor;
	uint	Reserved;
	uint	SizeOfImage;
	uint	SizeOfHeaders;
	uint	Checksum;
	ushort	Subsystem;
	ushort	DLLCharacteristics;
	uint	SizeOfStackReserve;
	uint	SizeOfStackCommit;
	uint	SizeOfHeapReserve;
	uint	SizeOfHeapCommit;
	uint	LoaderFlags;
	uint	NumberOfRVAAndSizes;
}

align(1) struct PEPlusWindowsHeader
{
	uint	ImageBase[2];
	uint	SectionAlignment;
	uint	FileAlignment;
	ushort	OperatingSystemMajor;
	ushort	OperatingSystemMinor;
	ushort	ImageVersionMajor;
	ushort	ImageVersionMinor;
	ushort	SubsystemMajor;
	ushort	SubsystemMinor;
	uint	Reserved;
	uint	SizeOfImage;
	uint	SizeOfHeaders;
	uint	Checksum;
	ushort	Subsystem;
	ushort	DLLCharacteristics;
	uint	SizeOfStackReserve[2];
	uint	SizeOfStackCommit[2];
	uint	SizeOfHeapReserve[2];
	uint	SizeOfHeapCommit[2];
	uint	LoaderFlags;
	uint	NumberOfRVAAndSizes;
}

align(1) struct PEDataDirectory
{
	uint	RVA;
	uint	Size;
}

align(1) struct PEDataDirectories
{
	PEDataDirectory	Export;
	PEDataDirectory	Import;
	PEDataDirectory	Resource;
	PEDataDirectory	Exception;
	PEDataDirectory	Certificate;
	PEDataDirectory	Base_relocation;
	PEDataDirectory	Debug;
	PEDataDirectory	Architecture;
	PEDataDirectory	GlobalPtr;
	PEDataDirectory	ThreadLocalStorage;
	PEDataDirectory	LoadConfig;
	PEDataDirectory	BoundImport;
	PEDataDirectory	ImportAddress;
	PEDataDirectory	DelayImport;
	PEDataDirectory	COMplus;
	PEDataDirectory	Reserved;
}

align(1) struct COFFExportDirectoryTable
{
	uint	Characteristics;
	uint	TimeStamp;
	ushort	MajorVersion;
	ushort	MiniorVersion;
	uint	NameRVA;
	uint	OrdinalBias;
	uint	NumberOfFunctions;
	uint	NumberOfNames;
	uint	AddressOfFunctions;
	uint	AddressOfNames;
	uint	AddressOfOrdinals;
}

//
// Import
//

align(1) struct t_image_import_descriptor
{
	uint	OriginalFirstThunk;
	uint	TimeStamp;
	uint	ForwarderChain;
	uint	NameRVA;
	uint	FirstThunk;
}

//
// Debug symbol stuff
//

align(1) struct COFFImageDebugDirectory
{
	uint	Characteristics;
	uint	TimeDateStamp;
	ushort	MajorVersion;
	ushort	MinorVersion;
	uint	Type;
	uint	SizeOfData;
	uint	AddressOfRawData;
	uint	PointerToRawData;
}

align(1) struct t_image_coff_symbols
{
    uint   NumberOfSymbols;
    uint   LvaToFirstSymbol;
    uint   NumberOfLinenumbers;
    uint   LvaToFirstLinenumber;
    uint   RvaToFirstByteOfCode;
    uint   RvaToLastByteOfCode;
    uint   RvaToFirstByteOfData;
    uint   RvaToLastByteOfData;
}

//align(1) struct t_image_fpo_data
//{
//    uint       ulOffStart;             // offset 1st byte of function code
//    uint       cbProcSize;             // # bytes in function
//    uint       cdwLocals;              // # bytes in locals/4
//    ushort        cdwParams;              // # bytes in params/4
//    ushort        cbProlog : 8;           // # bytes in prolog
//    ushort        cbRegs   : 3;           // # regs saved
//    ushort        fHasSEH  : 1;           // TRUE if SEH in func
//    ushort        fUseBP   : 1;           // TRUE if EBP has been allocated
//    ushort        reserved : 1;           // reserved for future use
//    ushort        cbFrame  : 2;           // frame type
//}

align(1) struct t_image_debug_misc
{
    uint		DataType;               // type of misc data
    uint		Length;                 // total length of record, rounded to four
                                        // byte multiple.
    byte		Unicode;                // TRUE if data is unicode string
    byte        Reserved[ 3 ];
    //BYTE        Data[ 1 ];			// Actual data (commented out to be read seperately)
}


// library member header
align(1) struct COFFLibraryMemberHeader
{
	char[16]	name;
	char[12]	date;
	char[6]		user;
	char[6]		group;
	char[8]		mode;
	char[10]	size;
	char[2]		endOfHeader;	// always '\n
}

// library import member header
align(1) struct COFFLibraryImportHeader
{
	ushort		sig1;		// COFF_MACHINE_UNKNOWN
	ushort		sig2;		// 0xffff
	ushort		ver;
	ushort		machine;
	uint		timeStamp;
	uint		dataSize;
	ushort		ordinal;
	byte		flags;
	byte		reserved;
}


// copy a static stringz that may not have a null to a char[]
char[] copyStringz( in char[] inStr )
{
	char[] outStr;
	outStr.length = inStr.length + 1; 	// provide extra padding
	memcpy( outStr.ptr, inStr.ptr, inStr.length );
	outStr[$-1] = 0;	// pad
	outStr.length = strlen( outStr.ptr );
	// strip extra spaces
	return strip( outStr );
}

// section info
struct SECTIONINFO
{
    char[]	szSection;
    uint 	uVirtualAddress;
    uint	uSize;
}



///////////////////////////////////////////////////////////////////////////////////////////
// windows api headers
///////////////////////////////////////////////////////////////////////////////////////////

enum : uint { IMAGE_DOS_SIGNATURE		= 0x5a4d }
enum : uint { IMAGE_OS2_SIGNATURE		= 0x454e }
enum : uint { IMAGE_OS2_SIGNATURE_LE	= 0x454c }
enum : uint { IMAGE_VXD_SIGNATURE		= 0x454c }
enum : uint { IMAGE_NT_SIGNATURE		= 0x00004550 }

align(1)
{


const uint IMAGE_SIZEOF_SHORT_NAME = 8;

struct _IMAGE_SECTION_HEADER
{
  	byte Name[IMAGE_SIZEOF_SHORT_NAME];
	union
	{
	  uint PhysicalAddress;
	  uint VirtualSize;
	}

  	uint VirtualAddress;
  	uint SizeOfRawData;
  	uint PointerToRawData;
  	uint PointerToRelocations;
  	uint PointerToLinenumbers;
  	ushort NumberOfRelocations;
  	ushort NumberOfLinenumbers;
  	uint Characteristics;
}

alias _IMAGE_SECTION_HEADER 	IMAGE_SECTION_HEADER;
alias _IMAGE_SECTION_HEADER* 	PIMAGE_SECTION_HEADER;



struct IMAGE_DEBUG_DIRECTORY 
{
  	uint Characteristics;
  	uint TimeDateStamp;
  	ushort MajorVersion;
  	ushort MinorVersion;
  	uint Type;
  	uint SizeOfData;
  	uint AddressOfRawData;
  	uint PointerToRawData;
}
alias IMAGE_DEBUG_DIRECTORY* 	PIMAGE_DEBUG_DIRECTORY;

enum : uint { IMAGE_DEBUG_TYPE_UNKNOWN = 0 }
enum : uint { IMAGE_DEBUG_TYPE_COFF = 1 }
enum : uint { IMAGE_DEBUG_TYPE_CODEVIEW = 2 }
enum : uint { IMAGE_DEBUG_TYPE_FPO = 3 }
enum : uint { IMAGE_DEBUG_TYPE_MISC = 4 }
enum : uint { IMAGE_DEBUG_TYPE_EXCEPTION = 5 }
enum : uint { IMAGE_DEBUG_TYPE_FIXUP = 6 }
enum : uint { IMAGE_DEBUG_TYPE_OMAP_TO_SRC = 7 }
enum : uint { IMAGE_DEBUG_TYPE_OMAP_FROM_SRC = 8 }
enum : uint { IMAGE_DEBUG_TYPE_BORLAND = 9 }
enum : uint { IMAGE_DEBUG_TYPE_RESERVED10 = 10 }
enum : uint { IMAGE_DEBUG_TYPE_CLSID = 11 }

struct _IMAGE_COFF_SYMBOLS_HEADER 
{
  uint NumberOfSymbols;
  uint LvaToFirstSymbol;
  uint NumberOfLinenumbers;
  uint LvaToFirstLinenumber;
  uint RvaToFirstByteOfCode;
  uint RvaToLastByteOfCode;
  uint RvaToFirstByteOfData;
  uint RvaToLastByteOfData;
}
alias _IMAGE_COFF_SYMBOLS_HEADER IMAGE_COFF_SYMBOLS_HEADER;
alias _IMAGE_COFF_SYMBOLS_HEADER* PIMAGE_COFF_SYMBOLS_HEADER;


enum : uint { IMAGE_COMDAT_SELECT_NODUPLICATES = 1 }
enum : uint { IMAGE_COMDAT_SELECT_ANY = 2 }
enum : uint { IMAGE_COMDAT_SELECT_SAME_SIZE = 3 }
enum : uint { IMAGE_COMDAT_SELECT_EXACT_MATCH = 4 }
enum : uint { IMAGE_COMDAT_SELECT_ASSOCIATIVE = 5 }
enum : uint { IMAGE_COMDAT_SELECT_LARGEST = 6 }
enum : uint { IMAGE_COMDAT_SELECT_NEWEST = 7 }

enum : uint { IMAGE_WEAK_EXTERN_SEARCH_NOLIBRARY = 1 }
enum : uint { IMAGE_WEAK_EXTERN_SEARCH_LIBRARY = 2 }
enum : uint { IMAGE_WEAK_EXTERN_SEARCH_ALIAS = 3 }

struct _IMAGE_RELOCATION {
union {
  uint VirtualAddress;
  uint RelocCount;
}

  uint SymbolTableIndex;
  ushort Type;
}
alias _IMAGE_RELOCATION IMAGE_RELOCATION;

alias IMAGE_RELOCATION* PIMAGE_RELOCATION;

enum : uint { IMAGE_SIZEOF_RELOCATION = 10 }

const uint IMAGE_REL_I386_ABSOLUTE	= 0x0000;	// This relocation is ignored.
const uint IMAGE_REL_I386_DIR16		= 0x0001;	// Not supported.
const uint IMAGE_REL_I386_REL16		= 0x0002;	// Not supported.
const uint IMAGE_REL_I386_DIR32		= 0x0006;	// The targets 32-bit virtual address.
const uint IMAGE_REL_I386_DIR32NB	= 0x0007;	// The targets 32-bit relative virtual address.
const uint IMAGE_REL_I386_SEG12		= 0x0009;	// Not supported.
const uint IMAGE_REL_I386_SECTION	= 0x000a;	// The 16-bit-section index of the section containing the target. This is used to support debugging information.
const uint IMAGE_REL_I386_SECREL	= 0x000b;	// The 32-bit offset of the target from the beginning of its section. This is used to support debugging information as well as static thread local storage.
const uint IMAGE_REL_I386_REL32		= 0x0014;	// The 32-bit relative displacement to the target. This supports the x86 relative branch and call instructions.

}

