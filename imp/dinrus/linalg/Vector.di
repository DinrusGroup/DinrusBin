//============================================================================
// Вектор.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
module linalg.Vector;

import stdrus, tpl.metastrings;

// ----------------------------------------------------------------------------

// Создаёт ткст, откатывающий данное выражение N раз, заменяя
// инд сим ('i' по умолчанию) всякий раз на номер цикла в выражении
ткст откат(цел N,цел i=0)(ткст выр, сим инд='i') {
    static if(i<N) {
        сим[] подст_выр;
        foreach (c; выр) {
            if (c==инд) { 
                подст_выр ~= tpl.metastrings.ВТкст!(i); 
            } else {
                подст_выр ~= c;
            }
        }
        return подст_выр ~ "\n" ~ откат!(N,i+1)(выр,инд);
    }else{
    return "";}
}

private ткст _gen_zero_vector(цел N)(ткст класс_сохранения, ткст имя) {
    ткст возвр = класс_сохранения ~" Вектор "~имя~" = {[cast(Т)";
    for(цел столб=0; столб<N; ++столб) {
        возвр ~= "0,";
    }
    return возвр[0..$-1] ~ "]};";
}



private ткст _gen_member_aliases(цел N)(ткст буквы) {
    // This takes a ткст of буквы like "xyz" and makes them aliases
    // for the N components using an anonymous struct.
    ткст возвр = "struct{";
    foreach(c; буквы) {
        возвр ~= "Скаляр " ~ c ~ ";";
    }
    возвр ~= "}";
    return возвр;
}



цел сравни(S,Т)(S a, Т b) {
    if (a==b) return 0;
    return (a<b)? -1 : 1;
} 

//== CLASS DEFINITION =========================================================


/** Значения N шаблонного типа Скаляр - единственные члены данных
    класса Вектор<Скаляр,N>. This guarantees 100% compatibility
    with arrays of type Скаляр and размер N, allowing us to define the
    cast operators to and from arrays and array pointers.

    In addition, this class will be specialized for Век4п to be 16 bit
    aligned, so that aligned SSE instructions can be used on these
    vectors.
*/
struct Вектор(Т, цел N)
{
    alias Т Скаляр;

private alias откат!(N) откат_;
public:

  //---------------------------------------------------------------- class info

    union {
        Скаляр[N] значения_ /*= проц*/;
        static if(N<=4) {
            struct {
                static if(N>=1) {Скаляр x; }
                static if(N>=2) {Скаляр y; }
                static if(N>=3) {Скаляр z; }
                static if(N>=4) {Скаляр w; }
            }
        }
    }


    /// тип используемого в шаблоне скаляра
    alias Скаляр тип_значения;

    /// тип вектора
    alias Вектор!(Скаляр,N)  т_вектор;

    /// возвращает размер вектора
    static т_мера размер();
	
    static const т_мера размер_ = N;
    static const т_мера длина = N;
	alias длина length;

    static if(is(typeof(Скаляр.nan))) {
        static const бул плав_ли = да;
    }        
    else {
        static const бул плав_ли = нет;
    }

    //-------------------------------------------------------------- constructors
    /// Статические векторы времени компиляции со значениями, установленными в 0.
    // static Вектор ноль = {0,0,0...}
    // static const Вектор ноль = {0,0,0...}
    mixin(_gen_zero_vector!(N)("static", "zero"));
    mixin(_gen_zero_vector!(N)("static const", "czero"));

    /// default constructor creates uninitialized values.
    static Вектор opCall();

    /// special constructor  -- broadcasts the value to all elements
    static Вектор opCall( Скаляр v);

    static if(N==2) {
    /// special constructor for 2D vectors
    static Вектор opCall( Скаляр v0,  Скаляр v1) ;
	}
	
    static if(N==3) {
    /// special constructor for 3D vectors
    static Вектор opCall( Скаляр v0,  Скаляр v1, 
                           Скаляр v2) ;
    }

    static if (N==4) {
    /// special constructor for 4D vectors
    static Вектор opCall( Скаляр v0,  Скаляр v1,
                           Скаляр v2,  Скаляр v3) ;
    }

