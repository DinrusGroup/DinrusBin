/**
 * Низкоуровневые Математические Функции, пользующиеся преимуществами IEEE754 ABI.
 *
 * Copyright: Portions Copyright (C) 2001-2005 Digital Mars.
 * License:   BSD стиль: $(LICENSE), Digital Mars.
 * Authors:   Don Clugston, Walter Bright, Sean Kelly
 */
/*
 * Author:
 *  Walter Bright
 * Copyright:
 *  Copyright (c) 2001-2005 by Digital Mars,
 *  все Rights Reserved,
 *  www.digitalmars.com
 * License:
 * Данное программное обеспечение предоставляется "как есть",
 * без какой-либо явной или косвенной гарантии. 
 * Авторы ни в коем случае не несут ответственность за ущерб,
 * причинённый от использования данного ПО.
 *
 *  Любому даётся разрешение использовать из_ ПО в любых целях,
 *  включая коммерческое применение, его изменение и свободное распространение,
 *  за исключением следующих ограничений:
 *
 *  <ul>
 *  <li> Нельзя искажать источник данного программного обеспечения; либо
 *       утверждать, что вами написано оригинальное ПО. Если данное ПО используется
 *       Вами в проекте, признательность в документации к продукту будет
 *       оценена достойно, но не является обязательной.
 *  </li>
 *  <li> Измененные версии исходников должны быть отмечены как таковые, и не быть
 *       неверно представлены, как оригинальное ПО.
 *  </li>
 *  <li> Данное сообщение нельзя удалять или изменять
 *       ни в каком дистрибутиве.
 *  </li>
 *  </ul>
 */
/**
 * Macros:
 *
 *  TABLE_SV = <table border=1 cellpadding=4 cellspacing=0>
 *      <caption>Особые Значения</caption>
 *      $0</table>
 *  SVH = $(TR $(TH $1) $(TH $2))
 *  SV  = $(TR $(TD $1) $(TD $2))
 *  SVH3 = $(TR $(TH $1) $(TH $2) $(TH $3))
 *  SV3  = $(TR $(TD $1) $(TD $2) $(TD $3))
 *  NAN = $(RED NAN)
 *  PLUSMN = &plusmn;
 *  INFIN = &infin;
 *  PLUSMNINF = &plusmn;&infin;
 *  ПИ = &pi;
 *  LT = &lt;
 *  GT = &gt;
 *  SQRT = &корень;
 *  HALF = &frac12;
 */
module math.IEEE;

version(D_InlineAsm_X86) {
    version = Naked_D_InlineAsm_X86;
}

version (X86){
    version = X86_Any;
}

version (X86_64){
    version = X86_Any;
}

version (Naked_D_InlineAsm_X86) {
    import cidrus;
}


version(Windows) { 
    version(DigitalMars) { 
 	    version = DMDWindows; 
    } 
	version = ЛитлЭндиан;
}

version (X86)
{
    const цел FP_ILOGB0        = -цел.max-1;
    const цел FP_ILOGBNAN      = -цел.max-1;
    const цел FP_ILOGBINFINITY = -цел.max-1;
} else {
    alias cidrus.FP_ILOGB0   FP_ILOGB0;
    alias cidrus.FP_ILOGBNAN FP_ILOGBNAN;
    const цел FP_ILOGBINFINITY = цел.max;
}
 	
// Стандартные НЧ payloads.
// Три младших бита указывают причину НЧ:
// 0 = ошибка, иная чем указанные ниже:
// 1 = ошибка домена
// 2 = сингулярность
// 3 = диапазон
// 4-7 = резерв.
enum ДИНРУС_НЧ {
    // Общие ошибки
    ОШИБКА_ДОМЕНА = 0x0101,
    СИНГУЛЯРНОСТЬ  = 0x0102,
    ОШИБКА_ДИАПАЗОНА  = 0x0103,
    // НЧ, создаваемые функциями из базовой библиотеки
    ТАН_ДОМЕН   = 0x1001,
    СТЕПЕНЬ_ДОМЕН   = 0x1021,
    ГАММА_ДОМЕН = 0x1101,
    ГАММА_ПОЛЮС   = 0x1102,
    ЗНГАММА     = 0x1112,
    БЕТА_ДОМЕН  = 0x1131,
    // NaNs из_ статические функции
    NORMALDISTRIBUTION_INV_DOMAIN = 0x2001,
    STUDENTSDDISTRIBUTION_DOMAIN  = 0x2011
}

