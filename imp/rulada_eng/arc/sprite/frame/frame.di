/******************************************************************************* 

	Base frame class.

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
		Base frame class.

	Examples:      
	---------------------
		None provided.  
	---------------------

*******************************************************************************/

module arc.sprite.frame.frame;

import 
	arc.texture,
	arc.types,
	arc.math.point,
	arc.sound,
	arc.log;

/// Holds either PIXEL, RADIUS, or BOX.
enum COLLISION_TYPE
{
	RADIUS=0,
	CIRCLE = RADIUS,
	BOX
}

/// common base to PixFrame, BoxFrame, and RadFrame
class Frame 
{
  public:
	// default const/dest
	this(){}
	~this(){}

/*
	/// draw frame (box)
	void draw(	arcfl argX, arcfl argY, arcfl argW, arcfl argH,
				short argR, short argG, short argB, short argA,
				arcfl pivX, arcfl pivY)
	{
		debug writefln("frame: Please use RadFrame, BoxFrame, or PixFrame instead");
		assert(0);	
	}

	/// draw bounds for box function
	void drawBounds(arcfl nx, arcfl ny, arcfl width, arcfl height,
					short r, short b, short g, short a)
	{
		debug writefln("frame: Please use RadFrame, BoxFrame, or PixFrame instead");
		assert(0);
	}

	/// test collision against a box frame
	bool boxCol(Frame boxframe, arcfl x1, arcfl y1, 
				arcfl x2, arcfl y2, arcfl w2, arcfl h2,
				arcfl argAngle, arcfl argGap)
	{
		debug writefln("Frame type doesn't support box collision");
		assert(0);
		return false;  
	}

	/// returns true if collides against a BoxFrame
	bool boxCol(arcfl nx1, arcfl ny1, arcfl w1, arcfl h1, 
				arcfl nx2, arcfl ny2, arcfl w2, arcfl h2)
	{	
		debug writefln("Frame type doesn't support box collision");
		assert(0);
		return false;
	}

   /// test collision against a radius frame
	bool radCol( arcfl x1, arcfl y1, arcfl w1, arcfl h1,
				arcfl x2, arcfl y2, 
				arcfl argAngle, arcfl argGap, arcfl radius)
   {
      debug writefln("Only supported by RadFrame");
      assert(0);
      return false; 
   }

   void reload(double zx, double zy, arcfl gap)
   {
	   assert(0);
   }

   arcfl getCX() { assert(0); return 0; }
   arcfl getCY() { assert(0); return 0; }

	int getID() { assert(0); }

	bool xyCol(arcfl argX, arcfl argY, arcfl x, arcfl y, arcfl angle, arcfl gap)
	{
		assert(0);
		return false;
	}*/

	void process() 
    {
        if (snd !is null)
            snd.process();
    }

	// time it will be displayed for
	int time=30;
	// and sound effect
	Sound snd;
	Texture texture;
}


version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
