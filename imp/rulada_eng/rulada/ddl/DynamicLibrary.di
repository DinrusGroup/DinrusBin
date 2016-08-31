/**
	Authors: Eric Anderton, Don Clugston
	License: BSD Derivative (see source for details)
	Copyright: 2005 Eric Anderton
*/
module ddl.DynamicLibrary;

private import ddl.ExportSymbol;
private import ddl.DynamicModule;
private import ddl.Mangle;
private import ddl.Attributes;
private import ddl.ExportClass;

// pull in the platform new() for classes
extern(C) Object _d_newclass(ClassInfo ci);

// base-class checking
extern(C) int _d_isbaseof2(ClassInfo oc, ClassInfo c, inout uint offset);

/**
	Abstract base class for all DynamicLibrary types for use with DDL.
*/
abstract class DynamicLibrary{
	/**
		Returns: an export for the requested symbol name.  Will throw if the symbol does not exist.
	*/
	public ExportSymbolPtr getSymbol(char[] name);
	
	/**
		Returns: all the modules controled by this library.
	*/
	public DynamicModule[] getModules();
	
	/**
		This provides a means to identify what type of library is being used here.  
		The string returned matches the string returned by the DymamicLibraryLoader 
		that created the library.  See getLibraryType() for more information.
		
		Returns: the type of library.
	*/
	public char[] getType();
	
	/**
		Returns: the attributes for this library.
	*/
	public Attributes getAttributes();

	/**
		The getModuleForSymbol() method provides a way for DymamicLibrary implementations to implement
		conservative loading of modules when a link operation is in progress.  The linker
		uses this method to get a module for a given export name, and then processes
		the link operation against the module returned.
		
		The behavior of this method is in sharp contrast to the getModules() method, which
		forces the implementation to return every and all modules it controls, without exception.  
		
		In light of that, Relying on the getModules() (and getSymbols()) methods can have serious 
		performance implications, depending on the actual implemenation of DynamicLibrary.  
		For example, some implementations may decide to intercept D symbols and map the symbol 
		namespace onto an internal lookup scheme or a file tree.  Others, may use an internal 
		cache for modules or implement some variation of lazy-loading.
		
		Returns: the module contianing the export, or null if no module in this library contains
		the export.  The module is not guaranteed to contain the symbol provided, and can simply be 
		the	library's best guess as to a match.  Call getSymbol() on the returned module to eliminate
		any such false-positives.
		
		Params:
			name = the name of the symbol to find a module match for.
	*/
	public DynamicModule getModuleForSymbol(char[] name);

	/**
		The use of the getResource method is primarily to support resource loading on
		.zip style collections.  Its behavior is very implementation dependent, but it
		can be reliably expected to return null if a resource cannot be reproduced.
		
		Returns: the requested resource, or null if it does not exist.
		Params:
			name = the name of the symbol to search for.
	*/
	public ubyte[] getResource(char[] name);
	
		
	/*
		Template method that returns a typed export from the library.  The implementation uses
		getSymbolAddress() internally.  This differs greatly from the use of getSymbol() 
		variants in that it allows for a proper D namespace/name instead of a mangled symbol.
		
		This is most effective when querying for a function from the library.  Simply pass a 
		function typedef or alias as T to the template, and the proper name of the function
		in name.
		
		Free fields are also supported, but any such T that is a pointer will need to be 
		dereferenced an extra time, due to how the method is designed to accomodate function
		aliases (function pointers).  To query a uint* in the library, T should be uint** instead.
		
		Returns: an export of type T named 'name', or null if none exists.
		Params:
			T = the type of the field or function to search for.  Note that pointers require at least 
			two levels of dereferencing (uint* becomes uint**) to work correctly.
			name = the D name and namespace to search for.
	*/
	template getDExport(T, char [] name) {
		static if(T.mangleof[0] == 'P'){
			typeof(T) getDExport() {
				return cast(typeof(T))getSymbol( "_D" ~  mangleSymbolName!(name) ~ T.mangleof[1..$]).address; 
				}
		} else {
			typeof(T) getDExport() {
			return cast(typeof(T))getSymbol("_D" ~  mangleSymbolName!(name) ~ T.mangleof).address; }
		}
	}

