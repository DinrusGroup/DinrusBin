/******************************************************************************* 

    ReadXML used in the background by layout to read XML files 

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		ReadXML used in the background by layout to read XML files.
	User will not want to use this file by itself. 

	Examples:
	--------------------
		Not provided.
	--------------------

*******************************************************************************/

module arc.gui.readxml; 

// XML parsing into Node structure code 
import 
	arc.types, 
	arc.xml.xml;

// stream file and text->int conversion utilites 
import 	
	std.file,
	std.stream,
	std.io,
	std.string,
	std.conv; 

// read xml layout data public interface 
public
{
	// Read layout data 
	LayoutData readLayoutXMLData(char[] fileName);

	// Read GUI data 
	GUIData readGUIXMLData(char[] fileName);

	// GUI data /////////////////////////////////////////////
	struct GUIData
	{
		GUILayoutData[] layouts; 

		void addLayout(char[] name, char[] file, bool hide);
	}

	// each layout will contain this data 
	struct GUILayoutData
	{
		char[] name, file;
		bool hide; 
	}
	
	// Layout data //////////////////////////////////////////
	struct LayoutData
	{
		// name of the layout 
		char[] name;

		// x and y, width and height
		Point position;
		Size size;

		// layout widget data arrays
		ImageData[] images; 
		ButtonData[] buttons; 
		LabelData[] labels;
		TextBoxData[] textboxes; 

		// add image widget 
		void addImage(char[] name, Point pos, Size size, char[] color, char[] image);

		// add label widget 
		void addLabel(Point pos, Size size, uint fontheight, char[] name, char[] color, char[] fontcolor, char[] fontname);
		
		void setCurrLabelText(char[] argT);
		
		void addTextBox(Point pos, Size size, uint fontheight, char[] name, char[] color, char[] fontcolor, char[] fontname);

		void setCurrTextBoxText(char[] argT);
		
		void addButton(Point pos, Size size, uint fontheight, char[] name, char[] color, char[] fontcolor, char[] fontname);

		void setCurrButtonText(char[] argT);
		
		void print();
	}
	

	struct ButtonData
	{
		Point position;
		Size size;
		uint fontheight; 
		char[] name, text, color, fontcolor, fontname; 
	}

	struct TextBoxData 
	{
		Point position; 
		Size size;
		uint fontheight; 
		uint maxwidth=0;
		uint maxlines=0; 
		char[] name, text, color, fontcolor, fontname;
	}

	struct LabelData 
	{
		Point position;
		Size size;
		uint fontheight; 
		char[] name, text, color, fontcolor, fontname; 
	}

	// single image can hold a list of frames 
	struct ImageData
	{
		Point position;
		Size size;
		char[] name; 
		char[] color;
		char[] image;

		void print();
	}

}

// privates user should not access 
private 
{
	char[][] validWidgets; 
	
	void initializeValidParents();

	// Recursively print all Nodes in the xml tree
	void recurseReadLayoutXML(inout LayoutData layout, XmlNode node, char[] parentName="");

	// Recursively print all Nodes in the xml tree
	void recurseReadGUIXML(inout GUIData gui, XmlNode node, char[] parentName="");
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
