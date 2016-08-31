//============================================================================
// VectorT.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III (OLM Digital, Inc.)
 * Created: 29 Aug 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 *      Based originally on OpenMesh (C++) http://www.openmesh.org
 *      Copyright (C) 2001-2003 by Computer Graphics Group, RWTH Aachen
 * License: LGPL 2.1
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
//============================================================================

module auxd.linalg.VectorT;
version(Tango) import std.compat;

import std.io;

//=============================================================================
//
//  CLASS VectorT
//
//=============================================================================


//== INCLUDES =================================================================


//import auxd.OpenMesh.Core.System.config;
import std.math;
static import std.string;
import conv = std.conv;
import std.metastrings;

// ----------------------------------------------------------------------------

// Create a string that unrolls the given expression N times replacing the
// idx char ('i' by default) with the loop number in the expression each time
string unroll(int N,int i=0)(string expr, char idx='i') {
    static if(i<N) {
        char[] subs_expr;
        foreach (c; expr) {
            if (c==idx) { 
                subs_expr ~= ToString!(i); 
            } else {
                subs_expr ~= c;
            }
        }
        return subs_expr ~ "\n" ~ unroll!(N,i+1)(expr,idx);
    }else{
    return "";}
}

private string _gen_zero_vector(int N)(string storage_class, string name) {
    string ret = storage_class ~" VectorT "~name~" = {[cast(T)";
    for(int col=0; col<N; ++col) {
        ret ~= "0,";
    }
    return ret[0..$-1] ~ "]};";
}



private string _gen_member_aliases(int N)(string letters) {
    // This takes a string of letters like "xyz" and makes them aliases
    // for the N components using an anonymous struct.
    string ret = "struct{";
    foreach(c; letters) {
        ret ~= "Scalar " ~ c ~ ";";
    }
    ret ~= "}";
    return ret;
}



int compare(S,T)(S a, T b) {
    if (a==b) return 0;
    return (a<b)? -1 : 1;
} 

//== CLASS DEFINITION =========================================================


/** The N values of the template Scalar type are the only data members
    of the class VectorT<Scalar,N>. This guarantees 100% compatibility
    with arrays of type Scalar and size N, allowing us to define the
    cast operators to and from arrays and array pointers.

    In addition, this class will be specialized for Vec4f to be 16 bit
    aligned, so that aligned SSE instructions can be used on these
    vectors.
*/
struct VectorT(T, int N)
{
    alias T Scalar;

private:
    alias unroll!(N) unroll_;
public:

  //---------------------------------------------------------------- class info

    union {
        Scalar[N] values_ /*= void*/;
        static if(N<=4) {
            struct {
                static if(N>=1) {Scalar x; }
                static if(N>=2) {Scalar y; }
                static if(N>=3) {Scalar z; }
                static if(N>=4) {Scalar w; }
            }
        }
    }


    /// the type of the scalar used in this template
    alias Scalar value_type;

    /// type of this vector
    alias VectorT!(Scalar,N)  vector_type;

    /// returns dimension of the vector
    static size_t size() { return N; }

    static const size_t size_ = N;
    static const size_t length = N;

    static if(is(typeof(Scalar.nan))) {
        static const bool is_float = true;
    }        
    else {
        static const bool is_float = false;
    }

    //-------------------------------------------------------------- constructors
    /// Compile-time static vectors with all elements set to 0.
    // static VectorT zero = {0,0,0...}
    // static const VectorT zero = {0,0,0...}
    mixin(_gen_zero_vector!(N)("static", "zero"));
    mixin(_gen_zero_vector!(N)("static const", "czero"));

    /// default constructor creates uninitialized values.
    static VectorT opCall() {
        VectorT M; with(M) {
        } return M;
    }

    /// special constructor  -- broadcasts the value to all elements
    static VectorT opCall(/*const*/ Scalar v) {
        VectorT M; with(M) {
            //     assert(N==1);
            //     values_[0] = v0;
            vectorize(v);
        } return M;
    }