    static if (N==5) {
    /// special constructor for 5D vectors
    static Вектор opCall( Скаляр v0,  Скаляр v1,
                           Скаляр v2,  Скаляр v3,
                           Скаляр v4) ;
    }

    static if (N==6) {
    /// special constructor for 6D vectors
    static Вектор opCall( Скаляр v0,  Скаляр v1,  Скаляр v2,
                           Скаляр v3,  Скаляр v4,  Скаляр v5) ;
    }

/+
    /// construct from a value array
    // This doesn't coexist nicely with the dynamic Скаляр[] version below
    // which is a shame because this version is compile-time checked but 
    // doesn't work with dynamic arrays, while the dynamic version works with
    // all arrays, but has to do runtime checking.
    static Вектор opCall( Скаляр[N] _значения) {
        assert( _значения.длина == N );
        Вектор M; with(M) {
            значения_[] = _значения;
        } return M;
    }
+/
    /// construct from a dynamic value array
    static Вектор opCall( Скаляр[] _значения);

    /// copy & cast constructor (explicit)
    /+
     // Currently conflicts with non-template version, but 
     // not needed since plain value copy and opAssign handle these cases ok.
    static Вектор opCall(otherScalarType)( ref Вектор!(otherScalarType,N) _rhs) {
        Вектор M; M = _rhs;
        return M;
    }
    +/



    //--------------------------------------------------------------------- casts

    /// cast from вектор with a different скаляр type
    //проц opAssign(otherScalarType)( ref Вектор!(otherScalarType,N) _rhs) {
    проц opAssign(ВекТип)( ВекТип _rhs) ;

    /// cast to Скаляр array
    Скаляр* укз();
	alias укз ptr;
    /// cast to const Скаляр array
    //  Скаляр* ptr()  { return значения_.ptr; }




    //----------------------------------------------------------- element access

    Скаляр opIndex(т_мера _i) ;
    проц opIndexAssign(Скаляр v, т_мера _i);
    цел opApply(цел delegate(ref Скаляр) цикл) ;
    цел opApply(цел delegate(ref т_мера, ref Скаляр) цикл);
    цел opApplyReverse(цел delegate(ref Скаляр) цикл) ;
    цел opApplyReverse(цел delegate(ref т_мера, ref Скаляр) цикл);


    //---------------------------------------------------------------- comparsion
    /// component-wise comparison
    цел opEquals( ref т_вектор _rhs) ;

    //---------------------------------------------------------- скаляр operators

    /// component-wise self-multiplication with скаляр
    проц opMulAssign( Скаляр _s) ;
    /** component-wise self-division by скаляр
        \attention v *= (1/_s) is much faster than this  */
    проц opDivAssign( Скаляр _s);
    /// component-wise multiplication with скаляр
    т_вектор opMul( Скаляр _s) ;
    /// component-wise division by with скаляр
    т_вектор opDiv( Скаляр _s) ;

    //---------------------------------------------------------- вектор operators

    /// component-wise self-multiplication
    проц opMulAssign( ref т_вектор _rhs);
    /// component-wise self-division
    проц opDivAssign( ref т_вектор _rhs) ;
    /// вектор difference from this
    проц opSubAssign( ref т_вектор _rhs) ;
    /// вектор self-addition
    проц opAddAssign( ref т_вектор _rhs) ;

    /// component-wise вектор multiplication
    т_вектор opMul( ref т_вектор _v) ;

    /// component-wise вектор division
    т_вектор opDiv( ref т_вектор _v)  ;

    /// component-wise вектор addition
    т_вектор opAdd( ref т_вектор _v);

    /// component-wise вектор difference
    т_вектор opSub( ref т_вектор _v)  ;

    /// unary minus
    т_вектор opNeg() ;

    static if(N==3) {
        /// кросс product: only defined for Vec3* as specialization
        /// See_Also: auxd.OpenMesh.кросс
        Вектор кросс( ref Вектор _rhs) ;
    }

