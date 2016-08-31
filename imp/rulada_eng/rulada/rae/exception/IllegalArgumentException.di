module rae.exception.IllegalArgumentException;

import rae.exception.RuntimeException;

public
class IllegalArgumentException : RuntimeException
{
	public this()
	{
		super();
	}

	public this(char[] s)
	{
		super(s);
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
