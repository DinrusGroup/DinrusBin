/******************************************************************************* 

	Frame with circle collision detection. 

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:      ArcLib team 

	Description:    
		Frame with circle collision detection. 

	Examples:      
	---------------------
		None provided.  
	---------------------

*******************************************************************************/
module arc.sprite.frame.radframe; 

public import 
	arc.sprite.frame.frame;

import std.math; 

import 
	arc.types,
	arc.draw.shape, 
	arc.texture,
	arc.sound,
	arc.window,
	arc.math.point,
	arc.math.collision;

import 
	derelict.opengl.gl,
	derelict.sdl.sdl,
	derelict.sdl.image;

/// Frame with radius based collision detection
class RadFrame : Frame
{
  public:

	this() {}

	// radius is assumed to be (width+height)/2
	this(char[] argFullFileName, int argTime, Sound argSnd, inout Size s)
	{
		s = init(argFullFileName, argTime, argSnd);
	}

	// radius is assumed to be (width+height)/2
	this(Texture tex, int argTime, Sound argSnd, inout Size s)
	{
		s = init(tex, argTime, argSnd);
	}

	Size init(char[] argFullFileName, int argTime, Sound argSnd)
	{
		// will crash if file doesn't exist
		assert (std.file.exists(argFullFileName), "File " ~ argFullFileName ~ " does not exist!");

		// turn image into an OpenGL texture and extract width and height 
		Texture tex = arc.texture.load(argFullFileName);
		texture = tex;
		
		ID = tex.getID; 

		time = argTime;
		snd = argSnd;
        if (snd !is null) snd.setPaused(false);

		Size size = tex.getSize;
		return size;
	}

	Size init(Texture tex, int argTime, Sound argSnd)
	{
		ID = tex.getID; 
		texture = tex;
		
		time = argTime;
		snd = argSnd;
        if (snd !is null) snd.setPaused(false);

		Size size = tex.getSize;
		return size;
	}

   ~this()  
   {
   }

	int getID() { return ID; }


  private:
   int ID;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
