/*
* The X11/MIT License
* 
* Copyright (c) Marios Hadjieleftheriou
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

module rae.canvas.rtree.RTree;

//Tango imports:

//private import std.stdio;
//import tango.io.Trace.formatln;
import tango.util.log.Trace;//Thread safe console output.
import Float = tango.text.convert.Float;
import Integer = tango.text.convert.Integer;

import tango.math.Math;

//import tango.util.container.LinkedList;

import tango.core.Exception;

alias char[] string;
//private import ptl.string;//private alias char[] string;
//private import ptl.list;

import rae.canvas.PlainRectangle;
import rae.canvas.Rectangle;
//alias Rectangle PlainRectangle;//for now.

import rae.canvas.Point;

import rae.canvas.rtree.Node;
import rae.canvas.rtree.AbstractNode;
import rae.canvas.rtree.Leaf;
import rae.canvas.rtree.Data;
import rae.canvas.rtree.Index;

import rae.canvas.rtree.Comparator;
import rae.canvas.rtree.AblNode;
import rae.canvas.rtree.PageFile;
//private import rae.canvas.rtree.hypercube;
import rae.canvas.rtree.MemoryPageFile;
//private import rae.canvas.exception.illegalargumentexception;
//alias IllegalArgumentException NoSuchElementException;
import rae.canvas.rtree.Sort;

import rae.canvas.ICanvasItem;
public alias ICanvasItem HyperCube;

alias Exception PageFaultError;






/+


//import rae.canvas.rtree.Leaf;

//private import ptl.string;

/**
 * Interface for easy access to common Node information.
 * <p>
 * Created: Tue May 18 16:03:08 1999
 * <p>
 * @author Hadjieleftheriou Marios
 * @version 1.001
 */
 
 
//TODO change to INode because it's an interface.

//public 
interface Node
{
	/** Level of this node. Leaves always have a level equal to 0. */
	protected int level(int set);
	protected int level();
	//protected int m_level = 0;

	/** The pageNumber where the parent of this node is stored. */
	int parent(int set);
	int parent();
	//int m_parent = 0;//protected

	/** The pageNumber where this node is stored. */
	int pageNumber(int set);
	int pageNumber();
	//int m_pageNumber = 0;//protected

	public int[] branches();

    // do not export any Set functions. We want to protect the state of the RTree from outside
    // tampering. Give only basic Get methods.

    //    public Object getChild(int i);

    public Node getParent();//was AbstractNode

    public HyperCube[] getHyperCubes();

	public HyperCube[] data();

    public int getLevel();

    public HyperCube getNodeMbb();

    public char[] getUniqueId();
    
    public int usedSpace();
		public int usedSpace(int set);

	void deleteData(int ind);

    public bool isLeaf();

    public bool isRoot();

    public bool isIndex();

    public char[] toString();

	//Leaf chooseLeaf(HyperCube h);
	//Leaf findLeaf(HyperCube h);
	Node chooseLeaf(HyperCube h);
	Node findLeaf(HyperCube h);

	public void condenseTree( LinkedList!(Node) q );

} // Node









/**
* Implements basic functions of Node interface. Also implements splitting functions.
* <p>
* Created: Tue May 18 15:57:56 1999
* <p>
* @author Hadjieleftheriou Marios
* @version 1.1
*/


//public
//abstract 
class AbstractNode : public Node
{
public:

/** Level of this node. Leaves always have a level equal to 0. */
//protected int level;

/** Parent of all nodes. */
//protected transient RTree tree; //java
protected RTree tree;

/** The pageNumber where the parent of this node is stored. */
//int parent;//protected

/** The pageNumber where this node is stored. */
//int pageNumber;//protected

	/** Level of this node. Leaves always have a level equal to 0. */
	protected int level(int set){ return m_level = set; }
	protected int level(){ return m_level; }
	protected int m_level = 0;

	/** The pageNumber where the parent of this node is stored. */
	int parent(int set) { return m_parent = set; }
	int parent() { return m_parent; }
	int m_parent = 0;//protected

	/** The pageNumber where this node is stored. */
	int pageNumber(int set) { return m_pageNumber = set; }
	int pageNumber() { return m_pageNumber; }
	int m_pageNumber = 0;//protected


/**
* All node data are stored into this array. It must have a size of <B>nodeCapacity + 1</B> to hold
* all data plus an overflow HyperCube, when the node must be split.
*/
protected HyperCube[] m_data;//CanvasItem[] data;//protected

/**
* Holds the pageNumbers containing the children of this node. Always has same size with the data array.
* If this is a Leaf node, than all branches should point to the real data objects.
*/
public int[] branches() { return m_branches; }
protected int[] m_branches;//protected

/** How much space is used up into this node. If equal to nodeCapacity then node is full. */
public int usedSpace() { return m_usedSpace; }
public int usedSpace(int set) { return m_usedSpace = set; }
protected int m_usedSpace;//protected

//
// Initialization.
//

protected this(RTree atree, int parent, int pageNumber, int level)
{
	this.parent = parent;
	this.tree = atree;
	this.pageNumber = pageNumber;
	this.level = level;
	m_data = cast(HyperCube[]) new PlainRectangle[atree.getNodeCapacity()+1];//new HyperCube[atree.getNodeCapacity()+1];
	m_branches = new int[atree.getNodeCapacity()+1];
	usedSpace = 0;
}

//
// Node interface.
//

/**
* Returns the node level. Always zero for leaf nodes.
*
* @return Level of node.
*/
public int getLevel()
{
	return level;
}

/**
*  Returns true if this node is the root node.
*/
public bool isRoot()
{
	return (parent == RTree.NIL);
}

/**
*  Returns true if this node is an Index. Root node is an Index too, unless it is a Leaf.
*/
public bool isIndex()
{
	return (level != 0);
}

/**
* Returns true if this node is a Leaf. Root may be a Leaf too.
*/
public bool isLeaf()
{
	return (level == 0);
}

/**
* Returns the mbb of all HyperCubes present in this node.
*
* @return A new HyperCube object, representing the mbb of this node.
*/
public HyperCube getNodeMbb()
{
	debug(RTreeMbb) Trace.formatln("AbstractNode.getNodeMbb()...START.");
	if (usedSpace > 0)
	{
		debug(RTreeMbb) Trace.formatln("Print this node before anything: ", this);
		debug(RTreeMbb) Trace.formatln("Usedspace: ", usedSpace);
		debug(RTreeMbb) Trace.formatln("this node data.size before dup.: ", data.size);
		//Trace.formatln("this node data.getDimension before dup.: ", data.getDimension() );

		scope HyperCube[] h = cast(HyperCube[]) new PlainRectangle[usedSpace];// this is left out on intention... = new HyperCube[usedSpace];
		//debug(RTree) Trace.formatln("h.size before dup.: ", h.size);
		//h = data.dup; //This doesn't work well, as when data is an Edit it will copy it's items which is an RTree, and that will result in creation of thousands of unnecessary RTrees.
		//h.size = usedSpace; //we resize it so that others will know it's size correctly.
		//This might be some differences in D and Java dup... or something I've forgotten about the java version.

		//Our new better working copier:
		for( uint i = 0; i < usedSpace; i++ )
		{
			h[i] = new PlainRectangle( data[i] );
		}

		debug(RTreeMbb)
		{
			if( h is null ) Trace.formatln(".dup failed.");
			else Trace.formatln("h.size after dup: ", h.size);
		}

		debug(RTreeMbb) Trace.formatln("data contents:");
		//foreach(HyperCube i; h) Trace.formatln(i);
		debug(RTreeMbb) for(uint i = 0; i < usedSpace; i++) Trace.formatln( data[i].toString() );

		debug(RTreeMbb) Trace.formatln("h contents:");
		//foreach(HyperCube i; h) Trace.formatln(i);
		debug(RTreeMbb) for(uint i = 0; i < usedSpace; i++) Trace.formatln( h[i].toString() );

		//Trace.formatln("and again h contents:", data);//This will crash, because data is data[4], but usually only has 2 members.
		//The usedSpace tells how many of the spaces are occupied.

		//System.arraycopy(data, 0, h, 0, usedSpace);
		debug(RTree) Trace.formatln("AbstractNode.getNodeMbb()...HyperCube = data.dup...END.");
		return PlainRectangle.getUnionMbb(h);
	}
	else
	{
		debug(RTree) Trace.formatln("AbstractNode.getNodeMbb()...new HyperCube 0, 0, 0, 0 ... it seems this node was empty. END.");
		return new PlainRectangle(new Point(0, 0), new Point(0, 0));//new HyperCube(new Point(0, 0), new Point(0, 0));
	}
}

/**
* Returns a unique id for this node. The page number is unique for every node but
* it doen't signify anything about where in the path from the root this node lies, it is random.
* This function returns a <I>point<I> separated list of page numbers from the root up to the
* current node. It is expensive thought, because it loads into main memory all the nodes lying
* on the path from the root up to this node.
*
* @return A string representing a unique id for this node.
*
public string getUniqueId() {
	if (!isRoot()) {
	AbstractNode n = tree.file.readNode(parent);
	int[] b = n.branches;

	int i;
	for (i = 0; i < n.usedSpace; i++) {
		if (b[i] == pageNumber) break;
	}

	return n.getUniqueId() + "." + i;
	} else {
	return "";
	}
}
*/

/**
* Returns a unique id for this node. The page number is unique for every node.
*
* @return A string representing a unique id for this node.
*/
public string getUniqueId()
{
	return Integer.toString(pageNumber);
}

/**
* Returns the parent of this node. If there is a parent, it must be an Index.
* If this node is the root, returns null. This function loads one disk page into
* main memory.
*/
public Node getParent()//was AbstractNode
{
	if (isRoot())
	{
		return null;
	}
	else
	{
		Node ret;//was AbstractNode
		try
		{
			ret = tree.file.readNode( parent );
		}
		catch(PageFaultError p)
		{
			Trace.formatln("AbstractNode.getParent() Error: Propably the page number wasn't found from Hashtable.");
			Trace.formatln( "This node: ", toString(), "\nThe whole tree: ", tree.toString() );
			//throw p;
		}
		return ret;
	}
}

public HyperCube[] data()
{
	return m_data;
}

/**
* Return a copy of the HyperCubes present in this node.
* Don't use this one! It's just copies, and you'll propably want the real thing.
* @return An array of HyperCubes containing copies of the original data.
*/
public HyperCube[] getHyperCubes()
{
	HyperCube[] h = cast(HyperCube[]) new PlainRectangle[usedSpace];//new HyperCube[usedSpace];

	for (int i = 0; i < usedSpace; i++)
	{
		h[i] = new PlainRectangle( data[i] );//cast(HyperCube) data[i].clone();
	}

	return h;
}

public string toString()
{
	string s = "";
	int level_add = 3 - level;

	for(int i = 0; i < (level_add-1); i++ )
		s ~= "--";

	s ~= "| ";
	s ~= "Node <Page: " ~ Integer.toString(pageNumber) ~ ", Level: " ~ Integer.toString(level) ~ ", UsedSpace: " ~ Integer.toString(usedSpace) ~ ", Parent: " ~ Integer.toString(parent) ~ ">\n";

	for (int i = 0; i < usedSpace; i++)
	{
		for(int j = 0; j < (level_add); j++ )
			s ~= "  ";
		s ~= "|   ";
		s ~= "Rect " ~ Integer.toString((i+1)) ~ ") " ~ data[i].toString() ~ " --> " ~ " page: " ~ Integer.toString(branches[i]) ~ "\n";
	}

	return s;
}

//
// Abstract functions.
//

/**
* chooseLeaf finds the most appropriate leaf where the given HyperCube should be stored.
*
* @param h The new HyperCube.
*
* @return The leaf where the new HyperCube should be inserted.
*/
//abstract 
//Leaf 
Node chooseLeaf(HyperCube h){ throw new Exception("AbstractNode.chooseLeaf() is not defined."); return null; }//protected

/**
* findLeaf returns the leaf that contains the given hypercube, null if the hypercube is not
* contained in any of the leaves of this node.
*
* @param h The HyperCube to search for.
*
* @return The leaf where the HyperCube is contained, null if such a leaf is not found.
*/
//abstract
//Leaf 
Node findLeaf(HyperCube h){ throw new Exception("AbstractNode.findLeaf() is not defined."); return null; }//protected

//
// Insertion/Deletion functions.
//

/**
* Adds a child node into this node.
* This function does not save the node into persistent storage. It is used for bulk loading
* a node whith data. The user must make sure that she saves the node into persistent storage, after
* calling this function.
*
* @param n The new node to insert as a child of the current node.
*
*/
//protected
void addData(Node n)//was AbstractNode
{
	debug(RTree) Trace.formatln("AbstractNode.addData(AbstractNode n)...START.");
	addData(n.getNodeMbb(), n.pageNumber);
	debug(RTree) Trace.formatln("AbstractNode.addData(AbstractNode n)...END.");
}

/**
* Adds a child node into this node.
* This function does not save the node into persistent storage. It is used for bulk loading
* a node whith data. The user must make sure that she saves the node into persistent storage, after
* calling this function.
*
* @param h The HyperCube to add.
* @param page The page where this HyperCube is located, if any.
*/
//protected
void addData(HyperCube h, int page)//(CanvasItem h, int page)
{
	if (usedSpace == tree.getNodeCapacity())
	{
		throw new Exception("AbstractNode.addData(HyperCube h, int page) : Error : Node is full.");
		//IllegalState
	}

	data[usedSpace] = h;
	branches[usedSpace] = page;

	h.rtreeNode( this );//cast(Index) getParent() );//satp: this is for edit's to know their trees,
		//and to be able to call adjustree when they're changed.

	m_usedSpace++;
}

/**
* Deletes a data entry from this node.
* This function does not save the node into persistent storage. The user must make sure that
* she saves the node into persistent storage, after calling this function.
*
* @param i  The index of the data entry to be deleted.
*/
//protected 
void deleteData(int ind)
{
	//System.arraycopy(data, i+1, data, i, usedSpace-i-1);
	for( uint i = ind+1; i < data.size; i++ )
	{
		//data[i-1].rtreeNode( null );
		data[i-1] = data[i];
	}
	//System.arraycopy(branches, i+1, branches, i, usedSpace-i-1);
	for( uint i = ind+1; i < branches.size; i++ )
	{
		branches[i-1] = branches[i];
	}
	m_usedSpace--;

}

/**
* Quadratic algorithm for spliting a node.
* [A. Guttman 'R-trees a dynamic index structure for spatial searching']
*
* @param  h  The overflow HyperCube that caused the split.
* @param  page The page where the child node that caused the split is stored. -1 if the split
*         occurs in a Leaf node.
*/
protected int[][] quadraticSplit(HyperCube h, int page)
{
	debug(RTree) Trace.formatln("AbstractNode.quadraticSplit(HyperCube h, int page) START.");

	if (h is null)
	{
		throw new Exception("AbstractNode.quadraticSplit(..) : Hypercube cannot be null.");
		//IllegalArgument
	}

	// temporarily insert new hypercube into data, for common manipulation. Data array is always
	// by one larger than node capacity.
	data[usedSpace] = h;
	branches[usedSpace] = page;
	int total = usedSpace + 1;

	debug(RTree) Trace.formatln("Total number of entries (usedSpace + 1): ", total);

	// use this mask array for marking visited entries.
	int[] mask = new int[total];
	for (int i = 0; i < total; i++)
	{
		mask[i] = 1;
	}

	// each group will have at most total/2 entries. Account for odd numbers too.
	int c = total/2 + 1;
	debug(RTree) Trace.formatln("New groups entries amount: c (total/2 +1): ", c);
	// calculate minimun number of entries a node must contain.
	//int min = std.c.math.lround(tree.getNodeCapacity() * tree.getFillFactor());
	int min = cast(int)round(tree.getNodeCapacity() * tree.getFillFactor());
	debug(RTree) Trace.formatln("Minimum number of entries a node must contain: ", min);
	// at least two nodes (in case the user selects a zero fill factor.)
	if (min < 2) min = 2;
	// count how many more entries are left unchecked.
	int rem = total;

	// create two groups of entries, for spliting the node in two.
	int[] g1 = new int[c];
	int[] g2 = new int[c];
	// keep track of the last item inserted into each group.
	int i1 = 0, i2 = 0;

	// initialize each group with the seed entries.
	int[] seed = pickSeeds();
	g1[i1++] = seed[0];
	g2[i2++] = seed[1];
	rem -= 2;
	mask[g1[0]] = -1;
	mask[g2[0]] = -1;

	while (rem > 0)
	{
		if (min - i1 == rem)
		{
			// all remaining entries must be assigned to g1 to comply with minimun fill factor.
			for (int i = 0; i < total; i++)
			{
				if (mask[i] != -1)
				{
					g1[i1++] = i;
					mask[i] = -1;
					rem--;
				}
			}
		}
		else if (min - i2 == rem)
		{
			// all remaining entries must be assigned to g2 to comply with minimun fill factor.
			for (int i = 0; i < total; i++)
			{
				if (mask[i] != -1)
				{
					g2[i2++] = i;
					mask[i] = -1;
					rem--;
				}
			}
		}
		else
		{
			// find mbr of each group.
			HyperCube mbr1 = new PlainRectangle( data[g1[0]] );//cast(HyperCube) data[g1[0]].clone();
			for (int i = 1; i < i1; i++)
			{
				mbr1 = mbr1.getUnionMbb(data[g1[i]]);
			}
			HyperCube mbr2 = new PlainRectangle( data[g2[0]] );//cast(HyperCube) data[g2[0]].clone();
			for (int i = 1; i < i2; i++)
			{
				mbr2 = mbr2.getUnionMbb(data[g2[i]]);
			}

			// for each entry not already assigned to a group, determine the cost of putting it in
			// either one and select the one with the maximun difference between the two costs.
			double dif = -double.max;//negative_infinity...? This seems to work fine.
			//debug(RTree) Trace.formatln( "negative_infinity:" , dif, " and double.max:", double.max );
			double d1 = 0, d2 = 0;
			int sel = -1;
			for (int i = 0; i < total; i++)
			{
				if (mask[i] != -1)
				{
					HyperCube a = mbr1.getUnionMbb(data[i]);
					d1 = a.getArea() - mbr1.getArea();
					HyperCube b = mbr2.getUnionMbb(data[i]);
					d2 = b.getArea() - mbr2.getArea();
					if (abs(d1 - d2) > dif)
					{
						dif = abs(d1 - d2);
						sel = i;
					}
				}
			}

			// determine the group where we should add the new entry.
			if (d1 < d2)
			{
				g1[i1++] = sel;
			}
			else if (d2 < d1)
			{
				g2[i2++] = sel;
			}
			else if (mbr1.getArea() < mbr2.getArea())
			{
				g1[i1++] = sel;
			}
			else if (mbr2.getArea() < mbr1.getArea())
			{
				g2[i2++] = sel;
			}
			else if (i1 < i2)
			{
				g1[i1++] = sel;
			}
			else if (i2 < i1)
			{
				g2[i2++] = sel;
			}
			else
			{
				g1[i1++] = sel;
			}
			mask[sel] = -1;
			rem--;
		}
	}

	// return the two groups. Let the subclass decide what to do with them.
	int[][] ret = new int[][2];//in java it's: new int[2][]; //Is this the other way around in D???
	//ret.size = 2;
	ret[0] = new int[i1];
	ret[1] = new int[i2];

	for (int i = 0; i < i1; i++)
	{
		ret[0][i] = g1[i];
	}
	for (int i = 0; i < i2; i++)
	{
		ret[1][i] = g2[i];
	}

	debug(RTree) Trace.formatln("AbstractNode.quadraticSplit(HyperCube h, int page) END.");

	return ret;
}

/*
protected Node[] rstarSplit(HyperCube h, int page) {
	// chooseSplitAxis.
	for (int i = 0; i < tree.getDimension(); i++) {
	HyperCube[] data = getData();
	final int dim = i;
	Sort.mergeSort(
		data,
		new Comparator() {
			public int compare(Object o1, Object o2) {
			float ret = ((HyperCube) o1).getP1().getFloatCoordinate(dim) -
					((HyperCube) o2).getP1().getFloatCoordinate(dim);
			if (ret > 0) return 1;
			else if (ret < 0) return -1;
			else  return 0;
			}
		}
		);
	for (int j = 0; j < data.size; j++)
		System.out.println(data[j]);
	}
	return null;
}
*/

/**
* pickSeeds is used by  split to initialize the two groups of HyperCubes.
* [A. Guttman 'R-trees a dynamic index structure for spatial searching']
* 3.5.2. A Quadratic-Cost Algorithm
*
* @return  The two indices of the selected entries to be the first elements of the groups.
*/
protected int[] pickSeeds()
{
	double inefficiency = -double.max;//NEGATIVE_INFINITY;
	int i1 = 0, i2 = 0;

	// for each pair of HyperCubes (account for overflow HyperCube too!)
	for (int i = 0; i < usedSpace; i++)
	{
		for (int j = i+1; j <= usedSpace; j++)
		{
			// get the mbr of those two entries.
			HyperCube h = data[i].getUnionMbb(data[j]);

			// find the inefficiency of grouping these entries together.
			double d = h.getArea() - data[i].getArea() - data[j].getArea();

			if (d > inefficiency)
			{
				inefficiency = d;
				i1 = i;
				i2 = j;
			}
		}
	}

	int[] ret = new int[2];
	ret[0] = i1;
	ret[1] = i2;

	return ret;//new int[] [i1, i2];
}

/**
* Used to condense the tree after an entry has been deleted.
* [A. Guttman 'R-trees a dynamic index structure for spatial searching']
* 3.3. Deletion
**/

//A strange unused placeholder... to get stuff to compile.
/*LinkedList!(AbstractNode) temp;

alias LinkedList!(AbstractNode) AbstractNodeList;
*/
//protected void condenseTree( AbstractNodeList q )
//protected 
public void condenseTree( LinkedList!(Node) q )//was AbstractNode
{
	throw new Exception("AbstractNode.condenseTree() not implemented.");
}

} // AbstractNode









