/**
	Attribute array alias and support functions.
	
	Authors: Eric Anderton
	License: BSD Derivative (see source for details)
	Copyright: 2006 Eric Anderton
*/
module ddl.Attributes;

alias char[][char[]] Attributes;

Attributes copyInto(Attributes from,Attributes to);
