/******************************************************************************* 

	Sprite class allows multiple animations and sound to be linked to 
	these animations. 	

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:      ArcLib team 

	Description:    
		Sprite class allows multiple animations and sound to be linked to 
	these animations. Also handles static collision detection (box + circle), 
	weapon spawn points, pivot points which allow sprite to be rotated from 
	a point other then center, and time based rotation. 

	Examples:      
	---------------------
		Please see sprite unittest in arcunittests. 
	---------------------

*******************************************************************************/

module arc.sprite.sprite;

import 
	std.math,
	std.io; 

private import 	
	arc.types,
	arc.sprite.entity,
	arc.texture,
	arc.draw.image,
	arc.draw.shape,
	arc.draw.color,
	arc.sprite.frame.boxframe,
	arc.sprite.frame.radframe,
	arc.sprite.animation,
	arc.sound,
	arc.math.collision,
	arc.math.routines,
	arc.math.angle,
	arc.time,
	arc.math.point;

// for COLLISION_TYPE
public import 
	arc.sprite.frame.frame;

import 
	derelict.opengl.gl,
	derelict.sdl.sdl,
	derelict.sdl.image;

const int DEFAULT_TIME = -1;
const char[] DEFAULT_ANIM = "default";

/// A graphical object with animation and sound
class Sprite : Entity
{
  public:	
	/// box/radius constructor, load from filename
	this(char[] filename, COLLISION_TYPE argCol)
	{
		// set collision type
		col = argCol;
		addFrame(filename, DEFAULT_ANIM, DEFAULT_TIME, null);
		initialize();
	}

	/// box/radius constructor, load from texture
	this(Texture tex, COLLISION_TYPE argCol)
	{
		// set collision type
		col = argCol;
		addFrame(tex, DEFAULT_ANIM, DEFAULT_TIME, null);
		initialize();
	}

	/// simple box/rad constructor, do not load anything
	this(COLLISION_TYPE argCol)
	{
		col = argCol;
		initialize();
	}

	/// what everything needs to do to initialize itself
	void initialize()
	{
		zoomX = zoomY = 1;
		rotSpeed = new Blinker;
		rotPoint.length = 0;
	}

	/// cleanup
	~this()  
	{
		// delete all animations
		foreach(char[] k; anim.keys)
			anim.remove(k);

		//delete rotSpeed;
		rotPoint.length = 0;
	}

	/// add a frame to the animation
	void addFrame(char[] img, char[] animation, int time, Sound snd)
	{
		// allocate new animation as required
		if (!(animation in anim)) {
			anim[animation] = new Animation;
			anim.rehash;
		}
		// otherwise just add it and set curr animation to it
		currAnim = animation;
			
		// load frame and set size
		Size s = anim[animation].addFrame(img, time, snd, col);

		// set getWidth from one extracted from animation
		setSize(s.w, s.h);
		origW = s.w;
		origH = s.h;

		// calculate radius if necessary
		if (col == COLLISION_TYPE.RADIUS)
			calcRadius();
	}

	/// add a frame to the animation
	void addFrame(Texture tex, char[] animation, int time, Sound snd)
	{
		// allocate new animation as required
		if (!(animation in anim)) {
			anim[animation] = new Animation;
			anim.rehash;
		}
		// otherwise just add it and set curr animation to it
		currAnim = animation;
			
		// load frame and set size
		Size s = anim[animation].addFrame(tex, time, snd, col);

		// set getWidth from one extracted from animation
		setSize(s.w, s.h);
		origW = s.w;
		origH = s.h;

		// calculate radius if necessary
		if (col == COLLISION_TYPE.RADIUS)
			calcRadius();
	}

	/// returns true if point getX, getY collides with sprite
	bool collide(arcfl argX, arcfl argY)
	{
		if (col == COLLISION_TYPE.BOX)
		{
			return boxXYCollision(Point(argX, argY), Point(getLeftX, getTopY), Size(getWidth, getHeight));
		}

		if (col == COLLISION_TYPE.RADIUS)
		{
			return circleXYCollision(Point(argX, argY), Point(getLeftX+getHalfWidth, getTopY+getHalfHeight), radius); 
		}

		arc.log.write("sprite", "collide(x,y)", "error", "no collision type found"); 
	}

