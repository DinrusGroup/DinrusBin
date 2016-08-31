/*
 * This file is part of gtkD.
 *
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
// generated automatically - do not change
// find conversion definition on APILookup.txt
// implement new conversion functionalities on the wrap.utils pakage

/*
 * Conversion parameters:
 * inFile  = 
 * outPack = gtk
 * outFile = TreeModel
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = 
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gobject.Type
 * 	- gtkD.gobject.ObjectG
 * 	- gtkD.gobject.Signals
 * 	- gtkD.gobject.Value
 * 	- gtkD.gtk.TreeIter
 * 	- gtkD.gtk.TreePath
 * 	- gtkD.gtk.TreeModelT
 * 	- gtkD.gtk.TreeModelIF
 * 	- gtkD.gtkc.gobject
 * 	- gtkD.gtkc.Loader
 * 	- gtkD.gtkc.paths
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.TreeModel;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.gobject.Type;
private import gtkD.gobject.ObjectG;
private import gtkD.gobject.Signals;
private import gtkD.gobject.Value;
private import gtkD.gtk.TreeIter;
private import gtkD.gtk.TreePath;
private import gtkD.gtk.TreeModelT;
private import gtkD.gtk.TreeModelIF;
private import gtkD.gtkc.gobject;
private import gtkD.gtkc.Loader;
private import gtkD.gtkc.paths;




struct CustomTreeModelClass
{
	GObjectClass parentClass;
}

//We need this function for the interface implementation.
extern(C) typedef GType function()c_gtk_tree_model_get_type;
c_gtk_tree_model_get_type gtk_tree_model_get_type;

/**
 */
public class TreeModel : ObjectG, TreeModelIF
{
	static GObjectClass* parentClass = null;
	
	static this()
	{
		Linker.link(gtk_tree_model_get_type, "gtk_tree_model_get_type", LIBRARY.GTK);
	}
	
