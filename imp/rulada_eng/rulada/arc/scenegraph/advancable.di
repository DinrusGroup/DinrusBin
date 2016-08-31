/******************************************************************************* 

	Advancable interface and traversal function

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
		Provides an interface for nodes	that want to be
		updated regularly with the time that has passed since
		the last call. For example the Physics nodes use
		it.
		
		The user has to call the advanceScenegraph function 
		regularly with the number of milliseconds that passed
		since the last call. Usually it'll be
		---
		arc.time.process();
		drawScenegraph(arc.time.elapsedMilliseconds);
		---

*******************************************************************************/

module arc.scenegraph.advancable;

import 
	arc.scenegraph.node,
	arc.scenegraph.root,
	arc.types;

/** 
	The advanceScenegraph function below will call the advance
	method defined in this interface for all nodes that
	derive from it.
**/
interface IAdvancable
{
	void advance(arcfl msDt);
}

/**
	Calls the advance method on all IAdvancable-derived
	nodes situated below the rootNode.
**/
void advanceScenegraph(arcfl msDt)
{
	foreach(n; &rootNode.traverseDown)
	{
		IAdvancable advancable = cast(IAdvancable) n;
		if(advancable)
			advancable.advance(msDt);
	}
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
