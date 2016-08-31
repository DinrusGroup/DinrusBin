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
	CodeView debug information v4 API

	Authors: J Duncan, Eric Anderton
	License: BSD Derivative (see source for details)
	Copyright: 2005, 2006 J Duncan, Eric Anderton
*/

module ddl.coff.cv4;

private import ddl.coff.COFF;

private import std.string;
private import os.windows;

// win32 api missing from phobos
extern(Windows) void SetLastError(DWORD);
const int ERROR_INVALID_ADDRESS = 487;
const int ERROR_INSUFFICIENT_BUFFER = 122;

const uint WIN32_IMAGE_SCN_MEM_EXECUTE = 0x20000000;	// changed from IMAGE_SCN_MEM_EXECUTE due to conflicts

/*
enum : uint { IMAGE_SIZEOF_SHORT_NAME = 8 }

align(1) struct IMAGE_SECTION_HEADER 
{
	BYTE Name[IMAGE_SIZEOF_SHORT_NAME];
	union 
	{
		DWORD PhysicalAddress;
		DWORD VirtualSize;
	}

	DWORD VirtualAddress;
	DWORD SizeOfRawData;
	DWORD PointerToRawData;
	DWORD PointerToRelocations;
	DWORD PointerToLinenumbers;
	WORD NumberOfRelocations;
	WORD NumberOfLinenumbers;
	DWORD Characteristics;
}

alias IMAGE_SECTION_HEADER*	PIMAGE_SECTION_HEADER;

enum : uint { IMAGE_SIZEOF_SECTION_HEADER = 40 }
*/
// codeview signature constants
const uint CODEVIEW_SIG_NB09 = cast(uint)( 'N' | ('B' << 8) | ('0' << 16) | ('9' << 24) );
const uint CODEVIEW_SIG_NB10 = cast(uint)( 'N' | ('B' << 8) | ('1' << 16) | ('0' << 24) );
const uint CODEVIEW_SIG_NB11 = cast(uint)( 'N' | ('B' << 8) | ('1' << 16) | ('1' << 24) );


// find source module
BOOL LocateSrcModule( LPVOID pCV4DebugData, DWORD dwAddress,DWORD *pLineNumber, out char[] fileName)
{
	char *ptr;
	PCV4DirectoryHeader pHeader;
	PCV4DirectoryEntry  pEntry;
	WORD i;
	ptr = cast(char*) pCV4DebugData;
	ptr = ptr + *cast(DWORD *)(ptr + DWORD.sizeof);        /* CV4 Directory header. */
	pHeader = cast(PCV4DirectoryHeader)ptr;

	if( pHeader.cbDirHeader != (*pHeader).sizeof )
	{
		.SetLastError(ERROR_INVALID_ADDRESS);
		return false;
	}

	pEntry = cast(PCV4DirectoryEntry) (ptr + pHeader.cbDirHeader);        /* Search CV4 directory entries. */

	for (i = 0; i < pHeader.cDir; i++, pEntry++)
	{
		// Locate sstSrcModule data block ( 0x0127 ) .
		switch( pEntry.subsection )
		{
			case 0x0127:
				if( GetSrcModuleInfo(cast(char *)pCV4DebugData + pEntry.Ifo,dwAddress, pLineNumber, fileName))
				{
					if (GetLastError() == ERROR_INSUFFICIENT_BUFFER)
						return false;
					return true;
				}
				break;
			default:
				break;
		}
	}

	.SetLastError(ERROR_INVALID_ADDRESS);
	return false;
}

BOOL GetSrcModuleInfo( LPSTR ptr, DWORD dwAddress, DWORD *pLineNumber, out char[] fileName )
{
	WORD    i, j, cFile, cSegInMod;
	char    *pModule;
	DWORD   fileTableOffset;
	char    *baseSrcFile;
	char    *mapTable;

	SetLastError(0);

	//*pFileName = 0;
	*pLineNumber = 0;
	pModule = ptr;        		
	// Number of source files in a module.
	cFile = *cast(WORD*)ptr;
	ptr += WORD.sizeof;        	// Total number of code segments in a module.
	cSegInMod = *cast(WORD*)ptr;
	ptr += WORD.sizeof;

	// loop through source files
	for( i = 0; i < cFile; i++ )
	{

		WORD    cSegInFile;
		DWORD   mapTableOffset;
		char* 	pFilePtr;
		WORD    fileNameLen;
		fileTableOffset = *cast(DWORD*)(ptr + i * DWORD.sizeof);
		baseSrcFile 	= pModule + fileTableOffset;            // Number of code segments in a source file.
		cSegInFile 		= *cast(WORD*)baseSrcFile;
		baseSrcFile 	+= (WORD.sizeof + WORD.sizeof);

		for (j = 0; j < cSegInFile; j++)
		{
			mapTableOffset 	= *cast(DWORD*)(baseSrcFile + j * DWORD.sizeof);
			mapTable 		= pModule + mapTableOffset;

			{
				WORD segIndex, nPairs, low, middle, high;
				segIndex 	= *cast(WORD*)mapTable;
				mapTable 	+= WORD.sizeof;
				nPairs 		= *cast(WORD*)mapTable;
				mapTable 	+= WORD.sizeof;                    // Analyze line/address mapping table.
				low = 0;
				high = nPairs - 1;

				while( high >= low )
				{
					DWORD offset, nextOffset;
					middle = (low + high) / 2;
					offset = *cast(DWORD*)(mapTable + middle * DWORD.sizeof);

					if (dwAddress < offset)
					{
						if (middle < 1)
							break;
						high = middle - 1;
						continue;
					}

					if (middle < (nPairs - 1))
					{
						nextOffset = *cast(DWORD*)(mapTable+ (middle+1) * DWORD.sizeof);
						if (dwAddress >= nextOffset)
						{
							low = middle + 1;
							if ((dwAddress > nextOffset) && (low == (nPairs - 1)))
								break;
							continue;
						}
					}

					// grab file & line
					*pLineNumber	= *cast(WORD*)(mapTable + nPairs * DWORD.sizeof + middle * WORD.sizeof);
					fileNameLen 	= *cast(char*)(baseSrcFile + cSegInFile * 3 * DWORD.sizeof);
					pFilePtr 		=  cast(char*)(baseSrcFile + cSegInFile * 3 * DWORD.sizeof + char.sizeof );
					// copy filename into string array
					if( (fileName.length = fileNameLen) != 0 )
						memcpy( fileName.ptr, pFilePtr, fileName.length );
					return true;
				}
			}
		}
	}
	return false;
}

