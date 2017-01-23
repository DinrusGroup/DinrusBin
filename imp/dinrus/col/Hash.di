/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.Hash;

private import col.Link;
private import col.model.Iterator;
private import col.DefaultAllocator;

/+  ИНТЕРФЕЙС:

struct ДефолтыХэш
{
    const плав факторЗагрузки = .75;
    const бцел размерТаблицы = 31;
}


struct Хэш(З, alias хэшФункц, alias обновлФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель, бул допускатьДубликаты=нет, бул обновить_ли=да)
{
 Связка!(З).Узел узел;
 alias Разместитель!(Связка!(З)) разместитель;
 разместитель разм;
 узел[] таблица;
 бцел счёт;
    struct позиция
    {
        Хэш *владелец;
        узел укз; alias укз ptr;
        цел инд;
        позиция следщ();
        позиция предш();
    бул добавь(З з);
    проц перемерьПод(бцел ёмкость);
    проц проверьФакторЗагрузки();
    позиция начало();
    позиция конец();
    позиция найди(З з);
    позиция удали(позиция поз);
    проц очисти();
    бцел накладка(Обходчик!(З) поднабор);;
        бцел считайВсе(З з);
        бцел удалиВсе(З з);
        позиция найди(З з, позиция начатьС);
    проц копируйВ(ref Хэш цель);
    узел размести();
    узел размести(З з);
    проц установка();
}


template ХэшБезОбновлений(З, alias хэшФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель);

template ХэшДуб(З, alias хэшФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель);

+/
//==================================================================
struct ДефолтыХэш
{
    const плав факторЗагрузки = .75;
    const бцел размерТаблицы = 31;
}

/**
 * Default Хэш implementation.  This is используется in the Хэш* containers by
 * default.
 *
 * The implementation consists of a таблица of linked lists.  The таблица index
 * that an элемент goes in is based on the hash code.
 */
struct Хэш(З, alias хэшФункц, alias обновлФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель, бул допускатьДубликаты=false, бул обновить_ли=true)
{
    /**
     * alias for Узел
     */
    alias Связка!(З).Узел узел;

    /**
     * alias for the Разместитель
     */
    alias Разместитель!(Связка!(З)) разместитель;

    /**
     * The Разместитель for the hash
     */
    разместитель разм;

    /**
     * the таблица of buckets
     */
    узел[] таблица;

    /**
     * счёт of elements in the таблица
     */
    бцел счёт;

    /**
     * This is like a pointer, используется to point to a given элемент in the hash.
     */
    struct позиция
    {
        Хэш *владелец;
        узел укз; alias укз ptr;
        цел инд;

        /**
         * Returns the позиция that comes after p.
         */
        позиция следщ()
        {
            позиция p = *this;
            auto таблица = владелец.таблица;

            if(p.ptr !is null)
            {
                if(p.ptr.следщ is таблица[p.инд])
                    //
                    // special case, at the конец of a bucket, go to the следщ
                    // bucket.
                    //
                    p.ptr = null;
                else
                {
                    //
                    // still in the bucket
                    //
                    p.ptr = p.ptr.следщ;
                    return p;
                }
            }

            //
            // iterated past the bucket, go to the следщ valid bucket
            //
            while(p.инд < cast(цел)таблица.length && p.ptr is null)
            {
                if(++p.инд < таблица.length)
                    p.ptr = таблица[p.инд];
                else
                    p.ptr = null;
            }
            return p;
        }

        /**
         * Returns the позиция that comes перед p.
         */
        позиция предш()
        {
            позиция p = *this;
            auto таблица = владелец.таблица;
            if(p.ptr !is null)
            {
                if(p.ptr is таблица[p.инд])
                    p.ptr = null;
                else
                {
                    p.ptr = p.ptr.предш;
                    return p;
                }
            }

            while(p.инд > 0 && p.ptr is null)
                p.ptr = таблица[--p.инд];
            if(p.ptr)
                //
                // go to the конец of the new bucket
                //
                p.ptr = p.ptr.предш;
            return p;
        }
    }

    /**
     * Add a значение to the hash.  Returns true if the значение was not present,
     * false if обх was updated.
     */
    бул добавь(З з)
    {
        if(таблица is null)
            перемерьПод(исходнРазмерТаблицы);

        auto h = хэшФункц(з) % таблица.length;
        узел хвост = таблица[h];
        if(хвост is null)
        {
            //
            // no узел yet, добавь the new узел here
            //
            хвост = таблица[h] = размести(з);
            узел.крепи(хвост, хвост);
            счёт++;
            return true;
        }
        else
        {
            static if(!допускатьДубликаты)
            {
                узел элт = findInBucket(хвост, з, хвост);
                if(элт is null)
                {
                    счёт++;
                    хвост.приставь(размести(з));
                    // not single элемент, need to проверь load factor
                    проверьФакторЗагрузки();
                    return true;
                }
                else
                {
                    //
                    // found the узел, установи the значение instead
                    //
                    static if(обновить_ли)
                        обновлФункц(элт.значение, з);
                    return false;
                }
            }
            else
            {
                //
                // always добавь, even if the узел already exists.
                //
                счёт++;
                хвост.приставь(размести(з));
                // not single элемент, need to проверь load factor
                проверьФакторЗагрузки();
                return true;
            }
        }
    }

