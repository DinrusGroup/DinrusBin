/*
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:

    Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.

    Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions and the following
    disclaimer in the documentation and/or other materials provided
    with the distribution.

    Neither name of Victor Nakoryakov nor the names of
    its contributors may be used to endorse or promote products
    derived from this software without specific prior written
    permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.

Copyright (C) 2006. Victor Nakoryakov.
*/
/**
Модуль содержит основные математические объекты, нацеленные для работы с 3D
графикой.

Это 2,3,4-D векторы, кватернион, матрицы 3x3 и 4x4. На случай специализации
под 3D-графику, имеются всегда некоторые средства и производные
из классической математики. Вот сводка по подобным средствам линейной алгебры helix:
$(UL
    $(LI В helix используется парадигма колончатого вектора (column-vector). Умножение матрицы на
         вектор имеет смысл, а умножение вектора на матрицу не имеет.
         Этот подход придерживается правил, принятых в классической математике, и совпадает 
         с правилами OpenGL. Но противоречит парадигме Direct3D, где вектор является
         рядом (row). Так, в helix, для комбинирования последовательности переносов, заданных
		матрицами A, B, C в порядке A, затем B, затем C, нужно умножить их в обратном порядке
         (сзади к переду): M=C*B*A. )

    $(LI При работе с углами euler приняты следующие определения.
         Yaw представляет вращение вокруг Y, Pitch - вращение вокруг X, Roll - вращение вокруг Z.
         Вращения всегда применяются в порядке: Roll, затем Pitch, затем Yaw. )

    $(LI Под матрицы Helix используется column-major memory layout. Т.е. матрица
        $(MAT33
            $(MAT33_ROW a, b, c)
            $(MAT33_ROW d, e, f)
            $(MAT33_ROW g, h, i)
        )
        в памяти выглядит как: a, d, g, b, e, h, c, f, i. Порядок этот аналогичен порядку в
        OpenGL API, но притивоположен Direct3D API. Но, как уже упоминалось, Direct3D
        использует векторно-рядовую парадигму, противоречащую классической математике, 
		поэтому D3D требуется транспонированная матрица, в отличие от классики, чтобы
		получить необходимую трансформацию (перенос). В итоге не требуется транспонировать
		матрицу helix при передаче в API, даже в случае с Direct3D.
		Как правило, помнить о разметке памяти необязательно, просто ею пользуются как в
		классической математике, это имеет значение только в процедурах, оперирующих над
		указателями на данные и над плоскими представлениями массивов.
		В документации на такие методы есть напоминания. )
)

Авторы:
    Виктор Накоряков, nail-mail[at]mail.ru
    
Macros:
    MAT33     = <table style="border-left: double 3px #666666; border-right: double 3px #666666;
                 margin-left: 3em;">$0</table>
    MAT33_ROW = <tr><td>$1</td><td>$2</td><td>$3</td></tr>
*/
module auxd.helix.linalgebra;

import std.math;
import std.string : format;
import auxd.helix.basic,
       auxd.helix.config;

/** Определяет названия ортов, обычно применяемых в качестве индексов. */
enum Ort
{
    X, ///
    Y, /// ditto
    Z, /// ditto
    W  /// ditto
}

