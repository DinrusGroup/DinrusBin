module rae.canvas.rtree.MemoryPageFile;

//import std.stdio;
import tango.util.log.Trace;//Thread safe console output.

//import tango.util.container.LinkedList;
import tango.util.container.HashMap;
import Integer = tango.text.convert.Integer;

//import ptl.hashtable;

import rae.canvas.rtree.PageFile;
import rae.canvas.rtree.RTree;
//import rae.canvas.rtree.AbstractNode;
import rae.canvas.rtree.Node;

//import rae.canvas.exception.illegalargumentexception;
//alias IllegalArgumentException PageFaultError;

//import java.util.*;

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

		
		Node ret;
		file.get(page, ret);//new Integer(page));
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
