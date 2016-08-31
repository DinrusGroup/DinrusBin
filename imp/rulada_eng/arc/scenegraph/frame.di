/******************************************************************************* 

	Node that draws a section of a texture

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:
		Add the Frame nodes to the scenegraph and use
		arc.scenegraph.drawable.drawScenegraph to get them drawn.

*******************************************************************************/

module arc.scenegraph.frame;

import 
	arc.types,
	arc.texture,
	arc.scenegraph.node,
	arc.scenegraph.drawable,
	arc.draw.image,
	arc.math.rect,
	arc.math.point,
	arc.math.angle; 

import derelict.opengl.gl; 

/**
	Frame is a drawable that displays a section of a texture on screen.
	
	The midpoint value is relative to the top-left of the texture section
	and does not neccessarily have to lie within it.
**/
class Frame : MultiParentNode, IDrawable
{
	enum Midpoint
	{
		Center,
		TopLeft
	}
	
	/// Construct with texture and midpoint specified by enum
	this(Texture texture_, Midpoint midpoint_ = Midpoint.Center)
	{
		texture = texture_;
		frame = Rect(Point(0,0), texture.getSize);		
		setMidpointByEnum(midpoint_);
	}

	/// Construct with texture and midpoint given explicitly
	this(Texture texture_, Point midpoint_)
	{
		texture = texture_;
		frame = Rect(Point(0,0), texture.getSize);
		midpoint = midpoint_;
	}
	
	/**
		Construct with texture, rectangle of the texture to be
		displayed and midpoint by enum
	**/
	this(Texture texture_, Rect frame_, Midpoint midpoint_ = Midpoint.Center)
	{
		texture = texture_;
		frame = frame_;
		setMidpointByEnum(midpoint_);
	}
	
	/**
		Construct with texture, rectangle of the texture to be
		displayed and midpoint given explicitly
	**/
	this(Texture texture_, Rect frame_, Point midpoint_)
	{
		texture = texture_;
		frame = frame_;
		midpoint = midpoint_;
	}
	
	// just set midpoint
	this(Midpoint midpoint_ = Midpoint.Center)
	{
		setMidpointByEnum(midpoint_);
	}
	
	/// return duplicate of frame
	Frame dup()
	{
		Frame f = new Frame(texture, frame, midpoint);
		foreach(i, elem; this.tupleof)
			f.tupleof[i] = elem;
		return f;
	}
	
	/// draw section of the texture
	override void draw()
	{
		glPushMatrix();
		glRotatef(radiansToDegrees(rotation), 0, 0, 1);
		glScalef(scale.x, scale.y, 1);
		glTranslatef(-midpoint.x, -midpoint.y, 0);

		/// BUG: make sure drawImageSubsection doesn't change any GL state
		drawImageSubsection(texture, frame.topLeft, frame.getBottomRight);
	
		glPopMatrix();
	}
	
	/// frame frame
	void setFrame(inout Rect frame_)
	in
	{
		assert(
				frame_.getLeft >= 0 &&
				frame_.getTop >= 0 &&
				frame_.getRight <= texture.getSize.w &&
				frame_.getBottom <= texture.getSize.h,
				"Frame in '" ~ texture.getFile ~ "' exceeds image dimensions.");
	}
	body
	{
		frame = frame_;
	}
	
	/// get frame for frame
	Rect getFrame()
	{
		return frame;
	}
	
	/// scale frame
	void setScale(Point s)
	{
		scale = s;
	}
	
	/// scale frame
	void setScale(arcfl s)
	{
		scale.set(s, s);
	}
		
package:
	void setMidpointByEnum(Midpoint m)
	{
		switch(m)
		{
			case Midpoint.TopLeft:
			{
				midpoint = Point(0,0);
				break;
			}
			case Midpoint.Center:
			{
				midpoint = Point(frame.size.w / 2, frame.size.h / 2);
				break;
			}
		}
	}
	
	Texture texture;
	Rect frame;
	Point midpoint;
	Point scale = {1f, 1f};
	Radians rotation = cast(Radians)0;
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
