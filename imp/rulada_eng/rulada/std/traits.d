
// Written in the D programming language.

/**
 * Шаблоны, с помощью которых во время компиляции
 * извлекается информация о типах.
 *
 * Макрос:
 *	WIKI = Phobos/StdTraits
 * Copyright:
 *	Public Domain
 */

/*
 * Authors:
 *	Walter Bright, Digital Mars, www.digitalmars.com
 *	Tomasz Stachowiak (isStaticArray, isExpressionTuple)
 */

module std.traits;

/***
 * Получить от функции тип возвращаемого значения,
 * указатель на какую-либо функцию или делегата.
 * Пример:
 * ---
 * import std.traits;
 * int foo();
 * ReturnType!(foo) x;   // x объявлено как int
 * ---
 */
template ReturnType(alias dg)
{
    alias ReturnType!(typeof(dg)) ReturnType;
}

/** ditto */
template ReturnType(dg)
{
    static if (is(dg R == return))
	alias R ReturnType;
    else
	static assert(0, "argument has no return type");
}

/***
 * Получить типы параметров, передаваемых функции,
 * указатель на функцию или делегата в виде кортежа.
 * Пример:
 * ---
 * import std.traits;
 * int foo(int, long);
 * void bar(ParameterTypeTuple!(foo));      // декларирует void bar(int, long);
 * void abc(ParameterTypeTuple!(foo)[1]);   // декларирует void abc(long);
 * ---
 */
template ParameterTypeTuple(alias dg)
{
    alias ParameterTypeTuple!(typeof(dg)) ParameterTypeTuple;
}

/** ditto */
template ParameterTypeTuple(dg)
{
    static if (is(dg P == function))
	alias P ParameterTypeTuple;
    else static if (is(dg P == delegate))
	alias ParameterTypeTuple!(P) ParameterTypeTuple;
    else static if (is(dg P == P*))
	alias ParameterTypeTuple!(P) ParameterTypeTuple;
    else
	static assert(0, "argument has no parameters");
}


/***
 * Получить типы полей структуры или класса.
 * Содержит поля, занимающие простанство памяти,
 * за исключением скрытых полей типа указателя на
 * таблицу виртуальных функций.
 */

template FieldTypeTuple(S)
{
    static if (is(S == struct) || is(S == class))
	alias typeof(S.tupleof) FieldTypeTuple;
    else
	static assert(0, "argument is not struct or class");
}


/***
 * Получить TypeTuple класса-основы и интерфейсы-основы
 * данного класса или интерфейса.
 * Пример:
 * ---
 * import std.traits, std.typetuple, std.io;
 * interface I { }
 * class A { }
 * class B : A, I { }
 *
 * void main()
 * {
 *     alias BaseTypeTuple!(B) TL;
 *     writefln(typeid(TL));	// выводит: (A,I)
 * }
 * ---
 */

template BaseTypeTuple(A)
{
    static if (is(A P == super))
	alias P BaseTypeTuple;
    else
	static assert(0, "argument is not a class or interface");
}

unittest
{
    interface I { }
    class A { }
    class B : A, I { }

    alias BaseTypeTuple!(B) TL;
    assert(TL.length == 2);
    assert(is (TL[0] == A));
    assert(is (TL[1] == I));
}

/* *******************************************
 */
template isStaticArray_impl(T)
{
    const T inst = void;
    
    static if (is(typeof(T.length)))
    {
	static if (!is(T == typeof(T.init)))
	{			// abuses the fact that int[5].init == int
	    static if (is(T == typeof(T[0])[inst.length]))
	    {	// санитарная проверка. самой по себе этой проверки недостаточно, так как dmd жалуется на динамические массивы
		const bool res = true;
	    }
	    else
		const bool res = false;
	}
	else
	    const bool res = false;
    }
    else
    {
	    const bool res = false;
    }
}
/**
 * Определить, является ли тип T статическим массивом.
 */
template isStaticArray(T)
{
    const bool isStaticArray = isStaticArray_impl!(T).res;
}


static assert (isStaticArray!(int[51]));
static assert (isStaticArray!(int[][2]));
static assert (isStaticArray!(char[][int][11]));
static assert (!isStaticArray!(int[]));
static assert (!isStaticArray!(int[char]));
static assert (!isStaticArray!(int[1][]));

/**
 * Определить, является ли кортеж T кортежем выражений.
 */
template isExpressionTuple(T ...)
{
    static if (is(void function(T)))
	const bool isExpressionTuple = false;
    else
	const bool isExpressionTuple = true;
}



