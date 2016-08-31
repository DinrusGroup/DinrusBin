/**
	Authors: Eric Anderton, Lars Ivar Igesund
	License: BSD Derivative (see source for details)
	Copyright: 2006 Eric Anderton, Lars Ivar Igesund
*/
module ddl.DDLError;

/**
	Error subclass for DDL internals.  Used when the application needs to halt, due to something
	un-recoverable.
*/
class DDLError : Error{
	public this(char[] message){
		super(
			"[Error] You have run into a condition not handled, or possibly incorrectly handled, by DDL.\n" ~
			message ~
			"\nPlease create a ticket (or look for similar ones) at http://trac.dsource.org/projects/ddl/newticket, explain the circumstances and paste this message into it. Also, if possible, please attach a minimal, reproducible testcase.\n - Thank You. -"
		);
	}
}

