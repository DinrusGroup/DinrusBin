module rae.canvas.rtree.Node;

//import tango.util.container.LinkedList;
//import rae.canvas.rtree.AbstractNode;
//private import ptl.rtree.hypercube;
import rae.canvas.ICanvasItem;
public alias ICanvasItem HyperCube;

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

	//public void condenseTree( LinkedList!(Node) q );
	public void condenseTree( ref Node[] q );

} // Node

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
