/******************************************************************************* 

    Drawing of different primitive shapes 

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		drawPixel, drawLine, drawCircle, drawRectangle
		Different functions for drawing of primitive shapes. 

	Examples:
	--------------------
	import arc.types;

	int main() 
	{
		while (gameloop)
		{
			drawPixel(point, color);
			drawLine(line1, line2, color);
			drawCirlce(point, radius, detail, color, fill); 
			drawRectangle(pos, size, color, fill);
		}

		return 0;
	}
	--------------------

*******************************************************************************/

module arc.draw.shape; 

import 
	arc.types,
	arc.draw.color,
	arc.math.angle,
	arc.math.point; 
	
import std.math; 

import derelict.opengl.gl; 

/// draw pixel at position and color
void drawPixel(Point pos, Color color);

/// draw line with color
void drawLine(	Point pos1, Point pos2, Color color );

/// draw circle at position, size (radius), detail (vertex's), and color
void drawCircle(Point pos, arcfl radius, int detail, Color color, bool fill);
/// draw rectange with given position, size, and color
void drawRectangle(Point pos, Size size, Color color, bool fill);

/// draw polygon
void drawPolygon(Point[] polygon, Color color, bool fill);

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
