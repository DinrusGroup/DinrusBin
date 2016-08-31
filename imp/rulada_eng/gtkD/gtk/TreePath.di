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
 * inFile  = GtkTreeModel.html
 * outPack = gtk
 * outFile = TreePath
 * strct   = GtkTreePath
 * realStrct=
 * ctorStrct=
 * clss    = TreePath
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_tree_path_
 * omit structs:
 * omit prefixes:
 * omit code:
 * 	- gtk_tree_path_new
 * 	- gtk_tree_path_new_first
 * omit signals:
 * 	- row-changed
 * 	- row-deleted
 * 	- row-has-child-toggled
 * 	- row-inserted
 * 	- rows-reordered
 * imports:
 * 	- gtkD.glib.Str
 * structWrap:
 * 	- GtkTreePath* -> TreePath
 * module aliases:
 * local aliases:
 * overrides:
 * 	- toString
 */

module gtkD.gtk.TreePath;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;




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
public class TreePath
{
	
	/** the main Gtk struct */
	protected GtkTreePath* gtkTreePath;
	
	
	public GtkTreePath* getTreePathStruct()
	{
		return gtkTreePath;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)gtkTreePath;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GtkTreePath* gtkTreePath)
	{
		if(gtkTreePath is null)
		{
			this = null;
			return;
		}
		this.gtkTreePath = gtkTreePath;
	}
	
	/**
	 * Creates a new GtkTreePath. This structure refers to a row.
	 * Params:
	 * firstRow = if true this is the string representation of this path is "0"
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (bool firstRow=false)
	{
		GtkTreePath* p;
		
		if ( firstRow )
		{
			// GtkTreePath* gtk_tree_path_new_first (void);
			p = cast(GtkTreePath*)gtk_tree_path_new_first();
		}
		else
		{
			// GtkTreePath* gtk_tree_path_new (void);
			p = cast(GtkTreePath*)gtk_tree_path_new();
		}
		
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_tree_path_new()");
		}
		
		this(p);
	}
	
	/**
	 */
	
	/**
	 * Creates a new GtkTreePath initialized to path. path is expected to be a
	 * colon separated list of numbers. For example, the string "10:4:0" would
	 * create a path of depth 3 pointing to the 11th child of the root node, the 5th
	 * child of that 11th child, and the 1st child of that 5th child. If an invalid
	 * path string is passed in, NULL is returned.
	 * Params:
	 * path =  The string representation of a path.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string path)
	{
		// GtkTreePath * gtk_tree_path_new_from_string (const gchar *path);
		auto p = gtk_tree_path_new_from_string(Str.toStringz(path));
		if(p is null)
		{
			throw new ConstructionException("null returned by gtk_tree_path_new_from_string(Str.toStringz(path))");
		}
		this(cast(GtkTreePath*) p);
	}
	
	/**
	 * Generates a string representation of the path. This string is a ':'
	 * separated list of numbers. For example, "4:10:0:3" would be an acceptable return value for this string.
	 * Returns: A newly-allocated string. Must be freed with g_free().
	 */
	public override string toString()
	{
		// gchar * gtk_tree_path_to_string (GtkTreePath *path);
		return Str.toString(gtk_tree_path_to_string(gtkTreePath));
	}
	
	/**
	 * Appends a new index to a path. As a result, the depth of the path is
	 * increased.
	 * Params:
	 * index =  The index.
	 */
	public void appendIndex(int index)
	{
		// void gtk_tree_path_append_index (GtkTreePath *path,  gint index_);
		gtk_tree_path_append_index(gtkTreePath, index);
	}
	
	/**
	 * Prepends a new index to a path. As a result, the depth of the path is
	 * increased.
	 * Params:
	 * index =  The index.
	 */
	public void prependIndex(int index)
	{
		// void gtk_tree_path_prepend_index (GtkTreePath *path,  gint index_);
		gtk_tree_path_prepend_index(gtkTreePath, index);
	}
	
	/**
	 * Returns the current depth of path.
	 * Returns: The depth of path
	 */
	public int getDepth()
	{
		// gint gtk_tree_path_get_depth (GtkTreePath *path);
		return gtk_tree_path_get_depth(gtkTreePath);
	}
	
	/**
	 * Returns the current indices of path. This is an array of integers, each
	 * representing a node in a tree. This value should not be freed.
	 * Returns: The current indices, or NULL.
	 */
	public int[] getIndices()
	{
		// gint * gtk_tree_path_get_indices (GtkTreePath *path);
		auto p = gtk_tree_path_get_indices(gtkTreePath);
		return p[0 .. getDepth()];
	}
	
	/**
	 * Frees path.
	 */
	public void free()
	{
		// void gtk_tree_path_free (GtkTreePath *path);
		gtk_tree_path_free(gtkTreePath);
	}
	
	/**
	 * Creates a new GtkTreePath as a copy of path.
	 * Returns: A new GtkTreePath.
	 */
	public TreePath copy()
	{
		// GtkTreePath * gtk_tree_path_copy (const GtkTreePath *path);
		auto p = gtk_tree_path_copy(gtkTreePath);
		if(p is null)
		{
			return null;
		}
		return new TreePath(cast(GtkTreePath*) p);
	}
	
	/**
	 * Compares two paths. If a appears before b in a tree, then -1 is returned.
	 * If b appears before a, then 1 is returned. If the two nodes are equal,
	 * then 0 is returned.
	 * Params:
	 * a =  A GtkTreePath.
	 * b =  A GtkTreePath to compare with.
	 * Returns: The relative positions of a and b
	 */
	public int compare(TreePath b)
	{
		// gint gtk_tree_path_compare (const GtkTreePath *a,  const GtkTreePath *b);
		return gtk_tree_path_compare(gtkTreePath, (b is null) ? null : b.getTreePathStruct());
	}
	
	/**
	 * Moves the path to point to the next node at the current depth.
	 */
	public void next()
	{
		// void gtk_tree_path_next (GtkTreePath *path);
		gtk_tree_path_next(gtkTreePath);
	}
	
	/**
	 * Moves the path to point to the previous node at the current depth,
	 * if it exists.
	 * Returns: TRUE if path has a previous node, and the move was made.
	 */
	public int prev()
	{
		// gboolean gtk_tree_path_prev (GtkTreePath *path);
		return gtk_tree_path_prev(gtkTreePath);
	}
	
	/**
	 * Moves the path to point to its parent node, if it has a parent.
	 * Returns: TRUE if path has a parent, and the move was made.
	 */
	public int up()
	{
		// gboolean gtk_tree_path_up (GtkTreePath *path);
		return gtk_tree_path_up(gtkTreePath);
	}
	
	/**
	 * Moves path to point to the first child of the current path.
	 */
	public void down()
	{
		// void gtk_tree_path_down (GtkTreePath *path);
		gtk_tree_path_down(gtkTreePath);
	}
	
	/**
	 * Returns TRUE if descendant is a descendant of path.
	 * Params:
	 * descendant =  another GtkTreePath
	 * Returns: TRUE if descendant is contained inside path
	 */
	public int isAncestor(TreePath descendant)
	{
		// gboolean gtk_tree_path_is_ancestor (GtkTreePath *path,  GtkTreePath *descendant);
		return gtk_tree_path_is_ancestor(gtkTreePath, (descendant is null) ? null : descendant.getTreePathStruct());
	}
	
	/**
	 * Returns TRUE if path is a descendant of ancestor.
	 * Params:
	 * ancestor =  another GtkTreePath
	 * Returns: TRUE if ancestor contains path somewhere below it
	 */
	public int isDescendant(TreePath ancestor)
	{
		// gboolean gtk_tree_path_is_descendant (GtkTreePath *path,  GtkTreePath *ancestor);
		return gtk_tree_path_is_descendant(gtkTreePath, (ancestor is null) ? null : ancestor.getTreePathStruct());
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
