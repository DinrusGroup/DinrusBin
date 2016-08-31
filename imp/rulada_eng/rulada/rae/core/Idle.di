module rae.core.Idle;

version(gtk)
{
	import gtkD.gtk.Timeout;
}

import rae.core.globals;

class Idle2
{
	public:
	this( bool delegate() dlg, bool firenow=false )
	{
		callback = dlg;
		register();
	}
	
	void call()
	{
		if( callback() == false )
			stop();
	}
	
	void start()
	{
		if( running == false )
		{
			running = true;
			register();
		}
	}
	
	void stop()
	{
		running = false;
		//The g_rae.callIdles will remove
		//this idle from the idle LinkedList now.
	}
	
protected:
	
	void register()
	{
		if( g_rae !is null )
			g_rae.registerIdle2(this);
	}

	public bool running() { return m_running; }
	public bool running(bool set) { return m_running = set; }
	protected bool m_running = true;
	bool delegate() callback;
}

version(gtk)
{
class Idle
{
public:
	this( uint set_interval, bool delegate() dlg, bool fireNow=false )
	{
		interval = set_interval;
		callback = dlg;
		start();
		if( g_rae !is null )
			g_rae.registerIdle(this);
	}
	
	void start()
	{
		if( running == false )
		{
			running = true;
			m_timeout = new Timeout( interval, callback, true );
		}
	}
	
	void stop()
	{
		running = false;
		m_timeout.stop();
	}
	
	bool running = false;
	Timeout m_timeout;
	uint interval;
	bool delegate() callback;
}

}//version(gtk)


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
