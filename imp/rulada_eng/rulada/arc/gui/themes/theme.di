/******************************************************************************* 

	Allows user to set the theme style used by Arc's GUI mechanism. 
	
    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		Allows user to set the theme style used by Arc's GUI mechanism. 
	Currently only the FreeUniverse theme is supported. 

	Examples:
	--------------------
		import arc.gui.themes.theme; 
		
		// set the theme 
		setTheme(FREEUNIVERSE); 
		
		// return type of theme
		THEME theme = getTheme(); 
	--------------------

*******************************************************************************/

module arc.gui.themes.theme; 

import 
	arc.types,
	arc.draw.color,
	arc.gui.widgets.types,
	arc.gui.themes.freeuniverse;

public  
{
	/// different themes the gui currently supports 
	enum THEME
	{
		FREEUNIVERSE,
		QT,
		WIN32
	}
}

private 
{	
	THEME currTheme; 
}

/// set theme of gui 
void setTheme(THEME theme);


/// get theme of gui 
THEME getTheme();


/// draw button with current theme
void drawButton(ACTIONTYPE type, bool focus, Point pos, Size size, Color color);

/// draw label with current theme
void drawLabel(ACTIONTYPE type, bool focus, Point pos, Size size, Color color);

/// draw textfields with current theme
void drawTextField(ACTIONTYPE type, bool focus, Point pos, Size size, Color color);





version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