private:
/* Большинство функций зависимо от формата наибольшего типа с плавающей запятой IEEE.
 * Этот код отличается в зависимости от того, равен ли 'реал' 64, 80 или 128 битам,
 * и архитектуры биг-эндиан или литл-эндиан.
 * Сейчас поддерживается лишь пять ABI 'реал':
 * 64-битный биг-эндиан  'дво' (напр., PowerPC)
 * 128-битный биг-эндиан 'квадрупл' (напр., SPARC)
 * 64-битный литл-эндиан 'дво' (напр., x86-SSE2)
 * 80-битный литл-эндиан, с битом 'real80' (напр., x87, Itanium).
 * 128-битный литл-эндиан 'квадрупл' (не реализован ни на одном из известных процессоров!)
 *
 * Есть также неподдерживаемый ABI, не следующий IEEE; несколько его функций
 *  при использовании генерируют ошибки времени выполнения.
 * 128-битный биг-эндиан 'дводво' (использован GDC <= 0.23 для PowerPC)
 */


// Константы используются для удаления из представления компонентов.
// Они обеспечиваются работой встроенных свойств плавающей запятой.
template плавТрэтсИ3Е(T) {
 // МАСКА_ЭКСП - бкрат маска для выделения экспонентной части (без знака)
 // МАСКА_ЗНАКА - бкрат маска для выделения значного бита.
 // БКРАТ_ПОЗ_ЭКСП - индекс экспоненты, представленной как бкрат Массив.
 // ББАЙТ_ПОЗ_ЗНАКА - индекс знака, представленного как ббайт Массив.
 // РЕЦИП_ЭПСИЛОН - значение, когда (smallest_denormal) * РЕЦИП_ЭПСИЛОН == T.min
 const T РЕЦИП_ЭПСИЛОН = (1/T.epsilon);

 static if (T.mant_dig == 24) { // плав
    enum : бкрат {
        МАСКА_ЭКСП = 0x7F80,
        МАСКА_ЗНАКА = 0x8000,
        ЭКСПБИАС = 0x3F00
    }
    const бцел МАСКА_ЭКСП_INT = 0x7F80_0000;
    const бцел MANTISSAMASK_INT = 0x007F_FFFF;
    version(ЛитлЭндиан) {        
      const БКРАТ_ПОЗ_ЭКСП = 1;
    } else {
      const БКРАТ_ПОЗ_ЭКСП = 0;
    }
 } else static if (T.mant_dig==53) { // дво, or реал==дво
     enum : бкрат {
         МАСКА_ЭКСП = 0x7FF0,
         МАСКА_ЗНАКА = 0x8000,
         ЭКСПБИАС = 0x3FE0
    }
    const бцел МАСКА_ЭКСП_INT = 0x7FF0_0000;
    const бцел MANTISSAMASK_INT = 0x000F_FFFF; // for the MSB only
    version(ЛитлЭндиан) {
      const БКРАТ_ПОЗ_ЭКСП = 3;
      const ББАЙТ_ПОЗ_ЗНАКА = 7;
    } else {
      const БКРАТ_ПОЗ_ЭКСП = 0;
      const ББАЙТ_ПОЗ_ЗНАКА = 0;
    }
 } else static if (T.mant_dig==64) { // real80
     enum : бкрат {
         МАСКА_ЭКСП = 0x7FFF,
         МАСКА_ЗНАКА = 0x8000,
         ЭКСПБИАС = 0x3FFE
     }
//    const бдол QUIETNANMASK = 0xC000_0000_0000_0000; // Преобразует сигнализирующмй НЧ в тихий НЧ.
    version(ЛитлЭндиан) {
      const БКРАТ_ПОЗ_ЭКСП = 4;
      const ББАЙТ_ПОЗ_ЗНАКА = 9;
    } else {
      const БКРАТ_ПОЗ_ЭКСП = 0;
      const ББАЙТ_ПОЗ_ЗНАКА = 0;
    }
 } else static if (реал.mant_dig==113){ // квадрупл
     enum : бкрат {
         МАСКА_ЭКСП = 0x7FFF,
         МАСКА_ЗНАКА = 0x8000,
         ЭКСПБИАС = 0x3FFE
     }
    version(ЛитлЭндиан) {
      const БКРАТ_ПОЗ_ЭКСП = 7;
      const ББАЙТ_ПОЗ_ЗНАКА = 15;
    } else {
      const БКРАТ_ПОЗ_ЭКСП = 0;
      const ББАЙТ_ПОЗ_ЗНАКА = 0;
    }
 } else static if (реал.mant_dig==106) { // дводво
     enum : бкрат {
         МАСКА_ЭКСП = 0x7FF0,
         МАСКА_ЗНАКА = 0x8000
//         ЭКСПБИАС = 0x3FE0
     }
    // байт экспоненты не уникален
    version(ЛитлЭндиан) {
      const БКРАТ_ПОЗ_ЭКСП = 7; // 3 также эксп крат
      const ББАЙТ_ПОЗ_ЗНАКА = 15;
    } else {
      const БКРАТ_ПОЗ_ЭКСП = 0; // 4 также эксп крат
      const ББАЙТ_ПОЗ_ЗНАКА = 0;
    }
 }
}