    static if(N==2) {
    /// special constructor for 2D vectors
    static VectorT opCall(/*const*/ Scalar v0, /*const*/ Scalar v1) {
        assert(N==2);
        VectorT M; with(M) {
            values_[0] = v0; values_[1] = v1;
        } return M;
    }
    }

    static if(N==3) {
    /// special constructor for 3D vectors
    static VectorT opCall(/*const*/ Scalar v0, /*const*/ Scalar v1, 
                          /*const*/ Scalar v2) 
    {
        assert(N==3);
        VectorT M; with(M) {
            values_[0]=v0; values_[1]=v1; values_[2]=v2;
        } return M;
    }
    }

    static if (N==4) {
    /// special constructor for 4D vectors
    static VectorT opCall(/*const*/ Scalar v0, /*const*/ Scalar v1,
                          /*const*/ Scalar v2, /*const*/ Scalar v3) 
    {
        assert(N==4);
        VectorT M; with(M) {
            values_[0]=v0; values_[1]=v1; values_[2]=v2; values_[3]=v3;
        } return M;
    }
    }

    static if (N==5) {
    /// special constructor for 5D vectors
    static VectorT opCall(/*const*/ Scalar v0, /*const*/ Scalar v1,
                          /*const*/ Scalar v2, /*const*/ Scalar v3,
                          /*const*/ Scalar v4) 
    {
        assert(N==5);
        VectorT M; with(M) {
            values_[0]=v0; values_[1]=v1;
            values_[2]=v2; values_[3]=v3; values_[4]=v4;
        } return M;
    } 
    }

    static if (N==6) {
    /// special constructor for 6D vectors
    static VectorT opCall(/*const*/ Scalar v0, /*const*/ Scalar v1, /*const*/ Scalar v2,
                          /*const*/ Scalar v3, /*const*/ Scalar v4, /*const*/ Scalar v5) 
    {
        assert(N==6);
        VectorT M; with(M) {
            values_[0]=v0; values_[1]=v1; values_[2]=v2;
            values_[3]=v3; values_[4]=v4; values_[5]=v5;
        } return M;
    }
    }

/+
    /// construct from a value array
    // This doesn't coexist nicely with the dynamic Scalar[] version below
    // which is a shame because this version is compile-time checked but 
    // doesn't work with dynamic arrays, while the dynamic version works with
    // all arrays, but has to do runtime checking.
    static VectorT opCall(/*const*/ Scalar[N] _values) {
        assert( _values.length == N );
        VectorT M; with(M) {
            values_[] = _values;
        } return M;
    }
+/
    /// construct from a dynamic value array
    static VectorT opCall(/*const*/ Scalar[] _values) {
        assert( _values.length == N );
        VectorT M;
        M.values_[] = _values;
        return M;
    }

    /// copy & cast constructor (explicit)
    /+
     // Currently conflicts with non-template version, but 
     // not needed since plain value copy and opAssign handle these cases ok.
    static VectorT opCall(otherScalarType)(/*const*/ ref VectorT!(otherScalarType,N) _rhs) {
        VectorT M; M = _rhs;
        return M;
    }
    +/



    //--------------------------------------------------------------------- casts

    /// cast from vector with a different scalar type
    //void opAssign(otherScalarType)(/*const*/ ref VectorT!(otherScalarType,N) _rhs) {
    void opAssign(VecType)(/*const*/ VecType _rhs) {
        static if(!is(typeof(_rhs.length))) { 
            pragma(msg,__FILE__~"(): Warning: in VectorT.opAssign assigned type, "
                   ~VecType.stringof~", has no .length property.");
        }
        else { assert(_rhs.length == N, "VectorT.opAssign: rhs is of wrong length"); }
        const string expr = "values_[i] = cast(Scalar)_rhs[i];";
        mixin( unroll_(expr) );
        //return *this
    }

    /// cast to Scalar array
    Scalar* ptr() { return values_.ptr; }

    /// cast to const Scalar array
    // /*const*/ Scalar* ptr() /*const*/ { return values_.ptr; }




    //----------------------------------------------------------- element access

