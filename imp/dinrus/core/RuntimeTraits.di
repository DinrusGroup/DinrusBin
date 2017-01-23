/** 
 * Provопрes рантайм traits, which provопрe much of the functionality of Traits and
 * is-expressions, as well as some functionality that is only available at рантайм, using 
 * рантайм тип information. 
 * 
 * Authors: Chris Wright (dhasenan) <dhasenan@gmail.com>
 * License: DinrusTango.lib license, apache 2.0
 * Copyright (c) 2009, CHRISTOPHER WRIGHT
 */
module core.RuntimeTraits;

/// If the given тип represents a typedef, return the actual тип.
ИнфОТипе реальныйТип (ИнфОТипе тип);

/// If the given тип represents a class, return its ИнфОКлассе; else return пусто;
ИнфОКлассе какКласс (ИнфОТипе тип);

/** Returns да iff one тип is an ancestor of the другой, or if the типы are the same.
 * If either is пусто, returns нет. */
бул производный_ли (ИнфОКлассе производный, ИнфОКлассе основа);

/** Returns да iff implementor реализует the interface described
 * by iface. This is an expensive operation (linear in the число of
 * interfaces and основа classes).
 */
бул реализует (ИнфОКлассе implementor, ИнфОКлассе iface);

/** Returns да iff an экземпляр of class тест is implicitly castable в_ мишень. 
 * This is an expensive operation (производный_ли + реализует). */
бул непосредственно_ли (ИнфОКлассе тест, ИнфОКлассе мишень);

/** Returns да iff an экземпляр of тип тест is implicitly castable в_ мишень. 
 * If the типы describe classes or interfaces, this is an expensive operation. */
бул непосредственно_ли (ИнфОТипе тест, ИнфОТипе мишень);

///
ИнфОКлассе[] классыОсновы (ИнфОКлассе тип);

/** Returns a список of все interfaces that this тип реализует, directly
 * or indirectly. This включает основа interfaces of типы the class реализует,
 * and interfaces that основа classes implement, and основа interfaces of interfaces
 * that основа classes implement. This is an expensive operation. */
ИнфОКлассе[] интерфейсыОсновы (ИнфОКлассе тип);

/** Returns все the interfaces that this тип directly реализует, включая
 * inherited interfaces. This is an expensive operation.
 * 
 * Examples:
 * ---
 * interface I1 {}
 * interface I2 : I1 {}
 * class A : I2 {}
 * 
 * auto interfaces = графИнтерфейсов (A.classinfo);
 * // interfaces = [I1.classinfo, I2.classinfo]
 * --- 
 * 
 * ---
 * interface I1 {}
 * interface I2 {}
 * class A : I1 {}
 * class B : A, I2 {}
 * 
 * auto interfaces = графИнтерфейсов (B.classinfo);
 * // interfaces = [I2.classinfo]
 * ---
 */
ИнфОКлассе[] графИнтерфейсов (ИнфОКлассе тип);

/** Iterate through все interfaces that тип реализует, directly or indirectly, включая основа interfaces. */
struct примениИнтерфейсы
{
    ///
    static примениИнтерфейсы opCall (ИнфОКлассе тип);

    ///
    цел opApply (цел delegate (ref ИнфОКлассе) дг);

    ИнфОКлассе тип;
}

///
ИнфОКлассе[] типыОсновы (ИнфОКлассе тип);

///
ИнфОМодуле модульИз (ИнфОКлассе тип);

/// Returns a список of interfaces that this class directly реализует.
ИнфОКлассе[] прямыеИнтерфейсы (ИнфОКлассе тип);

/** Returns a список of все типы that are производный из_ the given тип. This does not 
 * счёт interfaces; that is, if тип is an interface, you will only получи производный 
 * interfaces back. It is an expensive operations. */
ИнфОКлассе[] производныеТипы (ИнфОКлассе тип);

///
бул динМасс_ли (ИнфОТипе тип);

///
бул статМасс_ли (ИнфОТипе тип);

/** Returns да iff the given тип is a dynamic or static Массив (нет for associative
 * массивы and non-массивы). */
бул массив_ли (ИнфОТипе тип);

///
бул ассоцМасс_ли (ИнфОТипе тип);

///
бул символ_ли (ИнфОТипе тип);

///
бул ткст_ли (ИнфОТипе тип);

///
бул беззначЦел_ли (ИнфОТипе тип);

///
бул значЦел_ли (ИнфОТипе тип);

///
бул цел_ли (ИнфОТипе тип);

///
бул бул_ли (ИнфОТипе тип);

///
бул плав_ли (ИнфОТипе тип);

///
бул примитив_ли (ИнфОТипе тип);

/// Returns да iff the given тип represents an interface.
бул интерфейс_ли (ИнфОТипе тип);

///
бул указатель_ли (ИнфОТипе тип);

/// Returns да iff the тип represents a class (нет for interfaces).
бул класс_ли (ИнфОТипе тип);

///
бул структ_ли (ИнфОТипе тип);

///
бул функция_ли (ИнфОТипе тип);

/** Returns да iff the given тип is a reference тип. */
бул типСсылка_ли (ИнфОТипе тип);

/** Returns да iff the given тип represents a пользовательский тип. 
 * This does not include functions, delegates, aliases, or typedefs. */
бул пользовательскТип_ли (ИнфОТипе тип);

/** Returns да for все значение типы, нет for все reference типы.
 * For functions and delegates, returns нет (is this the way it should be?). */
бул типЗначение_ли (ИнфОТипе тип);

/** The ключ тип of the given тип. For an Массив, т_мера; for an associative
 * Массив T[U], U. */
ИнфОТипе типКлюч (ИнфОТипе тип);

/** The значение тип of the given тип -- given T[] or T[n], T; given T[U],
 * T; given T*, T; anything else, пусто. */
ИнфОТипе типЗначение (ИнфОТипе тип);

/** If the given тип represents a delegate or function, the return тип
 * of that function. Otherwise, пусто. */
ИнфОТипе типВозврат (ИнфОТипе тип);
