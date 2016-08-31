﻿/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.TreeSet;

public import col.model.Set;
public import col.Functions;

private import col.RBTree;

/**
 * Implementation of the Набор interface using Красный-Чёрный trees.  this allows for
 * O(lg(n)) insertion, removal, and lookup times.  It also creates a sorted
 * установи.  V must be comparable.
 *
 * Adding an элемент does not invalidate any cursors.
 *
 * Removing an элемент only invalidates the cursors that were pointing at
 * that элемент.
 *
 * You can replace the Tree implementation with a custom implementation, the
 * implementation must be a struct template which can be instantiated with a
 * single template argument V, and must implement the following members
 * (non-function members can be properties unless otherwise specified):
 *
 * parameters -> must be a struct with at least the following members:
 *   функцСравнения -> the compare function to use (should be a
 *                      ФункцСравнения!(V))
 *   обновлФункц -> the update function to use (should be an
 *                     ФункцОбновления!(V))
 * 
 * проц установка(parameters p) -> initializes the tree with the given parameters.
 *
 * бцел счёт -> счёт of the elements in the tree
 *
 * Узел -> must be a struct/class with the following members:
 *   V значение -> the значение which is pointed to by this позиция (cannot be a
 *                property)
 *   Узел следщ -> the следщ Узел in the tree as defined by the compare
 *                function, or конец if no other nodes exist.
 *   Узел предш -> the previous Узел in the tree as defined by the compare
 *                function.
 *
 * бул добавь(V v) -> добавь the given значение to the tree according to the order
 * defined by the compare function.  If the элемент already exists in the
 * tree, the 
 *
 * Узел начало -> must be a Узел that points to the very первый valid
 * элемент in the tree, or конец if no elements exist.
 *
 * Узел конец -> must be a Узел that points to just past the very последн
 * valid элемент.
 *
 * Узел найди(V v) -> returns a Узел that points to the элемент that
 * содержит v, or конец if the элемент doesn't exist.
 *
 * Узел удали(Узел p) -> removes the given элемент from the tree,
 * returns the следщ valid элемент or конец if p was последн in the tree.
 *
 * проц очисти() -> removes all elements from the tree, sets счёт to 0.
 */
class ДеревоНабор(V, alias ШаблРеализац = КЧДеревоБезОбнова, alias функцСравнения = ДефСравнить) : Набор!(V)
{
    /**
     * convenience alias.
     */
    alias ШаблРеализац!(V, функцСравнения) Реализ;

    private Реализ _дерево;

    /**
     * Обходчик for the tree установи.
     */
    struct курсор
    {
        private Реализ.Узел укз; alias укз ptr;

        /**
         * дай the значение in this элемент
         */
        V значение()
        {
            return укз.значение;
        }

        /**
         * increment this курсор, returns what the курсор was перед
         * incrementing.
         */
        курсор opPostInc()
        {
            курсор врм = *this;
            укз = укз.следщ;
            return врм;
        }

        /**
         * decrement this курсор, returns what the курсор was перед
         * decrementing.
         */
        курсор opPostDec()
        {
            курсор врм = *this;
            укз = укз.предш;
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
                укз = укз.следщ;
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
                укз = укз.предш;
            return *this;
        }

        /**
         * compare two cursors for equality
         */
        бул opEquals(курсор обх)
        {
            return обх.ptr is укз;
        }
    }

    /**
     * Iterate through elements of the ДеревоНабор, specifying which ones to
     * удали.
     *
     * Use like this:
     * -------------
     * // удали all odd elements
     * foreach(ref чистить_ли, v; &treeSet.очистить)
     * {
     *   чистить_ли = ((v % 1) == 1);
     * }
     * -------------
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
     * Instantiate the tree установи
     */
    this()
    {
        _дерево.установка();
    }

    //
    // for dup
    //
    private this(ref Реализ дубИз)
    {
        дубИз.копируйВ(_дерево);
    }

    /**
     * Clear the collection of all elements
     */
    ДеревоНабор очисти()
    {
        _дерево.очисти();
        return this;
    }

    /**
     * returns number of elements in the collection
     */
    бцел длина()
    {
        return _дерево.счёт;
    }
	alias длина length;

    /**
     * returns a курсор to the первый элемент in the collection.
     */
    курсор начало()
    {
        курсор обх;
        обх.ptr = _дерево.начало;
        return обх;
    }

    /**
     * returns a курсор that points just past the последн элемент in the
     * collection.
     */
    курсор конец()
    {
        курсор обх;
        обх.ptr = _дерево.конец;
        return обх;
    }

    /**
     * удали the элемент pointed at by the given курсор, returning an
     * курсор that points to the следщ элемент in the collection.
     *
     * Runs in O(lg(n)) time.
     */
    курсор удали(курсор обх)
    {
        обх.ptr = _дерево.удали(обх.ptr);
        return обх;
    }

    /**
     * найди the instance of a значение in the collection.  Returns конец if the
     * значение is not present.
     *
     * Runs in O(lg(n)) time.
     */
    курсор найди(V v)
    {
        курсор обх;
        обх.ptr = _дерево.найди(v);
        return обх;
    }

