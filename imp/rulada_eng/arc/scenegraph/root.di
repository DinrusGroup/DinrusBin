/******************************************************************************* 

	The scenegraph's root node.

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:
		The rootNode defined in this module is the global root 
		for the scenegraph.
		It serves as a point of reference for 
		coordinate transformations. Subnodes can expect that
		this root node lives in the coordinate system
		defined in arc.window.
		
		Also, some functions like arc.scenegraph.drawable.drawScenegraph or
		arc.scenegraph.advancable.advanceScenegraph work on the tree started
		with this node.

*******************************************************************************/

module arc.scenegraph.root;

import 
	arc.scenegraph.node,
	arc.types;

/** 
	The scenegraph's root node.
**/
RootNode rootNode;

/**
	Interface for nodes that want to be notified when they
	are added or removed from the root tree that starts
	with the root node in this module.
**/
interface INotifyOnRootTreeAddRemove
{
	void addedToRootTree();
	void removedFromRootTree();
}

private
{
	class RootNode : GroupNode, INotifyOnChildrenAddRemove
	{
		override void childAdded(Node n)
		{
			if(auto x = cast(INotifyOnRootTreeAddRemove) n)
				x.addedToRootTree();
		}
		
		override void childRemoved(Node n)
		{
			if(auto x = cast(INotifyOnRootTreeAddRemove) n)
				x.removedFromRootTree();			
		}
	}
}

static this()
{
	rootNode = new RootNode;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