    /**
     * Resize the hash таблица to the given ёмкость.  Normally only called
     * privately.
     */
    проц перемерьПод(бцел ёмкость)
    {
        if(ёмкость > таблица.length)
        {
            auto новТабл = new узел[ёмкость];

            foreach(голова; таблица)
            {
                if(голова)
                {
                    //
                    // make the последн узел point to null, to mark the конец of
                    // the bucket
                    //
                    узел.крепи(голова.предш, null);
                    for(узел тек = голова, следщ = голова.следщ; тек !is null;
                            тек = следщ)
                    {
                        следщ = тек.следщ;
                        auto h = хэшФункц(тек.значение) % новТабл.length;
                        узел новГолова = новТабл[h];
                        if(новГолова is null)
                        {
                            новТабл[h] = тек;
                            узел.крепи(тек, тек);
                        }
                        else
                            новГолова.приставь(тек);
                    }
                }
            }
            delete таблица;
            таблица = новТабл;
        }
    }

    /**
     * Check to see whether the load factor dictates a перемерьПод is in order.
     */
    проц проверьФакторЗагрузки()
    {
        if(таблица !is null)
        {
            плав fc = cast(плав) счёт;
            плав ft = таблица.length;

            if(fc / ft > факторЗагрузки)
                перемерьПод(2 * cast(бцел)(fc / факторЗагрузки) + 1);
        }
    }

    /**
     * Returns a позиция that points to the первый элемент in the hash.
     */
    позиция начало()
    {
        if(счёт == 0)
            return конец;
        позиция рез;
        рез.ptr = null;
        рез.владелец = this;
        рез.инд = -1;
        //
        // this finds the первый valid узел
        //
        return рез.следщ;
    }

    /**
     * Returns a позиция that points past the последн элемент of the hash.
     */
    позиция конец()
    {
        позиция рез;
        рез.инд = таблица.length;
        рез.владелец = this;
        return рез;
    }

    // private function используется to implement common pieces
    private узел findInBucket(узел bucket, З з, узел начатьС)
    in
    {
        assert(bucket !is null);
    }
    body
    {
        if(начатьС.значение == з)
            return начатьС;
        узел n;
        for(n = начатьС.следщ; n !is bucket && n.значение != з; n = n.следщ)
        {
        }
        return (n is bucket ? null : n);
    }

    /**
     * Find the первый instance of a значение
     */
    позиция найди(З з)
    {
        if(счёт == 0)
            return конец;
        auto h = хэшФункц(з) % таблица.length;
        // if bucket is empty, or doesn'т contain з, return конец
        узел укз;
        if(таблица[h] is null || (укз = findInBucket(таблица[h], з, таблица[h])) is null)
            return конец;
        позиция p;
        p.владелец = this;
        p.инд = h;
        p.ptr = укз;
        return p;
    }

    /**
     * Remove a given позиция from the hash.
     */
    позиция удали(позиция поз)
    {
        позиция возврзнач = поз.следщ;
        if(поз.ptr is таблица[поз.инд])
        {
            if(поз.ptr.следщ is поз.ptr)
                таблица[поз.инд] = null;
            else
                таблица[поз.инд] = поз.ptr.следщ;
        }
        поз.ptr.открепи;
        static if(разместитель.нужноСвоб)
            разм.освободи(поз.ptr);
        счёт--;
        return возврзнач;
    }

    /**
     * Remove all values from the hash
     */
    проц очисти()
    {
        static if(разместитель.нужноСвоб)
            разм.освободиВсе();
        delete таблица;
        таблица = null;
        счёт = 0;
    }

    /**
     * keep only elements that appear in поднабор
     *
     * returns the number of elements removed
     */
    бцел накладка(Обходчик!(З) поднабор)
    {
        if(счёт == 0)
            return 0;
        //
        // старт out removing all nodes, then filter out ones that are in the
        // установи.
        //
        бцел рез = счёт;
        auto врм = new узел[таблица.length];

        foreach(ref з; поднабор)
        {
            позиция p = найди(з);
            if(p.инд != таблица.length)
            {
                //
                // found the узел in the current таблица, добавь обх to the new
                // таблица.
                //
                узел голова = врм[p.инд];

                //
                // need to update the таблица pointer if this is the голова узел in that cell
                //
                if(p.ptr is таблица[p.инд])
                {
                    if(p.ptr.следщ is p.ptr)
                        таблица[p.инд] = null;
                    else
                        таблица[p.инд] = p.ptr.следщ;
                }

                if(голова is null)
                {
                    врм[p.инд] = p.ptr.открепи;
                    узел.крепи(p.ptr, p.ptr);
                }
                else
                    голова.приставь(p.ptr.открепи);
                рез--;
            }
        }

        static if(разместитель.нужноСвоб)
        {
            //
            // now, we must освободи all the unused nodes
            //
            foreach(голова; таблица)
            {
                if(голова !is null)
                {
                    //
                    // since we will освободи голова, mark the конец of the list with
                    // a null pointer
                    //
                    узел.крепи(голова.предш, null);
                    while(голова !is null)
                    {
                        auto newhead = голова.следщ;
                        разм.освободи(голова);
                        голова = newhead;
                    }
                }
            }
        }
        таблица = врм;
        счёт -= рез;
        return рез;
    }

    static if(допускатьДубликаты)
    {
        // private function to do the dirty work of считайВсе and удалиВсе
        private бцел _applyAll(З з, бул удали)
        {
            позиция p = найди(з);
            бцел рез = 0;
            if(p.инд != таблица.length)
            {
                auto bucket = таблица[p.инд];
                do
                {
                    if(p.ptr.значение == з)
                    {
                        рез++;
                        if(удали)
                        {
                            auto исх = p.ptr;
                            p.ptr = p.ptr.следщ;
                            исх.открепи();
                            static if(разместитель.нужноСвоб)
                            {
                                разм.освободи(исх);
                            }
                            continue;
                        }
                    }

                    p.ptr = p.ptr.следщ;
                }
                while(p.ptr !is bucket)
            }
            return рез;
        }

        /**
         * счёт the number of times a given значение appears in the hash
         */
        бцел считайВсе(З з)
        {
            return _applyAll(з, false);
        }

        /**
         * удали all the экземпляры of з that appear in the hash
         */
        бцел удалиВсе(З з)
        {
            return _applyAll(з, true);
        }

        /**
         * Find a given значение in the hash, starting from the given позиция.
         * If the позиция is beyond the последн instance of з (which can be
         * determined if the позиция's bucket is beyond the bucket where з
         * should go).
         */
        позиция найди(З з, позиция начатьС)
        {
            if(счёт == 0)
                return конец;
            auto h = хэшФункц(з) % таблица.length;
            if(начатьС.инд < h)
            {
                // if bucket is empty, return конец
                if(таблица[h] is null)
                    return конец;

                // старт from the bucket that the значение would live in
                начатьС.инд = h;
                начатьС.ptr = таблица[h];
            }
            else if(начатьС.инд > h)
                // beyond the bucket, return конец
                return конец;

            if((начатьС.ptr = findInBucket(таблица[h], з, начатьС.ptr)) !is
                    null)
                return начатьС;
            return конец;
        }
    }

    /**
     * copy all the elements from this hash to цель.
     */
    проц копируйВ(ref Хэш цель)
    {
        //
        // copy all local values
        //
        цель = *this;

        //
        // reset разместитель
        //
        цель.разм = цель.разм.init;

        //
        // reallocate all the nodes in the таблица
        //
        цель.таблица = new узел[таблица.length];
        foreach(i, n; таблица)
        {
            if(n !is null)
                цель.таблица[i] = n.dup(&цель.размести);
        }
    }

    узел размести()
    {
        return разм.размести();
    }

    узел размести(З з)
    {
        auto рез = размести();
        рез.значение = з;
        return рез;
    }

    /**
     * Perform any установка necessary (none for this hash impl)
     */
    проц установка()
    {
    }
}

/**
 * используется to define a Хэш that does not perform updates
 */
template ХэшБезОбновлений(З, alias хэшФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель)
{
    // note the второй хэшФункц isn'т используется because обновлять_ли is false
    alias Хэш!(З, хэшФункц, хэшФункц, факторЗагрузки, исходнРазмерТаблицы, Разместитель, false, false) ХэшБезОбновлений;
}

/**
 * используется to define a Хэш that takes duplicates
 */
template ХэшДуб(З, alias хэшФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель)
{
    // note the второй хэшФункц isn'т используется because обновлять_ли is false
    alias Хэш!(З, хэшФункц, хэшФункц, факторЗагрузки, исходнРазмерТаблицы, Разместитель, true, false) ХэшДуб;
}
