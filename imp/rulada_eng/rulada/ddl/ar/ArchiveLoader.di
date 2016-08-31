/+
    Copyright (c) 2006 Lars Ivar Igesund, Eric Anderton

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
    Copyright: 2005-2006 Lars Ivar Igesund, Eric Anderton
*/
module ddl.ar.ArchiveLoader;

private import ddl.DynamicLibrary;
private import ddl.DynamicLibraryLoader;
private import ddl.LoaderRegistry;
private import ddl.FileBuffer;
private import ddl.Utils;
private import ddl.ar.ArchiveLibrary;

/**
    An implementation of the abstract class DynamicLibraryLoader for
    use with archive files in the Ar format.
    In general, archive files can hold all types of files, but for use
    in DDL, only archives of ELF object files and COFF library files
    are handled.
*/
class ArchiveLoader : DynamicLibraryLoader{

    public char[] getLibraryType(){
        return "AR";
    }

    /**
        Returns: true if the file can be loaded by this loader, 
        false if it cannot.
    */
    public bool canLoadLibrary(FileBuffer file){
        return (cast(ubyte[])file.get(8,false)) == cast(ubyte[])"!<arch>\n";
    }

    /**
        Loads a binary file.

        Returns: the library stored in the provided file.
        Params:
            file = the file that contains the binary library data.
    */
    public DynamicLibrary load(LoaderRegistry registry, FileBuffer file) {
         debug debugLog("* Loading the lib");   
         return new ArchiveLibrary(registry, file);
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
