/******************************************************************************* 

    Allows drawing of images

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		Code that will allow different ways to render an image with arc. 

	Examples:
	--------------------
	import arc.types;

	int main() 
	{
		Texture t = Texture("texture.png"); 
		
		Point pos, pivot;
		Size size;
		Color color; 
		arcfl angle; 
	
		while (gameloop)
		{
			drawImage(t, pos, size, color, pivot, angle);
		}

		return 0;
	}
	--------------------

*******************************************************************************/

module arc.draw.image; 

import
	arc.types,
	arc.texture,
	arc.draw.color,
	arc.math.point,
	arc.math.angle;

import derelict.opengl.gl; 

/// simply draw image to screen with given image ID from the center with pivot points 
void drawImage(Texture texture,
				Point pos, Size size = Size(float.nan,float.nan), 
				Point pivot = Point(0,0),
				Radians angle = 0,
				Color color = Color.White);

/// draw image from the top left location 
void drawImageTopLeft(Texture texture, Point pos, Size size = Size(float.nan,float.nan), Color color = Color.White);

/// draw a subsection of an image with the top-left at 0,0
void drawImageSubsection(Texture texture, Point topLeft, Point rightBottom, Color color = Color.White);

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