// относятся к типам с плавающей точкой
version(ЛитлЭндиан) {
    const МАНТИССА_ЛСБ = 0;
    const МАНТИССА_МСБ = 1;    
} else {
    const МАНТИССА_ЛСБ = 1;
    const МАНТИССА_МСБ = 0;
}

public:

/** Флаги исключительного состояния IEEE

 Эти флаги указывают на случай исключительного условия плавающей запятой.
 Указывают, что было сгенерировано НЧ (не-число) или бесконечность, что результат
 неточен, либо, что был получен сигнал НЧ.
 Возвратные значения этих свойств нужно расценивать как булевы, хотя
 каждое из них возвращается ка цел, для скорости.

 Пример:
 ----
    реал a=3.5;
    // Установить все флаги в ноль
    сбросьИ3еФлаги();
    assert(!и3еФлаги.делНаНоль);
    // Выполнить деление на ноль.
    a/=0.0L;
    assert(a==реал.infinity);
    assert(и3еФлаги.делНаНоль);
    // Создать НЧ
    a*=0.0L;
    assert(и3еФлаги.не_годится);
    assert(нч_ли(a));

    // Проверить, что вызывающая func() не влияет на
    // флаги состояния.
    И3еФлаги f = и3еФлаги;
    func();
    assert(и3еФлаги == f);

 ----
 */
struct И3еФлаги
{
public:
    /// The результат cannot be represented exactly, so rounding occured.
    /// (example: x = син(0.1); }
    цел неточно();
    /// A zero was generated by недобор (example: x = реал.min*реал.epsilon/2;)
    цел недобор() ;
    /// An infinity was generated by перебор (example: x = реал.max*2;)
    цел перебор();
    /// An infinity was generated by division by zero (example: x = 3/0.0; )
    цел делНаНоль() ;
    /// A machine НЧ was generated. (example: x = реал.infinity * 0.0; )
    цел не_годится();
}

/// Возвращает снимок of the текущ состояние of the floating-точка статус флаги.
И3еФлаги и3еФлаги();

/// Набор все of the floating-точка статус флаги в_ нет.
проц сбросьИ3еФлаги();

/** IEEE rounding modes.
 * The default режим is НАИБЛИЖАЙШИЙ.
 */
enum РежимОкругления : крат {
    НАИБЛИЖАЙШИЙ = 0x0000,
    ВВЕРХ      = 0x0400,
    ВНИЗ        = 0x0800,
    К_НУЛЮ    = 0x0C00
};

/** Change the rounding режим использован for все floating-точка operations.
 *
 * Returns the old rounding режим.
 *
 * When changing the rounding режим, it is almost always necessary в_ restore it
 * at the конец of the function. Typical usage:
---
    auto oldrounding = установиИ3еОкругление(РежимОкругления.ВВЕРХ);
    scope (exit) установиИ3еОкругление(oldrounding);
---
 */
РежимОкругления установиИ3еОкругление(РежимОкругления режокрукгл) ;

/** Get the IEEE rounding режим which is in use.
 *
 */
РежимОкругления дайИ3еОкругление();

// Note: Itanium supports ещё точность опции than this. SSE/SSE2 does not support any.
enum КонтрольТочности : крат {
    ТОЧНОСТЬ80 = 0x300,
    ТОЧНОСТЬ64 = 0x200,
    ТОЧНОСТЬ32 = 0x000
};

/** Набор the число of биты of точность использован by 'реал'.
 *
 * Возвращает: the old точность.
 * This is not supported on все platforms.
 */