/**
 * Internal node of the RTree. Used to access Leaf nodes, where real data lies.
 * <p>
 * Created: Tue May 18 13:04:25 1999
 * <p>
 * @author Hadjieleftheriou Marios
 * @version 1.001
 */
//public 
class Index : public AbstractNode
{

	//protected //satb: Why should this be protected?
	this(RTree tree, int parent, int pageNumber, int level)
	{
		super(tree, parent, pageNumber, level);
	}

	
	//This didn't work when I put it in AbstractNode...
	//protected 
	public void condenseTree( LinkedList!(Node) q )//was AbstractNode
	{
		debug(RTree) Trace.formatln("AbstractNode.condenseTree(LinkedList!(AbstractNode) q) START.");
		if (isRoot())
		{
			// eliminate root if it has only one child.
			if ( !isLeaf() && usedSpace == 1 )
			{
				Node n = tree.file.readNode(branches[0]);
				tree.file.deletePage(n.pageNumber);
				n.pageNumber = 0;
				n.parent = RTree.NIL;
				tree.file.writeNode(n);
				if (! n.isLeaf())
				{
					for (int i = 0; i < n.usedSpace; i++)
					{
						Node m = (cast(Index) n).getChild(i);
						m.parent = 0;
						tree.file.writeNode(m);
					}
				}
			}
		}
		else
		{
			// find the parent.
			Node p = getParent();
			int e;
	
			// find the entry in the parent, that points to this node.
			for (e = 0; e < p.usedSpace; e++)
			{
				if (pageNumber == p.branches[e])
				{
					break;
				}
			}
	
			int min = cast(int)round(tree.getNodeCapacity() * tree.getFillFactor());
			if (usedSpace < min)
			{
				// eleminate node.
				p.deleteData(e);
				q.append(this);
			}
			else
			{
				// adjust the entry in 'p' to contain the new bounding box of this node.
				p.data[e] = getNodeMbb();
			}
	
			tree.file.writeNode(p);
			p.condenseTree(q);
		}
		debug(RTree) Trace.formatln("AbstractNode.condenseTree(LinkedList!(AbstractNode) q)...END.");
	}


	protected Leaf chooseLeaf(HyperCube h)
	{
		debug(RTree) Trace.formatln("Index.chooseLeaf() START.");
		debug(RTree) scope(exit) Trace.formatln("Index.chooseLeaf() END.");
		
		int i;

		if( tree is null )
		{
			Trace.formatln("Index.chooseLeaf() tree is null.");
			return null;
		}

		switch (tree.getTreeType())
		{
			case RTreeType.RTREE_LINEAR:
			case RTreeType.RTREE_QUADRATIC:
			case RTreeType.RTREE_EXPONENTIAL:
				i = findLeastEnlargement(h);
			break;
			case RTreeType.RSTAR:
				if (level == 1)
				{
					// if this node points to leaves...
					i = findLeastOverlap(h);
				}
				else
				{
					i = findLeastEnlargement(h);
				}
			break;
			default:
				throw new IllegalStateException("Invalid tree type.");
		}

		//return (cast(Leaf) getChild(i)).chooseLeaf(h);//was cast AbstractNode
		return (getChild(i)).chooseLeaf(h);//was cast AbstractNode
	}

	//protected
	public Leaf findLeaf(HyperCube h)
	{
		debug(FindLeaf) Trace.formatln("Index.findLeaf() START.");
		for (int i = 0; i < usedSpace; i++)
		{
			debug(FindLeaf) Trace.formatln("Index.findLeaf() i:", i);
			if (data[i].enclosure(h))
			{
				debug(FindLeaf) Trace.formatln("Index.findLeaf() enclosure == true.");
				Leaf l = (cast(Leaf) getChild(i)).findLeaf(h);//was cast AbstractNode
				if (l !is null)
				{
					debug(FindLeaf) Trace.formatln("Index.findLeaf() found leaf END.");
					return l;
				}
			}
			/*else
			{
				debug(FindLeaf)
				{
					Trace.formatln("Index.findLeaf() enclosure == false.");
					Trace.formatln("data[", i, "]: ", data[i].toString() );
					Trace.formatln("h: ", h.toString() );
					if( h.rtreeNode is this )
					{
						Trace.formatln("h.parentNode is this == true: THIS was the Index we were looking for. BUG here.");
					}
				}
			}*/
		}
			debug(FindLeaf) Trace.formatln("Index.findLeaf() no leaf here END.");
			return null;
    }

	/**
	* Add the new HyperCube to all mbbs present in this node. Calculate the area difference and
	* choose the entry with the least enlargement. Based on that metric we choose the path that
	* leads to the leaf that will hold the new HyperCube.
	* [A. Guttman 'R-trees a dynamic index structure for spatial searching']
	*
	* @return The index of the branch of the path that leads to the Leaf where the new HyperCube
	*         should be inserted.
	*/
	private int findLeastEnlargement(HyperCube h)
	{
		debug(RTree) Trace.formatln("Index.findLeastEnlargement() START.");
		debug(RTree) scope(exit) Trace.formatln("Index.findLeastEnlargement() END.");
	
		double area = double.max;
		int sel = -1;

		for (int i = 0; i < usedSpace; i++)
		{
			double enl = data[i].getUnionMbb(h).getArea() - data[i].getArea();
			if (enl < area)
			{
				area = enl;
				sel = i;
			}
			else if (enl == area)
			{
				sel = (data[sel].getArea() <= data[i].getArea()) ? sel : i;
			}
		}
		return sel;
	}

    /**
     * R*-tree criterion for choosing the best branch to follow.
     * [Beckmann, Kriegel, Schneider, Seeger 'The R*-tree: An efficient and Robust Access Method
     *  for Points and Rectangles]
     *
     * @return The index of the branch of the path that leads to the Leaf where the new HyperCube
     *         should be inserted.
     */
    private int findLeastOverlap(HyperCube h) {
	float overlap = float.max;
	int sel = -1;

	for (int i = 0; i < usedSpace; i++) {
	    Node n = getChild(i);//cast(AbstractNode)
	    float o = 0;
	    for (int j = 0; j < n.data.size; j++) {
		o += h.intersectingArea(n.data[j]);
	    }
	    if (o < overlap) {
		overlap = o;
		sel = i;
	    } else if (o == overlap) {
		double area1 = data[i].getUnionMbb(h).getArea() - data[i].getArea();
		double area2 = data[sel].getUnionMbb(h).getArea() - data[sel].getArea();

		if (area1 == area2) {
		    sel = (data[sel].getArea() <= data[i].getArea()) ? sel : i;
		} else {
		    sel = (area1 < area2) ? i : sel;
		}
	    }
	}
	return sel;
    }

