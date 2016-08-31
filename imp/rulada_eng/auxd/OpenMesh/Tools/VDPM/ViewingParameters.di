/*===========================================================================
 * ViewingParameters.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/****************************************************************************
 * <TODO: Module Summary>
 *
 * <TODO: Description>
 *
 * Authors:  William V. Baxter III, OLM Digital, Inc.
 * Date: 12 Oct 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 *      Based on OpenMesh (C++) http://www.openmesh.org
 *      Copyright (C) 2001-2003 by Computer Graphics Group, RWTH Aachen
 * License:
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public License
 *  as published by the Free Software Foundation, version 2.1.
 *                                                                           
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *                                                                           
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free
 *  Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
//===========================================================================

module auxd.OpenMesh.Tools.VDPM.ViewingParameters;

//== INCLUDES =================================================================

import auxd.OpenMesh.Core.Geometry.VectorT;
import auxd.OpenMesh.Core.Geometry.Plane3d;
import auxd.OpenMesh.Core.IO.Streams;
import std.math;

//== CLASS DEFINITION =========================================================

	      
/** <documentation here>
 */
class ViewingParameters
{
private:
    double    modelview_matrix_[16];
    float     fovy_     = 45.0f;
    float     aspect_   = 1.0f;
    float     tolerance_square_ = 0.001f;

    Vec3f   eye_pos_;
    Vec3f   right_dir_;
    Vec3f   up_dir_;
    Vec3f   view_dir_;

    Plane3d           frustum_plane_[4];

public:

    this() {}

    void increase_tolerance()           { tolerance_square_ *= 5.0f; }
    void decrease_tolerance()           { tolerance_square_ /= 5.0f; }  

    float fovy() /*const*/                  { return  fovy_; }
    float aspect() /*const*/                { return  aspect_; }
    float tolerance_square() /*const*/      { return  tolerance_square_; } 
  
    void set_fovy(float _fovy)                            { fovy_ = _fovy; }
    void set_aspect(float _aspect)                        { aspect_ = _aspect; }
    void set_tolerance_square(float _tolerance_square)    { tolerance_square_ = _tolerance_square; }

    Vec3f eye_pos() /*const*/    { return eye_pos_; }
    Vec3f right_dir() /*const*/  { return right_dir_; }
    Vec3f up_dir() /*const*/     { return up_dir_; }
    Vec3f view_dir() /*const*/   { return view_dir_; }
    /// TODO: setters too?

    void frustum_planes( Plane3d _plane[4] )
    {
        for (uint i=0; i<4; ++i)
            _plane[i] = frustum_plane_[i];
    }
   
    void get_modelview_matrix(double[16] _modelview_matrix)  
    {
        for (uint i=0; i<16; ++i)
            _modelview_matrix[i] = modelview_matrix_[i];
    }  

    void set_modelview_matrix(/*const*/ double[16] _modelview_matrix)
    {
        for (uint i=0; i<16; ++i)
            modelview_matrix_[i] = _modelview_matrix[i];   
    }

    void update_viewing_configurations()
    {
        // |a11 a12 a13|-1       |  a33a22-a32a23  -(a33a12-a32a13)   a23a12-a22a13 |
        // |a21 a22 a23| = 1/DET*|-(a33a21-a31a23)   a33a11-a31a13  -(a23a11-a21a13)|
        // |a31 a32 a33|         |  a32a21-a31a22  -(a32a11-a31a12)   a22a11-a21a12 |
        //  DET  =  a11(a33a22-a32a23)-a21(a33a12-a32a13)+a31(a23a12-a22a13)

        float    invdet;
        float    a11, a12, a13, a21, a22, a23, a31, a32, a33;
        Vec3f[3] inv_rot;
        Vec3f    trans;

        a11      = cast(float) modelview_matrix_[0]; 
        a12      = cast(float) modelview_matrix_[4]; 
        a13      = cast(float) modelview_matrix_[8];     
        trans[0] = cast(float) modelview_matrix_[12];

        a21      = cast(float) modelview_matrix_[1];
        a22      = cast(float) modelview_matrix_[5];
        a23      = cast(float) modelview_matrix_[9];
        trans[1] = cast(float) modelview_matrix_[13];
  
        a31      = cast(float) modelview_matrix_[2];
        a32      = cast(float) modelview_matrix_[6];
        a33      = cast(float) modelview_matrix_[10];
        trans[2] = cast(float) modelview_matrix_[14];

        invdet=a11*(a33*a22-a32*a23) - a21*(a33*a12-a32*a13) + a31*(a23*a12-a22*a13);
        invdet= cast(float) 1.0/invdet;

        (inv_rot[0])[0] =  (a33*a22-a32*a23) * invdet;
        (inv_rot[0])[1] = -(a33*a12-a32*a13) * invdet;
        (inv_rot[0])[2] =  (a23*a12-a22*a13) * invdet;
        (inv_rot[1])[0] = -(a33*a21-a31*a23) * invdet;
        (inv_rot[1])[1] =  (a33*a11-a31*a13) * invdet;
        (inv_rot[1])[2] = -(a23*a11-a21*a13) * invdet;
        (inv_rot[2])[0] =  (a32*a21-a31*a22) * invdet;
        (inv_rot[2])[1] = -(a32*a11-a31*a12) * invdet;
        (inv_rot[2])[2] =  (a22*a11-a21*a12) * invdet;

        eye_pos_   = - Vec3f(dot(inv_rot[0], trans), 
                             dot(inv_rot[1], trans), 
                             dot(inv_rot[2], trans));
        right_dir_ =   Vec3f(a11, a12, a13);
        up_dir_    =   Vec3f(a21, a22, a23);
        view_dir_  = - Vec3f(a31, a32, a33);

        Vec3f[4] normal;
        //float	aspect = width() / height();
        float	half_theta = fovy() * 0.5f;
        float	half_phi = atan(aspect() * tan(half_theta));
  
        float sin1 = sin(half_theta);
        float cos1 = cos(half_theta);
        float sin2 = sin(half_phi);
        float cos2 = cos(half_phi);
  
        normal[0] =  cos2 * right_dir_ + sin2 * view_dir_;
        normal[1] = -cos1 * up_dir_    - sin1 * view_dir_;
        normal[2] = -cos2 * right_dir_ + sin2 * view_dir_;
        normal[3] =  cos1 * up_dir_    - sin1 * view_dir_;

        for (int i=0; i<4; i++)
            frustum_plane_[i] = Plane3d(normal[i], eye_pos_);
    }

    void PrintOut() {
        alias modelview_matrix_ M;
        dout.writefln( "  ModelView matrix: ");
        dout.writefln( "    |%8s %8s %8s %8s|", M[0], M[4], M[8], M[12]);
        dout.writefln( "    |%8s %8s %8s %8s|", M[1], M[5], M[9], M[13]);
        dout.writefln( "    |%8s %8s %8s %8s|", M[2], M[6], M[10], M[14]);
        dout.writefln( "    |%8s %8s %8s %8s|", M[3], M[7], M[11], M[15]); 
        dout.writefln( "  Fovy: " , fovy_);
        dout.writefln( "  Aspect: " , aspect_);
        dout.writefln( "  Tolerance^2: " , tolerance_square_);
        dout.writefln( "  Eye Pos: " , eye_pos_ );
        dout.writefln( "  Right dir: " , right_dir_);
        dout.writefln( "  Up dir: " , up_dir_);
        dout.writefln( "  View dir: " , view_dir_);
        dout.flush;
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
