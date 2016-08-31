//============================================================================
// Timer.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 *
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III, OLM Digital, Inc.
 * Created: 28 Aug 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 *      Based on OpenMesh (C++) http://www.openmesh.org
 *      Copyright (C) 2001-2003 by Computer Graphics Group, RWTH Aachen
 * License:
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public License
 *  as published by the Free Software Foundation, version 2.1.
 *                                                                           
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *                                                                           
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
//============================================================================

module auxd.OpenMesh.Tools.Utils.Timer;

/** \file Timer.d
    A timer class
*/


// ----------------------------------------------------------------------------

import auxd.OpenMesh.Core.System.config;
static import std.string;
import perf=std.perf;

private int compare(S,T)(S a, T b) {
    if (a==b) return 0;
    return (a<b)? -1 : 1;
}


class NotImplementedError : Error
{
    this(char[] msg)
    {
        super(msg ~ " not implemented");
    }
}


// ----------------------------------------------------------------- class ----

/** Timer class
 */
class Timer
{
public:

    /// Formatting options for member Timer.as_string()
    enum Format {
        Automatic,
        Long,
        Hours,
        Minutes,
        Seconds,
        HSeconds,
        MSeconds,
        MicroSeconds,
        NanoSeconds
    }

    this() {
        impl_ = new perf.PerformanceCounter;
    }

    /// Returns true if self is in a valid state!
    bool is_valid() /*const*/ { return state_!=State.Invalid; }

    bool is_stopped() /*const*/ { return state_==State.Stopped; }

    /// Reset the timer
    void reset() { }

    /// Start measurement
    void start() { impl_.start(); state_=State.Running; }

    /// Stop measurement
    void stop() { impl_.stop(); state_=State.Stopped; }

    /// Continue measurement
    void cont() { throw new NotImplementedError("Timer.cont"); }

    /// Give resolution of timer. Depends on the underlying measurement method.
    float resolution() /*const*/ { 
        return 1e-3;  // don't know.
    } 
    
    /// Returns measured time in seconds, if the timer is in state 'Stopped'
    double seconds() /*const*/ {
        return 1e-6*impl_.microseconds;
    }

    /// Returns measured time in hundredth seconds, if the timer is in state 'Stopped'
    double hseconds() /*const*/ { return seconds()*1e2; }

    /// Returns measured time in milli seconds, if the timer is in state 'Stopped'
    double mseconds() /*const*/ { return seconds()*1e3; }

    /// Returns measured time in micro seconds, if the timer is in state 'Stopped'
    double useconds() /*const*/ { return seconds()*1e6; }
  
    /** Returns the measured time as a string. Use the format flags to specify
        a wanted resolution.
    */
    string as_string(Format format = Format.Automatic) {
        return toString();
    }
  
    /** Returns a given measured time as a string. Use the format flags to 
        specify a wanted resolution.
    */
    static string as_string(double seconds, Format format = Format.Automatic) {
        return std.string.format(seconds);
    }

    /** Write seconds to output stream. 
     *  Timer must be stopped before.
     *  \relates Timer
     */
    string toString()
    {
        return std.string.format(seconds());
    }

public:

    //@{
    /// Compare timer values
    int opCmp(/*const*/ ref Timer t2) /*const*/ 
    { 
        assert( is_stopped() && t2.is_stopped() ); 
        return compare(seconds(), t2.seconds()); 
    }

    int opEquals (/*const*/ ref Timer t2) /*const*/
    { 
        assert( is_stopped() && t2.is_stopped() ); 
        return (seconds() == t2.seconds());
    }

    //@}






protected:

    perf.PerformanceCounter impl_;

    enum State : int {
        Invalid = -1,
        Stopped =  0,
        Running =  1
    } 
    State state_ = State.Stopped;
}

unittest {
    scope Timer t1 = new Timer;
    int N = 10000;
    float[] x; x.length = N;
    t1.start();
    for(int i=0; i<1000000; i++) {
        x[i%N] = 0;
    }
    x[0] = 100.0;
    for(int j=0; j<2*N; j++) {
        for(int i=1; i<N-2; i++) {
            x[i] = 0.5*(x[i-1]+x[i+1]);
        }
    }
    t1.stop();
    std.io.writefln("T1 time was %s seconds", t1);
    scope Timer t2 = new Timer;
    t2.start();
    for(int i=0; i<1000000; i++) {
        x[i%N] = 0;
    }
    t2.stop();
    std.io.writefln("T2 time was %s seconds", t2);
    assert(t2<t1);
}


//--- Emacs setup ---
// Local Variables:
// c-basic-offset: 4
// indent-tabs-mode: nil
// End:


version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