    static if(N==2) {
        /// кросс product: only defined for Vec2* as specialization
        /// See_Also: auxd.OpenMesh.кросс
        Скаляр кросс( ref Вектор _rhs) ;
    }

    /// compute скаляр product
    /// See_Also: auxd.OpenMesh.точка
    Скаляр точка( ref т_вектор _rhs);



    //------------------------------------------------------------ euclidean нормаль

    static if (т_вектор.плав_ли) {
        /// Compute Euclidean (L2) нормаль
        Скаляр нормаль() ;
        /// Compute squared Euclidean (L2) нормаль
        Скаляр квнорм()  ;
        /// Return the one-нормаль of the вектор (sum of elements' absolute values)
        Скаляр норм1() ;
        /// Return the infinity-нормаль of the вектор (макс element std.math.absolute value)
        Скаляр бескнорм();
        /** нормализуй вектор in place, return original length
         */
        Скаляр нормализуй() ;  
        /** Return нормализованный copy of вектор
         */
        Вектор нормализованный()  ;  
        /** нормализуй вектор avoiding div by ноль 
         *  returns original length.
         */
        Скаляр нормализуй_усл();		
        /** Return нормализованный copy of вектор avoiding div by ноль 
         *  returns original new вектор.
         */
        Вектор нормализованный_усл() ;
    }

    //------------------------------------------------------------ макс, мин, среднеариф

    /// return the maximal component
    Скаляр макс()  ;
    /// return the minimal component
    Скаляр мин()  ;

    static if (т_вектор.плав_ли) {
        /// return arithmetic среднеариф
        Скаляр среднеариф()  ;
    }

    /// минимируй values: same as *this = мин(*this, _rhs), but faster
    т_вектор минимируй( ref т_вектор _rhs) ;
    /// максимируй values: same as *this = макс(*this, _rhs), but faster
    т_вектор максимируй( ref т_вектор _rhs) ;
    /// component-wise мин
    т_вектор мин( ref т_вектор _rhs) ;
    /// component-wise макс
    т_вектор макс( ref т_вектор _rhs);

    //------------------------------------------------------------ misc functions

    /// component-wise примени function object with Скаляр opCall(Скаляр).
    т_вектор примени(Функтор)( Функтор _func)  ;
    /// store the same value in each component (e.g. to clear all entries)
    проц векторизуй( Скаляр _s);
    /// store the same value in each component
    static т_вектор векторизованный( Скаляр _s) ;
    /// lexicographical comparison
    цел opCmp( т_вектор _rhs) ;
    ткст вТкст() ;

}



//== GLOBAL FUNCTIONS =========================================================

/// symmetric version of the точка product
Скаляр 
точка(Скаляр, цел N)(ref Вектор!(Скаляр,N) _v1, 
                    ref Вектор!(Скаляр,N) _v2) 
{
    return (_v1.точка(_v2)); 
}


/// \relates auxd.OpenMesh.Вектор
/// symmetric version of the кросс product
template кросс( Скаляр, цел N)
{
    // This monstrosity is required to make D allow the
    // 2d and 3d versions of the template to coexist peacefully.
    // (should be 
    //   alias typeof(Вектор!(Скаляр,N)().кросс(Вектор!(Скаляр,N)())) RetT;
    // but that kills implicit instatiation.
    // Or should be two separate templates, but then DMD says they're ambiguous.
    typeof(Вектор!(Скаляр,N)().кросс(Вектор!(Скаляр,N)()))
    
    кросс( ref Вектор!(Скаляр,N) _v1, 
           ref Вектор!(Скаляр,N) _v2) 
    {
        return (_v1.кросс(_v2));
    }
}

/// \relates auxd.OpenMesh.Вектор
/// Linear interpolation between _v1 and _v2.
Вектор!(Скаляр,N) 
лининтерп( Скаляр, цел N)(Скаляр t,
                     /*const*/ ref Вектор!(Скаляр,N) _v1, 
                     /*const*/ ref Вектор!(Скаляр,N) _v2) 
{
    Вектор!(Скаляр,N) v = _v1;
    Скаляр s = 1.0-t;
    const ткст выр = "v.значения_[i] *= s; v.значения_[i] += t*_v2.значения_[i];";
    //pragma(msg,откат_(выр,'i'));
    mixin( откат!(N)(выр) );
    return v;
}