КонтрольТочности передайТочностьРеала(КонтрольТочности прец);

/*********************************************************************
 * Separate floating точка значение преобр_в significand и exponent.
 *
 * Возвращает:
 *      Calculate и return $(I x) и $(I эксп) such that
 *      значение =$(I x)*2$(SUP эксп) и
 *      .5 $(LT)= |$(I x)| $(LT) 1.0
 *      
 *      $(I x) имеется same знак as значение.
 *
 *      $(TABLE_SV
 *      $(TR $(TH значение)           $(TH returns)         $(TH эксп))
 *      $(TR $(TD $(PLUSMN)0.0)    $(TD $(PLUSMN)0.0)    $(TD 0))
 *      $(TR $(TD +$(INFIN))       $(TD +$(INFIN))       $(TD цел.max))
 *      $(TR $(TD -$(INFIN))       $(TD -$(INFIN))       $(TD цел.min))
 *      $(TR $(TD $(PLUSMN)$(NAN)) $(TD $(PLUSMN)$(NAN)) $(TD цел.min))
 *      )
 */
реал фрэксп(реал значение, out цел эксп);

/**
 * Compute n * 2$(SUP эксп)
 * References: фрэксп
 */
реал лдэксп(реал n, цел эксп);

/******************************************
 * Extracts the exponent of x as a signed integral значение.
 *
 * If x is not a special значение, the результат is the same as
 * $(D cast(цел)логб(x)).
 * 
 * Remarks: This function is consistent with IEEE754R, but it
 * differs из_ the C function of the same имя
 * in the return значение of infinity. (in C, илогб(реал.infinity)== цел.max).
 * Note that the special return значения may все be equal.
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                $(TH илогб(x))     $(TH Неверный?))
 *      $(TR $(TD 0)                 $(TD FP_ILOGB0)   $(TD да))
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD FP_ILOGBINFINITY) $(TD да))
 *      $(TR $(TD $(NAN))            $(TD FP_ILOGBNAN) $(TD да))
 *      )
 */
цел илогб(реал x);

/*****************************************
 * Extracts the exponent of x as a signed integral значение.
 *
 * If x is subnormal, it is treated as if it were normalized.
 * For a positive, finite x:
 *
 * 1 $(LT)= $(I x) * FLT_RADIX$(SUP -логб(x)) $(LT) FLT_RADIX
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                 $(TH логб(x))   $(TH divопрe by 0?) )
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD +$(INFIN)) $(TD no))
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD -$(INFIN)) $(TD да) )
 *      )
 */
реал логб(реал x);

/*************************************
 * Efficiently calculates x * 2$(SUP n).
 *
 * скалбн handles недобор и перебор in
 * the same fashion as the basic arithmetic operators.
 *
 *  $(TABLE_SV
 *      $(TR $(TH x)                 $(TH scalb(x)))
 *      $(TR $(TD $(PLUSMNINF))      $(TD $(PLUSMNINF)) )
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD $(PLUSMN)0.0) )
 *  )
 */
реал скалбн(реал x, цел n);

/**
 * Возвращает положительную разницу между x и y.
 *
 * Если либо x, либо y равно $(NAN), то возвращается не-число.
 * Возвращает:
 * $(TABLE_SV
 *  $(SVH Аргументы, фдим(x, y))
 *  $(SV x $(GT) y, x - y)
 *  $(SV x $(LT)= y, +0.0)
 * )
 */
реал фдим(реал x, реал y);

/*******************************
 * Returns |x|
 *
 *      $(TABLE_SV
 *      $(TR $(TH x)                 $(TH фабс(x)))
 *      $(TR $(TD $(PLUSMN)0.0)      $(TD +0.0) )
 *      $(TR $(TD $(PLUSMN)$(INFIN)) $(TD +$(INFIN)) )
 *      )
 */
реал фабс(реал x);

/**
 * Возвращает (x * y) + z, округлённое один раз в соответствии с
 * текущим режимом округления.
 *
 * BUGS: Пока н ереализовано - округляет дважды.
 */
реал фма(плав x, плав y, плав z);

/**
 * Calculate кос(y) + i син(y).
 *
 * On x86 CPUs, this is a very efficient operation;
 * almost twice as fast as calculating син(y) и кос(y)
 * seperately, и is the preferred метод when Всё are требуется.
 */
креал экспи(реал y);

/*********************************
 * Returns !=0 if e is a НЧ.
 */

