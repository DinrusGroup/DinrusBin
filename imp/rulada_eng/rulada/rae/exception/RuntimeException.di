module rae.exception.RuntimeException;

import tango.util.log.Trace;//Thread safe console output.

public class RuntimeException
{
	public this()
	{
		Trace.formatln("RuntimeException");
	}
	
	public this(char[] message)
	{
		Trace.formatln(message);
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