	/**
	* Inserts a new node into the tree. If enought space is available
	* the insertion is straighforward. If not, a split must occur.
	*
	* @param  node The node that should be inserted.
	*
	* @return True if a split occurred, false otherwise.
	*/
	protected bool insert(Node node)
	{
		debug(RTree) Trace.formatln("Index.insert(AbstractNode node)...START.");
		if (usedSpace < tree.getNodeCapacity())
		{
			data[usedSpace] = node.getNodeMbb();
			branches[usedSpace] = node.pageNumber;
			m_usedSpace++;
			node.parent = pageNumber;
			tree.file.writeNode(node);
			tree.file.writeNode(this);
			Index p = cast(Index) getParent();
			if (p !is null)
			{
				p.adjustTree(this, null);
			}

			debug(RTree) Trace.formatln("Index.insert(AbstractNode node)...false.END.");
			debug(RTreeDebugCheck) tree.debugCheckStart();
			return false;
		}
		else
		{
			Index[] a = splitIndex(node);
			Index n = a[0];
			Index nn = a[1];

			if (isRoot())
			{
				n.parent = 0;
				n.pageNumber = -1;
				nn.parent = 0;
				nn.pageNumber = -1;
				int p = tree.file.writeNode(n);
				for (int i = 0; i < n.usedSpace; i++)
				{
					Node ch = n.getChild(i);//cast(AbstractNode)
					ch.parent = p;
					tree.file.writeNode(ch);
				}
				p = tree.file.writeNode(nn);
				for (int i = 0; i < nn.usedSpace; i++)
				{
					Node ch = nn.getChild(i);//cast(AbstractNode) 
					ch.parent = p;
					tree.file.writeNode(ch);
				}
				Index r = new Index(tree, RTree.NIL, 0, level+1);
				r.addData(n.getNodeMbb(), n.pageNumber);
				r.addData(nn.getNodeMbb(), nn.pageNumber);
				tree.file.writeNode(r);
			}
			else
			{
				n.pageNumber = pageNumber;
				n.parent = parent;
				nn.pageNumber = -1;
				nn.parent = parent;
				tree.file.writeNode(n);
				int j = tree.file.writeNode(nn);
				for (int i = 0; i < nn.usedSpace; i++)
				{
					Node ch = nn.getChild(i);//cast(AbstractNode) 
					ch.parent = j;
					tree.file.writeNode(ch);
				}
				Index p = cast(Index) getParent();
				p.adjustTree(n, nn);
			}
				debug(RTree) Trace.formatln("Index.insert(AbstractNode node)...true.END.");
				debug(RTreeDebugCheck) tree.debugCheckStart();
			return true;
		}
	}

	/**
	* Called by insert to adjust the parents of the node that was modified by the insertion. Stops
	* when it reaches the root.
	*
	* @param  n1  The child node that caused the need for adjustment.
	* @param  n2  If a split occured in the child node, this is the new node that must be inserted.
	*             Otherwise, this is null.
	*/
	//protected
	void adjustTree(Node n1, Node n2)
	{
		debug(RTree) Trace.formatln("Index.adjustTree(AbstractNode n1, n2) START. thisnode before anything:\n", toString() );
		// find entry pointing to old node;
		for (int i = 0; i < usedSpace; i++)
		{
			if (branches[i] == n1.pageNumber)
			{
				data[i] = n1.getNodeMbb();
				break;
			}
		}

		debug(RTree) Trace.formatln("Index.adjustTree(AbstractNode n1, n2) thisnode after data[i] = n1.getNodeMbb():\n", toString() );

		// if a split has occured we must insert the new node, else we must continue adjusting the tree
		// until we hit the root.
		if (n2 !is null)
		{
			debug(RTree) Trace.formatln("Index.adjustTree(AbstractNode n1, n2) There is a n2, Split has happened. Reinserting n2.");
			insert(n2);
			//debug(RTree) Trace.formatln("Index.adjustTree(AbstractNode n1, n2) thisnode after insert(n2):\n", toString() );
		}
		else if (! isRoot())
		{
			debug(RTree) Trace.formatln("Index.adjustTree(AbstractNode n1, n2) There is NO n2. Adjusting tree until root.");
			Index p = cast(Index) getParent();
			p.adjustTree(this, null);
			debug(RTree) Trace.formatln("Index.adjustTree(AbstractNode n1, n2) thisnode after p.adjustTree(this, null):\n", toString() );
		}
		debug(RTree) Trace.formatln("Index.adjustTree(AbstractNode n1, n2)...END.");
		debug(RTreeDebugCheck) tree.debugCheckStart();
	}

	private Index[] splitIndex(Node n)
	{
		debug(RTree) Trace.formatln("Index.splitIndex(AbstractNode node) START.");
		int[][] group = null;

		switch (tree.getTreeType())
		{
			case RTreeType.RTREE_LINEAR:
			break;
			case RTreeType.RTREE_QUADRATIC:
				group = quadraticSplit(n.getNodeMbb(), n.pageNumber);
			break;
			case RTreeType.RTREE_EXPONENTIAL:
			break;
			case RTreeType.RSTAR:
			break;
			default:
				throw new IllegalStateException("Invalid tree type.");
			break;
		}

		Index i1 = new Index(tree, parent, pageNumber, level);
		Index i2 = new Index(tree, parent, -1, level);

		int[] g1 = group[0];
		int[] g2 = group[1];

		for (int i = 0; i < g1.size; i++)
		{
			i1.addData(data[g1[i]], branches[g1[i]]);
		}

		for (int i = 0; i < g2.size; i++)
		{
			i2.addData(data[g2[i]], branches[g2[i]]);
		}

		Index[] resultIndex = new Index[2];
		resultIndex[0] = i1;
		resultIndex[1] = i2;

		debug(RTree) Trace.formatln("Index.splitIndex(AbstractNode node) END.");
		debug(RTreeDebugCheck) tree.debugCheckStart();
		return resultIndex;//new Index[] [i1, i2];
	}

	/**
	* Retrieves the <B>i-th</B> child node. Loads one page into main memory.
	*
	* @param  i The index of the child in the data array.
	* @return The i-th child.
	*/
	public Node getChild(int i)
	{
		if (i < 0 || i >= usedSpace)
		{
			throw new IndexOutOfBoundsException( Integer.toString(i) );//std.string.toString(i) );
		}

		return tree.file.readNode(branches[i]);
	}

} // Index








alias Exception IllegalStateException;
alias Exception IndexOutOfBoundsException;

//import java.util.*;

/**
 * A Leaf node. Containts pointers to the real data.
 * <p>
 * Created: Tue May 18 13:04:08 1999
 * <p>
 * @author Hadjieleftheriou Marios
 * @version 1.002
 */
//public
class Leaf : public AbstractNode
{
public:
    this(RTree tree, int parent, int pageNumber)//protected
    {
		// Leaf nodes belong by default to level 0.
		super(tree, parent, pageNumber, 0);
    }

    this(RTree tree, int parent)//protected
    {
		// Leaf nodes belong by default to level 0.
		super(tree, parent, -1, 0);
    }

	//This didn't work when I put it in AbstractNode...
	//protected 
	public void condenseTree( LinkedList!(Node) q )//was abstractnode
	{
		debug(RTree) Trace.formatln("AbstractNode.condenseTree(LinkedList!(AbstractNode) q) START.");
		if (isRoot())
		{
			// eliminate root if it has only one child.
			if ( !isLeaf() && usedSpace == 1 )
			{
				Node n = tree.file.readNode(branches[0]);
				tree.file.deletePage(n.pageNumber);
				n.pageNumber = 0;
				n.parent = RTree.NIL;
				tree.file.writeNode(n);
				if (! n.isLeaf())
				{
					for (int i = 0; i < n.usedSpace; i++)
					{
						Node m = (cast(Index) n).getChild(i);
						m.parent = 0;
						tree.file.writeNode(m);
					}
				}
			}
		}
		else
		{
			// find the parent.
			Node p = getParent();//was AbstractNode
			int e;
	
			// find the entry in the parent, that points to this node.
			for (e = 0; e < p.usedSpace; e++)
			{
				if (pageNumber == p.branches[e])
				{
					break;
				}
			}
	
			int min = cast(int)round(tree.getNodeCapacity() * tree.getFillFactor());
			if (usedSpace < min)
			{
				// eleminate node.
				p.deleteData(e);
				q.append(this);
			}
			else
			{
				// adjust the entry in 'p' to contain the new bounding box of this node.
				p.data[e] = getNodeMbb();
			}
	
			tree.file.writeNode(p);
			p.condenseTree(q);
		}
		debug(RTree) Trace.formatln("AbstractNode.condenseTree(LinkedList!(AbstractNode) q)...END.");
	}

	Leaf chooseLeaf(HyperCube h)//protected
	{
		return this;
	}

	Leaf findLeaf(HyperCube h)//protected
	{
		debug(FindLeaf) Trace.formatln("Leaf.findLeaf() START.");
		for (int i = 0; i < usedSpace; i++)
		{
			//if (data[i].enclosure(h)) //This version seems to look for similar HyperCubes, as we're interested in exact match.
			if( data[i] is h )
			{
				debug(FindLeaf) Trace.formatln("Leaf.findLeaf() found leaf: data[ {} {}", i, "] is h. END.");
				return this;
			}
			else
			{
				debug(FindLeaf)
				{
					Trace.formatln("Leaf.findLeaf() data[ {} {} ",i,"] is h == false.");
					Trace.formatln("data[{}{}{}", i, "]: ", data[i].toString() );
					Trace.formatln("h: {}", h.toString() );
				}
			}
		}
		debug(FindLeaf) Trace.formatln("Leaf.findLeaf() no leaf here. END.");
		return null;
    }

/**
* Inserts a new HyperCube into the Leaf. If there is space left, then the insertion is straightforward and
* adjustTree must be called. Otherwise, a split must occur and two new leaves must be created.
*
* @param h The HyperCube that represents the MBB of the data.
* @param page The page number where the real data resides.
* @return The page number of the Leaf where the hypercube was inserted.
*/
int insert(HyperCube h, int page)//protected
{
	debug(RTree) Trace.formatln("Leaf.insert(HyperCube h, int page) START. Inserting: {}", h.toString() );
	if (usedSpace < tree.getNodeCapacity())
	{
		debug(RTree) Trace.formatln("Leaf.insert(HyperCube h, int page) usedSpace < tree.getNodeCapacity, usedSpace: {}", usedSpace);

		//Is there any reason why this code isn't using addData here??? That would make data hiding better.
		data[usedSpace] = h;
		branches[usedSpace] = page;
		m_usedSpace++;
		tree.file.writeNode(this);

		h.rtreeNode( this );//cast(Index) getParent() );//satp: this is for edit's to know their trees,
		//and to be able to call adjustree when they're changed.

		Index p = cast(Index) getParent();
		if (p !is null)
		{
			p.adjustTree(this, null);
		}

		debug(RTree) Trace.formatln("Leaf.insert(HyperCube h, int page) END.");
		debug(RTreeDebugCheck) tree.debugCheckStart();
		return pageNumber;
	}
	else
	{
		debug(RTree) Trace.formatln("Leaf.insert(HyperCube h, int page) SPLIT.");
		Leaf[] a = splitLeaf(h, page);
		Leaf l = a[0];
		Leaf ll = a[1];

		if( isRoot() )
		{
			debug(RTree) Trace.formatln("Leaf.insert(HyperCube h, int page) SPLIT isRoot == true.");
			// root is full, so we must split it. From now on root will be
			// an Index and not a Leaf.
			l.parent = 0;
			l.pageNumber = -1;
			ll.parent = 0;
			ll.pageNumber = -1;
			tree.file.writeNode(l);
			tree.file.writeNode(ll);
			// create the new root node. It belongs to pageNumber 0 and level 1.
			Index r = new Index(tree, RTree.NIL, 0, 1);
			debug(RTree) Trace.formatln("Leaf.insert(HyperCube h, int page) l.getNodeMbb.");
			r.addData(l.getNodeMbb(), l.pageNumber);
			debug(RTree) Trace.formatln("Leaf.insert(HyperCube h, int page) ll.getNodeMbb.");
			r.addData(ll.getNodeMbb(), ll.pageNumber);
			tree.file.writeNode(r);
		}
		else
		{
			debug(RTree) Trace.formatln("Leaf.insert(HyperCube h, int page) SPLIT isRoot == false.");
			// use old page number for left child, a new page number for the right child.
			l.pageNumber = pageNumber;
			ll.pageNumber = -1;
			tree.file.writeNode(l);
			tree.file.writeNode(ll);
			Index p = cast(Index) getParent();
			p.adjustTree(l, ll);
		}

		//debug(RTree) Trace.formatln("Tree after insert() SPLIT: ", tree);

		// Find which is the parent Leaf of the inserted hypercube and return it's page number.
		for (int i = 0; i < l.usedSpace; i++)
		{
			if (l.branches[i] == page)
			{
				debug(RTree) Trace.formatln("Leaf.insert(HyperCube h, int page)...END.");

				//This propably isn't needed here...
				//h.rtreeNode( this );//cast(Index) getParent() );//satp: this is for edit's to know their trees,
				//and to be able to call adjustree when they're changed.

				debug(RTreeDebugCheck) tree.debugCheckStart();

				return l.pageNumber;
			}
		}

		for (int i = 0; i < ll.usedSpace; i++)
		{
			if (ll.branches[i] == page)
			{
				debug(RTree) Trace.formatln("Leaf.insert(HyperCube h, int page)...END.");

				//This propably isn't needed here:
				//h.rtreeNode( this );//cast(Index) getParent() );//satp: this is for edit's to know their trees,
				//and to be able to call adjustree when they're changed.

				debug(RTreeDebugCheck) tree.debugCheckStart();

				return ll.pageNumber;
			}
		}

		//h.rtreeNode( this );//cast(Index) getParent() );//satp: this is for edit's to know their trees,
		//and to be able to call adjustree when they're changed.

		debug(RTree) Trace.formatln("Leaf.insert(HyperCube h, int page)...END.");
		debug(RTreeDebugCheck) tree.debugCheckStart();
		return -1;
	}

	return 0;//This wasn't here before...
}

