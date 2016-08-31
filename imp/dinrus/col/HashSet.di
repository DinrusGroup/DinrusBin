/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.HashSet;

public import col.model.Set;
public import col.Functions;
private import col.Hash;

/**
 * A установи implementation which uses a Хэш to have near O(1) insertion,
 * deletion and lookup time.
 *
 * Adding an элемент can invalidate cursors depending on the implementation.
 *
 * Removing an элемент only invalidates cursors that were pointing at that
 * элемент.
 *
 * You can replace the Хэш implementation with a custom implementation, the
 * Хэш must be a struct template which can be instantiated with a single
 * template argument V, and must implement the following members (non-function
 * members can be properties unless otherwise specified):
 *
 *
 * parameters -> must be a struct with at least the following members:
 *   хэшФункц -> the hash function to use (should be a ХэшФунк!(V))
 *   обновлФункц -> the update function to use (should be an
 *                     ФункцОбновления!(V))
 * 
 * проц установка(parameters p) -> initializes the hash with the given parameters.
 *
 * бцел счёт -> счёт of the elements in the hash
 *
 * позиция -> must be a struct with the following member:
 *   укз -> must define the following member:
 *     V значение -> the значение which is pointed to by this позиция (cannot be a
 *                property)
 *   позиция следщ -> must be the следщ значение in the hash
 *   позиция предш -> must be the previous значение in the hash
 *
 * бул добавь(V v) -> добавь the given значение to the hash.  The hash of the значение
 * will be given by хэшФункц(v).  If the значение already exists in the hash,
 * this should call обновлФункц(v) and should not increment счёт.
 *
 * позиция начало -> must be a позиция that points to the very первый valid
 * элемент in the hash, or конец if no elements exist.
 *
 * позиция конец -> must be a позиция that points to just past the very последн
 * valid элемент.
 *
 * позиция найди(V v) -> returns a позиция that points to the элемент that
 * содержит v, or конец if the элемент doesn't exist.
 *
 * позиция удали(позиция p) -> removes the given элемент from the hash,
 * returns the следщ valid элемент or конец if p was последн in the hash.
 *
 * проц очисти() -> removes all elements from the hash, sets счёт to 0.
 */
class ХэшНабор(V, alias ШаблРеализац=ХэшБезОбновлений, alias хэшФункц=ДефХэш) : Набор!(V)
{
    /**
     * an alias the the implementation template instantiation.
     */
    alias ШаблРеализац!(V, хэшФункц) Реализ;

    private Реализ _хэш;

    /**
     * A курсор for the hash установи.
     */
    struct курсор
    {
        private Реализ.позиция позиция;

        /**
         * дай the значение at this позиция
         */
        V значение()
        {
            return позиция.ptr.значение;
        }

        /**
         * increment this курсор, returns what the курсор was перед
         * incrementing.
         */
        курсор opPostInc()
        {
            курсор врм = *this;
            позиция = позиция.следщ;
            return врм;
        }

        /**
         * decrement this курсор, returns what the курсор was перед
         * decrementing.
         */
        курсор opPostDec()
        {
            курсор врм = *this;
            позиция = позиция.предш;
            return врм;
        }

        /**
         * increment the курсор by the given amount.
         *
         * This is an O(прир) operation!  You should only use this operator in
         * the form:
         *
         * ++i;
         */
        курсор opAddAssign(цел прир)
        {
            if(прир < 0)
                return opSubAssign(-прир);
            while(прир--)
                позиция = позиция.следщ;
            return *this;
        }

        /**
         * decrement the курсор by the given amount.
         *
         * This is an O(прир) operation!  You should only use this operator in
         * the form:
         *
         * --i;
         */
        курсор opSubAssign(цел прир)
        {
            if(прир < 0)
                return opAddAssign(-прир);
            while(прир--)
                позиция = позиция.предш;
            return *this;
        }

        /**
         * compare two cursors for equality
         */
        бул opEquals(курсор обх)
        {
            return обх.позиция == позиция;
        }
    }

