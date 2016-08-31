
/***************************************************************************
 * Класс матрицы фиксированного размера (типа значения)
 *
 * Число рядов и колонок фиксируется при компиляции.
 * Storage is column major like FORTRAN or OpenGL.
 *
 * Authors:  William V. Baxter III (OLM Digital, Inc.)
 * Date: 23 Nov 2007
 * Copyright: (C) 2007-2008  William Baxter, OLM Digital, Inc.
 * License: ZLIB/LIBPNG
 */
//===========================================================================

module linalg.Matrix;

import linalg.Vector;
import stdrus;


/// Перестанавливает два значения
void переставь(Т)(inout Т a, inout Т b) { Т t = a; a = b; b = t; }

/** 
 *  Матрица is a generic M x N matrix тип.
 *  Dimensions (M rows, N columns) are fixed at compile time.
 *
 *  Matrix elements are stored in column-major order 
 *  like FORTRAN or OpenGL.
 *
 *  Compatible with linalg.Vector.
 */
struct Матрица(Т, цел M, цел N)
{
    alias Т Скаляр;

    union {
        Скаляр[M*N] значения_ = void;
        static if(M<=10 && N<=10) {
            mixin(_gen_elements!(M,N)("Скаляр"));
        }
    }

    /** This contstructor takes M*N elements listed in ряд-major order.
     *  Example:
     *      auto M = Матрица!(плав,2,3)( a00, a01, a02
     *                                    a10, a11, a12 );
     */
    mixin(_gen_constructor!(M,N)("Т"));


    /** This constructor takes an array of M*N elements listed in ряд-major order:
     *  Example:
     *      auto M = Матрица!(плав,2,3)([ a00, a01, a02
     *                                     a10, a11, a12 ]);
     */
    static Матрица opCall(Т[] v) {
        assert(v.length == M*N, "Входной размер вектора должен быть "~ctfe_itoa(M*N));
        Матрица Mat;
        with(Mat) {
            mixin(_gen_row_major_body!(M,N)("v"));
        }
        return Mat;
    }

    /// Compile-time const подобие matrix.
    mixin(_gen_identity_matrix!(M,N)("static", "подобие")) ;
    mixin(_gen_identity_matrix!(M,N)("static const", "cidentity")) ;

    /// Compile-time const matrix with all elements установи to 0.
    mixin(_gen_zero_matrix!(M,N)("static", "ноль")) ;
    mixin(_gen_zero_matrix!(M,N)("static const", "czero")) ;


    /** This constructor takes an array of M*N elements listed in ряд-major order:
     *  Example:
     *      auto M = Матрица!(плав,2,3)([ a00, a01, a02
     *                                     a10, a11, a12 ]);
     */
    static Матрица ряд_майор(Т[] v) {
        return Матрица(v);
    }

    /** This constructor takes an array of M*N elements listed in column-major order:
     *  Example:
     *      auto M = Матрица!(плав,2,3)([ a00, a10,
     *                                     a01, a11,
     *                                     a02, a12 ]);
     */
    static Матрица столб_майор(Т[] v) {
        assert(v.length == M*N, "Размер входного вектора должен быть "~ctfe_itoa(M*N));
        Матрица M;
        M.значения_[] = v;
        return M;
    }

    /// returns total dimension of the matrix
    static т_мера размер() { return M*N; }

    /// Number of rows in the matrix
    static const цел члорядов = M;

    /// Number of columns in the matrix
    static const цел члостолбцов = N;
    
    /// The форма (rows and columns) of the matrix
    static бцел[2] форма = [M,N];

    // Return a pointer to the elements
    Скаляр* укз() { return значения_.ptr; }

    // Return a pointer to the i,j-th element
    Скаляр* укз(цел i, цел j) { return значения_.ptr + j*члорядов+i; }

    Скаляр opIndex(бцел ряд, бцел столб) {
        return значения_[члорядов*столб + ряд];
    }

    Скаляр opIndexAssign(Скаляр v, бцел ряд, бцел столб) {
        return значения_[члорядов*столб + ряд] = v;
    }

    /// Add прирост прир to the element [ряд,столб]
    void добавь_элт(бцел ряд, бцел столб, Скаляр прир) {
        return значения_[члорядов*столб + ряд] += прир;
    }

