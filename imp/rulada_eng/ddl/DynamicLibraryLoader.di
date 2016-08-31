/**
	Provides DynamicLibrary loading support.
	
	Authors: Eric Anderton
	License: BSD Derivative (see source for details)
	Copyright: 2005,2006 Eric Anderton
*/
module ddl.DynamicLibraryLoader;

private import ddl.DynamicLibrary;
private import ddl.LoaderRegistry;
private import ddl.FileBuffer;


/**
	Base class for all dynamic library loaders.
*/
abstract class DynamicLibraryLoader{
	/**
		Returns: the type for this library.
	*/
	public char[] getLibraryType();

	/**
		The implementaiton is understood to check the file by inspecting its contents.
		The implementor must be sure to not advance the internal buffer pointer, so that
		future checks against the buffer can all begin at the same location.
	
		Returns: true if the file can be loaded by this loader, false if it cannot.
	*/
	public bit canLoadLibrary(FileBuffer file);
	
	/**
		Loads a binary file.
	
		Returns: the library stored in the provided file.
		Params:
			file = the file that contains the binary library data.
	*/
	public DynamicLibrary load(LoaderRegistry registry,FileBuffer file);
}