	/**
	* Deletes an entry for the leaf.
	* [A. Guttman 'R-trees a dynamic index structure for spatial searching']
	* 3.3. Deletion
	*
	* @param h  The hypercube that corresponds to the entry to be deleted.
	* @return The data pointer of the deleted entry.
	**/
	int delet(HyperCube h)//protected
	{
		debug(RTree) Trace.formatln("Leaf.delet(HyperCube h) START. Deleting: {}", h.toString() );
		for (int i = 0; i < usedSpace; i++)
		{
			//if (data[i].equals(h))
			if( data[i] is h )
			{
				int pointer = branches[i];
				deleteData(i);
				tree.file.writeNode(this);
				LinkedList!(Node) q = new LinkedList!(Node);
				condenseTree(q);

				// reinsert eliminated leaves.
				//for (int l = 0; l < q.size(); l++)//DONE foreach is faster.
				foreach( Node n; q )
				{
					//AbstractNode n = cast(AbstractNode) q[l];
					if (n.isLeaf())
					{
						for (int j = 0; j < n.usedSpace; j++)
						{
							tree.insert(n.data[j], n.branches[j]);
						}
					}
					else
					{
						// this is not what Gutman says, but it will work anyway...
						LinkedList!(Node) v = tree.traversePostOrder(n);
						//for (int j = 0; j < v.size(); j++)
						foreach( Node m; v )
						{
							//AbstractNode m = cast(AbstractNode) v[j];
							if (m.isLeaf())
							{
								for (int k = 0; k < m.usedSpace; k++)
								{
									tree.insert(m.data[k], m.branches[k]);
								}
							}
							tree.file.deletePage(m.pageNumber);
						}
					}
					tree.file.deletePage(n.pageNumber);
				}

				//satp: added this when I noticed there was no adjustree after deleting a HyperCube from
				//a Leaf node...
				Index p = cast(Index) getParent();
				if (p !is null)
				{
					p.adjustTree(this, null);
				}

				debug(RTree) Trace.formatln("Leaf.delet(HyperCube h) END.");
				debug(RTreeDebugCheck) tree.debugCheckStart();
				return pointer;
			}
		}
		debug(RTree) Trace.formatln("Leaf.delet(HyperCube h) END.");
		debug(RTreeDebugCheck) tree.debugCheckStart();
		return RTree.NIL;
	}

	private Leaf[] splitLeaf(HyperCube h, int page)
	{
		debug(RTree) Trace.formatln("Leaf.splitLeaf(HyperCube h, int page) START.");
		int[][] group = null;

		switch (tree.getTreeType())
		{
			case RTreeType.RTREE_LINEAR:
			break;
			case RTreeType.RTREE_QUADRATIC:
				group = quadraticSplit(h, page);
			break;
			case RTreeType.RTREE_EXPONENTIAL:
			break;
			case RTreeType.RSTAR:
			break;
			default:
				throw new IllegalStateException("Leaf.splitLeaf() Invalid tree type.");
			break;
		}

		Leaf l = new Leaf(tree, parent);
		Leaf ll = new Leaf(tree, parent);

		int[] g1 = group[0];
		int[] g2 = group[1];

		for (int i = 0; i < g1.size; i++)
		{
			l.addData(data[g1[i]], branches[g1[i]]);
			//data[g1[i]].rtreeNode(l);TANNE //I've decided to do this in abstractnode.addData().
		}

		for (int i = 0; i < g2.size; i++)
		{
			ll.addData(data[g2[i]], branches[g2[i]]);
		}

		Leaf[] retleaf = new Leaf[2];
		retleaf[0] = l;
		retleaf[1] = ll;

		debug(RTree) Trace.formatln("Tree after splitLeaf(): {}", tree);

		debug(RTree) Trace.formatln("Leaf.splitLeaf(HyperCube h, int page) END.");

		//debug(RTreeDebugCheck) tree.debugCheckStart();
		return retleaf;//new Leaf[] [l, ll];
	}

	/**
	* Returns the pointer of the <i>i-th</i> data entry.
	*
	* @param  i The index of the child in the data array.
	* @return The pointer of the <i>i-th</i> child.
	*/
	public int getDataPointer(int i)
	{
		if (i < 0 || i >= usedSpace)
		{
			throw new IndexOutOfBoundsException( Integer.toString(i) );//std.string.toString(i) );
		}

		return branches[i];
	}

} // Leaf








// generate Active Branch List.
class ABLNode
{
	Node node;//was AbstractNode
	float minDist;

	public this(Node node, float minDist)//was AbstractNode
	{
		this.node = node;
		this.minDist = minDist;
	}
}








class Comparator
{
	public int compare(Object o1, Object o2)
	{
		float f = (cast(ABLNode) o1).minDist -
				(cast(ABLNode) o2).minDist;

		// do not round the float here. It is wrong!
		if (f > 0) return 1;
		else if (f < 0) return -1;
		else  return 0;
	}
}












/**
 * Abstract class for all classes implementing a storage manager for the RTree. Every node should be stored in
 * a unique page. The root node is always stored in page 0. The storage manager should have the control
 * over the page numbers where each node should be stored.
 * <p>
 * Created: Tue May 18 16:24:00 1999
 * <p>
 * @author Hadjieleftheriou Marios
 * @version 1.003
 */
//public abstract 
class PageFile
{
    public:
	RTree tree = null;//TODO make protected

    /** Dimension of data inserted into the tree. */
    int dimension = -1;//protected

    /**
     * fillFactor specifies minimum node entries present in each node. It must be a float between
     * 0 and 0.5.
     */
    float fillFactor = -1;//protected

    /** Maximum node capacity. Each node will be able to hold at most nodeCapacity entries. */
	int nodeCapacity = -1;//protected

    /**
     * The page size needed in bytes to store a full node. Calculated using the following formula:
     * [nodeCapacity * (sizeof(HyperCube) + sizeof(Branch))] + parent + level + usedSpace =
     * {nodeCapacity * [(2 * dimension * sizeof(float)) + sizeof(int)]} +
     * sizeof(int) + sizeof(int) + sizeof(int)
     */
    int pageSize = -1;//protected

    /** RTree variant used. Specified when creating a new tree. */
    int treeType = -1;//protected


    /**
     * Returns the object stored in the requested page.
     */
    //    protected abstract byte[] readData(int page) throws PageFaultError;

    /**
     * if <i>page</i> is negative, writes the object into the first available page
     * and returns that page. Else, the object is written into the given page. Objects
     * larger than one page size in.size, are not supported yet!
     */
    //    protected abstract int writeData(byte[] d, int page) throws PageFaultError;

    /**
     * Returns the node stored in the requested page.
     */
    //abstract
    //Abstract
    Node readNode(int page)
    {
    	throw new Exception("PageFaultError");
    	return null;//PageFaultError
    }// throws PageFaultError;//protected

    /**
     * Writes the node into the first available page and returns that page.
     */
    //abstract
    int writeNode(Node o)//was AbstractNode
    {
    	throw new Exception("PageFaultError");//PageFaultError
    	return 0;
    }//protected

    /**
     * Marks a specific page as empty.
     */
	//protected
	//abstract AbstractNode deletePage(int page) { throw new Exception("PageFaultError"); return null; }//protected
	//abstract
	void deletePage(int page) { throw new Exception("PageFaultError"); return null; }//protected

public void initialize(RTree tree, int dimension, float fillFactor, int capacity, int treeType)//toDO make protected
{
	this.dimension = dimension;
	this.fillFactor = fillFactor;
	this.nodeCapacity = capacity;
	this.treeType = treeType;
	this.tree = tree;

	this.pageSize = capacity * (8 * dimension + 4) + 12;
    }

	protected void finalize()//protected
	{
		throw new Exception("PageFile.finalize()... Why is this here?");//Throwable;
		//super.finalize();
	}

} // PageFile







import tango.util.container.HashMap;

/**
* Implements a memory page file. Holds all pages into a HashTable with keys equal to each object's
* page number.
* <p>
* Created: Wed May 19 09:33:26 1999
* <p>
* @author Hadjieleftheriou Marios
* @version 1.002
*/

//public 
class MemoryPageFile : public PageFile
{
	private HashMap!(int, Node) file;

	protected void initialize(RTree tree, int dimension, float fillFactor, int capacity, int treeType)
	{
		debug(RTree) Trace.formatln("MemoryPageFile.initialize(...) START.");
		debug(RTree) scope(exit) Trace.formatln("MemoryPageFile.initialize(...) END.");
		
		file = new HashMap!(int, Node);
		super.initialize(tree, dimension, fillFactor, capacity, treeType);
		//file.clear(); //this isn't really necessary... it's just duplicate initialization.
	}

	/*
	protected byte[] readData(int page) throws PageFaultError {
		if (page < 0) {
		throw new IllegalArgumentException("Page number cannot be negative.");
		}

		byte[] ret = (byte[]) file.get(new Integer(page));

		if (ret is null) {
		throw new PageFaultError("Invalid page number request.");
		}

		return ret;
	}

	protected int writeData(byte[] d, int page) throws PageFaultError {
		if (d is null) {
		throw new IllegalArgumentException("Data cannot be null.");
		}

		if (page < 0) {
		page = 0;
		while (true) {
			if (! file.containsKey(new Integer(page))) {
			break;
			}
			page++;
		}
		}

		file.add(new Integer(page), d);

		return page;
	}
	*/

	protected Node readNode(int page) //throws PageFaultError
	{
		debug(RTree) Trace.formatln("MemoryPageFile.readNode(...) START.");
		debug(RTree) scope(exit) Trace.formatln("MemoryPageFile.readNode(...) END.");
	
		if (page < 0)
		{
			throw new Exception( "MemoryPageFile.readNode(int page) Error: Page number cannot be negative. Page: " ~ Integer.toString(page) );
			//IllegalArgument
		}

		
		Node ret = file.get(page);//new Integer(page));
		/*
		if (ret is null)//The hashtable is propably too small, let's try to grow it.
		{
			file.growHashTable();
		}

		ret = cast(AbstractNode) file.get(page);//new Integer(page));
		*/
		if (ret is null)//It still didn't work. Something else went wrong.
		{
			throw new Exception( "MemoryPageFile.readNode(int page) Error: Invalid page number request. Page: " ~ Integer.toString(page) );
			//PageFaultError
		}

		return ret;
	}

	protected int writeNode(Node n) //throws PageFaultError
	{
		debug(RTree) Trace.formatln("MemoryPageFile.writeNode(...) START.");
		debug(RTree) scope(exit) Trace.formatln("MemoryPageFile.writeNode(...) END.");
	
		if (n is null)
		{
			throw new Exception("Node cannot be null.");
			//IllegalArgument
		}

		int i = 0;
		if (n.pageNumber < 0)
		{
			while( true )
			{
				if ( !file.containsKey(i) )//new Integer(i)))
				{
					break;
				}
				i++;
			}
			n.pageNumber = i;
		}
		else
		{
			i = n.pageNumber;
		}

		file.add(i, n);

		return i;
	}

	//protected AbstractNode deletePage(int page)// throws PageFaultError
	protected void deletePage(int page)// throws PageFaultError
	{
		//return cast(AbstractNode)
		//AbstractNode toberemoved = cast(AbstractNode)file.get(page);
		file.removeKey(page);//new Integer(page));
		//return toberemoved;
	}

	/*public void dumpMemory()
	{
		for (Enumeration e = file.elements(); e.hasMoreElements();)
		{
			Trace.formatln(e.nextElement());
		}
	}*/

} // MemoryPageFile








public class Sort
{

private this()
{
}

private static void mergeSort(Object[] src, Object[] dest,
		  int low, int high, Comparator c)
{
	int.size = high - low;

	// Insertion sort on smallest arrays
	if .size < 7)
	{
		for (int i=low; i<high; i++)
			for (int j=i; j>low && c.compare(dest[j-1], dest[j])>0; j--)
				swap(dest, j, j-1);
		return;
	}

        // Recursively sort halves of dest into src
        int mid = (low + high)/2;
        mergeSort(dest, src, low, mid, c);
        mergeSort(dest, src, mid, high, c);

        // If list is already sorted, just copy from src to dest.  This is an
        // optimization that results in faster sorts for nearly ordered lists.
	if (c.compare(src[mid-1], src[mid]) <= 0)
	{
		//System.
		//arraycopy(src, low, dest, low,.size);
		dest[low..high] = src[low..high];
		return;
	}

		// Merge sorted halves (now in src) into dest
	for(int i = low, p = low, q = mid; i < high; i++)
	{
		if (q>=high || p<mid && c.compare(src[p], src[q]) <= 0)
			dest[i] = src[p++];
		else
			dest[i] = src[q++];
	}
}

private static void swap(Object x[], int a, int b)
{
	Object t = x[a];
	x[a] = x[b];
	x[b] = t;
}

public static void mergeSort(Object[] a, Comparator c)
{
	Object aux[] = cast(Object[])a.dup;//clone();
	mergeSort(aux, a, 0, a.size, c);
}

} // Sort



+/






//import java.util.*;

/**
* To create a new RTree use the first two constructors. You must specify the dimension, the fill factor as
* a float between 0 and 0.5 (0 to 50% capacity) and the variant of the RTree which is one of:
* <ul>
*  <li>RTREE_QUADRATIC</li>
* </ul>
* The first constructor creates by default a new memory resident page file. The second constructor takes
* the page file as an argument. If the given page file is not empty, then all data are deleted.
* <p>
* The third constructor initializes the RTree from an already filled page file. Thus, you may store the
* RTree into a persistent page file and recreate it again at any time.
* <p>
* Created: Tue May 18 12:57:35 1999
* <p>
* @author Hadjieleftheriou Marios
* @version 1.003
*/

enum RTreeType
{
	RTREE_LINEAR = 0,
	RTREE_QUADRATIC = 1,
	RTREE_EXPONENTIAL = 2,
	RSTAR = 3
}

/**
* This is used for atleast nearestNeighbourSearch to determine if we should only search
* to the left or right, or should all of the items be looked. It's usefull for finding the
* left neighbour.
*/
enum RTreeSearchType
{
	ALL,
	LEFT,
	RIGHT
	//UP, //These might be usefull as well. Maybe.
	//DOWN
}

