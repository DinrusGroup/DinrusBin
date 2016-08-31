/******************************************************************************* 

	A Single Lined text box
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 
    
    Description:    
		A text box that supports only one line of text 

	Examples:
	--------------------
		import arc.gui.widgets.textbox; 
		
		TextBox box = new TextBox(); 
		box.setFont(font);
		box.setText("Hello"); 

		while (!arc.input.keyDown(ARC_QUIT))
		{
			arc.input.process(); 
			arc.window.clear();

			box.setPosition(arc.input.mouseX, arc.input.mouseY); 
			box.process(); 
			box.draw();

			arc.window.swap();
		}
		--------------------

*******************************************************************************/

module arc.gui.widgets.textbox;

import 
	std.stream, 
	std.conv, 
	std.string; 

import
	arc.gui.widgets.widget,
	arc.gui.themes.theme, 
	arc.font,
	arc.input,
	arc.log,
	arc.time,
	arc.types,
	arc.math.point; 
		
/// TextBox widget supports a single line of text only
class TextBox : Widget 
{
  public: 

	this()
	{
		blink = new Blinker; 
	}

	~this()
	{
//		delete blink; 
	}

	/// draw textfield 
	void draw(Point parentPos = Point(0,0));
	/// process textfield 
	void process(Point parentPos = Point(0,0));

	/// set text of widget 
	void setText(char[] argText);
	
	/// set font and set widget size correctly
	void setFont(Font argFont);
	
  private: 
	Blinker blink; 
	bool showcursor = false; 
	int index; 
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
