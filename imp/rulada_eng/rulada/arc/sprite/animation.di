/******************************************************************************* 

	Animation class that holds a single animation. 

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:      ArcLib team 

	Description:    
		Animation class that holds a single animation. Sounds can also be 
	linked to specific frames in the animation. 


	Examples:      
	---------------------
		None provided.  
	---------------------

*******************************************************************************/

module arc.sprite.animation;

import
	std.math, 
	std.io,
	std.string;

import
	arc.types,
	arc.sprite.entity,
	arc.texture,
	arc.draw.image,
	arc.draw.color,
	arc.sprite.frame.frame,
	arc.sprite.frame.boxframe,
	arc.sprite.frame.radframe,
	arc.sound,
	arc.log,
	arc.math.collision,
	arc.math.point,
	arc.math.angle;

import 
	derelict.opengl.gl,
	derelict.sdl.sdl,
	derelict.sdl.image;

/// provides animations and encapulates frame collision
class Animation 
{
  public:

	/// simply set the frame length to 0
	this() 
	{
		frame.length = 0;
	}

	/// cleanup
	~this()  
	{
		//delete frame;
	}

	/// add a frame to the animation
	Size addFrame(	char[] img, int time, Sound snd, 
					COLLISION_TYPE col)
	{
		// grow frame length
		frame.length = frame.length+1;
		int i = frame.length-1;

		// extract size from frames after they load
		Size size;

		if (col == COLLISION_TYPE.BOX)
		{
			frame[i] = new BoxFrame(img, time, snd, size);
		}
		else if (col == COLLISION_TYPE.RADIUS)
		{
			frame[i] = new RadFrame(img, time, snd, size);
		}
		else
		{
			arc.log.write("animation", "addFrame", "error", "invalid collision type");
		}

		return size;
	}


	/// add a frame to the animation
	Size addFrame(	Texture tex, int time, Sound snd, 
					COLLISION_TYPE col)
	{
		// grow frame length
		frame.length = frame.length+1;
		int i = frame.length-1;

		// extract size from frames after they load
		Size size;

		if (col == COLLISION_TYPE.BOX)
		{
			frame[i] = new BoxFrame(tex, time, snd, size);
		}
		else if (col == COLLISION_TYPE.RADIUS)
		{
			frame[i] = new RadFrame(tex, time, snd, size);
		}
		else
		{
			arc.log.write("animation", "addFrame", "error", "invalid collision type");
		}

		return size;
	}

	/// draw frame 
	void draw(arcfl x, arcfl y, arcfl width, arcfl height, 
				Color color, 
				arcfl pivX, arcfl pivY, Radians angle,
				arcfl nx, arcfl ny,
				COLLISION_TYPE col)
	{	
		drawImage(frame[curr].texture, Point(x, y), Size(width, height), Point(pivX, pivY), angle, color);
	}

	/// process pivots, call every frame
	void process()
	{
		// time of less than 0 will be frozen
		if (frame[curr].time > 0)
		{
			// calculate time elapsed between calls
			prevTime = currTime;
			currTime = SDL_GetTicks();

			// add it to the amount of time elapsed so far
			elapsed += currTime-prevTime;

			// check to see if enough time elapsed to move to next frame
			if (elapsed >= frame[curr].time)
			{
				// play snd if there is one
				if (frame[curr].snd !is null)
				{
					frame[curr].snd.stop(); 
					frame[curr].snd.play();
				}
				
				// we reached the end of the frame
				if (curr == frame.length-1)
				{
					// loop back to beginning if specified
					if (loop)
						curr = 0;
					// otherwise just stay here
				}
				else
				{
					curr++;
				}
				
				// reset
				elapsed = 0;
			}
		}

		frame[curr].process();
        
	}

	/// get current frame of the sprite 
	Frame getCurrFrame() 
	{
		return frame[curr]; 
	}

	/// get curr frame num of the sprite 
	int getCurr() { return curr; }

	/// set looping or not 
	void setLoop(bool v)
	{
		loop = v;
	}

	/// get sound from frame num 
	Sound getSound(int argNum)
	in
	{
		assert (argNum <= frame.length);
	}
	body
	{
		return frame[argNum].snd;
	}

	/// set sound at frame  num 
	void setSound(Sound snd, int argNum)
	in
	{
		assert (argNum <= frame.length);
	}
	body
	{
		// remove old sound if its there
		if (frame[argNum].snd !is null)
			delete frame[argNum].snd;

		frame[argNum].snd = snd;
	}

	/// get time at frame num 
	int getTime(int aNum)
	{
		return frame[aNum].time;
	}

	/// set time at frame num 
	void setTime(int aT, int aNum)
	{
		frame[aNum].time = aT; 
	}

	/// reset sprite frame and time values 
	void reset() 
	{ 
		curr = 0; 
		currTime=SDL_GetTicks();
		prevTime = currTime; 
		//elapsed=0;
	}

	/// tell whether or not it is looping 
	bool isLoop() { return loop; }

  private:  
	// animation information
	Frame[] frame;
	int curr = 0;
	uint prevTime=0, currTime=0, elapsed = 0;
	bool loop = true;
}


version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