	/// collide a sprite with any other sprite
	bool collide(Sprite s)
	{	
		if (col == COLLISION_TYPE.BOX)
		{
			// box-box
			if (s.col == COLLISION_TYPE.BOX)
			{
				return boxBoxCollision(	Point(getLeftX, getTopY), Size(getWidth, getHeight), Point(s.getLeftX, s.getTopY), Size(s.getWidth, s.getHeight));
			}
			// box-rad
			else if (s.col == COLLISION_TYPE.RADIUS)
			{
				return boxCircleCollision(	Point(getLeftX, getTopY), Size(getWidth, getHeight), 
											Point(s.getLeftX+s.getHalfWidth, s.getTopY+s.getHalfHeight),
											s.getRadius);
			}
		}
		else if (col == COLLISION_TYPE.RADIUS)
		{
			// test circle
			if (s.col == COLLISION_TYPE.RADIUS)
			{
				return circleCircleCollision(Point(getLeftX+getHalfWidth, getTopY+getHalfHeight),
											radius,
											Point(s.getLeftX+s.getHalfWidth, s.getTopY+s.getHalfHeight),
											s.getRadius);
			}
			if (s.col == COLLISION_TYPE.BOX)
			{
				return boxCircleCollision(	Point(s.getLeftX, s.getTopY), Size(s.getWidth, s.getHeight), 
											Point(getLeftX+getHalfWidth, getTopY+getHalfHeight),
											radius);
			}
		}

		arc.log.write("sprite", "collide(Sprite)", "error", "collision failed"); 
	}

	/// draw frame 
	void draw()
	{	
		anim[currAnim].draw(getX,getY,getWidth,getHeight,getColor,pivX,pivY,getAngleRad,getLeftX, getTopY,col);
	}

	/// draw the boundry of given type, won't draw anything for 'per-pixel'
	void drawBounds()
	{
		if (col == COLLISION_TYPE.BOX)
			drawRectangle(Point(getLeftX, getTopY), Size(getWidth, getHeight), getColor, false);
		else if (col == COLLISION_TYPE.RADIUS)
		{
			drawCircle(Point(getLeftX+getHalfWidth, getTopY+getHalfHeight), radius, 30, getColor,false);
		}
	}

	/// fast angle setting in radians 
	void setFastAngleRad(Radians argA) {
		angle = argA;
	}

	//TODO: is this a sensible method name? (see setFastAngle above)
	/// rotate frame to specified degree in radians 
	void setAngleRad(Radians argA)
	{
		// rotate exactly to it
		if (rotateBy == 0)
		{
			angle = argA;		
			restrictRad(angle);
		}
		// slowly rotate by setting target getAngle
		else
		{
			targetAngle = argA;		
			restrictRad(targetAngle);
		}
	}
	
	/// get getAngle at which it is rotated at in radians
	Radians getAngleRad() 
	{ 
		return angle; 
	}
    
	/// fast angle setting in degrees 
	void setFastAngleDeg(arcfl argA) {
		angle = degreesToRadians(argA);
	}

	//TODO: is this a sensible method name? (see setFastAngle above)
	/// rotate frame to specified degree in degrees 
	void setAngleDeg(arcfl argA)
	{
        argA = degreesToRadians(argA); 
        
		// rotate exactly to it
		if (rotateBy == 0)
		{
			angle = argA;		
			restrictDeg(angle);
		}
		// slowly rotate by setting target getAngle
		else
		{
			targetAngle = argA;		
			restrictDeg(targetAngle);
		}
	}
	
	/// get getAngle at which it is rotated at in degrees
	Radians getAngleDeg() 
	{ 
		return radiansToDegrees(angle); 
	}

	/// point on which to rotate around
	void setPivot(arcfl argX, arcfl argY)
	{
		pivX = argX; pivY = argY;
	}

	/// set pivot point with point
	void setPivot(Point p)
	{
		pivX = p.x;
		pivY = p.y; 
	}

	/// set X pivot point
	void setPivX(arcfl argX)
	{
		pivX = argX;
	}

	/// set Y pivot point
	void setPivY(arcfl argY)
	{
		pivY = argY;
	}

	/// returns X rotation pivot point
	arcfl getPivX() { return pivX; }
	
	/// returns Y rotation pivot point
	arcfl getPivY() { return pivY; }

	/// get radius
	arcfl getRadius() 
	{ 
		return radius;
	}

	/// set radius
	void setRadius(arcfl argR)
	{
		radius = argR;
	}

