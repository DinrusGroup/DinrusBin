/******************************************************************************* 

	A button that can be clicked on and can support text to be drawn on it.
	
    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		A button that can be clicked on and can support text to be drawn 
	on it. Widgets are not recommended for use by themselves, but it is 
	possible. 

	Examples:
	--------------------
		import arc.gui.widgets.button; 
		
		Button button = new Button(); 
		
		button.setSize(size);
		button.setPosition(pos);
		button.setFont(font); 
		button.setText("Hello World"); 
	--------------------

*******************************************************************************/

module arc.gui.widgets.button;

import std.stream, std.conv; 

import
		arc.gui.widgets.widget,
		arc.gui.themes.theme, 
		arc.font,
		arc.sound,
		arc.input,
		arc.log,
		arc.types,
		arc.math.point; 

/// Button Class, Derives from base class Widget 
class Button : Widget 
{
  public: 

	/// draw button 
	void draw(Point parentPos = Point(0,0));

	/// set text of widget 
	void setText(char[] argText);

	/// set font and set widget size correctly
	void setFont(Font argFont);
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
