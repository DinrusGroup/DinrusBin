//============================================================================
// arcball.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 * Arcball controller for OpenGL in the D Programming Language
 *
 * Based on code by Alessandro Falappa published to CodePage Oct 1999.
 *    http://www.codeproject.com/opengl/virtualtrackball.asp?print=true
 * That was in turn based on code by Ken Shoemake and J. Childs.
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 04 Sep 2007
 * Copyright: (C) 2007-2008 William Baxter, OLM Digital, Inc.
 */
//============================================================================

module arcball;

import auxd.helix.linalgebra;
import auxd.helix.color;
//version (useDerelict) {
  import derelict.opengl.gl;
  import derelict.opengl.glu;
  private alias GLUquadric GLUquadric_t;
//} else {
//  import gl;
//  import glu;
//  private alias GLUquadricObj GLUquatric_t;
//}
import math=std.math;
import std.io;

/**
   Defines some constant values used to set the axes to which
   constrain rotations about.
*/
enum AxisSet
{
	NO_AXES,
	CAMERA_AXES,
	BODY_AXES,
	OTHER_AXES,
}

private float clamped(float x, float xmin, float xmax)
{
    if (x<xmin) return xmin;
    return x>xmax ? xmax : x;
}
private void clamp(inout float x, float xmin, float xmax)
{
    if(x<xmin) x = xmin;
    if(x>xmax) x = xmax;
}
private float degToRad(float x) {
    return x*0.017453292519943295769236907684886;
}



class ArcBallController
{
private:
	bool m_bDrawConstraints = true;
	bool m_bAltProjectionMethod = false;
	bool m_bDrawBallArea = false;
	bool m_mouseButtonDown = false;
	int m_GLdisplayList = 0;
	Matrix44f m_bodyorientation;
	Color3f m_ballColor;
	Quaternionf m_currentQuat;
	Quaternionf m_previousQuat;
	float m_radius    = 0.6;
	float m_winWidth  = 0;
	float m_winHeight = 0;
	float m_xprev     = 0;
	float m_yprev     = 0;
	//Vector2f center;
	AxisSet m_whichConstraints = AxisSet.NO_AXES;
	int m_currentAxisIndex  = 0;
	Vector3f[3] m_cameraAxes;
	Vector3f[3] m_bodyAxes;
	Vector3f[] m_otherAxes;

  public:
    this()
    {
        initVars();
    }

    this(float rad)
    {
        initVars();
        m_radius = clamped(rad,0.1,1);
    }

    this(float rad, Quaternionf initialOrient)
    {
        initVars();
        m_radius = clamped(rad,0.1,1);
        m_currentQuat = initialOrient;
    }

    void setRadius(float newRadius)
    {
        m_radius = newRadius;
    }

    float getRadius() { return m_radius; }

    void setColor(Color3f col)
    {
        m_ballColor = col;
    }

    void setColor(Vector3f colv)
    {
        m_ballColor = Color3f(colv.x,colv.y,colv.z);
    }

    Color3f getColor()  { return m_ballColor;  }

    void setAlternateMethod(bool flag)
    {
        m_bAltProjectionMethod = flag;
    }

    void toggleProjectionMethod()
    {
        m_bAltProjectionMethod = !m_bAltProjectionMethod;
    }

    void useConstraints(AxisSet constraints)
    {
        m_whichConstraints = constraints;
    }

    void cycleConstraints()
    {
        uint v = m_whichConstraints;
        v++;
        if (v>AxisSet.max){ v=AxisSet.min; }
        m_whichConstraints = cast(AxisSet)v;
    }

    bool getDrawConstraints()
    {
        return m_bDrawConstraints;
    }

    void setDrawConstraints(bool flag)
    {
        m_bDrawConstraints = flag;
    }


    ArcBallController dup()
    {
        ArcBallController ret  =  new ArcBallController;
        ret.initVars();
        ret.m_currentQuat = m_currentQuat;
        ret.m_previousQuat = m_previousQuat;
        ret.m_radius = m_radius;
        ret.m_winWidth = m_winWidth;
        ret.m_winHeight = m_winHeight;
        ret.m_otherAxes = m_otherAxes.dup;
        ret.m_ballColor = m_ballColor;
        return ret;
    }

