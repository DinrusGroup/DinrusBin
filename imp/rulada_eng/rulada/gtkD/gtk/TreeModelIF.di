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
 * outFile = TreeModelIF
 * strct   = GtkTreeModel
 * realStrct=
 * ctorStrct=
 * clss    = TreeModelT
 * interf  = TreeModelIF
 * class Code: Yes
 * interface Code: Yes
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_tree_model_
 * omit structs:
 * omit prefixes:
 * 	- gtk_tree_row_reference_
 * 	- gtk_tree_path_
 * 	- gtk_tree_iter_
 * omit code:
 * 	- gtk_tree_model_get_iter
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.gtk.TreeIter
 * 	- gtkD.gtk.TreePath
 * 	- gtkD.gobject.Value
 * structWrap:
 * 	- GValue* -> Value
 * 	- GtkTreeIter* -> TreeIter
 * 	- GtkTreePath* -> TreePath
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gtk.TreeModelIF;

public  import gtkD.gtkc.gtktypes;

private import gtkD.gtkc.gtk;
private import gtkD.glib.ConstructionException;

private import gtkD.gobject.Signals;
public  import gtkD.gtkc.gdktypes;

private import gtkD.glib.Str;
private import gtkD.gtk.TreeIter;
private import gtkD.gtk.TreePath;
private import gtkD.gobject.Value;




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
public interface TreeModelIF
{
	
	
	public GtkTreeModel* getTreeModelTStruct();
	
	/** the main Gtk struct as a void* */
	protected void* getStruct();
	
	
	/**
	 * Get the value of a column as a char array.
	 * this is the same calling getValue and get the string from the value object
	 */
	string getValueString(TreeIter iter, int column);
	
	/**
	 * Get the value of a column as a char array.
	 * this is the same calling getValue and get the int from the value object
	 */
	int getValueInt(TreeIter iter, int column);
	
	/**
	 * Sets iter to a valid iterator pointing to path.
	 * Params:
	 *  iter = The uninitialized GtkTreeIter.
	 *  path = The GtkTreePath.
	 * Returns:
	 *  TRUE, if iter was set.
	 */
	public int getIter(TreeIter iter, TreePath path);
	
	/**
	 */
	
