module rae.canvas.rtree.Index;

//private import std.stdio;
//private import std.string;

import tango.util.log.Trace;//Thread safe console output.

import tango.math.Math;

//import tango.util.container.LinkedList;
import Integer = tango.text.convert.Integer;

//import ptl.exception.illegalargumentexception;
//alias IllegalArgumentException IllegalStateException;
//alias IllegalArgumentException IndexOutOfBoundsException;

import rae.canvas.rtree.RTree;
import rae.canvas.rtree.Node;
import rae.canvas.rtree.AbstractNode;
//private import ptl.rtree.hypercube;
import rae.canvas.ICanvasItem;
public alias ICanvasItem HyperCube;
import rae.canvas.rtree.Leaf;

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
	//public void condenseTree( LinkedList!(Node) q )//was AbstractNode
	public void condenseTree( ref Node[] q )//was AbstractNode
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
			debug(FindLeaf) Trace.formatln("Index.findLeaf() i: {}", i);
			if (data[i].enclosure(h))
			{
				debug(FindLeaf) Trace.formatln("Index.findLeaf() enclosure == true.");
				
				
				//getChild may return either an Index or a Leaf. Both of them
				//derive from AbstractNode which implements the Node interface.
				//That's why we cast to AbstractNode and do a findLeaf on that,
				//which will again find the lowest Leaf recursively. Finally
				//we cast the result to a Leaf, and we have found our leaf.
				Leaf l = cast(Leaf)(cast(AbstractNode) getChild(i)).findLeaf(h);
					
				debug(FindLeaf) Trace.formatln("Index.findLeaf() getChild worked.");
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
	    for (int j = 0; j < n.data.length; j++) {
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

		for (int i = 0; i < g1.length; i++)
		{
			i1.addData(data[g1[i]], branches[g1[i]]);
		}

		for (int i = 0; i < g2.length; i++)
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