align(1)
{



	struct CV4SourceFile
	{
		uint numSegments;
		uint a;
	}

}

alias CV4DirectoryHeader*	PCV4DirectoryHeader;
alias CV4DirectoryEntry* 	PCV4DirectoryEntry;

struct SourceModule
{
	char[]		name;
	char[]		fileName;
	uint		numSegments;
}


//  subsection type constants
enum
{
    sstModule		= 0x120,		// Basic info. about object module
    sstTypes		= 0x121,
    sstPublic		= 0x122,		// Public symbols
    sstPublicSym	= 0x123,
    sstSymbols		= 0x124,		// Symbol Data
    sstAlignSym		= 0x125,		// module symbols
    sstSrcLnSeg		= 0x126,		// Same as source lines, contains segment
    sstSrcModule	= 0x127,		// Source line information
    sstLibraries	= 0x128,		// Names of all library files used
    sstGlobalSym	= 0x129,		// global symbols
    sstGlobalPub	= 0x12a,		// global publics
    sstGlobalTypes	= 0x12b,		// Type information
    sstMPC			= 0x12c,
    sstSegMap		= 0x12d,
    sstSegName		= 0x12e,
    sstPreComp		= 0x12f,
    sstPreCompMap	= 0x130,
    sstOffsetMap16	= 0x131,
    sstOffsetMap32	= 0x132,		// Symbols for DLL fixups
    sstFileIndex	= 0x133,
    sstStaticSym	= 0x134
}

//Symbol indices are broken into five ranges:
//	The first range is for symbols whose format does not change with the compilation model of the program or the target machine.
//		These include register symbols, user-defined type symbols, and so on.
//	The second range of symbols are those that contain 16:16 segmented addresses.
//	The third symbol range is for symbols that contain 16:32 addresses.
//		Note that for flat model programs, the segment is replaced with the section number for PE format .exe files.
//	The fourth symbol range is for symbols that are specific to the MIPS architecture/compiler.
//	The fifth range is for Microsoft CodeView optimization.

//	Symbol type identifiers (ripped from MSDN)
enum
{
// basic symbols
	S_COMPILE		= 0x0001,	// compile flags
	S_REGISTER		= 0x0002,	// register var
	S_CONSTANT		= 0x0003,	// constant
	S_UDT			= 0x0004,	// user data types

	S_SSEARCH		= 0x0005,	// start search
	S_END			= 0x0006,	// end block procedure with or thunk
	S_SKIP			= 0x0007,	// skip - reserve symbol space
	S_CVRESERVE		= 0x0008,	// internal use
	S_OBJNAME		= 0x0009,	// name of object file
	S_ENDARG		= 0x000a,	// end of arguments in function
	S_COBOLUDT		= 0x000b,	// COBOL udt
	S_MANYREG		= 0x000c,	// many register symbol
	S_RETURN		= 0x000d,	// function return description
	S_ENTRYTHIS		= 0x000e,	// description of this pointer at entry

//	S_COBOLUDT2		= 0x0010,
//	S_MANYREG2		= 0x0011,

// 16:32 types
	S_BPREL32		= 0x0200,	// BP
	
	S_LDATA32		= 0x0201,	// local data
	S_GDATA32		= 0x0202,	// global data
	S_PUB32			= 0x0203,	// public symbol

	S_LPROC32		= 0x0204,	// local procedure
	S_GPROC32		= 0x0205,	// global procedure
	S_THUNK32		= 0x0206,	// thunk start
	S_BLOCK32		= 0x0207,	// block start
	S_WITH32		= 0x0208,	//
	S_LABEL32		= 0x0209,	//
	S_CEXMODEL32	= 0x020a,	//
	S_VFTTABLE32	= 0x020b,	// virtual function table
	S_REGREL32		= 0x020c,	// register
	S_LTHREAD32		= 0x020d,	// local thread storage data
	S_GTHREAD32		= 0x020e,	// global thread storage data

// MIPS types
	S_LPROCMIPS		= 0x0300,	// Local procedure start MIPS
	S_GPROCMIPS		= 0x0301,	// global procedure start MIPS

// codeview optimized types
	S_PROCREF		= 0x0400,	// reference to a procedure
	S_DATAREF		= 0x0401,	// reference to data
	S_ALIGN			= 0x0402,	// page align symbol

