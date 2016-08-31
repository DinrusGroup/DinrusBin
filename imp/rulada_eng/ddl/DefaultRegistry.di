/**
	Default loader registry implemenation, suitable for quick prototyping or
	kitchen-sink style support for DDL loading.
	
	Authors: Eric Anderton
	License: BSD Derivative (see source for details)
	Copyright: 2005-2006 Eric Anderton
*/
module ddl.DefaultRegistry;

private import ddl.LoaderRegistry;
private import ddl.ar.ArchiveLoader;
private import ddl.omf.OMFLoader;
private import ddl.ddl.DDLLoader;
private import ddl.elf.ELFObjLoader;
private import ddl.insitu.InSituLoader;
//private import ddl.coff.COFFLoader;

class DefaultRegistry : LoaderRegistry{
	public this(){
		version(Windows){ // order optimized per OS
			register(new OMFLibLoader());
			register(new OMFObjLoader());
			register(new DDLLoader());
			register(new InSituLibLoader());
			register(new InSituMapLoader());
			register(new ArchiveLoader());			
	//		register(new COFFObjLoader());			
	//		register(new ELFObjLoader());			
		}
		else{
			register(new ArchiveLoader());
			register(new ELFObjLoader());
			register(new DDLLoader());
			register(new InSituLibLoader());			
			register(new OMFLibLoader());
			register(new OMFObjLoader());
			register(new InSituMapLoader());			
	//		register(new COFFObjLoader());			
		}
	}
}

