/*
* The X11/MIT License
* 
* Copyright (c) 2008-2009, Jonas Kivi
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

module rae.ui.Animator;

import tango.util.log.Trace;//Thread safe console output.

import rae.core.globals;

import rae.core.Idle;
import rae.canvas.ICanvasItem;

import rae.canvas.Rectangle;
//Circular import/LinkedList/GDC bug is the reason
//for this insanity. ICanvasItem and stuff is all
//in Rectangle until that bug is fixed in GDC.

import rae.canvas.ControlCurve;//actually we'd like to import Point
import rae.canvas.Bezier;

enum AnimatorType
{
	RELATIVE_PATH,
	ABSOLUTE_PATH,
	ABSOLUTE_TO
}

class Animator// : ICanvasItem
{
protected:
	float delegate() getX;
	float delegate() getY;
	float delegate() getZ;
	void delegate(float) setX;
	void delegate(float) setY;
	void delegate(float) setZ;
	
	void delegate() whenFinished;
	
	float toX = 0.0f;
	float toY = 0.0f;
	float toZ = 0.0f;
	
	bool xDone = false;
	bool yDone = false;
	bool zDone = false;
	
	ICanvasItem owner( ICanvasItem set_owner ) { return m_owner = set_owner; }
	ICanvasItem owner() { return m_owner; }
	ICanvasItem m_owner;//CHECK name this parent?
	
	BezierG1 m_path;
	
	//Idle2 idle;
	
	//float speed = 1.0
	//void start()
	
public:

	AnimatorType animatorType;

	//this( float delegate() set_get, void delegate(float) set_set )
	
	this( ICanvasItem set_item, void delegate(float) set_x, void delegate(float) set_y, void delegate(float) set_z, void delegate() set_when_finished = null )
	{
		//BROKEN!?
	
		animatorType = AnimatorType.ABSOLUTE_PATH;
		
		//get = set_get;
		setX = set_x;
		setY = set_y;
		setZ = set_z;
		
		whenFinished = set_when_finished;
		
		owner = set_item;
		
		//if( owner !is null )
			//owner.add( this );
	}


	//TODO remove set_item from the ctor.
	//It should be set in Rectangle.add( Animator ).
	this( ICanvasItem set_item, void delegate(float) set_x, float delegate() get_x, void delegate(float) set_y, float delegate() get_y, void delegate(float) set_z, float delegate() get_z, void delegate() set_when_finished = null )
	{
		animatorType = AnimatorType.ABSOLUTE_TO;
		
		speed = 10.0f;
	
		//get = set_get;
		setX = set_x;
		getX = get_x;
		setY = set_y;
		getY = get_y;
		setZ = set_z;
		getZ = get_z;
		
		whenFinished = set_when_finished;
		
		if( setX is null || getX is null )
			xDone = true;
		if( setY is null || getY is null )
			yDone = true;
		if( setZ is null || getZ is null )
			zDone = true;
			
		owner = set_item;
		
		//if( owner !is null )
			//owner.add( this );
	}
	
	char[] toString()
	{
		char[] ret = "Animator: ";
		ret ~= "toX: ";
		ret ~= Float.toString(toX);
		ret ~= " toY: ";
		ret ~= Float.toString(toY);
		ret ~= " toZ: ";
		ret ~= Float.toString(toZ);
		return ret;
	}
	
	//Returns true if set_anim should be added to the animations in owner.
	//If there's something left there that couldn't be combined with
	//other animators.
	bool combine(Animator set_anim)
	{
		//We presume that the owner is the same.
	
		bool checkDelegateCombine( Animator a_anim, void delegate(float) a_dlg, Animator b_anim, void delegate(float) b_dlg )
		{
			if( a_dlg !is null && a_dlg is b_dlg )
			{
				return true;
			}
			return false;
		}
	
		if( animatorType == AnimatorType.ABSOLUTE_TO && set_anim.animatorType == AnimatorType.ABSOLUTE_TO )
		{
			//TODO check for other combinations, like if setX is setZ
		
			if( xDone == false && checkDelegateCombine( this, setX, set_anim, set_anim.setX ) )
			{
				debug(Animator) Trace.formatln("setX was identical. Removing it. toX: {} set_anim.toX: {}", cast(double)toX, cast(double)set_anim.toX );
				toX = set_anim.toX;
				whenFinished = set_anim.whenFinished;
				set_anim.setX = null;
				set_anim.xDone = true;	
				debug(Animator) Trace.formatln("after. toX: {}", cast(double)toX );
			}
			if( yDone == false && checkDelegateCombine( this, setY, set_anim, set_anim.setY ) )
			{
				debug(Animator) Trace.formatln("setY was identical. Removing it. {}", cast(double)toY );
				toY = set_anim.toY;
				whenFinished = set_anim.whenFinished;
				set_anim.setY = null;
				set_anim.yDone = true;
			}
			if( zDone == false && checkDelegateCombine( this, setZ, set_anim, set_anim.setZ ) )
			{
				debug(Animator) Trace.formatln("setZ was identical. Removing it. {}", cast(double)toZ );
				toZ = set_anim.toZ;
				whenFinished = set_anim.whenFinished;
				set_anim.setZ = null;
				set_anim.zDone = true;
			}
			
			if( set_anim.xDone == true && set_anim.yDone == true && set_anim.zDone == true )
			{
				return false;//Everything was combined.
			}
			//else
			return true;//There's something left in set_anim.
		}
	}
	
	/+
	//ABSOLUTE: X
	this( void delegate(float) set_x )
	{
		this( set_x, null, null );
	}
	
	//ABSOLUTE: X,Y
	this( void delegate(float) set_x, void delegate(float) set_y )
	{
		this( set_x, set_y, null );
	}
	
	//ABSOLUTE: X,Y,Z
	this( void delegate(float) set_x, void delegate(float) set_y, void delegate(float) set_z )//, AnimatorType set_type = AnimatorType.RELATIVE_PATH )
	{
		animatorType = AnimatorType.ABSOLUTE_PATH;
	
		//if( g_rae !is null )
		//	g_rae.registerAnimator(this);
		
		//get = set_get;
		setX = set_x;
		setY = set_y;
		setZ = set_z;
	}
	
	//RELATIVE: get X,Y,Z set X,Y,Z
	this( float delegate() get_x, float delegate() get_y, float delegate() get_z, void delegate(float) set_x, void delegate(float) set_y, void delegate(float) set_z )
	{
		animatorType = AnimatorType.RELATIVE_PATH;
	
		//if( g_rae !is null )
		//	g_rae.registerAnimator(this);
		
		getX = get_x;
		getY = get_y;
		getZ = get_z;
		setX = set_x;
		setY = set_y;
		setZ = set_z;
	}
	+/
	
	
	~this()
	{
		//delete m_path; //Hmm. Paths could be shared. Let GC decide.
		/////////delete idle;
	}
	
	void path( BezierG1 set_path, bool start_now = true )
	{
		m_path = set_path;
		//idle = new Idle2( &animate );
	}
	
	void animateTo( float to_x, float to_y, float to_z )
	{
		toX = to_x;
		toY = to_y;
		toZ = to_z;
	}
	
	void animateRelativeTo( float to_x, float to_y, float to_z )
	{
		if( getX !is null )
			toX = to_x + getX();
		if( getY !is null )
			toY = to_y + getY();
		if( getZ !is null )
			toZ = to_z + getZ();
	}
	
	double frameTime()
	{
		if( owner !is null )
			return owner.frameTime();
		return 0.0f;//CHECK no movement will happen without
		//a rootWindow... Is that bad?
	}
	
	//percent 0.0 - 1.0
	double position = 0.0;
	double speed = 1.0;
	
	void removeFromOwner()
	{
		debug(Animator) Trace.formatln("Animator.removeFromOwner() owner exists: {}", (owner !is null ? true : false) );
		if( owner !is null )
		{
			owner.remove( this );
		}
	}
	
	
	float last_x = 0.0f;
	int giveup_count_x = -1;//This might get to zero the first time.
	float last_y = 0.0f;
	int giveup_count_y = -1;
	float last_z = 0.0f;
	int giveup_count_z = -1;
	
	//CHECK rename to idle()???? to be consistent
	//with Rectangle.idle() which will call this?
	
	//Now there's also a system that will end the animation
	//if the animation is not moving at all, between two calls.
	//It usually means there's some other constraint that is preventing
	//the animation from finishing, so we don't want to argue, and just
	//give up. And call whenFinished() if there is one.
	bool animate()
	{
		if( animatorType == AnimatorType.ABSOLUTE_PATH )
		{
			//scope Point ret = m_path.next();
			position += speed * frameTime;
			
			if( position >= 1.0 )
			{
				position = 1.0;//To make the last call even.
			}
			
			scope Point ret = m_path.get(position);
			
			/*if( animatorType == AnimatorType.RELATIVE_PATH )
			{
				if( setX !is null && getX !is null )
					setX( getX() + (ret.x/30.0) );
				if( setY !is null && getY !is null  )
					setY( getY() + (ret.y/30.0) );
				if( setZ !is null && getZ !is null  )
					setZ( getZ() + (ret.z/30.0) );
			}
			else
			if( animatorType == AnimatorType.ABSOLUTE_PATH )
			{
			*/
				if( setX !is null )
					setX( ret.x );
				if( setY !is null )
					setY( ret.y );
				if( setZ !is null )
					setZ( ret.z );
			//}
			
			debug(AnimatorTemp)
			{
				Trace.formatln("x: {}", cast(double)ret.x);
				Trace.formatln("y: {}", cast(double)ret.y);
				Trace.formatln("z: {}", cast(double)ret.z);
			}
			
			//if( m_path.isLoop == true )
			if( position >= 1.0 )
			{
				if( whenFinished !is null )
					whenFinished();
			
				//This would segfault, if we were running the Animations from
				//a foreach. So we've removed this, and you can see how this
				//is settled in Rectangle.idle() with two foreaches. Where
				//the second one will do the removing.
				
				/*if( owner !is null )
				{
					owner.remove( this );
				}
				*/
				
				/*else
				{
					if( g_rae !is null )
						g_rae.removeAnimator(this);
				}*/
				//delete this;//Wow? Can't do this because the Idle will get deleted too...
				return false;//stop idle.
			}
		}
		else if( animatorType == AnimatorType.ABSOLUTE_TO )
		{
			float timevalue = (speed * frameTime);
			if( timevalue > 1.0f ) timevalue = 1.0f;//because if it's 1 we'll jump
			//straight to toX.
		
			if( xDone == false && setX !is null && getX !is null )
			{
				float now_x = toX - getX();//TODO rename now_x to diff_x.?
				debug(AnimatorTemp)
				{
					Trace.formatln("now_x: {}", cast(double)now_x);
					Trace.formatln("to_x: {}", cast(double)toX);
					Trace.formatln("getX: {}", cast(double)getX());
				}
				
				if( frameTime > 0.0f )
				{
					if( now_x > 0.0f )//toX is bigger than getX. now_x is positive. Going to zero.
					{
						if( now_x >= last_x )//if now_x hasn't moved or is going in the wrong way then we add giveup_count_x.
						{
							giveup_count_x++;
							debug(AnimatorTemp) Trace.formatln("addgiveup positive now_x: {}", cast(double)last_x);
						}
					}
					else if( now_x < 0.0f )//toX is smaller than getX. now_x is negative. Going to zero.
					{
						if( now_x <= last_x )//if now_x hasn't moved or is going in the wrong way then we add giveup_count_x.
						{
							giveup_count_x++;
							debug(AnimatorTemp) Trace.formatln("addgiveup negative now_x: {}", cast(double)last_x);
						}
					}
					
					if( giveup_count_x >= 25 )//Try for 25 times before giving up.
					{
						xDone = true;
						debug(AnimatorTemp) Trace.formatln("x anim giveup.");
					}
				}
				
				if( now_x < 0.001f && now_x > -0.001f )
				{
					debug(AnimatorTemp) Trace.formatln("xDone.");
					xDone = true;
					setX( toX );
				}
				else
				{
					setX( getX() + (timevalue * now_x) );
				}
				
				last_x = now_x;
			}
			
			if( yDone == false && setY !is null && getY !is null )
			{
				float now_y = toY - getY();
				debug(AnimatorTemp) Trace.formatln("now_y: {}", cast(double)now_y);
				
				if( now_y > 0.0f )//toX is bigger than getX. now_y is positive. Going to zero.
				{
					if( now_y >= last_y )//if now_y hasn't moved or is going in the wrong way then we add giveup_count_y.
					{
						giveup_count_y++;
					}
				}
				else if( now_y < 0.0f )//toX is smaller than getX. now_y is negative. Going to zero.
				{
					if( now_y <= last_y )//if now_y hasn't moved or is going in the wrong way then we add giveup_count_y.
					{
						giveup_count_y++;
					}
				}
				
				if( giveup_count_y >= 25 )//Try for 25 times before giving up.
				{
					yDone = true;
					debug(AnimatorTemp) Trace.formatln("y anim giveup.");
				}
				
				if( now_y < 0.001f && now_y > -0.001f )
				{
					debug(AnimatorTemp) Trace.formatln("yDone.");
					yDone = true;
					setY( toY );
				}
				else
				{
					setY( getY() + (timevalue * now_y) );
				}
				
				last_y = now_y;
			}
			
			if( zDone == false && setZ !is null && getZ !is null )
			{
				float now_z = toZ - getZ();
				
				if( now_z > 0.0f )//toX is bigger than getX. now_z is positive. Going to zero.
				{
					if( now_z >= last_z )//if now_z hasn't moved or is going in the wrong way then we add giveup_count_z.
					{
						giveup_count_z++;
					}
				}
				else if( now_z < 0.0f )//toX is smaller than getX. now_z is negative. Going to zero.
				{
					if( now_z <= last_z )//if now_z hasn't moved or is going in the wrong way then we add giveup_count_z.
					{
						giveup_count_z++;
					}
				}
				
				if( giveup_count_z >= 25 )//Try for 25 times before giving up.
				{
					zDone = true;
					debug(AnimatorTemp) Trace.formatln("z anim giveup.");
				}
				
				if( now_z < 0.001f && now_z > -0.001f )
				{
					zDone = true;
					setZ( toZ );
				}
				else
				{
					setZ( getZ() + (timevalue * now_z) );
				}
				
				last_z = now_z;
			}
			
			if( xDone == true && yDone == true && zDone == true )
			{
				debug(AnimatorTemp) Trace.formatln("All Done.");
				
				if( whenFinished !is null )
					whenFinished();
				
				/*if( owner !is null )
				{
					owner.remove( this );
				}*/
				return false;
			}
		}
		
		return true;//continue idle.
	}

	/*
	this(ICanvasItem set_anim_object)
	{
		ob = set_anim_object;
		target = set_anim_object.dup;//new Rectangle(ob);
		
		bezX = new BezierG1();
		bezier.addPoint( 0.0f, 0.0f );
		bezier.addPoint( 0.1f, 0.1f );
	}
	
	~this()
	{
		//We don't delete ob as it's not Animators concern.
		if( target !is null )
			delete target;
	}
	
	bool animate()
	{
		if( ob.x == target.x )
			return false;//stop idle.
		else if( ob.x < target.x )
			ob.x = ob.x + 0.001;
		else if( ob.x > target.x )
			ob.x = ob.x - 0.001;
		
		//Trace.formatln("ob.x: {}", ob.x);
		//Trace.formatln("target.x: {}", target.x);
		
		return true;//continue idle.
	}
	
	Idle idle;
	
	float speed = 1.0;
	//AnimType ... BSPLINE, etc..
	
	public float x() { return ob.x; }
	public float x( float set )
	{
		target.x = set;
		idle = new Idle( 40, &animate, true );
		return ob.x;
	}
	
	BezierG1 bezX;
	
	ICanvasItem ob;
	//At the moment it is guaranteed that
	//target is a Rectangle. It can't be any
	//other type, until those types all have
	//a .dup() method.
	ICanvasItem target;
	*/
}



version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    }
}
