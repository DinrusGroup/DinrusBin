/**
Модуль из классов и функций для работы со значениями цвета.

В нём есть структуры для представления Красно-Зелёно-Синего цвета (Цвет3),
цвета КЗС+Альфа  (Цвет4) и триады Hue Saturation Luminance (ХСЛ).

All components of those structs are плав values, not integers.
Rationale is that under different circumstances it is necessary to
work with different standards of integer representation. Frequently
one байт-wise integer layout needed for one API and another for second.
One can require АКЗС порядок, another СЗКА. So it'с better to operate with
floats and to convert them to integer just when it is necessary.

Normal диапазон for плав components' values is [0; 1]. Normal диапазон for integer
values is [0; 255] for Цвет3 and Цвет4, and [0; 240] for ХСЛ. Each struct
has several methods to convert native плав representation to integer and
back.

Authors:
    Victor Nakoryakov, nail-mail[at]mail.ru
*/

module linalg.color;

 import linalg.basic,
               linalg.config;

/** Defines bytes orders for плав to бцел conversions. */
enum ПорядокБайтов
{
    АКЗС,        ///
    АСЗК,        /// описано
    КЗСА,        /// описано
    СЗКА
}

/**
Wrapper template to provide possibility to use different плав types
in implemented structs and routines.
*/
 template Цвет(т_плав)
{
     alias linalg.basic.закрепиПод  закрепиПод;
     alias linalg.basic.закрепиНад  закрепиНад;
     alias linalg.basic.закрепи       закрепи;
     alias linalg.basic.равны       равны;

     alias .Цвет!(плав).ХСЛ      ХСЛп;
     alias .Цвет!(плав).Цвет3   Цвет3п;
     alias .Цвет!(плав).Цвет4   Цвет4п;

     alias .Цвет!(дво).ХСЛ     ХСЛд;
     alias .Цвет!(дво).Цвет3  Цвет3д;
     alias .Цвет!(дво).Цвет4  Цвет4д;

     alias .Цвет!(реал).ХСЛ       ХСЛр;
     alias .Цвет!(реал).Цвет3    Цвет3р;
     alias .Цвет!(реал).Цвет4    Цвет4р;

     static const т_плав кзсК = 255;
     static const т_плав хслК = 240;

    /************************************************************************************
    Hue, Saturation, Luminance triple.
    *************************************************************************************/
    struct ХСЛ
    {
        т_плав х; /// Hue.
        т_плав с; /// Saturation.
        т_плав л; /// Luminance.

        /**
        Method to construct struct in C-like syntax.

        Примеры:
        ------------
        ХСЛ hsl = ХСЛ(0.1, 0.2, 0.3);
        ------------
        */
        static ХСЛ opCall(т_плав х, т_плав с, т_плав л);

        /** Sets components to values of passed arguments. */
        проц установи(т_плав х, т_плав с, т_плав л);

        /** Возвращает: Integer value of corresponding component in диапазон [0; 240]. */
        бцел хц();

        /** описано */
        бцел сц();

        /** описано */
        бцел лц();

        /**
        Set components to values of passed arguments. It is assumed that values of
        arguments are in диапазон [0; 240].
        */
        проц хц(бцел х);

        /** описано */
        проц сц(бцел с);

        /** описано */
        проц лц(бцел л);

        /** Component-wise equality operator. */
        бул opEquals(ХСЛ hsl);

        /** Возвращает: Цвет3 representing the same color as this triple. */
        Цвет3 вЦвет3();
}

    /**
    Approximate equality function.
    Params:
        отнпрец, абспрец = Parameters passed to равны function while calculations.
                           Have the same meaning as in равны function.
    */
    бул равны(ХСЛ а, ХСЛ с, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);

    /************************************************************************************
    Red, Green, Blue triple.
    *************************************************************************************/
    struct Цвет3
    {
        align(1)
        {
            т_плав к; /// Red.
            т_плав з; /// Green.
            т_плав с; /// Blue.
        }

        /// Цвет3 with all components seted to NaN.
        static Цвет3 нч = { т_плав.nan, т_плав.nan, т_плав.nan };

        /**
        Method to construct color in C-like syntax.

        Примеры:
        ------------
        Цвет3 c = Цвет3(0.1, 0.2, 0.3);
        ------------
        */
        static Цвет3 opCall(т_плав к, т_плав з, т_плав с);

        /**
        Method to construct color in C-like syntax from value specified
        in бцел parameter.

        Params:
            ист     = бцел to extract value from.
            порядок   = specifies байт-wise _order in ист.

        Примеры:
        ------------
        Цвет3 c = Цвет3(0x00FFEEDD, ПорядокБайтов.АКЗС);
        ------------
        */
        static Цвет3 opCall(бцел ист, ПорядокБайтов порядок);

        /** Sets components to values of passed arguments. */
        проц установи(т_плав к, т_плав з, т_плав с);

        /**
        Sets components according to color packed in ист бцел argument.

        Params:
            ист     = бцел to extract value from.
            порядок   = specifies байт-wise component layout in ист.
        */
        проц установи(бцел ист, ПорядокБайтов порядок = ПорядокБайтов.АКЗС);
		
        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли();

        /**
        Возвращает: Integer value of corresponding component.

        Float value 0 is mapped to integer 0. Float value 1 is mapped to
        integer 255.
        */
        цел кц();

        /** описано */
        цел зц();

        /** описано */
        цел сц();

        /**
        Sets corresponding component value to mapped value of passed argument.

        Integer value 0 is mapped to плав 0. Integer value 255 is mapped to
        плав 1.
        */
        проц кц(цел к);

        /** описано */
        проц зц(цел з);

        /** описано */
        проц сц(цел с);

        /**
        Возвращает:
            This color packed to бцел.
        Params:
            порядок = specifies байт-wise component layout in ист.
        Throws:
            AssertError if any component is out of диапазон [0; 1] and module was
            compiled with asserts.
        */
        бцел вБцел(ПорядокБайтов порядок);

        /**
        Возвращает:
            ХСЛ triple representing same color as this.
        */
        ХСЛ вХСЛ();
		
        /** Возвращает: т_плав pointer to к component of this color. It'с like а _ptr method for arrays. */
        т_плав* укз();

        /**
        Standard operators that have meaning exactly the same as for Вектор3, i.e. do
        component-wise operations.

        Note that division operators do no cheks of value of k, so in case of division
        by 0 result вектор will have infinity components. You can check this with нормален_ли()
        method.
        */
        бул opEquals(Цвет3 v);

        /** описано */
        Цвет3 opNeg();

        /** описано */
        Цвет3 opAdd(Цвет3 v);

        /** описано */
        проц opAddAssign(Цвет3 v);

        /** описано */
        Цвет3 opSub(Цвет3 v);

        /** описано */
        проц opSubAssign(Цвет3 v);

        /** описано */
        Цвет3 opMul(реал k);

        /** описано */
        проц opMulAssign(реал k);

        /** описано */
        Цвет3 opMulr(реал k);

        /** описано */
        Цвет3 opDiv(реал k);

        /** описано */
        проц opDivAssign(реал k);

        /** Sets all components меньше than беск to беск. */
        проц закрепиПод(т_плав беск = 0);

        /** Возвращает:Копию этого цвета с типом компонентов all components меньше than беск seted to беск. */
        Цвет3 закреплённыйПод(т_плав беск = 0);

        /** Sets all components больше than sup to sup. */
        проц закрепиНад(т_плав sup = 1);

        /** Возвращает:Копию этого цвета с типом компонентов all components больше than sup seted to sup. */
        Цвет3 закреплённыйНад(т_плав sup = 1);

        /**
        Sets all components меньше than беск to беск and
        all components больше than sup to sup.
        */
        проц закрепи(т_плав беск = 0, т_плав sup = 1);

        /**
        Возвращает:
           Копию этого цвета с типом компонентов all components меньше than беск seted to беск
            and all components больше than sup seted to sup.
        */
        Цвет3 закреплённый(т_плав беск = 0, т_плав sup = 1);

        /** Возвращает:Копию этого цвета с типом компонентов плав . */
        Цвет3п вЦвет3п();

        /** Возвращает:Копию этого цвета с типом компонентов дво . */
        Цвет3д вЦвет3д();

        /** Возвращает:Копию этого цвета с типом компонентов реал . */
        Цвет3р вЦвет3р();

        /**
        Routines known as swizzling.
        Возвращает:
            New color constructed from this one and having component values
            that correspond to method name.
        */
        Цвет4 кзс0();
        Цвет4 кзс1();
    }

    /**
    Approximate equality function.
    Params:
        отнпрец, абспрец = Parameters passed to равны function while calculations.
                           Have the same meaning as in равны function.
    */
    бул равны(Цвет3 а, Цвет3 с, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);

    alias Лининтерп!(Цвет3).лининтерп лининтерп; /// Introduces linear interpolation function for Цвет3.


    /************************************************************************************
    Red, Green, Blue triple with additional Alpha component.
    *************************************************************************************/
    struct Цвет4
    {
        align(1)
        {
            т_плав к; /// Red.
            т_плав з; /// Green.
            т_плав с; /// Blue.
            т_плав а; /// Alpha.
        }

        /// Цвет4 with all components seted to NaN.
        static Цвет4 нч = { т_плав.nan, т_плав.nan, т_плав.nan, т_плав.nan };

        /**
        Methods to construct color in C-like syntax.

        Примеры:
        ------------
        Цвет4 c1 = Цвет4(0.1, 0.2, 0.3, 1);
        Цвет3 кзс = Цвет3(0, 0, 0.5);
        Цвет4 c2 = Цвет4(кзс, 1);
        ------------
        */
        static Цвет4 opCall(т_плав к, т_плав з, т_плав с, т_плав а);

        /** описано */
        static Цвет4 opCall(Цвет3 кзс, т_плав а = 1);


        /**
        Method to construct color in C-like syntax from value specified
        in бцел parameter.

        Params:
            ист     = бцел to extract value from.
            порядок   = specifies байт-wise _order in ист.

        Примеры:
        ------------
        Цвет4 c = Цвет4(0x99FFEEDD, ПорядокБайтов.АКЗС);
        ------------
        */
        static Цвет4 opCall(бцел ист, ПорядокБайтов порядок);

        /** Set components to values of passed arguments. */
        проц установи(т_плав к, т_плав з, т_плав с, т_плав а);
		
        /** описано */
        проц установи(Цвет3 кзс, т_плав а);

        /**
        Sets components according to color packed in ист бцел argument.

        Params:
            ист     = бцел to extract value from.
            порядок   = specifies байт-wise layout in ист.
        */
        проц установи(бцел ист, ПорядокБайтов порядок = ПорядокБайтов.АКЗС);
		
        /** Возвращает: Whether all components are нормализованный numbers. */
        бул нормален_ли();
        /**
        Возвращает: Integer value of corresponding component.

        Float value 0 is mapped to integer 0. Float value 1 is mapped to
        integer 255.
        */
        цел кц();
		
        /** описано */
        цел зц();

        /** описано */
        цел сц();

        /** описано */
        цел ац();

        /**
        Sets corresponding component value to mapped value of passed argument.

        Integer value 0 is mapped to плав 0. Integer value 255 is mapped to
        плав 1.
        */
        проц кц(цел к);

        /** описано */
        проц зц(цел з);

        /** описано */
        проц сц(цел с);

        /** описано */
        проц ац(цел а);

        /**
        Возвращает:
            This color packed to бцел.
        Params:
            порядок = specifies байт-wise component layout in ист.
        Throws:
            AssertError if any component is out of диапазон [0; 1] and
            module was compiled with asserts.
        */
        бцел вБцел(ПорядокБайтов порядок);

        /**
        Возвращает:
            ХСЛ triple representing same color as this.

        Alpha value is ignored.
        */
        ХСЛ вХСЛ();

        /** Возвращает: т_плав pointer to к component of this color. It'с like а _ptr method for arrays. */
        т_плав* укз();


        /**
        Standard operators that have meaning exactly the same as for Вектор4, i.e. do
        component-wise operations. So alpha component equaly in rights takes place in all
        operations, to affect just RGB part use swizzling operations.

        Note that division operators do no cheks of value of k, so in case of division
        by 0 result вектор will have infinity components. You can check this with нормален_ли()
        method.
        */
        бул opEquals(Цвет4 v);

        /** описано */
        Цвет4 opNeg();

        /** описано */
        Цвет4 opAdd(Цвет4 v);

        /** описано */
        проц opAddAssign(Цвет4 v);

        /** описано */
        Цвет4 opSub(Цвет4 v);

        /** описано */
        проц opSubAssign(Цвет4 v);

        /** описано */
        Цвет4 opMul(реал k);

        /** описано */
        проц opMulAssign(реал k);

        /** описано */
        Цвет4 opMulr(реал k);

        /** описано */
        Цвет4 opDiv(реал k);
		
        /** описано */
        проц opDivAssign(реал k);

        /** Sets all components меньше than беск to беск. */
        проц закрепиПод(т_плав беск = 0);

        /** Возвращает:Копию этого цвета с типом компонентов all components меньше than беск seted to беск. */
        Цвет4 закреплённыйПод(т_плав беск = 0);

        /** Sets all components больше than sup to sup. */
        проц закрепиНад(т_плав sup = 1);

        /** Возвращает:Копию этого цвета с типом компонентов all components больше than sup seted to sup. */
        Цвет4 закреплённыйНад(т_плав sup = 1);

        /**
        Sets all components меньше than беск to беск and
        all components больше than sup to sup.
        */
        проц закрепи(т_плав беск = 0, т_плав sup = 1);

        /**
        Возвращает:
           Копию этого цвета с типом компонентов all components меньше than беск seted to беск
            and all components больше than sup seted to sup.
        */
        Цвет4 закреплённый(т_плав беск = 0, т_плав sup = 1);

        /** Возвращает:Копию этого цвета с типом компонентов плав . */
        Цвет4п вЦвет4п();

        /** Возвращает:Копию этого цвета с типом компонентов дво . */
        Цвет4д вЦвет4д();

        /** Возвращает:Копию этого цвета с типом компонентов реал . */
        Цвет4р вЦвет4р();

        /**
        Routine known as swizzling.
        Возвращает:
            Цвет3 representing RGB part of this color.
        */
        Цвет3 кзс();

        /**
        Routine known as swizzling.
        Sets RGB part components to values of passed _кзс argument'с components.
        */
        проц кзс(Цвет3 кзс);
}
    /**
    Approximate equality function.
    Params:
        отнпрец, абспрец = Parameters passed to равны function while calculations.
                           Have the same meaning as in равны function.
    */
    бул равны(Цвет4 а, Цвет4 с, цел отнпрец = дефотнпрец, цел абспрец = дефабспрец);

    alias Лининтерп!(Цвет4).лининтерп лининтерп; /// Introduces linear interpolation function for Цвет4.
}