    void resizeRegion(int width, int height)
    {
        m_winWidth = width;
        m_winHeight = height;
        glDeleteLists(m_GLdisplayList,1);
        m_GLdisplayList = 0;
    }

    void startDrag(int winx, int winy)
    {
        assert (m_winHeight>0 && m_winWidth>0);
        m_xprev = (2*winx-m_winWidth)/m_winWidth;
        m_yprev = (m_winHeight-2*winy)/m_winHeight;
        m_previousQuat = m_currentQuat;
        m_mouseButtonDown = true;
        m_bDrawBallArea = true; //m_bAltProjectionMethod;// draw circle only if method 2 active
    }


    void endDrag()
    {
        m_mouseButtonDown = false;
        m_bDrawBallArea = false;
        m_xprev = m_yprev = 0.0;
        // save current rotation axes for bodyAxes constraint at next rotation
        m_bodyorientation  =  Matrix44.rotation(m_currentQuat);

        m_bodyAxes[0] = m_bodyorientation[0].xyz;
        m_bodyAxes[1] = m_bodyorientation[1].xyz;
        m_bodyAxes[2] = m_bodyorientation[2].xyz;
    }


    void updateDrag(int winx, int winy)
    {
        assert (m_winHeight>0 && m_winWidth>0);
        float xcurr =  (2*winx - m_winWidth)/m_winWidth;
        float ycurr = -(2*winy - m_winHeight)/m_winHeight;
        Vector3f vfrom = Vector3f(m_xprev,m_yprev,0);
        Vector3f vto = Vector3f(xcurr,ycurr,0);
        if(m_mouseButtonDown)
        {
            // find the two points on sphere according to the projection method
            projectOnSphere(vfrom);
            projectOnSphere(vto);
            // modify the vectors according to the active constraint
            if(m_whichConstraints !=  AxisSet.NO_AXES)
            {
                Vector3f[] axisSet = _getUsedAxisSet();
                vfrom = constrainToAxis(vfrom,axisSet[m_currentAxisIndex]);
                vto = constrainToAxis(vto,axisSet[m_currentAxisIndex]);
            }
            // get the corresponding Quaternionf
            Quaternionf lastQuat = rotationFromMove(vfrom,vto);
            m_currentQuat *= lastQuat;
            m_xprev = xcurr;
            m_yprev = ycurr;
        }
        else if(m_whichConstraints !=  AxisSet.NO_AXES)
		{
			projectOnSphere(vto);
			m_currentAxisIndex = nearestConstraintAxis(vto);
		}
    }

    void cancelDrag() {
        m_currentQuat = m_previousQuat;
        endDrag();
    }
    
    void resetRotation() {
        m_currentQuat = Quaternionf.rotation(Vector3f.unitX, 0);
    }

    void rotX(float rads) { m_currentQuat *= Quaternionf.rotation(Vector3f.unitX, rads);}
    void rotY(float rads) { m_currentQuat *= Quaternionf.rotation(Vector3f.unitY, rads);}
    void rotZ(float rads) { m_currentQuat *= Quaternionf.rotation(Vector3f.unitZ, rads);}
    
    void cycleConstraintAxis() {
        if (m_whichConstraints!=AxisSet.NO_AXES) 
            m_currentAxisIndex = (m_currentAxisIndex+1)%3;
    }