цел нч_ли(реал x);

/**
 * Returns !=0 if x is normalized.
 *
 * (Need one for each форматируй because subnormal
 *  floats might be преобразованый в_ нормаль reals)
 */
цел норм_ли(X)(X x)
{
    alias плавТрэтсИ3Е!(X) F;
    
    static if(реал.mant_dig==106) { // дводво
    // дводво is нормаль if the least significant часть is нормаль.
        return норм_ли((cast(дво*)&x)[МАНТИССА_ЛСБ]);
    } else {
        бкрат e = F.МАСКА_ЭКСП & (cast(бкрат *)&x)[F.БКРАТ_ПОЗ_ЭКСП];
        return (e != F.МАСКА_ЭКСП && e!=0);
    }
}

/*********************************
 * Is the binary representation of x опрentical в_ y?
 *
 * Same as ==, except that positive и негатив zero are not опрentical,
 * и two $(NAN)s are опрentical if they have the same 'payload'.
 */

бул идентичен_ли(реал x, реал y);

/** ditto */
бул идентичен_ли(вреал x, вреал y);

/** ditto */
бул идентичен_ли(креал x, креал y);

/*********************************
 * Is число subnormal? (Also called "denormal".)
 * Subnormals have a 0 exponent и a 0 most significant significand bit,
 * but are non-zero.
 */

/* Need one for each форматируй because subnormal floats might
 * be преобразованый в_ нормаль reals.
 */

цел субнорм_ли(плав f);

/// ditto

цел субнорм_ли(дво d);

/// ditto

цел субнорм_ли(реал x);

/*********************************
 * Return !=0 if x is $(PLUSMN)0.
 *
 * Does not affect any floating-точка флаги
 */
цел ноль_ли(реал x);

/*********************************
 * Return !=0 if e is $(PLUSMNINF);.
 */

цел беск_ли(реал x);

/**
 * Calculate the следщ largest floating точка значение after x.
 *
 * Return the least число greater than x that is representable as a реал;
 * thus, it gives the следщ точка on the IEEE число строка.
 *
 *  $(TABLE_SV
 *    $(SVH x,            следщВыше(x)   )
 *    $(SV  -$(INFIN),    -реал.max   )
 *    $(SV  $(PLUSMN)0.0, реал.min*реал.epsilon )
 *    $(SV  реал.max,     $(INFIN) )
 *    $(SV  $(INFIN),     $(INFIN) )
 *    $(SV  $(NAN),       $(NAN)   )
 * )
 *
 * Remarks:
 * This function is included in the IEEE 754-2008 стандарт.
 * 
 * следщДвоВыше и следщПлавВыше are the corresponding functions for
 * the IEEE дво и IEEE плав число строки.
 */
реал следщВыше(реал x);
/** ditto */
дво следщДвоВыше(дво x);

/** ditto */
плав следщПлавВыше(плав x);


/** Reduces the magnitude of x, so the биты in the lower half of its significand
 * are все zero. Returns the amount which needs в_ be добавьed в_ x в_ restore its
 * начальное значение; this amount will also have zeros in все биты in the lower half
 * of its significand.
 */
X разбейЗначимое(X)(ref X x)
{
    if (фабс(x) !< X.infinity) return 0; // don't change НЧ or infinity
    X y = x; // копируй the original значение
    static if (X.mant_dig == плав.mant_dig) {
        бцел *ps = cast(бцел *)&x;
        (*ps) &= 0xFFFF_FC00;
    } else static if (X.mant_dig == 53) {
        бдол *ps = cast(бдол *)&x;
        (*ps) &= 0xFFFF_FFFF_FC00_0000L;
    } else static if (X.mant_dig == 64){ // 80-битные реал
        // An x87 real80 имеется 63 биты, because the 'implied' bit is stored explicitly.
        // This is annoying, because it means the significand cannot be
        // precisely halved. Instead, we разбей it преобр_в 31+32 биты.
        бдол *ps = cast(бдол *)&x;
        (*ps) &= 0xFFFF_FFFF_0000_0000L;
    } else static if (X.mant_dig==113) { // квадрупл
        бдол *ps = cast(бдол *)&x;
        ps[МАНТИССА_ЛСБ] &= 0xFF00_0000_0000_0000L;
    }
    //else static assert(0, "Unsupported размер");

    return y - x;
}

