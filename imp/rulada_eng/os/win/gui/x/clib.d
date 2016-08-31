// Public domain.


module os.win.gui.x.clib;


version(Tango)
{
	public import tango.stdc.stdlib,
		tango.stdc.string,
		tango.stdc.stdint,
		tango.stdc.stdio;
	
	alias tango.stdc.stdio.printf cprintf;
}
else // Phobos
{
	public import std.c;		
		
	
	alias std.c.printf cprintf;
}

