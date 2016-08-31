//From http://www.cse.unsw.edu.au/~lambert/splines/source.html
//Most propably written by Tim Lambert

module rae.canvas.Bezier;

import tango.util.log.Trace;//Thread safe console output.

import Math = tango.math.Math;

import rae.canvas.ControlCurve;

unittest
{
	Bezier to_path = new Bezier();
	to_path.addPoint( 0.0f, 0.0f );//p 0
	to_path.addPoint( 30.5f, 0.0f );//1
	to_path.addPoint( 60.0f, 0.0f );//2
	to_path.addPoint( 90.0f, 0.0f );//p 3
	to_path.addPoint( 120.0f, 0.0f );//4
	to_path.addPoint( 150.0f, 0.0f );//5
	to_path.addPoint( 180.0f, 0.0f );//p 6
	to_path.addPoint( 210.0f, 0.0f );//7
	to_path.addPoint( 240.0f, 0.0f );//8
	to_path.addPoint( 270.0f, 0.0f );//p 9
	/*
	to_path.addPoint( 300.0f, 0.0f );//10
	to_path.addPoint( 330.0f, 0.0f );//11
	to_path.addPoint( 360.0f, 0.0f );//p 12
	*/
	
	scope Point poi = to_path.get( 0.0 );
	debug(Bezier) Trace.formatln("poi.x: {}", cast(double)poi.x );
	assert( poi.x == 0.0f );
	
	scope Point poi5 = to_path.get( 0.33333 );
	debug(Bezier) Trace.formatln("poi5.x: {}", cast(double)poi5.x );
	assert( poi5.x > 89.0f && poi5.x < 91.0f);
	
	scope Point poi4 = to_path.get( 0.99 );
	debug(Bezier) Trace.formatln("poi4.x: {}", cast(double)poi4.x );
	assert( poi4.x > 240.0f && poi4.x < 270.0f);
	
	scope Point poi2 = to_path.get( 1.0 );
	debug(Bezier) Trace.formatln("poi2.x: {}", cast(double)poi2.x );
	assert( poi2.x == 270.0f );
	
	scope Point poi3 = to_path.get( 0.5 );
	debug(Bezier) Trace.formatln("poi3.x: {}", cast(double)poi3.x );
	assert( poi3.x > 119.0f && poi3.x < 150.0f);
	
	
	
	to_path.addPoint( 300.0f, 0.0f );//10
	to_path.addPoint( 330.0f, 0.0f );//11
	to_path.addPoint( 360.0f, 0.0f );//p 12
	
	scope Point poi6 = to_path.get( 0.0 );
	debug(Bezier) Trace.formatln("poi6.x: {}", cast(double)poi6.x );
	assert( poi6.x == 0.0f );
	
	scope Point poi7 = to_path.get( 1.0 );
	debug(Bezier) Trace.formatln("poi7.x: {}", cast(double)poi7.x );
	assert( poi7.x == 360.0f );
	
}

public class Bezier : ControlCurve
{

  // the basis function for a Bezier spline
  static float b(int i, float t)
  {
    switch (i)
    {
			case 0:
				return (1-t)*(1-t)*(1-t);
			case 1:
				return 3*t*(1-t)*(1-t);
			case 2:
				return 3*t*t*(1-t);
			case 3:
				return t*t*t;
    }
    return 0; //we only get here if an invalid i is specified
  }
	
	//evaluate a point on the B spline
	Point p(int i, float t)
	{
		float px = 0.0f;
		float py = 0.0f;
		float pz = 0.0f;
		
		//Handle the last point specifically:
		if(i >= pts.npoints-1 )
		{
			return new Point( pts.xpoints[pts.npoints-1], pts.ypoints[pts.npoints-1], 0.0f );
		}
		
		for (int j = 0; j<=3; j++)
		{
			px += b(j,t)*pts.xpoints[i+j];
			py += b(j,t)*pts.ypoints[i+j];
			//pz += b(j,t)*pts.zpoints[i+j]; //2D only ATM.
		}
		//return new Point( Math.round(px), Math.round(py) );
		return new Point( px, py, pz );
	}

	uint anim_i = 0;
	uint anim_step = 0;
	
	//reinit.
	void init()
	{
		anim_i = 0;
		anim_step = 0;
		isLoop = false;
		nextTimeSetIsLoop = false;
	}
	///This tells you if this Bezier has
	///looped to the beginning or not.
	protected bool isLoop(bool set){ return m_isLoop = set;}
	public bool isLoop(){ return m_isLoop; }
	protected bool m_isLoop = false;
	protected bool nextTimeSetIsLoop = false;
	
	/*public uint position()
	{
		return anim_i;
	}
	
	public uint.size()
	{
		return pts.npoints;
	}*/
	
	public Point next()
	{
		if( nextTimeSetIsLoop == true )
			isLoop = true;
	
		Point ret = p( anim_i, anim_step/cast(float)STEPS );
		
		anim_step++;
		
		if( anim_step >= ANIM_STEPS )
		{
			anim_step = 0;
			anim_i+=3;
		}
		
		if( anim_i >= pts.npoints-3 )
		{
			//We've gone through the curve
			//now we set isLoop to true to show others
			//that we're looping. Any better ideas for this API?
			nextTimeSetIsLoop = true;
			//isLoop = true;
			anim_i = 0;
			anim_step = 0;
		}
		
		return ret;
	}