public class RTree
{

public:

string versio = "1.003";
string date = "December 7th 1999";

/** Page file where data is stored. */
PageFile file = null;//protected

/** static identifier used for the parent of the root node. */
public static final int NIL = -1;

/** Available RTree variants. */
/*public static final int RTREE_LINEAR = 0;
public static final int RTREE_QUADRATIC = 1;
public static final int RTREE_EXPONENTIAL = 2;
public static final int RSTAR = 3;*/

/**
* Creates a memory resident RTree with an empty root node, which is stored in page 0 and has a
* parent identifier equal to NIL. A new memory page file is created and used as a storage manager
* by default.
*
* @param  dimension  The data dimension.
* @param  fillFactor A percentage between 0 and 0.5. Used to calculate minimum number of entries
*                    present in each node.
* @param  capacity   The maximun number of entries that each node can hold.
* @param  type       The RTree variant to use.
*/

public this(int dimension = 2, float fillFactor = 0.4f, int capacity = 3, int type = RTreeType.RTREE_QUADRATIC)
{
	
	this(dimension, fillFactor, capacity, new MemoryPageFile(), type);
	
}

/**
* Creates a new RTree with an empty root node, which is stored in page 0 and has
* a parent identifier equal to NIL. The given page file is used for storing the rtree nodes.
* If the page file is not empty, than all entries will be overwritten.
*
* @param  dimension  The data dimension.
* @param  fillFactor A percentage between 0 and 0.5. Used to calculate minimum number of entries
*                    present in each node.
* @param  capacity   The maximun number of entries that each node can hold.
* @param  file       The page file to use for storing the nodes of the rtree.
* @param  type       The RTree variant to use.
*/
public this(int dimension, float fillFactor, int capacity, PageFile file, int type)
{
	debug(RTree) Trace.formatln("RTree.this(int dimension, float fillFactor, int capacity, PageFile file, int type) START.");

	if (dimension <= 1)
	{
		throw new IllegalArgumentException("Dimension must be larger than 1.");
	}

	if (fillFactor < 0 || fillFactor > 0.5)
	{
		throw new IllegalArgumentException("Fill factor must be between 0 and 0.5.");
	}

	if (capacity <= 1)
	{
		throw new IllegalArgumentException("Capacity must be larger than 1.");
	}

	if (type != RTreeType.RTREE_QUADRATIC /*&& type != RTREE_LINEAR && type != RTREE_EXPONENTIAL && type != RSTAR*/)
	{
		throw new IllegalArgumentException("Invalid tree type.");
	}

	if (file.tree !is null)
	{
		throw new IllegalArgumentException("PageFile already in use by another rtree instance.");
	}

	file.initialize(this, dimension, fillFactor, capacity, type);
	this.file = file;

	Leaf root = new Leaf(this, NIL, 0);
	file.writeNode(root);

	debug(RTree) Trace.formatln("RTree.this(int dimension, float fillFactor, int capacity, PageFile file, int type) END.");
}

/**
* Creates an rtree from an already initialized page file, probably stored into persistent storage.
*/
public this(PageFile file)
{
	if (file.tree !is null)
	{
		throw new IllegalArgumentException("PageFile already in use by another rtree instance.");
	}

	if (file.treeType == -1)
	{
		throw new IllegalArgumentException("PageFile is empty. Use some other RTree constructor.");
	}

	file.tree = this;
	this.file = file;
}

//get the root node:
Node getRoot()//was AbstractNode
{
	return file.readNode(0);
}

/**
* Retruns the maximun capacity of each Node.
*/
public int getNodeCapacity()
{
	return file.nodeCapacity;
}

/**
* Returns the percentage between 0 and 0.5, used to calculate minimum number of entries
* present in each node.
*/
public float getFillFactor()
{
	return file.fillFactor;
}

/**
* Returns the data dimension.
*/
public int getDimension()
{
	return file.dimension;
}

/**
* Returns the page.size.
*/
public int getPageSize()
{
	return file.pageSize;
}

/**
* Returns the level of the root Node, which signifies the level of the whole tree. Loads one
* page into main memory.
*/
public int getTreeLevel()
{
	return  file.readNode(0).getLevel();
}

/**
* Returns the RTree variant used.
*/
public int getTreeType()
{
	return file.treeType;
}

/**
* Inserts a HyperCube into the tree, pointing to the data stored at the given page number.
*
* @param h The hypercube to insert.
* @param page The page where the real data is stored.
* @return The page number of the Leaf where the hypercube was inserted (the parent of the
*         data entry.)
*/
public int insert(HyperCube h, int page)
{
	debug(RTree) Trace.formatln("RTree.insert(HyperCube h, int page) START. inserting: {}", h.toString() );

	if (h is null)
	{
		throw new IllegalArgumentException("Rtree.insert(..) : HyperCube cannot be null.");
	}

	if (h.getDimension() != file.dimension)
	{
		throw new IllegalArgumentException("Rtree.insert(..) : HyperCube dimension different than RTree dimension.");
	}

	Node root = file.readNode(0);//AbstractNode

	Leaf l = cast(Leaf)root.chooseLeaf(h);

	debug(RTree) Trace.formatln("RTree.insert(HyperCube h, int page) END. going to Leaf.inserting: {}", h.toString() );
	return l.insert(h, page);
}

/**
* Deletes a HyperCube from the leaf level of the tree. If there is no leaf containg a hypercube
* that matches the given hypercube, the tree is left intact.
*
* @param h The HyperCube to delete.
* @return The data pointer of the deleted entry, NIL if no matching entry was found.
*/
public int delet(HyperCube h)
{
	if (h is null)
	{
		throw new IllegalArgumentException("RTree.delet(..) : HyperCube cannot be null.");
	}

	if (h.getDimension() != file.dimension)
	{
		throw new IllegalArgumentException("RTree.delet(..) : HyperCube dimension different than RTree dimension.");
	}

	Node root = file.readNode(0);//was AbstractNode

	Leaf l = cast(Leaf)root.findLeaf(h);
	if (l !is null)
	{
		//debug(FindLeaf) Trace.formatln( l.toString() );

		h.rtreeNode = null;

		return l.delet(h);
	}
	else Trace.formatln("No such leaf.");
	return NIL;
}

/**
* Returns a Vector containing all tree nodes from bottom to top, left to right.
* CAUTION: If the tree is not memory resident, all nodes will be loaded into main memory.
*
* @param root The node from which the traverse should begin.
* @return A Vector containing all Nodes in the correct order.
*/
//This used to be LinkedList!(Node) all the way:
//public LinkedList!(Node) traverseByLevel(Node root)
public Node[] traverseByLevel(Node root)
{
	if (root is null)
	{
		throw new IllegalArgumentException("RTree.traverseByLevel() : Error : Node cannot be null.");
	}

	//LinkedList!(Node) ret = new LinkedList!(Node);
	//LinkedList!(Node) v = traversePostOrder(root);
	Node[] ret;// = new LinkedList!(Node);
	Node[] v = traversePostOrder(root);

	for (int i = 0; i <= getTreeLevel(); i++)
	{
		//LinkedList!(Node) a = new LinkedList!(Node);
		Node[] a;// = new LinkedList!(Node);
		//for (int j = 0; j < v.size(); j++)
		for (int j = 0; j < v.length; j++)
		{
			//Node n = cast(Node) v.get(j);
			Node n = cast(Node) v[j];
			if (n.getLevel() == i)
			{
				//a.append( cast(Node) n);//a.append(n);
				a ~= cast(Node) n;
			}
		}
		//for (int j = 0; j < a.size(); j++)
		for (int j = 0; j < a.length; j++)
		{
			//ret.append(a.get(j));
			ret ~= a[j];
		}
	}

	return ret;
}

/**
* Returns an Enumeration containing all tree nodes from bottom to top, left to right.
*
* @return An Enumeration containing all Nodes in the correct order.
*/
/+
public Enumeration traverseByLevel()
{
	class ByLevelEnum : Enumeration
	{
		// there is at least one node, the root node.
		private bool hasNext = true;

		private Vector nodes;

		private int index = 0;

		public this()
		{
			AbstractNode root = file.readNode(0);
			nodes = traverseByLevel(root);
		}

		public bool hasMoreElements()
		{
			return hasNext;
		}

		public Object nextElement()
		{
			if (! hasNext)
			{
				throw new NoSuchElementException("traverseByLevel");
			}

			Object n = nodes.elementAt(index);
			index++;
			if (index == nodes.size())
			{
				hasNext = false;
			}

			return n;
		}
	};

	return new ByLevelEnum();
}
+/

int opApply(int delegate(inout HyperCube) dg)//This makes foreach possible on RTrees HyperCubes.
{
	int result = 0;

	Node iter = file.readNode(0);//ListNode!(T) iter;//was AbstractNode
	//iter = begin;

	//version(Release) 
	//LinkedList!(Node) all_nodes = traversePostOrder(iter);//was AbstractNode
	Node[] all_nodes = traversePostOrder(iter);//was AbstractNode //MAYBE scope delete?
	//version(RTreeTester) LinkedList!(AbstractNode) all_nodes = traversePostOrderAll(iter);

	foreach( Node n; all_nodes)//was AbstractNode
	{
		//HyperCube[] hc = n.getHyperCubes();//this makes copies, and that's bad.
		HyperCube[] hc = n.data;

		foreach( HyperCube h; hc )
		{
			if(h !is null)
			{
				result = dg( h );
				if (result)
					break;
			}
		}
		if (result)
			break;
	}

	return result;
}



/**
* Post order traverse of tree nodes. This includes only leaf nodes!
* CAUTION: If the tree is not memory resident, all nodes will be loaded into main memory.
*
* @param root The node where the traversing should begin.
* @return A Vector containing all tree nodes in the correct order.
*/
//public LinkedList!(Node) traversePostOrder(Node root)//was AbstractNode
public Node[] traversePostOrder(Node root)//was AbstractNode
{
	debug(RTreeTraverse) Trace.formatln("RTree.traversePostOrder() START.");

	if (root is null)
	{
		throw new IllegalArgumentException("RTree.traversePostOrder() Error: Node cannot be null.");
	}

	//LinkedList!(Node) v = new LinkedList!(Node);//was AbstractNode
	Node[] v;// = new LinkedList!(Node);//was AbstractNode

	if (root.isLeaf())
	{
		debug(RTreeTraverse) Trace.formatln("RTree.traversePostOrder() root.isLeaf.");
		//v.append(root);
		v ~= root;
	}
	else
	{
		debug(RTreeTraverse) Trace.formatln("RTree.traversePostOrder() root has some children.");
		for (int i = 0; i < root.usedSpace; i++)
		{
			debug(RTreeTraverse) Trace.formatln("RTree.traversePostOrder() child i: {}", i);
			//LinkedList!(Node) a = traversePostOrder((cast(Index) root).getChild(i));//was AbstractNode
			Node[] a = traversePostOrder((cast(Index) root).getChild(i));//was AbstractNode
			//for (int j = 0; j < a.size(); j++)//DONE This should be foreach to make it quicker.
			foreach( Node an; a )//was AbstractNode
			{
				if( an.isLeaf() )
					//v.append( an );
					v ~= an;
			}
		}
	}

	debug(RTreeTraverse) Trace.formatln("RTree.traversePostOrder() END.");
	return v;
}

/**
* Post order traverse of tree nodes. This includes ALL nodes, including index nodes which are just PlainRectangles!
* CAUTION: If the tree is not memory resident, all nodes will be loaded into main memory.
*
* @param root The node where the traversing should begin.
* @return A Vector containing all tree nodes in the correct order.
*/
//public LinkedList!(Node) traversePostOrderAll(Node root)//was AbstractNode
public Node[] traversePostOrderAll(Node root)//was AbstractNode
{
	debug(RTreeTraverse) Trace.formatln("RTree.traversePostOrder() START.");

	if (root is null)
	{
		throw new IllegalArgumentException("RTree.traversePostOrder() Error: Node cannot be null.");
	}

	//LinkedList!(Node) v = new LinkedList!(Node);//AbstractNode
	Node[] v;// = new LinkedList!(Node);//AbstractNode

	//v.append(root);
	v ~= root;

	if (root.isLeaf())
	{
		debug(RTreeTraverse) Trace.formatln("RTree.traversePostOrder() root.isLeaf.");
		//v.append(root); //note that this is just appended before this if in the All version.
	}
	else
	{
		debug(RTreeTraverse) Trace.formatln("RTree.traversePostOrder() root has some children.");
		for (int i = 0; i < root.usedSpace; i++)
		{
			//v.append( (cast(Index) root).getChild(i) );//this was missing at some point, making most of our Indexes disappear from toString();
			v ~= (cast(Index) root).getChild(i);//this was missing at some point, making most of our Indexes disappear from toString();
			debug(RTreeTraverse) Trace.formatln("RTree.traversePostOrder() child i: {}", i);
			//LinkedList!(Node) a = traversePostOrder((cast(Index) root).getChild(i));//was AbstractNode
			Node[] a = traversePostOrder((cast(Index) root).getChild(i));//was AbstractNode
			//for (int j = 0; j < a.size(); j++)
			for (int j = 0; j < a.length; j++)
			{
				//if( a[j].isLeaf() )
					//v.append(a.get(j));
					v ~= a[j];
			}
		}
	}

	debug(RTreeTraverse) Trace.formatln("RTree.traversePostOrder() END.");
	return v;
}


/**
* Post order traverse of all tree nodes, begging with root.
* CAUTION: If the tree is not memory resident, all nodes will be loaded into main memory.
*
* @return An Enumeration containing all tree nodes in the correct order.
*/
/+
public Enumeration traversePostOrder()
{
	class PostOrderEnum : Enumeration
	{
		private bool hasNext = true;

		private Vector nodes;

		private int index = 0;

		public this()
		{
			AbstractNode root = file.readNode(0);
			nodes = traversePostOrder(root);
		}

		public bool hasMoreElements()
		{
			return hasNext;
		}

		public Object nextElement()
		{
			if (! hasNext)
			{
				throw new NoSuchElementException("traversePostOrder");
			}

			Object n = nodes.elementAt(index);
			index++;
			if (index == nodes.size())
			{
				hasNext = false;
			}
			return n;
		}
	};

	return new PostOrderEnum();
}
+/
/**
* Pre order traverse of tree nodes. This includes only leaf nodes!
* CAUTION: If the tree is not memory resident, all nodes will be loaded into main memory.
*
* @param root The node where the traversing should begin.
* @return A Vector containing all tree nodes in the correct order.
*/
//public LinkedList!(Node) traversePreOrder(Node root)//was AbstractNode
public Node[] traversePreOrder(Node root)//was AbstractNode
{
	if (root is null)
	{
		throw new IllegalArgumentException("Node cannot be null.");
	}

	//LinkedList!(Node) v = new LinkedList!(Node);
	Node[] v;// = new LinkedList!(Node);

	if (root.isLeaf())
	{
		//v.append(root);
		v ~= root;
	}
	else
	{
		for (int i = 0; i < root.usedSpace; i++)
		{
			//LinkedList!(Node) a = traversePreOrder((cast(Index) root).getChild(i));
			Node[] a = traversePreOrder((cast(Index) root).getChild(i));
			//for (int j = 0; j < a.size(); j++)
			for (int j = 0; j < a.length; j++)
			{
				//if( a.get(j).isLeaf() )
				if( a[j].isLeaf() )
					//v.append(a.get(j));
					v ~= a[j];
			}
		}
		//v.append(root);
	}
	return v;
}

/**
* Pre order traverse of all tree nodes, begging with root.
* CAUTION: If the tree is not memory resident, all nodes will be loaded into main memory.
*
* @return An Enumeration containing all tree nodes in the correct order.
*/
/+
public Enumeration traversePreOrder()
{
	class PreOrderEnum : Enumeration
	{
		private bool hasNext = true;

		private Vector nodes;

		private int index = 0;

		public this()
		{
			AbstractNode root = file.readNode(0);
			nodes = traversePreOrder(root);
		}

		public bool hasMoreElements()
		{
			return hasNext;
		}

		public Object nextElement()
		{
			if (! hasNext)
			{
				throw new NoSuchElementException("traversePreOrder");
			}

			Object n = nodes.elementAt(index);
			index++;
			if (index == nodes.size())
			{
				hasNext = false;
			}
			return n;
		}
	};

	return new PreOrderEnum();
}
+/
/**
* Returns a Vector with all nodes that intersect with the given HyperCube.
* The nodes are returned in post order traversing
*
* @param h The given HyperCube that is tested for overlapping.
* @param root The node where the search should begin.
* @return A Vector containing the appropriate nodes in the correct order.
*/
//public LinkedList!(Node) intersection(HyperCube h, Node root)//was AbstractNode
public Node[] intersection(HyperCube h, Node root)//was AbstractNode
{
	debug(RTree) Trace.formatln("RTree.intersection(AbstractNode node)...START.");
	if (h is null || root is null)
	{
		throw new IllegalArgumentException("Arguments cannot be null.");
	}

	if (h.getDimension() != file.dimension)
	{
		throw new IllegalArgumentException("HyperCube dimension different than RTree dimension.");
	}

	//LinkedList!(Node) v = new LinkedList!(Node);
	Node[] v;// = new LinkedList!(Node);

	if (root.getNodeMbb().intersection(h))
	{
		if( root.isLeaf() )
		{
			//v.append(root);
			v ~= root;
		}
		else//if (!root.isLeaf())
		{
			for (int i = 0; i < root.usedSpace; i++)
			{
				if (root.data[i].intersection(h))
				{
					//LinkedList!(Node) a = intersection(h, (cast(Index) root).getChild(i));
					Node[] a = intersection(h, (cast(Index) root).getChild(i));
					//for (int j = 0; j < a.size(); j++)
					for (int j = 0; j < a.length; j++)
					{
						//if( a.get(j).isLeaf() )
						if( a[j].isLeaf() )
						{
							//v.append(a.get(j));
							v ~= a[j];
						}
					}
				}
			}
		}
	}
	return v;
}


//public LinkedList!(HyperCube) intersectionList(double sx, double sy, double sw, double sh, bool skip_selected = false)//, out LinkedList!(Node) hit_nodes )
//public LinkedList!(HyperCube) intersectionList(double sx1, double sy1, double sx2, double sy2, bool skip_selected = false)//, out LinkedList!(Node) hit_nodes )
public HyperCube[] intersectionList(double sx1, double sy1, double sx2, double sy2, bool skip_selected = false)//, out LinkedList!(Node) hit_nodes )
{
	scope PlainRectangle rect = new PlainRectangle(sx1, sy1, sx2, sy2);
	//LinkedList!(HyperCube) retlist = intersectionList(rect, getRoot(), skip_selected );//, hit_nodes );//new HyperCube(p, p), getRoot() );
	HyperCube[] retlist = intersectionList(rect, getRoot(), skip_selected );//, hit_nodes );//new HyperCube(p, p), getRoot() );
	return retlist;
}

//public LinkedList!(HyperCube) intersectionList( HyperCube h, bool skip_selected = false )
public HyperCube[] intersectionList( HyperCube h, bool skip_selected = false )
{
	//LinkedList!(HyperCube) retlist = intersectionList(h, getRoot(), skip_selected );
	HyperCube[] retlist = intersectionList(h, getRoot(), skip_selected );
	return retlist;
}

//public LinkedList!(HyperCube) intersectionList(HyperCube h, Node root, bool skip_selected )//, out LinkedList!(Node) hit_nodes )//was AbstractNode
public HyperCube[] intersectionList(HyperCube h, Node root, bool skip_selected )//, out LinkedList!(Node) hit_nodes )//was AbstractNode
{
	debug(RTree) Trace.formatln("RTree.intersectionList(AbstractNode node)...START.");

	if (h is null || root is null)
		throw new IllegalArgumentException("Arguments cannot be null.");

	if (h.getDimension() != file.dimension)
		throw new IllegalArgumentException("HyperCube dimension different than RTree dimension.");

	//LinkedList!(HyperCube) hit_items = new LinkedList!(HyperCube);
	HyperCube[] hit_items;// = new LinkedList!(HyperCube);
	//LinkedList!(Node) hit_nodes = new LinkedList!(Node);

	//scope LinkedList!(Node) hit_nodes = intersection( h, root );
	scope Node[] hit_nodes = intersection( h, root );

	//Trace.formatln( "Hit nodes List:\n{}", hit_nodes.toString() );

	foreach( Node n; hit_nodes)
	{
		HyperCube[] hc = n.data;

		foreach( HyperCube it; hc )
		{
			if(it !is null)
			{
				if( skip_selected && it.isSelected() == true )
				{
					//then we skip this because it's selected.
				}
				else if( it.intersection( h ) )
				{
					//it.parentNode = n;
					//hit_items.append( it );
					hit_items ~= it;
					//hit_nodes.append( n );
				}
			}
		}
	}

	//Trace.formatln( "Hit items List:\n{}", hit_items.toString() );

	return hit_items;
}

/**
* Returns an Enumeration with all nodes present in the tree that intersect with the given
* HyperCube. The nodes are returned in post order traversing
*
* @param h The given HyperCube that is tested for overlapping.
* @return An Enumeration containing the appropriate nodes in the correct order.
*/
/+
public Enumeration intersection(HyperCube h) {
	class IntersectionEnum : Enumeration
	{
	private bool hasNext = true;

	private Vector nodes;


	private int index = 0;

	public this(HyperCube hh) {
		nodes = intersection(hh, file.readNode(0));
		if (nodes.isEmpty()) {
		hasNext = false;
		}
	}

	public bool hasMoreElements() {
		return hasNext;
	}

	public Object nextElement() {
		if (! hasNext) {
		throw new NoSuchElementException("intersection");
		}

		Object c = nodes.elementAt(index);
		index++;
		if (index == nodes.size()) {
		hasNext = false;
		}
		return c;
	}
	};

	return new IntersectionEnum(h);
}
+/

//public LinkedList!(HyperCube) enclosureList(Point p, Node root )//, out LinkedList!(Node) hit_nodes )//was AbstractNode
public HyperCube[] enclosureList(Point p, Node root )//, out LinkedList!(Node) hit_nodes )//was AbstractNode
{
	scope PlainRectangle rect = new PlainRectangle(p, p);
	//LinkedList!(HyperCube) retlist = enclosureList(rect, root );//, hit_nodes);//new HyperCube(p, p), root);
	HyperCube[] retlist = enclosureList(rect, root );//, hit_nodes);//new HyperCube(p, p), root);
	return retlist;
}

//And for convenience:
//public LinkedList!(HyperCube) enclosureList(Point p )//, out LinkedList!(Node) hit_nodes )
public HyperCube[] enclosureList(Point p )//, out LinkedList!(Node) hit_nodes )
{
	scope PlainRectangle rect = new PlainRectangle(p, p);
	//LinkedList!(HyperCube) retlist = enclosureList(rect, getRoot() );//, hit_nodes );//new HyperCube(p, p), getRoot() );
	HyperCube[] retlist = enclosureList(rect, getRoot() );//, hit_nodes );//new HyperCube(p, p), getRoot() );
	return retlist;
}

//And for convenience:
//public LinkedList!(HyperCube) enclosureList(double sx, double sy )//, out LinkedList!(Node) hit_nodes )
public HyperCube[] enclosureList(double sx, double sy )//, out LinkedList!(Node) hit_nodes )
{
	//scope PlainRectangle rect = new PlainRectangle(sx, sy, 0.0, 0.0);//w h version
	scope PlainRectangle rect = new PlainRectangle(sx, sy, sx, sy);
	//LinkedList!(HyperCube) retlist = enclosureList(rect, getRoot() );//, hit_nodes );//new HyperCube(p, p), getRoot() );
	HyperCube[] retlist = enclosureList(rect, getRoot() );//, hit_nodes );//new HyperCube(p, p), getRoot() );
	return retlist;
}

//And for convenience:
//public LinkedList!(HyperCube) enclosureList(double sx, double sy, double sw, double sh )//, out LinkedList!(Node) hit_nodes )
//public LinkedList!(HyperCube) enclosureList(double sx1, double sy1, double sx2, double sy2 )//, out LinkedList!(Node) hit_nodes )
public HyperCube[] enclosureList(double sx1, double sy1, double sx2, double sy2 )//, out LinkedList!(Node) hit_nodes )
{
	scope PlainRectangle rect = new PlainRectangle(sx1, sy1, sx2, sy2);
	return enclosureList(rect, getRoot() );//, hit_nodes );//new HyperCube(p, p), getRoot() );
}

//public LinkedList!(HyperCube) enclosureList(HyperCube h, Node root )//, out LinkedList!(Node) hit_nodes )//was AbstractNode
public HyperCube[] enclosureList(HyperCube h, Node root )//, out LinkedList!(Node) hit_nodes )//was AbstractNode
{
	debug(RTree) Trace.formatln("RTree.enclosureList(AbstractNode node)...START.");

	if (h is null || root is null)
		throw new IllegalArgumentException("Arguments cannot be null.");

	if (h.getDimension() != file.dimension)
		throw new IllegalArgumentException("HyperCube dimension different than RTree dimension.");

	//LinkedList!(HyperCube) hit_items = new LinkedList!(HyperCube);
	HyperCube[] hit_items;// = new HyperCube[];
	//Not needed anymore: LinkedList!(Node) hit_nodes = new LinkedList!(Node);

	//scope LinkedList!(Node) hit_nodes = enclosure( h, root );
	scope Node[] hit_nodes = enclosure( h, root );

		
	debug(RTree) Trace.formatln( "Going through the hit_nodes list gotten from enclosure. hit_nodes.length: {}", hit_nodes.length );
	//debug(RTree) Trace.formatln( "Hit nodes List:\n{}", hit_nodes[0].toString() );

	debug(RTree) uint d_counter = 0;
	foreach( Node n; hit_nodes)
	{
		debug(RTree) Trace.formatln("foreach Node n; hit_nodes. {}", d_counter );
		HyperCube[] hc = n.data;

		debug(RTree) Trace.formatln("hc.length: {}", hc.length );

		foreach( HyperCube it; hc )
		{
			debug(RTree) Trace.formatln("inner foreach.");
			if(it !is null && it.isHidden == false )
			{
				debug(RTree) Trace.formatln("testing for enclosure then.");
				if( it.enclosure( h ) )
				{
					debug(RTree) Trace.formatln("Yes. It was inside. Appending to hit_items list.");
					//it.parentNode = n;
					//hit_items.append( it );
					hit_items ~= it;
					//hit_nodes.append( n );
				}
			}
		}
		
		debug(RTree) d_counter++;
	}

	debug(RTree) Trace.formatln("Got to the end of enclosure() in RTree. Now returning list.");
	//Trace.formatln( "Hit items List:\n{}", hit_items.toString() );
	debug(RTree)
	{
		foreach( HyperCube it; hit_items )
		{
			Trace.formatln("hit ICanvasItem: {}", it.toString() );
		}
	}

	return hit_items;
	//
	/*
	LinkedList!(Node) v = new LinkedList!(Node);

	Trace.formatln("RTree.enclosureList(h) Checking if canvasitem: {}{}{}", h.toString(), " is enclosed in this root: ", root.getNodeMbb().toString() );

	if (root.getNodeMbb().enclosure(h))
	{
		Trace.formatln("RTree.enclosureList(h) YES it is enclosed.");
		if( root.isLeaf() )
		{
			Trace.formatln("RTree.enclosureList(h) root is Leaf, adding to List.");
			v.append(root);
		}
		else
		{
			Trace.formatln("RTree.enclosureList(h) root is Index. Going through it's children.'");
			for (int i = 0; i < root.usedSpace; i++)
			{
				Trace.formatln("RTree.enclosureList(h) children i: {}", i);
				if( root.data[i].enclosure(h) )
				{
					Trace.formatln("RTree.enclosureList(h) i: {}{}", i, " is enclosed. Getting an enclosure List from it.");
					LinkedList!(Node) a = enclosure(h, (cast(Index) root).getChild(i));
					for (int j = 0; j < a.size(); j++)
					{
						Trace.formatln("RTree.enclosureList(h) list has member j: {}", j);
						if( a[j].isLeaf() )
						{
							Trace.formatln("RTree.enclosureList(h) and j: {}{}", j, " is a Leaf.");
							v.append(a[j]);
						}
					}
				}
			}
		}
	}
	else Trace.formatln("RTree.enclosureList(h) NO it is not enclosed.");

	return v;*/
}



/**
* Returns a Vector with all Hypercubes that completely contain HyperCube <B>h</B>.
* The HyperCubes are returned in post order traversing, according to the Nodes where
* they belong.
*
* @param h The given HyperCube.
* @param root The node where the search should begin.
* @return A Vector containing the appropriate HyperCubes in the correct order.
*/

//public LinkedList!(Node) enclosure(HyperCube h, Node root)//was AbstractNode
public Node[] enclosure(HyperCube h, Node root)//was AbstractNode
{
	debug(RTree) Trace.formatln("RTree.enclosure(AbstractNode node)...START.");

	if (h is null || root is null)
		throw new IllegalArgumentException("Arguments cannot be null.");

	if (h.getDimension() != file.dimension)
		throw new IllegalArgumentException("HyperCube dimension different than RTree dimension.");

	//LinkedList!(Node) v = new LinkedList!(Node);
	Node[] v;// = new LinkedList!(Node);

	debug(RTree) Trace.formatln("RTree.enclosure(h) Checking if canvasitem: {}{}{}", h.toString(), " is enclosed in this root: ", root.getNodeMbb().toString() );

	if (root.getNodeMbb().enclosure(h))
	{
		debug(RTree) Trace.formatln("RTree.enclosure(h) YES it is enclosed.");
		if( root.isLeaf() )
		{
			debug(RTree) Trace.formatln("RTree.enclosure(h) root is Leaf, adding to List.");
			//v.append(root);
			v ~= root;
		}
		else
		{
			debug(RTree) Trace.formatln("RTree.enclosure(h) root is Index. Going through it's children.'");
			for (int i = 0; i < root.usedSpace; i++)
			{
				debug(RTree) Trace.formatln("RTree.enclosure(h) children i: {}", i);
				if( root.data[i].enclosure(h) )
				{
					debug(RTree) Trace.formatln("RTree.enclosure(h) i: {}{}", i, " is enclosed. Getting an enclosure List from it.");
					//LinkedList!(Node) a = enclosure(h, (cast(Index) root).getChild(i));
					Node[] a = enclosure(h, (cast(Index) root).getChild(i));
					//for (int j = 0; j < a.size(); j++)
					for(int j = 0; j < a.length; j++)//foreach?
					{
						debug(RTree) Trace.formatln("RTree.enclosure(h) list has member j: {}", j);
						//if( a.get(j).isLeaf() )
						if( a[j].isLeaf() )
						{
							debug(RTree) Trace.formatln("RTree.enclosure(h) and j: {}{}", j, " is a Leaf.");
							//v.append(a.get(j));
							v ~= a[j];
						}
					}
				}
			}
		}
	}
	else
	{
		debug(RTree) Trace.formatln("RTree.enclosure(h) NO it is not enclosed.");
	}

	return v;
}


/**
* Returns an Enumeration with all Hypercubes present in the tree that contain the given
* HyperCube. The HyperCubes are returned in post order traversing, according to the Nodes where
* they belong.
*
* @param h The given HyperCube.
* @param root The node where the search should begin.
* @return An Enumeration containing the appropriate HyperCubes in the correct order.
*/
/+
public Enumeration enclosure(HyperCube h) {
	class ContainEnum : Enumeration {
	private bool hasNext = true;

	private Vector cubes;

	private int index = 0;

	public this(HyperCube hh) {
		cubes = enclosure(hh, file.readNode(0));
		if (cubes.isEmpty()) {
		hasNext = false;
		}
	}

	public bool hasMoreElements() {
		return hasNext;
	}

	public Object nextElement() {
		if (!hasNext) throw new
		NoSuchElementException("enclosure");

		Object c = cubes.elementAt(index);
		index++;
		if (index == cubes.size()) {
		hasNext = false;
		}
		return c;
	}
	};

	return new ContainEnum(h);
}
+/
/**
* Returns a Vector with all Hypercubes that completely contain point <B>p</B>.
* The HyperCubes are returned in post order traversing, according to the Nodes where
* they belong.
*
* @param p The given point.
* @param root The node where the search should begin.
* @return A Vector containing the appropriate HyperCubes in the correct order.
*/
//public LinkedList!(Node) enclosure(Point p, Node root)//was AbstractNode
public Node[] enclosure(Point p, Node root)//was AbstractNode
{
	scope PlainRectangle rect = new PlainRectangle(p, p);
	return enclosure(rect, root);//new HyperCube(p, p), root);
}

//And for convenience:
//public LinkedList!(Node) enclosure(Point p)
public Node[] enclosure(Point p)
{
	scope PlainRectangle rect = new PlainRectangle(p, p);
	return enclosure(rect, getRoot() );//new HyperCube(p, p), getRoot() );
}

//And for convenience:
//public LinkedList!(Node) enclosure(double sx, double sy)
public Node[] enclosure(double sx, double sy)
{
	//scope PlainRectangle rect = new PlainRectangle(sx, sy, 0.0, 0.0);
	scope PlainRectangle rect = new PlainRectangle(sx, sy, sx, sy);
	return enclosure(rect, getRoot() );//new HyperCube(p, p), getRoot() );
}

/**
* Returns an Enumeration with all Hypercubes present in the tree that contain the given
* point. The HyperCubes are returned in post order traversing, according to the Nodes where
* they belong.
*
* @param p The query point.
* @param root The node where the search should begin.
* @return An Enumeration containing the appropriate HyperCubes in the correct order.
*/
/+
public Enumeration enclosure(Point p) {
	return enclosure(new HyperCube(p, p));
}
+/




/**
* Returns the nearest HyperCube to the given point.
* [King Lum Cheung and Ada Wai-chee Fu: Enhanced Nearest Neighbour Search on the R-Tree]
*
* @param p The query point.
* @return A vector containing all the nodes lying in the search path until the nearest hypercube
*         is found. Elements are instances of AbstractNode and Data classes. The last Data instance
*         in the vector is the answer to the query.
*/

public HyperCube nearestNeighbour( double fx, double fy, bool skip_selected, RTreeSearchType search_type = RTreeSearchType.ALL )
{
	debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbour(double, double) START.");
	scope Point p = new Point( fx, fy );//TODO we should get rid of this Point type. It's annoying. double x, double y is just fine.
	debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbour(double, double) Going to try nearestNeighbourList(Point).");
	//scope LinkedList!(Object) list_objects = nearestNeighbourList( p, skip_selected, search_type );
	scope Object[] list_objects = nearestNeighbourList( p, skip_selected, search_type );

	//if( list_objects !is null && list_objects.size() != 0 )
	if( list_objects !is null && list_objects.length != 0 )
	{
		debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbour(double, double) list_objects isn't null. Trying to get list_objects.tail().");
		//Object lastob = list_objects.tail();
		Object lastob = list_objects[list_objects.length-1];

		debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbour(double, double) Checking lastob.classinfo.name.");
		if (lastob.classinfo.name == "ptl.rtree.data.Data")
		{
			debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbour(double, double) END. Last was of type Data. lastob: ", (cast(Data)lastob).mbb.toString() );
			return (cast(Data)lastob).mbb;
		}
		else
		{
			debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbour(double, double) It wasn't Data. Going to go throught the list_objects with foreach.");
			int i = 0;
			foreach( Object o; list_objects ) //This surely would benefit from backwards traversal of lists.
			{
				debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbour(double, double) Checking object i:", i, " o.toString: ", o.toString() );
				if (o.classinfo.name == "ptl.rtree.data.Data")
				{
					lastob = o;
				}
				else if( o.classinfo.name == "ptl.rtree.leaf.Leaf")
				{
					debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbour(double, double) i is a Leaf.");
				}
				else
				{
					debug(RTreeNearestNeighbour) Trace.formatln("o.classinfo.name: {}", o.classinfo.name );
				}
				i++;
			}

			if( lastob !is null && lastob.classinfo.name == "ptl.rtree.data.Data" )
			{
				debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbour(double, double) END. Had to go through the list. lastob: {}", (cast(Data)lastob).mbb.toString() );
				return (cast(Data)lastob).mbb;
			}
			else
			{
				debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbour(d,d) None of the list_objects items was a Data object.");
			}
		}
	}
	else
	{
		debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbour(d,d) Error: didn't find any nearestNeighbour.");
	}
	return null;
}

//CHECK: Is this usable at all. To me it seems that nearestNeighbourSearch
//returns just material for the actual nearestNeighbour()...
//public LinkedList!(Object) nearestNeighbourList(Point p, bool skip_selected, RTreeSearchType search_type = RTreeSearchType.ALL )
public Object[] nearestNeighbourList(Point p, bool skip_selected, RTreeSearchType search_type = RTreeSearchType.ALL )
{
	debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbourList(Point p) START.");
	debug(RTreeNearestNeighbour) scope(exit) Trace.formatln("RTree.nearestNeighbourList(Point p) END.");
	return nearestNeighbourSearch(file.readNode(0), p, double.max, skip_selected, search_type );
}

/**
* Used for nearest neighbour recursive search into the RTree structure. <B>n</B> is the current
* node of the active branch list, searched. <B>p</B> is the query point. <B>nearest</B> is the
* distance of <B>p</B> from current nearest hypercube <B>h</B>.
*/

//satp: How to make this work as it uses a List with both Data and AbstractNodes? Maybe LinkedList!(Object), but does that work with other stuff...?)
//protected LinkedList!(Object) nearestNeighbourSearch(Node n, Point p, double nearest, bool skip_selected, RTreeSearchType search_type )//was AbstractNode
protected Object[] nearestNeighbourSearch(Node n, Point p, double nearest, bool skip_selected, RTreeSearchType search_type )//was AbstractNode
{
	debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbourSearch(AbstractNode n, Point p, float nearest) START. point p: {}", p.toString() );
	//LinkedList!(Object) ret = new LinkedList!(Object);
	Object[] ret;
	HyperCube h;

	if (n.isLeaf())
	{
		debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbourSearch(AbstractNode n, Point p, float nearest) This is a leaf. Returning it's nearest child as a Data object. n.toString: {}", n.toString() );
		for (int i = 0; i < n.usedSpace; i++)
		{
			debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbourSearch(AbstractNode n, Point p, float nearest) for i < usedSpace. Trying n.data[i].getMinDist(p). i:{}", i );
			//If the data[i] i.e. CanvasItem is selected, then we ignore it from the nearestNeighbour search.
			//This is what Scene wants, but I might have to change the behaviour for Edits.
			//We'll see. satp.
			//Done with skip_selected...
			if( n.data[i] !is null )
			{
				bool skip_it_anyway = false;

				//Notice that RTreeSearchType.ALL is default and it will
				//just pass through these two.
				if( search_type == RTreeSearchType.LEFT && p.x <= n.data[i].x1 )//This presumes that .x1 is left side of the item.
				{
					//We had to change the test to be p.x <= n.data[i].x.
					//<= did the trick, because then it would skip the one that it was sitting on top of...
					//TODO.. MAYBE..Maybe we could do this in a way that it would check if p intersects n.data[i]
					//and if it does (and seach_type == LEFT or RIGHT ) then skip it.
					//Ofcourse in normal cases when search_type would be ALL, and
					//the intersected would also appear on the results.
					//But this might not be necessary if the <= approach works on all_nodes
					//relevant cases.
					skip_it_anyway = true;
				}
				else if( search_type == RTreeSearchType.RIGHT && p.x >= n.data[i].x2 )//This presumes that .x2 is right side of the item.
				{
					skip_it_anyway = true;
				}

				if( skip_selected == true && n.data[i].isSelected() == true )
				{
					//skip this, it's selected.
				}
				else if( skip_it_anyway == true )
				{
					//skip this, it's left or right when we don't want it to be.
					debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbourSearch(..) Skipping because it's LEFT or RIGHT i: {}{}{}", i, " name: ", n.data[i].toString() );
				}
				else
				{
					float dist = n.data[i].getMinDist(p);
					if (dist < nearest)
					{
						debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbourSearch(AbstractNode n, Point p, float nearest) This is nearest: i: {}{}{}{}{}{}{}", i, " name: ", n.data[i].toString(), " dist: ", dist, " nearest: ", nearest );
						h = n.data[i];
						nearest = dist;
						//ret.append(new Data(h, n.branches[i], n.pageNumber, i));
						ret ~= new Data(h, n.branches[i], n.pageNumber, i);
					}
				}
				//else Trace.formatln("None of the children was near enough.");
			}
		}
		debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbourSearch(AbstractNode n, Point p, float nearest) END. Leaf. Return Data.");
		return ret;
	}
	else
	{
	// generate Active Branch List.

	scope ABLNode[] abl = new ABLNode[n.usedSpace];

	for (int i = 0; i < n.usedSpace; i++)
	{
		Node ch = (cast(Index) n).getChild(i);//was AbstractNode
		abl[i] = new ABLNode(ch , ch.getNodeMbb().getMinDist(p));
	}

	// sort ABL in ascending order of MINDIST from the query point.
	Sort.mergeSort
	(
		abl,
		new Comparator()
	);

	double revert_nearest = nearest;//a BIG TODO... how to get this return to searching even if the node is close but it doesn't have any good hypercubes in it???

	// traverse all ABL nodes and prune irrelevant nodes according to the MINDIST heuristic.
	for (int i = 0; i < abl.length; i++)
	{
		//TODO add a check for LEFT and RIGHT seachType. If the node is totally
		//on the LEFT (e.g.) then don't even bother with it.
		if (abl[i].minDist <= nearest)
		{
			// add node in the results vector, if it complies to the MINDIST heuristic.
			// BUT... So, do we even need this node in the results if we're only interested about CanvasItems...
			//I don't think we need it...
			////////////ret.append(abl[i].node);

			// recursively continue the search.
			//scope LinkedList!(Object) v = nearestNeighbourSearch(abl[i].node, p, nearest, skip_selected, search_type );
			scope Object[] v = nearestNeighbourSearch(abl[i].node, p, nearest, skip_selected, search_type );

			// find the new nearest distance and add all the nodes accessed, into the current
			// results vector.
			try //Well, tango has this too: I think this catching an Exception named NoSuchElementException is a Java thing and should be removed.
			//We are now checking if the Object o is null or not.
			{
				//Object o = v.tail();
				Object o = v[v.length-1];
				if( o !is null )
				{
					if ( o.classinfo.name == "ptl.rtree.leaf.Leaf" || o.classinfo.name == "ptl.rtree.index.Index" || o.classinfo.name == "ptl.rtree.abstractnode.AbstractNode")
					{
						//It seems to me now, that we don't need to add the Leaves and Indexes to the List ret. We don't want to know
						//the closest Index which doesn't have any interesting CanvasItems in it...
						/*for (int j = 0; j < v.size; j++)
						{
							ret.append(v.get(j));
						}*/
						//AbstractNode an = cast(AbstractNode) o;
						//h = cast(HyperCube) an.getNodeMbb();
						//nearest = h.getMinDist(p);
					}
					else if (o.classinfo.name == "ptl.rtree.data.Data")
					{
						// if the current node searched was a leaf, than the resulting set definetly
						// contains just one HyperCube, the nearest to the query point.
						h = (cast(Data) o).mbb;
						nearest = h.getMinDist(p);
						revert_nearest = nearest;//update revert_nearest...??
						//ret.append(o);
						ret ~= o;
					}
				}
				else
				{
					debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbourSearch() It seem's that our Leaf returned an empty List. Reverting back to old nearest.");
					nearest = revert_nearest;
				}
			}
			catch (tango.core.Exception.NoSuchElementException e)
			{
				// no nearest node or hypercube was found from this recursion step. Leave nearest
				// distance intact.
			}
		}
	}

	debug(RTreeNearestNeighbour) Trace.formatln("RTree.nearestNeighbourSearch(AbstractNode n, Point p, float nearest) END.");
	return ret;
	}
}



