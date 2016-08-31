/******************************************************************************* 

	XML saving/loading functionality.
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
	
	XML saving/loading functionality.
	
	Comment by Eric Poggel: 
	
	According to http://aegisknight.org/~andy/d/
	this code is in the public domain.
	When trying to contact the author, andy@ikagames.com, the mail bounced.
	As stated on the page above:
	"Legal crap: Unless specified otherwise, all of this stuff is placed
	in the public domain, with the exception of stuff I didn't make, which
	is copyrighted to whomever did make it."

	Examples:      
	---------------------
		See XML unittest 
	---------------------

*******************************************************************************/

module arc.xml.xml;

public import arc.xml.xmlnode;

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
