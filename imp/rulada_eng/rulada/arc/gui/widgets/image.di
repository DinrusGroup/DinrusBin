/******************************************************************************* 

	A image that can be clicked on.
	
    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		Simply is a single image that can be used in GUI's. 

	Examples:
	--------------------
		import arc.gui.widgets.image; 
		
		Image image = new Image("guibin/penguin.png"); 

		while (!arc.input.keyDown(ARC_QUIT))
		{
			arc.input.process(); 
			arc.window.clear();

			image.setPosition(arc.input.mouseX, arc.input.mouseY); 
			image.process(); 
			image.draw();

			arc.window.swap();
		}
		--------------------

*******************************************************************************/

module arc.gui.widgets.image; 

import 	
	arc.types,
	arc.texture, 
	arc.draw.image, 
	arc.gui.widgets.widget,
	arc.math.point;

import std.io, std.conv;

/// Image widget 
class Image : Widget
{
  public:

	/// load widget based on image
	this(char[] argFullPath)
	{
		load(argFullPath); 
	}

	/// load image 
	void load(char[] argFullPath);

	/// draw image from position + parent position  
	void draw(Point parentPos = Point(0,0));

  private:
	Texture texture; 
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
