/******************************************************************************* 

	World class holds physics objects inside of it  

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	The contents of this file are based on E. Catto's Box2d, which is 
	Copyright (c) 2006 Erin Catto http://www.gphysics.com. 

	Description:    
		World class holds physics objects inside of it  

	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/

module arc.physics.world; 

import 
	arc.physics.arbiter,
	arc.physics.mybody,
	arc.physics.joint,
	arc.physics.quadtree,
	arc.physics.drawphysics,
	arc.physics.collide,
	arc.scenegraph.node,
	arc.scenegraph.advancable,
	arc.scenegraph.drawable,
	arc.math.point,
	arc.math.rect,
	arc.math.matrix,
	arc.math.routines,
	arc.templates.redblacktree,
	arc.templates.array,
	arc.types;

static import std.io;

/***
	Root node for physics. 

	All Body-derived nodes added below it will be moved according
	to their velocities and considered for collisions.
*/
class World : GroupNode, IAdvancable, IDrawable, INotifyOnChildrenAddRemove
{
	///TODO: Replace with a drawphysics node in order to be able to change drawlevels
	bool drawBodies = false;

	/// constructor
	this(Rect area_, int iterations_, Point gravity_)
	{
		iterations = iterations_;
		arbiters = new RedBlackTree!(Arbiter);
		quadtree = Quadtree!(Body)(area_);
		gravity = gravity_;
	}

	/**
		Implementing INotifyOnChildrenAddRemove
		if a child added is Body-derived, register it with the world
	**/
	override void childAdded(Node n)
	{
		Body b = cast(Body) n;
		
		if(b !is null)
			bodies ~= b;
	}
	
	/**
		Implementing INotifyOnChildrenAddRemove
		if a child removed is Body-derived, unregister it from the world
	**/
	override void childRemoved(Node n)
	{
		Body b = cast(Body) n;
		
		if(b !is null)
		{
			bodiesToRemove ~= b;
			
			// schedule all arbiters for b for removal
			foreach(inout arb; arbiters)
				if(arb.data.body1 is b || arb.data.body2 is b)
					arb.data.remove = true;
		}
	}
	
	/// advance time in the world
	override void advance(arcfl msDt)
	{
		// make sure we don't get msDt == 0
		if(msDt == 0)
			msDt = 1;
		
		arcfl inv_dt = 1.0f / msDt;

		// make sure there's an arbiter for each contact
		updateCollisions(msDt);

		// apply forces on bodies
		foreach(inout b; bodies)
		{
			if (b.getInvMass == 0.0f)
				continue;

			b.velocity += msDt * (gravity + b.getInvMass * b.force);
			b.angularVelocity += msDt * b.getInvInertia * b.torque;
			
			b.preStep_velocity = b.velocity;
			b.preStep_angularVelocity = b.angularVelocity;
			
			b.force += b.getMass * gravity;
		}

		foreach(inout arb; arbiters)
		{
			if(!arb.data.body1.passThroughBodies && !arb.data.body2.passThroughBodies)
				arb.data.preStep(inv_dt); 
		}

		foreach(inout j; joints)
		{
			j.preStep(inv_dt);	
		}

		for (int i = 0; i < iterations; ++i)
		{
			foreach(inout arb; arbiters)
			{
				if(!arb.data.body1.passThroughBodies && !arb.data.body2.passThroughBodies)
					arb.data.applyImpulse();
			}
					
			foreach(inout j; joints)
			{
				j.applyImpulse();
			}
		}

		// step positions on bodies and reset forces
		foreach(inout b; bodies)
		{
			b.translation += msDt * b.velocity + msDt * b.biasVelocity;
			b.rotation = b.rotation + msDt * b.angularVelocity + msDt * b.biasAngularVelocity;

			b.biasVelocity.set(0.0f, 0.0f);
			b.biasAngularVelocity = 0.0f;
			b.force.set(0.0f, 0.0f);
			b.torque = 0.0f;
		}
	}
	