/**
Шаблон-обмотчик, предоставляющий возможность использования
в реализуемых структурах и процедурах разных типов с
плавающей запятой.
*/
private template LinearAlgebra(float_t)
{
    private alias auxd.helix.basic.equal          equal;
    
    alias .LinearAlgebra!(float).Vector2     Vector2f;
    alias .LinearAlgebra!(float).Vector3     Vector3f;
    alias .LinearAlgebra!(float).Vector4     Vector4f;
    alias .LinearAlgebra!(float).Quaternion  Quaternionf;
    alias .LinearAlgebra!(float).Matrix22    Matrix22f;
    alias .LinearAlgebra!(float).Matrix33    Matrix33f;
    alias .LinearAlgebra!(float).Matrix44    Matrix44f;
    
    alias .LinearAlgebra!(double).Vector2    Vector2d;
    alias .LinearAlgebra!(double).Vector3    Vector3d;
    alias .LinearAlgebra!(double).Vector4    Vector4d;
    alias .LinearAlgebra!(double).Quaternion Quaterniond;
    alias .LinearAlgebra!(double).Matrix22   Matrix22d;
    alias .LinearAlgebra!(double).Matrix33   Matrix33d;
    alias .LinearAlgebra!(double).Matrix44   Matrix44d;
    
    alias .LinearAlgebra!(real).Vector2      Vector2r;
    alias .LinearAlgebra!(real).Vector3      Vector3r;
    alias .LinearAlgebra!(real).Vector4      Vector4r;
    alias .LinearAlgebra!(real).Quaternion   Quaternionr;
    alias .LinearAlgebra!(real).Matrix22     Matrix22r;
    alias .LinearAlgebra!(real).Matrix33     Matrix33r;
    alias .LinearAlgebra!(real).Matrix44     Matrix44r;

    /************************************************************************************
    Двухмерный вектор.

    Формальное определение вектора, значение возможных операций и связанная с этим
    информация приведена на стр. $(LINK http://en.wikipedia.org/wiki/Vector_(spatial)).
    *************************************************************************************/
    struct Vector2
    {
        enum { length = 2u }

        align(1)
        {
            float_t x; /// Компоненты вектора.
            float_t y; /// ditto
        }
        
        static Vector2 nan = { float_t.nan, float_t.nan }; /// Вектор, у которого обе компоненты установлены в NaN.
        static Vector2 zero = { 0, 0 };                    /// Нулевой вектор 

        static Vector2 unitX = { 1, 0 };                   /// Unit vector codirectional with corresponding axis.
        static Vector2 unitY = { 0, 1 };                   /// ditto
        
        
        /**
        Метод для построения вектора в стиле синтаксиса Си.

        Пример:
        ------------
        Vector2 myVector = Vector2(1, 2);
        ------------
        */
        static Vector2 opCall(float_t x, float_t y)
        {
            Vector2 v;
            v.set(x, y);
            return v;
        }
        
        /** Метод для построения из массива. */
        static Vector2 opCall(float_t[2] p)
        {
            Vector2 v;
            v.set(p);
            return v;
        }
        
        /** Устанавливает значения компонент на передаваемые значения. */
        void set(float_t x, float_t y)
        {
            this.x = x;
            this.y = y;
        }
        
        /** Устанавливает значения компонент на передаваемые значения. */
        void set(float_t[2] p)
        {
            this.x = p[0];
            this.y = p[1];
        }
        
        /** Возвращает: Нормаль (также известную как длину, величину) вектора. */
        real norm()
        {
            return hypot(x, y);
        }
    
        /**
        Возвращает: Квадрат нормали вектора.
        
        Поскольку данный метод не требует вычисления квадратного корня, лучше
        использовать его, а не norm(). Например, если нужно просто узнать,
        который из 2-х векторов длинее, то лучше всего сравнить квадраты их нормалей,
        а не сами нормали.
        */
        real normSquare()
        {
            return x*x + y*y;
        }
    
        /** Нормализует данный вектор. Возвращает: исходную длину. */
        real normalize()
        {
            real len = norm();
            *this /= len;
            return len;
        }
    
        /** Возвращает: Нормализованную копию данного вектора. */
        Vector2 normalized()
        {
            real n = norm;
            return Vector2(x / n, y / n);
        }
    
        /**
        Возвращает: Является ли данный вектор единицей (unit).
        Параметры:
            relprec, absprec = Параметры, передаваемые функции equal при сравнении
                               квадрата нормали и 1. Имеет то же значение, что и в функции equal.
        */
        bool isUnit(int relprec = defrelprec, int absprec = defabsprec)
        {
            return equal( normSquare(), 1, relprec, absprec );
        }
    
        /** Возвращает: Ось, для которой проекция данного вектора будет самой длинной. */
        Ort dominatingAxis()
        {
            return (x > y) ? Ort.X : Ort.Y;
        }
    
        /** Возвращает: Являются ли все компоненты нормализованными числами. */
        bool isnormal()
        {
            return std.math.isnormal(x) && std.math.isnormal(y);
        }
    
        /** Возвращает: float_t указатель на компоненту x данного вектора. Подобен методу _ptr для массивов. */
        float_t* ptr()
        {
            return cast(float_t*)this;
        }
    
        /** Возвращает: Компоненту, соответствующую переданному индексу. */
        float_t opIndex(size_t ort)
        in { assert(ort <= Ort.Y); }
        body
        {
            return ptr[cast(int)ort];
        }
    
        /** Присваивает компоненте новое значение (_value), соответствующее переданному индексу. */
        void opIndexAssign(float_t value, size_t ort)
        in { assert(ort <= Ort.Y); }
        body
        {
            ptr[cast(int)ort] = value;
        }
    
        /**
        Стандартные операторы, значения которых понятны интуитивно. Аналогичны классической математике.
        
        Внимание: операторы деления не выполняют проверок значения k, поэтому в случае деления на
        0 результирующий вектор будет иметь компоненты с бесконечностью. Это можно проверить с помощью
	    метода isnormal().
        */
        bool opEquals(Vector2 v)
        {
            return x == v.x && y == v.y;
        }
    
        /** ditto */
        Vector2 opNeg()
        {
            return Vector2(-x, -y);
        }
    
        /** ditto */
        Vector2 opAdd(Vector2 v)
        {
            return Vector2(x + v.x, y + v.y);
        }
    
        /** ditto */
        void opAddAssign(Vector2 v)
        {
            x += v.x;
            y += v.y;
        }
    
        /** ditto */
        Vector2 opSub(Vector2 v)
        {
            return Vector2(x - v.x, y - v.y);
        }
    
        /** ditto */
        void opSubAssign(Vector2 v)
        {
            x -= v.x;
            y -= v.y;
        }
    
        /** ditto */
        Vector2 opMul(real k)
        {
            return Vector2(x * k, y * k);
        }
    
        /** ditto */
        void opMulAssign(real k)
        {
            x *= k;
            y *= k;
        }
    
        /** ditto */
        Vector2 opMul_r(real k)
        {
            return Vector2(x * k, y * k);
        }
    
        /** ditto */
        Vector2 opDiv(real k)
        {
            return Vector2(x / k, y / k);
        }
    
        /** ditto */
        void opDivAssign(real k)
        {
            x /= k;
            y /= k;
        }
    
        /** Возвращает: Вектор, перепендикулярный к данному */
        Vector2 perp() 
        {
            return Vector2(-y,x);
        }

        /** Возвращает: Копию данного вектора с компонентами типа float */
        Vector2f toVector2f()
        {
            return Vector2f(cast(float)x, cast(float)y);
        }
        
        /** Возвращает: Копию данного вектора с компонентами типа double */
        Vector2d toVector2d()
        {
            return Vector2d(cast(double)x, cast(double)y);
        }
        
        /** Возвращает: Копию данного вектора с компонентами типа real */
        Vector2r toVector2r()
        {
            return Vector2r(cast(real)x, cast(real)y);
        }
    
        /**
        Процедуры, известные как swizzling.
        Возвращает:
            Новый вектор, построенный из данного. Значения его компонент
            соответствуют названию метода.
        */
        Vector3 xy0()    { return Vector3(x, y, 0); }
        Vector3 x0y()    { return Vector3(x, 0, y); } /// ditto

        char[] toString() { return format("[",x,", ",y,"]"); }
    }
    
    public {
    /** Возвращает: Производную точки между переданными векторами. */
    real dot(Vector2 a, Vector2 b)
    {
        return a.x * b.x + a.y * b.y;
    }
        
    /** Возвращает: Внешнюю производную между переданными векторами. */
    Matrix22 outer(Vector2 a, Vector2 b)
    {
        return Matrix22( a.x * b.x, a.x * b.y,
                         a.y * b.x, a.y * b.y);
    }
        
    /**
    Возвращает: Производную пересечения между заданными векторами. Результатом является скаляр c,
    при этом [a.x a.y 0], [b.x b.y 0], [0,0,c] образуют правую тройку (right-hand tripple).
    */
    real cross(Vector2 a, Vector2 b)
    {
        return a.x * b.y - b.x * a.y;
    }


    alias EqualityByNorm!(Vector2).equal equal; /// Представляет функцию приближенного равенства для Vector2.
    alias Lerp!(Vector2).lerp lerp;             /// Представляет функцию линейной интерполяции для Vector2.
    } // end public
    
    /************************************************************************************
    Трёхмерный вектор.

    Формальное определение вектора, значение возможных операций и связанную с этим
    информацию можно найти на странице $(LINK http://en.wikipedia.org/wiki/Vector_(spatial)).
    *************************************************************************************/
    struct Vector3
    {
        enum { length = 3u }

        align(1)
        {
            float_t x; /// Компоненты вектора.
            float_t y; /// ditto
            float_t z; /// ditto
        }
        
        static Vector3 nan = { float_t.nan, float_t.nan, float_t.nan }; /// Вектор, у которого все компоненты установлены в NaN.
        static Vector3 zero = {0,0,0};    // The zero vector
        static Vector3 unitX = { 1, 0, 0 };  /// Unit vector, сонаправленный с определенной осью.
        static Vector3 unitY = { 0, 1, 0 };  /// ditto
        static Vector3 unitZ = { 0, 0, 1 };  /// ditto
        
        /**
        Метод для построения вектора в стиле Си.

        Примеры:
        ------------
        Vector3 myVector = Vector3(1, 2, 3);
        ------------
        */
        static Vector3 opCall(float_t x, float_t y, float_t z)
        {
            Vector3 v;
            v.set(x, y, z);
            return v;
        }
        
        /** Метод для построения из массива */
        static Vector3 opCall(float_t[3] p)
        {
            Vector3 v;
            v.set(p);
            return v;
        }
        
        /** Устанавливает значения компонент на передаваемые значения. */
        void set(float_t x, float_t y, float_t z)
        {
            this.x = x;
            this.y = y;
            this.z = z;
        }
    
        
        /** Устанавливает значения компонент на передаваемые значения. */
        void set(float_t[3] p)
        {
            this.x = p[0];
            this.y = p[1];
            this.z = p[2];
        }
    
        
        /** Возвращает: Norm (also known as length, magnitude) of vector. */
        real norm()
        {
            return sqrt(x*x + y*y + z*z);
        }
    
        /**
        Возвращает: Square of vector's norm.
        
        Since this method doesn't need calculation of square root it is better
        to use it instead of norm() when you can. For example, if you want just
        to know which of 2 vectors is longer it's better to compare their norm
        squares instead of their norm.
        */
        real normSquare()
        {
            return x*x + y*y + z*z;
        }
    
        /** Normalizes this vector. Возвращает: the original length */
        real normalize()
        {
            real len = norm();
            *this /= len;
            return len;
        }
    
        /** Возвращает: Normalized copy of this vector. */
        Vector3 normalized()
        {
            real n = norm;
            return Vector3(x / n, y / n, z / n);
        }
    
        /**
        Возвращает: Whether this vector is unit.
        Params:
            relprec, absprec = Parameters passed to equal function while comparison of
                               norm square and 1. Have the same meaning as in equal function.
        */
        bool isUnit(int relprec = defrelprec, int absprec = defabsprec)
        {
            return equal( normSquare(), 1, relprec, absprec );
        }
    
        /** Возвращает: Axis for which projection of this vector on it will be longest. */
        Ort dominatingAxis()
        {
            if (x > y)
                return (x > z) ? Ort.X : Ort.Z;
            else
                return (y > z) ? Ort.Y : Ort.Z;
        }
    
        /** Возвращает: Whether all components are normalized numbers. */
        bool isnormal()
        {
            return std.math.isnormal(x) && std.math.isnormal(y) && std.math.isnormal(z);
        }
    
        /** Возвращает: float_t pointer to x component of this vector. It's like a _ptr method for arrays. */
        float_t* ptr()
        {
            return cast(float_t*)(&x);
        }
    
        /** Возвращает: Component corresponded to passed index. */
        float_t opIndex(size_t ort)
        in { assert(ort <= Ort.Z); }
        body
        {
            return ptr[cast(int)ort];
        }
    
        /** Assigns new _value to component corresponded to passed index. */
        void opIndexAssign(float_t value, size_t ort)
        in { assert(ort <= Ort.Z); }
        body
        {
            ptr[cast(int)ort] = value;
        }
    
        /**
        Standard operators that have intuitive meaning, same as in classical math.
        
        Note that division operators do no cheks of value of k, so in case of division
        by 0 result vector will have infinity components. You can check this with isnormal()
        method.
        */
        bool opEquals(Vector3 v)
        {
            return x == v.x && y == v.y && z == v.z;
        }
    
        /** ditto */
        Vector3 opNeg()
        {
            return Vector3(-x, -y, -z);
        }
    
        /** ditto */
        Vector3 opAdd(Vector3 v)
        {
            return Vector3(x + v.x, y + v.y, z + v.z);
        }
    
        /** ditto */
        void opAddAssign(Vector3 v)
        {
            x += v.x;
            y += v.y;
            z += v.z;
        }
    
        /** ditto */
        Vector3 opSub(Vector3 v)
        {
            return Vector3(x - v.x, y - v.y, z - v.z);
        }
    
        /** ditto */
        void opSubAssign(Vector3 v)
        {
            x -= v.x;
            y -= v.y;
            z -= v.z;
        }
    
        /** ditto */
        Vector3 opMul(real k)
        {
            return Vector3(x * k, y * k, z * k);
        }
    
        /** ditto */
        void opMulAssign(real k)
        {
            x *= k;
            y *= k;
            z *= k;
        }
    
        /** ditto */
        Vector3 opMul_r(real k)
        {
            return Vector3(x * k, y * k, z * k);
        }
    
        /** ditto */
        Vector3 opDiv(real k)
        {
            return Vector3(x / k, y / k, z / k);
        }
    
        /** ditto */
        void opDivAssign(real k)
        {
            x /= k;
            y /= k;
            z /= k;
        }
        
        /** Возвращает: Copy of this vector with float type components */
        Vector3f toVector3f()
        {
            return Vector3f(cast(float)x, cast(float)y, cast(float)z);
        }
        
        /** Возвращает: Copy of this vector with double type components */
        Vector3d toVector3d()
        {
            return Vector3d(cast(double)x, cast(double)y, cast(double)z);
        }

        /** Возвращает: Copy of this vector with real type components */
        Vector3r toVector3r()
        {
            return Vector3r(cast(real)x, cast(real)y, cast(real)z);
        }

    
        /**
        Routines known as swizzling.
        Возвращает:
            New vector constructed from this one and having component values
            that correspond to method name.
        */
        Vector4 xyz0()        { return Vector4(x,y,z,0); }
        Vector4 xyz1()        { return Vector4(x,y,z,1); } /// ditto
        Vector2 xy()          { return Vector2(x, y); }    /// ditto
        Vector2 xz()          { return Vector2(x, z); }    /// ditto
        
        /**
        Routines known as swizzling.
        Assigns new values to some components corresponding to method name.
        */
        void xy(Vector2 v)    { x = v.x; y = v.y; }
        void xz(Vector2 v)    { x = v.x; z = v.y; }        /// ditto

        char[] toString() { return format("[",x,", ",y,", ", z, "]"); }
    }
    
    public {

    /** Возвращает: Dot product between passed vectors. */
    real dot(Vector3 a, Vector3 b)
    {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }
    
    /** Возвращает: Outer product between passed vectors. */
    Matrix33 outer(Vector3 a, Vector3 b)
    {
        return Matrix33( a.x * b.x,  a.x * b.y,  a.x * b.z,
                         a.y * b.x,  a.y * b.y,  a.y * b.z,
                         a.z * b.x,  a.z * b.y,  a.z * b.z);
    }
        

    /**
    Возвращает: Cross product between passed vectors. Result is vector c
    so that a, b, c forms right-hand tripple.
    */
    Vector3 cross(Vector3 a, Vector3 b)
    {
        return Vector3(
            a.y * b.z - b.y * a.z,
            a.z * b.x - b.z * a.x,
            a.x * b.y - b.x * a.y  );
    }
    
    /**
    Возвращает: Является ли переданное основание ортогональным.
    Params:
        r, s, t =          Векторы, образующие основание.
        relprec, absprec = Параметры, передаваемые функции сравнения при вычислениях.
                           Имею то же значение, что и в функции equal.
    Ссылки:
        $(LINK http://en.wikipedia.org/wiki/Orthogonal_basis)
    */
    bool isBasisOrthogonal(Vector3 r, Vector3 s, Vector3 t, int relprec = defrelprec, int absprec = defabsprec)
    {
        return equal( cross(r, cross(s, t)).normSquare, 0, relprec, absprec );
    }
    
    /**
    Возвращает: Является ли переданное основание ортонормальным.
    Params:
        r, s, t =   Векторы, образующие основание.
        relprec, absprec = Параметры, передаваемые функции сравнения при вычислениях.
                           Имею то же значение, что и в функции equal.
    Ссылки:
        $(LINK http://en.wikipedia.org/wiki/Orthonormal_basis)
    */
    bool isBasisOrthonormal(Vector3 r, Vector3 s, Vector3 t, int relprec = defrelprec, int absprec = defabsprec)
    {
        return isBasisOrthogonal(r, s, t, relprec, absprec) &&
            r.isUnit(relprec, absprec) &&
            s.isUnit(relprec, absprec) &&
            t.isUnit(relprec, absprec);
    }
    
    alias EqualityByNorm!(Vector3).equal equal; /// Introduces approximate equality function for Vector3.
    alias Lerp!(Vector3).lerp lerp;             /// Introduces linear interpolation function for Vector3.
    
    } // end public
    
    /************************************************************************************
    4D vector.

    For formal definition of vector, meaning of possible operations and related
    information see $(LINK http://en.wikipedia.org/wiki/Vector_(spatial)),
    $(LINK http://en.wikipedia.org/wiki/Homogeneous_coordinates).
    *************************************************************************************/
    struct Vector4
    {
        enum { length = 4u }

        align(1)
        {
            float_t x; /// Components of vector.
            float_t y; /// ditto
            float_t z; /// ditto
            float_t w; /// ditto
        }
        
        /// Vector with all components set to NaN.
        static Vector4 nan = { float_t.nan, float_t.nan, float_t.nan, float_t.nan };
        static Vector4 zero = { 0,0,0,0 };
        static Vector4 unitX = { 1, 0, 0, 0 }; /// Unit vector codirectional with corresponding axis.
        static Vector4 unitY = { 0, 1, 0, 0 }; /// ditto
        static Vector4 unitZ = { 0, 0, 1, 0 }; /// ditto
        static Vector4 unitW = { 0, 0, 0, 1 }; /// ditto
        
        /**
        Methods to construct vector in C-like syntax.

        Примеры:
        ------------
        Vector4 myVector = Vector4(1, 2, 3, 1);
        Vector4 myVector = Vector4(Vector3(1, 2, 3), 0);
        Vector4 myVector = Vector4([1,2,3,1]);
        ------------
        */
        static Vector4 opCall(float_t x, float_t y, float_t z, float_t w)
        {
            Vector4 v;
            v.set(x, y, z, w);
            return v;
        }
        
        /** ditto */
        static Vector4 opCall(Vector3 xyz, float_t w)
        {
            Vector4 v;
            v.set(xyz, w);
            return v;
        }
    
        /** ditto */
        static Vector4 opCall(float_t[4] p)
        {
            Vector4 v;
            v.set(p);
            return v;
        }
    
        /** Sets values of components to passed values. */
        void set(float_t x, float_t y, float_t z, float_t w)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }
    
        /** ditto */
        void set(Vector3 xyz, float_t w)
        {
            this.x = xyz.x;
            this.y = xyz.y;
            this.z = xyz.z;
            this.w = w;
        }
    
        /** ditto */
        void set(float_t[4] p)
        {
            this.x = p[0];
            this.y = p[1];
            this.z = p[2];
            this.w = p[3];
        }
    
        

        /**
        Возвращает: Norm (also known as length, magnitude) of vector.
        
        W-component is taken into account.
        */
        real norm()
        {
            return sqrt(x*x + y*y + z*z + w*w);
        }
    
        /**
        Возвращает: Square of vector's norm.

        W-component is taken into account.
        
        Since this method doesn't need calculation of square root it is better
        to use it instead of norm() when you can. For example, if you want just
        to know which of 2 vectors is longer it's better to compare their norm
        squares instead of their norm.
        */
        real normSquare()
        {
            return x*x + y*y + z*z + w*w;
        }
    
        /** Normalizes this vector. Возвращает: the original length. */
        real normalize()
        {
            real len = norm();
            *this /= len;
            return len;
        }
    
        /** Возвращает: Normalized copy of this vector. */
        Vector4 normalized()
        {
            real n = norm;
            return Vector4(x / n, y / n, z / n, w / n);
        }
    
        /**
        Возвращает: Whether this vector is unit.
        Params:
            relprec, absprec = Parameters passed to equal function while comparison of
                               norm square and 1. Have the same meaning as in equal function.
        */
        bool isUnit(int relprec = defrelprec, int absprec = defabsprec)
        {
            return equal( normSquare, 1, relprec, absprec );
        }
    
        /**
        Возвращает: Axis for which projection of this vector on it will be longest.
        
        W-component is taken into account.
        */
        Ort dominatingAxis()
        {
            if (x > y)
            {
                if (x > z)
                    return (x > w) ? Ort.X : Ort.W;
                else
                    return (z > w) ? Ort.Z : Ort.W;
            }
            else
            {
                if (y > z)
                    return (y > w) ? Ort.Y : Ort.W;
                else
                    return (z > w) ? Ort.Z : Ort.W;
            }
        }
    
        /** Возвращает: Whether all components are normalized numbers. */
        bool isnormal()
        {
            return std.math.isnormal(x) && std.math.isnormal(y) && std.math.isnormal(z) && std.math.isnormal(w);
        }
    
        /** Возвращает: float_t pointer to x component of this vector. It's like a _ptr method for arrays. */
        float_t* ptr()
        {
            return cast(float_t*)(&x);
        }
        
        /** Возвращает: Component corresponded to passed index. */
        float_t opIndex(size_t ort)
        in { assert(ort <= Ort.W); }
        body
        {
            return ptr[cast(int)ort];
        }
    
        /** Assigns new value to component corresponded to passed index. */
        void opIndexAssign(float_t value, size_t ort)
        in { assert(ort <= Ort.W); }
        body
        {
            ptr[cast(int)ort] = value;
        }
    
        /**
        Standard operators that have intuitive meaning, same as in classical math.
        
        Note that division operators do no cheks of value of k, so in case of division
        by 0 result vector will have infinity components. You can check this with isnormal()
        method.
        */
        bool opEquals(Vector4 v)
        {
            return x == v.x && y == v.y && z == v.z && w == v.w;
        }
    
        /** ditto */
        Vector4 opNeg()
        {
            return Vector4(-x, -y, -z, -w);
        }
    
        /** ditto */
        Vector4 opAdd(Vector4 v)
        {
            return Vector4(x + v.x, y + v.y, z + v.z, w + v.w);
        }
    
        /** ditto */
        void opAddAssign(Vector4 v)
        {
            x += v.x;
            y += v.y;
            z += v.z;
            w += v.w;
        }
    
        /** ditto */
        Vector4 opSub(Vector4 v)
        {
            return Vector4(x - v.x, y - v.y, z - v.z, w - v.w);
        }
    
        /** ditto */
        void opSubAssign(Vector4 v)
        {
            x -= v.x;
            y -= v.y;
            z -= v.z;
            w -= v.w;
        }
    
        /** ditto */
        Vector4 opMul(real k)
        {
            return Vector4(x * k, y * k, z * k, w * k);
        }
    
        /** ditto */
        void opMulAssign(real k)
        {
            x *= k;
            y *= k;
            z *= k;
            w *= k;
        }
    
        /** ditto */
        Vector4 opMul_r(real k)
        {
            return Vector4(x * k, y * k, z * k, w * k);
        }
    
        /** ditto */
        Vector4 opDiv(real k)
        {
            return Vector4(x / k, y / k, z / k, w / k);
        }
    
        /** ditto */
        void opDivAssign(real k)
        {
            x /= k;
            y /= k;
            z /= k;
            w /= k;
        }
    
        /** Возвращает: Copy of this vector with float type components */
        Vector4f toVector4f()
        {
            return Vector4f(cast(float)x, cast(float)y, cast(float)z, cast(float)w);
        }
        
        /** Возвращает: Copy of this vector with double type components */
        Vector4d toVector4d()
        {
            return Vector4d(cast(double)x, cast(double)y, cast(double)z, cast(double)w);
        }
        
        /** Возвращает: Copy of this vector with real type components */
        Vector4r toVector4r()
        {
            return Vector4r(cast(real)x, cast(real)y, cast(real)z, cast(real)w);
        }
    
        /**
        Routine known as swizzling.
        Возвращает:
            Vector3 that has the same x, y, z components values.
        */
        Vector3 xyz()   { return Vector3(x,y,z); }    
        
        /**
        Routine known as swizzling.
        Assigns new values to x, y, z components corresponding to argument's components values.
        */
        void xyz(Vector3 v)    { x = v.x; y = v.y; z = v.z; }        

        char[] toString() { return format("[",x,", ",y,", ", z, ", ", w, "]"); }

    }
    
    public {

    /** Возвращает: Dot product between passed vectors. */
    real dot(Vector4 a, Vector4 b)
    {
        return a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w;
    }
    
    /** Возвращает: Outer product between passed vectors. */
    Matrix44 outer(Vector4 a, Vector4 b)
    {
        return Matrix44( a.x * b.x,  a.x * b.y,  a.x * b.z, a.x * b.w,
                         a.y * b.x,  a.y * b.y,  a.y * b.z, a.y * b.w,
                         a.z * b.x,  a.z * b.y,  a.z * b.z, a.z * b.w,
                         a.w * b.x,  a.w * b.y,  a.w * b.z, a.w * b.w);
    }

    alias EqualityByNorm!(Vector4).equal equal; /// Introduces approximate equality function for Vector4.
    alias Lerp!(Vector4).lerp lerp;             /// Introduces linear interpolation function for Vector4.
    
    } // end public
    
    /************************************************************************************
    _Quaternion.

    For formal definition of quaternion, meaning of possible operations and related
    information see $(LINK http://en.wikipedia.org/wiki/_Quaternion),
    $(LINK http://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation).
    *************************************************************************************/
    struct Quaternion
    {
        align(1)
        {
            union
            {
                struct
                {
                    float_t x; /// Components of quaternion.
                    float_t y; /// ditto
                    float_t z; /// ditto
                }
                
                Vector3 vector; /// Vector part. Can be used instead of explicit members x, y and z.
            }
    
            union
            {
                float_t w;      /// Scalar part.
                float_t scalar; /// Another name for _scalar part.
            }
        }
        
        /// Identity quaternion.
        static Quaternion identity;
        /// Quaternion with all components set to NaN.
        static Quaternion nan = { x: float_t.nan, y: float_t.nan, z: float_t.nan, w: float_t.nan };
    
        /**
        Methods to construct quaternion in C-like syntax.

        Примеры:
        ------------
        Quaternion q1 = Quaternion(0, 0, 0, 1);
        Quaternion q2 = Quaternion(Vector3(0, 0, 0), 1);
        Quaternion q3 = Quaternion(Matrix33.rotationY(PI / 6), 1);
        ------------
        */
        static Quaternion opCall(float_t x, float_t y, float_t z, float_t w)
        {
            Quaternion q;
            q.set(x, y, z, w);
            return q;
        }
    
        /** ditto */
        static Quaternion opCall(Vector3 vector, float_t scalar)
        {
            Quaternion q;
            q.set(vector, scalar);
            return q;
        }
        
        /** ditto */
        static Quaternion opCall(Matrix33 mat)
        {
            Quaternion q;
            q.set(mat);
            return q;
        }
        
        /** Sets values of components according to passed values. */
        void set(float_t x, float_t y, float_t z, float_t w)
        {
            this.x = x;
            this.y = y;
            this.z = z;
            this.w = w;
        }
    
        /** ditto */
        void set(Vector3 vector, float_t scalar)
        {
            this.vector = vector;
            this.scalar = scalar;
        }
        
        /**
        Sets quaternion, so that, it will represent same rotation as in mat matrix argument.
        Params:
            mat = Matrix to extract rotation from. Should be pure rotation matrix.
        Throws:
            AssertError if mat is not pure rotation matrix and module was compiled with
            contract checkings are enabled.
        */
        // NOTE: refactor to use mat.ptr instead of [] operator if
        // perforance will be unsatisfactory.
        void set(Matrix33 mat)
        in { assert(mat.isRotation()); }
        body
        {
            // Algorithm stolen from OGRE (http://ogre.sourceforge.net)
            real trace = mat[0, 0] + mat[1, 1] + mat[2, 2];
            real root;
        
            if ( trace > 0 )
            {
                // |w| > 1/2, may as well choose w > 1/2
                root = sqrt(trace + 1);  // 2w
                w = 0.5 * root;
                root = 0.5 / root;  // 1/(4w)
                x = (mat[2, 1] - mat[1, 2]) * root;
                y = (mat[0, 2] - mat[2, 0]) * root;
                z = (mat[1, 0] - mat[0, 1]) * root;
            }
            else
            {
                // |w| <= 1/2
                static int[3] next = [ 1, 2, 0 ];
                int i = 0;
                if ( mat[1, 1] > mat[0, 0] )
                    i = 1;
                if ( mat[2, 2] > mat[i, i] )
                    i = 2;
                int j = next[i];
                int k = next[j];
                
                root = sqrt(mat[i, i] - mat[j, j] - mat[k, k] + 1);
                *(&x + i) = 0.5 * root;
                root = 0.5 / root;
                /+
                 // User "Helmut Duregger reports this sometimes 
                 // causes mirroring of rotations, and that Ogre
                 // actually uses the uncommented version below.

                 w = (mat[j, k] - mat[k, j]) * root;
                 *(&x + j) = (mat[i, j] + mat[j, i]) * root;
                 *(&x + k) = (mat[i, k] + mat[k, i]) * root;
                +/
                w = (mat[k, j] - mat[j, k]) * root;
                *(&x + j) = (mat[j, i] + mat[i, j]) * root;
                *(&x + k) = (mat[k, i] + mat[i, k]) * root;

            }
        }
        
        /** Construct quaternion that represents rotation around corresponding axis. */
        static Quaternion rotationX(float_t radians)
        {
            Quaternion q;
            
            float_t s = sin(radians * 0.5f);
            float_t c = cos(radians * 0.5f);
            q.x = s;
            q.y = 0;
            q.z = 0;
            q.w = c;
            
            return q;
        }
    
        /** ditto */
        static Quaternion rotationY(float_t radians)
        {
            Quaternion q;
            
            float_t s = sin(radians * 0.5f);
            float_t c = cos(radians * 0.5f);
            q.x = 0;
            q.y = s;
            q.z = 0;
            q.w = c;
            
            return q;
        }
    
        /** ditto */
        static Quaternion rotationZ(float_t radians)
        {
            Quaternion q;
            
            float_t s = sin(radians * 0.5f);
            float_t c = cos(radians * 0.5f);
            q.x = 0;
            q.y = 0;
            q.z = s;
            q.w = c;
            
            return q;
        }
    
        /**
        Constructs quaternion that represents _rotation specified by euler angles passed as arguments.
        Order of _rotation application is: roll (Z axis), pitch (X axis), yaw (Y axis).
        */
        static Quaternion rotation(float_t yaw, float_t pitch, float_t roll)
        {
            return Quaternion.rotationY(yaw) * Quaternion.rotationX(pitch) * Quaternion.rotationZ(roll);
        }
    
        /**
        Constructs quaternion that represents _rotation around 'axis' _axis by 'radians' angle.
        */
        static Quaternion rotation(Vector3 axis, float_t radians)
        {
            Quaternion q;
            
            float_t s = sin(radians * 0.5f);
            float_t c = cos(radians * 0.5f);
            q.x = axis.x * s;
            q.y = axis.y * s;
            q.z = axis.z * s;
            q.w = c;
            
            return q;
        }
    
        /** Возвращает: Norm (also known as length, magnitude) of quaternion. */
        real norm()
        {
            return sqrt(x*x + y*y + z*z + w*w);
        }
    
        /**
        Возвращает: Square of vector's norm.
        
        Method doesn't need calculation of square root.
        */
        real normSquare()
        {
            return x*x + y*y + z*z + w*w;
        }
    
        /** Normalizes this quaternion. Возвращает: the original length. */
        real normalize()
        {
            float_t n = norm();
            assert( greater(n, 0) );
            *this /= n;
            return n;
        }
    
        /** Возвращает: Normalized copy of this quaternion. */
        Quaternion normalized()
        {
            float_t n = norm();
            assert( greater(n, 0) );
            return Quaternion(x / n, y / n, z / n, w / n);
        }
    
        /**
        Возвращает: Whether this quaternion is unit.
        Params:
            relprec, absprec = Parameters passed to equal function while comparison of
                               norm square and 1. Have the same meaning as in equal function.
        */
        bool isUnit(int relprec = defrelprec, int absprec = defabsprec)
        {
            return equal( normSquare(), 1, relprec, absprec );
        }
    
        /** Возвращает: Conjugate quaternion. */
        Quaternion conj()
        {
            return Quaternion(-vector, scalar);
        }
    
        /** Invert this quaternion. */
        void invert()
        {
            float_t n = norm();
            assert( greater(n, 0) );
            vector = -vector / n;
            scalar =  scalar / n;
        }
    
        /** Возвращает: Inverse copy of this quaternion. */
        Quaternion inverse()
        {
            float_t n = norm();
            assert( greater(n, 0) );
            return conj / n;
        }
        
        /**
        Возвращает: Extracted euler angle with the assumption that rotation is applied in order:
        _roll (Z axis), _pitch (X axis), _yaw (Y axis).
        */
        real yaw()
        {
            return atan2(2 * (w*y + x*z), w*w - x*x - y*y + z*z);
        }
    
        /** ditto */
        real pitch()
        {
            return asin(2 * (w*x - y*z));
        }
        
        /** ditto */
        real roll()
        {
            return atan2(2 * (w*z + x*y), w*w - x*x + y*y - z*z);
        }
        
        /** Возвращает: Whether all components are normalized. */
        bool isnormal()
        {
            return std.math.isnormal(x) && std.math.isnormal(y) && std.math.isnormal(z) && std.math.isnormal(w);
        }
    
        /** Возвращает: float_t pointer to x component of this vector. It's like a _ptr method for arrays. */
        float_t* ptr()
        {
            return cast(float_t*)(&x);
        }
    
        /** Возвращает: Component corresponded to passed index. */
        float_t opIndex(size_t ort)
        in { assert(ort <= Ort.W); }
        body
        {
            return (cast(float_t*)this)[cast(int)ort];
        }
    
        /** Assigns new _value to component corresponded to passed index. */
        void opIndexAssign(float_t value, size_t ort)
        in { assert(ort <= Ort.W); }
        body
        {
            (cast(float_t*)this)[cast(int)ort] = value;
        }
    
        /**
        Standard operators that have meaning exactly the same as for Vector4.
        
        Note that division operators do no cheks of value of k, so in case of division
        by 0 result vector will have infinity components. You can check this with isnormal()
        method.
        */
        bool opEquals(Quaternion q)
        {
            return x == q.x && y == q.y && z == q.z && w == q.w;
        }
    
        /** ditto */
        Quaternion opNeg()
        {
            return Quaternion(-x, -y, -z, -w);
        }
    
        /** ditto */
        Quaternion opAdd(Quaternion q)
        {
            return Quaternion(x + q.x, y + q.y, z + q.z, w + q.w);
        }
    
        /** ditto */
        void opAddAssign(Quaternion q)
        {
            x += q.x;
            y += q.y;
            z += q.z;
            w += q.w;
        }
    
        /** ditto */
        Quaternion opSub(Quaternion q)
        {
            return Quaternion(x - q.x, y - q.y, z - q.z, w - q.w);
        }
    
        /** ditto */
        void opSubAssign(Quaternion q)
        {
            x -= q.x;
            y -= q.y;
            z -= q.z;
            w -= q.w;
        }
    
        /** ditto */
        Quaternion opMul(float_t k)
        {
            return Quaternion(x * k, y * k, z * k, w * k);
        }

        /** ditto */
        Quaternion opMul_r(float_t k)
        {
            return Quaternion(x * k, y * k, z * k, w * k);
        }
    
        /** ditto */
        Quaternion opDiv(float_t k)
        {
            return Quaternion(x / k, y / k, z / k, w / k);
        }
    
        /** ditto */
        void opDivAssign(float_t k)
        {
            x /= k;
            y /= k;
            z /= k;
            w /= k;
        }
    
        /**
        Quaternion multiplication operators. Result of Q1*Q2 is quaternion that represents
        rotation which has meaning of application Q2's rotation and the Q1's rotation.
        */
        Quaternion opMul(Quaternion q)
        {
            return Quaternion(
                w * q.x + x * q.w + y * q.z - z * q.y,
                w * q.y + y * q.w + z * q.x - x * q.z,
                w * q.z + z * q.w + x * q.y - y * q.x,
                w * q.w - x * q.x - y * q.y - z * q.z );
        }
        
        /** ditto */
        void opMulAssign(Quaternion q)
        {
            set(w * q.x + x * q.w + y * q.z - z * q.y,
                w * q.y + y * q.w + z * q.x - x * q.z,
                w * q.z + z * q.w + x * q.y - y * q.x,
                w * q.w - x * q.x - y * q.y - z * q.z );
        }
    
        /** Возвращает: Copy of this quaternion with float type components. */
        Quaternionf toQuaternionf()
        {
            return Quaternionf(cast(float)x, cast(float)y, cast(float)z, cast(float)w);
        }
        
        /** Возвращает: Copy of this vector with double type components. */
        Quaterniond toQuaterniond()
        {
            return Quaterniond(cast(double)x, cast(double)y, cast(double)z, cast(double)w);
        }
        
        /** Возвращает: Copy of this vector with real type components. */
        Quaternionr toQuaternionr()
        {
            return Quaternionr(cast(real)x, cast(real)y, cast(real)z, cast(real)w);
        }

        char[] toString() { return format("[",x,", ",y,", ", z, ", ", w, "]"); }
    }    
    
    alias EqualityByNorm!(Quaternion).equal equal;  /// Introduces approximate equality function for Quaternion.
    alias Lerp!(Quaternion).lerp lerp;              /// Introduces linear interpolation function for Quaternion.
    
    /**
    Возвращает:
        Product of spherical linear interpolation between q0 and q1 with parameter t.
    Ссылки:
        $(LINK http://en.wikipedia.org/wiki/Slerp).
    */
    Quaternion slerp(Quaternion q0, Quaternion q1, real t)
    {
        real cosTheta = q0.x * q1.x + q0.y * q1.y + q0.z * q1.z + q0.w * q1.w;
        real theta = acos(cosTheta);
    
        if ( equal(fabs(theta), 0) )
            return lerp(q0, q1, t);
    
        real sinTheta = sin(theta);
        real coeff0 = sin((1 - t) * theta) / sinTheta;
        real coeff1 = sin(t * theta) / sinTheta;
        
        // Invert rotation if necessary
        if (cosTheta < 0.0f)
        {
            coeff0 = -coeff0;
            // taking the complement requires renormalisation
            Quaternion ret = coeff0 * q0 + coeff1 * q1;
            return ret.normalized();
        }
        
        return coeff0 * q0 + coeff1 * q1;    
    }
    
    /************************************************************************************
    2x2 Matrix.

    $(LINK http://en.wikipedia.org/wiki/Transformation_matrix).
    *************************************************************************************/
    struct Matrix22
    {
        align(1) union
        {
            struct
            {
                float_t m00, m10;
                float_t m01, m11;
            }
    
            float_t[2][2] m;
            Vector2[2]    v;
            float_t[4]    a;
        }
    
        /// Identity matrix.
        static Matrix22 identity = {
            1, 0,
            0, 1 };
        /// Matrix with all elements set to NaN.
        static Matrix22 nan = {
            float_t.nan, float_t.nan,
            float_t.nan, float_t.nan, };
        /// Matrix with all elements set to 0.
        static Matrix22 zero = {
            0, 0,
            0, 0 };
    
        /**
        Methods to construct matrix in C-like syntax.

        In case with array remember about column-major matrix memory layout,
        note last line with assert in example.

        Примеры:
        ------------
        Matrix22 mat1 = Matrix22(1,2,3,4);
        static float[9] a = [1,2,3,4];
        Matrix22 mat2 = Matrix22(a);

        assert(mat1 == mat2.transposed);
        ------------
        */
        static Matrix22 opCall(float_t m00, float_t m01,
                               float_t m10, float_t m11)
        {
            Matrix22 mat;
            mat.m00 = m00;        mat.m01 = m01;
            mat.m10 = m10;        mat.m11 = m11;
            return mat;
        }
        
        /** ditto */
        static Matrix22 opCall(float_t[4] a)
        {
            Matrix22 mat;
            mat.a[0..4] = a[0..4].dup;
            return mat;
        }
        
        /**
        Method to construct matrix in C-like syntax. Sets columns to passed vector
        arguments.
        */
        static Matrix22 opCall(Vector2 basisX, Vector2 basisY)
        {
            Matrix22 mat;
            mat.v[0] = basisX;
            mat.v[1] = basisY;
            return mat;
        }
    
        /** Sets elements to passed values. */
        void set(float_t m00, float_t m01,
                 float_t m10, float_t m11)
        {
            this.m00 = m00;        this.m01 = m01;
            this.m10 = m10;        this.m11 = m11;
        }
        
        /** Sets elements as _a copy of a contents. Remember about column-major matrix memory layout. */
        void set(float_t[4] a)
        {
            this.a[0..4] = a[0..4].dup;
        }
        
        /** Sets columns to passed basis vectors. */
        void set(Vector2 basisX, Vector2 basisY)
        {
            v[0] = basisX;
            v[1] = basisY;
        }
        
        /** Возвращает: Whether all components are normalized numbers. */
        bool isnormal()
        {
            return
                std.math.isnormal(m00) && std.math.isnormal(m01) &&
                std.math.isnormal(m10) && std.math.isnormal(m11);
        }
        
        /**
        Возвращает: Whether this matrix is identity.
        Params:
            relprec, absprec = Parameters passed to equal function while calculations.
                               Have the same meaning as in equal function.
        */
        bool isIdentity(int relprec = defrelprec, int absprec = defabsprec)
        {
            return equal(*this, identity, relprec, absprec);
        }
        
        /**
        Возвращает: Whether this matrix is zero.
        Params:
            relprec, absprec = Parameters passed to equal function while calculations.
                               Have the same meaning as in equal function.
        */
        bool isZero(int relprec = defrelprec, int absprec = defabsprec)
        {
            return equal(normSquare(), 0, relprec, absprec);
        }
        
        /**
        Возвращает: Whether this matrix is orthogonal.
        Params:
            relprec, absprec = Parameters passed to equal function while calculations.
                               Have the same meaning as in equal function.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Orthogonal_matrix).
        */
        bool isOrthogonal(int relprec = defrelprec, int absprec = defabsprec)
        {
            return equal(abs(cross(v[0],v[1])),1.0, relprec, absprec);
        }
        
        /**
        Возвращает: Whether this matrix represents pure rotation. I.e. hasn't scale admixture.
        Params:
            relprec, absprec = Parameters passed to equal function while calculations.
                               Have the same meaning as in equal function.
        */
        bool isRotation(int relprec = defrelprec, int absprec = defabsprec)
        {
            return isOrthogonal(relprec, absprec);
        }
    
        /** Constructs _scale matrix with _scale coefficients specified as arguments. */
        static Matrix22 scale(float_t x, float_t y)
        {
            Matrix22 mat = identity;
            with (mat)
            {
                m00 = x;
                m11 = y;
            }
    
            return mat;
        }
    
        /** Constructs _scale matrix with _scale coefficients specified as v's components. */
        static Matrix22 scale(Vector2 v)
        {
            return scale(v.x, v.y);
        }
    
        /** Construct matrix that represents rotation. */
        static Matrix22 rotation(float_t radians)
        {
            Matrix22 mat = identity;
            float_t c = cos(radians);
            float_t s = sin(radians);
            with (mat)
            {
                m00 = m11 = c;
                m10 = s;
                m01 = -s;
            }
    
            return mat;
        }
    
    
        /**
        Constructs matrix that represents _rotation same as in passed in complex number q.
        Method works with assumption that q is unit.
        Throws:
            AssertError on non-unit quaternion call attempt if you compile with
            contract checks enabled.
        */
/*
        static Matrix22 rotation(complex q)
        in { assert( q.isUnit() ); }
        body
        {
            float_t tx  = 2.f * q.x;
            float_t ty  = 2.f * q.y;
            float_t tz  = 2.f * q.z;
            float_t twx = tx * q.w;
            float_t twy = ty * q.w;
            float_t twz = tz * q.w;
            float_t txx = tx * q.x;
            float_t txy = ty * q.x;
            float_t txz = tz * q.x;
            float_t tyy = ty * q.y;
            float_t tyz = tz * q.y;
            float_t tzz = tz * q.z;
            
            Matrix22 mat;
            with (mat)
            {
                m00 = 1.f - (tyy + tzz);    m01 = txy + twz;            m02 = txz - twy;        
                m10 = txy - twz;            m11 = 1.f - (txx + tzz);    m12 = tyz + twx;        
                m20 = txz + twy;            m21 = tyz - twx;            m22 = 1.f - (txx + tyy);
            }
            
            return mat;
        }
*/        
        /**
        Возвращает: Inverse copy of this matrix.
        
        In case if this matrix is singular (i.e. determinant = 0) result matrix will has
        infinity elements. You can check this with isnormal() method.
        */
        Matrix22 inverse()
        {
            Matrix22 mat;
            
            mat.m00 =  m11;
            mat.m01 = -m01;
            mat.m10 = -m10;
            mat.m11 =  m00;

            real det = m00 * m11 - m01 * m10;
            
            for (int i = 4; i--; )
                mat.a[i] /= det;
    
            return mat;
        }
        
        /**
        Inverts this matrix.
        
        In case if matrix is singular (i.e. determinant = 0) result matrix will has
        infinity elements. You can check this with isnormal() method.
        */
        void invert()
        {
            real idet = 1.0/(m00 * m11 - m01 * m10);
            swap(m00,m11);
            m10 = -m10;
            m01 = -m01;
            (*this) *= idet;
        }
        
        /** Возвращает: Determinant */
        real determinant()
        {
            return m00 * m11 - m10 * m01;
        }
        
        /**
        Возвращает: Frobenius _norm of matrix. I.e. square root from sum of all elements' squares.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        real norm()
        {
            return sqrt( normSquare );
        }
        
        /**
        Возвращает: Square of Frobenius _norm of matrix. I.e. sum of all elements' squares.

        Method doesn't need calculation of square root.

        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        real normSquare()
        {
            real ret = 0;
            for (int i = 4; i--; )
            {
                real x = a[i];
                ret += x * x;
            }
            
            return ret;
        }
        
        /** Transposes this matrix. */
        void transpose()
        {
            /*           */        swap(m01, m10);
            /*           */        /*           */
        }
        
        /** Возвращает: Transposed copy of this matrix. */
        Matrix22 transposed()
        {
            return Matrix22(
                m00, m10,
                m01, m11 );
        }
        
        /**
        Makes polar decomposition of this matrix. Denote this matrix with 'M', in
        that case M=Q*S.
        
        Method is useful to decompose your matrix into rotation 'Q' and scale+shear 'S'. If you
        didn't use shear transform matrix S will be diagonal, i.e. represent scale. This can
        have many applications, particulary you can use method for suppressing errors in pure
        rotation matrices after long multiplication chain.
        
        Params:
            Q = Output matrix, will be orthogonal after decomposition.
                Argument shouldn't be null.
            S = Output matrix, will be symmetric non-negative definite after
                decomposition. Argument shouldn't be null.

        Примеры:
        --------
        Matrix22 Q, S;
        Matrix22 rot = Matrix22.rotationZ(PI / 7);
        Matrix22 scale = Matrix22.scale(-1, 2, 3);
        Matrix22 composition = rot * scale;
        composition.polarDecomposition(Q, S);    
        assert( equal(Q * S, composition) );
        --------

        Ссылки:
            $(LINK http://www.cs.wisc.edu/graphics/Courses/cs-838-2002/Papers/polar-decomp.pdf)
        */
        void polarDecomposition(out Matrix22 Q, out Matrix22 S)
            out { assert(Q.isRotation(), 
                         "(postcondition) Q not a rotation:\n" ~ Q.toString); }
        body
        {
            // TODO: Optimize, we need only sign of determinant, not value
            if (determinant < 0)
                Q = (*this) * (-identity);
            else
                Q = *this;
                
            // use scaled Newton method to orthonormalize Q
            int maxIterations = 100; // avoid deadlock
            Matrix22 Qp = Q;
            Q = 0.5f * (Q + Q.transposed.inverse);
            while (!(Q - Qp).isZero && maxIterations--)
            {
                Matrix22 Qinv = Q.inverse;
                real gamma = sqrt( Qinv.norm / Q.norm );
                Qp = Q;
                Q = 0.5f * (gamma * Q + (1 / gamma) * Qinv.transposed);
            }
            
            assert( maxIterations != -1 );
            
            S = Q.transposed * (*this);
        }
    
        /**
        Standard operators that have intuitive meaning, same as in classical math.
        
        Note that division operators do no cheks of value of k, so in case of division
        by 0 result matrix will have infinity components. You can check this with isnormal()
        method.
        */
        Matrix22 opNeg()
        {
            return Matrix22(-m00, -m01,
                            -m10, -m11);
        }
    
        /** ditto */
        Matrix22 opAdd(Matrix22 mat)
        {
            return Matrix22(m00 + mat.m00, m01 + mat.m01,
                            m10 + mat.m10, m11 + mat.m11);
        }
    
        /** ditto */
        void opAddAssign(Matrix22 mat)
        {
            m00 += mat.m00; m01 += mat.m01;
            m10 += mat.m10; m11 += mat.m11;
        }
    
        /** ditto */
        Matrix22 opSub(Matrix22 mat)
        {
            return Matrix22(m00 - mat.m00, m01 - mat.m01,
                            m10 - mat.m10, m11 - mat.m11);
        }
    
        /** ditto */
        void opSubAssign(Matrix22 mat)
        {
            m00 -= mat.m00; m01 -= mat.m01;
            m10 -= mat.m10; m11 -= mat.m11;
        }
    
        /** ditto */
        Matrix22 opMul(float_t k)
        {
            return Matrix22(m00 * k, m01 * k,
                            m10 * k, m11 * k);
        }
    
        /** ditto */
        void opMulAssign(float_t k)
        {
            m00 *= k; m01 *= k;
            m10 *= k; m11 *= k;
        }
    
        /** ditto */
        Matrix22 opMul_r(float_t k)
        {
            return Matrix22(m00 * k, m01 * k,
                            m10 * k, m11 * k);
        }
    
        /** ditto */
        Matrix22 opDiv(float_t k)
        {
            return Matrix22(m00 / k, m01 / k,
                            m10 / k, m11 / k);
        }
    
        /** ditto */
        void opDivAssign(float_t k)
        {
            m00 /= k; m01 /= k;
            m10 /= k; m11 /= k;
        }
    
        /** ditto */
        bool opEquals(Matrix22 mat)
        {
            return m00 == mat.m00 && m01 == mat.m01 &&
                   m10 == mat.m10 && m11 == mat.m11;
        }

        /** ditto */
        Matrix22 opMul(Matrix22 mat)
        {
            return Matrix22(
                m00 * mat.m00 + m01 * mat.m10,   m00 * mat.m01 + m01 * mat.m11,
                m10 * mat.m00 + m11 * mat.m10,   m10 * mat.m01 + m11 * mat.m11 );
        }
    
        /** ditto */
        void opMulAssign(Matrix22 mat)
        {
            *this = *this * mat;
        }
    
        /** ditto */
        Vector2 opMul(Vector2 v)
        {
            return Vector2(v.x * m00 + v.y * m01,
                           v.x * m10 + v.y * m11 );
        }
    
        /** Возвращает: Element at row'th _row and col'th column. */
        float_t opIndex(uint row, uint col)
        in { assert( row < 2 && col < 2 ); }
        body
        {
            return m[col][row];
        }
    
        /** Assigns value f to element at row'th _row and col'th column. */
        void opIndexAssign(float_t f, uint row, uint col)
        in { assert( row < 2 && col < 2 ); }
        body
        {
            m[col][row] = f;
        }
        
        /** Возвращает: Vector representing col'th column. */
        Vector2 opIndex(uint col)
        in { assert( col < 2 ); }
        body
        {
            return v[col];
        }
        
        /** Replaces elements in col'th column with v's values. */
        void opIndexAssign(Vector2 v, uint col)
        in { assert( col < 2 ); }
        body
        {
            return this.v[col] = v;
        }
    
        /**
        Возвращает: float_t pointer to [0,0] element of this matrix. It's like a _ptr method for arrays.
        
        Remember about column-major matrix memory layout.
        */
        float_t* ptr()
        {
            return a.ptr;
        }
        
        /** Возвращает: Copy of this matrix with float type elements. */
        Matrix22f toMatrix22f()
        {
            return Matrix22f(
                cast(float)m00, cast(float)m01,
                cast(float)m10, cast(float)m11 );
        }
        
        /** Возвращает: Copy of this matrix with double type elements. */
        Matrix22d toMatrix22d()
        {
            return Matrix22d(
                cast(double)m00, cast(double)m01,
                cast(double)m10, cast(double)m11 );
        }
        
        /** Возвращает: Copy of this matrix with real type elements. */
        Matrix22r toMatrix22r()
        {
            return Matrix22r(
                cast(real)m00, cast(real)m01,
                cast(real)m10, cast(real)m11     );
        }

        char[] toString() { 
            return format("[" ,m00, ", " ,m01, ",\n",
                          " " ,m10, ", " ,m11, "]");
        }
    }
    
    
    alias EqualityByNorm!(Matrix22).equal equal; /// Introduces approximate equality function for Matrix22.
    alias Lerp!(Matrix22).lerp lerp;             /// Introduces linear interpolation function for Matrix22.

    /************************************************************************************
    3x3 Matrix.

    For formal definition of quaternion, meaning of possible operations and related
    information see $(LINK http://en.wikipedia.org/wiki/Matrix(mathematics)),
    $(LINK http://en.wikipedia.org/wiki/Transformation_matrix).
    *************************************************************************************/
    struct Matrix33
    {
        align(1) union
        {
            struct
            {
                float_t m00, m10, m20;
                float_t m01, m11, m21;
                float_t m02, m12, m22;
            }
    
            float_t[3][3] m;
            Vector3[3]    v;
            float_t[9]    a;
        }
    
        /// Identity matrix.
        static Matrix33 identity = {
            1, 0, 0,
            0, 1, 0,
            0, 0, 1 };
        /// Matrix with all elements set to NaN.
        static Matrix33 nan = {
            float_t.nan, float_t.nan, float_t.nan,
            float_t.nan, float_t.nan, float_t.nan,
            float_t.nan, float_t.nan, float_t.nan };
        /// Matrix with all elements set to 0.
        static Matrix33 zero = {
            0, 0, 0,
            0, 0, 0,
            0, 0, 0 };
    
        /**
        Methods to construct matrix in C-like syntax.

        In case with array remember about column-major matrix memory layout,
        note last line with assert in example.

        Примеры:
        ------------
        Matrix33 mat1 = Matrix33(1,2,3,4,5,6,7,8,9);
        static float[9] a = [1,2,3,4,5,6,7,8,9];
        Matrix33 mat2 = Matrix33(a);

        assert(mat1 == mat2.transposed);
        ------------
        */
        static Matrix33 opCall(float_t m00, float_t m01, float_t m02,
                               float_t m10, float_t m11, float_t m12,
                               float_t m20, float_t m21, float_t m22)
        {
            Matrix33 mat;
            mat.m00 = m00;        mat.m01 = m01;        mat.m02 = m02;
            mat.m10 = m10;        mat.m11 = m11;        mat.m12 = m12;
            mat.m20 = m20;        mat.m21 = m21;        mat.m22 = m22;
            return mat;
        }
        
        /** ditto */
        static Matrix33 opCall(float_t[9] a)
        {
            Matrix33 mat;
            mat.a[0..9] = a[0..9].dup;
            return mat;
        }
        
        /**
        Method to construct matrix in C-like syntax. Sets columns to passed vector
        arguments.
        */
        static Matrix33 opCall(Vector3 basisX, Vector3 basisY, Vector3 basisZ)
        {
            Matrix33 mat;
            mat.v[0] = basisX;
            mat.v[1] = basisY;
            mat.v[2] = basisZ;
            return mat;
        }
    
        /** Sets elements to passed values. */
        void set(float_t m00, float_t m01, float_t m02,
                 float_t m10, float_t m11, float_t m12,
                 float_t m20, float_t m21, float_t m22)
        {
            this.m00 = m00;        this.m01 = m01;        this.m02 = m02;
            this.m10 = m10;        this.m11 = m11;        this.m12 = m12;
            this.m20 = m20;        this.m21 = m21;        this.m22 = m22;
        }
        
        /** Sets elements as _a copy of a contents. Remember about column-major matrix memory layout. */
        void set(float_t[9] a)
        {
            this.a[0..9] = a[0..9].dup;
        }
        
        /** Sets columns to passed basis vectors. */
        void set(Vector3 basisX, Vector3 basisY, Vector3 basisZ)
        {
            v[0] = basisX;
            v[1] = basisY;
            v[2] = basisZ;
        }
        
        /** Возвращает: Whether all components are normalized numbers. */
        bool isnormal()
        {
            return
                std.math.isnormal(m00) && std.math.isnormal(m01) && std.math.isnormal(m02) &&
                std.math.isnormal(m10) && std.math.isnormal(m11) && std.math.isnormal(m12) &&
                std.math.isnormal(m20) && std.math.isnormal(m21) && std.math.isnormal(m22);
        }
        
        /**
        Возвращает: Whether this matrix is identity.
        Params:
            relprec, absprec = Parameters passed to equal function while calculations.
                               Have the same meaning as in equal function.
        */
        bool isIdentity(int relprec = defrelprec, int absprec = defabsprec)
        {
            return equal(*this, identity, relprec, absprec);
        }
        
        /**
        Возвращает: Whether this matrix is zero.
        Params:
            relprec, absprec = Parameters passed to equal function while calculations.
                               Have the same meaning as in equal function.
        */
        bool isZero(int relprec = defrelprec, int absprec = defabsprec)
        {
            return equal(normSquare(), 0, relprec, absprec);
        }
        
        /**
        Возвращает: Whether this matrix is orthogonal.
        Params:
            relprec, absprec = Parameters passed to equal function while calculations.
                               Have the same meaning as in equal function.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Orthogonal_matrix).
        */
        bool isOrthogonal(int relprec = defrelprec, int absprec = defabsprec)
        {
            return isBasisOrthonormal(v[0], v[1], v[2], relprec, absprec);
        }
        
        /**
        Возвращает: Whether this matrix represents pure rotation. I.e. hasn't scale admixture.
        Params:
            relprec, absprec = Parameters passed to equal function while calculations.
                               Have the same meaning as in equal function.
        */
        bool isRotation(int relprec = defrelprec, int absprec = defabsprec)
        {
            return isOrthogonal(relprec, absprec) && equal(v[2], cross(v[0], v[1]), relprec, absprec);
        }
    
        /** Constructs _scale matrix with _scale coefficients specified as arguments. */
        static Matrix33 scale(float_t x, float_t y, float_t z)
        {
            Matrix33 mat = identity;
            with (mat)
            {
                m00 = x;
                m11 = y;
                m22 = z;
            }
    
            return mat;
        }
    
        /** Constructs _scale matrix with _scale coefficients specified as v's components. */
        static Matrix33 scale(Vector3 v)
        {
            return scale(v.x, v.y, v.z);
        }
    
        /** Construct matrix that represents rotation around corresponding axis. */
        static Matrix33 rotationX(float_t radians)
        {
            Matrix33 mat = identity;
            float_t c = cos(radians);
            float_t s = sin(radians);
            with (mat)
            {
                m11 = m22 = c;
                m21 = s;
                m12 = -s;            
            }
    
            return mat;
        }
    
        /** ditto */
        static Matrix33 rotationY(float_t radians)
        {
            Matrix33 mat = identity;
            float_t c = cos(radians);
            float_t s = sin(radians);
            with (mat)
            {
                m00 = m22 = c;
                m20 = -s;
                m02 = s;            
            }
    
            return mat;
        }
    
        /** ditto */
        static Matrix33 rotationZ(float_t radians)
        {
            Matrix33 mat = identity;
            float_t c = cos(radians);
            float_t s = sin(radians);
            with (mat)
            {
                m00 = m11 = c;
                m10 = s;
                m01 = -s;            
            }
    
            return mat;
        }
    
        /**
        Constructs matrix that represents _rotation specified by euler angles passed as arguments.
        Order of _rotation application is: roll (Z axis), pitch (X axis), yaw (Y axis).
        */
        static Matrix33 rotation(float_t yaw, float_t pitch, float_t roll)
        {
            return Matrix33.rotationY(yaw) * Matrix33.rotationX(pitch) * Matrix33.rotationZ(roll);
        }
    
        /**
        Constructs matrix that represents _rotation specified by axis and angle.
        Method works with assumption that axis is unit vector.        
        Throws:
            AssertError on non-unit axis call attempt if module was compiled with
            contract checks enabled.
        */
        static Matrix33 rotation(Vector3 axis, float_t radians)
        in { assert( axis.isUnit() ); }
        body
        {
            real c = cos(radians);
            real s = sin(radians);
            real cc = 1.0 - c;
            real x2 = axis.x * axis.x;
            real y2 = axis.y * axis.y;
            real z2 = axis.z * axis.z;
            real xycc = axis.x * axis.y * cc;
            real xzcc = axis.x * axis.z * cc;
            real yzcc = axis.y * axis.z * cc;
            real xs = axis.x * s;
            real ys = axis.y * s;
            real zs = axis.z * s;
    
            Matrix33 mat;
            with (mat)
            {
                m00 = x2 * cc + c;      m01 = xycc - zs;        m02 = xzcc + ys;
                m10 = xycc + zs;        m11 = y2 * cc + c;      m12 = yzcc - xs;
                m20 = xzcc - ys;        m21 = yzcc + xs;        m22 = z2 * cc + c;
            }
    
            return mat;
        }
        
        /**
        Constructs matrix that represents _rotation same as in passed quaternion q.
        Method works with assumption that q is unit.
        Throws:
            AssertError on non-unit quaternion call attempt if you compile with
            contract checks enabled.
        */
        static Matrix33 rotation(Quaternion q)
        in { assert( q.isUnit() ); }
        body
        {
            float_t tx  = 2.f * q.x;
            float_t ty  = 2.f * q.y;
            float_t tz  = 2.f * q.z;
            float_t twx = tx * q.w;
            float_t twy = ty * q.w;
            float_t twz = tz * q.w;
            float_t txx = tx * q.x;
            float_t txy = ty * q.x;
            float_t txz = tz * q.x;
            float_t tyy = ty * q.y;
            float_t tyz = tz * q.y;
            float_t tzz = tz * q.z;
            
            Matrix33 mat;
            with (mat)
            {
                m00 = 1.f - (tyy + tzz);    m01 = txy - twz;            m02 = txz + twy;
                m10 = txy + twz;            m11 = 1.f - (txx + tzz);    m12 = tyz - twx;
                m20 = txz - twy;            m21 = tyz + twx;            m22 = 1.f - (txx + tyy);
            }
            
            return mat;
        }
        
        /**
        Возвращает: Inverse copy of this matrix.
        
        In case if this matrix is singular (i.e. determinant = 0) result matrix will has
        infinity elements. You can check this with isnormal() method.
        */
        Matrix33 inverse()
        {
            Matrix33 mat;
            
            mat.m00 = m11 * m22 - m12 * m21;
            mat.m01 = m02 * m21 - m01 * m22;
            mat.m02 = m01 * m12 - m02 * m11;
            mat.m10 = m12 * m20 - m10 * m22;
            mat.m11 = m00 * m22 - m02 * m20;
            mat.m12 = m02 * m10 - m00 * m12;
            mat.m20 = m10 * m21 - m11 * m20;
            mat.m21 = m01 * m20 - m00 * m21;
            mat.m22 = m00 * m11 - m01 * m10;
            
            real det = m00 * mat.m00 + m01 * mat.m10 + m02 * mat.m20;
            
            for (int i = 9; i--; )
                mat.a[i] /= det;
    
            return mat;
        }
        
        /**
        Inverts this matrix.
        
        In case if matrix is singular (i.e. determinant = 0) result matrix will has
        infinity elements. You can check this with isnormal() method.
        */
        void invert()
        {
            *this = inverse();
        }
        
        /** Возвращает: Determinant */
        real determinant()
        {
            real cofactor00 = m11 * m22 - m12 * m21;
            real cofactor10 = m12 * m20 - m10 * m22;
            real cofactor20 = m10 * m21 - m11 * m20;
            
            return m00 * cofactor00 + m01 * cofactor10 + m02 * cofactor20;;
        }
        
        /**
        Возвращает: Frobenius _norm of matrix. I.e. square root from sum of all elements' squares.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        real norm()
        {
            return sqrt( normSquare );
        }
        
        /**
        Возвращает: Square of Frobenius _norm of matrix. I.e. sum of all elements' squares.

        Method doesn't need calculation of square root.

        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        real normSquare()
        {
            real ret = 0;
            for (int i = 9; i--; )
            {
                real x = a[i];
                ret += x * x;
            }
            
            return ret;
        }
        
        /** Transposes this matrix. */
        void transpose()
        {
            /*           */        swap(m01, m10);        swap(m02, m20);
            /*           */        /*           */        swap(m12, m21);
            /*           */        /*           */        /*           */
        }
        
        /** Возвращает: Transposed copy of this matrix. */
        Matrix33 transposed()
        {
            return Matrix33(
                m00, m10, m20,
                m01, m11, m21,
                m02, m12, m22 );
        }
        
        /**
        Makes polar decomposition of this matrix. Denote this matrix with 'M', in
        that case M=Q*S.
        
        Method is useful to decompose your matrix into rotation 'Q' and scale+shear 'S'. If you
        didn't use shear transform matrix S will be diagonal, i.e. represent scale. This can
        have many applications, particulary you can use method for suppressing errors in pure
        rotation matrices after long multiplication chain.
        
        Params:
            Q = Output matrix, will be orthogonal after decomposition.
                Argument shouldn't be null.
            S = Output matrix, will be symmetric non-negative definite after
                decomposition. Argument shouldn't be null.

        Примеры:
        --------
        Matrix33 Q, S;
        Matrix33 rot = Matrix33.rotationZ(PI / 7);
        Matrix33 scale = Matrix33.scale(-1, 2, 3);
        Matrix33 composition = rot * scale;
        composition.polarDecomposition(Q, S);    
        assert( equal(Q * S, composition) );
        --------

        Ссылки:
            $(LINK http://www.cs.wisc.edu/graphics/Courses/cs-838-2002/Papers/polar-decomp.pdf)
        */
        void polarDecomposition(out Matrix33 Q, out Matrix33 S)
        out { assert(Q.isRotation()); }
        body
        {
            // TODO: Optimize, we need only sign of determinant, not value
            if (determinant < 0)
                Q = (*this) * (-identity);
            else
                Q = *this;
                
            // use scaled Newton method to orthonormalize Q
            int maxIterations = 100; // avoid deadlock
            Matrix33 Qp = Q;
            Q = 0.5f * (Q + Q.transposed.inverse);
            while (!(Q - Qp).isZero && maxIterations--)
            {
                Matrix33 Qinv = Q.inverse;
                real gamma = sqrt( Qinv.norm / Q.norm );
                Qp = Q;
                Q = 0.5f * (gamma * Q + (1 / gamma) * Qinv.transposed);
            }
            
            assert( maxIterations != -1 );
            
            S = Q.transposed * (*this);
        }
    
        /**
        Standard operators that have intuitive meaning, same as in classical math.
        
        Note that division operators do no cheks of value of k, so in case of division
        by 0 result matrix will have infinity components. You can check this with isnormal()
        method.
        */
        Matrix33 opNeg()
        {
            return Matrix33(-m00, -m01, -m02,
                            -m10, -m11, -m12,
                            -m20, -m21, -m22);
        }
    
        /** ditto */
        Matrix33 opAdd(Matrix33 mat)
        {
            return Matrix33(m00 + mat.m00, m01 + mat.m01, m02 + mat.m02,
                            m10 + mat.m10, m11 + mat.m11, m12 + mat.m12,
                            m20 + mat.m20, m21 + mat.m21, m22 + mat.m22);
        }
    
        /** ditto */
        void opAddAssign(Matrix33 mat)
        {
            m00 += mat.m00; m01 += mat.m01; m02 += mat.m02;
            m10 += mat.m10; m11 += mat.m11; m12 += mat.m12;
            m20 += mat.m20; m21 += mat.m21; m22 += mat.m22;
        }
    
        /** ditto */
        Matrix33 opSub(Matrix33 mat)
        {
            return Matrix33(m00 - mat.m00, m01 - mat.m01, m02 - mat.m02,
                            m10 - mat.m10, m11 - mat.m11, m12 - mat.m12,
                            m20 - mat.m20, m21 - mat.m21, m22 - mat.m22);
        }
    
        /** ditto */
        void opSubAssign(Matrix33 mat)
        {
            m00 -= mat.m00; m01 -= mat.m01; m02 -= mat.m02;
            m10 -= mat.m10; m11 -= mat.m11; m12 -= mat.m12;
            m20 -= mat.m20; m21 -= mat.m21; m22 -= mat.m22;        
        }
    
        /** ditto */
        Matrix33 opMul(float_t k)
        {
            return Matrix33(m00 * k, m01 * k, m02 * k,
                            m10 * k, m11 * k, m12 * k,
                            m20 * k, m21 * k, m22 * k);
        }
    
        /** ditto */
        void opMulAssign(float_t k)
        {
            m00 *= k; m01 *= k; m02 *= k;
            m10 *= k; m11 *= k; m12 *= k;
            m20 *= k; m21 *= k; m22 *= k;
        }
    
        /** ditto */
        Matrix33 opMul_r(float_t k)
        {
            return Matrix33(m00 * k, m01 * k, m02 * k,
                            m10 * k, m11 * k, m12 * k,
                            m20 * k, m21 * k, m22 * k);
        }
    
        /** ditto */
        Matrix33 opDiv(float_t k)
        {
            
            return Matrix33(m00 / k, m01 / k, m02 / k,
                            m10 / k, m11 / k, m12 / k,
                            m20 / k, m21 / k, m22 / k);
        }
    
        /** ditto */
        void opDivAssign(float_t k)
        {
            m00 /= k; m01 /= k; m02 /= k;
            m10 /= k; m11 /= k; m12 /= k;
            m20 /= k; m21 /= k; m22 /= k;
        }
    
        /** ditto */
        bool opEquals(Matrix33 mat)
        {
            return m00 == mat.m00 && m01 == mat.m01 && m02 == mat.m02 &&
                   m10 == mat.m10 && m11 == mat.m11 && m12 == mat.m12 &&
                   m20 == mat.m20 && m21 == mat.m21 && m22 == mat.m22;
        }

        /** ditto */
        Matrix33 opMul(Matrix33 mat)
        {
            return Matrix33(m00 * mat.m00 + m01 * mat.m10 + m02 * mat.m20,
                            m00 * mat.m01 + m01 * mat.m11 + m02 * mat.m21,
                            m00 * mat.m02 + m01 * mat.m12 + m02 * mat.m22,
                            m10 * mat.m00 + m11 * mat.m10 + m12 * mat.m20,
                            m10 * mat.m01 + m11 * mat.m11 + m12 * mat.m21,
                            m10 * mat.m02 + m11 * mat.m12 + m12 * mat.m22,
                            m20 * mat.m00 + m21 * mat.m10 + m22 * mat.m20,
                            m20 * mat.m01 + m21 * mat.m11 + m22 * mat.m21,
                            m20 * mat.m02 + m21 * mat.m12 + m22 * mat.m22 );
        }
    
        /** ditto */
        void opMulAssign(Matrix33 mat)
        {
            *this = *this * mat;
        }
    
        /** ditto */
        Vector3 opMul(Vector3 v)
        {
            return Vector3(v.x * m00 + v.y * m01 + v.z * m02,
                           v.x * m10 + v.y * m11 + v.z * m12,
                           v.x * m20 + v.y * m21 + v.z * m22 );
        }
    
        /** Возвращает: Element at row'th _row and col'th column. */
        float_t opIndex(uint row, uint col)
        in { assert( row < 3 && col < 3 ); }
        body
        {
            return m[col][row];
        }
    
        /** Assigns value f to element at row'th _row and col'th column. */
        void opIndexAssign(float_t f, uint row, uint col)
        in { assert( row < 3 && col < 3 ); }
        body
        {
            m[col][row] = f;
        }
        
        /** Возвращает: Vector representing col'th column. */
        Vector3 opIndex(uint col)
        in { assert( col < 3 ); }
        body
        {
            return v[col];
        }
        
        /** Replaces elements in col'th column with v's values. */
        void opIndexAssign(Vector3 v, uint col)
        in { assert( col < 3 ); }
        body
        {
            return this.v[col] = v;
        }
    
        /**
        Возвращает: float_t pointer to [0,0] element of this matrix. It's like a _ptr method for arrays.
        
        Remember about column-major matrix memory layout.
        */
        float_t* ptr()
        {
            return a.ptr;
        }
        
        /** Возвращает: Copy of this matrix with float type elements. */
        Matrix33f toMatrix33f()
        {
            return Matrix33f(
                cast(float)m00, cast(float)m01, cast(float)m02,
                cast(float)m10, cast(float)m11, cast(float)m12,
                cast(float)m20, cast(float)m21, cast(float)m22 );
        }
        
        /** Возвращает: Copy of this matrix with double type elements. */
        Matrix33d toMatrix33d()
        {
            return Matrix33d(
                cast(double)m00, cast(double)m01, cast(double)m02,
                cast(double)m10, cast(double)m11, cast(double)m12,
                cast(double)m20, cast(double)m21, cast(double)m22 );
        }
        
        /** Возвращает: Copy of this matrix with real type elements. */
        Matrix33r toMatrix33r()
        {
            return Matrix33r(
                cast(real)m00, cast(real)m01, cast(real)m02,
                cast(real)m10, cast(real)m11, cast(real)m12,
                cast(real)m20, cast(real)m21, cast(real)m22 );
        }

        char[] toString() { 
            return format("[" ,m00, ", " ,m01, ", " ,m02, ",\n",
                          " " ,m10, ", " ,m11, ", " ,m12, ",\n",
                          " " ,m20, ", " ,m21, ", " ,m22, "]");
        }
    }
    
    
    alias EqualityByNorm!(Matrix33).equal equal; /// Introduces approximate equality function for Matrix33.
    alias Lerp!(Matrix33).lerp lerp;             /// Introduces linear interpolation function for Matrix33.
    
    /************************************************************************************
    4x4 Matrix.

    Helix matrices uses column-major memory layout.
    *************************************************************************************/
    struct Matrix44
    {
        align (1) union
        {
            struct
            {
                float_t m00, m10, m20, m30;
                float_t m01, m11, m21, m31;
                float_t m02, m12, m22, m32;
                float_t m03, m13, m23, m33;
            }
    
            float_t[4][4] m;
            float_t[16]   a;
            Vector4[4]    v;
        }
    
        /// Identity matrix.
        static Matrix44 identity = {
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1 };
        /// Matrix with all elements set to NaN.
        static Matrix44 nan = {
            float_t.nan, float_t.nan, float_t.nan, float_t.nan,
            float_t.nan, float_t.nan, float_t.nan, float_t.nan,
            float_t.nan, float_t.nan, float_t.nan, float_t.nan,
            float_t.nan, float_t.nan, float_t.nan, float_t.nan };
        /// Matrix with all elements set to 0.
        static Matrix44 zero = {
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0 };
    
        /**
        Methods to construct matrix in C-like syntax.

        In case with array remember about column-major matrix memory layout,
        note last line with assert in example - it'll be passed.

        Примеры:
        ------------
        Matrix33 mat1 = Matrix33(
             1,  2,  3,  4,
             5,  6,  7,  8,
             9, 10, 11, 12,
            13, 14, 15, 16 );
            
        static float[16] a = [
             1,  2,  3,  4,
             5,  6,  7,  8,
             9, 10, 11, 12,
            13, 14, 15, 16 ];
        Matrix33 mat2 = Matrix33(a);

        assert(mat1 == mat2.transposed);
        ------------
        */
        static Matrix44 opCall(float_t m00, float_t m01, float_t m02, float_t m03,
                               float_t m10, float_t m11, float_t m12, float_t m13,
                               float_t m20, float_t m21, float_t m22, float_t m23,
                               float_t m30, float_t m31, float_t m32, float_t m33)
        {
            Matrix44 mat;
            mat.m00 = m00;        mat.m01 = m01;        mat.m02 = m02;        mat.m03 = m03;
            mat.m10 = m10;        mat.m11 = m11;        mat.m12 = m12;        mat.m13 = m13;
            mat.m20 = m20;        mat.m21 = m21;        mat.m22 = m22;        mat.m23 = m23;
            mat.m30 = m30;        mat.m31 = m31;        mat.m32 = m32;        mat.m33 = m33;
            return mat;
        }
        
        /** ditto */
        static Matrix44 opCall(float_t[16] a)
        {
            Matrix44 mat;
            mat.a[0..16] = a[0..16].dup;
            return mat;
        }
        
        /**
        Method to construct matrix in C-like syntax. Sets columns to passed vector
        arguments.
        */
        static Matrix44 opCall(Vector4 basisX, Vector4 basisY, Vector4 basisZ,
                               Vector4 basisW = Vector4(0, 0, 0, 1))
        {
            Matrix44 mat;
            mat.v[0] = basisX;
            mat.v[1] = basisY;
            mat.v[2] = basisZ;
            mat.v[3] = basisW;
            return mat;
        }
        
        /**
        Method to construct matrix in C-like syntax. Constructs affine transform
        matrix based on passed vector arguments.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Affine_transformation).
        */
        static Matrix44 opCall(Vector3 basisX, Vector3 basisY, Vector3 basisZ,
                               Vector3 translation = Vector3(0, 0, 0))
        {
            return opCall(Vector4(basisX, 0), Vector4(basisX, 0), Vector4(basisX, 0), Vector4(translation, 1));
        }
    
        /** Sets elements to passed values. */
        void set(float_t m00, float_t m01, float_t m02, float_t m03,
                 float_t m10, float_t m11, float_t m12, float_t m13,
                 float_t m20, float_t m21, float_t m22, float_t m23,
                 float_t m30, float_t m31, float_t m32, float_t m33)
        {
            this.m00 = m00;        this.m01 = m01;        this.m02 = m02;        this.m03 = m03;
            this.m10 = m10;        this.m11 = m11;        this.m12 = m12;        this.m13 = m13;
            this.m20 = m20;        this.m21 = m21;        this.m22 = m22;        this.m23 = m23;
            this.m30 = m30;        this.m31 = m31;        this.m32 = m32;        this.m33 = m33;    
        }
        
        /** Sets elements as _a copy of a contents. Remember about column-major matrix memory layout. */
        void set(float_t[16] a)
        {
            this.a[0..16] = a[0..16].dup;
        }
    
        /** Sets columns to passed basis vectors. */
        void set(Vector4 basisX, Vector4 basisY, Vector4 basisZ,
                 Vector4 basisW = Vector4(0, 0, 0, 1))
        {
            v[0] = basisX;
            v[1] = basisY;
            v[2] = basisZ;
            v[3] = basisW;
        }

        /** Возвращает: Whether all components are normalized numbers. */
        bool isnormal()
        {
            return
                std.math.isnormal(m00) && std.math.isnormal(m01) && std.math.isnormal(m02) && std.math.isnormal(m03) &&
                std.math.isnormal(m10) && std.math.isnormal(m11) && std.math.isnormal(m12) && std.math.isnormal(m13) &&
                std.math.isnormal(m20) && std.math.isnormal(m21) && std.math.isnormal(m22) && std.math.isnormal(m23) &&
                std.math.isnormal(m30) && std.math.isnormal(m31) && std.math.isnormal(m32) && std.math.isnormal(m33);
        }

        /**
        Возвращает: Whether this matrix is identity.
        Params:
            relprec, absprec = Parameters passed to equal function while calculations.
                               Have the same meaning as in equal function.
        */
        bool isIdentity(int relprec = defrelprec, int absprec = defabsprec)
        {
            return equal(*this, identity, relprec, absprec);
        }
        
        /**
        Возвращает: Whether this matrix is zero.
        Params:
            relprec, absprec = Parameters passed to equal function while calculations.
                        Has the same meaning as in equal function.
        */
        bool isZero(int relprec = defrelprec, int absprec = defabsprec)
        {
            return equal(normSquare(), 0, relprec, absprec);
        }
        
        /**
        Resets this matrix to affine transform matrix based on passed
        vector arguments.
        */
        void set(Vector3 basisX, Vector3 basisY, Vector3 basisZ,
                 Vector3 translation = Vector3(0, 0, 0))
        {
            v[0] = Vector4(basisX, 0);
            v[1] = Vector4(basisY, 0);
            v[2] = Vector4(basisZ, 0);
            v[3] = Vector4(translation, 1);
        }
    
        /** Constructs _scale matrix with _scale coefficients specified as arguments. */
        static Matrix44 scale(float_t x, float_t y, float_t z)
        {
            Matrix44 mat = identity;
            with (mat)
            {
                m00 = x;
                m11 = y;
                m22 = z;            
            }
    
            return mat;
        }
    
        /** Constructs _scale matrix with _scale coefficients specified as v's components. */
        static Matrix44 scale(Vector3 v)
        {
            return scale(v.x, v.y, v.z);
        }
    
        /** Construct matrix that represents rotation around corresponding axis. */
        static Matrix44 rotationX(float_t radians)
        {
            Matrix44 mat = identity;
            float_t c = cos(radians);
            float_t s = sin(radians);
            with (mat)
            {
                m11 = m22 = c;
                m21 = s;
                m12 = -s;            
            }
    
            return mat;
        }
    
        /** ditto */
        static Matrix44 rotationY(float_t radians)
        {
            Matrix44 mat = identity;
            float_t c = cos(radians);
            float_t s = sin(radians);
            with (mat)
            {
                m00 = m22 = c;
                m20 = -s;
                m02 = s;            
            }
    
            return mat;
        }
    
        /** ditto */
        static Matrix44 rotationZ(float_t radians)
        {
            Matrix44 mat = identity;
            float_t c = cos(radians);
            float_t s = sin(radians);
            with (mat)
            {
                m00 = m11 = c;
                m10 = s;
                m01 = -s;            
            }
    
            return mat;
        }
    
        /**
        Constructs matrix that represents _rotation specified by euler angles passed as arguments.
        Order of _rotation application is: roll (Z axis), pitch (X axis), yaw (Y axis).
        */
        static Matrix44 rotation(float_t yaw, float_t pitch, float_t roll)
        {
            return Matrix44.rotationY(yaw) * Matrix44.rotationX(pitch) * Matrix44.rotationZ(roll);
        }
    
        /**
        Constructs matrix that represents _rotation specified by axis and angle.
        Method works with assumption that axis is unit vector.        
        Throws:
            AssertError on non-unit axis call attempt if module was compiled with
            contract checks enabled.
        */
        static Matrix44 rotation(Vector3 axis, float_t radians)
        in { assert( axis.isUnit() ); }
        body
        {
            real c = cos(radians);
            real s = sin(radians);
            real cc = 1.0 - c;
            real x2 = axis.x * axis.x;
            real y2 = axis.y * axis.y;
            real z2 = axis.z * axis.z;
            real xycc = axis.x * axis.y * cc;
            real xzcc = axis.x * axis.z * cc;
            real yzcc = axis.y * axis.z * cc;
            real xs = axis.x * s;
            real ys = axis.y * s;
            real zs = axis.z * s;
    
            Matrix44 mat = identity;
            with (mat)
            {
                m00 = x2 * cc + c;      m01 = xycc - zs;        m02 = xzcc + ys;
                m10 = xycc + zs;        m11 = y2 * cc + c;      m12 = yzcc - xs;
                m20 = xzcc - ys;        m21 = yzcc + xs;        m22 = z2 * cc + c;
            }
    
            return mat;
        }
        
        /**
        Constructs matrix that represents _rotation specified by quaternion.
        Method works with assumption that quaternion is unit.        
        Throws:
            AssertError on non-unit quaternion call attempt if module was compiled with
            contract checks enabled.
        */
        static Matrix44 rotation(Quaternion q)
        in { assert( q.isUnit() ); }
        body
        {
            float_t tx  = 2.f * q.x;
            float_t ty  = 2.f * q.y;
            float_t tz  = 2.f * q.z;
            float_t twx = tx * q.w;
            float_t twy = ty * q.w;
            float_t twz = tz * q.w;
            float_t txx = tx * q.x;
            float_t txy = ty * q.x;
            float_t txz = tz * q.x;
            float_t tyy = ty * q.y;
            float_t tyz = tz * q.y;
            float_t tzz = tz * q.z;
            
            Matrix44 mat = identity;
            with (mat)
            {
                m00 = 1.f - (tyy + tzz); m01 = txy - twz;           m02 = txz + twy;
                m10 = txy + twz;         m11 = 1.f - (txx + tzz);   m12 = tyz - twx;
                m20 = txz - twy;         m21 = tyz + twx;           m22 = 1.f - (txx + tyy);
            }
            
            return mat;
        }
    
        /** Constructs _translation matrix with offset values specified as arguments. */
        static Matrix44 translation(float_t x, float_t y, float_t z)
        {
            return Matrix44(1, 0, 0, x,
                            0, 1, 0, y,
                            0, 0, 1, z,
                            0, 0, 0, 1);
        }
    
        /** Constructs _translation matrix with offset values specified as v's components. */
        static Matrix44 translation(Vector3 v)
        {
            return translation(v.x, v.y, v.z);
        }
        
        /**
        Constructs one-point perspecive projection matrix.
        Params:
            fov =       Field of view in vertical plane in radians.
            aspect =    Frustum's width / height coefficient. It shouldn't be 0.
            near =      Distance to near plane.
            near =      Distance to far plane.
        */
        static Matrix44 perspective(float_t fov, float_t aspect, float_t near, float_t far)
        in
        {
            assert( fov < 2*PI );
            assert( !equal(aspect, 0) );
            assert( near > 0 );
            assert( far > near );
        }
        body
        {
            real cot = 1. / tan(fov / 2.);
                    
            return Matrix44(cot / aspect,    0,                            0,                                  0,
                            0,             cot,                            0,                                  0,
                            0,               0,  (near + far) / (near - far),  2.f * (near * far) / (near - far),
                            0,               0,                           -1,                                  0);
        }
        
        /**
        Constructs view matrix.
        Params:
            eye =       Viewer's eye position.
            target =    View target.
            up =        View up vector.
        
        Arguments should not be complanar, elsewise matrix will contain infinity
        elements. You can check this with isnormal() method.
        */
        static Matrix44 lookAt(Vector3 eye, Vector3 target, Vector3 up)
        {
            Vector3 z = (eye - target).normalized();
            alias up y;
            Vector3 x = cross(y, z);
            y = cross(z, x);
            x.normalize();
            y.normalize();
                    
            Matrix44 mat = identity;
            mat.v[0].xyz = Vector3(x.x, y.x, z.x);
            mat.v[1].xyz = Vector3(x.y, y.y, z.y);
            mat.v[2].xyz = Vector3(x.z, y.z, z.z);
                    
            mat.m03 = -dot(eye, x);
            mat.m13 = -dot(eye, y);
            mat.m23 = -dot(eye, z);
                    
            return mat;    
        }
        
        /**
        Возвращает: Inverse copy of this matrix.
        
        In case if this matrix is singular (i.e. determinant = 0) result matrix will has
        infinity elements. You can check this with isnormal() method.
        */
        Matrix44 inverse()
        {
            real det = determinant();
            //if (equal(det, 0))
            //{
            //    return nan;
            //}
            
            real rdet = 1/det;
            return Matrix44(
                rdet * (m11 * (m22 * m33 - m23 * m32) + m12 * (m23 * m31 - m21 * m33) + m13 * (m21 * m32 - m22 * m31)),
                rdet * (m21 * (m02 * m33 - m03 * m32) + m22 * (m03 * m31 - m01 * m33) + m23 * (m01 * m32 - m02 * m31)),
                rdet * (m31 * (m02 * m13 - m03 * m12) + m32 * (m03 * m11 - m01 * m13) + m33 * (m01 * m12 - m02 * m11)),
                rdet * (m01 * (m13 * m22 - m12 * m23) + m02 * (m11 * m23 - m13 * m21) + m03 * (m12 * m21 - m11 * m22)),
                rdet * (m12 * (m20 * m33 - m23 * m30) + m13 * (m22 * m30 - m20 * m32) + m10 * (m23 * m32 - m22 * m33)),
                rdet * (m22 * (m00 * m33 - m03 * m30) + m23 * (m02 * m30 - m00 * m32) + m20 * (m03 * m32 - m02 * m33)),
                rdet * (m32 * (m00 * m13 - m03 * m10) + m33 * (m02 * m10 - m00 * m12) + m30 * (m03 * m12 - m02 * m13)),
                rdet * (m02 * (m13 * m20 - m10 * m23) + m03 * (m10 * m22 - m12 * m20) + m00 * (m12 * m23 - m13 * m22)),
                rdet * (m13 * (m20 * m31 - m21 * m30) + m10 * (m21 * m33 - m23 * m31) + m11 * (m23 * m30 - m20 * m33)),
                rdet * (m23 * (m00 * m31 - m01 * m30) + m20 * (m01 * m33 - m03 * m31) + m21 * (m03 * m30 - m00 * m33)),
                rdet * (m33 * (m00 * m11 - m01 * m10) + m30 * (m01 * m13 - m03 * m11) + m31 * (m03 * m10 - m00 * m13)),
                rdet * (m03 * (m11 * m20 - m10 * m21) + m00 * (m13 * m21 - m11 * m23) + m01 * (m10 * m23 - m13 * m20)),
                rdet * (m10 * (m22 * m31 - m21 * m32) + m11 * (m20 * m32 - m22 * m30) + m12 * (m21 * m30 - m20 * m31)),
                rdet * (m20 * (m02 * m31 - m01 * m32) + m21 * (m00 * m32 - m02 * m30) + m22 * (m01 * m30 - m00 * m31)),
                rdet * (m30 * (m02 * m11 - m01 * m12) + m31 * (m00 * m12 - m02 * m10) + m32 * (m01 * m10 - m00 * m11)),
                rdet * (m00 * (m11 * m22 - m12 * m21) + m01 * (m12 * m20 - m10 * m22) + m02 * (m10 * m21 - m11 * m20)));
        }
        
        /**
        Inverts this matrix.
        
        In case if matrix is singular (i.e. determinant = 0) result matrix will has
        infinity elements. You can check this with isnormal() method.
        */
        void invert()
        {
            real det = determinant();
            //if (equal(det, 0))
            //{
            //    *this = nan;
            //    return;
            //}
            
            real rdet = 1/det;
            set(rdet * (m11 * (m22 * m33 - m23 * m32) + m12 * (m23 * m31 - m21 * m33) + m13 * (m21 * m32 - m22 * m31)),
                rdet * (m21 * (m02 * m33 - m03 * m32) + m22 * (m03 * m31 - m01 * m33) + m23 * (m01 * m32 - m02 * m31)),
                rdet * (m31 * (m02 * m13 - m03 * m12) + m32 * (m03 * m11 - m01 * m13) + m33 * (m01 * m12 - m02 * m11)),
                rdet * (m01 * (m13 * m22 - m12 * m23) + m02 * (m11 * m23 - m13 * m21) + m03 * (m12 * m21 - m11 * m22)),
                rdet * (m12 * (m20 * m33 - m23 * m30) + m13 * (m22 * m30 - m20 * m32) + m10 * (m23 * m32 - m22 * m33)),
                rdet * (m22 * (m00 * m33 - m03 * m30) + m23 * (m02 * m30 - m00 * m32) + m20 * (m03 * m32 - m02 * m33)),
                rdet * (m32 * (m00 * m13 - m03 * m10) + m33 * (m02 * m10 - m00 * m12) + m30 * (m03 * m12 - m02 * m13)),
                rdet * (m02 * (m13 * m20 - m10 * m23) + m03 * (m10 * m22 - m12 * m20) + m00 * (m12 * m23 - m13 * m22)),
                rdet * (m13 * (m20 * m31 - m21 * m30) + m10 * (m21 * m33 - m23 * m31) + m11 * (m23 * m30 - m20 * m33)),
                rdet * (m23 * (m00 * m31 - m01 * m30) + m20 * (m01 * m33 - m03 * m31) + m21 * (m03 * m30 - m00 * m33)),
                rdet * (m33 * (m00 * m11 - m01 * m10) + m30 * (m01 * m13 - m03 * m11) + m31 * (m03 * m10 - m00 * m13)),
                rdet * (m03 * (m11 * m20 - m10 * m21) + m00 * (m13 * m21 - m11 * m23) + m01 * (m10 * m23 - m13 * m20)),
                rdet * (m10 * (m22 * m31 - m21 * m32) + m11 * (m20 * m32 - m22 * m30) + m12 * (m21 * m30 - m20 * m31)),
                rdet * (m20 * (m02 * m31 - m01 * m32) + m21 * (m00 * m32 - m02 * m30) + m22 * (m01 * m30 - m00 * m31)),
                rdet * (m30 * (m02 * m11 - m01 * m12) + m31 * (m00 * m12 - m02 * m10) + m32 * (m01 * m10 - m00 * m11)),
                rdet * (m00 * (m11 * m22 - m12 * m21) + m01 * (m12 * m20 - m10 * m22) + m02 * (m10 * m21 - m11 * m20)));
        }
        
        /** Возвращает: Determinant */
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
        
        /**
        Возвращает: Frobenius _norm of matrix.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).        
        */
        real norm()
        {
            return sqrt( normSquare );
        }
        
        /**
        Возвращает: Square of Frobenius norm of matrix.

        Method doesn't need calculation of square root.

        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Frobenius_norm#Frobenius_norm).
        */
        real normSquare()
        {
            real ret = 0;
            for (int i = 16; i--; )
            {
                real x = a[i];
                ret += x * x;
            }
            
            return ret;
        }
        
        /** 
        Возвращает: Whether this matrix represents affine transformation.
        Ссылки:
            $(LINK http://en.wikipedia.org/wiki/Affine_transformation).
        */
        bool isAffine()
        {
            return equal(m30, 0) && equal(m31, 0) && equal(m32, 0) && equal(m33, 1);
        }
        
        /** Transposes this matrix. */
        void transpose()
        {
            /*           */        swap(m01, m10);        swap(m02, m20);        swap(m03, m30);
            /*           */        /*           */        swap(m12, m21);        swap(m13, m31);
            /*           */        /*           */        /*           */        swap(m23, m32);
            /*           */        /*           */        /*           */        /*           */
        }
        
        /** Возвращает: Transposed copy of this matrix. */
        Matrix44 transposed()
        {
            return Matrix44(
                m00, m10, m20, m30,
                m01, m11, m21, m31,
                m02, m12, m22, m32,
                m03, m13, m23, m33 );
        }
        
        /** R/W property. Corner 3x3 minor. */
        Matrix33 cornerMinor()
        {
            return Matrix33(m00, m01, m02,
                            m10, m11, m12,
                            m20, m21, m22);
        }
        
        /** ditto */
        void cornerMinor(Matrix33 mat)
        {
            m00 = mat.m00;        m01 = mat.m01;        m02 = mat.m02;
            m10 = mat.m10;        m11 = mat.m11;        m12 = mat.m12;
            m20 = mat.m20;        m21 = mat.m21;        m22 = mat.m22;
        }
        
        /**
        Standard operators that have intuitive meaning, same as in classical math. Exception
        is multiplication with Vecto3 that doesn't make sense for classical math, in that case
        Vector3 is implicitl expanded to Vector4 with w=1.
        
        Note that division operators do no cheks of value of k, so in case of division
        by 0 result matrix will have infinity components. You can check this with isnormal()
        method.
        */
        Matrix44 opNeg()
        {
            return Matrix44(-m00, -m01, -m02, -m03,
                            -m10, -m11, -m12, -m13,
                            -m20, -m21, -m22, -m23,
                            -m30, -m31, -m32, -m33);
        }
    
        /** ditto */
        Matrix44 opAdd(Matrix44 mat)
        {
            return Matrix44(m00 + mat.m00, m01 + mat.m01, m02 + mat.m02, m03 + mat.m03,
                            m10 + mat.m10, m11 + mat.m11, m12 + mat.m12, m13 + mat.m13,
                            m20 + mat.m20, m21 + mat.m21, m22 + mat.m22, m23 + mat.m23,
                            m30 + mat.m30, m31 + mat.m31, m32 + mat.m32, m33 + mat.m33);
        }
    
        /** ditto */
        void opAddAssign(Matrix44 mat)
        {
            m00 += mat.m00; m01 += mat.m01; m02 += mat.m02; m03 += mat.m03;
            m10 += mat.m10; m11 += mat.m11; m12 += mat.m12; m13 += mat.m13;
            m20 += mat.m20; m21 += mat.m21; m22 += mat.m22; m23 += mat.m23;
            m30 += mat.m30; m31 += mat.m31; m32 += mat.m32; m33 += mat.m33;
        }
    
        /** ditto */
        Matrix44 opSub(Matrix44 mat)
        {
            return Matrix44(m00 - mat.m00, m01 - mat.m01, m02 - mat.m02, m03 - mat.m03,
                            m10 - mat.m10, m11 - mat.m11, m12 - mat.m12, m13 - mat.m13,
                            m20 - mat.m20, m21 - mat.m21, m22 - mat.m22, m23 - mat.m23,
                            m30 - mat.m30, m31 - mat.m31, m32 - mat.m32, m33 - mat.m33);
        }
    
        /** ditto */
        void opSubAssign(Matrix44 mat)
        {
            m00 -= mat.m00; m01 -= mat.m01; m02 -= mat.m02; m03 -= mat.m03;
            m10 -= mat.m10; m11 -= mat.m11; m12 -= mat.m12; m13 -= mat.m13;
            m20 -= mat.m20; m21 -= mat.m21; m22 -= mat.m22; m23 -= mat.m23;        
            m30 -= mat.m30; m31 -= mat.m31; m32 -= mat.m32; m33 -= mat.m33;        
        }
    
        /** ditto */
        Matrix44 opMul(float_t k)
        {
            return Matrix44(m00 * k, m01 * k, m02 * k, m03 * k,
                            m10 * k, m11 * k, m12 * k, m13 * k,
                            m20 * k, m21 * k, m22 * k, m23 * k,
                            m30 * k, m31 * k, m32 * k, m33 * k);
        }
    
        /** ditto */
        void opMulAssign(float_t k)
        {
            m00 *= k; m01 *= k; m02 *= k; m03 *= k;
            m10 *= k; m11 *= k; m12 *= k; m13 *= k;
            m20 *= k; m21 *= k; m22 *= k; m23 *= k;
            m30 *= k; m31 *= k; m32 *= k; m33 *= k;
        }
    
        /** ditto */
        Matrix44 opMul_r(float_t k)
        {
            return Matrix44(m00 * k, m01 * k, m02 * k, m03 * k,
                            m10 * k, m11 * k, m12 * k, m13 * k,
                            m20 * k, m21 * k, m22 * k, m23 * k,
                            m30 * k, m31 * k, m32 * k, m33 * k);
        }
    
        /** ditto */
        Matrix44 opDiv(float_t k)
        {
            
            return Matrix44(m00 / k, m01 / k, m02 / k, m03 / k,
                            m10 / k, m11 / k, m12 / k, m13 / k,
                            m20 / k, m21 / k, m22 / k, m23 / k,
                            m30 / k, m31 / k, m32 / k, m33 / k);
        }
    
        /** ditto */
        void opDivAssign(float_t k)
        {
            m00 /= k; m01 /= k; m02 /= k; m03 /= k;
            m10 /= k; m11 /= k; m12 /= k; m13 /= k;
            m20 /= k; m21 /= k; m22 /= k; m23 /= k;
            m30 /= k; m31 /= k; m32 /= k; m33 /= k;
        }
    
        /** ditto */
        bool opEquals(Matrix44 mat)
        {
            return m00 == mat.m00 && m01 == mat.m01 && m02 == mat.m02 && m03 == mat.m03 &&
                   m10 == mat.m10 && m11 == mat.m11 && m12 == mat.m12 && m13 == mat.m13 &&
                   m20 == mat.m20 && m21 == mat.m21 && m22 == mat.m22 && m23 == mat.m23 &&
                   m30 == mat.m30 && m31 == mat.m31 && m32 == mat.m32 && m33 == mat.m33;
        }

        /** ditto */
        Matrix44 opMul(Matrix44 mat)
        {
            return Matrix44(m00 * mat.m00 + m01 * mat.m10 + m02 * mat.m20 + m03 * mat.m30,
                            m00 * mat.m01 + m01 * mat.m11 + m02 * mat.m21 + m03 * mat.m31,
                            m00 * mat.m02 + m01 * mat.m12 + m02 * mat.m22 + m03 * mat.m32,
                            m00 * mat.m03 + m01 * mat.m13 + m02 * mat.m23 + m03 * mat.m33,
    
                            m10 * mat.m00 + m11 * mat.m10 + m12 * mat.m20 + m13 * mat.m30,
                            m10 * mat.m01 + m11 * mat.m11 + m12 * mat.m21 + m13 * mat.m31,
                            m10 * mat.m02 + m11 * mat.m12 + m12 * mat.m22 + m13 * mat.m32,
                            m10 * mat.m03 + m11 * mat.m13 + m12 * mat.m23 + m13 * mat.m33,
    
                            m20 * mat.m00 + m21 * mat.m10 + m22 * mat.m20 + m23 * mat.m30,
                            m20 * mat.m01 + m21 * mat.m11 + m22 * mat.m21 + m23 * mat.m31,
                            m20 * mat.m02 + m21 * mat.m12 + m22 * mat.m22 + m23 * mat.m32,
                            m20 * mat.m03 + m21 * mat.m13 + m22 * mat.m23 + m23 * mat.m33,
    
                            m30 * mat.m00 + m31 * mat.m10 + m32 * mat.m20 + m33 * mat.m30,
                            m30 * mat.m01 + m31 * mat.m11 + m32 * mat.m21 + m33 * mat.m31,
                            m30 * mat.m02 + m31 * mat.m12 + m32 * mat.m22 + m33 * mat.m32,
                            m30 * mat.m03 + m31 * mat.m13 + m32 * mat.m23 + m33 * mat.m33);
        }
    
        /** ditto */
        void opMulAssign(Matrix44 mat)
        {
            *this = *this * mat;
        }
    
        /** ditto */
        Vector3 opMul(Vector3 v)
        {
            return Vector3(v.x * m00 + v.y * m01 + v.z * m02 + m03,
                           v.x * m10 + v.y * m11 + v.z * m12 + m13,
                           v.x * m20 + v.y * m21 + v.z * m22 + m23 );
        }
    
        /** ditto */
        Vector4 opMul(Vector4 v)
        {
            return Vector4(v.x * m00 + v.y * m01 + v.z * m02 + v.w * m03,
                           v.x * m10 + v.y * m11 + v.z * m12 + v.w * m13,
                           v.x * m20 + v.y * m21 + v.z * m22 + v.w * m23,
                           v.x * m30 + v.y * m31 + v.z * m32 + v.w * m33);
        }
    
        /** Возвращает: Element at row'th _row and col'th column. */
        float_t opIndex(uint row, uint col)
        in { assert( col < 4 && row < 4 ); }
        body
        {
            return m[col][row];
        }
    
        /** Assigns value f to element at row'th _row and col'th column. */
        void opIndexAssign(float_t f, uint row, uint col)
        in { assert( col < 4 && row < 4 ); }
        body
        {
            m[col][row] = f;
        }
        
        /** Возвращает: Vector representing col'th column. */
        Vector4 opIndex(uint col)
        in { assert( col < 4 ); }
        body
        {
            return v[col];
        }
    
        /** Replaces elements in col'th column with v's values. */
        void opIndexAssign(Vector4 v, uint col)
        in { assert( col < 4 ); }
        body
        {
            this.v[col] = v;
        }
    
        /**
        Возвращает: float_t pointer to [0,0] element of this matrix. It's like a _ptr method for arrays.
        
        Remember about column-major matrix memory layout.
        */
        float_t* ptr()
        {
            return a.ptr;
        }
        
        /** Возвращает: Copy of this matrix with float type elements. */
        Matrix44f toMatrix44f()
        {
            return Matrix44f(
                cast(float)m00, cast(float)m01, cast(float)m02, cast(float)m03,
                cast(float)m10, cast(float)m11, cast(float)m12, cast(float)m13,
                cast(float)m20, cast(float)m21, cast(float)m22, cast(float)m23,
                cast(float)m30, cast(float)m31, cast(float)m32, cast(float)m33 );
        }
        
        /** Возвращает: Copy of this matrix with double type elements. */
        Matrix44d toMatrix44d()
        {
            return Matrix44d(
                cast(double)m00, cast(double)m01, cast(double)m02, cast(double)m03,
                cast(double)m10, cast(double)m11, cast(double)m12, cast(double)m13,
                cast(double)m20, cast(double)m21, cast(double)m22, cast(double)m23,
                cast(double)m30, cast(double)m31, cast(double)m32, cast(double)m33 );
        }
        
        /** Возвращает: Copy of this matrix with real type elements. */
        Matrix44r toMatrix44r()
        {
            return Matrix44r(
                cast(real)m00, cast(real)m01, cast(real)m02, cast(real)m03,
                cast(real)m10, cast(real)m11, cast(real)m12, cast(real)m13,
                cast(real)m20, cast(real)m21, cast(real)m22, cast(real)m23,
                cast(real)m30, cast(real)m31, cast(real)m32, cast(real)m33 );
        }

        char[] toString() { 
            return format("[" ,m00, ", " ,m01, ", " ,m02, ", " ,m03, ",\n",
                          " " ,m10, ", " ,m11, ", " ,m12, ", " ,m13, ",\n",
                          " " ,m20, ", " ,m21, ", " ,m22, ", " ,m23, ",\n",
                          " " ,m30, ", " ,m31, ", " ,m32, ", " ,m33, "]");
        }

    }
    
    alias EqualityByNorm!(Matrix44).equal equal; /// Introduces approximate equality function for Matrix44.
    alias Lerp!(Matrix44).lerp lerp;             /// Introduces linear interpolation function for Matrix44.    
}