/**
 * Calculate the следщ smallest floating точка значение before x.
 *
 * Return the greatest число less than x that is representable as a реал;
 * thus, it gives the previous точка on the IEEE число строка.
 *
 *  $(TABLE_SV
 *    $(SVH x,            следщНиже(x)   )
 *    $(SV  $(INFIN),     реал.max  )
 *    $(SV  $(PLUSMN)0.0, -реал.min*реал.epsilon )
 *    $(SV  -реал.max,    -$(INFIN) )
 *    $(SV  -$(INFIN),    -$(INFIN) )
 *    $(SV  $(NAN),       $(NAN)    )
 * )
 *
 * Remarks:
 * This function is included in the IEEE 754-2008 стандарт.
 * 
 * следщДвоНиже и следщПлавНиже are the corresponding functions for
 * the IEEE дво и IEEE плав число строки.
 */
реал следщНиже(реал x);

/** ditto */
дво следщДвоНиже(дво x);

/** ditto */
плав следщПлавНиже(плав x);

/**
 * Calculates the следщ representable значение after x in the direction of y.
 *
 * If y > x, the результат will be the следщ largest floating-точка значение;
 * if y < x, the результат will be the следщ smallest значение.
 * If x == y, the результат is y.
 *
 * Remarks:
 * This function is not generally very useful; it's almost always better в_ use
 * the faster functions следщВыше() or следщНиже() instead.
 *
 * IEEE 754 requirements не реализован:
 * The FE_INEXACT и FE_OVERFLOW exceptions will be raised if x is finite и
 * the function результат is infinite. The FE_INEXACT и FE_UNDERFLOW
 * exceptions will be raised if the function значение is subnormal, и x is
 * not equal в_ y.
 */
реал следщза(реал x, реал y);

/**************************************
 * To что точность is x equal в_ y?
 *
 * Возвращает: the число of significand биты which are equal in x и y.
 * eg, 0x1.F8p+60 и 0x1.F1p+60 are equal в_ 5 биты of точность.
 *
 *  $(TABLE_SV
 *    $(SVH3 x,      y,         отнравх(x, y)  )
 *    $(SV3  x,      x,         typeof(x).mant_dig )
 *    $(SV3  x,      $(GT)= 2*x, 0 )
 *    $(SV3  x,      $(LE)= x/2, 0 )
 *    $(SV3  $(NAN), any,       0 )
 *    $(SV3  any,    $(NAN),    0 )
 *  )
 *
 * Remarks:
 * This is a very fast operation, suitable for use in скорость-critical код.
 */
