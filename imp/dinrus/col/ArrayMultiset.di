/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.ArrayMultiset;

public import col.model.Multiset;

private import col.Link;
private import col.DefaultAllocator;

/+ ИНТЕРФЕЙС:

class МассивМультинабор(З, alias Разместитель=ДефолтныйРазместитель) : Мультинабор!(З)
{
    alias МассивМультинабор!(З, Разместитель) ТипМассивМультинабор;

    struct курсор
    {
        З значение();
        З значение(З з);
        курсор opPostInc();
        курсор opPostDec();
        курсор opAddAssign(цел прир);
        курсор opSubAssign(цел прир);
        бул opEquals(курсор обх);
    }

    final цел очистить(цел delegate(ref бул чистить_ли, ref З з) дг);
    цел opApply(цел delegate(ref З з) дг);
    this(бцел gs = 31);
    ТипМассивМультинабор очисти();
    бцел длина();
    курсор начало();
    курсор конец();
    курсор удали(курсор обх);
    курсор найди(З з);
    бул содержит(З з);
    ТипМассивМультинабор удали(З з);
    ТипМассивМультинабор удали(З з, ref бул был_Удалён);
    ТипМассивМультинабор добавь(З з);
    ТипМассивМультинабор добавь(З з, ref бул был_добавлен);
    ТипМассивМультинабор добавь(Обходчик!(З) обх);
    ТипМассивМультинабор добавь(Обходчик!(З) обх, ref бцел чло_добавленных);
    ТипМассивМультинабор добавь(З[] массив);
    ТипМассивМультинабор добавь(З[] массив, ref бцел чло_добавленных);
    бцел счёт(З з);
    ТипМассивМультинабор удалиВсе(З з);
    ТипМассивМультинабор удалиВсе(З з, ref бцел чло_Удалённых);
    ТипМассивМультинабор dup();
    З дай();
    З изыми();
}
+///===============================================================================

/**
 * This class implements the multiset interface by keeping a linked list of
 * arrays to store the elements.  Because the установи does not need to maintain a
 * specific order, removal and addition is an O(1) operation.
 *
 * Removing an элемент invalidates all cursors.
 *
 * Adding an элемент does not invalidate any cursors.
 */
class МассивМультинабор(З, alias Разместитель=ДефолтныйРазместитель) : Мультинабор!(З)
{
    private alias Связка!(З[]).Узел узел;
    private alias Разместитель!(Связка!(З[])) разместитель;
    private разместитель разм;
    private узел _голова;
    private бцел _счёт;

    private бцел _growSize;

    private узел размести()
    {
        return разм.размести;
    }

    private узел размести(З[] з)
    {
        auto n = размести;
        n.значение = з;
        return n;
    }

    alias МассивМультинабор!(З, Разместитель) ТипМассивМультинабор;

    /**
     * A курсор is like a pointer into the МассивМультинабор collection.
     */
    struct курсор
    {
        private узел укз; alias укз ptr;
        private бцел инд;

        /**
         * returns the значение pointed at by the курсор
         */
        З значение()
        {
            return укз.значение[инд];
        }

        /**
         * Sets the значение pointed at by the курсор.
         */
        З значение(З з)
        {
            return (укз.значение[инд] = з);
        }

        /**
         * increment the курсор, returns what the курсор was перед
         * incrementing
         */
        курсор opPostInc()
        {
            курсор врм = *this;
            инд++;
            if(инд >= укз.значение.length)
            {
                инд = 0;
                укз = укз.следщ;
            }
            return врм;
        }

        /**
         * decrement the курсор, returns what the курсор was перед
         * decrementing
         */
        курсор opPostDec()
        {
            курсор врм = *this;
            if(инд == 0)
            {
                укз = укз.предш;
                инд = укз.значение.length - 1;
            }
            else
                инд--;
            return врм;
        }

        /**
         * добавь a given значение to the курсор.
         *
         * Runs in O(n) time, but the constant is < 1
         */
        курсор opAddAssign(цел прир)
        {
            if(прир < 0)
                return opSubAssign(-прир);
            while(прир >= укз.значение.length - инд)
            {
                прир -= (укз.значение.length - инд);
                укз = укз.следщ;
                инд = 0;
            }
            инд += прир;
            return *this;
        }

        /**
         * subtract a given значение from the курсор.
         *
         * Runs in O(n) time, but the constant is < 1
         */
        курсор opSubAssign(цел прир)
        {
            if(прир < 0)
                return opAddAssign(-прир);
            while(прир > инд)
            {
                прир -= инд;
                укз = укз.предш;
                инд = укз.значение.length;
            }
            инд -= прир;
            return *this;
        }