	/**
		Template method that returns a ClassInfo instance for the given classname.
		Returns: a ClassInfo instance for classname, or null if none exists.
		Params:
			classname = the D namespace and name of the class to search for.
	*/
	template getClassInfo(char[] classname){
		ClassInfo getClassInfo(){
			return cast(ClassInfo)getSymbol("__Class_" ~  mangleSymbolName!(classname)).address;
		}
	}	
	
	/**   TInterface function(P1)  getCtor!(TInterface, classname, P1);
	 *
	 *  Returns a function which constructs a class, using the given parameters.
	 *  For example:
	 *  ------------
	 *  auto newFoo = getCtor("FooModule.Foo", char [], real);
	 *  auto newFooI = getCtor("FooModule.Foo", int);
	 *  x = newFooI(58);
	 *  y = newFoo("Avogadro's Number", 6.022e23);
	 * -----------------
	 *  is equivalent to:
	 * -----------------
	 *  x = new FooModule.Foo(58);
	 *  y = new FooModule.Foo("Avogadro's Number", 6.022e23);
	 * -----------------
	 */
	// TODO: might be better to return a delegate?
	// BUG: assumes that the class will actually have a Ctor in the library
	template getCtor(TInterface, char [] classname) {
		TInterface function() getCtor() {
			static ClassInfo typeClass;
			typeClass = getClassInfo!(classname)();
			static Object function (Object) rawCtor;
			rawCtor = cast(Object function (Object)) getSymbol(
				"_D" ~ mangleSymbolName!(classname) ~ mangleSymbolName!("_ctor") 
				~ "F"
				~ "ZC" ~ mangleSymbolName!(classname)).address;		
			static TInterface internalCtor() {
				  auto a = _d_newclass(typeClass);
				  rawCtor(a);
				  return cast(TInterface)a;
		   }
		
		   return &internalCtor;
	   }
	}
	
	template getCtor(TInterface, char [] classname, P1) {
		TInterface function(P1) getCtor() {
			static ClassInfo typeClass;
			typeClass = getClassInfo!(classname)();
			static Object function (P1, Object) rawCtor;
			rawCtor = cast(Object function (P1, Object)) getSymbol(
				"_D" ~ mangleSymbolName!(classname) ~ mangleSymbolName!("_ctor") 
				~ "F" ~ P1.mangleof 
				~ "ZC" ~ mangleSymbolName!(classname)).address;		
			static TInterface internalCtor(P1 p1) {
				  auto a = _d_newclass(typeClass);
				  rawCtor(p1, a);
				  return cast(TInterface)a;
		   }
		
		   return &internalCtor;
	   }
	}

	template getCtor(TInterface, char [] classname, P1, P2) {
		TInterface function(P1, P2) getCtor() {
			static ClassInfo typeClass;
			typeClass = getClassInfo!(classname)();
			static Object function (P1, P2, Object) rawCtor;
			rawCtor = cast(Object function (P1, P2, Object)) getSymbol(
				"_D" ~ mangleSymbolName!(classname) ~ mangleSymbolName!("_ctor") 
				~ "F" ~ P1.mangleof ~ P2.mangleof
				~ "ZC" ~ mangleSymbolName!(classname)).address;		
			static TInterface internalCtor(P1 p1, P2 p2) {
				  auto a = _d_newclass(typeClass);
				  rawCtor(p1, p2, a);
				  return cast(TInterface)a;
		   }
		
		   return &internalCtor;
	   }
	}
	
	ExportClass!(T)[] getSubclasses(T)() {
	  ExportClass!(T)[] res;
	  
	  foreach (mod; getModules) {
	     foreach (sym; mod.getSymbols) {
	        const char[] prefix = `__Class_`;
	        
	        if (sym.name.length > prefix.length && sym.name[0 .. prefix.length] == prefix) {
	           ClassInfo ci = cast(ClassInfo)getSymbol(sym.name).address;
	           assert (ci !is null);
	           
	           uint dummy;
	           if (T.classinfo !is ci && _d_isbaseof2(ci, T.classinfo, dummy)) {
	              res ~= new ExportClass!(T)(ci, sym.name[prefix.length .. length], this);
	           }
	        }
	     }
	  }
	  
	  return res;
	}
	
	
	ExportClass!(Tinterface) getClass(Tinterface, char[] classname)() {
	  return new ExportClass!(Tinterface)(
	     getClassInfo!(classname),
	     mangleSymbolName!(classname),
	     this);
	} 	
}
