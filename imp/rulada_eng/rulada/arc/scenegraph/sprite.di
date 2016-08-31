/******************************************************************************* 

	The scenegraph's sprite class.

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
		The scenegraph's sprite class. An alternative to Arc's other
	sprite class. 


	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/

module arc.scenegraph.sprite;

import 
	arc.scenegraph.node,
	arc.scenegraph.transform,
	arc.types;
		
/// Sprite class is a composite group node
class Sprite : CompositeGroupNode
{
	/// initialize 
	this(Node initialState)
	{
		state_ = initialState;
		
		transform = new Transform;		
		transform.addChild(initialState);		
		
		super(transform, transform);
	}
	
	/// initialize with transform
	this(Transform atransform, Node initialState)
	{
		transform = atransform;
		state_ = initialState;
		
		super(atransform, atransform);
		
		atransform.addChild(initialState);		
	}
	
	/// return state 
	Node state()
	{
		return state_;
	}
	
	/// give a new state 
	void state(Node newState)
	{
		transform.removeChild(state_);
//		state_ = null;
		
		transform.addChild(newState);
		state_ = newState;
	}

	Transform transform;
	Node state_;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
