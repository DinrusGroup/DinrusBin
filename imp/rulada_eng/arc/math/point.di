/******************************************************************************* 

    A 2d Point Structure 

    Authors:       ArcLib team, see AUTHORS file 
    Maintainer:    Christian Kamm (kamm incasoftware de) 
    License:       zlib/libpng license: $(LICENSE) 
    Copyright:     ArcLib team 
    
    Description:    
    	A 2d Point Structure, holding math pertaining to 2D points. 

	Examples:
	--------------------
	import arc.math.point;

	int main() 
	{
		Point vec = Point(x, y);

		return 0;
	}
	--------------------

*******************************************************************************/

module arc.math.point; 

import 
	std.io, 
	std.math, 
	std.stream; 

import derelict.opengl.gl;

import 
	arc.math.routines,
	arc.math.angle,
	arc.math.size,
	arc.math.matrix,
	arc.math.size, 
	arc.types;


/// 

/**
 * A point structure
 *
 * Generally, methods perform actions in-place if possible.
 * If the method ends in Copy it's a convenience wrapper for 
 * copying the vector and then applying the method.
 *
 * Freely uses inout arguments for speed reasons.
*/
struct Point
{
	static Point NanNan = {arcfl.nan, arcfl.nan};
	
	arcfl x=0;
	arcfl y=0;

	/// Point 'constructor' from carthesian coordinates
	static Point opCall(arcfl Ix, arcfl Iy)
	{
		Point v;
		v.x = Ix;
		v.y = Iy;
		return v;
	}

	/*** unfortunately, making this an opCall makes Point(1,1) ambigious...
	     Point 'constructor' from polar coordinates
	*/
	static Point fromPolar(arcfl length, Radians angle)
	{
		Point v;
		v.x = length * cos(angle);
		v.y = length * sin(angle);
		return v;
	}
	
	/// construct a vector that's rotated by 90 deg ccw
	static Point makePerpTo(inout Point p)
	{
		Point v;
		v.y = p.x;
		v.x = - p.y;
		return v;
	}
	
	/// convenient setter
	void set(arcfl x_, arcfl y_) { x = x_; y = y_; }
	
	/// getter for angle (radians) in polar coordinates
	Radians angle() { return cast(Radians) atan2(y, x); }
	
	/// returns length of vector
	arcfl length() { return cast(arcfl) sqrt(x*x + y*y); }
	
	/// convert point to string value
	char[] toString()
	{
		return "X - " ~ std.string.toString(x) ~ ", Y - " ~ std.string.toString(y);
	}

	/// returns largest component
	arcfl maxComponent()
	{
		if (x > y)
			return x;
		return y;
	}

	/// returns smallest component
	arcfl minComponent()
	{
		if (x < y)
			return x;
		return y;
	}

	// Size operators 
	// add size to point 
	Point opAdd(Size size) 
	{
		return Point(x + size.w, y + size.h); 
	}
	
	// subtract size from point, return point
	Point opSub(Size size) 
	{
		return Point(x - size.w, y - size.h); 
	}
	
	// scalar addition
	Point opAdd(arcfl V) { return Point(x+V, y+V); }
	Point opSub(arcfl V) { return Point(x-V, y-V); }
	Point opAddAssign(arcfl V) { x += V; y += V; return *this; }
	Point opSubAssign(arcfl V) { x -= V; y -= V; return *this; }
	
	// scalar multiplication
	Point opMulAssign(arcfl s) { x *= s; y *= s; return *this; }
	Point opMul(arcfl s) { return Point(x*s, y*s); }
	Point opDivAssign(arcfl s) { x /= s; y /= s; return *this; }
	Point opDiv(arcfl s) { return Point(x/s, y/s); }

	// vector addition
	Point opAddAssign(inout Point Other) { x += Other.x; y += Other.y; return *this; }
	Point opAdd(inout Point V) { return Point(x+V.x, y+V.y); }
	Point opSubAssign(inout Point Other) { x -= Other.x;	y -= Other.y; return *this; }
	Point opSub(inout Point V) { return Point(x-V.x, y-V.y); }

	/// negation
	Point opNeg() { return Point(-x, -y); }

	/// cross product
	arcfl cross(inout Point V) { return (x * V.y) - (y * V.x); }

	/// dot product
	arcfl dot(inout Point V) { return (x*V.x) + (y*V.y); }
	
	/// scaling product
	Point scale(arcfl by) { *this *= by; return *this; }
	Point scale(inout Point by) { x *= by.x; y *= by.y; return *this; }
	
	/// apply matrix from left side without a copy
	Point apply(inout Matrix M)
	{
		arcfl tx = x;
		x = M.col1.x * x + M.col2.x * y;
		y = M.col1.y * tx + M.col2.y * y;
		
		return *this;
	}

