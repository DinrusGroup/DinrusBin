/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.LinkList;

public import col.model.List;
private import col.Link;
private import col.Functions;

/**
 * This class implements the list interface by using Связка nodes.  This gives
 * the advantage of O(1) добавь and removal, but no random access.
 *
 * Adding elements does not affect any курсор.
 *
 * Removing elements does not affect any курсор unless the курсор points
 * to a removed элемент, in which case обх is invalidated.
 *
 * The implementation can be swapped out for another implementation of
 * a doubly linked list.  The implementation must be a struct which uses one
 * template argument V with the following members (unless specified, members
 * can be implemented as properties):
 *
 * parameters -> data type that is passed to установка to help установи up the Узел.
 * There are no specific requirements for this type.
 *
 * Узел -> data type that represents a Узел in the list.  This should be a
 * ссылка type.  Each Узел must define the following members:
 *   V значение -> the значение held at this Узел.  Cannot be a property.
 *   Узел предш -> (дай only) the previous Узел in the list
 *   Узел следщ -> (дай only) the следщ Узел in the list
 *
 * Узел конец -> (дай only) An invalid Узел that points just past the последн valid
 * Узел.  конец.предш should be the последн valid Узел.  конец.следщ is undefined.
 *
 * Узел начало -> (дай only) The первый valid Узел.  начало.предш is undefined.
 *
 * бцел счёт -> (дай only)  The number of nodes in the list.  This can be
 * calculated in O(n) time to allow for more efficient removal of multiple
 * nodes.
 *
 * проц установка(parameters p) -> установи up the list.  This is like a constructor.
 *
 * Узел удали(Узел n) -> removes the given Узел from the list.  Returns the
 * следщ Узел in the list.
 *
 * Узел удали(Узел первый, Узел последн) -> removes the nodes from первый to последн,
 * not including последн.  Returns последн.  This can run in O(n) time if счёт is
 * O(1), or O(1) time if счёт is O(n).
 *
 * Узел вставь(Узел перед, V v) -> добавь a new Узел перед the Узел 'перед',
 * return a pointer to the new Узел.
 *
 * проц очисти() -> удали all nodes from the list.
 * 
 * проц сортируй(ФункцСравнения!(V) comp) -> сортируй the list according to the
 * compare function
 *
 */
class СвязкаСписок(V, alias ШаблРеализац = ГоловаСвязки) : Список!(V)
{
    /**
     * convenience alias
     */
    alias ГоловаСвязки!(V) Реализ;

    /**
     * convenience alias
     */
    alias СвязкаСписок!(V, ШаблРеализац) ТипСвязкаСписок;

    private Реализ _связка;

    /**
     * A курсор for link list
     */
    struct курсор
    {
        private Реализ.Узел укз; alias укз ptr;

        /**
         * дай the значение pointed to by this курсор
         */
        V значение()
        {
            return укз.значение;
        }

        /**
         * установи the значение pointed to by this курсор
         */
        V значение(V v)
        {
            return (укз.значение = v);
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
            return укз is обх.ptr;
        }
    }

    /**
     * Constructor
     */
    this()
    {
        _связка.установка();
    }

    //
    // private constructor for dup
    //
    private this(ref Реализ дубИз, бул копироватьУзлы)
    {
      дубИз.копируйВ(_связка, копироватьУзлы);
    }

    /**
     * Clear the collection of all elements
     */
    ТипСвязкаСписок очисти()
    {
        _связка.очисти();
        return this;
    }

    /**
     * returns number of elements in the collection
     */
    бцел длина()
    {
        return _связка.счёт;
    }
	alias длина length;

    /**
     * returns a курсор to the первый элемент in the collection.
     */
    курсор начало()
    {
        курсор обх;
        обх.ptr = _связка.начало;
        return обх;
    }

    /**
     * returns a курсор that points just past the последн элемент in the
     * collection.
     */
    курсор конец()
    {
        курсор обх;
        обх.ptr = _связка.конец;
        return обх;
    }

    /**
     * удали the элемент pointed at by the given курсор, returning an
     * курсор that points to the следщ элемент in the collection.
     *
     * Runs in O(1) time.
     */
    курсор удали(курсор обх)
    {
        обх.ptr = _связка.удали(обх.ptr);
        return обх;
    }

    /**
     * удали the elements pointed at by the given курсор range, returning
     * a курсор that points to the элемент that последн pointed to.
     *
     * Runs in O(последн-первый) time.
     */
    курсор удали(курсор первый, курсор последн)
    {
        последн.ptr = _связка.удали(первый.ptr, последн.ptr);
        return последн;
    }

    /**
     * Removes the первый элемент that has the значение v.  Returns true if the
     * значение was present and was removed.
     *
     * Runs in O(n) time.
     */
    ТипСвязкаСписок удали(V v)
    {
        бул пропущен;
        return удали(v, пропущен);
    }