	/// return the current frame in the sprite
	Frame getCurrFrame()
	{
		return anim[currAnim].getCurrFrame;
	}

	/// set animation loop/not loop
	void setAnimLoop(char[] animation, bool v)
	{
		anim[animation].setLoop(v);
	}

	/// get zoom X value
	arcfl getZoomX() { return zoomX; }

	/// get zoom Y value
	arcfl getZoomY() { return zoomY; }

	/// set getWidth of sprite
	void setWidth(arcfl argW)
	{
		setSize(argW, getHeight);
	}

	/// set getHeight of sprite
	void setHeight(arcfl argH)
	{
		setSize(getWidth, argH);
	}

	/// set size of sprite
	void setSize(arcfl argW, arcfl argH)
	{	
		super.setSize(argW, argH);

		// calculate zoom amount
		zoomX = argW/origW;
		zoomY = argH/origH; 
		if (col == COLLISION_TYPE.RADIUS)
		{
			calcRadius();
		}
	}

	/// set general zoom
	void setZoom(arcfl argZ)
	{
		setZoom(argZ, argZ);
	}

	/// set zoom X and Y amounts
	void setZoom(arcfl argZX, arcfl argZY)
	{
		zoomX = argZX;
		zoomY = argZY;

		super.setSize(zoomX*origW, zoomY*origH);

		if (col == COLLISION_TYPE.RADIUS)
		{
			calcRadius();
		}
	}

	/// give a certain sound to a frame
	void setSound(Sound snd, char[] animation, int argNum)
	{
		anim[animation].setSound(snd, argNum);
	}

	/// retrieve a certain sound from a frame
	Sound getSound(char[] animation, int argNum)
	{
		return anim[animation].getSound(argNum); 
	}

	/// set frame to display for time amount
	void setTime(int argT, char[] animation, int argNum)
	{
		anim[animation].setTime(argT, argNum);
	}

	/// gives the current time display of frame
	int getTime(char[] animation, int argNum)
	{
		return anim[animation].getTime(argNum);
	}

	/// remove an animation
	void removeAnim(char[] animation)
	{
		anim.remove(animation);
	}

	/// set current animation
	void setAnim(char[] animation)
	{
		currAnim = animation;
	}

	/// reset an animation
	void resetAnim(char[] animation)
	{
		anim[animation].reset();
	}

	/// get current animation
	char[] getAnim()
	{
		return currAnim; 
	}

	/// get current animation frame number
	int getAnimNum()
	{
		return anim[currAnim].getCurr;
	}

	/// move based on getAngle facing, -1 is backwards, 1 is forwards
	void moveDir(arcfl argSpeed)
	{
		setX(getX + sin(-getAngleRad)*-argSpeed);
		setY(getY + cos(-getAngleRad)*-argSpeed);
	}

	/// move based on a velocity vector
	void moveVel(Point vel)
	{
		setX(getX + vel.x);
		setY(getY + vel.y);
	}

	/// get velocity based on angle and speed
	Point getVelocityDir(arcfl argSpeed)
	{
		return Point(sin(-targetAngle)*-argSpeed,
		             cos(-targetAngle)*-argSpeed); 
	}

	/// set look gradient, the number of degrees to rotate as we face a point
	void setRotateBy(Radians argLG)
	{
		rotateBy = argLG;
	}

	/// return the value of the processPosition amount
	arcfl getRotateBy() { return rotateBy; }

	/// set value of the rotation speed
	void setRotateSpeed(arcfl argSpeed)
	{
		speedOfRot = argSpeed;
	}

	/// get value of rotation speed
	arcfl getRotateSpeed() { return speedOfRot; }

	/// have sprite face towards the direction of X,Y
	void pointTo(arcfl argX, arcfl argY)
	{
		/// thank you, phr00t!
		targetAngle = /*degreeToRadian(*/PI - atan2(argX-getX, argY-getY);//);

		// if rotateBy is just zero, then rotate directly there
		// otherwise it will be slowly rotated in 'process()'
		if (rotateBy == 0)
			angle = targetAngle;
	}

	/// have sprite face towards another sprite
	void pointTo(Sprite s)
	{
		pointTo(s.getX, s.getY);
	}
    
    /// point to specific point
    void pointTo(Point argP)
    {
        pointTo(argP.x, argP.y);
    }

	/// just processes pivot points used for collision detection
	void processCollisionPos() 
	{
		calcPivot();
	}

