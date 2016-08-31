/******************************************************************************* 

	The base for every graphical object in the game world before scenegraph 
	node came along, now it seems to be used only with sprite. 

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:      ArcLib team 

	Description:    
		The base for every graphical object in the game world before scenegraph 
	node came along, now it seems to be used only with sprite. It holds functions
	that would be beneficial to any graphical object in the game world, hence the
	generic name, 'entity'. 

	Examples:      
	---------------------
		None provided.  
	---------------------

*******************************************************************************/

module arc.sprite.entity; 

import 
	arc.types,
	arc.window,
	arc.input,
	arc.math.point,
	arc.math.routines;

import 	
	derelict.opengl.gl,
	derelict.opengl.glu;

import std.math;

// entity x and y is scheduled to be replaced with getX and getY, 
// same for width and height
        
/*******************************************************************************

   The entity class is the basis of all things in the game world

*******************************************************************************/
class Entity 
{
  public:

   this()
   {
   }

   ~this()
   {
   }

   /// initialize OpenGL parameters required to draw
   void initGL()
   {
      glEnable(GL_TEXTURE_2D); 
      glEnable(GL_BLEND);
      glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
   }

   /*******************************************************************************
   
      Test if mouse is over entity
   
   *******************************************************************************/
   bool mouseOver()
   {
      return xyCol(Point(arc.input.mouseX, arc.input.mouseY));
   }

   /*******************************************************************************
   
      Test if given coordinate is over entity, simple box collision
   
   *******************************************************************************/
   bool xyCol(Point p)
   {
			arcfl max_size = size.maxComponent();

      if (p.x > pos.x && p.x < pos.x + max_size &&
         p.y > pos.y && p.y < pos.y + max_size) {
            return true;
         }
   
      return false;
   }

   /*******************************************************************************
   
      Left mouse clicks on entity
   
   *******************************************************************************/
   bool mouseHit()
   {
      if (mouseOver && arc.input.mouseButtonPressed(LEFT))
         return true; 

      return false; 
   }

   /// returns true if entity is on the screen
   bool onScreen() {
			arcfl max_size = size.maxComponent();

      if( pos.x >= -max_size && pos.x <= arc.window.coordinates.getWidth + max_size &&
          pos.y >= -max_size && pos.y <= arc.window.coordinates.getHeight + max_size) 
         return true;

      return false;
   }

   /*******************************************************************************
   
      Be able to save/load information using the serializer
   
   *******************************************************************************/
   void describe(T)(T s)
   {
      s.describe(pos); 
      s.describe(size); 
   }

   /// set position
   void setPosition(arcfl x, arcfl y) { pos.set(x, y); }
   /// set position based on point
   void setPosition(Point p) { pos = p; }
   /// set size
   void setSize(arcfl width, arcfl height) { size.set(width, height); }
   /// just set X value
   void setX(arcfl x) { pos.x = x; }
   /// just set Y value
   void setY(arcfl y) { pos.y = y; }
   /// add value to X
   void addX(arcfl x) { pos.x += x; }
   /// add value to Y
   void addY(arcfl y) { pos.y += y; }

	/// change color of entity
	void setColor(Color aC) 
	{ 
		color = aC; 
	}

   /// return x position
   arcfl getX() { return pos.x; }
   /// return y position
   arcfl getY() { return pos.y; }
   /// return entity width
   arcfl getWidth() { return size.w; }
   /// return entity height
   arcfl getHeight() { return size.h; }
   /// return center X position of entity
   arcfl getCenterX() { return pos.x + (size.w/2); }
   /// return center Y position of entity
   arcfl getCenterY() { return pos.y + (size.h/2); }
   /// return half of entity's width
   arcfl getHalfWidth() { return getWidth/2; }
   /// return half of entity's height
   arcfl getHalfHeight() { return getHeight/2; }
   /// return position as a point
   Point getPosition() { return pos; }
   /// return size as a point
   Size getSize() { return size; }

   /// returns true if entity is within proximity of x and y value
   bool inRange(real argX, real argY, real argProx)
   {
      // if x and y are within proximity distance
      if (arc.math.routines.withinRange(getX, argX, argProx) && arc.math.routines.withinRange(getY, argY, argProx))
      {  
         return true; // we are within range
      }
   
      return false; 
   }

	/// set width
	void setWidth(arcfl argW)
	{
		size.w = argW;
	}

	/// set height
	void setHeight(arcfl argH)
	{
		size.h = argH;
	}

   /***
      return the distance between two entities
   */
   real distance(inout Entity a)
   {
      return arc.math.routines.distance(getCenterX,getCenterY,a.getCenterX,a.getCenterY);
   }

   /***
      return the distance between entity and two points
   */
   real distance(real x2, real y2)
   {
      return arc.math.routines.distance(getCenterX,getCenterY,x2,y2);
   }
	 
   final Color getColor() { return color; }
		 

  private:
	// Everything in the game world needs a position, size, and color
	Point pos;
	Size size;
	
	Color color; 
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
