/******************************************************************************* 

	Arbiter calculates contact points between two bodies. 

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:      ArcLib team 

	The contents of this file are based on E. Catto's Box2d, which is 
	Copyright (c) 2006 Erin Catto http://www.gphysics.com. 

	Description:    
	Arbiter calculates contact points between two bodies. 

	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/

module arc.physics.arbiter; 

import 
	arc.physics.collide, 
	arc.physics.mybody,
	arc.math.point,
	arc.math.matrix,
	arc.math.routines,
	arc.types;

import std.math;

///TODO: polygons might have an arbitrary number of collision points.
const size_t MAX_COLLISION_POINTS = 2; 

/// Arbiter struct 
struct Arbiter
{
	/// whether this arbiter's contacts have been calculated this round
	bool updated = false;
	/// remove the arbiter after this round?
	bool remove = false;
	
	size_t nContacts = 0;
	Contact[] contacts;
	
	Body body1, body2;
	
	/// combined friction
	arcfl combined_friction = 0;
	/// combined restitution
	arcfl combined_restitution = 0;
	
	/// test if arbiter equals another arbiter 
	bool opEquals(inout Arbiter a);

	/// order arbiters lexographically by (body1, body2)
	int opCmp(inout Arbiter a);
	
	/// only use to generate dumb keys
	static Arbiter opCall(Body a, Body b);
	
	/// Arbiter constructor 
	static Arbiter opCall(Body a, Body b, Contact[] acontacts, size_t anContacts);

	/// updates an existing arbiter with new collision points
	void update(Contact[] new_contacts, int n_new_contacts);

	/**
		Performs once-per timestep actions and precomputations for the following iterations.
		- calculate normal and tangent mass vectors
		- compute restitution velocity
		- compute bias velocity
		- apply accumulated impulses for coherence
	*/
	void preStep(arcfl inv_dt);

	/**
		Perform one step of the iteration by trying to reach the desired
		velocities through applying impulses
	*/
	void applyImpulse();   
}





version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