        /**
         * compare two cursors for equality
         */
        бул opEquals(курсор обх)
        {
            return обх.ptr is укз && обх.инд is инд;
        }
    }

    /**
     * Iterate over the items in the МассивМультинабор, specifying which elements
     * should be removed.
     *
     * Use like this:
     * ----------
     * // удали all odd elements
     * foreach(ref чистить_ли, элт; &МассивМультинабор.очистить)
     * {
     *    чистить_ли = ((элт & 1) == 1)
     * }
     */
    final цел очистить(цел delegate(ref бул чистить_ли, ref З з) дг)
    {
        return _примени(дг);
    }

    private цел _примени(цел delegate(ref бул чистить_ли, ref З з) дг)
    {
        курсор обх = начало;
        бул чистить_ли;
        цел возврдг = 0;
        курсор _конец = конец; // cache конец so обх isn'т always being generated
        while(!возврдг && обх != _конец)
        {
            чистить_ли = false;
            if((возврдг = дг(чистить_ли, обх.ptr.значение[обх.инд])) != 0)
                break;
            if(чистить_ли)
                обх = удали(обх);
            else
                обх++;
        }
        return возврдг;
    }

    /**
     * Iterate over the collection
     */
    цел opApply(цел delegate(ref З з) дг)
    {
        цел _дг(ref бул чистить_ли, ref З з)
        {
            return дг(з);
        }
        return _примени(&_дг);
    }

    /**
     * Create an МассивМультинабор with the given grow size.  The grow size is
     * используется to размести new arrays to поставь to the linked list.
     */
    this(бцел gs = 31)
    {
        _growSize = gs;
        _голова = разм.размести();
        узел.крепи(_голова, _голова);
        _счёт = 0;
    }

    /**
     * Clear the collection of all values
     */
    ТипМассивМультинабор очисти()
    {
        static if(разместитель.нужноСвоб)
        {
            разм.освободиВсе();
            _голова = размести;
        }
        узел.крепи(_голова, _голова);
        return this;
    }

    /**
     * Returns the number of elements in the collection
     */
    бцел длина()
    {
        return _счёт;
    }
	alias длина length;

    /**
     * Returns a курсор that points to the первый элемент of the collection.
     */
    курсор начало()
    {
        курсор обх;
        обх.ptr = _голова.следщ;
        обх.инд = 0;
        return обх;
    }

    /**
     * Returns a курсор that points just past the последн элемент of the
     * collection.
     */
    курсор конец()
    {
        курсор обх;
        обх.ptr = _голова;
        обх.инд = 0;
        return обх;
    }

    /**
     * Removes the элемент pointed at by the курсор.  Returns a valid
     * курсор that points to another элемент or конец if the элемент removed
     * was the последн элемент.
     *
     * Runs in O(1) time.
     */
    курсор удали(курсор обх)
    {
        узел последн = _голова.предш;
        if(обх.ptr is последн && обх.инд is последн.значение.length - 1)
        {
            обх = конец;
        }
        else
        {
            обх.значение = последн.значение[$-1];
        }
        последн.значение.length = последн.значение.length - 1;
        if(последн.значение.length == 0)
        {
            последн.открепи;
            static if(разместитель.нужноСвоб)
                разм.освободи(последн);
        }
        _счёт--;
        return обх;
    }

    /**
     * Returns a курсор that points to the первый occurrence of з
     *
     * Runs in O(n) time.
     */
    курсор найди(З з)
    {
        курсор обх = начало;
        курсор _конец = конец;
        while(обх != _конец && обх.значение != з)
            обх++;
        return обх;
    }

    /**
     * Returns true if з is an элемент in the установи
     *
     * Runs in O(n) time.
     */
    бул содержит(З з)
    {
        return найди(з) != конец;
    }

    /**
     * удали the given элемент from the установи.  This removes the первый
     * occurrence only.
     *
     * Returns true if the элемент was found and removed.
     *
     * Runs in O(n) time.
     */
    ТипМассивМультинабор удали(З з)
    {
        бул пропущен;
        return удали(з, пропущен);
    }

    /**
     * удали the given элемент from the установи.  This removes the первый
     * occurrence only.
     *
     * Returns true if the элемент was found and removed.
     *
     * Runs in O(n) time.
     */
    ТипМассивМультинабор удали(З з, ref бул был_Удалён)
    {
        курсор обх = найди(з);
        if(обх == конец)
            был_Удалён = false;
        else
        {
            удали(обх);
            был_Удалён = true;
        }
        return this;
    }

