/+
	Copyright (c) 2005 Eric Anderton
	
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

module ddl.insitu.InSituLoader;

private import ddl.ExportSymbol;
private import ddl.DynamicLibrary;
private import ddl.DynamicModule;
private import ddl.DynamicLibraryLoader;
private import ddl.LoaderRegistry;
private import ddl.FileBuffer;

private import ddl.insitu.InSituMapBinary;
private import ddl.insitu.InSituLibBinary;
private import ddl.insitu.InSituLibrary;

class InSituLibLoader : DynamicLibraryLoader{
	static char[] typeName = "SITU";
	static char[] fileExtension = "situ";

	public char[] getLibraryType(){
		return(typeName);
	}
	
	public char[] getFileExtension(){
		return(fileExtension);
	}
		
	public bit canLoadLibrary(FileBuffer file){
		return (cast(char[])file.get(8,false)) == "DDLSITU!";
	}
	
	public DynamicLibrary load(LoaderRegistry registry,FileBuffer file){
		InSituLibBinary binary = new InSituLibBinary();
		binary.load(file);
		return new InSituLibrary(binary);	
	}
}

class InSituMapLoader : DynamicLibraryLoader{
	static char[] typeName = "SITUMAP";
	static char[] fileExtension = "map";

	public char[] getLibraryType(){
		return(typeName);
	}
	
	public char[] getFileExtension(){
		return(fileExtension);
	}	
		
	public bit canLoadLibrary(FileBuffer file){
		return (cast(char[])file.get(8,false)) == "\r\n Start";
	}
	
	public DynamicLibrary load(LoaderRegistry registry,FileBuffer file){
		InSituMapBinary binary = new InSituMapBinary();
		binary.load(file);
		return new InSituLibrary(binary);		
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
