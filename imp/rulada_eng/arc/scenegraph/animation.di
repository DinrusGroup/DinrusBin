/******************************************************************************* 

	Simple frame-based animations

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Christian Kamm (kamm incasoftware de) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
		Provides a class for creating animation nodes that will play an animation
		by showing frame after frame. The animation data must be located in a
		texture: All the frames are placed in a horizontal row, directly adjacent
		to one another.
		
		You need to use arc.scenegraph.advancable.advanceScenegraph regularly to
		make the animations run and should use 
		arc.scenegraph.drawable.drawScenegraph to get them drawn to the screen.

	Example:      
	---------------------
	// Setup:
	auto explosionanimation = 
		new LinearAnimation(
			new Frame(Texture("explosion.png"), Rect(0,0,30,30)), // <- this is the leftmost frame
			10, // <- number of frames
			20, // <- delay between frames in ms
			LinearAnimation.Direction.Forward // <- play forward (default)
		);
	
	explosionanimation.sigEnd.connect(&onDoneExploding);
	
	// Now, whenever you want the explosion animation, add it to the scenegraph
	someNode.addChild(explosionanimation.start());
	// it will run and call onDoneExploding when done
	---------------------

*******************************************************************************/

module arc.scenegraph.animation;

import 
	arc.types,
	arc.draw.image,
	arc.math.rect,
	arc.scenegraph.frame,
	arc.scenegraph.node,
	arc.scenegraph.drawable,
	arc.scenegraph.advancable,
	arc.templates.flexsignal; 

/***
	Base class for all animated nodes. Lets see if it makes sense to have this.
*/
class AnimationNode : MultiParentNode, IDrawable, IAdvancable
{
	/// Workaround, D complains if these are missing
	override void draw() {}
	override void advance(arcfl msDt) {} /// ditto
}

/**
	Factory for nodes drawing frame-based animations.
	
	Once set up, call LinearAnimation.start to produce a new
	Node that plays the animation.
**/
class LinearAnimation
{
public:
	/// the animation nodes created by this class raise this when the animation is over
	mixin FlexSignal!(AnimationNode) sigEnd;
	
	/** 
		Determines how the animation runs.
	
		Options:
			forward - runs from leftmost frame to rightmost frame
			forward loop - like forward, but starts from the beginning once through
			backward - runs from rightmost frame to leftmost frame
			backward loop - see forward loop
			circular - runs forward, then backward, then forward again, ...
	**/
	enum Direction : int
	{
		Forward = 1,
		ForwardLoop = 2,
		Backward = -1,
		BackwardLoop = -2,
		Circular = 0
	}
		
	/**
		Constructs a class of animations. All instances created by methods of this class will
		have the properties set here.
	
		Params:
			startFrame = Frame node that determines texture and area of the leftmost frame
			nFrames    = number of frames in animation; in the texture, the frames are located 
			             in a horizonal row starting with the first frame
			msDelay    = milliseconds to wait before switching to the next frame
			dir        = direction the animation shall run, see Direction enum
	**/
	this(Frame startframe, uint nFrames_ = 1, arcfl msDelay_ = 1, Direction dir_ = Direction.Forward)
	in
	{
		assert(
				startframe.frame.getLeft + startframe.frame.getSize.w * nFrames_ <=  startframe.texture.getSize.w,
				"Animation in '" ~ startframe.texture.getFile ~ "' exceeds image dimensions.");
	}
	body
	{
		startFrame = startframe;
		nFrames = nFrames_;
		msDelay = msDelay_;
		direction = dir_;
	}
	
	/**
		Creates and returns a new Node that plays the animation with the
		settings given in the constructor.
	**/
	StateNode start()
	{
		return new StateNode();
	}
	
private:
	Direction direction;
	Frame startFrame;
	uint nFrames;
	arcfl msDelay;

	class StateNode : AnimationNode
	{
		this()
		{
			currentFrame = startFrame.dup();
			restart();
		}
		
		void restart()
		{
			switch(direction)
			{
				case Direction.Forward, Direction.ForwardLoop, Direction.Circular:
				{
					currentFrameIndex = 0;
					step = 1;
					break;
				}
				case Direction.Backward, Direction.BackwardLoop:
				{
					currentFrameIndex = nFrames - 1;
					step = -1;
					break;
				}
			}
			msRemaining = msDelay;
			updateCurrentFrame();
		}
		
		override void advance(arcfl msDt)
		{
			msRemaining -= msDt;
			
			while(msRemaining < 0)
			{
				msRemaining += msDelay;
				
				if(step == 0)
					continue;
				
				if(currentFrameIndex == nFrames - 1 && direction == Direction.Forward)
				{
					step = 0;
					sigEnd.emit(this);
				}
				else if(currentFrameIndex == 0 && direction == Direction.Backward)
				{
					step = 0;
					sigEnd.emit(this);
				}
				else if(currentFrameIndex == nFrames - 1 && direction == Direction.Circular && step == 1)
				{
					step = -1;
					currentFrameIndex += step;
				}
				else if(currentFrameIndex == 0 && direction == Direction.Circular && step == -1)
				{
					step = 1;
					currentFrameIndex += step;
				}
				else if(currentFrameIndex == 0 && direction == Direction.BackwardLoop)
					currentFrameIndex = nFrames - 1;
				else if(currentFrameIndex == nFrames - 1 && direction == Direction.ForwardLoop)
					currentFrameIndex = 0;
				else
					currentFrameIndex += step;
			}
			updateCurrentFrame();
		}
		
		override void draw()
		{
			currentFrame.draw();
		}
		
		void updateCurrentFrame()
		{
			arcfl movex = startFrame.frame.size.w * currentFrameIndex;
			currentFrame.frame.topLeft.x = startFrame.frame.topLeft.x + movex;
		}
		
		Frame currentFrame;
		uint currentFrameIndex;
		int step;
		arcfl msRemaining;
	}
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
