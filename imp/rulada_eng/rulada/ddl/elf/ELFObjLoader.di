/+
    Copyright (c) 2005-2006 Lars Ivar Igesund, Eric Anderton

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
    Authors: Lars Ivar Igesund, Eric Anderton
    License: BSD Derivative (see source for details)
    Copyright: 2005-2006 Lars Ivar Igesund
*/
module ddl.elf.ELFObjLoader;

private import ddl.DynamicLibrary;
private import ddl.DynamicLibraryLoader;
private import ddl.LoaderRegistry;
private import ddl.Utils;
private import ddl.FileBuffer;
private import ddl.Utils;

private import ddl.elf.ELFLibrary;
private import ddl.elf.ELFModule;


/**
    An implementation of the abstract class DynamicLibraryLoader for
    for use with object files in ELF (Executable and Linkable Format).
    The object files can be standalone .o or embedded in archive files.
*/
class ELFObjLoader : DynamicLibraryLoader{
    /**
        Returns the typename supported by this loader. Returns the
        static string "ELF".
    */
    public char[] getLibraryType(){
        return("ELF");
    }

    /**
        Returns true if the loader can load the provided library.
        The method checks if the supplied library starts with the ELF
        magic string, "\x7fELF".
    */
    public bool canLoadLibrary(FileBuffer file){
        debug debugLog("Testing for ELF compliance");
        debug debugLog("from file: ", cast(char[])file.get(4,false));
        debug debugLog("magic header: \0x7ELF");
    	if((cast(ubyte[])file.get(4,false)) == cast(ubyte[])"\x7fELF"){
            debug debugLog("ELF header verified");
            return true;
        }
        return false;
    }

    /**
        Loads the supplied library, returning an instance of ELFLibrary.
    */
    public DynamicLibrary load(LoaderRegistry registry,FileBuffer file){
        ELFLibrary lib = new ELFLibrary();

        // load object format
        ELFModule mod = new ELFModule(file);
        lib.addModule(mod);
        
		// establish the correct attributes in the library
		lib.setAttributes(mod.getAttributes);
		lib.setAttribute("elf.filename",file.getPath.toString());     
        return lib;
    }
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
