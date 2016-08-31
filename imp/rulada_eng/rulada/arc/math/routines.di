/******************************************************************************* 

	Free standing helpful mathematical routines

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

    Description:    
		Free standing helpful mathematical routines, such as distance,
	randomRange, min, max, and area functions. 

	Examples:
	--------------------
	None provided.
	--------------------

*******************************************************************************/

module arc.math.routines; 

import 	
	std.random,
	std.io,
	std.math;  

import 
	arc.math.point,
	arc.math.angle,
	arc.types;

/*******************************************************************************

   See if number is in range of target, rangle is variable, use with caution

*******************************************************************************/
bool withinRange(real argNum, real argTarget, real argRange)
{
	if (argNum <= (argTarget+argRange) && argNum >= (argTarget-argRange))
		return true;

	return false;
}

deprecated /// use mod % operator instead 
{
	/// wrap angle to stay within range of 0-360
	void wrapAngle(inout Radians argAngle)
	{
		while (argAngle > 2*PI)
			argAngle = argAngle-2*PI;

		while (argAngle < 0)
			argAngle = 2*PI+argAngle;
	}
}

/*******************************************************************************

   Calculate the distance between 2 points

*******************************************************************************/
real distance(real x1, real y1, real x2, real y2)
   out(result)
   {
       assert(result >= 0, "arc.math.routines.distance: error - result less than zero"); 
   }
   body
   {
      return sqrt(pow(x2-x1, 2) + pow(y2-y1, 2));
   }

/*******************************************************************************

   Returns the next power of two

*******************************************************************************/
int nextPowerOfTwo(int a)
{
	int rval=1; 
	while(rval<a) rval<<=1;
	return rval; 
}
   
/*******************************************************************************

   Returns a random integer between a and b

*******************************************************************************/
int randomRange(real a, real b)
   in
   {
      assert( a <= b, "a <= b expected" );
   }
   out (result)
   {
      assert (result >= a && result <= b+1); 
   }
   body
   {
      return cast(int)(a + (std.random.rand() % (b+1-a) ));
   }

/// Finds the roots
bool findRoots(arcfl a, arcfl b, arcfl c, inout arcfl t0, inout arcfl t1)
{
	arcfl d = b*b - (4.0f * a * c);

	if (d < 0.0f)
		return false;

	d = cast(arcfl) sqrt(d);

	arcfl one_over_two_a = 1.0f / (2.0f * a);

	t0 = (-b - d) * one_over_two_a;
	t1 = (-b + d) * one_over_two_a;

	if (t1 < t0)
	{
		arcfl t = t0;
		t0 = t1;
		t1 = t;
	}
	return true;
}


/// area of a polygon 
arcfl area(Point[] contour)
{
  int n = contour.length;

  arcfl A=0.0f;

  for(int p=n-1,q=0; q<n; p=q++)
  {
	A+= contour[p].x*contour[q].y - contour[q].x*contour[p].y;
  }

  return A*0.5f;
}

/// Max distance of a given point from a given set of points 
arcfl maxDistance(Point given, Point[] set)
{
	arcfl max = 0; 
	arcfl tmp = 0; 

	foreach(Point p; set)
	{
		// measure distance 
		tmp = given.distance(p); 

		// if greater than current max point, then make this distance the maximum 
		if (tmp > max)
			max = tmp; 
	}

	return max; 
}

/// templated max function 
T max(T)(T a, T b)
{
	return a > b ? a : b;
}

/// templated min function 
T min(T)(T a, T b)
{
	return a < b ? a : b;
}

/// swap arcfl values
void swapf(inout arcfl a, inout arcfl b)
{
	arcfl c = a;
	a = b;
	b = c;
}

/// clamp arcfl value to min and max
arcfl clampf(arcfl x, arcfl min, arcfl max)
{
	return (x < min)? min : (x > max)? max : x;
}

/// wrap arcfl value around min and max
arcfl wrapf(arcfl x, arcfl min, arcfl max)
{
	return (x < min)? (x - min) + max : (x > max)? (x - max) + min : x;
}

/// return sign of a number 
arcfl sign(arcfl x)
{
	return x < 0.0f ? -1.0f : 1.0f;
}

/// clamp number to a certain value 
arcfl clamp(arcfl a, arcfl low, arcfl high)
{
	return max!(arcfl)( low, min!(arcfl)(a, high));
}

/// templated swap function 
void swap(T)(inout T a, inout T b)
{
	T tmp = a;
	a = b;
	b = tmp;
}

/// Random number in range [-1,1]
arcfl random()
{
	arcfl r = cast(arcfl)rand();
	r /= uint.max;
	r = 2.0f * r - 1.0f;
	return r;
}

/// random number with given range between high and low 
arcfl random(arcfl lo, arcfl hi)
{
	arcfl r = cast(arcfl)rand();
	r /= uint.max;
	r = (hi - lo) * r + lo;
	return r;
}


version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
