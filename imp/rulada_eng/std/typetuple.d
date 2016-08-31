
// Written in the D programming language.

/**
 * Шаблоны для манипуляции кортежами типов (a.k.a списками типов).
 *
 * Некоторые из операций над кортежами типов встроены в язык,
 * например, TL[$(I n)], которая получает $(I n)-ый тип из
 * кортежа типов. TL[$(I lwr) .. $(I upr)] возвращает новый список типов,
 * который является срезом от старого списка.
 *
 * Ссылки:
 *	Основано на идеях из Таблицы 3.1 в
 *	$(LINK2 http://www.amazon.com/exec/obidos/ASIN/0201704315/ref=ase_classicempire/102-2957199-2585768,
 *		Modern C++ Design),
 *	 Andrei Alexandrescu (Addison-Wesley Professional, 2001)
 * Macros:
 *	WIKI = Phobos/StdTypeTuple
 * Copyright:
 *	Public Domain
 */

/* Author:
 *	Walter Bright, Digital Mars, www.digitalmars.com
 */

module std.typetuple;

/**
 * Создает кортеж типов из множества, состоящего из 0 и более типов.
 * Пример:
 * ---
 * import std.typetuple;
 * alias TypeTuple!(int, double) TL;
 *
 * int foo(TL td)  // то же, что int foo(int, double);
 * {
 *    return td[0] + cast(int)td[1];
 * }
 * ---
 *
 * Пример:
 * ---
 * TypeTuple!(TL, char)
 * // эквивалентно:
 * TypeTuple!(int, double, char)
 * ---
 */
template TypeTuple(TList...)
{
    alias TList TypeTuple;
}

/**
 * Возвращает индекс первого вхождения типа T в
 * последовательность (множество) из нуль и более типов TList.
 * Если не найдено, возвращается -1.
 * Пример:
 * ---
 * import std.typetuple;
 * import std.io;
 *
 * void foo()
 * {
 *    writefln("The index of long is ",
 *          IndexOf!(long, TypeTuple!(int, long, double)));
 *    // выводит: The index of long is 1
 * }
 * ---
 */
template IndexOf(T, TList...)
{
    static if (TList.length == 0)
	const int IndexOf = -1;
    else static if (is(T == TList[0]))
	const int IndexOf = 0;
    else
	const int IndexOf =
		(IndexOf!(T, TList[1 .. length]) == -1)
			? -1
			: 1 + IndexOf!(T, TList[1 .. length]);
}

/**
 * Возвращает кортеж типов, созданный из TList с первым вхождением,
 * если оно имеет место быть, удаляемого T.
 * Пример:
 * ---
 * Erase!(long, int, long, double, char)
 * // то же самое, что:
 * TypeTuple!(int, double, char)
 * ---
 */
template Erase(T, TList...)
{
    static if (TList.length == 0)
	alias TList Erase;
    else static if (is(T == TList[0]))
	alias TList[1 .. length] Erase;
    else
	alias TypeTuple!(TList[0], Erase!(T, TList[1 .. length])) Erase;
}

/**
 * Возвращает кортеж типов, созданный из TList со всеми вхождениями,
 * если они имеются, удаляемого T.
 * Пример:
 * ---
 * alias TypeTuple!(int, long, long, int) TL;
 *
 * EraseAll!(long, TL)
 * // то же самое, что:
 * TypeTuple!(int, int)
 * ---
 */
template EraseAll(T, TList...)
{
    static if (TList.length == 0)
	alias TList EraseAll;
    else static if (is(T == TList[0]))
	alias EraseAll!(T, TList[1 .. length]) EraseAll;
    else
	alias TypeTuple!(TList[0], EraseAll!(T, TList[1 .. length])) EraseAll;
}

/**
 * Возвращает кортеж типов, созданный из TList, с удалением всех типов-дубликатов.
 * Пример:
 * ---
 * alias TypeTuple!(int, long, long, int, float) TL;
 *
 * NoDuplicates!(TL)
 * // то же самое, что:
 * TypeTuple!(int, long, float)
 * ---
 */
template NoDuplicates(TList...)
{
    static if (TList.length == 0)
	alias TList NoDuplicates;
    else
	alias TypeTuple!(TList[0], NoDuplicates!(EraseAll!(TList[0], TList[1 .. length]))) NoDuplicates;
}

/**
 * Returns a typetuple created from TList with the first occurrence
 * of type T, if found, replaced with type U.
 * Пример:
 * ---
 * alias TypeTuple!(int, long, long, int, float) TL;
 *
 * Replace!(long, char, TL)
 * // то же самое, что:
 * TypeTuple!(int, char, long, int, float)
 * ---
 */
template Replace(T, U, TList...)
{
    static if (TList.length == 0)
	alias TList Replace;
    else static if (is(T == TList[0]))
	alias TypeTuple!(U, TList[1 .. length]) Replace;
    else
	alias TypeTuple!(TList[0], Replace!(T, U, TList[1 .. length])) Replace;
}

/**
 * Returns a typetuple created from TList with all occurrences
 * of type T, if found, replaced with type U.
 * Пример:
 * ---
 * alias TypeTuple!(int, long, long, int, float) TL;
 *
 * ReplaceAll!(long, char, TL)
 * // то же самое, что:
 * TypeTuple!(int, char, char, int, float)
 * ---
 */
template ReplaceAll(T, U, TList...)
{
    static if (TList.length == 0)
	alias TList ReplaceAll;
    else static if (is(T == TList[0]))
	alias TypeTuple!(U, ReplaceAll!(T, U, TList[1 .. length])) ReplaceAll;
    else
	alias TypeTuple!(TList[0], ReplaceAll!(T, U, TList[1 .. length])) ReplaceAll;
}

/**
 * Returns a typetuple created from TList with the order reversed.
 * Пример:
 * ---
 * alias TypeTuple!(int, long, long, int, float) TL;
 *
 * Reverse!(TL)
 * // то же самое, что:
 * TypeTuple!(float, int, long, long, int)
 * ---
 */
template Reverse(TList...)
{
    static if (TList.length == 0)
	alias TList Reverse;
    else
	alias TypeTuple!(Reverse!(TList[1 .. length]), TList[0]) Reverse;
}

/**
 * Returns the type from TList that is the most derived from type T.
 * If none are found, T is returned.
 * Пример:
 * ---
 * class A { }
 * class B : A { }
 * class C : B { }
 * alias TypeTuple!(A, C, B) TL;
 *
 * MostDerived!(Object, TL) x;  // x is declared as type C
 * ---
 */
template MostDerived(T, TList...)
{
    static if (TList.length == 0)
	alias T MostDerived;
    else static if (is(TList[0] : T))
	alias MostDerived!(TList[0], TList[1 .. length]) MostDerived;
    else
	alias MostDerived!(T, TList[1 .. length]) MostDerived;
}

/**
 * Returns the typetuple TList with the types sorted so that the most
 * derived types come first.
 * Пример:
 * ---
 * class A { }
 * class B : A { }
 * class C : B { }
 * alias TypeTuple!(A, C, B) TL;
 *
 * DerivedToFront!(TL)
 * // то же самое, что:
 * TypeTuple!(C, B, A)
 * ---
 */
template DerivedToFront(TList...)
{
    static if (TList.length == 0)
	alias TList DerivedToFront;
    else
	alias TypeTuple!(MostDerived!(TList[0], TList[1 .. length]),
	                DerivedToFront!(ReplaceAll!(MostDerived!(TList[0], TList[1 .. length]),
						    TList[0],
						    TList[1 .. length]))) DerivedToFront;
}