цел отнравх(X)(X x, X y)
{
    /* Public Domain. Author: Don Clugston, 18 Aug 2005.
     */
  static assert(is(X==реал) || is(X==дво) || is(X==плав), "Only плав, дво, и реал are supported by отнравх");
  
  static if (X.mant_dig == 106) { // дводво.
     цел a = отнравх(cast(дво*)(&x)[МАНТИССА_МСБ], cast(дво*)(&y)[МАНТИССА_МСБ]);
     if (a != дво.mant_dig) return a;
     return дво.mant_dig + отнравх(cast(дво*)(&x)[МАНТИССА_ЛСБ], cast(дво*)(&y)[МАНТИССА_ЛСБ]);     
  } else static if (X.mant_dig==64 || X.mant_dig==113 
                 || X.mant_dig==53 || X.mant_dig == 24) {
    if (x == y) return X.mant_dig; // ensure diff!=0, cope with INF.

    X diff = фабс(x - y);

    бкрат *pa = cast(бкрат *)(&x);
    бкрат *pb = cast(бкрат *)(&y);
    бкрат *pd = cast(бкрат *)(&diff);

    alias плавТрэтсИ3Е!(X) F;

    // The difference in абс(exponent) between x or y и абс(x-y)
    // is equal в_ the число of significand биты of x which are
    // equal в_ y. If негатив, x и y have different exponents.
    // If positive, x и y are equal в_ 'bitsdiff' биты.
    // AND with 0x7FFF в_ form the абсолютный значение.
    // To avoопр out-by-1 ошибки, we вычти 1 so it rounds down
    // if the exponents were different. This means 'bitsdiff' is
    // always 1 lower than we want, except that if bitsdiff==0,
    // they could have 0 or 1 биты in common.

 static if (X.mant_dig==64 || X.mant_dig==113) { // real80 or квадрупл
    цел bitsdiff = ( ((pa[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП) 
                     + (pb[F.БКРАТ_ПОЗ_ЭКСП]& F.МАСКА_ЭКСП)
                     - (0x8000-F.МАСКА_ЭКСП))>>1) 
                - pd[F.БКРАТ_ПОЗ_ЭКСП];
 } else static if (X.mant_dig==53) { // дво
    цел bitsdiff = (( ((pa[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП)
                     + (pb[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП)
                     - (0x8000-F.МАСКА_ЭКСП))>>1) 
                 - (pd[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП))>>4;
 } else static if (X.mant_dig == 24) { // плав
     цел bitsdiff = (( ((pa[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП)
                      + (pb[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП)
                      - (0x8000-F.МАСКА_ЭКСП))>>1) 
             - (pd[F.БКРАТ_ПОЗ_ЭКСП] & F.МАСКА_ЭКСП))>>7;     
 }
    if (pd[F.БКРАТ_ПОЗ_ЭКСП] == 0)
    {   // Difference is denormal
        // For denormals, we need в_ добавь the число of zeros that
        // lie at the старт of diff's significand.
        // We do this by multИПlying by 2^реал.mant_dig
        diff *= F.РЕЦИП_ЭПСИЛОН;
        return bitsdiff + X.mant_dig - pd[F.БКРАТ_ПОЗ_ЭКСП];
    }

    if (bitsdiff > 0)
        return bitsdiff + 1; // добавь the 1 we subtracted before
        
    // Avoопр out-by-1 ошибки when factor is almost 2.    
     static if (X.mant_dig==64 || X.mant_dig==113) { // real80 or квадрупл    
        return (bitsdiff == 0) ? (pa[F.БКРАТ_ПОЗ_ЭКСП] == pb[F.БКРАТ_ПОЗ_ЭКСП]) : 0;
     } else static if (X.mant_dig == 53 || X.mant_dig == 24) { // дво or плав
        return (bitsdiff == 0 && !((pa[F.БКРАТ_ПОЗ_ЭКСП] ^ pb[F.БКРАТ_ПОЗ_ЭКСП])& F.МАСКА_ЭКСП)) ? 1 : 0;
     }
 } else {
    assert(0, "Unsupported");
 }
}

/*********************************
 * Return 1 if знак bit of e is установи, 0 if not.
 */

цел битзнака(реал x);


/*********************************
 * Return a значение composed of в_ with из_'s знак bit.
 */

реал копируйзнак(реал в_, реал из_);

/** Return the значение that lies halfway between x и y on the IEEE число строка.
 *
 * Formally, the результат is the arithmetic mean of the binary significands of x
 * и y, multИПlied by the geometric mean of the binary exponents of x и y.
 * x и y must have the same знак, и must not be НЧ.
 * Note: this function is useful for ensuring O(лог n) behaviour in algorithms
 * involving a 'binary chop'.
 *
 * Special cases:
 * If x и y are внутри a factor of 2, (ie, отнравх(x, y) > 0), the return значение
 * is the arithmetic mean (x + y) / 2.
 * If x и y are even powers of 2, the return значение is the geometric mean,
 *   и3еСреднее(x, y) = квкор(x * y).
 *
 */
T и3еСреднее(T)(T x, T y)
in {
    // Всё x и y must have the same знак, и must not be НЧ.
    assert(битзнака(x) == битзнака(y)); 
    assert(x<>=0 && y<>=0);
}
body {
    // Runtime behaviour for contract violation:
    // If signs are opposite, or one is a НЧ, return 0.
    if (!((x>=0 && y>=0) || (x<=0 && y<=0))) return 0.0;

    // The implementation is simple: cast x и y в_ целыйs,
    // average them (avoопрing перебор), и cast the результат back в_ a floating-точка число.

    alias плавТрэтсИ3Е!(реал) F;
    T u;
    static if (T.mant_dig==64) { // real80
        // There's slight добавьitional complexity because they are actually
        // 79-битные reals...
        бкрат *ue = cast(бкрат *)&u;
        бдол *ul = cast(бдол *)&u;
        бкрат *xe = cast(бкрат *)&x;
        бдол *xl = cast(бдол *)&x;
        бкрат *ye = cast(бкрат *)&y;
        бдол *yl = cast(бдол *)&y;
        // Ignore the useless implicit bit. (Bonus: this prevents overflows)
        бдол m = ((*xl) & 0x7FFF_FFFF_FFFF_FFFFL) + ((*yl) & 0x7FFF_FFFF_FFFF_FFFFL);

        бкрат e = cast(бкрат)((xe[F.БКРАТ_ПОЗ_ЭКСП] & 0x7FFF) + (ye[F.БКРАТ_ПОЗ_ЭКСП] & 0x7FFF));
        if (m & 0x8000_0000_0000_0000L) {
            ++e;
            m &= 0x7FFF_FFFF_FFFF_FFFFL;
        }
        // Сейчас do a multi-байт right shift
        бцел c = e & 1; // carry
        e >>= 1;
        m >>>= 1;
        if (c) m |= 0x4000_0000_0000_0000L; // shift carry преобр_в significand
        if (e) *ul = m | 0x8000_0000_0000_0000L; // установи implicit bit...
        else *ul = m; // ... unless exponent is 0 (denormal or zero).
        ue[4]=  e | (xe[F.БКРАТ_ПОЗ_ЭКСП]& F.МАСКА_ЗНАКА); // restore знак bit
    } else static if(T.mant_dig == 113) { //квадрупл
        // This would be trivial if 'ucent' were implemented...
        бдол *ul = cast(бдол *)&u;
        бдол *xl = cast(бдол *)&x;
        бдол *yl = cast(бдол *)&y;
        // Multi-байт добавь, then multi-байт right shift.        
        бдол mh = ((xl[МАНТИССА_МСБ] & 0x7FFF_FFFF_FFFF_FFFFL) 
                  + (yl[МАНТИССА_МСБ] & 0x7FFF_FFFF_FFFF_FFFFL));
        // Discard the lowest bit (в_ avoопр перебор)
        бдол ml = (xl[МАНТИССА_ЛСБ]>>>1) + (yl[МАНТИССА_ЛСБ]>>>1);
        // добавь the lowest bit back in, if necessary.
        if (xl[МАНТИССА_ЛСБ] & yl[МАНТИССА_ЛСБ] & 1) {
            ++ml;
            if (ml==0) ++mh;
        }
        mh >>>=1;
        ul[МАНТИССА_МСБ] = mh | (xl[МАНТИССА_МСБ] & 0x8000_0000_0000_0000);
        ul[МАНТИССА_ЛСБ] = ml;
    } else static if (T.mant_dig == дво.mant_dig) {
        бдол *ul = cast(бдол *)&u;
        бдол *xl = cast(бдол *)&x;
        бдол *yl = cast(бдол *)&y;
        бдол m = (((*xl) & 0x7FFF_FFFF_FFFF_FFFFL) + ((*yl) & 0x7FFF_FFFF_FFFF_FFFFL)) >>> 1;
        m |= ((*xl) & 0x8000_0000_0000_0000L);
        *ul = m;
    } else static if (T.mant_dig == плав.mant_dig) {
        бцел *ul = cast(бцел *)&u;
        бцел *xl = cast(бцел *)&x;
        бцел *yl = cast(бцел *)&y;
        бцел m = (((*xl) & 0x7FFF_FFFF) + ((*yl) & 0x7FFF_FFFF)) >>> 1;
        m |= ((*xl) & 0x8000_0000);
        *ul = m;
    } else {
        assert(0, "Not implemented");
    }
    return u;
}

// Functions for НЧ payloads
/*
 * A 'payload' can be stored in the significand of a $(NAN). One bit is требуется
 * в_ distinguish between a quiet и a signalling $(NAN). This leaves 22 биты
 * of payload for a плав; 51 биты for a дво; 62 биты for an 80-битные реал;
 * и 111 биты for a 128-битные quad.
*/
/**
 * Созд a $(NAN), storing an целое insопрe the payload.
 *
 * For 80-битные or 128-битные reals, the largest possible payload is 0x3FFF_FFFF_FFFF_FFFF.
 * For doubles, it is 0x3_FFFF_FFFF_FFFF.
 * For floats, it is 0x3F_FFFF.
 */
реал НЧ(бдол payload);

/**
 * Extract an integral payload из_ a $(NAN).
 *
 * Возвращает:
 * the целое payload as a бдол.
 *
 * For 80-битные or 128-битные reals, the largest possible payload is 0x3FFF_FFFF_FFFF_FFFF.
 * For doubles, it is 0x3_FFFF_FFFF_FFFF.
 * For floats, it is 0x3F_FFFF.
 */
бдол getNaNPayload(реал x);