    /// get i'th element read-only
    Scalar opIndex(size_t _i) {
        assert(_i<N,"v["~std.string.toString(_i)~"]: index out of range"); return values_[_i];
    }
    /// get i'th element write-only
    void opIndexAssign(Scalar v, size_t _i) {
        assert(_i<N); values_[_i] = v;
    }
    int opApply(int delegate(ref Scalar) loop) {
        foreach(ref x; values_) {
            int ret = loop(x);
            if (ret) return ret;
        }
        return 0;
    }
    int opApply(int delegate(ref size_t, ref Scalar) loop) {
        foreach(i, ref x; values_) {
            int ret = loop(i,x);
            if (ret) return ret;
        }
        return 0;
    }
    int opApplyReverse(int delegate(ref Scalar) loop) {
        foreach_reverse(ref x; values_) {
            int ret = loop(x);
            if (ret) return ret;
        }
        return 0;
    }
    int opApplyReverse(int delegate(ref size_t, ref Scalar) loop) {
        foreach_reverse(i, ref x; values_) {
            int ret = loop(i,x);
            if (ret) return ret;
        }
        return 0;
    }


    //---------------------------------------------------------------- comparsion
    /// component-wise comparison
    int opEquals(/*const*/ ref vector_type _rhs) /*const*/ {
        const string expr = "if(values_[z]!=_rhs.values_[z]) return 0;";
        mixin( unroll_(expr,'z') );
        return 1;
    }

    //---------------------------------------------------------- scalar operators

    /// component-wise self-multiplication with scalar
    void opMulAssign(/*const*/ Scalar _s) {
        const string expr = "values_[i] *= _s;";
        mixin( unroll_(expr) );
        //return *this;
    }

    /** component-wise self-division by scalar
        \attention v *= (1/_s) is much faster than this  */
    void opDivAssign(/*const*/ Scalar _s) {
        static if(is(typeof(Scalar.nan))) { // it's an fp type
            Scalar recp = (cast(Scalar)1) / _s; 
            const string expr = "values_[i] *= recp;";
        } else {
            const string expr = "values_[i] /= _s;";
        }
        //pragma(msg,unroll_(expr,'i'));
        mixin( unroll_(expr) );
        //return *this;
    }

    /// component-wise multiplication with scalar
    vector_type opMul(/*const*/ Scalar _s) /*const*/ {
        version(all) {
            auto M = *this;
            M *= _s;
            return M;
        } else {
            //const string expr = "values_[i] * _s;";
            //pragma(msg,unroll_(expr,'i'));
            //return vector_type(unroll_csv(expr));
        }
    }
    /// component-wise division by with scalar
    vector_type opDiv(/*const*/ Scalar _s) /*const*/ {
        version(all) {
            auto M = *this;
            M /= _s;
            return M;
        } else {
            //const string expr = "values_[i] / _s;"
            //return vector_type(unroll_csv(expr));
        }
    }


    //---------------------------------------------------------- vector operators

    /// component-wise self-multiplication
    void opMulAssign(/*const*/ ref vector_type _rhs) {
        const string expr = "values_[i] *= _rhs[i];";
        //pragma(msg,unroll_(expr,'i'));
        mixin( unroll_(expr) );
        //return *this;
    }

    /// component-wise self-division
    void opDivAssign(/*const*/ ref vector_type _rhs) {
        const string expr = "values_[i] /= _rhs[i];";
        //pragma(msg,unroll_(expr,'i'));
        mixin( unroll_(expr) );
        //return *this;
    }


    /// vector difference from this
    void opSubAssign(/*const*/ ref vector_type _rhs) {
        const string expr = "values_[i] -= _rhs[i];";
        //pragma(msg,unroll_(expr,'i'));
        mixin( unroll_(expr) );
        //return *this;
    }

    /// vector self-addition
    void opAddAssign(/*const*/ ref vector_type _rhs) {
        const string expr = "values_[i] += _rhs[i];";
        //pragma(msg,unroll_(expr,'i'));
        mixin( unroll_(expr) );
        //return *this;
    }


