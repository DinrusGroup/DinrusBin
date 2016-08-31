module ddl.omf.OMFException;

private import ddl.DDLException;
private import ddl.Utils;

class OMFException : DDLException{
	public this(char[] fmt,...){
		super(fmt,_arguments,_argptr);
	}
		
	public this(char[] fmt,TypeInfo[] arguments,void* argptr){
		super(fmt,arguments,argptr);
	}
}

class FeatureNotSupportedException : OMFException{
	public this(char[] fmt,...){
		super(fmt,_arguments,_argptr);
	}
}

class ChecksumFailedException : OMFException{
	public this(char[] fmt,...){
		super(fmt,_arguments,_argptr);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-ddl");
        } else version (DigitalMars) {
            pragma(link, "mango");
        } else {
            pragma(link, "DO-ddl");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-ddl");
        } else version (DigitalMars) {
            pragma(link, "mango");
        } else {
            pragma(link, "DO-ddl");
        }
    }
}