    /*
    // Example keydown procedure
    void keydown(uint nChar)
    {
        switch(nChar)
        {
        case GLD_KEY_UP:
        case GLD_KEY_KP_8:
            rotX(degToRad(m_angleKeyIncrement));
            break;
        case GLD_KEY_DOWN:
        case GLD_KEY_KP_2:
            rotX(degToRad(-m_angleKeyIncrement));
            break;
        case GLD_KEY_RIGHT:
        case GLD_KEY_KP_6:
            rotY(degToRad(m_angleKeyIncrement));
            break;
        case GLD_KEY_LEFT:
        case GLD_KEY_KP_4:
            rotY(degToRad(-m_angleKeyIncrement));
            break;
        case GLD_KEY_PAGEUP:
        case GLD_KEY_KP_9:
            rotZ(degToRad(m_angleKeyIncrement));
            break;
        case GLD_KEY_HOME:
        case GLD_KEY_KP_7:
            rotZ(degToRad(-m_angleKeyIncrement));
            break;
        case GLD_KEY_DEL:
        case GLD_KEY_KP_5:
            resetRotation();
            break;
        case GLD_KEY_ESC:
            cancelDrag();
            break;
        case GLD_KEY_TAB:
            if(m_mouseButtonDown) cycleConstraintAxis();
            break;
        default:
        }
    }
    */

    void multMatrixGL()
    {
        Matrix44f mat = Matrix44f.rotation(m_currentQuat);
        mat.transpose();
        glMultMatrixf( mat.ptr );
    }


    Vector3f constrainToAxis(inout Vector3f loose, inout Vector3f axis)
    {
        Vector3f onPlane = loose-axis*dot(axis,loose);
        float norm  = onPlane.norm;
        if (norm > 0)
        {
            if (onPlane.z < 0.0) onPlane  =  -onPlane;
            return ( onPlane/math.sqrt(norm) );
        }
        if (axis.z == 1) onPlane = Vector3f.unitX;
        else
        {
            onPlane = Vector3f(-axis.y, axis.x, 0);
            onPlane.normalize();
        }
        return (onPlane);
    }

    void drawBall()
    {
        // change the projection matrix to identity (no view transformation )
        glMatrixMode(GL_PROJECTION);
		glPushMatrix();
		glLoadIdentity();
        // reset the transformations
        glMatrixMode(GL_MODELVIEW);
		glPushMatrix();
		glLoadIdentity();
        // prepare the circle display list the first time
        if(m_GLdisplayList == 0) initDisplayLists();
        // disable lighting and depth testing
        glPushAttrib(GL_ENABLE_BIT | GL_DEPTH_TEST);
		glDisable(GL_LIGHTING);
		glDisable(GL_DEPTH_TEST);
        // draw the constraints or the ball limit if appropriate
		if(m_bDrawConstraints && m_whichConstraints!=AxisSet.NO_AXES)
            _drawConstraints();
		else if(m_bDrawBallArea) drawBallLimit();
        glPopAttrib();
        // restore the modelview and projection matrices
		glPopMatrix();
        glMatrixMode(GL_PROJECTION);
		glPopMatrix();
        glMatrixMode(GL_MODELVIEW);
    }

  private:
    void projectOnSphere(inout Vector3f v)
    {
        float rsqr = m_radius * m_radius;
        float dsqr = v.x*v.x+v.y*v.y;
        if(m_bAltProjectionMethod)
        {
            // if inside sphere project to sphere else on plane
            if(dsqr>rsqr)
            {
                float scale = (m_radius-.05)/math.sqrt(dsqr);
                v.x *= scale;
                v.y *= scale;
                v.z = 0;
            }
            else
            {
                v.z = math.sqrt(rsqr-dsqr);
            }
        }
        else
        {
            // if relatively "inside" sphere project to sphere else on hyperbolic sheet
            if(dsqr<(rsqr*0.5))	v.z = math.sqrt(rsqr-dsqr);
            else v.z = rsqr/(2*math.sqrt(dsqr));
        }
    }

    Quaternionf rotationFromMove(inout Vector3f vfrom,inout Vector3f vto)
    {
        if(m_bAltProjectionMethod)
        {
            Quaternionf q;
            q.x = vfrom.z*vto.y-vfrom.y*vto.z;
            q.y = vfrom.x*vto.z-vfrom.z*vto.x;
            q.z = vfrom.y*vto.x-vfrom.x*vto.y;
            q.w = dot(vfrom,vto);
            q.normalize();
            return q;
        }
        else
        {
            // calculate axis of rotation and correct it to avoid "near zero length" rot axis
            Vector3f rotaxis = cross(vto, vfrom);
            if (rotaxis.normSquare < 1e-7) {
                rotaxis = Vector3f.unitX;
            } else {
                rotaxis.normalize();
            }
            // find the amount of rotation
            Vector3f d = vfrom-vto;
            float t = d.norm()/(2.0*m_radius);
            clamp(t,-1.0,1.0);
            float phi = 2.0*math.asin(t);
            Quaternionf qret = Quaternionf.rotation(rotaxis,phi);
            qret.normalize();
            return qret;
        }
    }

