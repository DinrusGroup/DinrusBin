/**
  *
  * Copyright:  Copyright (C) 2008 Chris Wright.  все rights reserved.
  * License:    BSD стиль: $(LICENSE)
  * Версия:    Oct 2008: Initial release
  * Author:     Chris Wright, aka dhasenan
  *
  */

module util.container.more.Heap;

private import exception;

бул minHeapCompare(T)(T a, T b) {return a <= b;}
бул maxHeapCompare(T)(T a, T b) {return a >= b;}
проц defaultHeapSwap(T)(T t, бцел индекс) {}

/** A куча is a данные structure where you can вставь items in random order и выкинь them in sorted order. 
  * Pushing an элемент преобр_в the куча takes O(lg n) и popping the верх of the куча takes O(lg n). Heaps are 
  * thus popular for sorting, among другой things.
  * 
  * No opApply is provопрed, since most people would expect this в_ return the contents in sorted order,
  * not do significant куча allocation, not modify the collection, и complete in linear время. This
  * combination is not possible with a куча. 
  *
  * Note: always пароль by reference when modifying a куча. 
  *
  * The template аргументы в_ the куча are:
  *     T       = the элемент тип
  *     Сравни = a function called when ordering элементы. Its сигнатура should be бул(T, T).
  *               see minHeapCompare() и maxHeapCompare() for examples.
  *     Move    = a function called when свопping элементы. Its сигнатура should be проц(T, бцел).
  *               The default does nothing, и should suffice for most users. You 
  *               probably want в_ keep this function small; it's called O(лог N) 
  *               times per insertion or removal.
*/

struct Куча (T, alias Сравни = minHeapCompare!(T), alias Move = defaultHeapSwap!(T))
{
        alias вынь       удали;
        alias сунь      opCatAssign;

        // The actual данные.
        private T[]     куча;
        
        // The индекс of the ячейка преобр_в which the следщ элемент will go.
        private бцел    следщ;

        /** Inserts the given элемент преобр_в the куча. */
        проц сунь (T t)
        {
                auto индекс = следщ++;
                while (куча.length <= индекс)
                       куча.length = 2 * куча.length + 32;

                куча [индекс] = t;
                Move (t, индекс);
                fixup (индекс);
        }

        /** Inserts все элементы in the given Массив преобр_в the куча. */
        проц сунь (T[] Массив)
        {
                if (куча.length < следщ + Массив.length)
                        куча.length = следщ + Массив.length + 32;

                foreach (t; Массив) сунь (t);
        }

        /** Removes the верх of this куча и returns it. */
        T вынь ()
        {
                return удалиПо (0);
        }

        /** Удали the every экземпляр that совпадает the given item. */
        проц удалиВсе (T t)
        {
                // TODO: this is slower than it could be.
                // I am reasonably certain we can do the O(n) скан, but I want в_
                // look at it a bit ещё.
                while (удали (t)) {}
        }

        /** Удали the первый экземпляр that совпадает the given item. 
          * Возвращает: да iff the item was найдено, otherwise нет. */
        бул удали (T t)
        {
                foreach (i, a; куча)
                {
                        if (a is t || a == t)
                        {
                                удалиПо (i);
                                return да;
                        }
                }
                return нет;
        }

        /** Удали the элемент at the given индекс из_ the куча.
          * The индекс is according в_ the куча's internal выкладка; you are 
          * responsible for making sure the индекс is correct.
          * The куча invariant is maintained. */
        T удалиПо (бцел индекс)
        {
                if (следщ <= индекс)
                {
                        throw new НетЭлементаИскл ("куча :: tried в_ удали an"
                                ~ " элемент with индекс greater than the размер of the куча "
                                ~ "(dопр you вызов вынь() из_ an пустой куча?)");
                }
                следщ--;
                auto t = куча[индекс];
                // if следщ == индекс, then we have nothing действителен on the куча
                // so popping does nothing but change the length
                // the другой calls are irrelevant, but we surely don't want в_
                // вызов Move with не_годится данные
                if (следщ > индекс)
                {
                        куча[индекс] = куча[следщ];
                        Move(куча[индекс], индекс);
                        fixdown(индекс);

                        // добавьed via ticket 1885 (kudos в_ wolfwood)
                        if (куча[индекс] is куча[следщ])
                            fixup(индекс);
                }
                return t;
        }

        /** Gets the значение at the верх of the куча without removing it. */
        T Просмотр ()
        {
                assert (следщ > 0);
                return куча[0];
        }

        /** Returns the число of элементы in this куча. */
        бцел размер ()
        {
                return следщ;
        }

        /** Reset this куча. */
        проц очисть ()
        {
                следщ = 0;
        }

        /** сбрось this куча, и use the provопрed хост for значение элементы */
        проц очисть (T[] хост)
        {
                this.куча = хост;
                очисть;
        }

        /** Get the reserved ёмкость of this куча. */
        бцел ёмкость ()
        {
                return куча.length;
        }

        /** Reserve enough пространство in this куча for значение элементы. The reserved пространство is truncated or extended as necessary. If the значение is less than the число of элементы already in the куча, throw an исключение. */
        бцел ёмкость (бцел значение)
        {
                if (значение < следщ)
                {
                        throw new ИсклНелегальногоАргумента ("куча :: illegal truncation");
                }
                куча.length = значение;
                return значение;
        }

        /** Return a shallow копируй of this куча. */
        Куча клонируй ()
        {
                куча другой;
                другой.куча = this.куча.dup;
                другой.следщ = this.следщ;
                return другой;
        }

        // Get the индекс of the предок for the элемент at the given индекс.
        private бцел предок (бцел индекс)
        {
                return (индекс - 1) / 2;
        }