alias LinearAlgebra!(float).Vector2             Vector2f;
alias LinearAlgebra!(float).Vector3             Vector3f;
alias LinearAlgebra!(float).Vector4             Vector4f;
alias LinearAlgebra!(float).Quaternion          Quaternionf;
alias LinearAlgebra!(float).Matrix22            Matrix22f;
alias LinearAlgebra!(float).Matrix33            Matrix33f;
alias LinearAlgebra!(float).Matrix44            Matrix44f;
alias LinearAlgebra!(float).equal               equal;
alias LinearAlgebra!(float).dot                 dot;
public alias LinearAlgebra!(float).outer        outer;
alias LinearAlgebra!(float).cross               cross;
alias LinearAlgebra!(float).isBasisOrthogonal   isBasisOrthogonal;
alias LinearAlgebra!(float).isBasisOrthonormal  isBasisOrthonormal;
alias LinearAlgebra!(float).lerp                lerp;
alias LinearAlgebra!(float).slerp               slerp;

alias LinearAlgebra!(double).Vector2            Vector2d;
alias LinearAlgebra!(double).Vector3            Vector3d;
alias LinearAlgebra!(double).Vector4            Vector4d;
alias LinearAlgebra!(double).Quaternion         Quaterniond;
alias LinearAlgebra!(double).Matrix22           Matrix22d;
alias LinearAlgebra!(double).Matrix33           Matrix33d;
alias LinearAlgebra!(double).Matrix44           Matrix44d;
alias LinearAlgebra!(double).equal              equal;
alias LinearAlgebra!(double).dot                dot;
//alias LinearAlgebra!(double).outer              outer;
alias LinearAlgebra!(double).cross              cross;
alias LinearAlgebra!(double).isBasisOrthogonal  isBasisOrthogonal;
alias LinearAlgebra!(double).isBasisOrthonormal isBasisOrthonormal;
alias LinearAlgebra!(double).lerp               lerp;
alias LinearAlgebra!(double).slerp              slerp;

