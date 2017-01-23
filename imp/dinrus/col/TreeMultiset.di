/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.TreeMultiset;

public import col.model.Multiset;
public import col.Functions;

private import col.RBTree;

/+ ИНТЕРФЕЙС:

class ДеревоМультинабор(З, alias ШаблРеализац = КЧДеревоДуб, alias функцСравнения=ДефСравнить) : Мультинабор!(З)
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
    ДеревоМультинабор очисти();
    бцел длина();
	alias длина length;

    курсор начало();
    курсор конец();
    курсор удали(курсор обх);
    курсор найди(З з);
    бул содержит(З з);
    ДеревоМультинабор удали(З з);
    ДеревоМультинабор удали(З з, ref бул был_Удалён);
    ДеревоМультинабор добавь(З з);
    ДеревоМультинабор добавь(З з, ref бул был_добавлен);
    ДеревоМультинабор добавь(Обходчик!(З) обх);
    ДеревоМультинабор добавь(Обходчик!(З) обх, ref бцел чло_добавленных);
    ДеревоМультинабор добавь(З[] массив);
    ДеревоМультинабор добавь(З[] массив, ref бцел чло_добавленных);
    бцел счёт(З з);
    ДеревоМультинабор удалиВсе(З з);
    ДеревоМультинабор удалиВсе(З з, ref бцел чло_Удалённых);
    ДеревоМультинабор dup();
    З дай();
    З изыми();
}

+/

/**
 * Implementation of the Мультинабор interface using Красный-Чёрный trees.  this
 * allows for O(lg(n)) insertion, removal, and lookup times.  It also creates
 * a sorted установи of elements.  З must be comparable.
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
 * tree, the function should добавь обх after all equivalent elements.
 *
 * Узел начало -> must be a Узел that points to the very первый valid
 * элемент in the tree, or конец if no elements exist.
 *
 * Узел конец -> must be a Узел that points to just past the very последн
 * valid элемент.
 *
 * Узел найди(З з) -> returns a Узел that points to the первый элемент in the
 * tree that содержит з, or конец if the элемент doesn'т exist.
 *
 * Узел удали(Узел p) -> removes the given элемент from the tree,
 * returns the следщ valid элемент or конец if p was последн in the tree.
 *
 * проц очисти() -> removes all elements from the tree, sets счёт to 0.
 *
 * бцел считайВсе(З з) -> returns the number of elements with the given значение.
 *
 * Узел удалиВсе(З з) -> removes all the given values from the tree.
 */
class ДеревоМультинабор(З, alias ШаблРеализац = КЧДеревоДуб, alias функцСравнения=ДефСравнить) : Мультинабор!(З)
{
    /**
     * convenience alias
     */
    alias ШаблРеализац!(З, функцСравнения) Реализ;

    private Реализ _дерево;

    /**
     * курсор for the tree multiset
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
     * Iterate through the elements of the collection, specifying which ones
     * should be removed.
     *
     * Use like this:
     * -------------
     * // удали all odd elements
     * foreach(ref чистить_ли, з; &treeMultiset.очистить)
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
     * Instantiate the tree multiset
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
    ДеревоМультинабор очисти()
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
     * найди the первый instance of a given значение in the collection.  Returns
     * конец if the значение is not present.
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
     * Removes the первый элемент that has the значение з.  Returns true if the
     * значение was present and was removed.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоМультинабор удали(З з)
    {
        курсор обх = найди(з);
        if(обх != конец)
            удали(обх);
        return this;
    }

    /**
     * Removes the первый элемент that has the значение з.  Returns true if the
     * значение was present and was removed.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоМультинабор удали(З з, ref бул был_Удалён)
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
     * Returns this.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоМультинабор добавь(З з)
    {
        _дерево.добавь(з);
        return this;
    }

    /**
     * Adds a значение to the collection. Sets был_добавлен to true if the значение was
     * добавленный.
     *
     * Returns this.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоМультинабор добавь(З з, ref бул был_добавлен)
    {
        был_добавлен = _дерево.добавь(з);
        return this;
    }

    /**
     * Adds all the values from the iterator to the collection.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements in
     * the iterator.
     */
    ДеревоМультинабор добавь(Обходчик!(З) обх)
    {
        foreach(з; обх)
            _дерево.добавь(з);
        return this;
    }

    /**
     * Adds all the values from the iterator to the collection. Sets чло_добавленных
     * to the number of values добавленный from the iterator.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements in
     * the iterator.
     */
    ДеревоМультинабор добавь(Обходчик!(З) обх, ref бцел чло_добавленных)
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
    ДеревоМультинабор добавь(З[] массив)
    {
        foreach(з; массив)
            _дерево.добавь(з);
        return this;
    }

    /**
     * Adds all the values from массив to the collection.  Sets чло_добавленных to the
     * number of elements добавленный from the массив.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements in
     * массив.
     */
    ДеревоМультинабор добавь(З[] массив, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        добавь(массив);
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Returns the number of elements in the collection that are equal to з.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements that are з.
     */
    бцел счёт(З з)
    {
        return _дерево.считайВсе(з);
    }

    /**
     * Removes all the elements that are equal to з.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements that are з.
     */
    ДеревоМультинабор удалиВсе(З з)
    {
        _дерево.удалиВсе(з);
        return this;
    }
    
    /**
     * Removes all the elements that are equal to з.  Sets чло_Удалённых to the
     * number of elements removed from the multiset.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements that are з.
     */
    ДеревоМультинабор удалиВсе(З з, ref бцел чло_Удалённых)
    {
        чло_Удалённых = _дерево.удалиВсе(з);
        return this;
    }

    /**
     * duplicate this tree multiset
     */
    ДеревоМультинабор dup()
    {
        return new ДеревоМультинабор(_дерево);
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
        auto tms = new ДеревоМультинабор!(бцел);
        Мультинабор!(бцел) ms = tms;
        ms.добавь([0U, 1, 2, 3, 4, 5, 5]);
        assert(ms.length == 7);
        assert(ms.счёт(5U) == 2);
        foreach(ref чистить_ли, i; &ms.очистить)
            чистить_ли = (i % 2 == 1);
        assert(ms.счёт(5U) == 0);
        assert(ms.length == 3);
    }
}