	S_FIRST			= S_COMPILE,
	S_LAST			= S_ALIGN
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// codeview data structures
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

align(1) struct CodeViewSignature
{
	uint	Signature;
	uint	Filepos;
}

align(1) struct CodeViewExternal
{
	uint	TimeStamp;
	uint	Unknown;
}

// codeview data header
align(1) struct CodeViewHeader
{
	ushort	HeaderSize;
	ushort	EntrySize;
	uint	NumberOfEntries;
	uint	NextDirectoryOffset;
	uint	Flags;
}

align(1) struct CV4DirectoryHeader
{
	WORD    cbDirHeader;
	WORD    cbDirEntry;
	DWORD   cDir;
	DWORD   IfoNextDir;
	DWORD   flags;
}

// codeview data directory subsection
align(1) struct CVSubSection
{
	ushort	SubsectionType;		//	Subsection type (sst...)
	ushort	iMod;				//	Module index
	uint	FileOffset;			//	Large file offset of subsection
	uint	Size;				//	Number of bytes in subsection

}

align(1) struct CV4DirectoryEntry
{
	WORD    subsection;
	WORD    iMod;
	DWORD   Ifo;
	DWORD   cb;
}

// subsection structs

// sstModule - module info header
align(1) struct CVModuleEntry
{
	ushort	overlay;
	ushort	library;
	ushort	segmentCount;
	ushort	style;
}

// sstModule - segment info
align(1) struct CVSegInfo
{
	ushort	segment;
	ushort	pad;
	uint	offset;
	uint	size;
}

// sstSrcModule - info about source files
align(1) struct CVSrcModule
{
	ushort	numFiles;					//	Number of source files contained in this module
	ushort	numSegs;					//	Number of base segments in this module
}

// source file entry
/*
align(1) struct CV4SourceEntry
{
	uint 	fileCount;
	uint 	codeSegments;
	uint*	fileTable;
}
*/


////////////////////////////////////////////////////////////////////////////////////////////////////////////

// S_PROCREF - procedure reference in global $$SYMBOL tables
align(1) struct CVSymProcRef
{
	uint	checksum;		// checksum Checksum of the referenced symbol name. The checksum used is the one specified in the header of the sstGlobalSym or sstStaticSym subsections.
	uint	symOffset;		// offset Offset of the procedure symbol record from the beginning of the $$SYMBOL table for the module.
	ushort	moduleIndex;	// module Index of the module that contains this procedure record.
}

// S_LDATA32 and S_GDATA32 - local and global data symbol
align(1) struct CVSymbolData
{
	uint	offset;						//	Offset of the symbol
	ushort	segment;					//	Symbol segment
	ushort	type;						//	symbol type
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////

align(1) struct CVSymTableHeader
{
	ushort	symHashFnc;					//	Symbol hash function (must be 12)
	ushort	addrHashFnc;				//	Address hash function (must be 10)
	uint	numSymBytes;				//	Number of bytes in the upcoming $$SYMBOL table
	uint	numSymHashBytes;			//	Number of bytes in the symbol hash table
	uint	numAddrHashBytes;			//	Number of bytes in the address hash table
}

// variable names in the $$SYMBOL table (S_LDATA32 and S_GDATA32)
align(1) struct CVSymData
{
	uint	m_TypeID;						//	Type identifier for the symbol
	uint	m_Offset;						//	Offset of the symbol
	ushort	m_Segment;						//	Symbol segment
	ubyte	m_NameLen;						//	Length of the symbol name
	char	m_Name[512];					//	Symbol name (not really 512 characters, but I only
											//	ever use this structure to reinterpret the data
											//	pointer, never as a stack or heap object)

}

//CVSymProcStart - proc start in a $$SYMBOL table (S_LPROC32 and S_GPROC32)
align(1) struct CVSymProcStart
{
	uint	m_Parent;						//
	uint	m_End;
	uint	m_Next;
	uint	m_ProcLength;
	uint	m_DbgStart;
	uint	m_DbgEnd;
	uint	m_Offset;
	ushort	m_Section;
	ushort	m_ProcType;
	ubyte	m_Flags;
//	ubyte	m_NameLen;
//	char	m_Name[512];
}


//CVAddrHashOffset - used in the address sort table in global symbol tables
align(1) struct CVAddrHashOffset
{
	uint	curSymOffset;
	uint	curMemOffset;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CodeView Predefined Primitive Types
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Special Types
const uint T_NOTYPE 	= 0x0000;	// Uncharacterized type (no type)
const uint T_ABS 		= 0x0001;	// Absolute symbol
const uint T_SEGMENT 	= 0x0002;	// Segment type
const uint T_VOID 		= 0x0003;	// Void
const uint T_PVOID 		= 0x0103;	// Near pointer to void
const uint T_PFVOID 	= 0x0203;	// Far pointer to void
const uint T_PHVOID 	= 0x0303;	// Huge pointer to void
const uint T_32PVOID 	= 0x0403;	// 32-bit near pointer to void
const uint T_32PFVOID 	= 0x0503;	// 32-bit far pointer to void
const uint T_CURRENCY 	= 0x0004;	// Basic 8-byte currency value
const uint T_NBASICSTR 	= 0x0005;	// Near Basic string
const uint T_FBASICSTR 	= 0x0006;	// Far Basic string
const uint T_NOTTRANS 	= 0x0007;	// Untranslated type record from Microsoft symbol format
const uint T_BIT 		= 0x0060;	// Bit
const uint T_PASCHAR 	= 0x0061;	// Pascal CHAR

// Character Types
const uint T_CHAR 		= 0x0010;	// 8-bit signed
const uint T_UCHAR 		= 0x0020;	// 8-bit unsigned
const uint T_PCHAR 		= 0x0110;	// Near pointer to 8-bit signed
const uint T_PUCHAR 	= 0x0120;	// Near pointer to 8-bit unsigned
const uint T_PFCHAR 	= 0x0210;	// Far pointer to 8-bit signed
const uint T_PFUCHAR 	= 0x0220;	// Far pointer to 8-bit unsigned
const uint T_PHCHAR 	= 0x0310;	// Huge pointer to 8-bit signed
const uint T_PHUCHAR 	= 0x0320;	// Huge pointer to 8-bit unsigned
const uint T_32PCHAR 	= 0x0410;	// 16:32 near pointer to 8-bit signed
const uint T_32PUCHAR 	= 0x0420;	// 16:32 near pointer to 8-bit unsigned
const uint T_32PFCHAR 	= 0x0510;	// 16:32 far pointer to 8-bit signed
const uint T_32PFUCHAR 	= 0x0520;	// 16:32 far pointer to 8-bit unsigned

//Real Character Types
const uint T_RCHAR 		= 0x0070;	// Real char
const uint T_PRCHAR 	= 0x0170;	// Near pointer to a real char
const uint T_PFRCHAR 	= 0x0270;	// Far pointer to a real char
const uint T_PHRCHAR 	= 0x0370;	// Huge pointer to a real char
const uint T_32PRCHAR 	= 0x0470;	// 16:32 near pointer to a real char
const uint T_32PFRCHAR 	= 0x0570;	// 16:32 far pointer to a real char

// Wide Character Types
const uint T_WCHAR 		= 0x0071;	// Wide char
const uint T_PWCHAR 	= 0x0171;	// Near pointer to a wide char
const uint T_PFWCHAR 	= 0x0271;	// Far pointer to a wide char
const uint T_PHWCHAR 	= 0x0371;	// Huge pointer to a wide char
const uint T_32PWCHAR 	= 0x0471;	// 16:32 near pointer to a wide char
const uint T_32PFWCHAR 	= 0x0571;	// 16:32 far pointer to a wide char

// Real 16-bit Integer Types
const uint T_INT2 		= 0x0072;	// Real 16-bit signed int
const uint T_UINT2 		= 0x0073;	// Real 16-bit unsigned int
const uint T_PINT2 		= 0x0172;	// Near pointer to 16-bit signed int
const uint T_PUINT2 	= 0x0173;	// Near pointer to 16-bit unsigned int
const uint T_PFINT2 	= 0x0272;	// Far pointer to 16-bit signed int
const uint T_PFUINT2 	= 0x0273;	// Far pointer to 16-bit unsigned int
const uint T_PHINT2 	= 0x0372;	// Huge pointer to 16-bit signed int
const uint T_PHUINT2 	= 0x0373;	// Huge pointer to 16-bit unsigned int
const uint T_32PINT2 	= 0x0472;	// 16:32 near pointer to 16-bit signed int
const uint T_32PUINT2 	= 0x0473;	// 16:32 near pointer to 16-bit unsigned int
const uint T_32PFINT2 	= 0x0572;	// 16:32 far pointer to 16-bit signed int
const uint T_32PFUINT2 	= 0x0573;	// 16:32 far pointer to 16-bit unsigned int

// 16-bit Short Types
const uint T_SHORT 		= 0x0011;	// 16-bit signed
const uint T_USHORT 	= 0x0021;	// 16-bit unsigned
const uint T_PSHORT 	= 0x0111;	// Near pointer to 16-bit signed
const uint T_PUSHORT 	= 0x0121;	// Near pointer to 16-bit unsigned
const uint T_PFSHORT 	= 0x0211;	// Far pointer to 16-bit signed
const uint T_PFUSHORT 	= 0x0221;	// Far pointer to 16-bit unsigned
const uint T_PHSHORT 	= 0x0311;	// Huge pointer to 16-bit signed
const uint T_PHUSHORT 	= 0x0321;	// Huge pointer to 16-bit unsigned
const uint T_32PSHORT 	= 0x0411;	// 16:32 near pointer to 16-bit signed
const uint T_32PUSHORT 	= 0x0421;	// 16:32 near pointer to 16-bit unsigned
const uint T_32PFSHORT 	= 0x0511;	// 16:32 far pointer to 16-bit signed
const uint T_32PFUSHORT = 0x0521;	// 16:32 far pointer to 16-bit unsigned

// Real 32-bit Integer Types
const uint T_INT4 		= 0x0074;	// Real 32-bit signed int
const uint T_UINT4 		= 0x0075;	// Real 32-bit unsigned int
const uint T_PINT4 		= 0x0174;	// Near pointer to 32-bit signed int
const uint T_PUINT4 	= 0x0175;	// Near pointer to 32-bit unsigned int
const uint T_PFINT4 	= 0x0274;	// Far pointer to 32-bit signed int
const uint T_PFUINT4 	= 0x0275;	// Far pointer to 32-bit unsigned int
const uint T_PHINT4 	= 0x0374;	// Huge pointer to 32-bit signed int
const uint T_PHUINT4 	= 0x0375;	// Huge pointer to 32-bit unsigned int
const uint T_32PINT4 	= 0x0474;	// 16:32 near pointer to 32-bit signed int
const uint T_32PUINT4 	= 0x0475;	// 16:32 near pointer to 32-bit unsigned int
const uint T_32PFINT4 	= 0x0574;	// 16:32 far pointer to 32-bit signed int
const uint T_32PFUINT4 	= 0x0575;	// 16:32 far pointer to 32-bit unsigned int

// 32-bit Long Types
const uint T_LONG 		= 0x0012;	// 32-bit signed
const uint T_ULONG 		= 0x0022;	// 32-bit unsigned
const uint T_PLONG 		= 0x0112;	// Near pointer to 32-bit signed
const uint T_PULONG 	= 0x0122;	// Near pointer to 32-bit unsigned
const uint T_PFLONG 	= 0x0212;	// Far pointer to 32-bit signed
const uint T_PFULONG 	= 0x0222;	// Far pointer to 32-bit unsigned
const uint T_PHLONG 	= 0x0312;	// Huge pointer to 32-bit signed
const uint T_PHULONG 	= 0x0322;	// Huge pointer to 32-bit unsigned
const uint T_32PLONG 	= 0x0412;	// 16:32 near pointer to 32-bit signed
const uint T_32PULONG 	= 0x0422;	// 16:32 near pointer to 32-bit unsigned
const uint T_32PFLONG 	= 0x0512;	// 16:32 far pointer to 32-bit signed
const uint T_32PFULONG 	= 0x0522;	// 16:32 far pointer to 32-bit unsigned

// Real 64-bit int Types
const uint T_INT8 		= 0x0076;	// 64-bit signed int
const uint T_UINT8 		= 0x0077;	// 64-bit unsigned int
const uint T_PINT8 		= 0x0176;	// Near pointer to 64-bit signed int
const uint T_PUINT8 	= 0x0177;	// Near pointer to 64-bit unsigned int
const uint T_PFINT8 	= 0x0276;	// Far pointer to 64-bit signed int
const uint T_PFUINT8 	= 0x0277;	// Far pointer to 64-bit unsigned int
const uint T_PHINT8 	= 0x0376;	// Huge pointer to 64-bit signed int
const uint T_PHUINT8 	= 0x0377;	// Huge pointer to 64-bit unsigned int
const uint T_32PINT8 	= 0x0476;	// 16:32 near pointer to 64-bit signed int
const uint T_32PUINT8 	= 0x0477;	// 16:32 near pointer to 64-bit unsigned int
const uint T_32PFINT8 	= 0x0576;	// 16:32 far pointer to 64-bit signed int
const uint T_32PFUINT8 	= 0x0577;	// 16:32 far pointer to 64-bit unsigned int

//64-bit Integral Types
const uint T_QUAD 		= 0x0013;	// 64-bit signed
const uint T_UQUAD 		= 0x0023;	// 64-bit unsigned
const uint T_PQUAD 		= 0x0113;	// Near pointer to 64-bit signed
const uint T_PUQUAD 	= 0x0123;	// Near pointer to 64-bit unsigned
const uint T_PFQUAD 	= 0x0213;	// Far pointer to 64-bit signed
const uint T_PFUQUAD 	= 0x0223;	// Far pointer to 64-bit unsigned
const uint T_PHQUAD 	= 0x0313;	// Huge pointer to 64-bit signed
const uint T_PHUQUAD 	= 0x0323;	// Huge pointer to 64-bit unsigned
const uint T_32PQUAD 	= 0x0413;	// 16:32 near pointer to 64-bit signed
const uint T_32PUQUAD 	= 0x0423;	// 16:32 near pointer to 64-bit unsigned
const uint T_32PFQUAD 	= 0x0513;	// 16:32 far pointer to 64-bit signed
const uint T_32PFUQUAD 	= 0x0523;	// 16:32 far pointer to 64-bit unsigned

//32-bit Real Types

const uint T_REAL32 	= 0x0040;	// 32-bit real
const uint T_PREAL32 	= 0x0140;	// Near pointer to 32-bit real
const uint T_PFREAL32 	= 0x0240;	// Far pointer to 32-bit real
const uint T_PHREAL32 	= 0x0340;	// Huge pointer to 32-bit real
const uint T_32PREAL32 	= 0x0440;	// 16:32 near pointer to 32-bit real
const uint T_32PFREAL32 = 0x0540;	// 16:32 far pointer to 32-bit real

// 48-bit Real Types
const uint T_REAL48 	= 0x0044;	// 48-bit real
const uint T_PREAL48 	= 0x0144;	// Near pointer to 48-bit real
const uint T_PFREAL48 	= 0x0244;	// Far pointer to 48-bit real
const uint T_PHREAL48 	= 0x0344;	// Huge pointer to 48-bit real
const uint T_32PREAL48 	= 0x0444;	// 16:32 near pointer to 48-bit real
const uint T_32PFREAL48 = 0x0544;	// 16:32 far pointer to 48-bit real

// 64-bit Real Types
const uint T_REAL64 	= 0x0041;	// 64-bit real
const uint T_PREAL64 	= 0x0141;	// Near pointer to 64-bit real
const uint T_PFREAL64 	= 0x0241;	// Far pointer to 64-bit real
const uint T_PHREAL64 	= 0x0341;	// Huge pointer to 64-bit real
const uint T_32PREAL64 	= 0x0441;	// 16:32 near pointer to 64-bit real
const uint T_32PFREAL64 = 0x0541;	// 16:32 far pointer to 64-bit real

// 80-bit Real Types
const uint T_REAL80 	= 0x0042;	// 80-bit real
const uint T_PREAL80 	= 0x0142;	// Near pointer to 80-bit real
const uint T_PFREAL80 	= 0x0242;	// Far pointer to 80-bit real
const uint T_PHREAL80 	= 0x0342;	// Huge pointer to 80-bit real
const uint T_32PREAL80 	= 0x0442;	// 16:32 near pointer to 80-bit real
const uint T_32PFREAL80 = 0x0542;	// 16:32 far pointer to 80-bit real

// 128-bit Real Types
const uint T_REAL128 	= 0x0043;	// 128-bit real
const uint T_PREAL128 	= 0x0143;	// Near pointer to 128-bit real
const uint T_PFREAL128 	= 0x0243;	// Far pointer to 128-bit real
const uint T_PHREAL128 	= 0x0343;	// Huge pointer to 128-bit real
const uint T_32PREAL128 = 0x0443;	// 16:32 near pointer to 128-bit real
const uint T_32PFREAL128 = 0x0543;	// 16:32 far pointer to 128-bit real

// 32-bit Complex Types
const uint T_CPLX32 	= 0x0050;	// 32-bit complex
const uint T_PCPLX32 	= 0x0150;	// Near pointer to 32-bit complex
const uint T_PFCPLX32 	= 0x0250;	// Far pointer to 32-bit complex
const uint T_PHCPLX32 	= 0x0350;	// Huge pointer to 32-bit complex
const uint T_32PCPLX32 	= 0x0450 ;	//16:32 near pointer to 32-bit complex
const uint T_32PFCPLX32 = 0x0550;	// 16:32 far pointer to 32-bit complex

// 64-bit Complex Types
const uint T_CPLX64 	= 0x0051;	// 64-bit complex
const uint T_PCPLX64 	= 0x0151;	// Near pointer to 64-bit complex
const uint T_PFCPLX64	= 0x0251;	// Far pointer to 64-bit complex
const uint T_PHCPLX64 	= 0x0351;	// Huge pointer to 64-bit complex
const uint T_32PCPLX64 	= 0x0451;	// 16:32 near pointer to 64-bit complex
const uint T_32PFCPLX64 = 0x0551;	// 16:32 far pointer to 64-bit complex

// 80-bit Complex Types
const uint T_CPLX80 	= 0x0052;	// 80-bit complex
const uint T_PCPLX80 	= 0x0152;	// Near pointer to 80-bit complex
const uint T_PFCPLX80 	= 0x0252;	// Far pointer to 80-bit complex
const uint T_PHCPLX80 	= 0x0352;	// Huge pointer to 80-bit complex
const uint T_32PCPLX80 	= 0x0452;	// 16:32 near pointer to 80-bit complex
const uint T_32PFCPLX80 = 0x0552;	// 16:32 far pointer to 80-bit complex


// 128-bit Complex Types
const uint T_CPLX128 	= 0x0053;	// 128-bit complex
const uint T_PCPLX128 	= 0x0153;	// Near pointer to 128-bit complex
const uint T_PFCPLX128 	= 0x0253;	// Far pointer to 128-bit complex
const uint T_PHCPLX128 	= 0x0353;	// Huge pointer to 128-bit real
const uint T_32PCPLX128 = 0x0453;	// 16:32 near pointer to 128-bit complex
const uint T_32PFCPLX128 = 0x0553;	// 16:32 far pointer to 128-bit complex

//Boolean Types
const uint T_BOOL08 	= 0x0030;	// 8-bit Boolean
const uint T_BOOL16 	= 0x0031;	// 16-bit Boolean
const uint T_BOOL32 	= 0x0032;	// 32-bit Boolean
const uint T_BOOL64 	= 0x0033;	// 64-bit Boolean
const uint T_PBOOL08 	= 0x0130;	// Near pointer to 8-bit Boolean
const uint T_PBOOL16 	= 0x0131;	// Near pointer to 16-bit Boolean
const uint T_PBOOL32 	= 0x0132;	// Near pointer to 32-bit Boolean
const uint T_PBOOL64 	= 0x0133;	// Near pointer to 64-bit Boolean
const uint T_PFBOOL08 	= 0x0230;	// Far pointer to 8-bit Boolean
const uint T_PFBOOL16 	= 0x0231;	// Far pointer to 16-bit Boolean
const uint T_PFBOOL32 	= 0x0232;	// Far pointer to 32-bit Boolean
const uint T_PFBOOL64 	= 0x0233;	// Far pointer to 64-bit Boolean
const uint T_PHBOOL08 	= 0x0330;	// Huge pointer to 8-bit Boolean
const uint T_PHBOOL16 	= 0x0331;	// Huge pointer to 16-bit Boolean
const uint T_PHBOOL32 	= 0x0332;	// Huge pointer to 32-bit Boolean
const uint T_PHBOOL64 	= 0x0333;	// Huge pointer to 64-bit Boolean
const uint T_32PBOOL08 	= 0x0430;	// 16:32 near pointer to 8-bit Boolean
const uint T_32PBOOL16 	= 0x0431;	// 16:32 near pointer to 16-bit Boolean
const uint T_32PBOOL32 	= 0x0432;	// 16:32 near pointer to 32-bit Boolean
const uint T_32PBOOL64 	= 0x0433;	// 16:32 near pointer to 64-bit Boolean
const uint T_32PFBOOL08 = 0x0530;	// 16:32 far pointer to 8-bit Boolean
const uint T_32PFBOOL16 = 0x0531;	// 16:32 far pointer to 16-bit Boolean
const uint T_32PFBOOL32 = 0x0532;	// 16:32 far pointer to 32-bit Boolean
const uint T_32PFBOOL64 = 0x0533;	// 16:32 far pointer to 64-bit Boolean

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// codeview type
////////////////////////////////////////////////////////////////////////////////////////////////////////////

struct CVGlobalTypesTable
{
	uint 	flags;
	uint 	numTypes; 		// number of types
//	uint*	offset; 		// array of offsets to types
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////
// leaf constants
////////////////////////////////////////////////////////////////////////////////////////////////////////////

const uint LF_MODIFIER_V1          = 0x0001;
const uint LF_POINTER_V1           = 0x0002;
const uint LF_ARRAY_V1             = 0x0003;
const uint LF_CLASS_V1             = 0x0004;
const uint LF_STRUCTURE_V1         = 0x0005;
const uint LF_UNION_V1             = 0x0006;
const uint LF_ENUM_V1              = 0x0007;
const uint LF_PROCEDURE_V1         = 0x0008;
const uint LF_MFUNCTION_V1         = 0x0009;
const uint LF_VTSHAPE_V1           = 0x000a;
const uint LF_COBOL0_V1            = 0x000b;
const uint LF_COBOL1_V1            = 0x000c;
const uint LF_BARRAY_V1            = 0x000d;
const uint LF_LABEL_V1             = 0x000e;
const uint LF_NULL_V1              = 0x000f;
const uint LF_NOTTRAN_V1           = 0x0010;
const uint LF_DIMARRAY_V1          = 0x0011;
const uint LF_VFTPATH_V1           = 0x0012;
const uint LF_PRECOMP_V1           = 0x0013;
const uint LF_ENDPRECOMP_V1        = 0x0014;
const uint LF_OEM_V1               = 0x0015;
const uint LF_TYPESERVER_V1        = 0x0016;

// variants with new 32-bit type indices (V2)
const uint LF_MODIFIER_V2          = 0x1001;
const uint LF_POINTER_V2           = 0x1002;
const uint LF_ARRAY_V2             = 0x1003;
const uint LF_CLASS_V2             = 0x1004;
const uint LF_STRUCTURE_V2         = 0x1005;
const uint LF_UNION_V2             = 0x1006;
const uint LF_ENUM_V2              = 0x1007;
const uint LF_PROCEDURE_V2         = 0x1008;
const uint LF_MFUNCTION_V2         = 0x1009;
const uint LF_COBOL0_V2            = 0x100a;
const uint LF_BARRAY_V2            = 0x100b;
const uint LF_DIMARRAY_V2          = 0x100c;
const uint LF_VFTPATH_V2           = 0x100d;
const uint LF_PRECOMP_V2           = 0x100e;
const uint LF_OEM_V2               = 0x100f;

const uint LF_SKIP_V1              = 0x0200;
const uint LF_ARGLIST_V1           = 0x0201;
const uint LF_DEFARG_V1            = 0x0202;
const uint LF_LIST_V1              = 0x0203;
const uint LF_FIELDLIST_V1         = 0x0204;
const uint LF_DERIVED_V1           = 0x0205;
const uint LF_BITFIELD_V1          = 0x0206;
const uint LF_METHODLIST_V1        = 0x0207;
const uint LF_DIMCONU_V1           = 0x0208;
const uint LF_DIMCONLU_V1          = 0x0209;
const uint LF_DIMVARU_V1           = 0x020a;
const uint LF_DIMVARLU_V1          = 0x020b;
const uint LF_REFSYM_V1            = 0x020c;

// variants with new 32-bit type indices (V2)
const uint LF_SKIP_V2              = 0x1200;
const uint LF_ARGLIST_V2           = 0x1201;
const uint LF_DEFARG_V2            = 0x1202;
const uint LF_FIELDLIST_V2         = 0x1203;
const uint LF_DERIVED_V2           = 0x1204;
const uint LF_BITFIELD_V2          = 0x1205;
const uint LF_METHODLIST_V2        = 0x1206;
const uint LF_DIMCONU_V2           = 0x1207;
const uint LF_DIMCONLU_V2          = 0x1208;
const uint LF_DIMVARU_V2           = 0x1209;
const uint LF_DIMVARLU_V2          = 0x120a;

// Field lists
const uint LF_BCLASS_V1            = 0x0400;
const uint LF_VBCLASS_V1           = 0x0401;
const uint LF_IVBCLASS_V1          = 0x0402;
const uint LF_ENUMERATE_V1         = 0x0403;
const uint LF_FRIENDFCN_V1         = 0x0404;
const uint LF_INDEX_V1             = 0x0405;
const uint LF_MEMBER_V1            = 0x0406;
const uint LF_STMEMBER_V1          = 0x0407;
const uint LF_METHOD_V1            = 0x0408;
const uint LF_NESTTYPE_V1          = 0x0409;
const uint LF_VFUNCTAB_V1          = 0x040a;
const uint LF_FRIENDCLS_V1         = 0x040b;
const uint LF_ONEMETHOD_V1         = 0x040c;
const uint LF_VFUNCOFF_V1          = 0x040d;
const uint LF_NESTTYPEEX_V1        = 0x040e;
const uint LF_MEMBERMODIFY_V1      = 0x040f;

// variants with new 32-bit type indices (V2)
const uint LF_BCLASS_V2            = 0x1400;
const uint LF_VBCLASS_V2           = 0x1401;
const uint LF_IVBCLASS_V2          = 0x1402;
const uint LF_FRIENDFCN_V2         = 0x1403;
const uint LF_INDEX_V2             = 0x1404;
const uint LF_MEMBER_V2            = 0x1405;
const uint LF_STMEMBER_V2          = 0x1406;
const uint LF_METHOD_V2            = 0x1407;
const uint LF_NESTTYPE_V2          = 0x1408;
const uint LF_VFUNCTAB_V2          = 0x1409;
const uint LF_FRIENDCLS_V2         = 0x140a;
const uint LF_ONEMETHOD_V2         = 0x140b;
const uint LF_VFUNCOFF_V2          = 0x140c;
const uint LF_NESTTYPEEX_V2        = 0x140d;

const uint LF_ENUMERATE_V3         = 0x1502;
const uint LF_ARRAY_V3             = 0x1503;
const uint LF_CLASS_V3             = 0x1504;
const uint LF_STRUCTURE_V3         = 0x1505;
const uint LF_UNION_V3             = 0x1506;
const uint LF_ENUM_V3              = 0x1507;
const uint LF_MEMBER_V3            = 0x150d;

// numeric leaf types
const uint LF_NUMERIC              = 0x8000;
const uint LF_CHAR                 = 0x8000;
const uint LF_SHORT                = 0x8001;
const uint LF_USHORT               = 0x8002;
const uint LF_LONG                 = 0x8003;
const uint LF_ULONG                = 0x8004;
const uint LF_REAL32               = 0x8005;
const uint LF_REAL64               = 0x8006;
const uint LF_REAL80               = 0x8007;
const uint LF_REAL128              = 0x8008;
const uint LF_QUADWORD             = 0x8009;
const uint LF_UQUADWORD            = 0x800a;
const uint LF_REAL48               = 0x800b;
const uint LF_COMPLEX32            = 0x800c;
const uint LF_COMPLEX64            = 0x800d;
const uint LF_COMPLEX80            = 0x800e;
const uint LF_COMPLEX128           = 0x800f;
const uint LF_VARSTRING            = 0x8010;

// codeview type enum

union codeview_type
{
    struct generic
    {
        ushort      len;
        short               id;
    }

    struct modifier_v1
    {
        ushort      len;
        short               id;
        short               attribute;
        short               type;
    }

    struct modifier_v2
    {
        ushort      len;
        short               id;
        int                     type;
        short               attribute;
    }

    struct pointer_v1
    {
        ushort      len;
        short               id;
        short               attribute;
        short               datatype;
//        struct p_string         p_name;
    }

    struct pointer_v2
    {
        ushort      len;
        short               id;
        uint            datatype;
        uint            attribute;
//        struct p_string         p_name;
    }

    struct bitfield_v1
    {
        ushort      len;
        short               id;
        ubyte           nbits;
        ubyte           bitoff;
        ushort          type;
    }

    struct bitfield_v2
    {
        ushort      len;
        short               id;
        uint            type;
        ubyte           nbits;
        ubyte           bitoff;
    }

    struct array_v1
    {
        ushort      len;
        short               id;
        short               elemtype;
        short               idxtype;
        ushort      arrlen;     /* numeric leaf */
//        struct p_string         p_name;
    }

    struct array_v2
    {
        ushort      len;
        short               id;
        uint            elemtype;
        uint            idxtype;
        ushort      arrlen;    /* numeric leaf */
//        struct p_string         p_name;
    }

    struct array_v3
    {
        ushort      len;
        short               id;
        uint            elemtype;
        uint            idxtype;
        ushort      arrlen;    /* numeric leaf */
//        char                    name[1];
    }

    struct struct_v1
    {
        ushort      len;
        short               id;
        short               n_element;
        short               fieldlist;
        short               property;
        short               derived;
        short               vshape;
        ushort      structlen;  /* numeric leaf */
//        struct p_string         p_name;
    }

    struct struct_v2
    {
        ushort      len;
        short               id;
        short               n_element;
        short               property;
        uint            fieldlist;
        uint            derived;
        uint            vshape;
        ushort      structlen;  /* numeric leaf */
//        struct p_string         p_name;
    }

    struct struct_v3
    {
        ushort      len;
        short               id;
        short               n_element;
        short               property;
        uint            fieldlist;
        uint            derived;
        uint            vshape;
        ushort      structlen;  /* numeric leaf */
//        char                    name[1];
    }

    struct union_v1
    {
        ushort      len;
        short               id;
        short               count;
        short               fieldlist;
        short               property;
        ushort      un_len;     /* numeric leaf */
//        struct p_string         p_name;
    }

    struct union_v2
    {
        ushort      len;
        short               id;
        short               count;
        short               property;
        uint            fieldlist;
        ushort      un_len;     /* numeric leaf */
//        struct p_string         p_name;
    }

    struct union_v3
    {
        ushort      		len;
        short           id;
        short           count;
        short           property;
        uint            	fieldlist;
        ushort      		un_len;     /* numeric leaf */
//        struct p_string         p_name;
    }

    struct enumeration_v1
    {
        ushort      		len;
        short           id;
        short           count;
        short           type;
        short           field;
        short           property;
//        struct p_string     p_name;
    }

    struct enumeration_v2
    {
        ushort      		len;
        short           id;
        short           count;
        short           property;
        uint            	type;
        uint            	field;
//        struct p_string         p_name;
    }

    struct enumeration_v3
    {
        ushort      len;
        short               id;
        short               count;
        short               property;
        uint            type;
        uint            field;
//        char                    name[1];
    }

    struct fieldlist
    {
        ushort      	len;
        short     	id;
//        ubyte           list;
    }

    struct procedure_v1
    {
        ushort      len;
        short               id;
        ushort      rvtype;
        ubyte           call;
        ubyte           reserved;
        ushort      params;
        ushort      arglist;
    }

    struct procedure_v2
    {
        ushort      len;
        short               id;
        uint            rvtype;
        ubyte           call;
        ubyte           reserved;
        ushort      params;
        uint            arglist;
    }

    struct mfunction_v1
    {
        ushort      len;
        short               id;
        ushort      rvtype;
        ushort      class_type;
        ushort      this_type;
        ubyte           call;
        ubyte           reserved;
        ushort      params;
        ushort      arglist;
        uint            this_adjust;
    }

    struct mfunction_v2
    {
        ushort      len;
        short       id;
        uint       	unknown1; /* could be this_type ??? */
        uint        class_type;
        uint        rvtype;
        ubyte       call;
        ubyte       reserved;
        ushort      params;
        uint        arglist;
        uint   		this_adjust;
    }
}

// LF_CLASS and LF_STRUCTURE property fields
enum CV_CLASSDEF_PROPERTIES
{
	Packed			= 0x0001,
	Ctor			= 0x0002,
	Overops			= 0x0004,
	IsNested		= 0x0008,
	ContainsNested	= 0x0010,
	OpAssign		= 0x0020,
	OpCast			= 0x0040,
	ForwardRef		= 0x0080,
	Scoped			= 0x0100,
}

// type string attribute flags
enum FIELD_ATTRIBUTE : uint
{
// access :2 Specifies the access protection of the item
	ACCESS_SHIFT	= 0,	// left-right shift
	ACCESS_MASK		= 0x03,	// mask
	None 			= 0, 	// No access protection
	Private 		= 1, 	// Private
	Protected 		= 2, 	// Protected
	Public 			= 3, 	// Public

// mprop :3 Specifies the properties for methods
	PROP_SHIFT		= 2,	// left-right shift
	PROP_MASK		= 0x07,	// mask
	Vanilla 		= 0, 	// Vanilla method
	Virtual 		= 1, 	//Virtual method
	Static 			= 2,	// Static
	Friend 			= 3,	// Friend
	Introducing 	= 4,	// Introducing virtual
	PureVirtual 	= 5,	// Pure virtual
	PureVirtualIntro = 6,	// Pure introducing virtual

	pseudo 			= 0x20,
	noinherit 		= 0x40,
	noconstruct 	= 0x80

}

bit fieldAttribIsVirtual( uint attrib )
{
	return ((attrib >> FIELD_ATTRIBUTE.PROP_SHIFT) & FIELD_ATTRIBUTE.PROP_MASK) == 1;
}