	void delegate(TreePath, TreeIter, TreeModelIF)[] onRowChangedListeners();
	/**
	 * This signal is emitted when a row in the model has changed.
	 */
	void addOnRowChanged(void delegate(TreePath, TreeIter, TreeModelIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	void delegate(TreePath, TreeModelIF)[] onRowDeletedListeners();
	/**
	 * This signal is emitted when a row has been deleted.
	 * Note that no iterator is passed to the signal handler,
	 * since the row is already deleted.
	 * Implementations of GtkTreeModel must emit row-deleted
	 * before removing the node from its
	 * internal data structures. This is because models and
	 * views which access and monitor this model might have
	 * references on the node which need to be released in the
	 * row-deleted handler.
	 */
	void addOnRowDeleted(void delegate(TreePath, TreeModelIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	void delegate(TreePath, TreeIter, TreeModelIF)[] onRowHasChildToggledListeners();
	/**
	 * This signal is emitted when a row has gotten the first child row or lost
	 * its last child row.
	 */
	void addOnRowHasChildToggled(void delegate(TreePath, TreeIter, TreeModelIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	void delegate(TreePath, TreeIter, TreeModelIF)[] onRowInsertedListeners();
	/**
	 * This signal is emitted when a new row has been inserted in the model.
	 * Note that the row may still be empty at this point, since
	 * it is a common pattern to first insert an empty row, and
	 * then fill it with the desired values.
	 */
	void addOnRowInserted(void delegate(TreePath, TreeIter, TreeModelIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	void delegate(TreePath, TreeIter, gpointer, TreeModelIF)[] onRowsReorderedListeners();
	/**
	 * This signal is emitted when the children of a node in the GtkTreeModel
	 * have been reordered.
	 * Note that this signal is not emitted
	 * when rows are reordered by DND, since this is implemented
	 * by removing and then reinserting the row.
	 * See Also
	 * GtkTreeView, GtkTreeStore, GtkListStore, GtkTreeDnd, GtkTreeSortable
	 * [4]
	 * Here, iter is short for “iterator”
	 */
	void addOnRowsReordered(void delegate(TreePath, TreeIter, gpointer, TreeModelIF) dlg, ConnectFlags connectFlags=cast(ConnectFlags)0);
	
	/**
	 * Returns a set of flags supported by this interface. The flags are a bitwise
	 * combination of GtkTreeModelFlags. The flags supported should not change
	 * during the lifecycle of the tree_model.
	 * Returns: The flags supported by this interface.
	 */
	public GtkTreeModelFlags getFlags();
	
	/**
	 * Returns the number of columns supported by tree_model.
	 * Returns: The number of columns.
	 */
	public int getNColumns();
	
	/**
	 * Returns the type of the column.
	 * Params:
	 * index =  The column index.
	 * Returns: The type of the column.
	 */
	public GType getColumnType(int index);
	
	/**
	 * Sets iter to a valid iterator pointing to path_string, if it
	 * exists. Otherwise, iter is left invalid and FALSE is returned.
	 * Params:
	 * iter =  An uninitialized GtkTreeIter.
	 * pathString =  A string representation of a GtkTreePath.
	 * Returns: TRUE, if iter was set.
	 */
	public int getIterFromString(TreeIter iter, string pathString);
	
	/**
	 * Initializes iter with the first iterator in the tree (the one at the path
	 * "0") and returns TRUE. Returns FALSE if the tree is empty.
	 * Params:
	 * iter =  The uninitialized GtkTreeIter.
	 * Returns: TRUE, if iter was set.
	 */
	public int getIterFirst(TreeIter iter);
	
	/**
	 * Returns a newly-created GtkTreePath referenced by iter. This path should
	 * be freed with gtk_tree_path_free().
	 * Params:
	 * iter =  The GtkTreeIter.
	 * Returns: a newly-created GtkTreePath.
	 */
	public TreePath getPath(TreeIter iter);
	
	/**
	 * Initializes and sets value to that at column.
	 * When done with value, g_value_unset() needs to be called
	 * to free any allocated memory.
	 * Params:
	 * iter =  The GtkTreeIter.
	 * column =  The column to lookup the value at.
	 * value =  An empty GValue to set.
	 */
	public void getValue(TreeIter iter, int column, Value value);
	
	/**
	 * Sets iter to point to the node following it at the current level. If there
	 * is no next iter, FALSE is returned and iter is set to be invalid.
	 * Params:
	 * iter =  The GtkTreeIter.
	 * Returns: TRUE if iter has been changed to the next node.
	 */
	public int iterNext(TreeIter iter);
	
	/**
	 * Sets iter to point to the first child of parent. If parent has no
	 * children, FALSE is returned and iter is set to be invalid. parent
	 * will remain a valid node after this function has been called.
	 * If parent is NULL returns the first node, equivalent to
	 * gtk_tree_model_get_iter_first (tree_model, iter);
	 * Params:
	 * iter =  The new GtkTreeIter to be set to the child.
	 * parent =  The GtkTreeIter, or NULL
	 * Returns: TRUE, if child has been set to the first child.
	 */
	public int iterChildren(TreeIter iter, TreeIter parent);
	
	/**
	 * Returns TRUE if iter has children, FALSE otherwise.
	 * Params:
	 * iter =  The GtkTreeIter to test for children.
	 * Returns: TRUE if iter has children.
	 */
	public int iterHasChild(TreeIter iter);
	
	/**
	 * Returns the number of children that iter has. As a special case, if iter
	 * is NULL, then the number of toplevel nodes is returned.
	 * Params:
	 * iter =  The GtkTreeIter, or NULL.
	 * Returns: The number of children of iter.
	 */
	public int iterNChildren(TreeIter iter);
	
	/**
	 * Sets iter to be the child of parent, using the given index. The first
	 * index is 0. If n is too big, or parent has no children, iter is set
	 * to an invalid iterator and FALSE is returned. parent will remain a valid
	 * node after this function has been called. As a special case, if parent is
	 * NULL, then the nth root node is set.
	 * Params:
	 * iter =  The GtkTreeIter to set to the nth child.
	 * parent =  The GtkTreeIter to get the child from, or NULL.
	 * n =  Then index of the desired child.
	 * Returns: TRUE, if parent has an nth child.
	 */
	public int iterNthChild(TreeIter iter, TreeIter parent, int n);
	
	/**
	 * Sets iter to be the parent of child. If child is at the toplevel, and
	 * doesn't have a parent, then iter is set to an invalid iterator and FALSE
	 * is returned. child will remain a valid node after this function has been
	 * called.
	 * Params:
	 * iter =  The new GtkTreeIter to set to the parent.
	 * child =  The GtkTreeIter.
	 * Returns: TRUE, if iter is set to the parent of child.
	 */
	public int iterParent(TreeIter iter, TreeIter child);
	
	/**
	 * Generates a string representation of the iter. This string is a ':'
	 * separated list of numbers. For example, "4:10:0:3" would be an
	 * acceptable return value for this string.
	 * Since 2.2
	 * Params:
	 * iter =  An GtkTreeIter.
	 * Returns: A newly-allocated string. Must be freed with g_free().
	 */
	public string getStringFromIter(TreeIter iter);
	
	/**
	 * Lets the tree ref the node. This is an optional method for models to
	 * implement. To be more specific, models may ignore this call as it exists
	 * primarily for performance reasons.
	 * This function is primarily meant as a way for views to let caching model
	 * know when nodes are being displayed (and hence, whether or not to cache that
	 * node.) For example, a file-system based model would not want to keep the
	 * entire file-hierarchy in memory, just the sections that are currently being
	 * displayed by every current view.
	 * A model should be expected to be able to get an iter independent of its
	 * reffed state.
	 * Params:
	 * iter =  The GtkTreeIter.
	 */
	public void refNode(TreeIter iter);
	
	/**
	 * Lets the tree unref the node. This is an optional method for models to
	 * implement. To be more specific, models may ignore this call as it exists
	 * primarily for performance reasons.
	 * For more information on what this means, see gtk_tree_model_ref_node().
	 * Please note that nodes that are deleted are not unreffed.
	 * Params:
	 * iter =  The GtkTreeIter.
	 */
	public void unrefNode(TreeIter iter);
	
	/**
	 * See gtk_tree_model_get(), this version takes a va_list
	 * for language bindings to use.
	 * Params:
	 * iter =  a row in tree_model
	 * varArgs =  va_list of column/return location pairs
	 */
	public void getValist(TreeIter iter, void* varArgs);
	
	/**
	 * Calls func on each node in model in a depth-first fashion.
	 * If func returns TRUE, then the tree ceases to be walked, and
	 * gtk_tree_model_foreach() returns.
	 * Params:
	 * func =  A function to be called on each row
	 * userData =  User data to passed to func.
	 */
	public void foreac(GtkTreeModelForeachFunc func, void* userData);
	
	/**
	 * Emits the "row-changed" signal on tree_model.
	 * Params:
	 * path =  A GtkTreePath pointing to the changed row
	 * iter =  A valid GtkTreeIter pointing to the changed row
	 */
	public void rowChanged(TreePath path, TreeIter iter);
	
	/**
	 * Emits the "row-inserted" signal on tree_model
	 * Params:
	 * path =  A GtkTreePath pointing to the inserted row
	 * iter =  A valid GtkTreeIter pointing to the inserted row
	 */
	public void rowInserted(TreePath path, TreeIter iter);
	
	/**
	 * Emits the "row-has-child-toggled" signal on tree_model. This should be
	 * called by models after the child state of a node changes.
	 * Params:
	 * path =  A GtkTreePath pointing to the changed row
	 * iter =  A valid GtkTreeIter pointing to the changed row
	 */
	public void rowHasChildToggled(TreePath path, TreeIter iter);
	
	/**
	 * Emits the "row-deleted" signal on tree_model. This should be called by
	 * models after a row has been removed. The location pointed to by path
	 * should be the location that the row previously was at. It may not be a
	 * valid location anymore.
	 * Params:
	 * path =  A GtkTreePath pointing to the previous location of the deleted row.
	 */
	public void rowDeleted(TreePath path);
	
	/**
	 * Emits the "rows-reordered" signal on tree_model. This should be called by
	 * models when their rows have been reordered.
	 * Params:
	 * path =  A GtkTreePath pointing to the tree node whose children have been
	 *  reordered
	 * iter =  A valid GtkTreeIter pointing to the node whose children have been
	 *  reordered, or NULL if the depth of path is 0.
	 * newOrder =  an array of integers mapping the current position of each child
	 *  to its old position before the re-ordering,
	 *  i.e. new_order[newpos] = oldpos.
	 * Signal Details
	 * The "row-changed" signal
	 * void user_function (GtkTreeModel *tree_model,
	 *  GtkTreePath *path,
	 *  GtkTreeIter *iter,
	 *  gpointer user_data) : Run Last
	 * This signal is emitted when a row in the model has changed.
	 * path =  a GtkTreePath identifying the changed row
	 * iter =  a valid GtkTreeIter pointing to the changed row
	 */
	public void rowsReordered(TreePath path, TreeIter iter, int[] newOrder);
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
