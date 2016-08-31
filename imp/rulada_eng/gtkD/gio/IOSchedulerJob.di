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
 * inFile  = gio-GIOScheduler.html
 * outPack = gio
 * outFile = IOSchedulerJob
 * strct   = GIOSchedulerJob
 * realStrct=
 * ctorStrct=
 * clss    = IOSchedulerJob
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_io_scheduler_job_
 * 	- g_io_scheduler_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gio.Cancellable
 * structWrap:
 * 	- GCancellable* -> Cancellable
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gio.IOSchedulerJob;

public  import gtkD.gtkc.giotypes;

private import gtkD.gtkc.gio;
private import gtkD.glib.ConstructionException;


private import gtkD.gio.Cancellable;




/**
 * Description
 * Schedules asynchronous I/O operations. GIOScheduler integrates
 * into the main event loop (GMainLoop) and may use threads if they
 * are available.
 * Each I/O operation has a priority, and the scheduler uses the priorities
 * to determine the order in which operations are executed. They are
 * not used to determine system-wide I/O scheduling.
 * Priorities are integers, with lower numbers indicating higher priority.
 * It is recommended to choose priorities between G_PRIORITY_LOW and
 * G_PRIORITY_HIGH, with G_PRIORITY_DEFAULT as a default.
 */
public class IOSchedulerJob
{
	
	/** the main Gtk struct */
	protected GIOSchedulerJob* gIOSchedulerJob;
	
	
	public GIOSchedulerJob* getIOSchedulerJobStruct()
	{
		return gIOSchedulerJob;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)gIOSchedulerJob;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GIOSchedulerJob* gIOSchedulerJob)
	{
		if(gIOSchedulerJob is null)
		{
			this = null;
			return;
		}
		this.gIOSchedulerJob = gIOSchedulerJob;
	}
	
	/**
	 */
	
	/**
	 * Schedules the I/O job to run.
	 * notify will be called on user_data after job_func has returned,
	 * regardless whether the job was cancelled or has run to completion.
	 * If cancellable is not NULL, it can be used to cancel the I/O job
	 * by calling g_cancellable_cancel() or by calling
	 * g_io_scheduler_cancel_all_jobs().
	 * Params:
	 * jobFunc =  a GIOSchedulerJobFunc.
	 * userData =  data to pass to job_func
	 * notify =  a GDestroyNotify for user_data, or NULL
	 * ioPriority =  the I/O priority
	 * of the request.
	 * cancellable =  optional GCancellable object, NULL to ignore.
	 */
	public static void pushJob(GIOSchedulerJobFunc jobFunc, void* userData, GDestroyNotify notify, int ioPriority, Cancellable cancellable)
	{
		// void g_io_scheduler_push_job (GIOSchedulerJobFunc job_func,  gpointer user_data,  GDestroyNotify notify,  gint io_priority,  GCancellable *cancellable);
		g_io_scheduler_push_job(jobFunc, userData, notify, ioPriority, (cancellable is null) ? null : cancellable.getCancellableStruct());
	}
	
	/**
	 * Cancels all cancellable I/O jobs.
	 * A job is cancellable if a GCancellable was passed into
	 * g_io_scheduler_push_job().
	 */
	public static void cancelAllJobs()
	{
		// void g_io_scheduler_cancel_all_jobs (void);
		g_io_scheduler_cancel_all_jobs();
	}
	
	/**
	 * Used from an I/O job to send a callback to be run in the thread
	 * that the job was started from, waiting for the result (and thus
	 * blocking the I/O job).
	 * Params:
	 * func =  a GSourceFunc callback that will be called in the original thread
	 * userData =  data to pass to func
	 * notify =  a GDestroyNotify for user_data, or NULL
	 * Returns: The return value of func
	 */
	public int sendToMainloop(GSourceFunc func, void* userData, GDestroyNotify notify)
	{
		// gboolean g_io_scheduler_job_send_to_mainloop (GIOSchedulerJob *job,  GSourceFunc func,  gpointer user_data,  GDestroyNotify notify);
		return g_io_scheduler_job_send_to_mainloop(gIOSchedulerJob, func, userData, notify);
	}
	
	/**
	 * Used from an I/O job to send a callback to be run asynchronously in
	 * the thread that the job was started from. The callback will be run
	 * when the main loop is available, but at that time the I/O job might
	 * have finished. The return value from the callback is ignored.
	 * Note that if you are passing the user_data from g_io_scheduler_push_job()
	 * on to this function you have to ensure that it is not freed before
	 * func is called, either by passing NULL as notify to
	 * g_io_scheduler_push_job() or by using refcounting for user_data.
	 * Params:
	 * func =  a GSourceFunc callback that will be called in the original thread
	 * userData =  data to pass to func
	 * notify =  a GDestroyNotify for user_data, or NULL
	 */
	public void sendToMainloopAsync(GSourceFunc func, void* userData, GDestroyNotify notify)
	{
		// void g_io_scheduler_job_send_to_mainloop_async  (GIOSchedulerJob *job,  GSourceFunc func,  gpointer user_data,  GDestroyNotify notify);
		g_io_scheduler_job_send_to_mainloop_async(gIOSchedulerJob, func, userData, notify);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gio");
        } else version (DigitalMars) {
            pragma(link, "DD-gio");
        } else {
            pragma(link, "DO-gio");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gio");
        } else version (DigitalMars) {
            pragma(link, "DD-gio");
        } else {
            pragma(link, "DO-gio");
        }
    }
}