    /// component-wise vector multiplication
    vector_type opMul(/*const*/ ref vector_type _v) /*const*/ {
        auto M = *this; 
        M *= _v; 
        return M;
    }

    /// component-wise vector division
    vector_type opDiv(/*const*/ ref vector_type _v) /*const*/ {
        auto M = *this; 
        M /= _v; 
        return M;
    }      


    /// component-wise vector addition
    vector_type opAdd(/*const*/ ref vector_type _v) /*const*/ {
        auto M = *this; 
        M += _v; 
        return M;
    }

    /// component-wise vector difference
    vector_type opSub(/*const*/ ref vector_type _v) /*const*/ {
        auto M = *this; 
        M -= _v; 
        return M;
    }

    /// unary minus
    vector_type opNeg() /*const*/ {
        vector_type v = void;
        const string expr = "v.values_[i] = -values_[i];";
        //pragma(msg,unroll_(expr,'i'));
        mixin( unroll_(expr) );
        return v;
    }

    static if(N==3) {
        /// cross product: only defined for Vec3* as specialization
        /// See_Also: auxd.OpenMesh.cross
        VectorT cross(/*const*/ ref VectorT _rhs) /*const*/
        {
            VectorT M;
            M.values_[0] = values_[1]*_rhs.values_[2]-values_[2]*_rhs.values_[1];
            M.values_[1] = values_[2]*_rhs.values_[0]-values_[0]*_rhs.values_[2];
            M.values_[2] = values_[0]*_rhs.values_[1]-values_[1]*_rhs.values_[0];
            return M;
        }
    }

    static if(N==2) {
        /// cross product: only defined for Vec2* as specialization
        /// See_Also: auxd.OpenMesh.cross
        Scalar cross(/*const*/ ref VectorT _rhs) /*const*/
        {
            return (values_[0]*_rhs.values_[1]-values_[1]*_rhs.values_[0]);
        }
    }

    /// compute scalar product
    /// See_Also: auxd.OpenMesh.dot
    Scalar dot(/*const*/ ref vector_type _rhs) /*const*/ {
        Scalar p = 0;
        const string expr = "p += values_[i] * _rhs.values_[i];";
        //pragma(msg,unroll_(expr,'i'));
        mixin( unroll_(expr) );
        return p;
    }



    //------------------------------------------------------------ euclidean norm

    static if (vector_type.is_float) {
        /// Compute Euclidean (L2) norm
        Scalar norm() /*const*/ { 
            return cast(Scalar)sqrt(sqrnorm());
        }

        /// Compute squared Euclidean (L2) norm
        Scalar sqrnorm() /*const*/ 
        {
            Scalar s = 0;
            const string expr = "s += values_[i] * values_[i];";
            mixin( unroll_(expr) );
            return s;
        }

        /// Return the one-norm of the vector (sum of elements' absolute values)
        Scalar onenorm() {
            Scalar ret=0;
            foreach(v; values_) ret += abs(v);
            return ret;
        }

        /// Return the infinity-norm of the vector (max element absolute value)
        Scalar infnorm() {
            Scalar ret= -Scalar.max;
            foreach(v; values_) {
                v = abs(v);
                if (v>ret) ret = v;
            }
            return ret;
        }


        /** normalize vector in place, return original length
         */
        Scalar normalize() 
        {
            Scalar len = this.norm();
            *this /= len;
            return len;
        }
  
        /** Return normalized copy of vector
         */
        VectorT normalized()  /*const*/
        {
            return *this / this.norm();
        }
  
        /** normalize vector avoiding div by zero 
         *  returns original length.
         */
        Scalar normalize_cond()
        {
            Scalar n = norm();
            if (n != cast(Scalar)0.0)
            {
                *this /= n;
            }
            return n;
        }
        /** Return normalized copy of vector avoiding div by zero 
         *  returns original new vector.
         */
        VectorT normalized_cond() /*const*/
        {
            Scalar n = norm();
            if (n != cast(Scalar)0.0)
            {
                return *this / n;
            }
            return *this;
        }
    }

    //------------------------------------------------------------ max, min, mean