    /// Multiply element [ряд,столб] by the given фактор
    void умножь_элт(бцел ряд, бцел столб, Скаляр фактор) {
        return значения_[члорядов*столб + ряд] *= фактор;
    }

    /// -A Unary negation of matrix
    Матрица opNeg() {
        Матрица возвр;
        for(цел i=0; i<размер; i++) {
            возвр.значения_[i] = -значения_[i];
        }
        return возвр;
    }

    /// A+B Add two matrices of the same форма
    Матрица opAdd(ref Матрица друг) {
        Матрица возвр; возвр = *this; возвр += друг; return возвр;
    }
    /// A-B Subtract two matrices of the same форма
    Матрица opSub(ref Матрица друг) {
        Матрица возвр; возвр = *this; возвр -= друг; return возвр;
    }

    /// A+=B
    void opAddAssign(ref Матрица друг) {
        for(цел i=0; i<размер; i++) {
            значения_[i] += друг.значения_[i];
        }
    }
    /// A-=B
    void opSubAssign(ref Матрица друг) {
        for(цел i=0; i<размер; i++) {
            значения_[i] -= друг.значения_[i];
        }
    }

    /// Or A/s multiplication by a скаляр
    Матрица opDiv(Скаляр v) { return умножь_скаляр(1/v); }

    /// Or A/=s multiplication by a скаляр
    void opDivAssign(Скаляр v) { умножь_присвой_скаляр(1/v); }


    /// Return squared Frobinius нормаль of the matrix
    Скаляр квнорм() {
        Скаляр возвр=0;
        foreach(v; значения_) возвр += v*v;
        return возвр;
    }

    /// Return Frobinius нормаль of the matrix
    Скаляр нормаль() {
        return квкор(квнорм());
    }

    /// Return the one-нормаль of the matrix (sum of elements' absolute values)
    Скаляр норм1() {
        Скаляр возвр=0;
        foreach(v; значения_) возвр += абс(v);
        return возвр;
    }

    /// Return the infinity-нормаль of the matrix (макс absolute value element)
    Скаляр бескнорм() {
        Скаляр возвр= -Скаляр.max;
        foreach(v; значения_) {
            v = абс(v);
            if (v>возвр) возвр = v;
        }
        return возвр;
    }

    template Матрица_ли(ТАрг) {
        // Check if it implements a suitable concept of
        // .члостолбцов, .члорядов and indexing with two values
        static if (is(typeof(ТАрг.члорядов)) && is(typeof(ТАрг.члостолбцов)) 
                   && is(typeof(ТАрг.init[0,0])))
        {
            const бул Матрица_ли = true;
        }        
        else {
            const бул Матрица_ли = false;
        }
    }
    template Вектор_ли(ТАрг) {
        // Check if it implements a suitable concept of
        // .length and indexing with one value
        static if (is(typeof(ТАрг.init[0])) && is(typeof(ТАрг.init.length))) {
            const бул Вектор_ли = true;
        } else {
            const бул Вектор_ли = false;
        }
    }

    template МногоВозврТип(ТАрг) {
        static if (Матрица_ли!(ТАрг)) {
            static if (члостолбцов == ТАрг.члорядов) {
                alias Матрица!(Т,M,ТАрг.члостолбцов) МногоВозврТип;
            }
            else {
                pragma(msg,"A * B: Shape "~ctfe_itoa(M)~" x "~ctfe_itoa(N)~
                       " не совместимо с "~
                       ctfe_itoa(ТАрг.члорядов)~" x "~ctfe_itoa(ТАрг.члостолбцов));
            }
        }
        else static if (Вектор_ли!(ТАрг)) {
            static if (члостолбцов == ТАрг.init.length) {
                alias Вектор!(Т,M) МногоВозврТип;
            }
            else {
                pragma(msg,"A * B: Shape "~ctfe_itoa(M)~" x "~ctfe_itoa(N)~
                       " не совместимо с Вектором "
                       ~ctfe_itoa(ТАрг.length));
            }
        }
        else static if (is(ТАрг:Т)) {
            alias Матрица МногоВозврТип ;
            }
        else {
            pragma(msg, "Неизвестный тип '"~ТАрг.stringof~"'для умножения на Матрица");
            alias void МногоВозврТип ;
        }
    }