	// Minimal implementation.
	mixin TreeModelT!(GtkTreeModel);
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gtkTreeModel;
	}
	
	public this ()
	{
		auto p =  super(customTreeModelgetType(), null);
		gtkTreeModel = cast(GtkTreeModel*) p.getObjectGStruct();
		
		objectGSetDataFull("customTreeModel", cast(void*)this);
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTreeModel* gtkTreeModel)
	{
		if(gtkTreeModel is null)
		{
			this = null;
			return;
		}
		
		//Check if there already is a D object for this gtk struct
		void* ptr = g_object_get_data(cast(GObject*) gtkTreeModel, Str.toStringz("customTreeModel"));
		if( ptr !is null )
		{
			this = cast(TreeModel)ptr;
			return;
		}
		
		super(cast(GObject*)gtkTreeModel);
		this.gtkTreeModel = gtkTreeModel;
	}
	
	
	extern(C)
	{
		/*
		 *  here we register our new type and its interfaces
		 *  with the type system. If you want to implement
		 *  additional interfaces like GtkTreeSortable, you
		 *  will need to do it here.
		 */
		
		static GType customTreeModelgetType()
		{
			GType customTreeModelType = Type.fromName("CustomTreeModel");
			
			/* Some boilerplate type registration stuff */
			if (customTreeModelType == GType.INVALID)
			{
				static GTypeInfo customTreeModelInfo =
				{
					CustomTreeModelClass.sizeof,                   /* class size */
					null,                                          /* base_init */
					null,                                          /* base_finalize */
					cast(GClassInitFunc) &customTreeModelClassInit,/* class init function */
					null,                                          /* class finalize */
					null,                                          /* class_data */
					CustomTreeModelClass.sizeof + 5,               /* instance size */
					0,                                             /* n_preallocs */
					cast(GInstanceInitFunc) &customTreeModelInit   /* instance init */
				};
				static GInterfaceInfo treeModelInfo =
				{
					cast(GInterfaceInitFunc) &customTreeModelInit,
					null,
					null
				};
				
				/* First register the new derived type with the GObject type system */
				customTreeModelType = Type.registerStatic (GType.OBJECT, "CustomTreeModel",
				&customTreeModelInfo, cast(GTypeFlags)0);
				
				/* Now register our GtkTreeModel interface with the type system */
				Type.addInterfaceStatic (customTreeModelType, gtk_tree_model_get_type() /*GTK_TYPE_TREE_MODEL*/, &treeModelInfo);
			}
			
			return customTreeModelType;
		}
		
		/*
		 *  boilerplate GObject/GType stuff.
		 *  Init callback for the type system,
		 *  called once when our new class is created.
		 */
		
		static void customTreeModelClassInit (void* klass)
		{
			GObjectClass* objectClass;
			
			parentClass = cast(GObjectClass*) Type.classPeekParent(klass);
			objectClass = cast(GObjectClass*) klass;
			
			objectClass.finalize = &customTreeModelFinalize;
		}
		
		/*
		 *  init callback for the interface registration
		 *  in customTreeModelGetType. Here we override
		 *  the GtkTreeModel interface functions that
		 *  we implement.
		 */
		
		static void customTreeModelInit (GtkTreeModelIface *iface)
		{
			iface.getFlags      = &customTreeModelGetFlags;
			iface.getNColumns   = &customTreeModelGetNColumns;
			iface.getColumnType = &customTreeModelGetColumnType;
			iface.getIter       = &customTreeModelGetIter;
			iface.getPath       = &customTreeModelGetPath;
			iface.getValue      = &customTreeModelGetValue;
			iface.iterNext      = &customTreeModelIterNext;
			iface.iterChildren  = &customTreeModelIterChildren;
			iface.iterHasChild  = &customTreeModelIterHasChild;
			iface.iterNChildren = &customTreeModelIterNChildren;
			iface.iterNthChild  = &customTreeModelIterNthChild;
			iface.iterParent    = &customTreeModelIterParent;
		}
		
		/*
		 *  this is called just before a custom list is
		 *  destroyed. Free dynamically allocated memory here.
		 */
		
		static void customTreeModelFinalize (GObject *object)
		{
			/* must chain up - finalize parent */
			parentClass.finalize(object);
		}
		
		static GtkTreeModelFlags customTreeModelGetFlags(GtkTreeModel *tree_model)
		{
			auto tm = new TreeModel(tree_model);
			
			return tm.getFlags();
		}
		
		static int customTreeModelGetNColumns(GtkTreeModel *tree_model)
		{
			auto tm = new TreeModel(tree_model);
			
			return tm.getNColumns();
		}
		
		static GType customTreeModelGetColumnType(GtkTreeModel *tree_model, int index)
		{
			auto tm = new TreeModel(tree_model);
			
			return tm.getColumnType(index);
		}
		
		static gboolean customTreeModelGetIter(GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreePath *path)
		{
			auto tm = new TreeModel(tree_model);
			
			return tm.getIter(new TreeIter(iter), new TreePath(path));
		}
		
		static GtkTreePath* customTreeModelGetPath(GtkTreeModel *tree_model, GtkTreeIter *iter)
		{
			auto tm = new TreeModel(tree_model);
			TreePath path = tm.getPath(new TreeIter(iter));
			
			return (path is null) ? null : path.getTreePathStruct();
		}
		
		static void customTreeModelGetValue(GtkTreeModel *tree_model, GtkTreeIter *iter, int column, GValue *value)
		{
			auto tm = new TreeModel(tree_model);
			
			tm.getValue(new TreeIter(iter), column, new Value(value));
		}
		
		static gboolean customTreeModelIterNext(GtkTreeModel *tree_model, GtkTreeIter *iter)
		{
			auto tm = new TreeModel(tree_model);
			
			return tm.iterNext(new TreeIter(iter));
		}
		
		static gboolean customTreeModelIterChildren(GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent)
		{
			auto tm = new TreeModel(tree_model);
			
			return tm.iterChildren(new TreeIter(iter), new TreeIter(parent));
		}
		
		static gboolean customTreeModelIterHasChild(GtkTreeModel *tree_model, GtkTreeIter *iter)
		{
			auto tm = new TreeModel(tree_model);
			
			return tm.iterHasChild(new TreeIter(iter));
		}
		
		static int customTreeModelIterNChildren(GtkTreeModel *tree_model, GtkTreeIter *iter)
		{
			auto tm = new TreeModel(tree_model);
			
			return tm.iterNChildren(new TreeIter(iter));
		}
		
		static gboolean customTreeModelIterNthChild(GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *parent, int n)
		{
			auto tm = new TreeModel(tree_model);
			
			return tm.iterNthChild(new TreeIter(iter), new TreeIter(parent), n);
		}
		
		static gboolean customTreeModelIterParent(GtkTreeModel *tree_model, GtkTreeIter *iter, GtkTreeIter *child)
		{
			auto tm = new TreeModel(tree_model);
			
			return tm.iterParent(new TreeIter(iter), new TreeIter(child));
		}
	}
}

/**
 */


version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gtk");
        } else version (DigitalMars) {
            pragma(link, "DD-gtk");
        } else {
            pragma(link, "DO-gtk");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gtk");
        } else version (DigitalMars) {
            pragma(link, "DD-gtk");
        } else {
            pragma(link, "DO-gtk");
        }
    }
}
