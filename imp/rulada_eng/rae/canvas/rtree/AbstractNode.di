module rae.canvas.rtree.AbstractNode;


//Tango imports:
//import tango.io.Trace.formatln;
import tango.util.log.Trace;//Thread safe console output.
import tango.math.Math;

//import tango.util.container.LinkedList;

//import std.stdio;
//import std.c.math;
//import std.math;

//import std.string;

alias char[] string;
//import ptl.string;
//import ptl.list;

//import pihlaja.canvas.canvasitem;
//import rae.canvas.plainrectangle;
import rae.canvas.Rectangle;
import rae.canvas.PlainRectangle;
//alias Rectangle PlainRectangle;
import rae.canvas.ICanvasItem;
//public 
alias ICanvasItem HyperCube;
import rae.canvas.Point;

import rae.canvas.rtree.RTree;
import rae.canvas.rtree.Node;
//private import rae.canvas.rtree.hypercube;
//import rae.canvas.rtree.Leaf;
//import rae.canvas.rtree.Index;
//import rae.canvas.exception.illegalargumentexception;
//alias IllegalArgumentException PageFaultError;
alias Exception PageFaultError;
//import java.util.*;
//import java.io.*;

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
public HyperCube[] data()
{
	return m_data;
}
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
	for( uint i = ind+1; i < data.length; i++ )
	{
		//data[i-1].rtreeNode( null );
		data[i-1] = data[i];
	}
	//System.arraycopy(branches, i+1, branches, i, usedSpace-i-1);
	for( uint i = ind+1; i < branches.length; i++ )
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
			//debug(RTree) 
			//Trace.formatln( "negative_infinity: {} and double.max: {}", dif, double.max );
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
			//Trace.formatln("mask sel: {}", sel);
			//if( sel > 0 )
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
//public void condenseTree( LinkedList!(Node) q )//was AbstractNode
public void condenseTree( ref Node[] q )//was AbstractNode
{
	throw new Exception("AbstractNode.condenseTree() not implemented.");
}

} // AbstractNode


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
