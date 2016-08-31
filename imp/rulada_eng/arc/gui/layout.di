/******************************************************************************* 

    Arc's layout can hold and arrange all GUI widgets 

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		Arc's layout can hold and arrange all GUI widgets.
	Use the GUI class if you want to hold multiple layouts in 
	one class. 
 

	Examples:
	--------------------
	import arc.gui.gui;

	int main()
	{
		// load GUI file from XML
		HandleGUI handle = new HandleGUI; 
		Layout layout = new Layout("layout.xml"); 

		// connect layout widgets actions with specific code 
		layout.getWidget("myimg").clicked.connect(&handle.image);
		layout.getWidget("lbl1").clicked.connect(&handle.label);
		
		while (!arc.input.keyDown(ARC_QUIT))
		{
			arc.input.process();
			arc.window.clear(); 

			layout.process();
			layout.draw(); 

			arc.window.swap(); 
		}
		
		return 0; 
	}

	--------------------

*******************************************************************************/

module arc.gui.layout; 

import arc.gui.readxml;

import
	std.conv;

import 
	arc.types,
	arc.font, 
	arc.gui.widgets.widget,
	arc.gui.widgets.image,
	arc.gui.widgets.label,
	arc.gui.widgets.button,
	arc.gui.widgets.textbox,
	arc.math.collision,
	arc.math.point,
	arc.draw.shape,
	arc.draw.color; 

/// Layout class 
class Layout : Widget
{
  public:
	/// read layout from an xml file 
	this(char[] fileName)
	{
		// read layout xml data 
		LayoutData layout = readLayoutXMLData(fileName); 

		// set layout position and width 
		setPosition(layout.position);
		setSize(layout.size);

		Color makeColor(char[][] colorStr)
		{
			return Color(
				toUbyte(colorStr[0]), 
				toUbyte(colorStr[1]),
				toUbyte(colorStr[2]),
				toUbyte(colorStr[3]));
		}
		
		// add all images to the layout 
		foreach(ImageData image; layout.images)
		{
			if (!(image.name in widgets))
			{
				char[] currw = image.name; 
				char[][] color = std.string.split(image.color,";"); 

				widgets[currw] = new Image(image.image); 
				widgets[currw].setPosition(image.position);
				widgets[currw].setSize(image.size);
				widgets[currw].setColor(makeColor(color)); 

				widgetBoundsCheck(widgets[currw]);
			}
			else
			{
				throw new Exception("Error: The image " ~ image.name ~ " has the same name as another widget in " ~ fileName); 
			}
		}

		// add all labels to the layout 
		foreach(LabelData label; layout.labels)
		{
			if (!(label.name in widgets))
			{
				char[] currw = label.name; 
				char[][] color = std.string.split(label.color,";"); 
				char[][] fontcolor = std.string.split(label.fontcolor,";"); 

				Font font = new Font(label.fontname, label.fontheight); 

				widgets[currw] = new Label; 
				widgets[currw].setFont(font); 
				widgets[currw].setText(label.text); 
				widgets[currw].setPosition(label.position);
				widgets[currw].setSize(label.size);
				
				widgets[currw].setColor(makeColor(color)); 
										
				widgets[currw].setFontColor(makeColor(fontcolor)); 

				widgetBoundsCheck(widgets[currw]);
			}
			else
			{
				throw new Exception("Error: The label " ~ label.name ~ " has the same name as another widget in " ~ fileName); 
			}

		}

		// add all buttons to the layout 
		foreach(ButtonData button; layout.buttons)
		{
			if (!(button.name in widgets))
			{
				char[] currw = button.name; 
				char[][] color = std.string.split(button.color,";"); 
				char[][] fontcolor = std.string.split(button.fontcolor,";"); 

				Font font = new Font(button.fontname, button.fontheight); 
	
				widgets[currw] = new Button();
				widgets[currw].setFont(font); 
				widgets[currw].setText(button.text); 
				widgets[currw].setPosition(button.position);
				widgets[currw].setSize(button.size);
                
				widgets[currw].setColor(makeColor(color)); 
										
				widgets[currw].setFontColor(makeColor(fontcolor)); 

				widgetBoundsCheck(widgets[currw]);

			}
			else
			{
				throw new Exception("Error: The button " ~ button.name ~ " has the same name as another widget in " ~ fileName); 
			}

		}

		// add all textboxes to the layout 
		foreach(TextBoxData textboxes; layout.textboxes)
		{
			if (!(textboxes.name in widgets))
			{
				char[] currw = textboxes.name; 
				char[][] color = std.string.split(textboxes.color,";"); 
				char[][] fontcolor = std.string.split(textboxes.fontcolor,";"); 

				Font font = new Font(textboxes.fontname, textboxes.fontheight);

				widgets[currw] = new TextBox();
				widgets[currw].setFont(font); 
				widgets[currw].setText(textboxes.text); 

				widgets[currw].setPosition(textboxes.position);
				widgets[currw].setSize(textboxes.size);

				widgets[currw].setColor(makeColor(color)); 
										
				widgets[currw].setFontColor(makeColor(fontcolor)); 

				widgetBoundsCheck(widgets[currw]);
			}
			else
			{
				throw new Exception("Error: The textbox " ~ textboxes.name ~ " has the same name as another widget in " ~ fileName); 
			}

			widgets.rehash; 
		}

	}

	/// draw bounds of layout 
	void drawBounds(Point parentPos = Point(0,0));

	/// draw layout 
	void draw(Point parentPos = Point(0,0));

	/// process layout 
	void process(Point parentPos = Point(0,0));

	/// get widget by name from layout 
	Widget getWidget(char[] widgetName);
	
	/// add a widget to the layout 
	void addWidget(char[] wname, Widget w);

	/// check to see if widget is within bounds 
	void widgetBoundsCheck(Widget w, Point parentPos = Point(0,0));

	/// set hide or not 
	void setHide(bool argH);

  private:
		// hold widgets in array by name
		Widget[char[]] widgets;

		// whether to display and process layout or not 
		bool hide=false; 
  
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
