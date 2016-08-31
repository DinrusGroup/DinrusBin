/**
	Provides support for parsing and decoding D's name mangling syntax. 
	Wraps std.demangle from phobos.
	
	Authors: Eric Anderton
	License: BSD Derivative (see source for details)
	Copyright: 2005-2006 Eric Anderton
*/
module ddl.Demangle;

private import std.demangle;

debug private import ddl.Utils;

/**
	The type of symbol that is represented by a given mangled name.
	
	Any ordinary type of symbol that doesn't match a D symbol, or a D special symbol
	is merely of type 'PublicSymbol'.
*/
enum DemangleType{
	PublicSymbol,
	ClassDefinition,
	Initalizer,
	Vtable,
	VarArguments,
	PlatformHook,
	DAssert,
	DArray,
	ModuleCtor,
	ModuleDtor,
	ModuleInfo,
	Main,
	WinMain,
	Nullext
}


/**
	Разбирает mangled символ D and returns the equivalent D code to match the symbol.
	
	Params:
		symbol = The mangled D symbol.
		
	Returns:
		A D code representation of the symbol.
*/
public char[] demangleSymbol(char[] symbol);

bool startsWith(char[] value,char[] test);

/**
	Parses a mangled D symbol and returns its DemangleType.
	
	Params:
		symbol = The mangled D symbol.
		
	Returns:
		The DemangleType for the symbol.
*/
public DemangleType getDemangleType(char[] symbol);