    /// return the maximal component
    Scalar max() /*const*/ 
    {
        Scalar m = values_[0];
        const string expr = "if(values_[z]>m) m=values_[z];";
        mixin( unroll!(N,1)(expr,'z') );
        return m;
    }

    /// return the minimal component
    Scalar min() /*const*/ 
    {
        Scalar m = values_[0];
        const string expr = "if(values_[z]<m) m=values_[z];";
        mixin( unroll!(N,1)(expr,'z') );
        return m;
    }

    static if (vector_type.is_float) {
        /// return arithmetic mean
        Scalar mean() /*const*/ 
        {
            Scalar m = values_[0];
            const string expr = "m+=values_[i];";
            mixin( unroll!(N,1)(expr) );
            return m/cast(Scalar)(N);
        }
    }

    /// minimize values: same as *this = min(*this, _rhs), but faster
    vector_type minimize(/*const*/ ref vector_type _rhs) {
        const string expr = "if (_rhs[z] < values_[z]) values_[z] = _rhs[z];";
        mixin( unroll_(expr,'z') );
        return *this;
    }

    /// maximize values: same as *this = max(*this, _rhs), but faster
    vector_type maximize(/*const*/ ref vector_type _rhs) {
        const string expr = "if (_rhs[z] > values_[z]) values_[z] = _rhs[z];";
        mixin( unroll_(expr,'z') );
        return *this;
    }

    /// component-wise min
    vector_type min(/*const*/ ref vector_type _rhs) {
        auto M = *this;
        M.minimize(_rhs);
        return M;
    }

    /// component-wise max
    vector_type max(/*const*/ ref vector_type _rhs) {
        auto M = *this;
        M.maximize(_rhs);
        return M;
    }




    //------------------------------------------------------------ misc functions

    /// component-wise apply function object with Scalar opCall(Scalar).
    vector_type apply(Functor)(/*const*/ Functor _func) /*const*/ {
        vector_type result;
        const string expr = "result[i] = _func(values_[i]);";
        mixin( unroll_(expr) );
        return result;
    }

    /// store the same value in each component (e.g. to clear all entries)
    void vectorize(/*const*/ Scalar _s) {
        const string expr = "values_[i] = _s;";
        mixin( unroll_(expr) );
        //return *this;
    }


    /// store the same value in each component
    static vector_type vectorized(/*const*/ Scalar _s) {
        auto ret = vector_type(); 
        ret.vectorize(_s);
        return ret;
    }


    /// lexicographical comparison
    int opCmp(/*const*/ vector_type _rhs) /*const*/ {
        const string expr =
            "cmp=compare(values_[z],_rhs.values_[z]);\n"
            "if (cmp!=0) return cmp;\n";
        int cmp;
        mixin (unroll_(expr,'z'));
        return false;
    }


    string toString() {
        char[] ret = "[";
        for(int i=0; i<N; i++) {
            ret ~= std.string.format(values_[i]);
            ret ~= i!=N-1 ? ", " : "]"; 
        }
        return ret;
    }

}


/+
/// read the space-separated components of a vector from a stream
template!(Scalar, int N)
std.ref istream
operator>>(ref istream is, VectorT<Scalar,N>& vec)
{
const string expr = ""is >> vec[i];
  unroll(expr);
  return is;
}


/// output a vector by printing its space-separated compontens
template!(Scalar, int N)
std.ref ostream
operator<<(ref ostream os, /*const*/ VectorT<Scalar,N>& vec)
{
#if N==N
  for(int i=0; i<N-1; ++i) os << vec[i] << " ";
  os << vec[N-1];
#else
const string expr = ""vec[i]
  os << unroll_comb(expr, << " " <<);
#endif

  return os;
}
+/


//== GLOBAL FUNCTIONS =========================================================

/+
/// \relates auxd.OpenMesh.VectorT
/// scalar * vector
template< Scalar,int N>
inline VectorT<Scalar,N> operator*(Scalar _s, const VectorT<Scalar,N>& _v) {
  return VectorT<Scalar,N>(_v) *= _s;
}