	//Percent 0.0 - 1.0
	public Point get(double percent)
	{
		debug(Bezier) Trace.formatln("Bezier.get(percent) START. {}", percent);
		debug(Bezier) scope(exit) Trace.formatln("Bezier.get(percent) END.");
		//Make legal:
		while( percent < 0.0 ) percent += 1.0;
		while( percent > 1.0 ) percent -= 1.0;
	
		debug(Bezier) Trace.formatln("pts.npoints: {}", pts.npoints );
	
		//the -1.0 comes from the fact that arrays start from 0 not 1.
		double lif = ((pts.npoints-1) * percent);
		debug(Bezier) Trace.formatln("lif1: {}", lif);
		int lii = cast(int)lif;
		debug(Bezier) Trace.formatln("lii1: {}", lii);
		double ljf = lif - lii;
		debug(Bezier) Trace.formatln("ljf1: {}", ljf);
		
		//double j_step = 3.0 / pts.npoints;
		//Trace.formatln("j_step: {}", j_step);
		
		int offsetter = lii % 3;//0 is an actual point.
		//1 and 2 are adjustment points...
		debug(Bezier) Trace.formatln("offsetter: {}", offsetter);
		lii = lii - offsetter;
		debug(Bezier) Trace.formatln("lii2: {}", lii);
		ljf = (ljf + offsetter) / 3.0;
		debug(Bezier) Trace.formatln("ljf2: {}", ljf);
		
		return p( lii, ljf );
	}

	final int ANIM_STEPS = 10;
	
	final int STEPS = 10;

	public void render()
	{
		super.render();
		scope Polygon pol = new Polygon();
		scope Point q = p( 0, 0.0f );
		pol.addPoint( q.x, q.y, q.z );
		for (uint i = 0; i < pts.npoints-3; i+=3)
		{
			for (uint j = 1; j <= STEPS; j++)
			{
				q = p( i,j/cast(float)STEPS );
				pol.addPoint( q.x, q.y, q.z );
			}
		}
		
		pol.renderLine();
		
		//g.drawPolyline(pol.xpoints, pol.ypoints, pol.npoints);
	}


}










/* Bezier spline with G1 continuity between control points */


public class BezierG1 : Bezier
{

	/** Ensure G1 continuity by forcing control points to be collinear.
	If 0 1 2 3 4 5 6 are the the control points, then for the
	Beziers 0123 and 3456 to be G1 continuous at their join, 2, 3
	and 4 must be collinear */
	
	float deltax;
	float deltay;
	//float deltaz; //2D only ATM.

	/* adjust positions of points so that points are collinear */
	void forceCollinear(int i)
	{
		if (i%3 == 0 && i<pts.npoints-1 && i>0)
		{ //interpolating control point
			pts.xpoints[i-1] += deltax;  //adjust neighbours
			pts.ypoints[i-1] += deltay;  // by the same amount 
			//pts.zpoints[i-1] += deltaz;
			pts.xpoints[i+1] += deltax;  // that this one has changed
			pts.ypoints[i+1] += deltay;
			//pts.zpoints[i+1] += deltaz;
		}
		else if (i%3 == 1 && i > 1)
		{
			forceCollinear(i, i-1, i-2);
		}
		else if (i%3 == 2 && i < pts.npoints-2)
		{
			forceCollinear(i, i+1, i+2);
		}
	}

  /* move k such that it is collinear with i and j */
  void forceCollinear(int i, int j, int k)
  {
    //float ij = distance3D(pts.xpoints[i],pts.ypoints[i],pts.zpoints[i],pts.xpoints[j],pts.ypoints[j],pts.zpoints[j]);
    //float jk = distance3D(pts.xpoints[j],pts.ypoints[j],pts.zpoints[j],pts.xpoints[k],pts.ypoints[k],pts.zpoints[k]);
    float ij = distance2D(pts.xpoints[i],pts.ypoints[i],pts.xpoints[j],pts.ypoints[j]);
    float jk = distance2D(pts.xpoints[j],pts.ypoints[j],pts.xpoints[k],pts.ypoints[k]);
    float r = jk/ij;
    //pts.xpoints[k] = Math.round(pts.xpoints[j]+r*(pts.xpoints[j]- pts.xpoints[i]));
    //pts.ypoints[k] = Math.round(pts.ypoints[j]+r*(pts.ypoints[j]- pts.ypoints[i]));
    pts.xpoints[k] = pts.xpoints[j]+r*(pts.xpoints[j]- pts.xpoints[i]);
    pts.ypoints[k] = pts.ypoints[j]+r*(pts.ypoints[j]- pts.ypoints[i]);
  }

	float distance2D( float x1, float y1, float x2, float y2 )
  {
    return cast(float)Math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
  }

  float distance3D(float x1, float y1, float z1, float x2, float y2, float z2)
  {
    return cast(float)Math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)+(z1-z2)*(z1-z2));
  }

  /** add a control point, return index of new control point */
  public int addPoint( float set_x, float set_y, float set_z = 0.0f )
  {
    int i = super.addPoint( set_x, set_y, set_z );
    forceCollinear(i);
    return i;
  }

  /** set selected control point */
  public void setPoint( float set_x, float set_y, float set_z )
  {
    deltax = set_x - pts.xpoints[selection]; //save previous value
    deltay = set_y - pts.ypoints[selection]; //save previous value
    //deltaz = set_z - pts.zpoints[selection]; //save previous value
    super.setPoint( set_x, set_y, set_z );
    forceCollinear(selection);
  }

  /** remove selected control point */
  public void removePoint()
  {
    super.removePoint();
    for (int i = 4; i < pts.npoints; i+=3)
    {
      forceCollinear(i);
    }
  }
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
