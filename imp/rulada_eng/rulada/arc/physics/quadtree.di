/******************************************************************************* 

	Quadtree implementation to speed up physics code.

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
		Quadtree implementation to speed up physics code. 

	Examples:      
	---------------------
	None provided 
	---------------------

*******************************************************************************/

module arc.physics.quadtree;

import 
	arc.math.point,
	arc.math.matrix,
	arc.math.routines,
	arc.math.rect,
	arc.types;

import 
	derelict.sdl.sdl,
	derelict.opengl.gl,
	derelict.opengl.glu;

/// quadtree structure
struct Quadtree(T)
{
	uint max_elements_per_node;
	uint max_depth;
	Rect total_area;
		
	Node[] nodes;	

	/// create new quadree with rect area, max elements and depth per node
	static Quadtree opCall(Rect area, uint max_elements_per_node_ = 8, uint max_depth_ = 4)
	{
		Quadtree q;
		
		q.total_area = area;
		q.max_elements_per_node = max_elements_per_node_;
		q.max_depth = max_depth_;
		
		return q;
	}

	/// rebuild 
	void rebuild(T[] newElements)
	{
		clean();
		
		foreach(e; newElements)
			add(e);
	}

	/// add body to quadtree
	void add(T e)
	in
	{
		assert(e !is null);
	}
	body
	{
		Rect bounding_box = e.getBoundingBox();
		
		bool added = false;
		
		// note that nodes.length changes during the loop
		// as nodes are split in four - do not use foreach!
		for(uint i = 1; i < nodes.length; ++i)
			if(tryAddToNode(i, e, bounding_box))
				added = true;
		
		// if it doesn't fit into any node, put it into node 0
		if(!added)
			nodes[0].elements ~= e;
	}

	/// remove elements from quadtree 
	void clean()
	{
		nodes.length = 2;
		
		// the catch-all-outside area node
		nodes[0].level = 0;
		nodes[0].elements.length = 0;
		nodes[0].area = Rect(0,0,0,0);
		
		// the root node
		nodes[1].level = 0;
		nodes[1].elements.length = 0;
		nodes[1].area = total_area;
	}
	
private:
	
	bool tryAddToNode(uint index, T e, inout Rect bounding_box)
	in
	{
		assert(index < nodes.length);
	}
	body
	{		
		if(nodes[index].area.intersects(bounding_box))
		{
			if(nodes[index].elements.length + 1 > max_elements_per_node && nodes[index].level < max_depth)
			{
				splitNode(index);
				// this does not try to add to the three other new nodes
				// on purpose! They will be covered by the for loop in 'add' anyway.
				return tryAddToNode(index, e, bounding_box);
			}
			else
			{
				nodes[index].elements ~= e;
				return true;
			}
		}
		
		return false;
	}
	
	void splitNode(uint i)
	in
	{
		assert(i < nodes.length);		
	}
	body
	{
		nodes[i].area.size *= 0.5;
		nodes[i].level += 1;
		
		nodes.length = nodes.length + 3;
		nodes[$-3].level = nodes[i].level;
		nodes[$-3].area = nodes[i].area;
		nodes[$-3].area.topLeft.x += nodes[i].area.size.w;
		
		nodes[$-2].level = nodes[i].level;
		nodes[$-2].area = nodes[i].area;
		nodes[$-2].area.topLeft.y += nodes[i].area.size.h;
		
		nodes[$-1].level = nodes[i].level;
		nodes[$-1].area = nodes[i].area;
		nodes[$-1].area.topLeft.x += nodes[i].area.size.w;
		nodes[$-1].area.topLeft.y += nodes[i].area.size.h;
		
		T[] elements_to_redistribute = nodes[i].elements;
		nodes[i].elements.length = 0;
		
		foreach(e; elements_to_redistribute)
		{
			Rect bounding_box = e.getBoundingBox();
			tryAddToNode(i, e, bounding_box);
			tryAddToNode(nodes.length - 3, e, bounding_box);
			tryAddToNode(nodes.length - 2, e, bounding_box);
			tryAddToNode(nodes.length - 1, e, bounding_box);
		}
	}
	
	/// Node structure used by quadtree 
	struct Node
	{
		uint level = 0;
		Rect area;
		T[] elements;
		
		debug(DrawQuadtree)
		{
			void draw()
			{
				glDisable(GL_TEXTURE_2D);
				glColor3f(1.0f, 1.0f, 0.0f);
	
				glBegin(GL_LINE_LOOP);
				glVertex2f(area.topLeft.x, area.topLeft.y);
				glVertex2f(area.topLeft.x + area.size.x, area.topLeft.y);
				glVertex2f(area.topLeft.x + area.size.x, area.topLeft.y + area.size.y);
				glVertex2f(area.topLeft.x, area.topLeft.y + area.size.y);
				glEnd();
									
				/*
				glColor3f(0.0f, 0.0f, 1.0f);
				
				foreach(e; elements)
				{
					glBegin(GL_LINES);
					glVertex2f(area.top_left.x + area.size.x / 2, area.top_left.y + area.size.y / 2);
					glVertex2f(e.position.x, e.position.y);
					glEnd();
				}
				*/
			}
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
