/******************************************************************************* 

    Arc defined types

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
		User defined types in arc, including arcfl and Radians. 
		Also provides public imports of common types.

	Examples:
	--------------------
		arcfl user_value = 3;
	--------------------

*******************************************************************************/

module arc.types; 

public import 
		arc.math.angle,
		arc.math.point,
		arc.math.size,
		arc.math.rect,
		arc.math.arcfl,
		arc.draw.color;

alias float arcfl; 
version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