//== ALIASES =================================================================

// Just the most common aliases.  The rest are in auxd.OpenMesh.Core.Geometry.Vectorypes

/** 2-ббайт вектор */
alias Вектор!(ббайт,2) Век2бб;
/** 2-плав вектор */
alias Вектор!(плав,2) Век2п;
/** 2-дво вектор */
alias Вектор!(дво,2) Век2д;
/** 3-ббайт вектор */
alias Вектор!(ббайт,3) Век3бб;
/** 3-плав вектор */
alias Вектор!(плав,3) Век3п;
/** 3-дво вектор */
alias Вектор!(дво,3) Век3д;
/** 4-ббайт вектор */
alias Вектор!(ббайт,4) Век4бб;
/** 4-плав вектор */
alias Вектор!(плав,4) Век4п;
/** 4-дво вектор */
alias Вектор!(дво,4) Век4д;

/*
template Вектор2(Т) { alias Вектор!(Т,2) Вектор2; }
template Вектор3(Т) { alias Вектор!(Т,3) Вектор3; }
template Вектор4(Т) { alias Вектор!(Т,4) Вектор4; }
template Vector5(Т) { alias Вектор!(Т,5) Vector5; }
template Vector6(Т) { alias Вектор!(Т,6) Vector6; }
template Vector7(Т) { alias Вектор!(Т,7) Vector7; }
template Vector8(Т) { alias Вектор!(Т,8) Vector8; }
*/



//=============================================================================


/** \name Cast vector type to another vector type.
*/
//@{

//-----------------------------------------------------------------------------

проц копируй_вектор(т_исток,т_приёмник,бцел N, бцел i=0)(ref т_исток s, ref т_приёмник d)
{
    static if(i<N) {
        d[i] = cast(typeof(d[0])) s[i];
        копируй_вектор!(т_исток,т_приёмник,N,i+1)(s,d);
    }
}


//-----------------------------------------------------------------------------


template каст_вектор(т_приёмник) {
    т_приёмник каст_вектор(т_исток)(ref т_исток ист) { 
        static if (is(т_приёмник==т_исток)) {
            //pragma(msg, "trivial branch");
            return ист; 
        }
        else {
            //pragma(msg, "different types branch");
            static assert(т_исток.length == т_приёмник.length, 
                          "Длины векторных типов не совпадают");
            т_приёмник tmp;
            копируй_вектор!(т_исток, т_приёмник, т_исток.length)(ист, tmp);
            return tmp;
        }
    }
}


//=============================================================================


/** \name Provide a standardized access to relevant information about a
     vector type.
*/
//@{

//-----------------------------------------------------------------------------

/** Helper class providing information about a vector type.
 *
 * If want to use a different vector type than the one provided %OpenMesh
 * you need to supply a specialization of this class for the new vector type.
 */
struct трэтс_вектора(T)
{
    /// Type of the vector class
    alias T.т_вектор т_вектор;
    /// Type of the scalar value
    alias T.тип_значения  тип_значения;

    /// size/dimension of the vector
    static const т_мера размер_ = T.размер_;

    /// size/dimension of the vector
    static т_мера размер() { return размер_; }
}

//== TESTS =================================================================
unittest {
/*
    alias Вектор!(плав,3) Век3п;
    alias Вектор!(плав,2) Век2п;
    alias Вектор!(цел,2) Vec2i;
    alias Вектор!(цел,3) Век3ц;
    alias Вектор!(ббайт,10) Vec10ub;

    alias std.io.writefln writefln;

    Век3п a;
    Век3п b=  {8,9,10};
    дво[] dyn = [7.0,6.0,3.0];
    Вектор!(дво,3) af = dyn;
    Вектор!(цел,3) ai;
    ai = [1,2,3];
    a = [1,2,3];
    
    writefln("A=", a);
    writefln("Alen=", a.нормаль);
    writefln("ai=", ai);
    writefln("B=", b);

    a = af;
*/
}