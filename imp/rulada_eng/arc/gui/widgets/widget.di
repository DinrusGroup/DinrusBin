/******************************************************************************* 

	The base class for all of the widgets 
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 
    
    Description:    
		The base class for all of the widgets. This class is not to be used
		by itself. 

	Examples:
	--------------------
		None Provided
	--------------------

*******************************************************************************/

module arc.gui.widgets.widget; 

import 
	std.stream, // fix import conflicts (weird, I know)
	std.signals; 

import 	
	arc.types,
	arc.texture,
	arc.font,
	arc.draw.color,
	arc.sound,
	arc.input,
	arc.log,
	arc.math.collision,
	arc.math.point,
	arc.gui.widgets.types;

public
{
	/// Text align left, center, and right 
	enum TEXTALIGN 
	{
		LEFTCENTER, 
		LEFTUP,
		LEFTDOWN,
		
		RIGHTCENTER,
		RIGHTUP,
		RIGHTDOWN, 
		
		CENTER, 
		CENTERUP, 
		CENTERDOWN
	}
}

/// Widget class, base class for all of the widgets 
class Widget
{
  public:
	this()
	{
	}

	/// set name of the widget 
	void setSize(Size argSize);

	/// set width of widget
	void setWidth(arcfl argW);

	/// set height of widget
	void setHeight(arcfl argH);

	/// set parent position of sprite 
	void setPosition(Point argPos);
	
	/// set color of the widget 
	void setColor(Color acolor);
	
	/// process widget 
	void process(Point parentPos = Point(0,0));
	
	/// get width 
	arcfl getWidth();

	/// get height 
	arcfl getHeight(); 
	
	/// get size
	Size getSize();

	/// get x position 
	arcfl getX();

	/// get Y position 
	arcfl getY();
	
	/// get position
	Point getPosition() ;

	/// return true if mouse is over widget 
	bool mouseOver(Point parentPos) ;

	/// set color of font 
	void setFontColor(Color afontColor);

	/// set text values
	void setText(char[] argText);
	
	/// set font value 
	void setFont(Font argFont);

	/// draw image from position + parent position  
	void draw(Point parentPos = Point(0,0));
	
	/// set maximum amount of lines 
	void setMaxLines(uint argLines);

	/// set maximum width  
	void setMaxWidth(uint maxWidth);
	
	/// return focus 
	bool getFocus();

	/// set alignment of text
	void setTextAlign(TEXTALIGN aText);
	
	/// get text inside of widget
	char[] getText();
	
	/// mixin signals for handling GUI events 
	mixin Signal!() clicked;

  private:
	// get alignment 	
	Point getAlignment();
	
  protected:
  
	// will hold the position relative to the layout
	Point position;
	Size size;

	// color values 
	Color color;

	// font color values 
	Color fontColor; 

	// font text and alignment 
	char[] text; 
	TEXTALIGN alignment = TEXTALIGN.CENTER; 

	// font 
	Font font; 
	Point fontAlign; 

	// focus value 
	bool focus=false;

	// info signal will emit
	ACTIONTYPE action;  
}


version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