    /**
     * Removes the первый элемент that has the значение v.  Returns true if the
     * значение was present and was removed.
     *
     * Runs in O(n) time.
     */
    ТипСвязкаСписок удали(V v, ref бул был_Удалён)
    {
        auto обх = найди(v);
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

    /**
     * найди a given значение in the collection starting at a given курсор.
     * This is useful to iterate over all elements that have the same значение.
     *
     * Runs in O(n) time.
     */
    курсор найди(курсор обх, V v)
    {
        return _найди(обх, конец, v);
    }

    /**
     * найди an instance of a значение in the collection.  Equivalent to
     * найди(начало, v);
     *
     * Runs in O(n) time.
     */
    курсор найди(V v)
    {
        return _найди(начало, конец, v);
    }

    private курсор _найди(курсор обх, курсор последн, V v)
    {
        while(обх != последн && обх.значение != v)
            обх++;
        return обх;
    }

    /**
     * Returns true if the given значение exists in the collection.
     *
     * Runs in O(n) time.
     */
    бул содержит(V v)
    {
        return найди(v) != конец;
    }

    private цел _примени(цел delegate(ref бул, ref V) дг, курсор старт, курсор последн)
    {
        курсор i = старт;
        цел возврдг = 0;
        бул удалить_ли;

        while(i != последн && i.ptr !is _связка.конец)
        {
            удалить_ли = false;
            if((возврдг = дг(удалить_ли, i.ptr.значение)) != 0)
                break;
            if(удалить_ли)
                удали(i++);
            else
                i++;
        }
        return возврдг;
    }

    private цел _примени(цел delegate(ref V значение) дг, курсор первый, курсор последн)
    {
        цел возврзнач = 0;
        for(курсор i = первый; i != последн; i++)
            if((возврзнач = дг(i.ptr.значение)) != 0)
                break;
        return возврзнач;
    }

    /**
     * iterate over the collection's values
     */
    цел opApply(цел delegate(ref V значение) дг)
    {
        return _примени(дг, начало, конец);
    }

    /**
     * Iterate over the collections values, specifying which ones should be
     * removed
     *
     * Use like this:
     *
     * -----------
     * // удали all odd values
     * foreach(ref чистить_ли, v; &list.очистить)
     * {
     *   чистить_ли = ((v & 1) == 1);
     * }
     * -----------
     */
    final цел очистить(цел delegate(ref бул удалить_ли, ref V значение) дг)
    {
        return _примени(дг, начало, конец);
    }

    /**
     * Adds an элемент to the list.  Returns true if the элемент was not
     * already present.
     *
     * Runs in O(1) time.
     */
    ТипСвязкаСписок добавь(V v)
    {
        _связка.вставь(_связка.конец, v);
        return this;
    }

    /**
     * Adds an элемент to the list.  Returns true if the элемент was not
     * already present.
     *
     * Runs in O(1) time.
     */
    ТипСвязкаСписок добавь(V v, ref бул был_добавлен)
    {
        _связка.вставь(_связка.конец, v);
        был_добавлен = true;
        return this;
    }

    /**
     * Adds all the values from the given iterator into the list.
     *
     * Returns this.
     */
    ТипСвязкаСписок добавь(Обходчик!(V) колл)
    {
        foreach(v; колл)
            добавь(v);
        return this;
    }

    /**
     * Adds all the values from the given iterator into the list.
     *
     * Returns the number of elements добавленный.
     */
    ТипСвязкаСписок добавь(Обходчик!(V) колл, ref бцел чло_добавленных)
    {
        бцел оригДлина = длина;
        добавь(колл);
        чло_добавленных = длина - оригДлина;
        return this;
    }

    /**
     * Adds all the values from the given массив into the list.
     *
     * Returns the number of elements добавленный.
     */
    ТипСвязкаСписок добавь(V[] массив)
    {
        foreach(v; массив)
            добавь(v);
        return this;
    }

    /**
     * Adds all the values from the given массив into the list.
     *
     * Returns the number of elements добавленный.
     */
    ТипСвязкаСписок добавь(V[] массив, ref бцел чло_добавленных)
    {
        foreach(v; массив)
            добавь(v);
        чло_добавленных = массив.length;
        return this;
    }

    /**
     * Count the number of occurrences of v
     *
     * Runs in O(n) time.
     */
    бцел счёт(V v)
    {
        бцел экземпляры = 0;
        foreach(x; this)
            if(v == x)
                экземпляры++;
        return экземпляры;
    }

    /**
     * Remove all the occurrences of v.  Returns the number of экземпляры that
     * were removed.
     *
     * Runs in O(n) time.
     */
    ТипСвязкаСписок удалиВсе(V v)
    {
        foreach(ref dp, x; &очистить)
        {
            dp = cast(бул)(x == v);
        }
        return this;
    }

    /**
     * Remove all the occurrences of v.  Returns the number of экземпляры that
     * were removed.
     *
     * Runs in O(n) time.
     */
    ТипСвязкаСписок удалиВсе(V v, ref бцел чло_Удалённых)
    {
        бцел оригДлина;
        удалиВсе(v);
        чло_Удалённых = оригДлина - длина;
        return this;
    }

    //
    // handy link-list only functions
    //
    /**
     * вставь an элемент at the given позиция.  Returns a курсор to the
     * newly inserted элемент.
     */
    курсор вставь(курсор обх, V v)
    {
        обх.ptr = _связка.вставь(обх.ptr, v);
        return обх;
    }

    /**
     * приставь an элемент to the первый элемент in the list.  Returns an
     * курсор to the newly prepended элемент.
     */
    курсор приставь(V v)
    {
        return вставь(начало, v);
    }

    /**
     * поставь an элемент to the последн элемент in the list.  Returns a курсор
     * to the newly appended элемент.
     */
    курсор поставь(V v)
    {
        return вставь(конец, v);
    }

    /**
     * return the последн элемент in the list.  Undefined if the list is empty.
     */
    V тыл()
    {
        return _связка.конец.предш.значение;
    }
    
    /**
     * return the первый элемент in the list.  Undefined if the list is empty.
     */
    V фронт()
    {
        return _связка.начало.значение;
    }

    /**
     * удали the первый элемент in the list, and return its значение.
     *
     * Do not call this on an empty list.
     */
    V возьмиФронт()
    {
        auto возврзнач = фронт;
        _связка.удали(_связка.начало);
        return возврзнач;
    }

    /**
     * удали the последн элемент in the list, and return its значение
     * Do not call this on an empty list.
     */
    V возьмиТыл()
    {
        auto возврзнач = тыл;
        _связка.удали(_связка.конец.предш);
        return возврзнач;
    }

    /**
     * Create a new list with this and the rhs concatenated together
     */
    ТипСвязкаСписок opCat(Список!(V) rhs)
    {
        return dup.добавь(rhs);
    }

    /**
     * Create a new list with this and the массив concatenated together
     */
    ТипСвязкаСписок opCat(V[] массив)
    {
        return dup.добавь(массив);
    }

    /**
     * Create a new list with the массив and this list concatenated together.
     */
    ТипСвязкаСписок opCat_r(V[] массив)
    {
        auto рез = new ТипСвязкаСписок(_связка, false);
        return рез.добавь(массив).добавь(this);
    }

    /**
     * Append the given list to the конец of this list.
     */
    ТипСвязкаСписок opCatAssign(Список!(V) rhs)
    {
        return добавь(rhs);
    }

    /**
     * Append the given массив to the конец of this list.
     */
    ТипСвязкаСписок opCatAssign(V[] массив)
    {
        return добавь(массив);
    }

    /**
     * duplicate the list
     */
    ТипСвязкаСписок dup()
    {
        return new ТипСвязкаСписок(_связка, true);
    }

    /**
     * Compare this list with another list.  Returns true if both lists have
     * the same длина and all the elements are the same.
     *
     * If o is null or not a Список, return 0.
     */
    цел opEquals(Объект o)
    {
        if(o !is null)
        {
            auto li = cast(Список!(V))o;
            if(li !is null && li.length == длина)
            {
                auto c = начало;
                foreach(элт; li)
                {
                    if(элт != c++.значение)
                        return 0;
                }
                return 1;
            }
        }
        return 0;
    }

    /**
     * Sort the linked list according to the given compare function.
     *
     * Runs in O(n lg(n)) time
     *
     * Returns this after sorting
     */
    СвязкаСписок сортируй(цел delegate(ref V, ref V) comp)
    {
        _связка.сортируй(comp);
        return this;
    }

    /**
     * Sort the linked list according to the given compare function.
     *
     * Runs in O(n lg(n)) time
     *
     * Returns this after sorting
     */
    СвязкаСписок сортируй(цел function(ref V, ref V) comp)
    {
        _связка.сортируй(comp);
        return this;
    }

    /**
     * Sort the linked list according to the default compare function for V.
     *
     * Runs in O(n lg(n)) time
     *
     * Returns this
     */
    СвязкаСписок сортируй()
    {
        return сортируй(&ДефСравнить!(V));
    }

    /**
     * Sort the linked list according to the given compare functor.  This is
     * a templatized version, and so can be используется with functors, and might be
     * inlined.
     */
    СвязкаСписок сортируйИкс(Сравниватель)(Сравниватель comp)
    {
        _связка.сортируй(comp);
        return this;
    }
}

version(UnitTest)
{
    unittest
    {
        auto ll = new СвязкаСписок!(бцел);
        Список!(бцел) l = ll;
        l.добавь([0U, 1, 2, 3, 4, 5]);
        assert(l.length == 6);
        assert(l.содержит(5));
        foreach(ref чистить_ли, i; &l.очистить)
            чистить_ли = (i % 2 == 1);
        assert(l.length == 3);
        assert(!l.содержит(5));
    }
}
