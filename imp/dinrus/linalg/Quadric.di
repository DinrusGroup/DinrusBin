module linalg.Quadric;
import linalg.Vector;
//import stdrus;

//== CLASS DEFINITION =========================================================


/** /class Квадрик Квадрик.hh <OSG/Geometry/Types/Квадрик.hh>

    Сохраняет квадрик как симметричную матрицу 4x4. Used by the
    error quadric based mesh decimation algorithms.
**/

struct Квадрик(Скаляр)
{
public:
    alias Скаляр           тип_значения;
    alias Квадрик!(Скаляр) тип;
    alias Квадрик!(Скаляр) Сам;
    //   alias VectorInterface<Скаляр, VecStorage3<Скаляр> > Vec3;
    //   alias VectorInterface<Скаляр, VecStorage4<Скаляр> > Vec4;
    //alias Vector3Elem      Vec3;
    //alias Vector4Elem      Vec4;

    /// конструирует с пом. самого верхнего треугольника симметричной матрицы 4x4
    static Квадрик opCall(Скаляр _a, Скаляр _b, Скаляр _c, Скаляр _d,
                           /*      */ Скаляр _e, Скаляр _f, Скаляр _g,
                           /*                 */ Скаляр _h, Скаляр _i,
                           /*                            */ Скаляр _j);


    /// конструирует из указанного уравнения плоскости: ax+by+cz+d_=0
    static Квадрик opCall( Скаляр _a=0.0, Скаляр _b=0.0, Скаляр _c=0.0, Скаляр _d=0.0 );

    /// конструирует из указанного уравнения плоскости: ax+by+cz+d_=0
    ///          или из расстояния к точке: x,y,z
    ///          или из самого верхнего треугольника симметричной матрицы 4x4.
    static Квадрик opCall( Скаляр[] v );


   static Квадрик из_точки(_Point)(ref _Point _pt)
    {
        Квадрик M; with(M) {
            уст_расстояние_к_точке(_pt);
        } return M;
    }

    static Квадрик из_нормали_и_точки(_Normal,_Point)( ref _Normal _n, ref _Point _p)
    {
        Квадрик M; with(M) {
            уст_расстояние_к_плоскости(_n,_p);
        } return M;
    }

    //установка оператора
    проц установи(Скаляр _a, Скаляр _b, Скаляр _c, Скаляр _d,
             Скаляр _e, Скаляр _f, Скаляр _g,
             Скаляр _h, Скаляр _i,
             Скаляр _j);

    //sets the quadric representing the squared distance to _pt
    проц уст_расстояние_к_точке(_Point)( ref _Point _pt)
    {
        установи(1, 0, 0, -_pt[0],
            1, 0, -_pt[1],
            1, -_pt[2],
            точка(_pt,_pt));
    }

    //sets the quadric representing the squared distance to the plane [_a,_b,_c,_d]
    проц уст_расстояние_к_плоскости(T=void)(Скаляр _a, Скаляр _b, Скаляр _c, Скаляр _d)
    {
        a_ = _a*_a; b_ = _a*_b; c_ = _a*_c;  d_ = _a*_d;
        /*       */ e_ = _b*_b; f_ = _b*_c;  g_ = _b*_d;
        /**/                    h_ = _c*_c;  i_ = _c*_d;
        /**/                                 j_ = _d*_d;
    }

    //sets the quadric representing the squared distance to the plane
    //determined by the normal _n and the point _p
    проц уст_расстояние_к_плоскости(_Normal,_Point)( ref _Normal  _n,ref _Point _p)
    {
        уст_расстояние_к_плоскости(_n[0], _n[1], _n[2], -точка(_n,_p));
    }

    /// установить все записи в ноль
    проц очисть();

    /// add quadrics
    проц opAddAssign(ref Квадрик _q );


    /// multiply by scalar
    проц opMulAssign( Скаляр _s);

    /// multiply 4D vector from right: Q*v
    _Vec4 opMul(_Vec4)(ref _Vec4 _v)
    {
        Скаляр x=_v[0], y=_v[1], z=_v[2], w=_v[3];
        return _Vec4(x*a_ + y*b_ + z*c_ + w*d_,
                     x*b_ + y*e_ + z*f_ + w*g_,
                     x*c_ + y*f_ + z*h_ + w*i_,
                     x*d_ + y*g_ + z*i_ + w*j_);
    }

    /// evaluate quadric Q at (3D or 4D) vector v: v*Q*v
    Скаляр оцени(_Vec)(ref _Vec _v) 
    {
        return расцени!(_Vec,_Vec.размер_)(_v);
    }

    Скаляр a();
    Скаляр b();
    Скаляр c();
    Скаляр d();
    Скаляр e();
    Скаляр f();
    Скаляр g();
    Скаляр h();
    Скаляр i();
    Скаляр j();

    Скаляр xx();
    Скаляр xy();
    Скаляр xz();
    Скаляр xw();
    Скаляр yy();
    Скаляр yz();
    Скаляр yw();
    Скаляр zz();
    Скаляр zw();
    Скаляр ww();

    ткст вТкст() ;
protected:

    /// evaluate quadric Q at 3D vector v: v*Q*v
    Скаляр расцени(_Vec3,бцел N)(ref _Vec3 _v) 
    {
        static if(N==3) {
            Скаляр x=_v[0], y=_v[1], z=_v[2];
            return a_*x*x + 2.0*b_*x*y + 2.0*c_*x*z + 2.0*d_*x
                /**/      +     e_*y*y + 2.0*f_*y*z + 2.0*g_*y
                /**/                   +     h_*z*z + 2.0*i_*z
                /**/                                +     j_;
        }
        else static if(N==4) {
            Скаляр x=_v[0], y=_v[1], z=_v[2], w=_v[3];
            return a_*x*x + 2.0*b_*x*y + 2.0*c_*x*z + 2.0*d_*x*w
                /**/      +     e_*y*y + 2.0*f_*y*z + 2.0*g_*y*w
                /**/                   +     h_*z*z + 2.0*i_*z*w
                /**/                                +     j_*w*w;
        }
        else {
            static assert(false, "Размер вектора должен быть 3 или 4");
        }
    }


private:

    Скаляр a_=0, b_=0, c_=0, d_=0,
        /**/     e_=0, f_=0, g_=0,
        /**/           h_=0, i_=0,
        /**/                 j_=0;
}


/// Quadric using floats
alias Квадрик!(плав) Квадрикп;

/// Quadric using double
alias Квадрик!(дво) Квадрикд;


import linalg.VectorTypes;

unittest
{
    Квадрикп qf;
    Квадрикд qd = [1,2,3,4];

    qf.оцени(Век3п(0,1,2));
    qd * Век4п(0,1,2,4);
	скажинс("окей");
}


