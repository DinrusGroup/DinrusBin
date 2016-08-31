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
 * outFile = TreeRowReference
 * strct   = GtkTreeRowReference
 * realStrct=
 * ctorStrct=
 * clss    = TreeRowReference
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_tree_row_reference_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * 	- row-changed
 * 	- row-deleted
 * 	- row-has-child-toggled
 * 	- row-inserted
 * 	- rows-reordered
 * imports:
 * 	- gtkD.gtk.TreeModel
 * 	- gtkD.gtk.TreeModelIF
 * 	- gtkD.gtk.TreePath
 * 	- gtkD.gobject.ObjectG
 * 	- gtkD.gtk.TreeIter
 * structWrap:
 * 	- GObject* -> ObjectG
 * 	- GtkTreeIter* -> TreeIter
 * 	- GtkTreeModel* -> TreeModelIF
 * 	- GtkTreePath* -> TreePath
 * 	- GtkTreeRowReference* -> TreeRowReference
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.TreeRowReference;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.gtk.TreeModel;
private import gtkD.gtk.TreeModelIF;
private import gtkD.gtk.TreePath;
private import gtkD.gobject.ObjectG;
private import gtkD.gtk.TreeIter;




/**
 * Description
 * The GtkTreeModel interface defines a generic tree interface for use by
 * the GtkTreeView widget. It is an abstract interface, and is designed
 * to be usable with any appropriate data structure. The programmer just
 * has to implement this interface on their own data type for it to be
 * viewable by a GtkTreeView widget.
 * The model is represented as a hierarchical tree of strongly-typed,
 * columned data. In other words, the model can be seen as a tree where
 * every node has different values depending on which column is being
 * queried. The type of data found in a column is determined by using the
 * GType system (ie. G_TYPE_INT, GTK_TYPE_BUTTON, G_TYPE_POINTER, etc.).
 * The types are homogeneous per column across all nodes. It is important
 * to note that this interface only provides a way of examining a model and
 * observing changes. The implementation of each individual model decides
 * how and if changes are made.
 * In order to make life simpler for programmers who do not need to write
 * their own specialized model, two generic models are provided — the
 * GtkTreeStore and the GtkListStore. To use these, the developer simply
 * pushes data into these models as necessary. These models provide the
 * data structure as well as all appropriate tree interfaces. As a result,
 * implementing drag and drop, sorting, and storing data is trivial. For
 * the vast majority of trees and lists, these two models are sufficient.
 * Models are accessed on a node/column level of granularity. One can
 * query for the value of a model at a certain node and a certain column
 * on that node. There are two structures used to reference a particular
 * node in a model. They are the GtkTreePath and the GtkTreeIter
 * [4]
 * Most of the interface consists of operations on a GtkTreeIter.
 * A path is essentially a potential node. It is a location on a model
 * that may or may not actually correspond to a node on a specific model.
 * The GtkTreePath struct can be converted into either an array of
 * unsigned integers or a string. The string form is a list of numbers
 * separated by a colon. Each number refers to the offset at that level.
 * Thus, the path “0” refers to the root node and the path
 * “2:4” refers to the fifth child of the third node.
 * By contrast, a GtkTreeIter is a reference to a specific node on a
 * specific model. It is a generic struct with an integer and three
 * generic pointers. These are filled in by the model in a model-specific
 * way. One can convert a path to an iterator by calling
 * gtk_tree_model_get_iter(). These iterators are the primary way of
 * accessing a model and are similar to the iterators used by
 * GtkTextBuffer. They are generally statically allocated on the stack and
 * only used for a short time. The model interface defines a set of
 * operations using them for navigating the model.
 * It is expected that models fill in the iterator with private data. For
 * example, the GtkListStore model, which is internally a simple linked
 * list, stores a list node in one of the pointers. The GtkTreeModelSort
 * stores an array and an offset in two of the pointers. Additionally,
 * there is an integer field. This field is generally filled with a unique
 * stamp per model. This stamp is for catching errors resulting from using
 * invalid iterators with a model.
 * The lifecycle of an iterator can be a little confusing at first.
 * Iterators are expected to always be valid for as long as the model is
 * unchanged (and doesn't emit a signal). The model is considered to own
 * all outstanding iterators and nothing needs to be done to free them from
 * the user's point of view. Additionally, some models guarantee that an
 * iterator is valid for as long as the node it refers to is valid (most
 * notably the GtkTreeStore and GtkListStore). Although generally
 * uninteresting, as one always has to allow for the case where iterators
 * do not persist beyond a signal, some very important performance
 * enhancements were made in the sort model. As a result, the
 * GTK_TREE_MODEL_ITERS_PERSIST flag was added to indicate this behavior.
 * To help show some common operation of a model, some examples are
 * provided. The first example shows three ways of getting the iter at the
 * location “3:2:5”. While the first method shown is easier,
 * the second is much more common, as you often get paths from callbacks.
 * Example 20. Acquiring a GtkTreeIter
 * /+* Three ways of getting the iter pointing to the location
 *  +/
 * {
	 *  GtkTreePath *path;
	 *  GtkTreeIter iter;
	 *  GtkTreeIter parent_iter;
	 *  /+* get the iterator from a string +/
	 *  gtk_tree_model_get_iter_from_string (model, iter, "3:2:5");
	 *  /+* get the iterator from a path +/
	 *  path = gtk_tree_path_new_from_string ("3:2:5");
	 *  gtk_tree_model_get_iter (model, iter, path);
	 *  gtk_tree_path_free (path);
	 *  /+* walk the tree to find the iterator +/
	 *  gtk_tree_model_iter_nth_child (model, iter, NULL, 3);
	 *  parent_iter = iter;
	 *  gtk_tree_model_iter_nth_child (model, iter, parent_iter, 2);
	 *  parent_iter = iter;
	 *  gtk_tree_model_iter_nth_child (model, iter, parent_iter, 5);
 * }
 * This second example shows a quick way of iterating through a list and
 * getting a string and an integer from each row. The
 * populate_model function used below is not shown, as
 * it is specific to the GtkListStore. For information on how to write
 * such a function, see the GtkListStore documentation.
 * Example 21. Reading data from a GtkTreeModel
 * enum
 * {
	 *  STRING_COLUMN,
	 *  INT_COLUMN,
	 *  N_COLUMNS
 * };
 * {
	 *  GtkTreeModel *list_store;
	 *  GtkTreeIter iter;
	 *  gboolean valid;
	 *  gint row_count = 0;
	 *  /+* make a new list_store +/
	 *  list_store = gtk_list_store_new (N_COLUMNS, G_TYPE_STRING, G_TYPE_INT);
	 *  /+* Fill the list store with data +/
	 *  populate_model (list_store);
	 *  /+* Get the first iter in the list +/
	 *  valid = gtk_tree_model_get_iter_first (list_store, iter);
	 *  while (valid)
	 *  {
		 *  /+* Walk through the list, reading each row +/
		 *  gchar *str_data;
		 *  gint int_data;
		 *  /+* Make sure you terminate calls to gtk_tree_model_get()
		 *  * with a '-1' value
		 *  +/
		 *  gtk_tree_model_get (list_store, iter,
		 *  STRING_COLUMN, str_data,
		 *  INT_COLUMN, int_data,
		 *  -1);
		 *  /+* Do something with the data +/
		 *  g_print ("Row %d: (%s,%d)\n", row_count, str_data, int_data);
		 *  g_free (str_data);
		 *  row_count ++;
		 *  valid = gtk_tree_model_iter_next (list_store, iter);
	 *  }
 * }
 */
