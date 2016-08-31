﻿/**
 * The barrier module provides a primitive for synchronizing the progress of
 * a group of threads.
 *
 * Copyright: Copyright Sean Kelly 2005 - 2009.
 * License:   <a href="http://www.boost.org/LICENSE_1_0.txt>Boost License 1.0</a>.
 * Authors:   Sean Kelly
 *
 *          Copyright Sean Kelly 2005 - 2009.
 * Distributed under the Boost Software License, Version 1.0.
 *    (See accompanying file LICENSE_1_0.txt or copy at
 *          http://www.boost.org/LICENSE_1_0.txt)
 */
module rt.core.sync.barrier;


public import rt.core.exception;
private import rt.core.sync.condition;
private import rt.core.sync.mutex;

version( Win32 )
{
    private import rt.core.os.windows;
}
else version( Posix )
{
    private import rt.core.stdc.errno;
    private import rt.core.os.pos.pthread;
}


////////////////////////////////////////////////////////////////////////////////
// Barrier
//
// void wait();
////////////////////////////////////////////////////////////////////////////////


/**
 * This class represents a barrier across which threads may only travel in
 * groups of a specific size.
 */
class Barrier
{
    ////////////////////////////////////////////////////////////////////////////
    // Initialization
    ////////////////////////////////////////////////////////////////////////////


    /**
     * Initializes a barrier object which releases threads in groups of limit
     * in size.
     *
     * Params:
     *  limit = The number of waiting threads to release in unison.
     *
     * Throws:
     *  SyncException on error.
     */
    this( uint limit )
    in
    {
        assert( limit > 0 );
    }
    body
    {
        m_lock  = new Mutex;
        m_cond  = new Condition( m_lock );
        m_group = 0;
        m_limit = limit;
        m_count = limit;
    }


    ////////////////////////////////////////////////////////////////////////////
    // General Actions
    ////////////////////////////////////////////////////////////////////////////


    /**
     * Wait for the pre-determined number of threads and then proceed.
     *
     * Throws:
     *  SyncException on error.
     */
    void wait()
    {
        synchronized( m_lock )
        {
            uint group = m_group;

            if( --m_count == 0 )
            {
                m_group++;
                m_count = m_limit;
                m_cond.notifyAll();
            }
            while( group == m_group )
                m_cond.wait();
        }
    }


private:
    Mutex       m_lock;
    Condition   m_cond;
    uint        m_group;
    uint        m_limit;
    uint        m_count;
}


////////////////////////////////////////////////////////////////////////////////
// Unit Tests
////////////////////////////////////////////////////////////////////////////////


debug( UnitTest )
{
    private import tango.core.Thread;


    unittest
    {
        int  numThreads = 10;
        auto barrier    = new Barrier( numThreads );
        auto synInfo    = new Object;
        int  numReady   = 0;
        int  numPassed  = 0;

        void threadFn()
        {
            synchronized( synInfo )
            {
                ++numReady;
            }
            barrier.wait();
            synchronized( synInfo )
            {
                ++numPassed;
            }
        }

        auto group = new ThreadGroup;

        for( int i = 0; i < numThreads; ++i )
        {
            group.create( &threadFn );
        }
        group.joinAll();
        assert( numReady == numThreads && numPassed == numThreads );
    }
}