	public string toString()
	{
		string ret_str;

		Node root = getRoot();//file.readNode(0);//AbstractNode

		ret_str ~= "RTree.toString() START :\n";

		if(root !is null)
		{
			//LinkedList!(Node) all_nodes = traversePostOrderAll(root);//or the option to leave out the Index nodes: traversePostOrder(root);//was AbstractNode
			//MAYBE scope delete:
			Node[] all_nodes = traversePostOrderAll(root);//or the option to leave out the Index nodes: traversePostOrder(root);//was AbstractNode

			ret_str ~= "The tree contains ";
			//ret_str ~= Integer.toString( all_nodes.size );
			ret_str ~= Integer.toString( all_nodes.length );
			ret_str ~= " nodes.";
			ret_str ~= "\nTree nodeCapacity: ";
			ret_str ~= Integer.toString( getNodeCapacity() );
			ret_str ~= "\nTree dimension: ";
			ret_str ~= Integer.toString( getDimension() );
			ret_str ~= "\nTree pageSize: ";
			ret_str ~= Integer.toString( getPageSize() );
			ret_str ~= "\nTree fillFactor: ";
			ret_str ~= Float.toString( getFillFactor() );
			ret_str ~= "\n";

			foreach( Node n; all_nodes)//was AbstractNode
			{
				ret_str ~= n.toString();
			}
		}

		ret_str ~= "RTree.toString() END.";

		return ret_str;
	}

