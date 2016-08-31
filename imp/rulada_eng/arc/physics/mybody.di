/******************************************************************************* 

	Code for body class. 

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	The contents of this file are based on E. Catto's Box2d, which is 
	Copyright (c) 2006 Erin Catto http://www.gphysics.com. 

	Description:    
		Code for body class. 

	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/

module arc.physics.mybody; 

import 
	arc.math.point,
	arc.math.matrix,
	arc.math.routines,
	arc.math.rect,
	arc.math.angle,
	arc.scenegraph.transform,
	arc.scenegraph.node,
	arc.templates.flexsignal,
	arc.types;

import std.io;


/// a body is a transform with translation and rotation updated according to physics
class Body : Transform
{
	/// create new body 
	this(arcfl amass)
	{
		setMass(amass);
	}	

	/// get bounding box of body 
	abstract Rect getBoundingBox();
	
	/// radius of bounding circle
	abstract arcfl getBoundingRadius();
	
	/**
	 * massless inertia around the center of mass
	 * i.e. evaluating (1/vol(V)) \int_V r^2 dx
	*/
	abstract arcfl getSurfaceFactor();

	/** 
		Can this body pass through others like a ghost?
		If this is true, collision with the body will still call
		the appropriate collision signals.
	**/
	bool passThroughBodies = false;
	
	/// does a collision trigger the other body's collision signals?
	bool triggerOtherCollisionSignals = true;
	
	/// does a collision trigger our own collision signals?
	bool triggerOwnCollisionSignals = true;
		
	/// see documentation at the FlexSignalAccess mixin
/*	package FlexSignal!(Body, Body) sigCollideStart_;
	package FlexSignal!(Body, Body, arcfl) sigCollide_; /// ditto
	package FlexSignal!(Body, Body) sigCollideEnd_; /// ditto
*/	
	/// raised when two bodies which were seperate before do now have contact
	mixin FlexSignal!(Body, Body) sigCollideStart;
	/// raised when two bodies continued to have contact for the given time
	mixin FlexSignal!(Body, Body, arcfl) sigCollide;
	/// raised when the contact between two bodies stopped
	mixin FlexSignal!(Body, Body) sigCollideEnd;
	
	
	// translation and rotation are inherited from Transform

	Point velocity;
	arcfl angularVelocity = 0;
	
	Point force;
	arcfl torque = 0;

	arcfl friction = 0.2;
	arcfl restitution = 0.7;
	
	///
	arcfl getMass() { return mass_; }
	
	///
	arcfl getInvMass() { return invMass_; }
	
	///
	void setMass(arcfl amass) 
	{ 
		mass_ = amass;
		inertia_ = mass_ * getSurfaceFactor();
		if(mass_ != arcfl.max)
		{
			invMass_ = 1. / mass_; 
			invInertia_ = 1. / inertia_;
		}
		else
		{
			invMass_ = 0;
			invInertia_ = 0;
		}
	}
	
	///
	arcfl getInertia() { return inertia_; }
	
	///
	arcfl getInvInertia() { return invInertia_; }	
	
package:
	/// arbiter.preStep changes velocities, these variables hold the unmodified ones
	Point preStep_velocity;
	arcfl preStep_angularVelocity = 0; /// ditto
	
	/// the bias velocities push two intersecting objects out of one another
	Point biasVelocity;
	arcfl biasAngularVelocity = 0; /// ditto
	
private:
	/// mass and its inverse
	arcfl mass_ = arcfl.max, invMass_ = 0;
	
	/// moment of inertia and its inverse
	arcfl inertia_ = arcfl.max, invInertia_ = 0;	
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
