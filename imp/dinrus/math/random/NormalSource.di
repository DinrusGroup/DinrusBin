/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: July 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.NormalSource;
private import Целое = text.convert.Integer;
import math.Math:эксп,квкор,лог,ПИ;
import math.ErrorFunction:матошфунк;
import math.random.Ziggurat;
import core.Traits: типРеал_ли;

/// class that returns gaussian (нормаль) distributed numbers (f=эксп(-0.5*x*x)/квкор(2*pi))
class НормальныйИсточник(СлучГ,T){
    static assert(типРеал_ли!(T),T.stringof~" недопустимо, поддерживаются только переменные с плавающей запятой");
    /// probability ни в каком дистрибутиве (non normalized, should be divопрed by квкор(2*ПИ))
    static реал плотностьВерФ(реал x);
    /// inverse probability ни в каком дистрибутиве
    static реал инвПлотностьВерФ(реал x);
    /// complement of the cumulative density ни в каком дистрибутиве (integral x..infinity плотностьВерФ)
    static реал кумПлотностьВерФКомпл(реал x);
	/*normalDistributionCompl(x);*/ 
    /// хвост for нормаль ни в каком дистрибутиве
    static T хвостГенератор(СлучГ r, T dMin, цел iNegative) 
    { 
        T x, y; 
        do 
        {
            x = -лог(r.униформа!(T)) / dMin;
            y = -лог(r.униформа!(T)); 
        } while (y+y < x * x); 
        return (iNegative ?(-x - dMin):(dMin + x)); 
    }
    alias Циггурат!(СлучГ,T,плотностьВерФ,хвостГенератор,да) ТИсток;
    /// internal источник of нормаль numbers
    ТИсток источник;
    /// initializes the probability ни в каком дистрибутиве
    this(СлучГ r){
        источник=ТИсток.создай!(инвПлотностьВерФ,кумПлотностьВерФКомпл)(r,0xe.9dda4104d699791p-2L);
    }
    /// chainable вызов стиль initialization of variables (thorugh a вызов в_ рандомируй)
    НормальныйИсточник opCall(U,S...)(ref U a,S арги){
        рандомируй(a,арги);
        return this;
    }
    /// returns a нормаль distribued число
    final T дайСлучайный(){
        return источник.дайСлучайный();
    }
    /// returns a нормаль distribued число with the given сигма (стандарт deviation)
    final T дайСлучайный(T сигма){
        return сигма*источник.дайСлучайный();
    }
    /// returns a нормаль distribued число with the given сигма (стандарт deviation) и мю (average)
    final T дайСлучайный(T сигма, T мю){
        return мю+сигма*источник.дайСлучайный();
    }
    /// initializes a переменная with нормаль distribued число и returns it
    U рандомируй(U)(ref U a){
        return источник.рандомируй(a);
    }
    /// initializes a переменная with нормаль distribued число with the given сигма и returns it
    U рандомируй(U,V)(ref U a,V сигма){
        return источник.рандомирОп((T x){ return x*cast(T)сигма; },a);
    }
    /// initializes a переменная with нормаль distribued numbers with the given сигма и мю и returns it
    U рандомируй(U,V,S)(ref U el,V сигма, S мю){
        return источник.рандомирОп((T x){ return x*cast(T)сигма+cast(T)мю; },a);
    }
    /// initializes the переменная with the результат of маппинг op on the random numbers (of тип T)
    U рандомирОп(U,S)(S delegate(T) op,ref U a){
        return источник.рандомирОп(op,a);
    }
    /// нормаль ни в каком дистрибутиве with different default сигма и мю
    /// f=эксп(-x*x/(2*сигма^2))/(квкор(2 pi)*сигма)
    struct НормальнаяДистрибуция{
        T сигма,мю;
        НормальныйИсточник источник;
        /// constructor
        static НормальнаяДистрибуция создай(НормальныйИсточник источник,T сигма,T мю){
            НормальнаяДистрибуция рез;
            рез.источник=источник;
            рез.сигма=сигма;
            рез.мю=мю;
            return рез;
        }
        /// chainable вызов стиль initialization of variables (thorugh a вызов в_ рандомируй)
        НормальнаяДистрибуция opCall(U,S...)(ref U a,S арги){
            рандомируй(a,арги);
            return *this;
        }
        /// returns a single число
        T дайСлучайный(){
            return мю+сигма*источник.дайСлучайный();
        }
        /// инициализуй a
        U рандомируй(U)(ref U a){
            T op(T x){return мю+сигма*x; }
            return источник.рандомирОп(&op,a);
        }
        /// инициализуй a (let s и m have different типы??)
        U рандомируй(U,V)(ref U a,V s){
            T op(T x){return мю+(cast(T)s)*x; }
            return источник.рандомирОп(&op,a);
        }
        /// инициализуй a (let s и m have different типы??)
        U рандомируй(U,V,S)(ref U a,V s, S m){
            T op(T x){return (cast(T)m)+(cast(T)s)*x; }
            return источник.рандомирОп(&op,a);
        }
    }
    /// returns a нормаль ни в каком дистрибутиве with a non-default сигма/мю
    НормальнаяДистрибуция нормальД(T сигма=cast(T)1,T мю=cast(T)0){
        return НормальнаяДистрибуция.создай(this,сигма,мю);
    }
}
