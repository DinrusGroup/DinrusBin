/**
	Authors: Eric Anderton
	License: BSD Derivative (see source for details)
	Copyright: 2005 Eric Anderton
*/
module ddl.ExportSymbol;

enum SymbolType: ubyte{
	Weak, // may or may not be defined, and cannot be not relied upon for linking
	Strong, // defined, can be linked against
	Extern // undefined, needs a strong reference
}

/**
	Defines a symbol within a DynamicModule.
*/
struct ExportSymbol{
	/**
		The type of the symbol.
	*/
	
	public SymbolType type;
	/** 
		The address of the symbol.
		
		In some very rare cases, this may be a null value.  It is reccomended that the developer test
		against ExportSymbol.init if they wish to determine if an ExportSymbol has been set/defined.
	*/
	
	public void* address;
	/** 
		The name of the symbol.
		
		Invariably, this string will contain the "mangled" name that the compiler generates for
		the symbol.  For D Modules, this will contain a properly mangled D symbol, per the D ABI.
		
		C symbols are usually exported as an underscore followed by the identifier as it reads in
		the source-code.  For C++, ASM and other languages, the results are much more varied and are usually
		compiler dependent.  It is not reccomended to code against these types of symbols literally
		if it can be at all avoided.
	*/
	public char[] name;
	
	/** 
		Returns the resolution status of this symbol.
		
	**/
	bool isResolved();

	/**
	        Can be used as an empty symbol, e.g. 
	            return ExportSymbol.NONE;
	*/
	static const ExportSymbol NONE;
	
	/**
		Returns a friendly name for the type of symbol, based on it's 'type' member.
	*/
	char[] getTypeName();
}

alias ExportSymbol* ExportSymbolPtr;
