/*
 * This file is part of gtkD.
 *
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
// generated automatically - do not change
// find conversion definition on APILookup.txt
// implement new conversion functionalities on the wrap.utils pakage

/*
 * Conversion parameters:
 * inFile  = glib-Timers.html
 * outPack = glib
 * outFile = Timer
 * strct   = GTimer
 * realStrct=
 * ctorStrct=
 * clss    = Timer
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_timer_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * structWrap:
 * 	- GTimer* -> Timer
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.glib.Timer;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * GTimer records a start time, and counts microseconds elapsed since that time.
 * This is done somewhat differently on different platforms, and can be tricky to
 * get exactly right, so GTimer provides a portable/convenient interface.
 * Note
 * GTimer uses a higher-quality clock when thread support is available.
 * Therefore, calling g_thread_init() while timers are running may lead to
 * unreliable results. It is best to call g_thread_init() before starting
 * any timers, if you are using threads at all.
 */
public class Timer
{
	
	/** the main Gtk struct */
	protected GTimer* gTimer;
	
	
	public GTimer* getTimerStruct()
	{
		return gTimer;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)gTimer;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GTimer* gTimer)
	{
		if(gTimer is null)
		{
			this = null;
			return;
		}
		this.gTimer = gTimer;
	}
	
	/**
	 */
	
	/**
	 * Creates a new timer, and starts timing (i.e. g_timer_start() is implicitly
	 * called for you).
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this ()
	{
		// GTimer* g_timer_new (void);
		auto p = g_timer_new();
		if(p is null)
		{
			throw new ConstructionException("null returned by g_timer_new()");
		}
		this(cast(GTimer*) p);
	}
	
	/**
	 * Marks a start time, so that future calls to g_timer_elapsed() will report the
	 * time since g_timer_start() was called. g_timer_new() automatically marks the
	 * start time, so no need to call g_timer_start() immediately after creating the
	 * timer.
	 */
	public void start()
	{
		// void g_timer_start (GTimer *timer);
		g_timer_start(gTimer);
	}
	
	/**
	 * Marks an end time, so calls to g_timer_elapsed() will return the difference
	 * between this end time and the start time.
	 */
	public void stop()
	{
		// void g_timer_stop (GTimer *timer);
		g_timer_stop(gTimer);
	}
	
	/**
	 * Resumes a timer that has previously been stopped with g_timer_stop().
	 * g_timer_stop() must be called before using this function.
	 * Since 2.4
	 */
	public void continu()
	{
		// void g_timer_continue (GTimer *timer);
		g_timer_continue(gTimer);
	}
	
	/**
	 * If timer has been started but not stopped, obtains the time since the timer was
	 * started. If timer has been stopped, obtains the elapsed time between the time
	 * it was started and the time it was stopped. The return value is the number of
	 * seconds elapsed, including any fractional part. The microseconds
	 * out parameter is essentially useless.
	 * Warning
	 * Calling initialization functions, in particular g_thread_init(),
	 * while a timer is running will cause invalid return values from this function.
	 * Params:
	 * microseconds = return location for the fractional part of seconds elapsed,
	 *  in microseconds (that is, the total number of microseconds elapsed, modulo
	 *  1000000), or NULL
	 * Returns:seconds elapsed as a floating point value, including  any fractional part.
	 */
	public double elapsed(out uint microseconds)
	{
		// gdouble g_timer_elapsed (GTimer *timer,  gulong *microseconds);
		return g_timer_elapsed(gTimer, &microseconds);
	}
	
	/**
	 * This function is useless; it's fine to call g_timer_start() on an
	 * already-started timer to reset the start time, so g_timer_reset() serves no
	 * purpose.
	 */
	public void reset()
	{
		// void g_timer_reset (GTimer *timer);
		g_timer_reset(gTimer);
	}
	
	/**
	 * Destroys a timer, freeing associated resources.
	 */
	public void destroy()
	{
		// void g_timer_destroy (GTimer *timer);
		g_timer_destroy(gTimer);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-glib");
        } else version (DigitalMars) {
            pragma(link, "DD-glib");
        } else {
            pragma(link, "DO-glib");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-glib");
        } else version (DigitalMars) {
            pragma(link, "DD-glib");
        } else {
            pragma(link, "DO-glib");
        }
    }
}
