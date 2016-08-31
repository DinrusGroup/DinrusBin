/******************************************************************************* 

	A label that can be clicked on.
	
    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		Simply is a single label that can be used in GUI's. 

	Examples:
	--------------------
		import arc.gui.widgets.label; 
		
		Label label = new Label(); 
		label.setFont(font);
		label.setText("Hello"); 

		while (!arc.input.keyDown(ARC_QUIT))
		{
			arc.input.process(); 
			arc.window.clear();

			label.setPosition(arc.input.mouseX, arc.input.mouseY); 
			label.process(); 
			label.draw();

			arc.window.swap();
		}
		--------------------

*******************************************************************************/

module arc.gui.widgets.label;

import
	arc.types,
	arc.font,
	arc.gui.widgets.widget,
	arc.gui.themes.theme, 
	arc.math.point;

/// Label widget 
class Label : Widget 
{
  public: 

	/// draw label with parent x and y position 
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
