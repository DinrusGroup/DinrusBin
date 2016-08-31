/******************************************************************************* 

	Particle engine allows particle effects 

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 
    
    Description:    
		Particle engine allows particle effects 

	Examples:
	--------------------
		None provided.
	--------------------

*******************************************************************************/

module arc.particle.particle;

// openGL + SDL
import 
	derelict.opengl.gl,
	derelict.sdl.sdl,  
	derelict.sdl.image; 

// ARC
import 
	arc.types,
	arc.texture, 
	arc.sprite.entity,
	arc.math.routines;

import 
	std.string,
	std.io,
	std.c;

/// A single particle
struct Particle
{
   // Alive (Yes/No)
   int   alive; 

   // Particle Life
   short life;   

   // Fade Speed
   arcfl fade;   

   // color   
   short r, g, b;     

   // getX and getY position
   arcfl x, y;

   // getX and getY direction   
   arcfl xi, yi;    
   
   // getX and getY gravity
   arcfl xg, yg;     
} 

/// A group of particles
class Particles : Entity
{
  public:
	/// load particles based on user given vars
   this(char[] argFileName, 
		int argNum, int argSlow, int argXSpeedMin, int argXSpeedMax,
		int argYSpeedMin, int argYSpeedMax, int argXGrav, int argYGrav,
		short[3][] argColors)
		
	{
		debug writefln("particle: this()");

		numParticles = argNum;
		slowdown = argSlow;

		xSpeedMin = argXSpeedMin; 
		xSpeedMax = argXSpeedMax;

		ySpeedMin = argYSpeedMin;
		ySpeedMax = argYSpeedMax;

		xgrav = argXGrav;
		ygrav = argYGrav; 
   
		// set dyn arr length as appropriate
		parts.length = numParticles;  
		colors.length = argColors.length;

		// copy gColors into our own colors
		for (int i = 0; i < argColors.length; i++)
		{
			assign3arr(colors[i], argColors[i]);
			//debug writefln(colors[i][0], ",", colors[i][1], ",", colors[i][2]);
		}

		// load up particle image
		Texture tex = Texture(argFileName);

		texture = tex.getID; 

		// set size to size of img
		setSize(tex.getSize.w, tex.getSize.h);

		// initialize all particles
		for (uint loop = 0; loop < numParticles; loop++ )
		{
			reset(loop);  
		}
   }

   ~this()
   {
   }

   /// creates an explosion with added speed
   void explode(int argSpeed)
   {
      // add to speeds for quick explosion
      xSpeedMin -= argSpeed; 
      xSpeedMax += argSpeed; 
      ySpeedMin -= argSpeed;  
      ySpeedMax += argSpeed;

      for (uint loop = 0; loop < numParticles; loop++ )
      {
         reset(loop);  
      }

      // set back to normal
      xSpeedMin += argSpeed; 
      xSpeedMax -= argSpeed; 
      ySpeedMin += argSpeed;  
      ySpeedMax -= argSpeed;
   }

   /// draw particles and update to next position
   void draw(double gameSpeed)
   {
      // Modify each of the particles  
      for (uint loop = 0; loop < numParticles; loop++ )
      {
         if ( parts[loop].alive )
         {
            // Grab Our Particle X Position  
            arcfl ex = parts[loop].x;

            // Grab Our Particle Y Position  
            arcfl why = parts[loop].y;
   
            // only fade if ready to 
            short alpha = parts[loop].life;
            if (alpha > 255)
               alpha = 255;

            // Draw The Particle Using Our RGB Values,
            // Fade The Particle Based On It's Life
            glColor4ub(parts[loop].r,
                       parts[loop].g,
                       parts[loop].b,
                       alpha);
   
            // bind our texture to this opengl triangle strip
            glBindTexture( GL_TEXTURE_2D, texture);
   
            // Build Quad From A Triangle Strip  
            glBegin( GL_TRIANGLE_STRIP );
               // Top Right  
               glTexCoord2d( 1, 1 );
               glVertex2f( ex + getWidth, why + getHeight);
               // Top Left  
               glTexCoord2d( 0, 1 );
               glVertex2f( ex - getWidth, why + getHeight);
               // Bottom Right  
               glTexCoord2d( 1, 0 );
               glVertex2f( ex + getWidth, why - getHeight);
               // Bottom Left  
               glTexCoord2d( 0, 0 );
               glVertex2f( ex - getWidth, why - getHeight);
            glEnd( );
   
            // Move On The X Axis By X Speed  
            parts[loop].x += parts[loop].xi * gameSpeed / ( slowdown * 1000);
            // Move On The Y Axis By Y Speed  
            parts[loop].y += parts[loop].yi * gameSpeed / ( slowdown * 1000);
   
            // Take Pull On X Axis Into Account  
            parts[loop].xi += parts[loop].xg * gameSpeed;
            // Take Pull On Y Axis Into Account  
            parts[loop].yi += parts[loop].yg * gameSpeed;
   
            // Reduce Particles Life By 'Fade'  
            parts[loop].life -= (parts[loop].fade * gameSpeed) * 3;
   
            // If the particle dies, revive it  
            if ( parts[loop].life < 0.0f )
            {
               reset(loop);
            }
         }
      }
   }
   
  private:
   // reset a given particle to given initial state
   void reset(int num)
   {
      // Make the particels active  
      parts[num].alive = true;
      // Give the particles life  
      parts[num].life = randomRange(255, 255*10);
      // Random Fade Speed  
      parts[num].fade = 1; 

      // pick random color in our color range
      int i = randomRange(0,colors.length-1); 

      // set red   
      parts[num].r = colors[i][0];
      // Select Green Rainbow Color  
      parts[num].g = colors[i][1];
      // Select Blue Rainbow Color  
      parts[num].b = colors[i][2];
      // Set the position on the X axis  
      parts[num].x = getX; 
      parts[num].y = getY; 

      // Random Speed On X Axis  
      parts[num].xi = randomRange(xSpeedMin, xSpeedMax);
      // Random Speed On Y Axi  
      parts[num].yi = randomRange(ySpeedMin, ySpeedMax);
      // Set Horizontal Pull To Zero  
      parts[num].xg = xgrav;
      // Set Vertical Pull Downward  
      parts[num].yg = ygrav;
   }

  private:
   int numParticles;
   arcfl slowdown;
   int xSpeedMin, xSpeedMax, ySpeedMin, ySpeedMax;
   arcfl xgrav, ygrav;
   uint delay, texture;
   Particle[] parts;
   short[3][] colors;
}

private
{
	// make array assigning easy
	void assign3arr(short[3] src, short[3] dst)
	{
	   for (int i = 0; i < 3; i++)
		  src[i] = dst[i];
	}
}
version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
