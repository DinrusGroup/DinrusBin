module mesh.Utils;
public import linalg.color, tpl.singleton, tpl.Std, linalg.Vector ;


/** \имя Cast вектор type to another вектор type.
*/
//@{

//-----------------------------------------------------------------------------
/// Cast one color вектор to another.

//-----------------------------------------------------------------------------


проц цветоКопия(т_ист,т_прм,т_масштаб,бцел N, бцел i=0)
    (/*const*/ ref т_ист s, ref т_прм d, т_масштаб масштаб, т_масштаб bias)
{
    static if(i<N) {
        d[i] = cast(typeof(d[0]))(s[i] * масштаб + bias);
        цветоКопия!(т_ист,т_прм,т_масштаб,N,i+1)(s,d, масштаб, bias);
    }
}


//-----------------------------------------------------------------------------


template цветоКаст(т_прм) {
    т_прм цветоКаст(т_ист)(ref т_ист ист) { 
        alias typeof(т_ист.init[0]) т_элем_ист;
        alias typeof(т_прм.init[0]) т_элем_прм;
        const бул ист_явл_плав = is(typeof(т_элем_ист.nan));
        const бул прм_явл_плав = is(typeof(т_элем_прм.nan));
        static assert(т_ист.длина == т_прм.длина, 
                      "Длины векторного типа не совпадают");

        static if (is(т_прм==т_ист)) {
            //pragma(сооб, "trivial branch");
            return ист; 
        }
        else static if ((ист_явл_плав && прм_явл_плав) ||
                        (!ист_явл_плав && !прм_явл_плав))
        {
            //pragma(сооб, "float/цел совпадает branch");
            static assert(т_ист.длина == т_прм.длина, 
                          "Длины векторного типа не совпадают");
            т_прм tmp;
            vector_copy!(т_ист, т_прм, т_ист.длина)(ист, tmp);
            return tmp;
        }
        else static if(ист_явл_плав && !прм_явл_плав) 
        {
            //pragma(сооб, "src_float, dest цел");
            т_прм tmp;
            alias  typeof(ист[0]) т_масштаб ;
            т_масштаб масштаб = cast(т_масштаб)255;
            т_масштаб bias = cast(т_масштаб)0.5;
            цветоКопия!(т_ист, т_прм, т_масштаб, т_ист.длина)(ист, tmp, масштаб, bias);
            return tmp;
        }
        else // (!ист_явл_плав && прм_явл_плав)
        {
            //pragma(сооб, "dest_float, ист цел");
            т_прм tmp;
            alias  typeof(tmp[0]) т_масштаб;
            т_масштаб масштаб = cast(т_масштаб)1.0/cast(т_масштаб)255;
            т_масштаб bias = cast(т_масштаб)0;
            цветоКопия!(т_ист, т_прм, т_масштаб, т_ист.длина)(ист, tmp, масштаб, bias);
            return tmp;
        }
    }
}

//@}

version(Unittest) {
    //import stdrus;
}


unittest {
    version(Unittest) {
        //Vec3f
        Вектор!(float,3) v; v = [.1f,.2,.3];
        Век3бб c = [0u,128,255];


        скажифнс("      v=%s       c=%s\n"
                 "cast(v)=%s cast(c)=%s", v,c, цветоКаст!(Век3бб)(v), цветоКаст!(Vec3f)(c));
        скажифнс("      v=[%s,%s,%s]", v[0],v[1],v[2]);
        //Век3бб c2 = (цветоКаст!(Век3бб)(v)/2 + c/2);
    }
    else {
        static assert(нет, "This unittest must be run with -version=Unittest");
    }
}

/// This type maps \c да or \c нет to different types.
struct Бул2Тип(бул b) { enum { мой_бул = b } }

/// This class generates different types from different \c цел 's.
struct Цел2Тип(цел i)  { enum { мой_цел = i } }

/// Handy typedef for Бул2Тип<да> classes
alias Бул2Тип!(да) Да;

/// Handy typedef for Бул2Тип<нет> classes
alias Бул2Тип!(нет) Нет;

//-----------------------------------------------------------------------------
/// compile time assertions 
template AssertCompile(бул Expr) {
    static_assert(Expr);
}


//--- Template "if" w/ partial specialization ---------------------------------
// not really necessary with 'static if' in the langauge


template assert_compile(EXPR) {
    static_assert(EXPR);
}

class ошибка_нереализовано : Ошибка
{
    this(ткст сооб) { super(сооб); }
}

class рантаймн_ошибка : Ошибка
{
    this(ткст сооб) { super(сооб); }
}

class логич_ошибка : Ошибка
{
    this(ткст сооб) { super(сооб); }
}

class неверн_аргумент : логич_ошибка
{
    this(ткст сооб) { super(сооб); }
}

class ошибка_длин : логич_ошибка
{
    this(ткст сооб) { super(сооб); }
}

class вне_диапазона : логич_ошибка
{
    this(ткст сооб) { super(сооб); }
}


class ошибка_диапазона : рантаймн_ошибка
{
    this(ткст сооб) { super(сооб); }
}
class ошибка_переполнения : рантаймн_ошибка
{
    this(ткст сооб) { super(сооб); }
}
class ошибка_недополнения : рантаймн_ошибка
{
    this(ткст сооб) { super(сооб); }
}