module rae.canvas.rtree.PageFile;

import rae.canvas.rtree.RTree;
//import rae.canvas.rtree.AbstractNode;
import rae.canvas.rtree.Node;

//import rae.canvas.exception.illegalargumentexception;
//alias IllegalArgumentException PageFaultError;
//alias IllegalArgumentException Throwable;

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
	void deletePage(int page) { throw new Exception("PageFaultError"); }//protected

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