	/// just processes animations
	void processAnimation() 
	{
		anim[currAnim].process();
	}

	/// just process rotation and turning
	void processRotation() 
	{
		rotSpeed.process(speedOfRot);

		// inRange function doesn't work here for some unknown reason
		if (withinRange(angle, targetAngle, rotateBy))
		{
			angle = targetAngle;
		}
		// not in range
		else if (
			rotateBy != 0 
			&& 
			rotSpeed.on 
			&& 
			!(angle == 0 && targetAngle == 2*PI) 
			&& 
			!(targetAngle == 0 && angle == 2*PI)
		   )
		{			
			arcfl a = 2*PI-targetAngle+angle;
			arcfl b = targetAngle-angle;

			if (a > 2*PI)
				a -= 2*PI;

			if (b < 0)  
				b += 2*PI;

			if (a >= b)  
			{
				angle += rotateBy;
				restrictRad(angle);			
			}
			else if (a < b)
			{
				angle -= rotateBy;
				restrictRad(angle);			
			}
		}   
	}

	/// rotate sprite left 
	void rotateLeft()
	{
		setAngleRad(getAngleRad-rotateBy);
	}

	/// rotate sprite right
	void rotateRight()
	{
		setAngleRad(getAngleRad+rotateBy);
	}

	/// process pivots, calculates pivot point and animations
	void process()
	{
		// calculate pivot point
		processCollisionPos();
		
		// animations
		processAnimation(); 
		
		// rotations
		processRotation();

		// rotation points
		processRotationPoint();
	}

	/// add rotation point
	void addRotationPoint(arcfl argX, arcfl argY)
	{
		rotPoint.length = rotPoint.length+1;
		rotPoint[rotPoint.length - 1].init(argX, argY);
	}

	/// get rotation point
	Point getRotationPoint(int argIndex)
	in
	{
		// bounds check 
		assert(argIndex < rotPoint.length && argIndex >= 0);
	}
	body
	{
		// return point
		return Point(rotPoint[argIndex].newPoint.x, rotPoint[argIndex].newPoint.y);
	}

	/// process rotation points
	void processRotationPoint()
	{
		// calculate all rotation points
		for(int i = 0; i < rotPoint.length; i++)
		{
			Point point = rotPoint[i].orig.rotateCopy(Point(pivX, pivY), getAngleRad);
			rotPoint[i].newPoint = point + getPosition; 
		}
	}

	/// get leftmost getX value of sprite
	arcfl getLeftX() { return leftX; }

	/// get topmost getY value of sprite
	arcfl getTopY() { return topY; }

  private:
	// calculate pivot point
	void calcPivot()
	{
		if (pivX != 0 && pivY != 0)
		{
			// calculate rotations based on pivot points
			Point p1;
			Point p2;

			p1 = Point.fromPolar(pivX, getAngleRad);
			p2 = Point.fromPolar(pivY, getAngleRad);
		
			// points with calculated pivot point
			leftX = getX-getHalfWidth-p2.y+p1.x;
			topY = getY-getHalfHeight+p2.x+p1.y;
		}
		else
		{
			// these will put it in the right position
			leftX = getX-getHalfWidth;
			topY = getY-getHalfHeight;
		}
	}

	// calculate radius of sprite
	void calcRadius()
	{
		radius = (getWidth+getHeight)/4;
	}


  private:  
	// animation information
	COLLISION_TYPE col; 
	Animation[char[]] anim;
	char[] currAnim = "default";
	Radians angle = 0;

	// zoom var
	double zoomX = 1, zoomY = 1;

	// special rotational values
	arcfl pivX=0, pivY=0;
	arcfl leftX=0, topY=0; 

	// special vars for radius
	arcfl radius=0;

	// special vars for pixframe
	arcfl origW, origH;

	// number of radians to rotate each time as we point to an object
	Radians rotateBy = 0;
	// target getAngle we are trying to reach
	Radians targetAngle = 0;
	// speed of rotation, time based
	arcfl speedOfRot = .1;
	// rotation timer
	Blinker rotSpeed;

	// rotation points that sprite can keep track of
	RotationPoint[] rotPoint;
}

private
{
	struct RotationPoint
	{
		void init(arcfl argX, arcfl argY) { orig = Point(argX, argY); }
	
		Point orig; 
		Point newPoint; 
	}
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