alias Цвет!(плав).ХСЛ         ХСЛп;
alias Цвет!(плав).Цвет3      Цвет3п;
alias Цвет!(плав).Цвет4      Цвет4п;
alias Цвет!(плав).равны       равны;
alias Цвет!(плав).лининтерп        лининтерп;

alias Цвет!(дво).ХСЛ        ХСЛд;
alias Цвет!(дво).Цвет3     Цвет3д;
alias Цвет!(дво).Цвет4     Цвет4д;
alias Цвет!(дво).равны      равны;
alias Цвет!(дво).лининтерп       лининтерп;

alias Цвет!(реал).ХСЛ          ХСЛр;
alias Цвет!(реал).Цвет3       Цвет3р;
alias Цвет!(реал).Цвет4       Цвет4р;
alias Цвет!(реал).равны        равны;
alias Цвет!(реал).лининтерп         лининтерп;

alias Цвет!(linalg.config.т_плав).ХСЛ     ХСЛ;
alias Цвет!(linalg.config.т_плав).Цвет3  Цвет3;
alias Цвет!(linalg.config.т_плав).Цвет4  Цвет4;

unittest
{
    Цвет4 а;
    а.установи(0.1, 0.3, 0.9, 0.6);
    Цвет3 с = а.кзс;
    бцел au = а.вБцел(ПорядокБайтов.КЗСА);
    assert( равны( Цвет3(au, ПорядокБайтов.КЗСА), с ) );
    assert(0);
}

unittest
{
    Цвет3 c = Цвет3( 0.2, 0.5, 1.0 );
    assert( равны(c.вХСЛ.вЦвет3(), c) );
}


//============================
/*
Ниже идут импорты из OpenMesh, несовместимые с изложенными выше структурами,
поэтому они оставлены в английском варианте названия.
В дальнейшем нужно привести всё это в порядок и обеспечить совместимости типов
линейной алгебры и Меш.

*/
import linalg.VectorTypes;

alias Век3бб  Color3ub;
alias Век3п   Color3f;
alias Век3д   Color3d;


/** convert hsv color to rgb color 
   From: http://www.cs.rit.edu/~ncs/color/t_convert.html
   HSV and RGB components all on [0,1] interval.
*/
проц HSV_to_RGB(ref Color3f hsv,  Color3f* rgb);

/** convert rgb color to hsv color 
 *   From: http://www.cs.rit.edu/~ncs/color/t_convert.html 
 *   х = [0,1], с = [0,1], v = [0,1]
 *		if с == 0, then х = -1 (undefined)
 */
проц RGB_to_HSV( ref Color3f rgb, Color3f *hsv);