    /// A*B Linear algebraic multiplication of A * B
    ///   (Only valid if A.члостолбцов == B.члорядов)
    /// Or A*s multiplication by a скаляр
    МногоВозврТип!(ТАрг) opMul(ТАрг)(ТАрг друг) 
    {
        МногоВозврТип!(ТАрг) возвр;
        static if (Матрица_ли!(ТАрг) && N == ТАрг.члорядов) {
            умножь_верни_мат!(Т,M,N,ТАрг.члостолбцов)(*this,друг,возвр);
        }
        else static if (Вектор_ли!(ТАрг) && N == ТАрг.length) {
            умножь_верни_мат_век!(Т,M,N)(*this,друг,возвр);
        }
        else static if (is(ТАрг:Т)) {
            возвр = умножь_скаляр(друг);
        }
        return возвр;
    }
    /+
    /// BUG: deduction does not work with DMD 1.023
    Матрица!(Т,M,P) opMul(цел P)(ref Матрица!(Т, N,P) друг) {
        Матрица!(Т,M,P) возвр; 
        умножь_верни_мат!(Т,M,N,P)(*this,друг,возвр);
        return возвр;
    }
    +/

    /// A*=B Linear algebraic multiplication of A * B
    ///   (Only valid if A.члостолбцов == B.члорядов == B.члостолбцов)
    /// Or A=*s multiplication by a скаляр
    void opMulAssign(ТАрг)(ТАрг друг) 
    {
        static if (Матрица_ли!(ТАрг)) {
            static if(члостолбцов==ТАрг.члорядов && члостолбцов==ТАрг.члостолбцов) {
                МногоВозврТип!(ТАрг) возвр;
                умножь_верни_мат!(Т,M,N,ТАрг.члостолбцов)(*this,друг,возвр);
                *this = возвр;
            }
            else {
                static assert(false,"A*=B: Shape "~ctfe_itoa(M)~" x "~ctfe_itoa(N)~
                              " не совместимо с "~
                              ctfe_itoa(ТАрг.члорядов)~" x "~ctfe_itoa(ТАрг.члостолбцов));
            }
        }
        else static if (is(ТАрг:Т)) {
            умножь_присвой_скаляр(друг);
        }
    }

    Матрица умножь_скаляр(Скаляр f) {
        Матрица возвр=void;
        for(цел i=0; i<размер; i++) { возвр.значения_[i] = значения_[i]*f; }
        return возвр;
    }

    void умножь_присвой_скаляр(Скаляр f) {
        for(цел i=0; i<размер; i++) { значения_[i] *= f; }
    }

    /// Transpose the matrix in place.  Only available for square matrices (M==N).
    /// For non-sqyare matrices use 'транспонированный'.
    static if(M==N) {
        void транспонируй() {
            for (цел i=0; i<члорядов; i++) {
                for (цел j=i+1; j<члостолбцов; j++) {
                    переставь(значения_[члорядов*i + j], значения_[члорядов*j + i]);
                }
            }
        }
    } else {
        // Make a template so it only asserts if an attempt is made to instantiate
        void транспонируй(Dummy=void)() {
            static assert(false, "транспонируй(): Only square matrices can be транспонированный in place");
        }
    }
    
    /// Return a транспонированный copy of the matrix.
    /// For non-sqyare matrices use 'транспонированный'.
    Матрица!(Т, N,M) транспонированный() {
        Матрица!(Т, N,M) возвр = void;
        for (цел i=0; i<члорядов; i++) {
            for (цел j=0; j<члостолбцов; j++) {
                возвр.значения_[члостолбцов*i+j] = значения_[члорядов*j + i];
            }
        }
        return возвр;
    }