	//methods to support List interface:

	void append(HyperCube h, int pag = -2)//should this be add() or put()
	{
		insert(h, pag);
	}

	//void prepend()

	void remove(HyperCube h)
	{
		int res = delet( h );
		//debug(FindLeaf)
		//{
			if(res == NIL)
			{
				Trace.formatln("The RTree we though had it: {}", toString() );
				Trace.formatln("The HyperCube we tried to remove: {}", h.toString() );

				throw new IllegalArgumentException("RTree.remove(h) : Remove didn't work.'");
			}
		//}
	}

	public void debugCheckStart()
	{
		debug(RTreeError)
		{
			static int count_times_used = 0;
			count_times_used++;
			Trace.formatln("RTree.debugCheckStart() START. times: {}", count_times_used );
		}
		debugCheck( getRoot() );
		debug(RTreeError) Trace.formatln("RTree.debugCheckStart() END.");
	}

	//public LinkedList!(Node) debugCheck( Node root )//was AbstractNode
	public Node[] debugCheck( Node root )//was AbstractNode
	{
		debug(RTreeError) Trace.formatln("RTree.debugCheck() START." );

		if (root is null)
		{
			throw new IllegalArgumentException("RTree.debugCheck() Error: Node cannot be null.");
		}

		//LinkedList!(Node) v = new LinkedList!(Node);//was AbstractNode
		Node[] v;// = new LinkedList!(Node);//was AbstractNode

		if (root.isLeaf())
		{
			debug(RTreeError) Trace.formatln("RTree.debugCheck() root.isLeaf.");
			//v.append(root);
			v ~= root;
		}
		else
		{
			//One thing to clarify is that: A node doesn't know it's own bounding box.
			//This seems a little wierd, and TODO is to check if it would be possible to make a
			//node contain it's own rectangle, instead of the parent having it in it's HyperCube data[i] member.
			//I guess it might have something to do with the possibility of a pagefile using the disk instead
			//of the main merory... But i don't know.
			//Anyway, because of this, a node can only check if it's grandchildren are enclosed in it's children.
			//This would lead me to think that the Root node of the whole Tree doesn't have a rectanle.
			//Which would be redundant anyway, because all the nodes are always contained in it.
			//I'm just beginning to understand this RTree structure and this particular implementation. satp.

			//and because the "int parent" is contained in the node, we check that differently:
			//we compare if the current root node is the parent of it's children.

			debug(RTreeError) Trace.formatln("RTree.debugCheck() root has some children.");
			for (int i = 0; i < root.usedSpace; i++) //Go though the children of root.
			{
				debug(RTreeError) Trace.formatln("RTree.debugCheck() child i: {}", i);

				//First we check if child i has it's "int parent" set properly. It should have
				//the same number as our current root's pageNumber is.

				Node n = (cast(Index) root).getChild(i);//was AbstractNode
				if( n.parent != root.pageNumber )
				{
					Trace.formatln("RTree.debugCheck() node parent error: Here's the tree: {}", toString() );
					Trace.formatln("RTree.debugCheck() These nodes have different int parent members: currentnode: {}", root.toString(), " and it's child node: ", n.toString() );
					throw new Exception( "RTree.debugCheck() Error in RTree. Some cubes parent and pageNumbers don't match." );
				}

				HyperCube parent_cube = root.data[i];//Get the rectangle of child i.

				//LinkedList!(Node) a = debugCheck( (cast(Index) root).getChild(i) );//recursively get the children of the current root node.//was AbstractNode
				Node[] a = debugCheck( (cast(Index) root).getChild(i) );//recursively get the children of the current root node.//was AbstractNode
				//This means that we actually go to the bottom and then come back up from there.

				//Then we go through that childnodes nodes. And check if they are enclosed in the rectangle of child i.
				//for (int j = 0; j < a.size(); j++)//DONE This should be foreach to make it quicker.
				foreach( Node an; a )//was AbstractNode
				{
					//if( a.get(j).isLeaf() )
						//v.append( an );
						v ~= an;
					HyperCube[] hs = an.data;
					foreach( HyperCube h; hs )
					{
						if( h !is null && parent_cube !is null)
						{
							if( parent_cube.enclosure( h ) == false )
							{
								Trace.formatln( "RTree.debugCheck() These Nodes dont match: root: {}{}{}", root.toString(), " and an:", an.toString() );//, " leafcube[", i, "]:", h.toString() );
								Trace.formatln( "RTree.debugCheck() These Cubes dont match: indexcube[{}{}{}{}{}{}{}", i, "]:", parent_cube.toString(), " leafcube[", i, "]:", h.toString() );
								Trace.formatln("And here's the tree: {}", toString() );
								throw new Exception( "RTree.debugCheck() Error in RTree. Some cubes don't match." );
							}
						}
						else
						{
							debug(RTreeError) Trace.formatln("RTree.debugCheck() The other is null. ");
						}
					}
				}
			}
		}

		debug(RTreeError) Trace.formatln("RTree.debugCheck() END.");
		return v;
	}


}//class RTree


