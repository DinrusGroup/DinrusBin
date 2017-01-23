/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: July 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.Ziggurat;
import math.Bracket:найдиКорень;
import math.Math:абс;
import math.ErrorFunction:матошфунк;
import core.Traits;

/// ziggurat метод for decreasing distributions.
/// Marsaglia, Tsang, Journal of Statistical Software, 2000
/// If имеется негатив is да the ни в каком дистрибутиве is assumed в_ be symmetric with respect в_ 0, 
/// otherwise it is assumed в_ be из_ 0 в_ infinity.
/// Struct based в_ avoопр extra indirection when wrapped in a class (и it should be wrapped
/// in a class и not использован directly).
/// Вызов стиль initialization avoопрed on purpose (this is a big structure, you don't want в_ return it)
struct Циггурат(СлучГ,T,alias плотностьВерФ,alias хвостГенератор,бул естьНегатив=да){
    static assert(типРеал_ли!(T),T.stringof~" недопустимо, поддерживаются только переменные с плавающей точкой");
    const цел члоБлоков=256;
    T[члоБлоков+1] блокПоз;
    T[члоБлоков+1] значФ;
    СлучГ r;
    alias Циггурат ТИсток;
    /// initializes the ziggurat
    static Циггурат создай(alias инвПлотностьВерФ, alias кумПлотностьВерФКомпл)(СлучГ рГенератор,реал xLast=-1.0L,бул проверь_ошиб=да){
        /// function в_ найди xLast
        реал findXLast(реал xLast){
            реал v=xLast*плотностьВерФ(xLast)+кумПлотностьВерФКомпл(xLast);
            реал fMax=плотностьВерФ(0.0L);
            реал pAtt=xLast;
            реал fAtt=плотностьВерФ(xLast);
            for (цел i=члоБлоков-2;i!=0;--i){
                fAtt+=v/pAtt;
                if (fAtt>fMax) return fAtt+(i-1)*fMax;
                pAtt=инвПлотностьВерФ(fAtt);
                assert(pAtt>=0,"инвПлотностьВерФ должен возвратить положительное значения");
            }
            return fAtt+v/pAtt-fMax;
        }
        проц findBracket(ref реал xMin,ref реал xMax){
            реал vMin=кумПлотностьВерФКомпл(0.0L)/члоБлоков;
            реал pAtt=0.0L;
            for (цел i=1;i<члоБлоков;++i){
                pAtt+=vMin/плотностьВерФ(pAtt);
            }
            реал df=findXLast(pAtt);
            if (df>0) {
                // (most likely)
                xMin=pAtt;
                реал vMax=кумПлотностьВерФКомпл(0.0L);
                xMax=pAtt+vMax/плотностьВерФ(pAtt);
            } else {
                xMax=pAtt;
                xMin=vMin/плотностьВерФ(0.0L);
            }
        }
        if (xLast<=0){
            реал xMin,xMax;
            findBracket(xMin,xMax);
            xLast=найдиКорень(&findXLast,xMin,xMax);
            // printf("xLast:%La => %La\n",xLast,findXLast(xLast));
        }
        Циггурат рез;
        with (рез){
            r=рГенератор;
            реал v=плотностьВерФ(xLast)*xLast+кумПлотностьВерФКомпл(xLast);
            реал pAtt=xLast;
            реал fMax=плотностьВерФ(0.0L);
            блокПоз[1]=cast(T)xLast;
            реал fAtt=плотностьВерФ(xLast);
            значФ[1]=cast(T)fAtt;
            for (цел i=2;i<члоБлоков;++i){
                fAtt+=v/pAtt;
                assert(fAtt<=fMax,"Построение Циггурат прервано");
                pAtt=инвПлотностьВерФ(fAtt);
                assert(pAtt>=0,"инвПлотностьВерФ должен возвратить положительное значения");
                блокПоз[i]=cast(T)pAtt;
                значФ[i]=cast(T)fAtt;
            }
            блокПоз[члоБлоков]=0.0L;
            значФ[члоБлоков]=cast(T)плотностьВерФ(0.0L);
            реал ошибка=fAtt+v/pAtt-плотностьВерФ(0.0L);
            assert((!проверь_ошиб) || ошибка<реал.epsilon*10000.0,"Ошибка Циггурат больше ожидаемой");
            блокПоз[0]=cast(T)(xLast*(1.0L+кумПлотностьВерФКомпл(xLast)/плотностьВерФ(xLast)));
            значФ[0]=0.0L;
            for (цел i=0;i<члоБлоков;++i){
                assert(блокПоз[i]>=блокПоз[i+1],"уменьшаемый блокПоз");
                assert(значФ[i]<=значФ[i+1],"увеличение функции плотности вероятности");
            }
        }
        return рез;
    }
    /// returns a single значение with the probability ни в каком дистрибутиве of the текущ Циггурат
    /// и slightly worse randomness (in the нормаль case uses only 32 random биты).
    /// Cannot be 0.
    T дайБыстрСлуч() 
    {
        static if (естьНегатив){
            for (цел итер=1000;итер!=0;--итер) 
            { 
                бцел i0=r.униформа!(бцел)();
                бцел i=i0 & 0xFFU;
                const T масштабФ=(cast(T)1)/(cast(T)бцел.max+1);
                T u= (cast(T)i0+cast(T)0.5)*масштабФ;
                T x = блокПоз[i]*u;
                if (x<блокПоз[i+1]) return ((i0 & 0x100u)?x:-x);
                if (i == 0) return хвостГенератор(r,блокПоз[1],x<0);
                if ((cast(T)плотностьВерФ(x))>значФ[i+1]+(значФ[i]-значФ[i+1])*((cast(T)r.униформа!(бцел)+cast(T)0.5)*масштабФ)) {
                    return ((i0 & 0x100u)?x:-x);
                }
            }
        } else {
            for (цел итер=1000;итер!=0;--итер) 
            { 
                бцел i0=r.униформа!(бцел);
                бцел i= i0 & 0xFFU;
                const T масштабФ=(cast(T)1)/(cast(T)бцел.max+1);
                T u= (cast(T)i0+cast(T)0.5)*масштабФ;
                T x = блокПоз[i]*u;
                if (x<блокПоз[i+1]) return x;
                if (i == 0) return хвостГенератор(r,блокПоз[1]);
                if ((cast(T)плотностьВерФ(x))>значФ[i+1]+(значФ[i]-значФ[i+1])*r.униформа!(T)) {
                    return x;
                }
            }
        }
        throw new Исключение("макс чло итераций в Циггурат, должна быть вероятность<1.0e-1000");
    }
    /// returns a single значение with the probability ни в каком дистрибутиве of the текущ Циггурат
    T дайСлучайный() 
    {
        static if (естьНегатив){
            for (цел итер=1000;итер!=0;--итер) 
            { 
                бцел i0 = r.униформа!(бцел);
                бцел i= i0 & 0xFF;
                T u = r.униформа!(T)();
                T x = блокПоз[i]*u;
                if (x<блокПоз[i+1]) return ((i0 & 0x100u)?x:-x);
                if (i == 0) return хвостГенератор(r,блокПоз[1],x<0);
                if ((cast(T)плотностьВерФ(x))>значФ[i+1]+(значФ[i]-значФ[i+1])*r.униформа!(T)) {
                    return ((i0 & 0x100u)?x:-x);
                }
            }
        } else {
            for (цел итер=1000;итер!=0;--итер) 
            { 
                бцел i=r.униформа!(ббайт);
                T u = r.униформа!(T)();
                T x = блокПоз[i]*u;
                if (x<блокПоз[i+1]) return x;
                if (i == 0) return хвостГенератор(r,блокПоз[1]);
                if ((cast(T)плотностьВерФ(x))>значФ[i+1]+(значФ[i]-значФ[i+1])*r.униформа!(T)) {
                    return x;
                }
            }
        }
        throw new Исключение("макс чло итераций в Циггурат, должна быть вероятность<1.0e-1000");
    }
    /// initializes the аргумент with the probability ни в каком дистрибутиве given и returns it
    /// for массивы this might potentially be faster than a naive loop
    U рандомируй(U)(ref U a){
        static if(is(U S:S[])){
            бцел aL=a.length;
            for (бцел i=0;i!=aL;++i){
                a[i]=cast(БазТипМассивов!(U))дайСлучайный();
            }
        } else {
            a=cast(U)дайСлучайный();
        }
        return a;
    }
    /// initializes the переменная with the результат of маппинг op on the random numbers (of тип T)
    // unfortunately this (ещё efficent version) cannot use local delegates
    template рандомирОп2(alias op){
        U рандомирОп2(U)(ref U a){
            static if(is(U S:S[])){
                alias БазТипМассивов!(U) TT;
                бцел aL=a.length;
                for (бцел i=0;i!=aL;++i){
                    static if(типКомплекс_ли!(TT)) {
                        a[i]=cast(TT)(op(дайСлучайный())+1i*op(дайСлучайный()));
                    } else static if (типМнимое_ли!(TT)){
                        a[i]=cast(TT)(1i*op(дайСлучайный()));
                    } else {
                        a[i]=cast(TT)op(дайСлучайный());
                    }
                }
            } else {
                static if(типКомплекс_ли!(U)) {
                    a=cast(U)(op(дайСлучайный())+1i*op(дайСлучайный()));
                } else static if (типМнимое_ли!(U)){
                    el=cast(U)(1i*op(дайСлучайный()));
                } else {
                    a=cast(U)op(дайСлучайный());
                }
            }
            return a;
        }
    }
    /// initializes the переменная with the результат of маппинг op on the random numbers (of тип T)
    U рандомирОп(U,S)(S delegate(T) op,ref U a){
        static if(is(U S:S[])){
            alias БазТипМассивов!(U) TT;
            бцел aL=a.length;
            for (бцел i=0;i!=aL;++i){
                static if(типКомплекс_ли!(TT)) {
                    a[i]=cast(TT)(op(дайСлучайный())+1i*op(дайСлучайный()));
                } else static if (типМнимое_ли!(TT)){
                    a[i]=cast(TT)(1i*op(дайСлучайный()));
                } else {
                    a[i]=cast(TT)op(дайСлучайный());
                }
            }
        } else {
            static if(типКомплекс_ли!(U)) {
                a=cast(U)(op(дайСлучайный())+1i*op(дайСлучайный()));
            } else static if (типМнимое_ли!(U)){
                el=cast(U)(1i*op(дайСлучайный()));
            } else {
                a=cast(U)op(дайСлучайный());
            }
        }
        return a;
    }
    
}