        // Having just inserted, restore the куча invariant (that a узел's значение is greater than its ветви)
        private проц fixup (бцел индекс)
        {
                if (индекс == 0) return;
                бцел par = предок (индекс);
                if (!Сравни(куча[par], куча[индекс]))
                {
                        обменяй (par, индекс);
                        fixup (par);
                }
        }

        // Having just removed и replaced the верх of the куча with the последний inserted элемент,
        // restore the куча invariant.
        private проц fixdown (бцел индекс)
        {
                бцел left = 2 * индекс + 1;
                бцел down;
                if (left >= следщ)
                {
                        return;
                }

                if (left == следщ - 1)
                {
                        down = left;
                }
                else if (Сравни (куча[left], куча[left + 1]))
                {
                        down = left;
                }
                else
                {
                        down = left + 1;
                }

                if (!Сравни(куча[индекс], куча[down]))
                {
                        обменяй (индекс, down);
                        fixdown (down);
                }
        }

        // Swap two элементы in the Массив.
        private проц обменяй (бцел a, бцел b)
        {
                auto t1 = куча[a];
                auto t2 = куча[b];
                куча[a] = t2;
                Move(t2, a);
                куча[b] = t1;
                Move(t1, b);
        }
}


/** A minheap implementation. This will have the smallest item as the верх of the куча. 
  *
  * Note: always пароль by reference when modifying a куча. 
  *
*/

template МинКуча(T)
{
        alias Куча!(T, minHeapCompare) МинКуча;
}

/** A maxheap implementation. This will have the largest item as the верх of the куча. 
  *
  * Note: always пароль by reference when modifying a куча. 
  *
*/

template МаксКуча(T)
{
        alias Куча!(T, maxHeapCompare) МаксКуча;
}



debug (UnitTest)
{
unittest
{
        МинКуча!(бцел) h;
        assert (h.размер is 0);
        h ~= 1;
        h ~= 3;
        h ~= 2;
        h ~= 4;
        assert (h.размер is 4);

        assert (h.Просмотр is 1);
        assert (h.Просмотр is 1);
        assert (h.размер is 4);
        h.вынь;
        assert (h.Просмотр is 2);
        assert (h.размер is 3);
}

unittest
{
        МинКуча!(бцел) h;
        assert (h.размер is 0);
        h ~= 1;
        h ~= 3;
        h ~= 2;
        h ~= 4;
        assert (h.размер is 4);

        assert (h.вынь is 1);
        assert (h.размер is 3);
        assert (h.вынь is 2);
        assert (h.размер is 2);
        assert (h.вынь is 3);
        assert (h.размер is 1);
        assert (h.вынь is 4);
        assert (h.размер is 0);
}

unittest
{
        МаксКуча!(бцел) h;
        h ~= 1;
        h ~= 3;
        h ~= 2;
        h ~= 4;

        assert (h.вынь is 4);
        assert (h.вынь is 3);
        assert (h.вынь is 2);
        assert (h.вынь is 1);
}

unittest
{
        МаксКуча!(бцел) h;
        h ~= 1;
        h ~= 3;
        h ~= 2;
        h ~= 4;
        h.удали(3);
        assert (h.вынь is 4);
        assert (h.вынь is 2);
        assert (h.вынь is 1);
        assert (h.размер == 0);
}

дол[] переставленные;
бцел[] индексы;
проц приПеремещении(дол a, бцел b)
{
        переставленные ~= a;
        индексы ~= b;
}
unittest
{
        // this tests that приПеремещении is called with fixdown
        переставленные = пусто;
        индексы = пусто;
        Куча!(дол, minHeapCompare, приПеремещении) h;
        // no обменяй
        h ~= 1;
        // no обменяй
        h ~= 3;

        // приПеремещении() is called for все insertions
        переставленные = пусто;
        индексы = пусто;
        // вынь: you замени the верх with the последний и
        // percolate down. So you have в_ обменяй once when
        // popping at a minimum, и that's if you have only two
        // items in the куча.
        assert (h.вынь is 1);
        assert (переставленные.length == 1, "" ~ cast(сим)('a' + переставленные.length));
        assert (переставленные[0] == 3);
        assert (индексы[0] == 0);
        assert (h.вынь is 3);
        assert (переставленные.length == 1, "" ~ cast(сим)('a' + переставленные.length));
}
unittest
{
        // this tests that приПеремещении is called with fixup
        переставленные = пусто;
        индексы = пусто;
        Куча!(дол, minHeapCompare, приПеремещении) h;
        // no обменяй
        h ~= 1;
        // no обменяй
        h ~= 3;
        // обменяй: перемести 0 в_ позиция 0, 1 в_ позиция 2
        h ~= 0;
        цел n=3; // приПеремещении() called for insertions too
        if (переставленные[n] == 0)
        {
                assert (переставленные[n+1] == 1);
                assert (индексы[n+0] == 0);
                assert (индексы[n+1] == 2);
        }
        else
        {
                assert (переставленные[n+1] == 0);
                assert (переставленные[n+0] == 1);
                assert (индексы[n+0] == 2);
                assert (индексы[n+1] == 0);
        }
}

unittest
{
        МаксКуча!(бцел) h;
        h ~= 1;
        h ~= 3;
        h ~= 2;
        h ~= 4;
        auto другой = h.клонируй;

        assert (другой.вынь is 4);
        assert (другой.вынь is 3);
        assert (другой.вынь is 2);
        assert (другой.вынь is 1);
        assert (h.размер is 4, "cloned куча shares данные with original куча");
        assert (h.вынь is 4, "cloned куча shares данные with original куча");
        assert (h.вынь is 3, "cloned куча shares данные with original куча");
        assert (h.вынь is 2, "cloned куча shares данные with original куча");
        assert (h.вынь is 1, "cloned куча shares данные with original куча");
}
}
