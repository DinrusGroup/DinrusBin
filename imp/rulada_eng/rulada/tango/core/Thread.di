/**
 * The thread module provides support for thread creation and management.
 *
 * If AtomicSuspendCount is used for speed reasons all signals are sent together.
 * When debugging gdb funnels all signals through one single handler, and if
 * the signals arrive quickly enough they will be coalesced in a single signal,
 * (discarding the second) thus it is possible to loose signals, which blocks
 * the program. Thus when debugging it is better to use the slower SuspendOneAtTime
 * version.
 *
 * Copyright: Copyright (C) 2005-2006 Sean Kelly, Fawzi.  All rights reserved.
 * License:   BSD style: $(LICENSE)
 * Authors:   Sean Kelly, Fawzi Mohamed
 */
module tango.core.Thread;
pragma(lib, "rulada.lib");
public import rt.core.thread;
version (build) {
    debug {
        pragma(link, "tango");
    } else {
        pragma(link, "tango");
    }
}
