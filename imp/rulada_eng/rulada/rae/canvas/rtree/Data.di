module rae.canvas.rtree.Data;

import tango.util.container.LinkedList;

//private import ptl.rtree.hypercube;


import rae.canvas.Rectangle;
//Circular import/LinkedList/GDC bug is the reason
//for this insanity. ICanvasItem and stuff is all
//in Rectangle until that bug is fixed in GDC.

import rae.canvas.ICanvasItem;
public alias ICanvasItem HyperCube;

/**
 * Created: Tue Dec 07 16:04:30 1999
 * <p>
 * @author Hadjieleftheriou Marios
 * @version 1.000
 */
public class Data
{
	public HyperCube mbb;
	public int dataPointer;
	public int parent;
	public int position;

	public this(HyperCube h, int d, int p, int pos)
	{
		mbb = h;
		dataPointer = d;
		parent = p;
		position = pos;
	}

} // Data

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
