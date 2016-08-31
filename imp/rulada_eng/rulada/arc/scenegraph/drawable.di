/******************************************************************************* 

	Drawable interface and traversal function

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
		Provides interfaces for nodes that want to draw themselves
		or want to alter the (OpenGL) state when drawing the
		scenegraph.
		
		It is neccessary to call the drawScenegraph function each 
		frame.
		
		The draw order can be controlled with the DrawLevel node.

*******************************************************************************/

module arc.scenegraph.drawable;

import 
	arc.scenegraph.node,
	arc.scenegraph.root,
	arc.templates.array,
	arc.types;

/** 
	The drawScenegraph function below will call the draw
	method defined in this interface for all nodes that
	derive from it.
**/
interface IDrawable
{
	void draw();
}

/** 
	The drawScenegraph function below will call the
	drawStateChangeApply method when arriving at a node
	derived from this interface, then proceed to its
	children and finally call drawStateChangeRestore when
	all children are done.
**/
interface IDrawStateChange
{
	void drawStateChangeApply();
	void drawStateChangeRestore();
}

/**
	Calls the draw and drawStateChangeApply/Restore methods
	for nodes that derive from the appropriate interfaces.
	
	It respects the draw order defined by the DrawLevel nodes, 
	implicitly drawing the rootNode at a level of 0.
**/
void drawScenegraph()
{
	// root node is implicitly drawlevel 0
	drawLevel(rootNode);
	
	foreach(key; DrawLevel.drawLevels.keys.sort)
		foreach(level; DrawLevel.drawLevels[key])
			drawLevel(level);
}

/**
	Provides draw-order functionality.
	
	Children to a DrawLevel node with a large number will
	be drawn after children of a DrawLevel node with a small number.
	
	The root node is implicitly drawn at number 0.
**/
class DrawLevel : GroupNode, INotifyOnRootTreeAddRemove
{
	static DrawLevel[][int] drawLevels;
	
	/// construct with given draw level 
	this(int adrawLevel)
	{
		drawLevel = adrawLevel;
	}
	
	/**
		When added to the root tree, register it with a global
		list of draw levels. Conversely, remove it when unparented.
	**/
	override void addedToRootTree()
	{
		drawLevels[drawLevel] ~= this;
	}
	
	/// ditto
	override void removedFromRootTree()
	{
		drawLevels[drawLevel].remove(this);
	}

private:
	int drawLevel;
}


private
{	
	/**
		Draws everything below start or until it reaches further DrawLevels.
	
		For this, it needs to apply all IDrawStateChanges between root and
		start, iterate over all nodes below start until reaching a leaf
		node or another DrawLevel and then restore the state changes again.
	**/
	void drawLevel(SingleParentNode start)
	{
		applyBackwardsDrawStateChanges(rootNode, start);		
		drawTraverse(start);
		restoreBackwardsDrawStateChanges(rootNode, start);
	}
	
	void drawTraverse(Node node)
	{
		IDrawable drawable = cast(IDrawable) node;
		IDrawStateChange drawstatechange = cast(IDrawStateChange) node;
		
		if(drawstatechange)
			drawstatechange.drawStateChangeApply();
		if(drawable)
			drawable.draw();
		
		foreach(child; &node.iterateChildren)
			if(cast(DrawLevel) child is null)
				drawTraverse(child);
	
		if(drawstatechange)
			drawstatechange.drawStateChangeRestore();
	}
	
	void applyBackwardsDrawStateChanges(SingleParentNode from, SingleParentNode to)
	{
		bool start = false;
		foreach(n; &to.traverseUpReverse)
		{
			if(n is from)
				start = true;
			
			if(start)
			{
				IDrawStateChange drawstatechange = cast(IDrawStateChange) n;
				if(drawstatechange)
					drawstatechange.drawStateChangeApply();
			}
		}
	}
	
	void restoreBackwardsDrawStateChanges(SingleParentNode from, SingleParentNode to)
	{
		foreach(n; &to.traverseUp)
		{
			IDrawStateChange drawstatechange = cast(IDrawStateChange) n;
			if(drawstatechange)
				drawstatechange.drawStateChangeRestore();
			
			if(n is from)
				break;
		}
	}
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