    /**
     * Returns true if the given значение exists in the collection.
     *
     * Runs in O(lg(n)) time.
     */
    бул содержит(V v)
    {
        return найди(v) != конец;
    }

    /**
     * Removes the элемент that has the значение v.  Returns true if the значение
     * was present and was removed.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоНабор удали(V v)
    {
        курсор обх = найди(v);
        if(обх !is конец)
            удали(обх);
        return this;
    }

    /**
     * Removes the элемент that has the значение v.  Returns true if the значение
     * was present and was removed.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоНабор удали(V v, ref бул был_Удалён)
    {
        курсор обх = найди(v);
        if(обх == конец)
        {
            был_Удалён = false;
        }
        else
        {
            удали(обх);
            был_Удалён = true;
        }
        return this;
    }

    /**
     * Adds a значение to the collection.
     * Returns true.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоНабор добавь(V v)
    {
        _дерево.добавь(v);
        return this;
    }

    /**
     * Adds a значение to the collection.
     * Returns true.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоНабор добавь(V v, ref бул был_добавлен)
    {
        был_добавлен = _дерево.добавь(v);
        return this;
    }

    /**
     * Adds all the values from enumerator to the collection.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements in
     * enumerator.
     */
    ДеревоНабор добавь(Обходчик!(V) обх)
    {
        foreach(v; обх)
            _дерево.добавь(v);
        return this;
    }

    /**
     * Adds all the values from enumerator to the collection.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements in
     * enumerator.
     */
    ДеревоНабор добавь(Обходчик!(V) обх, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        добавь(обх);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Adds all the values from массив to the collection.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements in
     * массив.
     */
    ДеревоНабор добавь(V[] массив)
    {
        foreach(v; массив)
            _дерево.добавь(v);
        return this;
    }

    /**
     * Adds all the values from массив to the collection.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements in
     * массив.
     */
    ДеревоНабор добавь(V[] массив, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        foreach(v; массив)
            _дерево.добавь(v);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Return a duplicate treeset containing all the elements in this tree
     * установи.
     */
    ДеревоНабор dup()
    {
        return new ДеревоНабор(_дерево);
    }

    /**
     * Remove all the elements that match in the поднабор
     */
    ДеревоНабор удали(Обходчик!(V) поднабор)
    {
        foreach(v; поднабор)
            удали(v);
        return this;
    }

    /**
     * Remove all the elements that match in the поднабор.  Sets чло_Удалённых to
     * number of elements removed.
     *
     * returns this.
     */
    ДеревоНабор удали(Обходчик!(V) поднабор, ref бцел чло_Удалённых)
    {
        бцел оригДлина = длина;
        удали(поднабор);
        чло_Удалённых = оригДлина - длина;
        return this;
    }

    /**
     * Remove all the elements that do NOT match in the поднабор.
     *
     * returns this.
     */
    ДеревоНабор накладка(Обходчик!(V) поднабор)
    {
        _дерево.накладка(поднабор);
        return this;
    }

    /**
     * Remove all the elements that do NOT match in the поднабор.  Sets
     * чло_Удалённых to number of elements removed.
     *
     * returns this.
     */
    ДеревоНабор накладка(Обходчик!(V) поднабор, ref бцел чло_Удалённых)
    {
        чло_Удалённых = _дерево.накладка(поднабор);
        return this;
    }

    /**
     * Compare this установи with another установи.  Returns true if both sets have the
     * same длина and every элемент in one установи exists in the other установи.
     *
     * If o is null or not a Набор, return 0.
     */
    цел opEquals(Объект o)
    {
        if(o !is null)
        {
            auto s = cast(Набор!(V))o;
            if(s !is null && s.length == длина)
            {
                auto ts = cast(ДеревоНабор)o;
                auto _конец = конец;
                if(ts !is null)
                {
                    if(длина != ts.length)
                        return 0;

                    //
                    // since we know treesets are sorted, compare elements
                    // using cursors.  This makes opEquals O(n) operation,
                    // versus O(n lg(n)) for other установи types.
                    //
                    auto c1 = начало;
                    auto c2 = ts.начало;
                    while(c1 != _конец)
                    {
                        if(c1++.значение != c2++.значение)
                            return 0;
                    }
                    return 1;
                }
                else
                {
                    foreach(элт; s)
                    {
                        //
                        // less work then calling содержит(), which builds конец
                        // each time
                        //
                        if(найди(элт) == _конец)
                            return 0;
                    }

                    //
                    // equal
                    //
                    return 1;
                }
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
        auto ts = new ДеревоНабор!(бцел);
        Набор!(бцел) s = ts;
        s.добавь([0U, 1, 2, 3, 4, 5, 5]);
        assert(s.length == 6);
        foreach(ref чистить_ли, i; &s.очистить)
            чистить_ли = (i % 2 == 1);
        assert(s.length == 3);
        assert(s.содержит(4));
    }
}
