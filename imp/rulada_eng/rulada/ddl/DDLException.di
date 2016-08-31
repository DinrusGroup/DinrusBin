/**
	Authors: Eric Anderton
	License: BSD Derivative (see source for details)
	Copyright: 2006 Eric Anderton
*/
module ddl.DDLException;

private import ddl.Utils;

/**
	Error subclass for DDL internals.  Used when the application needs to be warned about something
	that could adversely affect its behavior, but is potentially recoverable.  The error message here
	is practically a clone of the one for DDLError for the sole purpose of informing the user 
	(or developer) should the exception never be caught.
*/
class DDLException : Exception{

	public this(char[] fmt,TypeInfo[] arguments,void* argptr);	
	public this(char[] fmt,...);	
	public static char[] boilerplate(char[] message);
}

