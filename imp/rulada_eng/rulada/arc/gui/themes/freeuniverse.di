/******************************************************************************* 

    FreeUniverse Theme for the GUI  

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		FreeUniverse Theme for the GUI  


	Examples:
	--------------------
		Not provided.
	--------------------

*******************************************************************************/

module arc.gui.themes.freeuniverse; 

import 
	arc.gui.widgets.types,
	arc.draw.shape,
	arc.draw.color,
	arc.math.point,
	arc.types;
	
import derelict.opengl.gl; 

/// Draw button FreeUniverse Style
void drawFreeUnivereButton(ACTIONTYPE type, bool focus, Point pos, Size size, Color color);

/// Draw label FreeUniverse Style
void drawFreeUnivereLabel(ACTIONTYPE type, bool focus, Point pos, Size size, Color color);

/// Draw textfield FreeUniverse Style
void drawFreeUnivereTextField(ACTIONTYPE type, bool focus, Point pos, Size size, Color color);
/// draw a nice rectangle border
private void drawBorder(ACTIONTYPE type, bool focus, Point pos, Size size, Color color);

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