alias LinearAlgebra!(real).Vector2              Vector2r;
alias LinearAlgebra!(real).Vector3              Vector3r;
alias LinearAlgebra!(real).Vector4              Vector4r;
alias LinearAlgebra!(real).Quaternion           Quaternionr;
alias LinearAlgebra!(real).Matrix22             Matrix22r;
alias LinearAlgebra!(real).Matrix33             Matrix33r;
alias LinearAlgebra!(real).Matrix44             Matrix44r;
alias LinearAlgebra!(real).equal                equal;
alias LinearAlgebra!(real).dot                  dot;
//alias LinearAlgebra!(real).outer                outer;
alias LinearAlgebra!(real).cross                cross;
alias LinearAlgebra!(real).isBasisOrthogonal    isBasisOrthogonal;
alias LinearAlgebra!(real).isBasisOrthonormal   isBasisOrthonormal;
alias LinearAlgebra!(real).lerp                 lerp;
alias LinearAlgebra!(real).slerp                slerp;

alias LinearAlgebra!(auxd.helix.config.float_t).Vector2     Vector2;
alias LinearAlgebra!(auxd.helix.config.float_t).Vector3     Vector3;
alias LinearAlgebra!(auxd.helix.config.float_t).Vector4     Vector4;
alias LinearAlgebra!(auxd.helix.config.float_t).Quaternion  Quaternion;
alias LinearAlgebra!(auxd.helix.config.float_t).Matrix22    Matrix22;
alias LinearAlgebra!(auxd.helix.config.float_t).Matrix33    Matrix33;
alias LinearAlgebra!(auxd.helix.config.float_t).Matrix44    Matrix44;