	override void draw() 
	{
		if(drawBodies)					
			foreach(b; bodies)
				drawBody(b);
			
		//TODO: Draw Joints
	}
	
private:
	/**
		Steps through all spacially close body pairs, adds arbiters for bodies and
	  might call collision handlers
	*/
	void updateCollisions(arcfl msDt)
	{
		alias arbiters.Node ArbIter;
		
		ArbIter arbQuery;
		Arbiter arbiter;
		
		size_t nContacts;
		Contact[] contacts;
		contacts.length = MAX_COLLISION_POINTS;
		
		quadtree.rebuild(bodies);
		
		foreach(node; quadtree.nodes)
		{
			debug(DrawQuadtree) node.draw();
			foreach(bi; node.elements)
				foreach(bj; node.elements)
				{	
					if(bi is bj)
						break;
					
					if(bi.getInvMass == 0 && bj.getInvMass == 0)
						continue;
					
					// fetch any information about the collision between the two objects
					arbiter = Arbiter(bi,bj);
					arbQuery = arbiters.search(arbiter);
					
					// if we already updated the collision this round, continue
					if(arbQuery !is null && arbQuery.data.updated)
						continue;
					
					// calculate data
					nContacts = getCollider(arbiter.body1, arbiter.body2)(contacts, arbiter.body1, arbiter.body2);
					
					// if this is a new collision...
					if(arbQuery is null && nContacts > 0)
					{
						arbiter = Arbiter(bi, bj, contacts, nContacts);
						arbiter.updated = true;
						
						arbiters.add(arbiter);
					
						callNewCollision(bi, bj);						
					}
					// if this is a sustained collision
					else if(arbQuery !is null && nContacts > 0)
					{
						arbQuery.data.updated = true;
						
						arbQuery.data.update(contacts, nContacts);
						
						callUpdateCollision(bi, bj, msDt);						
					}
					// if this is an ending collision
					else if(arbQuery !is null && nContacts == 0)
					{
						arbQuery.data.updated = true;
						arbQuery.data.remove = true;
						
						callEndCollision(bi, bj);
					}
				}
		}
		
		// set updated to false and collect list of CollisionInfos to remove
		Arbiter*[] toRemove;
		foreach(inout arb; arbiters)
		{
			arb.data.updated = false;
			if(arb.data.remove)
				toRemove ~= &arb.data;
		}
		
		// remove toRemove arbiters
		foreach(arbptr; toRemove)
			arbiters.remove(*arbptr);
		
		// remove toRemove bodies
		foreach(b; bodiesToRemove)
			bodies.remove(b);		
		bodiesToRemove.length = 0;
	}
	
	final void callNewCollision(Body b1, Body b2)
	{
		if(b1.triggerOwnCollisionSignals && b2.triggerOtherCollisionSignals)
			b1.sigCollideStart.emit(b1, b2);
		if(b2.triggerOwnCollisionSignals && b1.triggerOtherCollisionSignals)
			b2.sigCollideStart.emit(b2, b1);
	}

	final void callUpdateCollision(Body b1, Body b2, arcfl msDt)
	{
		if(b1.triggerOwnCollisionSignals && b2.triggerOtherCollisionSignals)
			b1.sigCollide.emit(b1, b2, msDt);
		if(b2.triggerOwnCollisionSignals && b1.triggerOtherCollisionSignals)
			b2.sigCollide.emit(b2, b1, msDt);
	}
	
	final void callEndCollision(Body b1, Body b2)
	{
		if(b1.triggerOwnCollisionSignals && b2.triggerOtherCollisionSignals)
			b1.sigCollideEnd.emit(b1, b2);
		if(b2.triggerOwnCollisionSignals && b1.triggerOtherCollisionSignals)
			b2.sigCollideEnd.emit(b2, b1);
	}
	
	Body[] bodies;
	Body[] bodiesToRemove;
	Joint[] joints;
	Quadtree!(Body) quadtree;
	RedBlackTree!(Arbiter) arbiters;
	int iterations;
	Point gravity;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
