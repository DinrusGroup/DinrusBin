module ddl.omf.OMFLibrary;

private import ddl.ExportSymbol;
private import ddl.Attributes;
private import ddl.DynamicLibrary;
private import ddl.DynamicModule;
private import ddl.FileBuffer;
private import ddl.DDLReader;
private import ddl.Utils;

private import ddl.omf.OMFModule;

private import mango.io.Exception;
private import mango.io.model.IBuffer;
private import mango.io.model.IConduit;

class OMFLibrary : DynamicLibrary{
	DynamicModule[] modules;
	DynamicModule[char[]] crossReference; // modules by symbol name
	ExportSymbolPtr[char[]] dictionary; // symbols by symbol name
	Attributes attributes;

	public this(){
		attributes["omf.filename"] = "<unknown>";
	}
	
	public this(FileBuffer file){
		attributes["omf.filename"] = file.getPath.toString();
		load(file);
	}
		
	public char[] getType();
	
	public Attributes getAttributes();
	
	package void setAttributes(Attributes other);
	
	package void setAttribute(char[] key,char[] value);
	
	public ExportSymbolPtr getSymbol(char[] name);
	
	public DynamicModule[] getModules();
		
	public DynamicModule getModuleForSymbol(char[] name);
	
	public ubyte[] getResource(char[] name);
	
	package void addModule(OMFModule mod);
		
	protected void load(IBuffer data);
	
	public char[] toString();
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