    /**
     * Iterate over the elements in the установи, specifying which ones to удали.
     *
     * Use like this:
     *
     * ---------------
     * // удали all odd elements
     * foreach(ref чистить_ли, v; &hashSet.очистить)
     * {
     *   чистить_ли = ((v & 1) == 1);
     * }
     */
    final цел очистить(цел delegate(ref бул чистить_ли, ref V v) дг)
    {
        return _примени(дг);
    }

    private цел _примени(цел delegate(ref бул чистить_ли, ref V v) дг)
    {
        курсор обх = начало;
        бул чистить_ли;
        цел возврдг = 0;
        курсор _конец = конец; // cache конец so обх isn't always being generated
        while(!возврдг && обх != _конец)
        {
            //
            // don't allow user to change значение
            //
            V врмзначение = обх.значение;
            чистить_ли = false;
            if((возврдг = дг(чистить_ли, врмзначение)) != 0)
                break;
            if(чистить_ли)
                обх = удали(обх);
            else
                обх++;
        }
        return возврдг;
    }

    /**
     * iterate over the collection's values
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел _дг(ref бул чистить_ли, ref V v)
        {
            return дг(v);
        }
        return _примени(&_дг);
    }

    /**
     * Instantiate the hash установи using the implementation parameters given.
     */
    this()
    {
        _хэш.установка();
    }

    //
    // private constructor for dup
    //
    private this(ref Реализ дубИз)
    {
        дубИз.копируйВ(_хэш);
    }

    /**
     * Clear the collection of all elements
     */
    ХэшНабор очисти()
    {
        _хэш.очисти();
        return this;
    }

    /**
     * returns number of elements in the collection
     */
    бцел длина()
    {
        return _хэш.счёт;
    }
	alias длина length;

    /**
     * returns a курсор to the первый элемент in the collection.
     */
    курсор начало()
    {
        курсор обх;
        обх.позиция = _хэш.начало();
        return обх;
    }

    /**
     * returns a курсор that points just past the последн элемент in the
     * collection.
     */
    курсор конец()
    {
        курсор обх;
        обх.позиция = _хэш.конец();
        return обх;
    }

    /**
     * удали the элемент pointed at by the given курсор, returning an
     * курсор that points to the следщ элемент in the collection.
     *
     * Runs on average in O(1) time.
     */
    курсор удали(курсор обх)
    {
        обх.позиция = _хэш.удали(обх.позиция);
        return обх;
    }

    /**
     * найди the instance of a значение in the collection.  Returns конец if the
     * значение is not present.
     *
     * Runs in average O(1) time.
     */
    курсор найди(V v)
    {
        курсор обх;
        обх.позиция = _хэш.найди(v);
        return обх;
    }

    /**
     * Returns true if the given значение exists in the collection.
     *
     * Runs in average O(1) time.
     */
    бул содержит(V v)
    {
        return найди(v) != конец;
    }

    /**
     * Removes the первый элемент that has the значение v.  Returns true if the
     * значение was present and was removed.
     *
     * Runs in O(n) time.
     */
    ХэшНабор удали(V v)
    {
        курсор обх = найди(v);
        if(обх != конец)
            удали(обх);
        return this;
    }

    /**
     * Removes the первый элемент that has the значение v.  Returns true if the
     * значение was present and was removed.
     *
     * Runs in O(n) time.
     */
    ХэшНабор удали(V v, ref бул был_Удалён)
    {
        курсор обх = найди(v);
        if(обх == конец)
        {
            был_Удалён = false;
        }
        else
        {
            был_Удалён = true;
            удали(обх);
        }
        return this;
    }

    ХэшНабор удали(Обходчик!(V) обх)
    {
        foreach(v; обх)
            удали(v);
        return this;
    }

    /**
     * Remove all the elements that appear in the iterator.  Sets чло_Удалённых
     * to the number of elements removed.
     *
     * Returns this.
     */
    ХэшНабор удали(Обходчик!(V) обх, ref бцел чло_Удалённых)
    {
        бцел исхдлина = длина;
        удали(обх);
        чло_Удалённых = исхдлина - длина;
        return this;
    }