    void drawBallLimit()
    {
        // "spherical zone" of controller
		glColor3fv(m_ballColor.ptr);
		glCallList(m_GLdisplayList);
    }

    void initDisplayLists()
    {
        m_GLdisplayList = glGenLists(1);
        if(m_GLdisplayList!=0)
        {
            //version(useDerelict) {
                //} else {
                //}
            GLUquadric_t* qobj = gluNewQuadric();
            gluQuadricDrawStyle(qobj,GLU_LINE);
            gluQuadricNormals(qobj,GLU_NONE);
            glNewList(m_GLdisplayList,GL_COMPILE);
			gluDisk(qobj,m_radius,m_radius,48,1);
            glEndList();
            gluDeleteQuadric(qobj);
        }
    }

    void initVars()
    {
        m_previousQuat = m_currentQuat =  Quaternionf.rotation(Vector3f.unitX,0);
        //center = Vector2f(0,0);
        m_ballColor = Color3f(0.0, 0.5, 1.0);
        //m_whichConstraints = AxisSet.NO_AXES;
        m_cameraAxes[0] = m_bodyAxes[0] = Vector3f.unitX;
        m_cameraAxes[1] = m_bodyAxes[1] = Vector3f.unitY;
        m_cameraAxes[2] = m_bodyAxes[2] = Vector3f.unitZ;
        m_bodyorientation = Matrix44f.identity;
    }

    int nearestConstraintAxis(inout Vector3f loose)
    {
        Vector3f[] axisSet = _getUsedAxisSet();
        Vector3f onPlane;
        float max, dp;
        int i, nearest;
        max = -1; 
        nearest = 0;
        if(m_whichConstraints == AxisSet.OTHER_AXES)
        {
            for (i = 0; i<m_otherAxes.length; i++)
            {
                onPlane = constrainToAxis(loose, axisSet[i]);
                dp = dot(onPlane,loose);
                if (dp>max) max = dp; nearest = i;
            }
        }
        else
        {
            for (i=0; i<3; i++)
            {
                onPlane = constrainToAxis(loose, axisSet[i]);
                dp = dot(onPlane,loose);
                if (dp>max)
                {
                    max = dp;
                    nearest = i;
                }
            }
        }
        return (nearest);
    }

    Vector3f[] _getUsedAxisSet()
    {
        Vector3f[] axes=null;
        switch(m_whichConstraints)
        {
        case AxisSet.CAMERA_AXES: axes = m_cameraAxes;
            break;
        case AxisSet.BODY_AXES: axes = m_bodyAxes;
            break;
        case AxisSet.OTHER_AXES: axes = m_otherAxes;
            break;
        }
        return axes;
    }

    void _drawConstraints()
    {
        glColor3f(0,.75f,0);
        if(m_whichConstraints==AxisSet.CAMERA_AXES)
        {
            glCallList(m_GLdisplayList);
            glBegin(GL_LINES);
			glVertex3f(-m_radius,0,0);
			glVertex3f(m_radius,0,0);
			glVertex3f(0,-m_radius,0);
			glVertex3f(0,m_radius,0);
            glEnd();
        }
        if(m_whichConstraints==AxisSet.BODY_AXES)
        {
            glPushMatrix();
            glMultMatrixf(m_bodyorientation.ptr);
            glCallList(m_GLdisplayList);
            glRotated(90,1.0,0.0,0.0);
            glCallList(m_GLdisplayList);
            glRotated(90,0.0,1.0,0.0);
            glCallList(m_GLdisplayList);

            glPopMatrix();
        }
    }

}



//--- Emacs setup ---
// Local Variables:
// c-basic-offset: 4
// indent-tabs-mode: nil
// End:


version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