unittest
{
	debug(RTree) Trace.formatln("Performing RTree unittest: START.");

	scope RTree itemTree = new RTree();

	Rectangle edit1 = new Rectangle();
	edit1.setXYXY( 123.333, 0.0, 448.333, 30.0 );
	edit1.name = "edit1";

	HyperCube edit2 = new Rectangle();
	edit2.setXYXY( 450.0, 0.0, 480.0, 30.0 );
	//edit2.name = "edit2";

	Rectangle edit3 = new Rectangle();
	edit3.setXYXY( 482.0, 0.0, 512.0, 30.0 );
	edit3.name = "edit3";

	Rectangle edit4 = new Rectangle();
	edit4.setXYXY( 515.0, 0.0, 612.0, 30.0 );
	edit4.name = "edit4";

	itemTree.append(edit1);
	itemTree.append(edit2);
	//Trace.formatln("RTree: ", items.toString() );
	//assert(0);
	itemTree.append(edit3);
	itemTree.append(edit4);
	itemTree.remove(edit4);

	//Trace.formatln("RTree: ", items.toString() );
	//assert(0);

	itemTree.remove(edit1);

	debug(RTree) Trace.formatln("RTree after remove unittest contents: {}", itemTree.toString() );
	debug(RTree) Trace.formatln("Tried to remove: {}\n\n", edit1.toString() );

	for( uint d = 0; d < 1; d++ )
	{

		uint num_of_elements = 2;
	
		debug(RTree) Trace.formatln( "\n\n\nAdding {} elements.\n\n\n", num_of_elements );
	
		//LinkedList!(Rectangle) rects = new LinkedList!(Rectangle);
		Rectangle[] rects;// = new LinkedList!(Rectangle);
		for( uint i = 0; i < num_of_elements; i++ )
		{
			debug(RTree) Trace.formatln( "Adding element {}.", i );
		
			Rectangle re = new Rectangle();
			re.setXYXY( i*10.0f, 0.0f, (i*10.0) + 10.0f, 18.0f );
			//rects.append(re);
			rects ~= re;
			itemTree.append(re);
		}
		
		debug(RTree) Trace.formatln( "Moving and adjusting tree for {} elements.", num_of_elements );
		foreach( Rectangle r; rects )
		{
			r.xPos = r.xPos + 8.0f;
			r.yPos = r.yPos + 5.0f;
			r.adjustTree();
		}
		
		debug(RTree) Trace.formatln( "Removing every other of {} elements.", num_of_elements );
		for( uint i = 0; i < num_of_elements; )
		{
			debug(RTree) Trace.formatln( "Trying to remove element {}.", i );
			//itemTree.remove( rects.get(i) );
			itemTree.remove( rects[i] );
			i = i + 2;
		}
	}	
	
	debug(RTree) Trace.formatln( "\nTesting enclosureList()." );
	//LinkedList!(ICanvasItem) my_hit_items = itemTree.enclosureList( 500.0f, 5.0f, 510.0f, 10.0f );
	ICanvasItem[] my_hit_items = itemTree.enclosureList( 500.0f, 5.0f, 510.0f, 10.0f );
	foreach( ICanvasItem r; my_hit_items )
	{
		debug(RTree) Trace.formatln( "hit name: {}", r.name );
	}
	

	debug(RTree) Trace.formatln( "All done in RTree unittest." );

	//assert(0); //A breakpoint.

	itemTree.remove(edit2);
	itemTree.remove(edit3);

	delete edit1;
	delete edit2;
	delete edit3;
	delete edit4;
	
	//Another test:
	debug(RTree) Trace.formatln("\n\n\nintersectionList test.");
	
	scope Rectangle rec1 = new Rectangle();
	rec1.setXYXY( 100.0, 100.0, 200.0, 200.0 );
	rec1.name = "rec1";
	itemTree.append(rec1);

	scope Rectangle rec2 = new Rectangle();
	rec2.setXYXY( 250.0, 250.0, 300.0, 300.0 );
	rec2.name = "rec2";
	itemTree.append(rec2);
	
	scope Rectangle rec3 = new Rectangle();
	rec3.setXYXY( 180.0, 180.0, 220.0, 220.0 );
	rec3.name = "rec3";
	itemTree.append(rec3);
	
	debug(RTree) Trace.formatln( "List should read: rec1 and rec2. NOT rec3." );
	
	scope ICanvasItem[] render_items = itemTree.intersectionList( 100.0, 100.0, 200.0, 200.0 );
	foreach( ICanvasItem r; render_items )
	{
		debug(RTree) Trace.formatln( "hit name: {}", r.name );
	}


	debug(RTree) Trace.formatln("Performing RTree unittest: END.");
	
	//assert(0);
}


/+

//void main(string[] args)
void main( char[][] args )
{
	Trace.formatln("\n\nHello RTree!\n\n");

	//PersistantPageFile file = new PersistantPageFile("c:/temp/rtree.dat");
	//CachedPersistentPageFile file = new CachedPersistentPageFile("/home/joonaz/temp/rtree.dat", 3);
	//MemoryPageFile file = new MemoryPageFile();//created automatically if we leave the file out of next one...
	//RTree r = new RTree(2, 0.4f, 3, file, RTreeType.RTREE_QUADRATIC);
	//RTree r = new RTree(file);

	RTree r = new RTree(2, 0.4f, 3, RTreeType.RTREE_QUADRATIC);
	//(int dimension, float fillFactor, int capacity, int type)

	static float[] f = [10, 20, 40, 70,
		30, 10, 70, 15,
		100, 70, 110, 80,
		0, 50, 30, 55,
		13, 21, 54, 78,
		3, 8, 23, 34,
		200, 29, 202, 50,
		34, 1, 35, 1,
		201, 200, 234, 203,
		56, 69, 58, 70,
		12, 67, 70, 102,
		1, 10, 10, 20
	];

	HyperCube h;
	//PlainRectangle h;

/*
	Point p1 = new Point( f[0], f[1] );
	Point p2 = new Point( f[2], f[3] ); //new float[] [f[i++],f[i++]]);

	Trace.formatln(p1);
	Trace.formatln(p2);

	//final HyperCube h = ...
	h = new PlainRectangle(p1, p2);

	//Trace.formatln("This is hypercube from the inside: x: ", h.x, "y: ", h.y);
	Trace.formatln( h.toString() );//TODO this crashes!!!!! because of CanvasItem being an interface???

	r.insert(h, -2);
*/


	for (int i = 0; i < f.size;)//Does this need i+4?
	{
		debug(RTree) Trace.formatln("Adding i to our tree i: ", i );
		Point p1 = new Point( f[i++], f[i++] );
		Point p2 = new Point( f[i++], f[i++] ); //new float[] [f[i++],f[i++]]);
		//final HyperCube h = ...
		h = new PlainRectangle(p1, p2);
		//debug(RTree) Trace.formatln("Adding hypercube to our tree: ", h);
		r.insert(h, -2);
	}


	Trace.formatln("The final tree you made was: ", r );


	Trace.formatln("Let's try to print them using foreach:");
	foreach( HyperCube h; r )
	{
		Trace.formatln( h.toString() );
	}

//	for (Enumeration e = r.traverseByLevel(); e.hasMoreElements();)
//	{
//		Trace.formatln(e.nextElement());
//	}

	/*
	HyperCube h = new HyperCube(new Point(new float[] {10, 15}), new Point(new float[] {23, 24}));

	for (Enumeration e = r.intersection(h); e.hasMoreElements();) {
	System.out.println(e.nextElement());
	}

	Point p = new Point(new float[] {112, 75});
	System.out.print("Nearest to " + p + " is ");
	System.out.println(r.nearestNeighbour(p));
	*/

	Trace.formatln("See you again soon RTree!");
}

+/

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    }
}