    static if(M==N) {
        static if(M==2) {
            /** Returns the детерминанта of the matrix */
            реал детерминанта() {
                return m00 * m11 - m10 * m01;
            }
            /** Returns the инверсия of the matrix */
            Матрица инверсия() {
                Матрица возвр;
                возвр.m00 =  m11;
                возвр.m01 = -m01;
                возвр.m10 = -m10;
                возвр.m11 =  m00;
                реал det = (m00 * m11 - m01 * m10);
                возвр *= 1.0/det;
                return возвр;
            }
            /** Inverts the matrix in place */
            void инвертируй()
            {
                реал idet = 1.0/(m00 * m11 - m01 * m10);
                переставь(m00,m11);
                m10 = -m10;
                m01 = -m01;
                (*this) *= idet;
            }
        }
        else static if(M==3) {
            /** Returns the детерминанта of the matrix */
            реал детерминанта()
            {
                реал cofactor00 = m11 * m22 - m12 * m21;
                реал cofactor10 = m12 * m20 - m10 * m22;
                реал cofactor20 = m10 * m21 - m11 * m20;
            
                return m00 * cofactor00 + m01 * cofactor10 + m02 * cofactor20;;
            }
            /** Returns the инверсия of the matrix */
            Матрица инверсия()
            {
                Матрица возвр;
                возвр.m00 = m11 * m22 - m12 * m21;
                возвр.m01 = m02 * m21 - m01 * m22;
                возвр.m02 = m01 * m12 - m02 * m11;
                возвр.m10 = m12 * m20 - m10 * m22;
                возвр.m11 = m00 * m22 - m02 * m20;
                возвр.m12 = m02 * m10 - m00 * m12;
                возвр.m20 = m10 * m21 - m11 * m20;
                возвр.m21 = m01 * m20 - m00 * m21;
                возвр.m22 = m00 * m11 - m01 * m10;
                реал det = m00 * возвр.m00 + m01 * возвр.m10 + m02 * возвр.m20;
                возвр *= 1.0/det;
                return возвр;
            }
            /** Inverts the matrix "in place" */
            void инвертируй() { *this = инверсия(); }
        }            
        else static if (M==4)
        {
            /* Returns the детерминанта of the matrix */
            реал детерминанта()
            {
                return
                    + (m00 * m11 - m01 * m10) * (m22 * m33 - m23 * m32)
                    - (m00 * m12 - m02 * m10) * (m21 * m33 - m23 * m31)
                    + (m00 * m13 - m03 * m10) * (m21 * m32 - m22 * m31)
                    + (m01 * m12 - m02 * m11) * (m20 * m33 - m23 * m30)
                    - (m01 * m13 - m03 * m11) * (m20 * m32 - m22 * m30)
                    + (m02 * m13 - m03 * m12) * (m20 * m31 - m21 * m30);
            }
            /** Returns the инверсия of the matrix */
            Матрица инверсия() {
                Матрица R=Матрица(
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
                реал det = детерминанта();
                R *= 1/det;
                return R;
            }
            /** Inverts the matrix "in place" */
            void инвертируй() {  *this = инверсия(); }
        }
        else {
            // TODO: implement general NxN case
            реал детерминанта(Dummy=void)() {
                static assert(false, "детерминанта() не реализовано для "~ Матрица.stringof);
            }
            Матрица инверсия(Dummy=void)() {
                static assert(false, "инверсия() не реализовано для "~ Матрица.stringof);
            }
            void инвертируй(Dummy=void)() {
                static assert(false, "инвертируй() не реализовано для "~ Матрица.stringof);
            }
        }
    } else {
        // Non-square matrix
        реал детерминанта(Dummy=void)() {
            static assert(false, "детерминанта() не определено для неквадрата "~ Матрица.stringof);
        }
        Матрица инверсия(Dummy=void)() {
            static assert(false, "инверсия() не определено для неквадрата "~ Матрица.stringof);
        }
        void инвертируй(Dummy=void)() {
            static assert(false, "инвертируй() не определено для неквадрата "~ Матрица.stringof);
        }
    }            

    ткст вТкст() {
        char[] возвр;
        возвр ~= "[";
        for (цел j = 0; j < члорядов; j++) {
            if (j != 0)
                возвр ~= " [ ";
            else 
                возвр ~= "[ ";
            for (цел i = 0; i < члостолбцов; i++) {
                static if (is(Т == struct))
                    возвр ~= stdrus.фм("%15s",(*this)[j,i].вТкст);
                else if (is(Т : цел))
                    возвр ~= stdrus.фм("%7s",(*this)[j,i]);
                else
                    возвр ~= stdrus.фм("%7.4f",(*this)[j,i]);
                if (i != члостолбцов -1)
                    возвр ~= ",  ";
                else 
                    возвр ~= "  ]";
            }
            if (j == члорядов - 1)
                возвр ~= "]";
            else
                возвр ~= ",";
            if (j!=члорядов-1) возвр ~= "\n";
        }
        return возвр;
    }
}


/// Multiply MxN matrix time NxP matrix
void умножь_верни_мат(Т,цел M,цел N,цел P)(
    /*const*/ref Матрица!(Т,M,N) A, 
    /*const*/ref Матрица!(Т,N,P) B,
    inout Матрица!(Т,M,P) возвр)
{
    with(возвр) {
        mixin(_gen_mat_mult_body!(M,N,P)("A","B"));
    }
}

/// Multiply MxN matrix time NxP matrix
void умножь_мат(Т,цел M,цел N,цел P, dum=void )(
    /*const*/ref Матрица!(Т,M,N) A,
    /*const*/ref Матрица!(Т,N,P) B,
    inout Матрица!(Т,M,P) возвр)
{
    умножь_верни_мат!(Т,M,N,P)(A,B,возвр);
}

/// Multiply MxN matrix time NxP matrix
Матрица!(Т,M,P) умножь_мат(Т,цел M,цел N,цел P)(
    /*const*/ref Матрица!(Т,M,N) A, 
    /*const*/ref Матрица!(Т,N,P) B)
{
    Матрица!(Т,M,P) возвр;
    умножь_верни_мат!(Т,M,N,P)(A,B, возвр);
    return возвр;
}

/// Multiply MxN matrix times N-вектор (as column) возвр = A * x
void умножь_верни_мат_век(Т,цел M,цел N)(
    /*const*/ref Матрица!(Т,M,N) A, 
    /*const*/ref Вектор!(Т,N) x,
    out Вектор!(Т,M) возвр)
{
    //pragma(msg, _gen_mat_vec_mult_body!(M,N)("A","x"));
    mixin(_gen_mat_vec_mult_body!(M,N)("A","x"));
}

/// Multiply MxN matrix times N-вектор (as column) возвр = A * x
Вектор!(Т,M) умножь_мат_век(Т,цел M,цел N)(
    /*const*/ref Матрица!(Т,M,N) A,
    /*const*/ref Вектор!(Т,N) x)
{
    Вектор!(Т,M) возвр=void;
    умножь_верни_мат_век!(Т,M,N)(A,x,возвр);
    return возвр;
}

/// Multiply M-вектор times MxN matrix (as ряд) возвр = x' * A
void умножь_верни_век_мат(Т,цел M,цел N)(
    /*const*/ref Вектор!(Т,M) x,
    /*const*/ref Матрица!(Т,M,N) A, 
    out Вектор!(Т,N) возвр)
{
    //pragma(msg, _gen_vec_mat_mult_body!(M,N)("x", "A"));
    mixin(_gen_vec_mat_mult_body!(M,N)("x","A"));
}

/// Multiply M-вектор times MxN matrix (as ряд) возвр = x' * A
Вектор!(Т,N) умножь_верни_век_мат(Т,цел M,цел N)(
    /*const*/ref Вектор!(Т,M) x,
    /*const*/ref Матрица!(Т,M,N) A )
{
    Вектор!(Т,N) возвр=void;
    return умножь_верни_век_мат!(Т,M,N)(x,A,возвр);
    return возвр;
}

/// Compute the внешн product matrix, возвр = a*b'
void верни_внешн_продукт(Т,цел M, цел N)(
    ref Вектор!(Т, M) a, 
    ref Вектор!(Т, N) b,
    out Матрица!(Т,M,N) возвр)
{
    //pragma(msg, _gen_outer_product_body!(M,N)("a", "b"));
    mixin(_gen_outer_product_body!(M,N)("a","b"));
}

/// Compute the внешн product matrix, возвр = a*b'
Матрица!(Т,M,N) внешн_продукт(Т,цел M, цел N)(
    ref Вектор!(Т, M) a, 
    ref Вектор!(Т, N) b)
{
    Матрица!(Т,M,N) возвр=void;
    верни_внешн_продукт!(Т,M,N)(a,b,возвр);
    return возвр;
}


/** Set A to be a вращение matrix */
void вращ2х2(Т)(Т угол_рад, out Матрица!(Т,2,2) A) 
{
    Т c = _кос(угол_рад);
    Т s = _син(угол_рад);
    A.m00 = A.m11 = c;
    A.m10 = s;
    A.m01 = -s;
}

/** Decomposes A into R*S where R is orthogonal (pure вращение) and 
    S is symmetric (scaling and shearing).

    For matrices A with positive детерминанта (no reflections), 
    the вращение R is additionally the closest orthogonal matrix to A
    in the Frobenius нормаль.

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
void полярн_декомп(Т, цел N)(
    ref Матрица!(Т, N,N) A,
    out Матрица!(Т, N,N) R,
    out Матрица!(Т, N,N) S)
{
    alias Матрица!(Т,N,N) Matrix;

    R = A;
    // Scaled Newton method to orthogonalize R.
    // Shoemake & Duff 92 just mentions using R := (R+R^-Т)
    // Higham86, and Higham & Schreiber 90 
    // use the scaled Newton version below
    // that improves convergence significantly.
    // (For instance, I've seen it reduce 11 iterations down to 4 in 
    //  cases where A has scaling near ноль along one ось.)

    цел maxIterations = 100;  // shouldn't ever hit this
    Matrix Rprev = R;
    R = 0.5f * (R + R.transposeauxd.инверсия);
    while (!((R - Rprev).квнорм < 1000*Т.epsilon) && maxIterations--)
    {
        Matrix Rinv = R.инверсия;
        // Alternate gamma, may (or may not) be a bit slower.  
        //реал gamma = квкор( квкор( Rinv.квнорм / R.квнорм ) );
        // TODO: measure whether квнорм or one*беск нормаль versions are slower
        // TODO: replace repeated квкор with approximate 4th-корень function?
        реал gamma = квкор( квкор( (Rinv.норм1 * Rinv.бескнорм) / (R.норм1 * R.бескнорм) ) );
        Rprev = R;

        //Calc: R = 0.5f * (gamma * R + (1.0 / gamma) * Rinv.транспонированный);
        R *= gamma;
        Rinv.транспонируй;
        Rinv /= gamma;
        R += Rinv;
        R *= 0.5;
    }
            
    assert( maxIterations != -1 );

    // Using R.Т * A + A.Т * R makes sure S is symmetric even in 
    // the case where A has a negative детерминанта.
    S  = R.транспонированный * A;
    S += A.транспонированный * R;
    S *= 0.5;
}



//----------- Private code gen functions ----------------------------

// Convert from integral тип to ткст. 
// (Source: Don Clugston's Blade library) 
private char [] ctfe_itoa(Т)(Т x)
{
    char [] s="";
    static if (is(Т==байт)||is(Т==крат)||is(Т==цел)||is(Т==дол)) {
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
private ткст _gen_elements(цел M, цел N)(ткст тип) {
    static assert(M<=10);
    static assert(N<=10);
    char[] Num = "0123456789";
    ткст возвр;
    for(цел столб=0; столб<N; ++столб) {
        возвр ~= тип ~ " ";
        for (цел ряд=0; ряд<M; ряд++) {
            возвр ~= "m" ~ Num[ряд] ~ Num[столб];
            if (ряд!=M-1) возвр ~=  ", ";
        }
        возвр ~= ";\n";
    }
    return возвр;
}

// Generate the opCall constructor taking a list of M*N values
// in ряд-major order. The constructor flips them propperly into
// Матрица's column-major ordering.
private ткст _gen_constructor(цел M, цел N)(ткст тип) {
    ткст возвр = "static Матрица opCall(";

    for (цел ряд=0; ряд<M; ++ряд) {
        for(цел столб=0; столб<N; ++столб) {
            возвр ~= тип ~ " _" ~ ctfe_itoa(ряд) ~ "_" ~ ctfe_itoa(столб);
            if (ряд*столб != (N-1)*(M-1)) возвр ~=  ", ";
        }
    }
    возвр ~= ")";
    возвр ~= "{
    Матрица R; with (R) {
";
    for (цел ряд=0; ряд<M; ++ряд) {
        возвр ~= "        ";
        for(цел столб=0; столб<N; ++столб) {
            возвр ~= "значения_["~ctfe_itoa(столб*M+ряд)~"] = _" ~ ctfe_itoa(ряд) ~ "_" ~ ctfe_itoa(столб) ~ ";  ";
        }
        возвр ~= "\n";
    }
    возвр ~= "    }\n";
    возвр ~= "    return R;\n}";
    return возвр;
}

private ткст _gen_row_major_body(цел M, цел N)(ткст Vals) {
    ткст возвр;
    цел v=0;
    for (цел ряд=0; ряд<M; ++ряд) {
        возвр ~= "        ";
        for(цел столб=0; столб<N; ++столб,++v) {
            возвр ~= "значения_["~ctfe_itoa(столб*M+ряд)~"] = "~Vals~"[" ~ ctfe_itoa(v) ~ "];  ";
        }
        возвр ~= "\n";
    }
    return возвр;
}

private ткст _gen_mat_mult_body(цел M, цел N, цел P)(ткст A, ткст B) 
{
    ткст возвр;
    for (цел ряд=0; ряд<M; ++ряд) {
        for(цел столб=0; столб<P; ++столб) {
            возвр ~= "        ";
            возвр ~= "значения_["~ctfe_itoa(столб*M+ряд)~"] = ";
            for(цел jj; jj<N; ++jj) {
                ткст JJ = ctfe_itoa(jj);
                ткст iA = ctfe_itoa( ряд+jj *M );
                ткст iB = ctfe_itoa( jj +столб*N );
                возвр ~= A ~ ".значения_["~iA~"]*"~B~".значения_["~iB~"]";
                if (jj != N-1) { возвр ~= " + "; }
                else { возвр ~= ";\n"; }
            }
        }
        возвр ~= "\n";
    }
    return возвр;
}

private ткст _gen_mat_vec_mult_body(цел M, цел N)(ткст A, ткст x) 
{
    ткст возвр;
    for (цел ряд=0; ряд<M; ++ряд) {
        возвр ~= "        ";
        возвр ~= "возвр["~ctfe_itoa(ряд)~"] = ";
        for(цел столб=0; столб<N; ++столб) {
            ткст iA = ctfe_itoa( ряд + столб*M );
            ткст ix = ctfe_itoa(столб);
            возвр ~= A ~ ".значения_["~iA~"]*"~x~"["~ix~"]";
            if (столб != N-1) { возвр ~= " + "; }
        }
        возвр ~= ";\n";
    }
    return возвр;
}

private ткст _gen_vec_mat_mult_body(цел M, цел N)(ткст x, ткст A) 
{
    ткст возвр;
    for(цел столб=0; столб<N; ++столб) {
        возвр ~= "        ";
        возвр ~= "возвр["~ctfe_itoa(столб)~"] = ";
        for (цел ряд=0; ряд<M; ++ряд) {
            ткст iA = ctfe_itoa( ряд + столб*M );
            ткст ix = ctfe_itoa( ряд );
            возвр ~= x~"["~ix~"]*"~ A ~ ".значения_["~iA~"]";
            if (ряд != M-1) { возвр ~= " + "; }
        }
        возвр ~= ";\n";
    }
    return возвр;
}


private ткст _gen_outer_product_body(цел M, цел N)(ткст a, ткст b) 
{
    ткст возвр;
    цел v=0;
    for(цел столб=0; столб<N; ++столб) {
        возвр ~= "        ";
        for (цел ряд=0; ряд<M; ++ряд,++v) {
            возвр ~= "возвр.значения_["~ctfe_itoa(v)~"] = ";
            ткст ia = ctfe_itoa( ряд );
            ткст ib = ctfe_itoa( столб );
            возвр ~= a ~ "["~ia~"]*"~b~"["~ib~"]; ";
        }
        возвр ~= "\n";
    }
    return возвр;
}



private ткст _gen_identity_matrix(цел M, цел N)(ткст storage_class, ткст name) {
    ткст возвр = storage_class ~" Матрица "~name~" = {[cast(Т)";
    for(цел столб=0; столб<N; ++столб) {
        for (цел ряд=0; ряд<M; ++ряд) {
            возвр ~= ряд==столб ? "1," : "0,";
            if (ряд==M-1 && столб!=N-1) возвр ~= "  ";
        }
    }
    return возвр[0..$-1] ~ "]};";
}

private ткст _gen_zero_matrix(цел M, цел N)(ткст storage_class, ткст name) {
    ткст возвр = storage_class ~" Матрица "~name~" = {[cast(Т)";
    for(цел столб=0; столб<N; ++столб) {
        for (цел ряд=0; ряд<M; ++ряд) {
            возвр ~= "0,";
            if (ряд==M-1 && столб!=N-1) возвр ~= "  ";
        }
    }
    return возвр[0..$-1] ~ "]};";
}


debug (MatrixMain) {
    private{
    alias дво num_t;
    alias Матрица!(num_t, 3,2) Mat32;
    alias Матрица!(num_t, 2,3) Mat23;
    alias Матрица!(num_t, 3,3) Mat33;
    alias Матрица!(num_t, 2,2) Mat22;
    alias Вектор!(num_t,3) Vec3;
    alias Вектор!(num_t,2) Vec2;

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
        assert(абс(A.m00 - v[0]) < 1e-4);
        assert(абс(A.m01 - v[1]) < 1e-4);
        assert(абс(A.m02 - v[2]) < 1e-4);
        assert(абс(A.m10 - v[3]) < 1e-4);
        assert(абс(A.m11 - v[4]) < 1e-4);
        assert(абс(A.m12 - v[5]) < 1e-4);
        assert(абс(A.m20 - v[6]) < 1e-4);
        assert(абс(A.m21 - v[7]) < 1e-4);
        assert(абс(A.m22 - v[8]) < 1e-4);
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
    Mat23 mat23 = {[9,8, 7,6, 5,4]};//столб major
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

    Матрица!(дво, 9,9) mat99;
    Матрица!(дво, 10,10) matxx;

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

    mat32 = Mat32.столб_майор([1,2,3,4,5,6]);
    check_mat(mat32, [1,4, 2,5, 3,6]);

    mat23 = Mat23.столб_майор([1,2, 3,4, 5,6]);
    check_mat(mat23, [1,3,5,
                      2,4,6]);

    auto mat33 = умножь_мат(mat32,mat23);
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

    // opMul (скаляр)
    mat22 = 2 * mat22;
    check_mat(mat22, [2,4, 10,6]);

    // opDiv (скаляр)
    check_mat(mat22/2, [1,2, 5,3]);

    // opMulAssign (скаляр)
    mat22 *= 0.5;
    check_mat(mat22, [1,2, 5,3]);

    // opDivAssign (скаляр)
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

    // Transpose / транспонированный
    mat22 = Mat22([1,2, 5,3]);
    check_mat(mat22.транспонированный, [1,5, 2,3]);
    check_mat(mat22,            [1,2, 5,3]);
    mat22.транспонируй();
    check_mat(mat22,            [1,5, 2,3]);
              
    mat23 = Mat23(1,2,3, 4,5,6);
    check_mat(mat23.транспонированный, [1,4, 2,5, 3,6]);
    check_mat(mat23,            [1,2,3, 4,5,6]);
    //mat23.транспонируй();  // compile time error
    
    mat32 = Mat32(1,2, 3,4, 5,6);
    check_mat(mat32.транспонированный, [1,3,5, 2,4,6]);
    check_mat(mat32,            [1,2, 3,4, 5,6]);
    //mat32.транспонируй(); // compile-time error

    mat33 = Mat33(1,2,3, 4,5,6, 7,8,9);
    check_mat(mat33.транспонированный, [1,4,7, 2,5,8, 3,6,9]);
    check_mat(mat33,            [1,2,3, 4,5,6, 7,8,9]);
    mat33.транспонируй();
    check_mat(mat33,            [1,4,7, 2,5,8, 3,6,9]);

    mat33.добавь_элт(2,1, 5.0);
    check_mat(mat33,            [1,4,7, 2,5,8, 3,11,9]);

    Mat33 mat33inv = mat33.инверсия();
    check_matf(mat33inv*3, [-4.3, 4.1,-0.3,
                            0.6, -1.2, 0.6,
                            0.7,  0.1,-0.3]);
    check_matf(mat33*mat33inv, [1.,0,0,  0,1,0, 0,0,1]);
    check_matf(mat33inv*mat33, [1.,0,0,  0,1,0, 0,0,1]);

    check_mat(Mat33.подобие, [1.,0,0,  0,1,0, 0,0,1]);
    check_mat(Mat33.ноль, [0,0,0,  0,0,0, 0,0,0]);
    
    Vec3 x = {[1,-3,7]};
    Vec2 Ax;
    mat23 = Mat23(1,2,3, 4,5,6);
    умножь_верни_мат_век(mat23, x, Ax);
    check_vec(Ax, [16,31]);

    умножь_верни_век_мат(Ax, mat23, x);
    check_vec(x, [140,187,234]);

    x = Век3д([-1, 2, -3]);
    Век3д y = {[3,2,1]};
    верни_внешн_продукт(x, y, mat33);
    check_mat(mat33, [-3, -2, -1,       
                      +6,  4,  2,
                      -9, -6, -3]);
    
}}}