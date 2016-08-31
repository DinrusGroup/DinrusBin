/+
    Copyright (c) 2005-2006 Lars Ivar Igesund

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
    Authors: Lars Ivar Igesund
    License: BSD Derivative (see source for details)
    Copyright: 2005-2006 Lars Ivar Igesund
*/
module ddl.elf.ELFHeaders;

/**
    Constants from the ELF specification.
*/

/** Size of the e_ident array. */
const uint EI_NIDENT = 16;

/** Indices in the e_ident array. */
const uint EI_MAG0 = 0;
const uint EI_MAG1 = 1;
const uint EI_MAG2 = 2;
const uint EI_MAG3 = 3;
const uint EI_CLASS = 4;
const uint EI_DATA = 5;
const uint EI_VERSION = 6;
const uint EI_PAD = 7;

/** Values defining the class of the file. */
const uint ELFCLASSNONE = 0;
const uint ELFCLASS32 = 1;
const uint ELFCLASS64 = 2;

/** Values defining the encoding of data. */
const uint ELFDATANONE = 0;
const uint ELFDATA2LSB = 1;
const uint ELFDATA2MSB = 2;

/** Defined version of the ELF specification. */
const uint EV_NONE = 0;
const uint EV_CURRENT = 1; // This can change!

/** The version currently supported by DDL */
const uint DDL_ELFVERSION_SUPP = 1;

/** Values defining the object file type. */
const uint ET_NONE = 0;
const uint ET_REL = 1;
const uint ET_EXEC = 2;
const uint ET_DYN = 3;
const uint ET_CORE = 4;
const uint ET_LOPROC = 0xff00;
const uint ET_HIPROC = 0xffff;

/** Values defining machine architectures. */
const uint EM_NONE = 0;
const uint EM_M32 = 1;
const uint EM_SPARC = 2;
const uint EM_386 = 3;
const uint EM_68K = 4;
const uint EM_88K = 5;
const uint EM_860 = 7;
const uint EM_MIPS = 8;

/** Values defining symbol binding. */
const ubyte STB_LOCAL = 0;
const ubyte STB_GLOBAL = 1;
const ubyte STB_WEAK = 2;
const ubyte STB_LOPROC = 13;
const ubyte STB_HIPROC = 15;

/** Values defining section types. */
const uint SHT_NULL = 0;
const uint SHT_PROGBITS = 1;
const uint SHT_SYMTAB = 2;
const uint SHT_STRTAB = 3;
const uint SHT_RELA = 4;
const uint SHT_HASH = 5;
const uint SHT_DYNAMIC = 6;
const uint SHT_NOTE = 7;
const uint SHT_NOBITS = 8;
const uint SHT_REL = 9;
const uint SHT_SHLIB = 10;
const uint SHT_DYNSYM = 11;
const uint SHT_LOPROC = 0x70000000;
const uint SHT_HIPROC = 0x7fffffff;
const uint SHT_LOUSER = 0x80000000;
const uint SHT_HIUSER = 0xffffffff;

/** Values defining segment types. */
const uint PT_NULL = 0;
const uint PT_LOAD = 1;
const uint PT_DYNAMIC = 2;
const uint PT_INTERP = 3;
const uint PT_NOTE = 4;
const uint PT_SHLIB = 5;
const uint PT_PHDR = 6;
const uint PT_LOPROC = 0x70000000;
const uint PT_HIPROC = 0x7fffffff;


alias uint Elf32_Addr;
alias ushort Elf32_Half;
alias uint Elf32_Off;
alias int Elf32_SWord;
alias uint Elf32_Word;
alias ushort Elf32_Sword;

/**
    This struct can hold an ELF object file header.
*/

struct Elf32_Ehdr{

     ubyte [EI_NIDENT] e_ident;
     Elf32_Half e_type;
     Elf32_Half e_machine;
     Elf32_Word e_version;
     Elf32_Addr e_entry;
     Elf32_Off e_phoff;
     Elf32_Off e_shoff;
     Elf32_Word e_flags;
     Elf32_Half e_ehsize;
     Elf32_Half e_phentsize;
     Elf32_Half e_phnum;
     Elf32_Half e_shentsize;
     Elf32_Half e_shnum;
     Elf32_Half e_shstrndx;

}

/**
    This struct can hold a section header table entry from an ELF object
    file.
*/

struct Elf32_Shdr{
    Elf32_Word sh_name;
    Elf32_Word sh_type;
    Elf32_Word sh_flags;
    Elf32_Addr sh_addr;
    Elf32_Off sh_offset;
    Elf32_Word sh_size;
    Elf32_Word sh_link;
    Elf32_Word sh_info;
    Elf32_Word sh_addralign;
    Elf32_Word sh_entsize;
}

/**
    This struct can hold a program header table entry from an ELF object
    file.
*/

struct Elf32_Phdr{
    Elf32_Word p_type;
    Elf32_Off p_offset;
    Elf32_Addr p_vaddr;
    Elf32_Addr p_paddr;
    Elf32_Word p_filesz;
    Elf32_Word p_memsz;
    Elf32_Word p_flags;
    Elf32_Word p_align;
}

/**
    This struct can hold a symbol table entry from an ELF object file.
*/ 

struct Elf32_Sym{
    Elf32_Word    st_name;
    Elf32_Addr    st_value;
    Elf32_Word    st_size;
    ubyte     	  st_info;
    ubyte         st_other;
    Elf32_Half    st_shndx;
}
/**
    This struct can hold a relocation entry from an ELF object file.
*/

struct Elf32_Rel{
    Elf32_Addr r_offset;
    Elf32_Word r_info;
}

/**
    This struct can hold a relocation entry from an ELF object file,
    including an addend.
*/

struct Elf32_Rela{
    Elf32_Addr r_offset;
    Elf32_Word r_info;
    Elf32_Sword r_addend;
}
version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-ddl");
        } else version (DigitalMars) {
            pragma(link, "mango");
        } else {
            pragma(link, "DO-ddl");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-ddl");
        } else version (DigitalMars) {
            pragma(link, "mango");
        } else {
            pragma(link, "DO-ddl");
        }
    }
}
