// Written in the D programming language
// written by Walter Bright
// www.digitalmars.com
// Placed into the public domain

/** Это встроенные в компилятор функции.
 *
	Подобные функции встраиваются в компилятор, в основном,
	для того, чтобы использовать определенные средства
	процессора, управлять которыми через внешние функции
	не вполне удобно и не эффективно.
	Оптимизатор и генератор кода компилятора полностью
	интегрируются во встроенные функции, что придает им
	полную действенность.
	Это способно приводить в неожиданным выигрышам в
	скорости компиляции.
 *
 * Copyright: Public Domain
 * License:   Public Domain
 * Authors:   Walter Bright
 * Macros:
 *	WIKI=Phobos/StdIntrinsic
 */

module std.intrinsic;

alias bsf сканбитвпер;
alias bsr сканбитрек;
alias bt тестбит;
alias btc тесбитуст;
alias btr тестбитнул;

/**
 * Сканирует биты в v, начиная с bit 0, ища
 * первый установленный бит.
 * Выдает:
 *	Номер первого установленного бита.
 *	Выдаваемое значение неопределено, если не ясно,
 * является ли v нулём.
 */
 int bsf(uint v);

/**
 * Сканирует биты в v от самого старшего (значимого) бита
 * к младшему, ища первый установленный бит.
 * Выдает:
 *	Выдаваемое значение неопределено, если не ясно,
 * является ли v нулём.
 * Пример:
 * ---
 * public import std.io;
 * public import std.intrinsic;
 *
 * int main()
 * {   
 *     uint v;
 *     int x;
 *
 *     v = 0x21;
 *     x = bsf(v);
 *     writefln("bsf(x%x) = %d", v, x);
 *     x = bsr(v);
 *     writefln("bsr(x%x) = %d", v, x);
 *     return 0;
 * } 
 * ---
 * Выводит:
 *  bsf(x21) = 0<br>
 *  bsr(x21) = 5
 */
 int bsr(uint v);

/**
 * Тестирует бит.
 */
 int bt(in uint *p, uint bitnum);

/**
 * Тестирует и заполняет бит.
 */
 int btc(uint *p, uint bitnum);

/**
 * Тестирует и обнуляет бит.
 */
 int btr(uint *p, uint bitnum);

/**
 * Тестирует и устанавливает бит.
 * Параметры:
 * p = ненулевой указатель на массив из uints.
 * index = номер бита, начиная с bit 0 из p[0],
 * и прогрессируя. Адресуется к битам как как выражение:
---
p[index / (uint.sizeof*8)] & (1 << (index & ((uint.sizeof*8) - 1)))
---
 * Выдает:
 * 	Ненулевое значение, если бит установлен, и ноль, если он
 *	пуст.
 *
 * Пример: 
 * ---
public import std.io;
public import std.intrinsic;

int main()
{   
    uint array[2];

    array[0] = 2;
    array[1] = 0x100;

    writefln("btc(array, 35) = %d", <b>btc</b>(array, 35));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    writefln("btc(array, 35) = %d", <b>btc</b>(array, 35));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    writefln("bts(array, 35) = %d", <b>bts</b>(array, 35));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    writefln("btr(array, 35) = %d", <b>btr</b>(array, 35));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    writefln("bt(array, 1) = %d", <b>bt</b>(array, 1));
    writefln("array = [0]:x%x, [1]:x%x", array[0], array[1]);

    return 0;
} 
 * ---
 * Выводится:
<pre>
btc(array, 35) = 0
array = [0]:x2, [1]:x108
btc(array, 35) = -1
array = [0]:x2, [1]:x100
bts(array, 35) = 0
array = [0]:x2, [1]:x108
btr(array, 35) = -1
array = [0]:x2, [1]:x100
bt(array, 1) = -1
array = [0]:x2, [1]:x100
</pre>
 */
 int bts(uint *p, uint bitnum);


/**
 * Меняет местами байты в 4-байтном uint из края в край, т.е. байт 0 становится
	байтом 3, байт 1 - байтом 2, байт 2 - байтом 1, байт 3
	- байтом 0.
 */
 uint bswap(uint v);


/**
 * Читает из порта I/O в  port_address.
 */
 ubyte  inp(uint port_address);

/**
 * ditto
 */
 ushort inpw(uint port_address);

/**
 * ditto
 */
 uint   inpl(uint port_address);


/**
 * Записывает и возвращает значение в порт I/O по  port_address.
 */
 ubyte  outp(uint port_address, ubyte value);

/**
 * ditto
 */
 ushort outpw(uint port_address, ushort value);

/**
 * ditto
 */
 uint   outpl(uint port_address, uint value);