+/

/// \relates auxd.OpenMesh.VectorT
/// symmetric version of the dot product
Scalar 
dot(Scalar, int N)(/*const*/ ref VectorT!(Scalar,N) _v1, 
                   /*const*/ ref VectorT!(Scalar,N) _v2) 
{
    return (_v1.dot(_v2)); 
}


/// \relates auxd.OpenMesh.VectorT
/// symmetric version of the cross product
template cross( Scalar, int N)
{
    // This monstrosity is required to make D allow the
    // 2d and 3d versions of the template to coexist peacefully.
    // (should be 
    //   alias typeof(VectorT!(Scalar,N)().cross(VectorT!(Scalar,N)())) RetT;
    // but that kills implicit instatiation.
    // Or should be two separate templates, but then DMD says they're ambiguous.
    typeof(VectorT!(Scalar,N)().cross(VectorT!(Scalar,N)()))
    
    cross(/*const*/ ref VectorT!(Scalar,N) _v1, 
          /*const*/ ref VectorT!(Scalar,N) _v2) 
    {
        return (_v1.cross(_v2));
    }
}

/// \relates auxd.OpenMesh.VectorT
/// Linear interpolation between _v1 and _v2.
VectorT!(Scalar,N) 
lerp( Scalar, int N)(Scalar t,
                     /*const*/ ref VectorT!(Scalar,N) _v1, 
                     /*const*/ ref VectorT!(Scalar,N) _v2) 
{
    VectorT!(Scalar,N) v = _v1;
    Scalar s = 1.0-t;
    const string expr = "v.values_[i] *= s; v.values_[i] += t*_v2.values_[i];";
    //pragma(msg,unroll_(expr,'i'));
    mixin( unroll!(N)(expr) );
    return v;
}


//== ALIASES =================================================================

// Just the most common aliases.  The rest are in auxd.OpenMesh.Core.Geometry.VectorTypes

/** 2-ubyte vector */
alias VectorT!(ubyte,2) Vec2ub;
/** 2-float vector */
alias VectorT!(float,2) Vec2f;
/** 2-double vector */
alias VectorT!(double,2) Vec2d;
/** 3-ubyte vector */
alias VectorT!(ubyte,3) Vec3ub;
/** 3-float vector */
alias VectorT!(float,3) Vec3f;
/** 3-double vector */
alias VectorT!(double,3) Vec3d;
/** 4-ubyte vector */
alias VectorT!(ubyte,4) Vec4ub;
/** 4-float vector */
alias VectorT!(float,4) Vec4f;
/** 4-double vector */
alias VectorT!(double,4) Vec4d;

/*
template Vector2(T) { alias VectorT!(T,2) Vector2; }
template Vector3(T) { alias VectorT!(T,3) Vector3; }
template Vector4(T) { alias VectorT!(T,4) Vector4; }
template Vector5(T) { alias VectorT!(T,5) Vector5; }
template Vector6(T) { alias VectorT!(T,6) Vector6; }
template Vector7(T) { alias VectorT!(T,7) Vector7; }
template Vector8(T) { alias VectorT!(T,8) Vector8; }
*/


//== TESTS =================================================================
unittest {
/*
    alias VectorT!(float,3) Vec3f;
    alias VectorT!(float,2) Vec2f;
    alias VectorT!(int,2) Vec2i;
    alias VectorT!(int,3) Vec3i;
    alias VectorT!(ubyte,10) Vec10ub;

    alias std.io.writefln writefln;

    Vec3f a;
    Vec3f b=  {8,9,10};
    double[] dyn = [7.0,6.0,3.0];
    VectorT!(double,3) af = dyn;
    VectorT!(int,3) ai;
    ai = [1,2,3];
    a = [1,2,3];
    
    writefln("A=", a);
    writefln("Alen=", a.norm);
    writefln("ai=", ai);
    writefln("B=", b);

    a = af;
*/
}


//--- Emacs setup ---
// Local Variables:
// c-basic-offset: 4
// indent-tabs-mode: nil
// End:

