/*==========================================================================
 * MatrixT.d
 *    Written in the D Programming Language (http://www.digitalmars.com/d)
 */
/***************************************************************************
 * Fixed size matrix class (value type)
 *
 * The number of rows and columns is fixed at compile time.
 * Storage is column major like FORTRAN or OpenGL.
 *
 * Authors:  William V. Baxter III (OLM Digital, Inc.)
 * Date: 23 Nov 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 * License: ZLIB/LIBPNG
 */
//===========================================================================

module auxd.linalg.MatrixT;
version(Tango) import std.compat;

import auxd.linalg.VectorT;

import std.math;
static import std.string;

/// Swap two values
void swap(T)(inout T a, inout T b) { T t = a; a = b; b = t; }

/** 
 *  MatrixT is a generic M x N matrix type.
 *  Dimensions (M rows, N columns) are fixed at compile time.
 *
 *  Matrix elements are stored in column-major order 
 *  like FORTRAN or OpenGL.
 *
 *  Compatible with linalg.VectorT.
 */
struct MatrixT(T, int M, int N)
{
    alias T Scalar;

    union {
        Scalar[M*N] values_ = void;
        static if(M<=10 && N<=10) {
            mixin(_gen_elements!(M,N)("Scalar"));
        }
    }

    /** This contstructor takes M*N elements listed in row-major order.
     *  Example:
     *      auto M = MatrixT!(float,2,3)( a00, a01, a02
     *                                    a10, a11, a12 );
     */
    mixin(_gen_constructor!(M,N)("T"));


    /** This constructor takes an array of M*N elements listed in row-major order:
     *  Example:
     *      auto M = MatrixT!(float,2,3)([ a00, a01, a02
     *                                     a10, a11, a12 ]);
     */
    static MatrixT opCall(T[] v) {
        assert(v.length == M*N, "Input vector size must be "~ctfe_itoa(M*N));
        MatrixT Mat;
        with(Mat) {
            mixin(_gen_row_major_body!(M,N)("v"));
        }
        return Mat;
    }

    /// Compile-time const identity matrix.
    mixin(_gen_identity_matrix!(M,N)("static", "identity")) ;
    mixin(_gen_identity_matrix!(M,N)("static const", "cidentity")) ;

    /// Compile-time const matrix with all elements set to 0.
    mixin(_gen_zero_matrix!(M,N)("static", "zero")) ;
    mixin(_gen_zero_matrix!(M,N)("static const", "czero")) ;


    /** This constructor takes an array of M*N elements listed in row-major order:
     *  Example:
     *      auto M = MatrixT!(float,2,3)([ a00, a01, a02
     *                                     a10, a11, a12 ]);
     */
    static MatrixT row_major(T[] v) {
        return MatrixT(v);
    }

    /** This constructor takes an array of M*N elements listed in column-major order:
     *  Example:
     *      auto M = MatrixT!(float,2,3)([ a00, a10,
     *                                     a01, a11,
     *                                     a02, a12 ]);
     */
    static MatrixT col_major(T[] v) {
        assert(v.length == M*N, "Input vector size must be "~ctfe_itoa(M*N));
        MatrixT M;
        M.values_[] = v;
        return M;
    }

    /// returns total dimension of the matrix
    static size_t size() { return M*N; }

    /// Number of rows in the matrix
    static const int nrows = M;

    /// Number of columns in the matrix
    static const int ncols = N;
    
    /// The shape (rows and columns) of the matrix
    static uint[2] shape = [M,N];

    // Return a pointer to the elements
    Scalar* ptr() { return values_.ptr; }

    // Return a pointer to the i,j-th element
    Scalar* ptr(int i, int j) { return values_.ptr + j*nrows+i; }

    Scalar opIndex(uint row, uint col) {
        return values_[nrows*col + row];
    }

    Scalar opIndexAssign(Scalar v, uint row, uint col) {
        return values_[nrows*col + row] = v;
    }

    /// Add increment incr to the element [row,col]
    void add_elem(uint row, uint col, Scalar incr) {
        return values_[nrows*col + row] += incr;
    }

    /// Multiply element [row,col] by the given factor
    void mult_elem(uint row, uint col, Scalar factor) {
        return values_[nrows*col + row] *= factor;
    }

    /// -A Unary negation of matrix
    MatrixT opNeg() {
        MatrixT ret;
        for(int i=0; i<size; i++) {
            ret.values_[i] = -values_[i];
        }
        return ret;
    }

    /// A+B Add two matrices of the same shape
    MatrixT opAdd(ref MatrixT other) {
        MatrixT ret; ret = *this; ret += other; return ret;
    }
    /// A-B Subtract two matrices of the same shape
    MatrixT opSub(ref MatrixT other) {
        MatrixT ret; ret = *this; ret -= other; return ret;
    }

    /// A+=B
    void opAddAssign(ref MatrixT other) {
        for(int i=0; i<size; i++) {
            values_[i] += other.values_[i];
        }
    }
    /// A-=B
    void opSubAssign(ref MatrixT other) {
        for(int i=0; i<size; i++) {
            values_[i] -= other.values_[i];
        }
    }

    /// Or A/s multiplication by a scalar
    MatrixT opDiv(Scalar v) { return scalar_mult(1/v); }

    /// Or A/=s multiplication by a scalar
    void opDivAssign(Scalar v) { scalar_mult_assign(1/v); }


    /// Return squared Frobinius norm of the matrix
    Scalar sqrnorm() {
        Scalar ret=0;
        foreach(v; values_) ret += v*v;
        return ret;
    }

    /// Return Frobinius norm of the matrix
    Scalar norm() {
        return sqrt(sqrnorm());
    }

    /// Return the one-norm of the matrix (sum of elements' absolute values)
    Scalar onenorm() {
        Scalar ret=0;
        foreach(v; values_) ret += abs(v);
        return ret;
    }

    /// Return the infinity-norm of the matrix (max absolute value element)
    Scalar infnorm() {
        Scalar ret= -Scalar.max;
        foreach(v; values_) {
            v = abs(v);
            if (v>ret) ret = v;
        }
        return ret;
    }

    template IsMatrixT(ArgT) {
        // Check if it implements a suitable concept of
        // .ncols, .nrows and indexing with two values
        static if (is(typeof(ArgT.nrows)) && is(typeof(ArgT.ncols)) 
                   && is(typeof(ArgT.init[0,0])))
        {
            const bool IsMatrixT = true;
        }        
        else {
            const bool IsMatrixT = false;
        }
    }
    template IsVectorT(ArgT) {
        // Check if it implements a suitable concept of
        // .length and indexing with one value
        static if (is(typeof(ArgT.init[0])) && is(typeof(ArgT.init.length))) {
            const bool IsVectorT = true;
        } else {
            const bool IsVectorT = false;
        }
    }

    template MultReturnType(ArgT) {
        static if (IsMatrixT!(ArgT)) {
            static if (ncols == ArgT.nrows) {
                alias MatrixT!(T,M,ArgT.ncols) MultReturnType;
            }
            else {
                pragma(msg,"A * B: Shape "~ctfe_itoa(M)~" x "~ctfe_itoa(N)~
                       " not compatible with "~
                       ctfe_itoa(ArgT.nrows)~" x "~ctfe_itoa(ArgT.ncols));
            }
        }
        else static if (IsVectorT!(ArgT)) {
            static if (ncols == ArgT.init.length) {
                alias VectorT!(T,M) MultReturnType;
            }
            else {
                pragma(msg,"A * B: Shape "~ctfe_itoa(M)~" x "~ctfe_itoa(N)~
                       " not compatible with Vector "
                       ~ctfe_itoa(ArgT.length));
            }
        }
        else static if (is(ArgT:T)) {
            alias MatrixT MultReturnType ;
            }
        else {
            pragma(msg, "Unknown type '"~ArgT.stringof~"'for multiplication by MatrixT");
            alias void MultReturnType ;
        }
    }

    /// A*B Linear algebraic multiplication of A * B
    ///   (Only valid if A.ncols == B.nrows)
    /// Or A*s multiplication by a scalar
    MultReturnType!(ArgT) opMul(ArgT)(ArgT other) 
    {
        MultReturnType!(ArgT) ret;
        static if (IsMatrixT!(ArgT) && N == ArgT.nrows) {
            mat_mult_ret!(T,M,N,ArgT.ncols)(*this,other,ret);
        }
        else static if (IsVectorT!(ArgT) && N == ArgT.length) {
            mat_vec_mult_ret!(T,M,N)(*this,other,ret);
        }
        else static if (is(ArgT:T)) {
            ret = scalar_mult(other);
        }
        return ret;
    }
    /+
    /// BUG: deduction does not work with DMD 1.023
    MatrixT!(T,M,P) opMul(int P)(ref MatrixT!(T, N,P) other) {
        MatrixT!(T,M,P) ret; 
        mat_mult_ret!(T,M,N,P)(*this,other,ret);
        return ret;
    }
    +/

    /// A*=B Linear algebraic multiplication of A * B
    ///   (Only valid if A.ncols == B.nrows == B.ncols)
    /// Or A=*s multiplication by a scalar
    void opMulAssign(ArgT)(ArgT other) 
    {
        static if (IsMatrixT!(ArgT)) {
            static if(ncols==ArgT.nrows && ncols==ArgT.ncols) {
                MultReturnType!(ArgT) ret;
                mat_mult_ret!(T,M,N,ArgT.ncols)(*this,other,ret);
                *this = ret;
            }
            else {
                static assert(false,"A*=B: Shape "~ctfe_itoa(M)~" x "~ctfe_itoa(N)~
                              " not accumulate compatible with "~
                              ctfe_itoa(ArgT.nrows)~" x "~ctfe_itoa(ArgT.ncols));
            }
        }
        else static if (is(ArgT:T)) {
            scalar_mult_assign(other);
        }
    }

    MatrixT scalar_mult(Scalar f) {
        MatrixT ret=void;
        for(int i=0; i<size; i++) { ret.values_[i] = values_[i]*f; }
        return ret;
    }

    void scalar_mult_assign(Scalar f) {
        for(int i=0; i<size; i++) { values_[i] *= f; }
    }

    /// Transpose the matrix in place.  Only available for square matrices (M==N).
    /// For non-sqyare matrices use 'transposed'.
    static if(M==N) {
        void transpose() {
            for (int i=0; i<nrows; i++) {
                for (int j=i+1; j<ncols; j++) {
                    swap(values_[nrows*i + j], values_[nrows*j + i]);
                }
            }
        }
    } else {
        // Make a template so it only asserts if an attempt is made to instantiate
        void transpose(Dummy=void)() {
            static assert(false, "transpose(): Only square matrices can be transposed in place");
        }
    }
    
    /// Return a transposed copy of the matrix.
    /// For non-sqyare matrices use 'transposed'.
    MatrixT!(T, N,M) transposed() {
        MatrixT!(T, N,M) ret = void;
        for (int i=0; i<nrows; i++) {
            for (int j=0; j<ncols; j++) {
                ret.values_[ncols*i+j] = values_[nrows*j + i];
            }
        }
        return ret;
    }


    static if(M==N) {
        static if(M==2) {
            /** Returns the determinant of the matrix */
            real determinant() {
                return m00 * m11 - m10 * m01;
            }
            /** Returns the inverse of the matrix */
            MatrixT inverse() {
                MatrixT ret;
                ret.m00 =  m11;
                ret.m01 = -m01;
                ret.m10 = -m10;
                ret.m11 =  m00;
                real det = (m00 * m11 - m01 * m10);
                ret *= 1.0/det;
                return ret;
            }
            /** Inverts the matrix in place */
            void invert()
            {
                real idet = 1.0/(m00 * m11 - m01 * m10);
                swap(m00,m11);
                m10 = -m10;
                m01 = -m01;
                (*this) *= idet;
            }
        }
        else static if(M==3) {
            /** Returns the determinant of the matrix */
            real determinant()
            {
                real cofactor00 = m11 * m22 - m12 * m21;
                real cofactor10 = m12 * m20 - m10 * m22;
                real cofactor20 = m10 * m21 - m11 * m20;
            
                return m00 * cofactor00 + m01 * cofactor10 + m02 * cofactor20;;
            }
            /** Returns the inverse of the matrix */
            MatrixT inverse()
            {
                MatrixT ret;
                ret.m00 = m11 * m22 - m12 * m21;
                ret.m01 = m02 * m21 - m01 * m22;
                ret.m02 = m01 * m12 - m02 * m11;
                ret.m10 = m12 * m20 - m10 * m22;
                ret.m11 = m00 * m22 - m02 * m20;
                ret.m12 = m02 * m10 - m00 * m12;
                ret.m20 = m10 * m21 - m11 * m20;
                ret.m21 = m01 * m20 - m00 * m21;
                ret.m22 = m00 * m11 - m01 * m10;
                real det = m00 * ret.m00 + m01 * ret.m10 + m02 * ret.m20;
                ret *= 1.0/det;
                return ret;
            }
            /** Inverts the matrix "in place" */
            void invert() { *this = inverse(); }
        }            
        else static if (M==4)
        {
            /* Returns the determinant of the matrix */
            real determinant()
            {
                return
                    + (m00 * m11 - m01 * m10) * (m22 * m33 - m23 * m32)
                    - (m00 * m12 - m02 * m10) * (m21 * m33 - m23 * m31)
                    + (m00 * m13 - m03 * m10) * (m21 * m32 - m22 * m31)
                    + (m01 * m12 - m02 * m11) * (m20 * m33 - m23 * m30)
                    - (m01 * m13 - m03 * m11) * (m20 * m32 - m22 * m30)
                    + (m02 * m13 - m03 * m12) * (m20 * m31 - m21 * m30);
            }
            /** Returns the inverse of the matrix */
            MatrixT inverse() {
                MatrixT R=MatrixT(
                    m11*(m22*m33 - m23*m32) + m12*(m23*m31 - m21*m33) + m13*(m21*m32 - m22*m31),
                    m21*(m02*m33 - m03*m32) + m22*(m03*m31 - m01*m33) + m23*(m01*m32 - m02*m31),
                    m31*(m02*m13 - m03*m12) + m32*(m03*m11 - m01*m13) + m33*(m01*m12 - m02*m11),
                    m01*(m13*m22 - m12*m23) + m02*(m11*m23 - m13*m21) + m03*(m12*m21 - m11*m22),
                    m12*(m20*m33 - m23*m30) + m13*(m22*m30 - m20*m32) + m10*(m23*m32 - m22*m33),
                    m22*(m00*m33 - m03*m30) + m23*(m02*m30 - m00*m32) + m20*(m03*m32 - m02*m33),
                    m32*(m00*m13 - m03*m10) + m33*(m02*m10 - m00*m12) + m30*(m03*m12 - m02*m13),
                    m02*(m13*m20 - m10*m23) + m03*(m10*m22 - m12*m20) + m00*(m12*m23 - m13*m22),
                    m13*(m20*m31 - m21*m30) + m10*(m21*m33 - m23*m31) + m11*(m23*m30 - m20*m33),
                    m23*(m00*m31 - m01*m30) + m20*(m01*m33 - m03*m31) + m21*(m03*m30 - m00*m33),
                    m33*(m00*m11 - m01*m10) + m30*(m01*m13 - m03*m11) + m31*(m03*m10 - m00*m13),
                    m03*(m11*m20 - m10*m21) + m00*(m13*m21 - m11*m23) + m01*(m10*m23 - m13*m20),
                    m10*(m22*m31 - m21*m32) + m11*(m20*m32 - m22*m30) + m12*(m21*m30 - m20*m31),
                    m20*(m02*m31 - m01*m32) + m21*(m00*m32 - m02*m30) + m22*(m01*m30 - m00*m31),
                    m30*(m02*m11 - m01*m12) + m31*(m00*m12 - m02*m10) + m32*(m01*m10 - m00*m11),
                    m00*(m11*m22 - m12*m21) + m01*(m12*m20 - m10*m22) + m02*(m10*m21 - m11*m20));
                real det = determinant();
                R *= 1/det;
                return R;
            }
            /** Inverts the matrix "in place" */
            void invert() {  *this = inverse(); }
        }
        else {
            // TODO: implement general NxN case
            real determinant(Dummy=void)() {
                static assert(false, "determinant() not implemented for "~ MatrixT.stringof);
            }
            MatrixT inverse(Dummy=void)() {
                static assert(false, "inverse() not implemented for "~ MatrixT.stringof);
            }
            void invert(Dummy=void)() {
                static assert(false, "invert() not implemented for "~ MatrixT.stringof);
            }
        }
    } else {
        // Non-square matrix
        real determinant(Dummy=void)() {
            static assert(false, "determinant() not defined for non-square "~ MatrixT.stringof);
        }
        MatrixT inverse(Dummy=void)() {
            static assert(false, "inverse() not defined for non-square "~ MatrixT.stringof);
        }
        void invert(Dummy=void)() {
            static assert(false, "invert() not defined for non-square "~ MatrixT.stringof);
        }
    }            

    string toString() {
        char[] ret;
        ret ~= "[";
        for (int j = 0; j < nrows; j++) {
            if (j != 0)
                ret ~= " [ ";
            else 
                ret ~= "[ ";
            for (int i = 0; i < ncols; i++) {
                static if (is(T == struct))
                    ret ~= std.string.format("%15s",(*this)[j,i].toString);
                else if (is(T : int))
                    ret ~= std.string.format("%7s",(*this)[j,i]);
                else
                    ret ~= std.string.format("%7.4f",(*this)[j,i]);
                if (i != ncols -1)
                    ret ~= ",  ";
                else 
                    ret ~= "  ]";
            }
            if (j == nrows - 1)
                ret ~= "]";
            else
                ret ~= ",";
            if (j!=nrows-1) ret ~= "\n";
        }
        return ret;
    }
}


/// Multiply MxN matrix time NxP matrix
void mat_mult_ret(T,int M,int N,int P)(
    /*const*/ref MatrixT!(T,M,N) A, 
    /*const*/ref MatrixT!(T,N,P) B,
    inout MatrixT!(T,M,P) ret)
{
    with(ret) {
        mixin(_gen_mat_mult_body!(M,N,P)("A","B"));
    }
}

/// Multiply MxN matrix time NxP matrix
void mat_mult(T,int M,int N,int P, dum=void )(
    /*const*/ref MatrixT!(T,M,N) A,
    /*const*/ref MatrixT!(T,N,P) B,
    inout MatrixT!(T,M,P) ret)
{
    mat_mult_ret!(T,M,N,P)(A,B,ret);
}

/// Multiply MxN matrix time NxP matrix
MatrixT!(T,M,P) mat_mult(T,int M,int N,int P)(
    /*const*/ref MatrixT!(T,M,N) A, 
    /*const*/ref MatrixT!(T,N,P) B)
{
    MatrixT!(T,M,P) ret;
    mat_mult_ret!(T,M,N,P)(A,B, ret);
    return ret;
}

