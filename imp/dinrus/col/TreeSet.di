/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.TreeSet;

public import col.model.Set;
public import col.Functions;

private import col.RBTree;

/+ ИНТЕРФЕЙС:
class ДеревоНабор(З, alias ШаблРеализац = КЧДеревоБезОбнова, alias функцСравнения = ДефСравнить) : Набор!(З)
{

    alias ШаблРеализац!(З, функцСравнения) Реализ;

    struct курсор
    {
        З значение();
        курсор opPostInc();
        курсор opPostDec();
        курсор opAddAssign(цел прир);
        курсор opSubAssign(цел прир);
        бул opEquals(курсор обх);
    }

    final цел очистить(цел delegate(ref бул чистить_ли, ref З з) дг);
    цел opApply(цел delegate(ref З з) дг);
    this();
    private this(ref Реализ дубИз);
    ДеревоНабор очисти();
    бцел длина();
	alias длина length;
    курсор начало();
    курсор конец();
    курсор удали(курсор обх);
    курсор найди(З з);
    бул содержит(З з);
    ДеревоНабор удали(З з);
    ДеревоНабор удали(З з, ref бул был_Удалён);
    ДеревоНабор добавь(З з);
    ДеревоНабор добавь(З з, ref бул был_добавлен);
    ДеревоНабор добавь(Обходчик!(З) обх);
    ДеревоНабор добавь(Обходчик!(З) обх, ref бцел чло_добавленных);
    ДеревоНабор добавь(З[] массив);
    ДеревоНабор добавь(З[] массив, ref бцел чло_добавленных);
    ДеревоНабор dup();
    ДеревоНабор удали(Обходчик!(З) поднабор);
    ДеревоНабор удали(Обходчик!(З) поднабор, ref бцел чло_Удалённых);
    ДеревоНабор накладка(Обходчик!(З) поднабор);
    ДеревоНабор накладка(Обходчик!(З) поднабор, ref бцел чло_Удалённых);
    цел opEquals(Объект o);
    З дай();
    З изыми();
}


+/

/**
 * Implementation of the Набор interface using Красный-Чёрный trees.  this allows for
 * O(lg(n)) insertion, removal, and lookup times.  It also creates a sorted
 * установи.  З must be comparable.
 *
 * Adding an элемент does not invalidate any cursors.
 *
 * Removing an элемент only invalidates the cursors that were pointing at
 * that элемент.
 *
 * You can replace the Tree implementation with a custom implementation, the
 * implementation must be a struct template which can be instantiated with a
 * single template argument З, and must implement the following members
 * (non-function members can be properties unless otherwise specified):
 *
 * parameters -> must be a struct with at least the following members:
 *   функцСравнения -> the compare function to use (should be a
 *                      ФункцСравнения!(З))
 *   обновлФункц -> the update function to use (should be an
 *                     ФункцОбновления!(З))
 * 
 * проц установка(parameters p) -> initializes the tree with the given parameters.
 *
 * бцел счёт -> счёт of the elements in the tree
 *
 * Узел -> must be a struct/class with the following members:
 *   З значение -> the значение which is pointed to by this позиция (cannot be a
 *                property)
 *   Узел следщ -> the следщ Узел in the tree as defined by the compare
 *                function, or конец if no other nodes exist.
 *   Узел предш -> the previous Узел in the tree as defined by the compare
 *                function.
 *
 * бул добавь(З з) -> добавь the given значение to the tree according to the order
 * defined by the compare function.  If the элемент already exists in the
 * tree, the 
 *
 * Узел начало -> must be a Узел that points to the very первый valid
 * элемент in the tree, or конец if no elements exist.
 *
 * Узел конец -> must be a Узел that points to just past the very последн
 * valid элемент.
 *
 * Узел найди(З з) -> returns a Узел that points to the элемент that
 * содержит з, or конец if the элемент doesn'т exist.
 *
 * Узел удали(Узел p) -> removes the given элемент from the tree,
 * returns the следщ valid элемент or конец if p was последн in the tree.
 *
 * проц очисти() -> removes all elements from the tree, sets счёт to 0.
 */
class ДеревоНабор(З, alias ШаблРеализац = КЧДеревоБезОбнова, alias функцСравнения = ДефСравнить) : Набор!(З)
{
    /**
     * convenience alias.
     */
    alias ШаблРеализац!(З, функцСравнения) Реализ;

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
        З значение()
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
     * foreach(ref чистить_ли, з; &treeSet.очистить)
     * {
     *   чистить_ли = ((з % 1) == 1);
     * }
     * -------------
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
            //
            // don'т allow user to change значение
            //
            З врмзначение = обх.значение;
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
    цел opApply(цел delegate(ref З з) дг)
    {
        цел _дг(ref бул чистить_ли, ref З з)
        {
            return дг(з);
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
    курсор найди(З з)
    {
        курсор обх;
        обх.ptr = _дерево.найди(з);
        return обх;
    }

    /**
     * Returns true if the given значение exists in the collection.
     *
     * Runs in O(lg(n)) time.
     */
    бул содержит(З з)
    {
        return найди(з) != конец;
    }

    /**
     * Removes the элемент that has the значение з.  Returns true if the значение
     * was present and was removed.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоНабор удали(З з)
    {
        курсор обх = найди(з);
        if(обх !is конец)
            удали(обх);
        return this;
    }

    /**
     * Removes the элемент that has the значение з.  Returns true if the значение
     * was present and was removed.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоНабор удали(З з, ref бул был_Удалён)
    {
        курсор обх = найди(з);
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
    ДеревоНабор добавь(З з)
    {
        _дерево.добавь(з);
        return this;
    }

    /**
     * Adds a значение to the collection.
     * Returns true.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоНабор добавь(З з, ref бул был_добавлен)
    {
        был_добавлен = _дерево.добавь(з);
        return this;
    }

    /**
     * Adds all the values from enumerator to the collection.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements in
     * enumerator.
     */
    ДеревоНабор добавь(Обходчик!(З) обх)
    {
        foreach(з; обх)
            _дерево.добавь(з);
        return this;
    }

    /**
     * Adds all the values from enumerator to the collection.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements in
     * enumerator.
     */
    ДеревоНабор добавь(Обходчик!(З) обх, ref бцел чло_добавленных)
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
    ДеревоНабор добавь(З[] массив)
    {
        foreach(з; массив)
            _дерево.добавь(з);
        return this;
    }

    /**
     * Adds all the values from массив to the collection.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements in
     * массив.
     */
    ДеревоНабор добавь(З[] массив, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        foreach(з; массив)
            _дерево.добавь(з);
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
    ДеревоНабор удали(Обходчик!(З) поднабор)
    {
        foreach(з; поднабор)
            удали(з);
        return this;
    }

    /**
     * Remove all the elements that match in the поднабор.  Sets чло_Удалённых to
     * number of elements removed.
     *
     * returns this.
     */
    ДеревоНабор удали(Обходчик!(З) поднабор, ref бцел чло_Удалённых)
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
    ДеревоНабор накладка(Обходчик!(З) поднабор)
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
    ДеревоНабор накладка(Обходчик!(З) поднабор, ref бцел чло_Удалённых)
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
            auto s = cast(Набор!(З))o;
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