    /**
     * Adds the given элемент to the установи.
     *
     * Returns true.
     *
     * Runs in O(1) time.
     */
    ТипМассивМультинабор добавь(З з)
    {
        бул пропущен;
        return добавь(з, пропущен);
    }
    /**
     * Adds the given элемент to the установи.
     *
     * Returns true.
     *
     * Runs in O(1) time.
     */
    ТипМассивМультинабор добавь(З з, ref бул был_добавлен)
    {
        узел последн = _голова.предш;
        if(последн is _голова || последн.значение.length == _growSize)
        {
            //
            // pre-размести массив длина, then установи the длина to 0
            //
            auto массив = new З[_growSize];
            массив.length = 0;
            _голова.приставь(размести(массив));
            последн = _голова.предш;
        }

        последн.значение ~= з;
        был_добавлен = true;
        _счёт++;
        return this;
    }

    //
    // these can probably be optimized more
    //

    /**
     * Adds all the values from the given iterator into the установи.
     *
     * Returns the number of elements добавленный.
     */
    ТипМассивМультинабор добавь(Обходчик!(З) обх)
    {
        бцел пропущен;
        return добавь(обх, пропущен);
    }

    /**
     * Adds all the values from the given iterator into the установи.
     *
     * Returns the number of elements добавленный.
     */
    ТипМассивМультинабор добавь(Обходчик!(З) обх, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        foreach(з; обх)
            добавь(з);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Adds all the values from the given массив into the установи.
     *
     * Returns the number of elements добавленный.
     */
    ТипМассивМультинабор добавь(З[] массив)
    {
        бцел пропущен;
        return добавь(массив, пропущен);
    }

    /**
     * Adds all the values from the given массив into the установи.
     *
     * Returns the number of elements добавленный.
     */
    ТипМассивМультинабор добавь(З[] массив, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        foreach(з; массив)
            добавь(з);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Count the number of occurrences of з
     *
     * Runs in O(n) time.
     */
    бцел счёт(З з)
    {
        бцел возврзнач = 0;
        foreach(x; this)
            if(з == x)
                возврзнач++;
        return возврзнач;
    }

    /**
     * Remove all the occurrences of з.  Returns the number of экземпляры that
     * were removed.
     *
     * Runs in O(n) time.
     */
    ТипМассивМультинабор удалиВсе(З з)
    {
        бцел пропущен;
        return удалиВсе(з, пропущен);
    }
    /**
     * Remove all the occurrences of з.  Returns the number of экземпляры that
     * were removed.
     *
     * Runs in O(n) time.
     */
    ТипМассивМультинабор удалиВсе(З з, ref бцел чло_Удалённых)
    {
        бцел исхдлина = длина;
        foreach(ref dp, x; &очистить)
        {
            dp = cast(бул)(з == x);
        }
        чло_Удалённых = исхдлина - длина;
        return this;
    }

    /**
     * duplicate this container.  This does not do a 'deep' copy of the
     * elements.
     */
    ТипМассивМультинабор dup()
    {
        auto возврзнач = new ТипМассивМультинабор(_growSize);
        узел n = _голова.следщ;
        while(n !is _голова)
        {
            узел x;
            if(n.значение.length == _growSize)
                x = возврзнач.размести(n.значение.dup);
            else
            {
                auto массив = new З[_growSize];
                массив.length = n.значение.length;
                массив[0..$] = n.значение[];
                x = возврзнач.размести(массив);
            }
            возврзнач._голова.приставь(x);
        }
        возврзнач._счёт = _счёт;
        return возврзнач;
    }

    /**
     * дай the most convenient элемент in the установи.  This is the элемент that
     * would be iterated первый.  Therefore, calling удали(дай()) is
     * guaranteed to be less than an O(n) operation.
     */
    З дай()
    {
        return начало.значение;
    }

    /**
     * Remove the most convenient элемент from the установи, and return its значение.
     * This is equivalent to удали(дай()), except that only one lookup is
     * performed.
     */
    З изыми()
    {
        auto c = начало;
        auto возврзнач = c.значение;
        удали(c);
        return возврзнач;
    }
}

version(UnitTest)
{
    void main()
    {
        auto ms = new МассивМультинабор!(бцел);
        ms.добавь([0U, 1, 2, 3, 4, 5]);
        assert(ms.length == 6);
        ms.удали(1);
        assert(ms.length == 5);
        assert(ms._голова.следщ.значение == [0U, 5, 2, 3, 4]);
        foreach(ref бул очистить_ли, бцел з; &ms.очистить)
            очистить_ли = (з % 2 == 1);
        assert(ms.length == 3);
        assert(ms._голова.следщ.значение == [0U, 4, 2]);
    }
}
