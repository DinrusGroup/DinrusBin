/**
 * D header file for POSIX.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   <a href="http://www.boost.org/LICENSE_1_0.txt">Boost License 1.0</a>.
 * Authors:   Sean Kelly
 * Standards: The Open Group Base Specifications Issue 6, IEEE Std 1003.1, 2004 Edition
 *
 *          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module core.sys.posix.sched;

private import core.sys.posix.config;
public import core.sys.posix.time;
public import core.sys.posix.sys.types;

extern  (C):

//
// Required
//
/*
struct sched_param
{
    int sched_priority (THR)
    int sched_ss_low_priority (SS|TSP)
    struct timespec sched_ss_repl_period (SS|TSP)
    struct timespec sched_ss_init_budget (SS|TSP)
    int sched_ss_max_repl (SS|TSP)
}

SCHED_FIFO
SCHED_RR
SCHED_SPORADIC (SS|TSP)
SCHED_OTHER

int sched_getparam(pid_t, sched_param*);
int sched_getscheduler(pid_t);
int sched_setparam(pid_t, in sched_param*);
int sched_setscheduler(pid_t, int, in sched_param*);
*/

version( linux )
{
    struct sched_param
    {
        int sched_priority;
    }

    enum SCHED_OTHER    = 0;
    enum SCHED_FIFO     = 1;
    enum SCHED_RR       = 2;
    //SCHED_SPORADIC (SS|TSP)
}
else version( OSX )
{
    enum SCHED_OTHER    = 1;
    enum SCHED_FIFO     = 4;
    enum SCHED_RR       = 2;
    //SCHED_SPORADIC (SS|TSP)

    private enum __SCHED_PARAM_SIZE__ = 4;

    struct sched_param
    {
        int                             sched_priority;
        byte[__PTHREAD_MUTEX_SIZE__]    __opaque;
    }
}
else version( FreeBSD )
{
    struct sched_param
    {
        int sched_priority;
    }

    enum SCHED_FIFO     = 1;
    enum SCHED_OTHER    = 2;
    enum SCHED_RR       = 3;
}

version( Posix )
{
    int sched_getparam(pid_t, sched_param*);
    int sched_getscheduler(pid_t);
    int sched_setparam(pid_t, in sched_param*);
    int sched_setscheduler(pid_t, int, in sched_param*);
}

//
// Thread (THR)
//
/*
int sched_yield();
*/

version( linux )
{
    int sched_yield();
}
else version( OSX )
{
    int sched_yield();
}
else version( FreeBSD )
{
    int sched_yield();
}

//
// Scheduling (TPS)
//
/*
int sched_get_priority_max(int);
int sched_get_priority_min(int);
int sched_rr_get_interval(pid_t, timespec*);
*/

version( linux )
{
    int sched_get_priority_max(int);
    int sched_get_priority_min(int);
    int sched_rr_get_interval(pid_t, timespec*);
}
else version( OSX )
{
    int sched_get_priority_min(int);
    int sched_get_priority_max(int);
    //int sched_rr_get_interval(pid_t, timespec*); // FIXME: unavailable?
}
else version( FreeBSD )
{
    int sched_get_priority_min(int);
    int sched_get_priority_max(int);
    int sched_rr_get_interval(pid_t, timespec*);
}