public class TreeRowReference
{
	
	/** the main Gtk struct */
	protected GtkTreeRowReference* gtkTreeRowReference;
	
	
	public GtkTreeRowReference* getTreeRowReferenceStruct()
	{
		return gtkTreeRowReference;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)gtkTreeRowReference;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTreeRowReference* gtkTreeRowReference)
	{
		if(gtkTreeRowReference is null)
		{
			this = null;
			return;
		}
		this.gtkTreeRowReference = gtkTreeRowReference;
	}
	
	/**
	 */
	
	/**
	 * Creates a row reference based on path. This reference will keep pointing
	 * to the node pointed to by path, so long as it exists. It listens to all
	 * signals emitted by model, and updates its path appropriately. If path
	 * isn't a valid path in model, then NULL is returned.
	 * Params:
	 * model =  A GtkTreeModel
	 * path =  A valid GtkTreePath to monitor
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (TreeModelIF model, TreePath path)
	{
		// GtkTreeRowReference * gtk_tree_row_reference_new (GtkTreeModel *model,  GtkTreePath *path);
		auto p = gtk_tree_row_reference_new((model is null) ? null : model.getTreeModelTStruct(), (path is null) ? null : path.getTreePathStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_tree_row_reference_new((model is null) ? null : model.getTreeModelTStruct(), (path is null) ? null : path.getTreePathStruct())");
		}
		this(cast(GtkTreeRowReference*) p);
	}
	
	/**
	 * You do not need to use this function. Creates a row reference based on
	 * path. This reference will keep pointing to the node pointed to by path,
	 * so long as it exists. If path isn't a valid path in model, then NULL is
	 * returned. However, unlike references created with
	 * gtk_tree_row_reference_new(), it does not listen to the model for changes.
	 * The creator of the row reference must do this explicitly using
	 * gtk_tree_row_reference_inserted(), gtk_tree_row_reference_deleted(),
	 * gtk_tree_row_reference_reordered().
	 * These functions must be called exactly once per proxy when the
	 * corresponding signal on the model is emitted. This single call
	 * updates all row references for that proxy. Since built-in GTK+
	 * objects like GtkTreeView already use this mechanism internally,
	 * using them as the proxy object will produce unpredictable results.
	 * Further more, passing the same object as model and proxy
	 * doesn't work for reasons of internal implementation.
	 * This type of row reference is primarily meant by structures that need to
	 * carefully monitor exactly when a row reference updates itself, and is not
	 * generally needed by most applications.
	 * Params:
	 * proxy =  A proxy GObject
	 * model =  A GtkTreeModel
	 * path =  A valid GtkTreePath to monitor
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (ObjectG proxy, TreeModelIF model, TreePath path)
	{
		// GtkTreeRowReference * gtk_tree_row_reference_new_proxy (GObject *proxy,  GtkTreeModel *model,  GtkTreePath *path);
		auto p = gtk_tree_row_reference_new_proxy((proxy is null) ? null : proxy.getObjectGStruct(), (model is null) ? null : model.getTreeModelTStruct(), (path is null) ? null : path.getTreePathStruct());
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_tree_row_reference_new_proxy((proxy is null) ? null : proxy.getObjectGStruct(), (model is null) ? null : model.getTreeModelTStruct(), (path is null) ? null : path.getTreePathStruct())");
		}
		this(cast(GtkTreeRowReference*) p);
	}
	
	/**
	 * Returns the model that the row reference is monitoring.
	 * Since 2.8
	 * Returns: the model
	 */
	public TreeModelIF getModel()
	{
		// GtkTreeModel * gtk_tree_row_reference_get_model (GtkTreeRowReference *reference);
		auto p = gtk_tree_row_reference_get_model(gtkTreeRowReference);
		if(p is null)
		{
			return null;
		}
		return new TreeModel(cast(GtkTreeModel*) p);
	}
	
	/**
	 * Returns a path that the row reference currently points to, or NULL if the
	 * path pointed to is no longer valid.
	 * Returns: A current path, or NULL.
	 */
	public TreePath getPath()
	{
		// GtkTreePath * gtk_tree_row_reference_get_path (GtkTreeRowReference *reference);
		auto p = gtk_tree_row_reference_get_path(gtkTreeRowReference);
		if(p is null)
		{
			return null;
		}
		return new TreePath(cast(GtkTreePath*) p);
	}
	
	/**
	 * Returns TRUE if the reference is non-NULL and refers to a current valid
	 * path.
	 * Returns: TRUE if reference points to a valid path.
	 */
	public int valid()
	{
		// gboolean gtk_tree_row_reference_valid (GtkTreeRowReference *reference);
		return gtk_tree_row_reference_valid(gtkTreeRowReference);
	}
	
	/**
	 * Free's reference. reference may be NULL.
	 */
	public void free()
	{
		// void gtk_tree_row_reference_free (GtkTreeRowReference *reference);
		gtk_tree_row_reference_free(gtkTreeRowReference);
	}
	
	/**
	 * Copies a GtkTreeRowReference.
	 * Since 2.2
	 * Returns: a copy of reference.
	 */
	public TreeRowReference copy()
	{
		// GtkTreeRowReference * gtk_tree_row_reference_copy (GtkTreeRowReference *reference);
		auto p = gtk_tree_row_reference_copy(gtkTreeRowReference);
		if(p is null)
		{
			return null;
		}
		return new TreeRowReference(cast(GtkTreeRowReference*) p);
	}
	
	/**
	 * Lets a set of row reference created by gtk_tree_row_reference_new_proxy()
	 * know that the model emitted the "row_inserted" signal.
	 * Params:
	 * proxy =  A GObject
	 * path =  The row position that was inserted
	 */
	public static void inserted(ObjectG proxy, TreePath path)
	{
		// void gtk_tree_row_reference_inserted (GObject *proxy,  GtkTreePath *path);
		gtk_tree_row_reference_inserted((proxy is null) ? null : proxy.getObjectGStruct(), (path is null) ? null : path.getTreePathStruct());
	}
	
	/**
	 * Lets a set of row reference created by gtk_tree_row_reference_new_proxy()
	 * know that the model emitted the "row_deleted" signal.
	 * Params:
	 * proxy =  A GObject
	 * path =  The path position that was deleted
	 */
	public static void deleted(ObjectG proxy, TreePath path)
	{
		// void gtk_tree_row_reference_deleted (GObject *proxy,  GtkTreePath *path);
		gtk_tree_row_reference_deleted((proxy is null) ? null : proxy.getObjectGStruct(), (path is null) ? null : path.getTreePathStruct());
	}
	
	/**
	 * Lets a set of row reference created by gtk_tree_row_reference_new_proxy()
	 * know that the model emitted the "rows_reordered" signal.
	 * Params:
	 * proxy =  A GObject
	 * path =  The parent path of the reordered signal
	 * iter =  The iter pointing to the parent of the reordered
	 * newOrder =  The new order of rows
	 */
	public static void reordered(ObjectG proxy, TreePath path, TreeIter iter, int[] newOrder)
	{
		// void gtk_tree_row_reference_reordered (GObject *proxy,  GtkTreePath *path,  GtkTreeIter *iter,  gint *new_order);
		gtk_tree_row_reference_reordered((proxy is null) ? null : proxy.getObjectGStruct(), (path is null) ? null : path.getTreePathStruct(), (iter is null) ? null : iter.getTreeIterStruct(), newOrder.ptr);
	}
}

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