/// Multiply MxN matrix times N-vector (as column) ret = A * x
void mat_vec_mult_ret(T,int M,int N)(
    /*const*/ref MatrixT!(T,M,N) A, 
    /*const*/ref VectorT!(T,N) x,
    out VectorT!(T,M) ret)
{
    //pragma(msg, _gen_mat_vec_mult_body!(M,N)("A","x"));
    mixin(_gen_mat_vec_mult_body!(M,N)("A","x"));
}

/// Multiply MxN matrix times N-vector (as column) ret = A * x
VectorT!(T,M) mat_vec_mult(T,int M,int N)(
    /*const*/ref MatrixT!(T,M,N) A,
    /*const*/ref VectorT!(T,N) x)
{
    VectorT!(T,M) ret=void;
    mat_vec_mult_ret!(T,M,N)(A,x,ret);
    return ret;
}

/// Multiply M-vector times MxN matrix (as row) ret = x' * A
void vec_mat_mult_ret(T,int M,int N)(
    /*const*/ref VectorT!(T,M) x,
    /*const*/ref MatrixT!(T,M,N) A, 
    out VectorT!(T,N) ret)
{
    //pragma(msg, _gen_vec_mat_mult_body!(M,N)("x", "A"));
    mixin(_gen_vec_mat_mult_body!(M,N)("x","A"));
}

/// Multiply M-vector times MxN matrix (as row) ret = x' * A
VectorT!(T,N) vec_mat_mult_ret(T,int M,int N)(
    /*const*/ref VectorT!(T,M) x,
    /*const*/ref MatrixT!(T,M,N) A )
{
    VectorT!(T,N) ret=void;
    return vec_mat_mult_ret!(T,M,N)(x,A,ret);
    return ret;
}

/// Compute the outer product matrix, ret = a*b'
void outer_product_ret(T,int M, int N)(
    ref VectorT!(T, M) a, 
    ref VectorT!(T, N) b,
    out MatrixT!(T,M,N) ret)
{
    //pragma(msg, _gen_outer_product_body!(M,N)("a", "b"));
    mixin(_gen_outer_product_body!(M,N)("a","b"));
}

/// Compute the outer product matrix, ret = a*b'
MatrixT!(T,M,N) outer_product(T,int M, int N)(
    ref VectorT!(T, M) a, 
    ref VectorT!(T, N) b)
{
    MatrixT!(T,M,N) ret=void;
    outer_product_ret!(T,M,N)(a,b,ret);
    return ret;
}


/** Set A to be a rotation matrix */
void rotation2x2(T)(T rads_angle, out MatrixT!(T,2,2) A) 
{
    T c = cos(rads_angle);
    T s = sin(rads_angle);
    A.m00 = A.m11 = c;
    A.m10 = s;
    A.m01 = -s;
}

/** Decomposes A into R*S where R is orthogonal (pure rotation) and 
    S is symmetric (scaling and shearing).

    For matrices A with positive determinant (no reflections), 
    the rotation R is additionally the closest orthogonal matrix to A
    in the Frobenius norm.

    See 
    1. Shoemake and Duff "Matrix Animation and Polar Decomposition",
       Proceedings of Graphics Interface, 1992

    2. Higham, "Computing the Polar Decomposition -- with applications",
       SIAM J. Sci. Stat. Comput, Vol 7,  pp 1160-1174, 1986.

    3. Higham and Schreiber, "Fast Polar Decomposition of an Arbitrary Matrix",
       SIAM J. Sci. Stat. Comput.  Vol 11, No. 4, pp 648-655, 1990.

    Note: Reference 3 extends the method to non-square matrices.
          Implementing that is a TODO.
*/
void polar_decomposition(T, int N)(
    ref MatrixT!(T, N,N) A,
    out MatrixT!(T, N,N) R,
    out MatrixT!(T, N,N) S)
{
    alias MatrixT!(T,N,N) Matrix;

    R = A;
    // Scaled Newton method to orthogonalize R.
    // Shoemake & Duff 92 just mentions using R := (R+R^-T)
    // Higham86, and Higham & Schreiber 90 
    // use the scaled Newton version below
    // that improves convergence significantly.
    // (For instance, I've seen it reduce 11 iterations down to 4 in 
    //  cases where A has scaling near zero along one axis.)

    int maxIterations = 100;  // shouldn't ever hit this
    Matrix Rprev = R;
    R = 0.5f * (R + R.transposeauxd.inverse);
    while (!((R - Rprev).sqrnorm < 1000*T.epsilon) && maxIterations--)
    {
        Matrix Rinv = R.inverse;
        // Alternate gamma, may (or may not) be a bit slower.  
        //real gamma = sqrt( sqrt( Rinv.sqrnorm / R.sqrnorm ) );
        // TODO: measure whether sqrnorm or one*inf norm versions are slower
        // TODO: replace repeated sqrt with approximate 4th-root function?
        real gamma = sqrt( sqrt( (Rinv.onenorm * Rinv.infnorm) / (R.onenorm * R.infnorm) ) );
        Rprev = R;

        //Calc: R = 0.5f * (gamma * R + (1.0 / gamma) * Rinv.transposed);
        R *= gamma;
        Rinv.transpose;
        Rinv /= gamma;
        R += Rinv;
        R *= 0.5;
    }
            
    assert( maxIterations != -1 );

    // Using R.T * A + A.T * R makes sure S is symmetric even in 
    // the case where A has a negative determinant.
    S  = R.transposed * A;
    S += A.transposed * R;
    S *= 0.5;
}



