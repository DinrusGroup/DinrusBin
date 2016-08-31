/**
	Authors: Eric Anderton
	License: BSD Derivative (see source for details)
	Copyright: 2005 Eric Anderton
*/
module ddl.Linker;

private import ddl.ExportSymbol;
private import ddl.DynamicLibrary;
private import ddl.DynamicModule;
private import ddl.Demangle;
private import ddl.LoaderRegistry;
private import ddl.DDLException;

private import std.moduleinit; // used for ModuleInfo type

debug private import ddl.Utils;

/**
	Exception class used exclusively by the Linker.
	
	LinkModuleException are generated when the linker cannot resolve a module during the linking process.
*/
class LinkModuleException : Exception{
	DynamicModule mod;
	
	/**
		Module that prompted the link exception.
	*/
	DynamicModule reason();
	
	/**
		Constructor.
		
		Params:
			reason = the module that prompts the exception
	*/
	public this(DynamicModule reason){
		super("LinkModuleException: cannot resolve '" ~ reason.getName ~ "'\n" ~ reason.toString());
		this.mod = reason;
	}
}

/**
	General-Purpose runtime linker for DDL.
*/
class Linker{
	protected LoaderRegistry registry;
	/** 
		Library list for libraries used for linking.
		
		The implementation here is deliberately simple -- some would call it brain-dead.
		The developer is therefore strongly encouraged to subclass this in order to 
		develop more sophisticated linking and library management behaviors.
		
		The order of insertion into the library list is used as a priority scheme
		when attempting to link new modules into the runtime.  The first library 
		added to the linker should be the current in-situ library, should linking
		to classes and types in the current runtime be a requirement.  In any case
		the next candidates for addition to the linker should be the runtime libraries
		in no particular order.
		
		The linker will attept to link against the first library first, and so on
		down the list.
	*/
	protected DynamicLibrary[] libraries;
	
	/** 
		The linker uses an LoaderRegistry to handle internal library dependencies
		automatically, such that the developer can more easily automate linking behavior.
			
		Params:
			registry = the LoaderRegistry to use when loading binaries.
	*/
	public this(LoaderRegistry registry){
		this.registry = registry;
	}
	
	/**
		Returns: the current registry
	*/
	public LoaderRegistry getRegistry(){
		return this.registry;
	}

	/**
		Initalizes a ModuleInfo instance from a DynamicModule.
		
		From here on the provided library 
	*/
	protected void initModule(ModuleInfo m, int skip){
		if(m is null) return;
		if (m.flags & MIctordone) return;

		debug debugLog("this module: %0.8X",cast(void*)m);
		debug debugLog("(name: %0.8X %d)",m.name.ptr,m.name.length);		
		debug debugLog("(ctor: %0.8X)",cast(void*)(m.ctor));
		debug debugLog("(dtor: %0.8X)",cast(void*)(m.dtor));
		debug debugLog("Module: %s\n",m.name);
		
		if (m.ctor || m.dtor)
		{
		    if (m.flags & MIctorstart)
		    {	if (skip)
			    return;
			throw new ModuleCtorError(m);
		    }
		    
		    m.flags |= MIctorstart;
		    debug debugLog("running imported modules (%d)...",m.importedModules.length);
		    foreach(ModuleInfo imported; m.importedModules){
			    debug debugLog("running: [%0.8X]",cast(void*)imported);
			    initModule(imported,0);
			    debug debugLog("-done.");
		    }
		    if (m.ctor)
			(*m.ctor)();
		    m.flags &= ~MIctorstart;
		    m.flags |= MIctordone;
	
		    //TODO: Now that construction is done, register the destructor
		}
		else
		{
		    m.flags |= MIctordone;
		    debug debugLog("running imported modules (%d)...",m.importedModules.length);
		    foreach(ModuleInfo imported; m.importedModules){
			    debug debugLog("running: [%0.8X]",cast(void*)imported);
			    initModule(imported,1);
			    debug debugLog("-done.");
		    }
		}    
	}
	
	alias ModuleInfo[DynamicModule] ModuleSet;	
		
	/**
		Links a module against the linker's internal cross-reference.
		
		This implementation performs a long search of modules, then discrete symbols in the
		cross-reference.
		
		The parameter canSelfResolve is passed as 'true' for registraion variants of link 
		routines.
		
		moduleSet a set of modules that need initalization following the link pass.
	*/
	public void link(DynamicModule mod, inout ModuleSet moduleSet, bool canSelfResolve=false){
		uint i;
		
		//protect against infinite recursion here by returning early
		//by this, we count on the module being resolved further up the call stack
		if(mod.isLinking) return;
		
		mod.isLinking = true;
		
		debug debugLog("Linking module: %s",mod.getName);
		
		auto moduleSymbols = mod.getSymbols();
		for(i=0; i<moduleSymbols.length; i++){
			auto symbol = &(moduleSymbols[i]);
			
			if(symbol.type == SymbolType.Strong) continue;
			// resolve a dependency from out of the registry
			debug debugLog("searching %d registered libs",this.libraries.length);
			foreach(lib; this.libraries){
				auto libMod = lib.getModuleForSymbol(symbol.name);
				if(libMod && libMod != mod){
					if(!libMod.isResolved()){
						this.link(libMod,moduleSet,true);
					}
					auto otherSymbol = libMod.getSymbol(symbol.name);
					if(otherSymbol.type == SymbolType.Strong){
						debug debugLog("[Linker] found %s at %0.8X",otherSymbol.name,otherSymbol.address); 		
						symbol.address = otherSymbol.address;
						symbol.type = SymbolType.Strong;
						goto nextSymbol;
					}
					debug debugLog("symbol is not strong (%s -> %0.8X)",symbol.getTypeName,symbol.address);
				}
			}
			// throw if we aboslutely *must* have this symbol resolved on this pass
			if(symbol.type == SymbolType.Extern || !canSelfResolve){
				throw new DDLException("cannot resolve symbol '%s'",symbol.name);
			}
			nextSymbol:
			{} // satisfy compiler
		}
	
		if(canSelfResolve){
			for(i=0; i<moduleSymbols.length; i++){
				auto symbol = &(moduleSymbols[i]);
				if(symbol.type == SymbolType.Weak) symbol.type = SymbolType.Strong;
			}
		}
				
		mod.resolveFixups();
		mod.isLinking = false;
		
		if(!mod.isResolved()){
			throw new LinkModuleException(mod);
		}
		
		debug debugLog("mod is resolved: %s",mod.toString());
					
		// dig up the ModuleInfo (if applicable) and store it for later use.
		if(!(mod in moduleSet)){
			debug debugLog("looking for: %s","__ModuleInfo_" ~ mod.getRawNamespace);
			auto sym = mod.getSymbol("__ModuleInfo_" ~ mod.getRawNamespace);
			if(sym.address != null){
				debug debugLog("Found moduleinfo for %s at [%0.8X] %s",mod.getNamespace,sym.address,sym.name);
				moduleSet[mod] = cast(ModuleInfo)(sym.address);
			}
		}
	}
	
	/**
		Links a library against the linker's internal cross-reference.
		
		There is a subtle difference between linking a lib and linking a lib that has been
		added to the cross-reference.  If every module in the lib is merely dependent upon
		modules that exist in the cross-reference already, then just calling link will do 
		the task.  Otherwise, the lib should be added to the cross-reference first, before
		proceeding with the actual link.
		
		Examples:
		---
		DynamicLibrary lib;
		Linker linker;
		
		linker.register(lib); // add to xref first
		linker.link(lib); // link in the library and its aggregate modules
		---
	*/
	public void link(DynamicLibrary lib){
		ModuleSet moduleSet;
		Exception exception = null;
		
		// link
		try{
			foreach(DynamicModule mod; lib.getModules){
				this.link(mod,moduleSet);
			}
		}
		catch(Exception e){
			exception = e; // re-throw in a minute...
		}
		
		// init (run whatever initalizers are pending, regardless of failure)
		foreach(mod,moduleInfo; moduleSet){
			debug debugLog("running %s init at [%0.8X]",mod.getName,cast(void*)moduleInfo);
			this.initModule(moduleInfo,0);
		}
		
		//re-throw if need be
		if(exception) throw exception;
	}
	
	/**
		Loads a library for the filename. 
		
		If the attrStdVersion parameter is supplied this is matched against the "std.version" 
		attribute in the supplied library.  If the attribute doesn't exist, and or the
		attrStdVersion attribute is omitted or set to "", then the library is loaded anyway.
		Otherwise, should attrStdVersion not match the "std.version" attribute, the method
		throws an exception.		
		
		Params:
		filename = the filename of the library to load
		attrStdVersion = (optional) value to match to attribute "std.version" in the loaded library.
	*/
	public DynamicLibrary load(char[] filename,char[] attrStdVersion = ""){
		DynamicLibrary result = registry.load(filename,attrStdVersion);
		return result;
	}
	
	/**
		Registers a library with the linker to be used during link operations.
	*/
	public void register(DynamicLibrary lib){
		debug foreach(DynamicModule mod; lib.getModules){
			debugLog("[Linker.register]: %s",mod.getName);
		}
		libraries ~= lib;
	}
		
	
	/** 
		Loads a DDL library and registers it with this linker.
		
		Returns: the DynamicLibrary that corresponds to filename
		Params:
			filename = the file name of the library to load
	*/
	public DynamicLibrary loadAndRegister(char[] filename,char[] attrStdVersion = ""){
		DynamicLibrary result = registry.load(filename,attrStdVersion);
		register(result);
		return result;
	}
	
	/** 
		Loads a DDL library and links it against all registered libraries.
		
		Returns: the DynamicLibrary that corresponds to filename
		Params:
			filename = the file name of the library to load
	*/
	public DynamicLibrary loadAndLink(char[] filename,char[] attrStdVersion = ""){
		DynamicLibrary result = registry.load(filename,attrStdVersion);
		link(result);
		return result;
	}
	
	/** 
		Loads a DDL library, links it against all registered libraries, and registers it.
		
		Returns: the DynamicLibrary that corresponds to filename
		Params:
			filename = the file name of the library to load
	*/
	public DynamicLibrary loadLinkAndRegister(char[] filename,char[] attrStdVersion = ""){
		DynamicLibrary result = registry.load(filename,attrStdVersion);
		link(result);
		register(result);
		return result;
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