	/// return the length squared
	arcfl lengthSquared()
	{
		return x*x + y*y;
	}
	
	/// normalises and returns original length
	arcfl normalise()
	{
		arcfl fLength = length();
		
		if(fLength == 0.0f)
			return 0.0f;
		
		(*this) *= (1.0f / fLength);
	
		return fLength;
	}

	/// return normalised copy of this
	Point normaliseCopy()
	{
		Point p = *this;
		p.normalise();
		return p;
	}

	/// angle to other vector
	Radians angle(inout Point xE)
	{
		arcfl dot = (*this).dot(xE);
		arcfl cross = (*this).cross(xE);
		
		// angle between segments
		return cast(Radians) atan2(cross, dot);
	}

	/// rotates vector by angle
	Point rotate(Radians angleRad)
	{
		arcfl tx = x;
		
		x = x*cos(angleRad) - y*sin(angleRad);
		y = tx*sin(angleRad) + y*cos(angleRad);
		
		return *this;
	}

	/// rotate the vector around a center point
	Point rotate(inout Point center, Radians angleRad)
	{
		Point D = *this - center;
		D.rotate(angleRad);
		*this = center + D;

		return *this;
	}

	/// make components positive
	Point abs()
	{
		x = fabs(x);
		y = fabs(y);
		return *this;
	}
	
	/// abs copy
	Point absCopy()
	{
		Point ret = *this;
		ret.abs();
		return ret;
	}
	
	/// clamp a vector to min and max values
	void clamp(inout Point min, inout Point max)
	{
		x = (x < min.x)? min.x : ((x > max.x)? max.x : x);
		y = (y < min.y)? min.y : ((y > max.y)? max.y : y);
	}

	/// random vector size between given ranges
	void randomise(Point xMin, Point xMax)
	{
		//TODO: this cast(int) looks odd
		x = randomRange(cast(int)xMin.x, cast(int)xMax.x);
		y = randomRange(cast(int)xMin.y, cast(int)xMax.y);
	}

	/// distance to point
	arcfl distance(inout Point another)
	{
		return cast(arcfl) sqrt(pow(another.x-x, 2.0) + pow(another.y-y, 2.0));
	}
	
	/// squared distance to other point
	arcfl distanceSquared(inout Point another)
	{
		return cast(arcfl) pow(another.x-x, 2.0) + pow(another.y-y, 2.0);
	}

	/// point is serializable
	void describe(T)(T s)
	{
		assert(s !is null);
		s.describe(x);
		s.describe(y);
	}

	debug
	{
		/// render the vector as a single point
		void render()
		{
			glColor3f(1.0f, 1.0f, 0.1f);
			glPointSize(3.0f);
			glBegin(GL_POINTS);
			glVertex2f(x, y);
			glEnd();
		}
	}

	deprecated // use cross product
	{
		/// perp product
		arcfl perpProduct(Point V) { return (x*V.y) - (y*V.x); }
	}

	deprecated // use normaliseCopy
	{
		/// direction of the vector, i.e. normalised vector
		Point direction() 
		{
			Point Temp = *this;
	
			Temp.normalise();
	
			return Temp;
		}
	}

	/// rotate 
	Point rotateCopy(Radians angle)
	{
		return Point(x*cos(angle)-y*sin(angle),
						x*sin(angle)+y*cos(angle));
	}
	
	/// rotate around pivot point 
	Point rotateCopy(Point center, Radians angle)
	{
		Point v = Point(x,y) + center;
		v.rotate(angle); 
		return v; 
	}	

	/// get x value
	final arcfl getX() { return x; }
	
	/// get y value
	final arcfl getY() { return y; }

	/// set x
	final void setX(arcfl argW) { x = argW; }

	/// set y
	final void setY(arcfl argH) { y = argH; }

	/// add amount to X
	final void addX(arcfl argV) { x += argV; }

	/// add amount to Y
	final void addY(arcfl argV) { y += argV; }

	deprecated // storing polar coordinates in the x,y members is discouraged
	{
		/// assuming point is given polar coordinates, this will convert to rectangular coordinates
		void polarToRect() 
		{
			y = degreesToRadians(y); // convert degrees to radian
		
			arcfl x_save = x;
		
			x = x_save * cos(y); // i know, polar->y is used too much, but i'd like to eliminate the need
			y = x_save * sin(y); // for too many variables
		}
	}

	/// return true if this point is above the other
	bool above(Point another)
	{
		if (y < another.y)
			return true;

		return false; 
	}
	
	/// return point below another
	bool below(Point another)
	{
		if (y > another.y)
			return true;
		return false; 
	}
	
	/// return point is to the right of another
	bool right(Point another)
	{
		if (x > another.x)
			return true;
		return false; 
	}
	
	/// point is to the left of another 
	bool left(Point another)
	{
		if (x < another.x)
			return true;
		return false; 
	}
}


version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
