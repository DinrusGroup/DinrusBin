module ddl.LoaderRegistry;

private import ddl.DynamicLibraryLoader;
private import ddl.DynamicLibrary;
private import ddl.FileBuffer;

debug private import mango.io.Stdout;

debug private import ddl.Utils;

/**
	Exception class used exclusively by the Linker.
	
	LibraryVersionException are generated when the linker can load a library but it does not match
	the requested version as embedded in that module's metadata (std.version).
*/
class LibraryVersionException : Exception{
	public char[] libraryName;
	public char[] requiredStdVersion;
	public char[] libStdVersion;
	
	/** The name of the library that was the cause of the exception */
	public char[] getLibraryName();
	
	/** The required version for the library */
	public char[] getRequiredStdVersion();
	
	/** The value of std.version in the libary */
	public char[] getLibStdVersion();
			
	/**
		Constructor.
	
		Params:
			libraryName = the name of the library involved.
			requiredStdVersion = the required version of the library
			libStdVersion = the version that the library actually has (if it has one at all).
	*/
	public this(char[] libraryName,char[] requiredStdVersion,char[] libStdVersion){
		if(libStdVersion && libStdVersion.length > 0){
			super("LibraryVersionException: the library '" ~ libraryName ~ "' version '" ~ libStdVersion ~ "' is not the required version: '" ~ requiredStdVersion ~ "'");
		}
		else{
			super("LibraryVersionException: the library '" ~ libraryName ~ "' (unversioned) is not the required version: '" ~ requiredStdVersion ~ "'");
		}
		
		this.libraryName = libraryName;
		this.requiredStdVersion = requiredStdVersion;
		this.libStdVersion = libStdVersion;
	}
}

/**
	The LoaderRegistry fufills the role of controlling access to the loaders to be used for a
	set of library load operations.  While this is most directly used by the Linker class,
	the registry can be used independently of a given linker.  In fact, several implementations
	of the DynamicLibrary class use the registry to support nested libraries. This is accomplished 
	by the registry	passing a reference to itself forward through every call to load() on a given loader.
	
	It also helps to establish a coherent set of support for a given chain of library loads.  Should
	a developer not want OMF or COFF support in their application, they can simply compose a registry
	that does not utilize either of those loaders.  This also helps prevent program bloat by not 
	taking on classes that support types that are not needed.
	
	The DefaultRegistry provides a boilerplate implementation of the LoaderRegistry, that pulls in 
	every standard loader that DDL provides.  Efficency minded developers should look to rolling
	their own LoaderRegistry intstead.
*/
class LoaderRegistry{
	DynamicLibraryLoader[char[]] loaders;
	
	/**
		Registers a loader within the registry.  The loader will then be used in subsequent
		calls to load (and its variants) to investigate if it can load a given file 
		(via canLoadLibrary) and to actually load a library (via load).
		
		The loader is associated in the registry via its type (loader.getLibraryType()).
		Should another loader of the same exact type be passed to this method, the latter
		loader will be associated instead.
		
		Params:
			loader = the loader to register.  
	*/
	public void register(DynamicLibraryLoader loader);
	/**
		Returns: a loader for the type given, or none if there is no loader for the associated type.
		Params:
			type = the type of loader to find.
	*/
	public DynamicLibraryLoader getLoader(char[] type);
	/**
		Returns: a dynamic library for the requested file, or null if there is no loader for the
		given library.  
		
		If the attrStdVersion parameter is supplied this is matched against the "std.version" 
		attribute in the supplied library.  If the attribute doesn't exist, and or the
		attrStdVersion attribute is omitted or set to "", then the library is loaded anyway.
		Otherwise, should attrStdVersion not match the "std.version" attribute, the method
		throws an exception.
		
		Params:
			buffer = buffer for the binary file
			attrStdVersion = (optional) the version of the library to match			
	*/
	public DynamicLibrary load(FileBuffer buffer,char[] attrStdVersion = "");
	/**
		Returns: a dynamic library for the requested filename, or null if there is no loader for the
		given library.
		
		If the attrStdVersion parameter is supplied this is matched against the "std.version" 
		attribute in the supplied library.  If the attribute doesn't exist, and or the
		attrStdVersion attribute is omitted or set to "", then the library is loaded anyway.
		Otherwise, should attrStdVersion not match the "std.version" attribute, the method
		throws an exception.				
		
		Params:
			file = the filename of the library to load.
			attrStdVersion = (optional) the version of the library to match
	*/
	public DynamicLibrary load(char[] filename,char[] attrStdVersion = "");
	
	/**
		Returns: true if the file can be loaded, false if it cannot.
		Params:
			file = the file to test.  The file is expected to already be loaded.
	*/
	public bit canLoad(FileBuffer file);
	
	/**
		Returns: true if the file can be loaded, false if it cannot.
		Params:
			filename = name of the file to test.
	*/
	public bit canLoad(char[] filename);
	/**
		Returns: an array of type names for all the supported loaders in this registry.
	*/
	public char[][] getSupportedTypes();
	/**
		Returns: true if the typename is supported, false if it is not.
		Params:
			type = the name of the type to test.  See DynamicLibraryLoader.getLibraryType() for more infomation.
	*/
	public bit isSupported(char[] type);
}