    /**
     * Adds an элемент to the установи.  Returns true if the элемент was not
     * already present.
     *
     * Runs on average in O(1) time.
     */
    ХэшНабор добавь(V v)
    {
        _хэш.добавь(v);
        return this;
    }

    /**
     * Adds an элемент to the установи.  Returns true if the элемент was not
     * already present.
     *
     * Runs on average in O(1) time.
     */
    ХэшНабор добавь(V v, ref бул был_добавлен)
    {
        был_добавлен = _хэш.добавь(v);
        return this;
    }

    /**
     * Adds all the elements from the iterator to the установи.  Returns the number
     * of elements добавленный.
     *
     * Runs on average in O(1) + O(m) time, where m is the number of elements
     * in the iterator.
     */
    ХэшНабор добавь(Обходчик!(V) обх)
    {
        foreach(v; обх)
            _хэш.добавь(v);
        return this;
    }

    /**
     * Adds all the elements from the iterator to the установи.  Returns the number
     * of elements добавленный.
     *
     * Runs on average in O(1) + O(m) time, where m is the number of elements
     * in the iterator.
     */
    ХэшНабор добавь(Обходчик!(V) обх, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        добавь(обх);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Adds all the elements from the массив to the установи.  Returns the number of
     * elements добавленный.
     *
     * Runs on average in O(1) + O(m) time, where m is the массив длина.
     */
    ХэшНабор добавь(V[] массив)
    {
        foreach(v; массив)
            _хэш.добавь(v);
        return this;
    }

    /**
     * Adds all the elements from the массив to the установи.  Returns the number of
     * elements добавленный.
     *
     * Runs on average in O(1) + O(m) time, where m is the массив длина.
     */
    ХэшНабор добавь(V[] массив, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        добавь(массив);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Remove all the values from the установи that are not in the given поднабор
     *
     * returns this.
     */
    ХэшНабор накладка(Обходчик!(V) поднабор)
    {
        //
        // intersection is more difficult than removal, because we do not have
        // insight into the implementation details.  Therefore, make the
        // implementation do обх.
        //
        _хэш.накладка(поднабор);
        return this;
    }

    /**
     * Remove all the values from the установи that are not in the given поднабор.
     * Sets чло_Удалённых to the number of elements removed.
     *
     * returns this.
     */
    ХэшНабор накладка(Обходчик!(V) поднабор, ref бцел чло_Удалённых)
    {
        //
        // intersection is more difficult than removal, because we do not have
        // insight into the implementation details.  Therefore, make the
        // implementation do обх.
        //
        чло_Удалённых = _хэш.накладка(поднабор);
        return this;
    }

    /**
     * duplicate this hash установи
     */
    ХэшНабор dup()
    {
        return new ХэшНабор(_хэш);
    }

    цел opEquals(Объект o)
    {
        if(o !is null)
        {
            auto s = cast(Набор!(V))o;
            if(s !is null && s.length == длина)
            {
                foreach(элт; s)
                {
                    if(!содержит(элт))
                        return 0;
                }

                //
                // equal
                //
                return 1;
            }
        }
        //
        // no comparison possible.
        //
        return 0;
    }

    /**
     * дай the most convenient элемент in the установи.  This is the элемент that
     * would be iterated первый.  Therefore, calling удали(дай()) is
     * guaranteed to be less than an O(n) operation.
     */
    V дай()
    {
        return начало.значение;
    }

    /**
     * Remove the most convenient элемент from the установи, and return its значение.
     * This is equivalent to удали(дай()), except that only one lookup is
     * performed.
     */
    V изыми()
    {
        auto c = начало;
        auto возврзнач = c.значение;
        удали(c);
        return возврзнач;
    }
}

version(UnitTest)
{
    unittest
    {
        auto hs = new ХэшНабор!(бцел);
        Набор!(бцел) s = hs;
        s.добавь([0U, 1, 2, 3, 4, 5, 5]);
        assert(s.length == 6);
        foreach(ref чистить_ли, i; &s.очистить)
            чистить_ли = (i % 2 == 1);
        assert(s.length == 3);
        assert(s.содержит(4));
    }
}
