module rae.canvas.rtree.Comparator;

import rae.canvas.rtree.AblNode;

import tango.util.container.LinkedList;

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