//----------- Private code gen functions ----------------------------

// Convert from integral type to string. 
// (Source: Don Clugston's Blade library) 
private char [] ctfe_itoa(T)(T x)
{
    char [] s="";
    static if (is(T==byte)||is(T==short)||is(T==int)||is(T==long)) {
        if (x<0) {
            return "-" ~ ctfe_itoa(-x);
        }
    }
    do {
        s = cast(char)('0' + (x%10)) ~ s;
        x/=10;
    } while (x>0);
    return s;
}


// Generate the elements m00,m01,m02... elements
// For matrices with dimensions < 10 x 10 only.
private string _gen_elements(int M, int N)(string type) {
    static assert(M<=10);
    static assert(N<=10);
    char[] Num = "0123456789";
    string ret;
    for(int col=0; col<N; ++col) {
        ret ~= type ~ " ";
        for (int row=0; row<M; row++) {
            ret ~= "m" ~ Num[row] ~ Num[col];
            if (row!=M-1) ret ~=  ", ";
        }
        ret ~= ";\n";
    }
    return ret;
}

// Generate the opCall constructor taking a list of M*N values
// in row-major order. The constructor flips them propperly into
// MatrixT's column-major ordering.
private string _gen_constructor(int M, int N)(string type) {
    string ret = "static MatrixT opCall(";

    for (int row=0; row<M; ++row) {
        for(int col=0; col<N; ++col) {
            ret ~= type ~ " _" ~ ctfe_itoa(row) ~ "_" ~ ctfe_itoa(col);
            if (row*col != (N-1)*(M-1)) ret ~=  ", ";
        }
    }
    ret ~= ")";
    ret ~= "{
    MatrixT R; with (R) {
";
    for (int row=0; row<M; ++row) {
        ret ~= "        ";
        for(int col=0; col<N; ++col) {
            ret ~= "values_["~ctfe_itoa(col*M+row)~"] = _" ~ ctfe_itoa(row) ~ "_" ~ ctfe_itoa(col) ~ ";  ";
        }
        ret ~= "\n";
    }
    ret ~= "    }\n";
    ret ~= "    return R;\n}";
    return ret;
}

private string _gen_row_major_body(int M, int N)(string Vals) {
    string ret;
    int v=0;
    for (int row=0; row<M; ++row) {
        ret ~= "        ";
        for(int col=0; col<N; ++col,++v) {
            ret ~= "values_["~ctfe_itoa(col*M+row)~"] = "~Vals~"[" ~ ctfe_itoa(v) ~ "];  ";
        }
        ret ~= "\n";
    }
    return ret;
}

private string _gen_mat_mult_body(int M, int N, int P)(string A, string B) 
{
    string ret;
    for (int row=0; row<M; ++row) {
        for(int col=0; col<P; ++col) {
            ret ~= "        ";
            ret ~= "values_["~ctfe_itoa(col*M+row)~"] = ";
            for(int jj; jj<N; ++jj) {
                string JJ = ctfe_itoa(jj);
                string iA = ctfe_itoa( row+jj *M );
                string iB = ctfe_itoa( jj +col*N );
                ret ~= A ~ ".values_["~iA~"]*"~B~".values_["~iB~"]";
                if (jj != N-1) { ret ~= " + "; }
                else { ret ~= ";\n"; }
            }
        }
        ret ~= "\n";
    }
    return ret;
}

private string _gen_mat_vec_mult_body(int M, int N)(string A, string x) 
{
    string ret;
    for (int row=0; row<M; ++row) {
        ret ~= "        ";
        ret ~= "ret["~ctfe_itoa(row)~"] = ";
        for(int col=0; col<N; ++col) {
            string iA = ctfe_itoa( row + col*M );
            string ix = ctfe_itoa(col);
            ret ~= A ~ ".values_["~iA~"]*"~x~"["~ix~"]";
            if (col != N-1) { ret ~= " + "; }
        }
        ret ~= ";\n";
    }
    return ret;
}

private string _gen_vec_mat_mult_body(int M, int N)(string x, string A) 
{
    string ret;
    for(int col=0; col<N; ++col) {
        ret ~= "        ";
        ret ~= "ret["~ctfe_itoa(col)~"] = ";
        for (int row=0; row<M; ++row) {
            string iA = ctfe_itoa( row + col*M );
            string ix = ctfe_itoa( row );
            ret ~= x~"["~ix~"]*"~ A ~ ".values_["~iA~"]";
            if (row != M-1) { ret ~= " + "; }
        }
        ret ~= ";\n";
    }
    return ret;
}


private string _gen_outer_product_body(int M, int N)(string a, string b) 
{
    string ret;
    int v=0;
    for(int col=0; col<N; ++col) {
        ret ~= "        ";
        for (int row=0; row<M; ++row,++v) {
            ret ~= "ret.values_["~ctfe_itoa(v)~"] = ";
            string ia = ctfe_itoa( row );
            string ib = ctfe_itoa( col );
            ret ~= a ~ "["~ia~"]*"~b~"["~ib~"]; ";
        }
        ret ~= "\n";
    }
    return ret;
}



private string _gen_identity_matrix(int M, int N)(string storage_class, string name) {
    string ret = storage_class ~" MatrixT "~name~" = {[cast(T)";
    for(int col=0; col<N; ++col) {
        for (int row=0; row<M; ++row) {
            ret ~= row==col ? "1," : "0,";
            if (row==M-1 && col!=N-1) ret ~= "  ";
        }
    }
    return ret[0..$-1] ~ "]};";
}

private string _gen_zero_matrix(int M, int N)(string storage_class, string name) {
    string ret = storage_class ~" MatrixT "~name~" = {[cast(T)";
    for(int col=0; col<N; ++col) {
        for (int row=0; row<M; ++row) {
            ret ~= "0,";
            if (row==M-1 && col!=N-1) ret ~= "  ";
        }
    }
    return ret[0..$-1] ~ "]};";
}


debug (MatrixTMain) {
    private{
    alias double num_t;
    alias MatrixT!(num_t, 3,2) Mat32;
    alias MatrixT!(num_t, 2,3) Mat23;
    alias MatrixT!(num_t, 3,3) Mat33;
    alias MatrixT!(num_t, 2,2) Mat22;
    alias VectorT!(num_t,3) Vec3;
    alias VectorT!(num_t,2) Vec2;

    void check_mat(ref Mat33 A, num_t[9] v) {
        assert(A.m00 == v[0]);
        assert(A.m01 == v[1]);
        assert(A.m02 == v[2]);
        assert(A.m10 == v[3]);
        assert(A.m11 == v[4]);
        assert(A.m12 == v[5]);
        assert(A.m20 == v[6]);
        assert(A.m21 == v[7]);
        assert(A.m22 == v[8]);
    }
    void check_matf(ref Mat33 A, num_t[9] v) {
        assert(abs(A.m00 - v[0]) < 1e-4);
        assert(abs(A.m01 - v[1]) < 1e-4);
        assert(abs(A.m02 - v[2]) < 1e-4);
        assert(abs(A.m10 - v[3]) < 1e-4);
        assert(abs(A.m11 - v[4]) < 1e-4);
        assert(abs(A.m12 - v[5]) < 1e-4);
        assert(abs(A.m20 - v[6]) < 1e-4);
        assert(abs(A.m21 - v[7]) < 1e-4);
        assert(abs(A.m22 - v[8]) < 1e-4);
    }
    void check_mat(ref Mat22 A, num_t[4] v) {
        assert(A.m00 == v[0]);
        assert(A.m01 == v[1]);
        assert(A.m10 == v[2]);
        assert(A.m11 == v[3]);
    }
    void check_mat(ref Mat23 A, num_t[6] v) {
        assert(A.m00 == v[0]);
        assert(A.m01 == v[1]);
        assert(A.m02 == v[2]);
        assert(A.m10 == v[3]);
        assert(A.m11 == v[4]);
        assert(A.m12 == v[5]);
    }
    void check_mat(ref Mat32 A, num_t[6] v) {
        assert(A.m00 == v[0]);
        assert(A.m01 == v[1]);
        assert(A.m10 == v[2]);
        assert(A.m11 == v[3]);
        assert(A.m20 == v[4]);
        assert(A.m21 == v[5]);
    }
    void check_vec(ref Vec2 x, num_t[2] v) {
        assert(x[0] == v[0]);
        assert(x[1] == v[1]);
    }
    void check_vec(ref Vec3 x, num_t[3] v) {
        assert(x[0] == v[0]);
        assert(x[1] == v[1]);
        assert(x[2] == v[2]);
    }


import std.io;
void main() {

    Mat32 mat32 = [9,8,7,6,5,4];
    check_mat(mat32, [9,8,
                      7,6,
                      5,4]);
    Mat23 mat23 = {[9,8, 7,6, 5,4]};//col major
    check_mat(mat23, [9,7,5,
                      8,6,4]);
    mat32.m10 = 3;
    check_mat(mat32, [9,8,
                      3,6,
                      5,4]);
    mat23.m10 = 1;
    check_mat(mat23, [9,7,5,
                      1,6,4]);

    //writefln("mat23 =\n%s", mat23);

    MatrixT!(double, 9,9) mat99;
    MatrixT!(double, 10,10) matxx;

    mat32 = Mat32(1,2,
                  3,4,
                  5,6);
    check_mat(mat32, [1,2,
                      3,4,
                      5,6]);

    mat23 = Mat23([1,2,3,
                   4,5,6]);
    check_mat(mat23, [1,2,3,
                      4,5,6]);

    mat32 = Mat32.col_major([1,2,3,4,5,6]);
    check_mat(mat32, [1,4, 2,5, 3,6]);

    mat23 = Mat23.col_major([1,2, 3,4, 5,6]);
    check_mat(mat23, [1,3,5,
                      2,4,6]);

    auto mat33 = mat_mult(mat32,mat23);
    check_mat(mat33, [9,19,29, 
                      12,26,40,
                      15,33,51]);

    // opMul
    auto mat22 = mat23 * mat32;
    assert(is(typeof(mat22)==Mat22));
    check_mat(mat22, [22,49, 28,64]);
    
    // opMulAssign
    mat22 = Mat22([1.,2,
                   5, 3]);
    mat32 *= mat22;
    check_mat(mat22, [1,2, 5,3]);
    check_mat(mat32, [21,14, 27,19, 33,24]);

    // opMul (scalar)
    mat22 = 2 * mat22;
    check_mat(mat22, [2,4, 10,6]);

    // opDiv (scalar)
    check_mat(mat22/2, [1,2, 5,3]);

    // opMulAssign (scalar)
    mat22 *= 0.5;
    check_mat(mat22, [1,2, 5,3]);

    // opDivAssign (scalar)
    mat22 /= 0.5;
    check_mat(mat22, [2,4, 10,6]);

    mat22 = Mat22([1,2, 5,3]);
    // opAdd
    check_mat(mat22+mat22, [2,4, 10,6]);
    check_mat(mat22, [1,2, 5,3]);
    check_mat(mat23 + mat23, [2,6,10,  4,8,12]);
    check_mat(mat23, [1,3,5,  2,4,6]);

    // opSub
    check_mat(mat22-Mat22(2,4,3,9), [-1,-2, 2,-6]);

    // Transpose / transposed
    mat22 = Mat22([1,2, 5,3]);
    check_mat(mat22.transposed, [1,5, 2,3]);
    check_mat(mat22,            [1,2, 5,3]);
    mat22.transpose();
    check_mat(mat22,            [1,5, 2,3]);
              
    mat23 = Mat23(1,2,3, 4,5,6);
    check_mat(mat23.transposed, [1,4, 2,5, 3,6]);
    check_mat(mat23,            [1,2,3, 4,5,6]);
    //mat23.transpose();  // compile time error
    
    mat32 = Mat32(1,2, 3,4, 5,6);
    check_mat(mat32.transposed, [1,3,5, 2,4,6]);
    check_mat(mat32,            [1,2, 3,4, 5,6]);
    //mat32.transpose(); // compile-time error

    mat33 = Mat33(1,2,3, 4,5,6, 7,8,9);
    check_mat(mat33.transposed, [1,4,7, 2,5,8, 3,6,9]);
    check_mat(mat33,            [1,2,3, 4,5,6, 7,8,9]);
    mat33.transpose();
    check_mat(mat33,            [1,4,7, 2,5,8, 3,6,9]);

    mat33.add_elem(2,1, 5.0);
    check_mat(mat33,            [1,4,7, 2,5,8, 3,11,9]);

    Mat33 mat33inv = mat33.inverse();
    check_matf(mat33inv*3, [-4.3, 4.1,-0.3,
                            0.6, -1.2, 0.6,
                            0.7,  0.1,-0.3]);
    check_matf(mat33*mat33inv, [1.,0,0,  0,1,0, 0,0,1]);
    check_matf(mat33inv*mat33, [1.,0,0,  0,1,0, 0,0,1]);

    check_mat(Mat33.identity, [1.,0,0,  0,1,0, 0,0,1]);
    check_mat(Mat33.zero, [0,0,0,  0,0,0, 0,0,0]);
    
    Vec3 x = {[1,-3,7]};
    Vec2 Ax;
    mat23 = Mat23(1,2,3, 4,5,6);
    mat_vec_mult_ret(mat23, x, Ax);
    check_vec(Ax, [16,31]);

    vec_mat_mult_ret(Ax, mat23, x);
    check_vec(x, [140,187,234]);

    x = Vec3d([-1, 2, -3]);
    Vec3d y = {[3,2,1]};
    outer_product_ret(x, y, mat33);
    check_mat(mat33, [-3, -2, -1,       
                      +6,  4,  2,
                      -9, -6, -3]);
    
}}}

//--- Emacs setup ---
// Local Variables:
// c-basic-offset: 4
// indent-tabs-mode: nil
// End:

