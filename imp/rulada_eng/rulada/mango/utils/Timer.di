/*******************************************************************************

        @file Timer.d
        
        Copyright (c) 2004 Kris Bell
        
        This software is provided 'as-is', without any express or implied
        warranty. In no event will the authors be held liable for damages
        of any kind arising from the use of this software.
        
        Permission is hereby granted to anyone to use this software for any 
        purpose, including commercial applications, and to alter it and/or 
        redistribute it freely, subject to the following restrictions:
        
        1. The origin of this software must not be misrepresented; you must 
           not claim that you wrote the original software. If you use this 
           software in a product, an acknowledgment within documentation of 
           said product would be appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must 
           not be misrepresented as being the original software.

        3. This notice may not be removed or altered from any distribution
           of the source.

        4. Derivative works are permitted, but they must carry this notice
           in full and credit the original source.


                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


        @version        Initial version, July 2004      
        @author         Kris


*******************************************************************************/

module mango.utils.Timer;

private import mango.sys.System;

/*******************************************************************************

*******************************************************************************/

class Timer
{
        private ulong   time;
        private uint    pause,
                        interval;
        
        /***********************************************************************

                Construct a Timer for the specified interval (in microseconds)

        ***********************************************************************/

        this (uint interval)
        {
                this.interval = interval;
                pause = interval / 2000;
                update ();

                System.createThread (&run, true);
        }

        /***********************************************************************

                Returns the current time in milliseconds

        ***********************************************************************/

        ulong getTime ()
        {
                volatile return time;
        }

        /***********************************************************************

        ***********************************************************************/

        private final void update ()
        {
                volatile time = (System.getMillisecs() / interval) * interval;
        }

        /***********************************************************************

        ***********************************************************************/

        version (Ares) 
                 alias void ThreadReturn;
              else
                 alias int ThreadReturn;

        ThreadReturn run ()
        {
                while (true)
                      {
                      System.sleep (pause);
                      update ();
                      }
                return 0;
        }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
