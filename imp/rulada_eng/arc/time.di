/******************************************************************************* 

    Time related code. 

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
        The time module holds the Blinker class which can be set to blink at 
	differing rates of time, the limitFPS function which will limit a games 
	FPS to whichever integer given as the function argument, functions to 
	retrieve the elapsed seconds and milliseconds, and a function to tell 
	you how many frames per second the application is currently getting. 

	Examples:
	--------------------
	import arc.time; 

	int main() {

		arc.time.open();
		Blinker blink = new Blinker;

		while (!done)
		{
			blink.process(5);
			arc.time.process();

			// elapsed time since last frame in seconds
			arc.time.elapsedSeconds();

			// elapsed time since last frame in milliseconds
			arc.time.elapsedMilliseconds();

			// blink is on every 5 seconds
			if (blink.on)
			{
				// code here is called every 5 sec
			}
			
			// will try to limit fps to 60
			arc.time.limitFPS(60);
			
			// will get FPS count
			arc.time.fps(); 
		}
		
		arc.time.close();

	   return 0;
	}
	--------------------

*******************************************************************************/

module arc.time; 

import derelict.sdl.sdl; 

import 
	arc.log, 
	arc.types;

/// Code good for anything that can blink
class Blinker 
{
  public:
   bool   on = false;
   double lastTime = 0, currTime = 0;
   double totalsec = 0.0f; 
   
   this()
   {
      lastTime = SDL_GetTicks();
      currTime = SDL_GetTicks()+.01; // make sure current starts out bigger than lastTime
   }

	/// blinker is on every # of seconds
   void process(arcfl argSeconds);
}
/// Returns the number of milliseconds since the creation of the application
uint getTime();
/// initialize the time system
void open();
/// does nothing, just here for consistency
void close();
/**
	Calculates fps and captures start of frame time.
	
	Call at the start of the frame loop.
**/
void process();
/// stop execution for some milliseconds
void sleep(uint milliseconds);
/// gets the number of milliseconds passed between two calls to process
uint elapsedMilliseconds();
/// number of seconds passed between two calls to process
real elapsedSeconds();
/// frames per second the application is currently receiving
uint fps();
/**
	Call at the end of the frame loop in order to limit the
	fps to a certain amount.
**/
void limitFPS(uint maxFps);

private
{
    // current time
	uint startOfFrameTime = 0;
    // previous time
	uint prevStartOfFrameTime = 0;
	
	uint fps_ = 0;
	
	// helpers for fps calculation
	uint frames = 0;
	uint msPassed = 0;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