unittest
{
    assert( Vector2(1, 2).normalized().isUnit() );
    assert( Vector3(1, 2, 3).normalized().isUnit() );
    assert( Vector4(1, 2, 3, 4).normalized().isUnit() );

    assert( Vector2(1, 2).dominatingAxis() == Ort.Y );
    assert( Vector3(1, 2, 3).dominatingAxis() == Ort.Z );
    assert( Vector4(1, 2, 3, 4).dominatingAxis() == Ort.W );

    Vector4 v;
    v.set(1, 2, 3, 4);
    assert( v.isnormal() );
    v /= 0;
    assert( !v.isnormal() );

    v.set(1, 2, 3, 4);
    v[Ort.Y] = v[Ort.X];
    assert( v == Vector4(1, 1, 3, 4) );

    Vector4 t = Vector4(100, 200, 300, 400);
    Vector4 s;
    v.set(1, 2, 3, 4);
    s = v;
    v += t;
    v -= t;
    v = (v + t) - t;
    v *= 100;
    v /= 100;
    v = (10 * v * 10) / 100;
    assert( equal(v, s) );

    assert( dot( cross( Vector3(1, 0, 2), Vector3(4, 0, 5) ), Vector3(3, 0, -2) )  == 0 );
}

unittest
{
    real yaw = PI / 8;
    real pitch = PI / 3;
    real roll = PI / 4;
    
    Quaternion q = Quaternion( Matrix33.rotation(yaw, pitch, roll) );
    assert( equal(q.yaw, yaw) );
    assert( equal(q.pitch, pitch) );
    assert( equal(q.roll, roll) );
}

unittest
{
    Matrix33 mat1 = Matrix33(1,2,3,4,5,6,7,8,9);
    static float[9] a = [1,2,3,4,5,6,7,8,9];
    Matrix33 mat2 = Matrix33(a);

    assert(mat1 == mat2.transposed);
}

/*
unittest
{
    Matrix33 a;
    
    a.m01 = 2;
    a.a[1] = 3;
    a.v[0].z = 4;
    assert(a[0, 1] == 2);
    assert(a[1, 0] == 3);
    assert(a[2, 0] == 4);
}
*/
unittest
{
    Matrix33 a = Matrix33.rotation( Vector3(1, 2, 3).normalized, PI / 7.f );
    Matrix33 b = a.inverse;
    b.invert();
    assert( equal(a, b) );
    assert( equal(a.transposed.inverse, a.inverse.transposed) );
}

unittest
{
    Matrix33 Q, S;
    Matrix33 rot = Matrix33.rotationZ(PI / 7);
    Matrix33 scale = Matrix33.scale(-1, 2, 3);
    Matrix33 composition = rot * scale;
    composition.polarDecomposition(Q, S);    
    assert( equal(Q * S, composition) );
}
