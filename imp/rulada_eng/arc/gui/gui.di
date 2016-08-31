/******************************************************************************* 

    Arc's GUI system 

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		Arc GUI class can hold a number of layouts of GUI widgets to 
		allow users to create GUI's for their games. 

	Examples:
	--------------------
	import arc.gui.gui;

	int main()
	{
		// load GUI file from XML
		HandleGUI handle = new HandleGUI; 
		GUI gui = new GUI("unittestbin/gui.xml");

		// connect layout widgets actions with specific code 
		gui.getLayout("layout1").getWidget("myimg").clicked.connect(&handle.image);
		gui.getLayout("layout1").getWidget("lbl1").clicked.connect(&handle.label);
		
		while (!arc.input.keyDown(ARC_QUIT))
		{
			arc.input.process();
			arc.window.clear(); 

			gui.process();
			gui.draw(); 

			arc.window.swap(); 
		}
		
		return 0; 
	}

	--------------------

*******************************************************************************/

module arc.gui.gui; 

import 
	arc.gui.layout,
	arc.gui.readxml,
	arc.log,
	arc.types; 

public import arc.gui.widgets.widget; 

/// GUI class 
class GUI 
{
  public: 
	/// load GUI from xml file 
	this(char[] xmlfile)
	{
		// read GUI xml data 
		GUIData gui = readGUIXMLData(xmlfile);

		// load each of the layouts 
		foreach(GUILayoutData layout; gui.layouts)
		{
			Layout l = new Layout(layout.file); 
			l.setHide(layout.hide); 
			layouts[layout.name] = l; 
			debug writefln("Loaded layout ", layout.name);
		}

		// optimize layout hash 
		layouts.rehash; 
	}

	/// draw gui 
	void draw();
    
    /// draw layout bounds of the GUI
    void drawBounds();

	/// process gui 
	void process();
	
	/// get layout 
	Layout getLayout(char[] layoutName);
  
  private: 
	Layout[char[]] layouts; 
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
