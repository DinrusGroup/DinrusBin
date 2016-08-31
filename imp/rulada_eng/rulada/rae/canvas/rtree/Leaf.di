module rae.canvas.rtree.Leaf;

//Tango imports:

//private import std.stdio;
//private import std.string;

//import tango.io.Trace.formatln;
import tango.util.log.Trace;//Thread safe console output.

import Integer = tango.text.convert.Integer;

import tango.math.Math;
//import tango.util.container.LinkedList;

//private import ptl.list;

import rae.canvas.rtree.RTree;
import rae.canvas.rtree.Node;
import rae.canvas.rtree.AbstractNode;
//private import ptl.rtree.hypercube;
import rae.canvas.ICanvasItem;
public alias ICanvasItem HyperCube;
import rae.canvas.rtree.Index;

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
	//public void condenseTree( LinkedList!(Node) q )//was abstractnode
	public void condenseTree( ref Node[] q )//was abstractnode
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
				//q.append(this);
				q ~= this;
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
				//LinkedList!(Node) q = new LinkedList!(Node);
				Node[] q;// = new LinkedList!(Node);
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
						//LinkedList!(Node) v = tree.traversePostOrder(n);
						Node[] v = tree.traversePostOrder(n);
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

		for (int i = 0; i < g1.length; i++)
		{
			l.addData(data[g1[i]], branches[g1[i]]);
			//data[g1[i]].rtreeNode(l);TANNE //I've decided to do this in abstractnode.addData().
		}

		for (int i = 0; i < g2.length; i++)
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
