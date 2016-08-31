/*
* The X11/MIT License
* 
* Copyright (c) 2008-2009, Jonas Kivi
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

module rae.core.Timeout;

import tango.util.log.Trace;//Thread safe console output.

version(gtk)
{
	import GtkTimeout = gtkD.gtk.Timeout;
}

//import rae.core.globals;

class Timeout
{
public:
	this( uint set_interval, bool delegate() dlg, bool set_firenow=false )
	{
		//Trace.formatln("Timeout.this().");
		fireNow = set_firenow;
		interval = set_interval;
		callback = dlg;
		start();
		//if( g_rae !is null )
		//	g_rae.registerIdle(this);
	}
	
	void start()
	{
		if( running == false )
		{
			//Trace.formatln("Timeout.start().");
			running = true;
			version(gtk)
			{
				m_timeout = new GtkTimeout.Timeout( interval, callback, fireNow );
			}
		}
	}
	
	void stop()
	{
		running = false;
		version(gtk)
		{
			m_timeout.stop();
		}
	}
	
	bool fireNow = false;
	
	bool running = false;
	version(gtk)
	{
		GtkTimeout.Timeout m_timeout;
	}
	uint interval;
	bool delegate() callback;
}



/+

//Oh well. This was my apparently lousy
//attempt at a Timeout class. No go. Crashes.

//import tango.core.Signal;
import tango.time.StopWatch;
import tango.core.Thread;

class Timeout
{
public:
	/*this( double set_interval )
	{
		interval = set_interval;
	}*/
	
	this( double set_interval, bool delegate() dlg, bool firenow=false)
	{
		//Trace.formatln("Timeout.this().");
		running = true;
		timer.start();
		interval = set_interval;
		timeoutListener = dlg;
		if( firenow == true )
		{
			if( dlg() == false )
			{
				//Trace.formatln("Timeout.this() stopping after firenow.");
				running = false;
			}
		}
		
		if( running == true )
			idleThread = new Thread(&idle);
			
		idleThread.start();
	}
	
	protected bool running = true;
	
	void idle()
	{
		while(running == true)
		{
			//Trace.formatln("timeout running.");
		
			ulong frameTime = timer.microsec();// * 0.001;//convert to milliseconds.
			
			if( (frameTime * 1000.0f) >= interval )
			{
				timer.start();
				if( timeoutListener() == false )
				{
					running = false;
				}
			}
		}
	}

	Thread idleThread;

	protected bool delegate() timeoutListener;//This could be an array
	//so we'd have many delegates, which would look more like a signal.
	//then we also should have an add(delegate) method.
	
/*
//Can't use tango Signals here because of tango ticket #809.
//(No return values in signals...)

	Signal!() signalActivate;
	void onActivate()
	{
		signalActivate.call();
	}
*/

	///Returns elapsed time since last frame in milliseconds
	/*
	public double frameTime() { return m_frameTime; }
	protected double frameTime(double set) { return m_frameTime = set; }
	double m_frameTime = 0.0;
	*/
	double interval = 0.0f;
	StopWatch timer;
}

+/



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
