/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.TreeMap;

public import col.model.Map;
public import col.Functions;

private import col.RBTree;
private import col.Iterators;

/**
 * Implementation of the Карта interface using Красный-Чёрный trees.  this allows for
 * O(lg(n)) insertion, removal, and lookup times.  It also creates a sorted
 * установи of ключи.  K must be comparable.
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
 * tree, the update function should be called, and the function should return
 * false.
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
class ДеревоКарта(K, V, alias ШаблРеализац=КЧДерево, alias функСравнить=ДефСравнить) : Карта!(K, V)
{
    /**
     * the elements that are passed to the tree.  Note that if you define a
     * custom update or compare function, обх should изыми элемент structs, not
     * K or V.
     */
    struct элемент
    {
        K ключ;
        V знач;
    }

    private КлючОбходчик _ключи;

    /**
     * Compare function используется internally to compare two ключи
     */
    static цел _функцияСравнения(ref элемент e, ref элемент e2)
    {
        return функСравнить(e.ключ, e2.ключ);
    }

    /**
     * Update function используется internally to update the значение of a Узел
     */
    static проц _функцияОбнова(ref элемент исх, ref элемент newv)
    {
        исх.знач = newv.знач;
    }

    /**
     * convenience alias to the implementation
     */
    alias ШаблРеализац!(элемент, _функцияСравнения, _функцияОбнова) Реализ;

    private Реализ _дерево;

    /**
     * A курсор for elements in the tree
     */
    struct курсор
    {
        private Реализ.Узел укз; alias укз ptr;

        /**
         * дай the значение in this элемент
         */
        V значение()
        {
            return укз.значение.знач;
        }

        /**
         * дай the ключ in this элемент
         */
        K ключ()
        {
            return укз.значение.ключ;
        }

        /**
         * установи the значение in this элемент
         */
        V значение(V v)
        {
            укз.значение.знач = v;
            return v;
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

    final цел очистить(цел delegate(ref бул чистить_ли, ref V v) дг)
    {
        цел _дг(ref бул чистить_ли, ref K k, ref V v)
        {
            return дг(чистить_ли, v);
        }
        return _примени(&_дг);
    }

    final цел чисть_ключ(цел delegate(ref бул чистить_ли, ref K k, ref V v) дг)
    {
        return _примени(дг);
    }

    private class КлючОбходчик : Обходчик!(K)
    {
        final бцел длина()
        {
            return this.outer.length;
        }
		alias длина length;

        final цел opApply(цел delegate(ref K) дг)
        {
            цел _дг(ref бул чистить_ли, ref K k, ref V v)
            {
                return дг(k);
            }
            return _примени(&_дг);
        }
    }


    private цел _примени(цел delegate(ref бул чистить_ли, ref K k, ref V v) дг)
    {
        курсор обх = начало;
        бул чистить_ли;
        цел возврдг = 0;
        курсор _конец = конец; // cache конец so обх isn't always being generated
        while(!возврдг && обх != _конец)
        {
            //
            // don't allow user to change ключ
            //
            K врмключ = обх.ключ;
            чистить_ли = false;
            if((возврдг = дг(чистить_ли, врмключ, обх.ptr.значение.знач)) != 0)
                break;
            if(чистить_ли)
                обх = удали(обх);
            else
                обх++;
        }
        return возврдг;
    }

    /**
     * iterate over the collection's ключ/значение pairs
     */
    цел opApply(цел delegate(ref K k, ref V v) дг)
    {
        цел _дг(ref бул чистить_ли, ref K k, ref V v)
        {
            return дг(k, v);
        }

        return _примени(&_дг);
    }

    /**
     * iterate over the collection's values
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел _дг(ref бул чистить_ли, ref K k, ref V v)
        {
            return дг(v);
        }
        return _примени(&_дг);
    }

    /**
     * Instantiate the tree map using the implementation parameters given.
     *
     * Набор members of p to their initializer values in order to use the
     * default values defined by ДеревоКарта.
     *
     * The default compare function performs K's compare.
     *
     * The default update function sets only the V part of the элемент, and
     * leaves the K part alone.
     */
    this()
    {
        _дерево.установка();
        _ключи = new КлючОбходчик;
    }

    //
    // private constructor for dup
    //
    private this(ref Реализ дубИз)
    {
        дубИз.копируйВ(_дерево);
        _ключи = new КлючОбходчик;
    }

    /**
     * Clear the collection of all elements
     */
    ДеревоКарта очисти()
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
     * найди a given значение in the collection starting at a given курсор.
     * This is useful to iterate over all elements that have the same значение.
     *
     * Runs in O(n) time.
     */
    курсор найдиЗначение(курсор обх, V v)
    {
        return _найдиЗначение(обх, конец, v);
    }

    /**
     * найди an instance of a значение in the collection.  Equivalent to
     * найдиЗначение(начало, v);
     *
     * Runs in O(n) time.
     */
    курсор найдиЗначение(V v)
    {
        return _найдиЗначение(начало, конец, v);
    }

    private курсор _найдиЗначение(курсор обх, курсор последн, V v)
    {
        while(обх != последн && обх.значение != v)
            обх++;
        return обх;
    }

    /**
     * найди the instance of a ключ in the collection.  Returns конец if the ключ
     * is not present.
     *
     * Runs in O(lg(n)) time.
     */
    курсор найди(K k)
    {
        курсор обх;
        элемент врм;
        врм.ключ = k;
        обх.ptr = _дерево.найди(врм);
        return обх;
    }

    /**
     * Returns true if the given значение exists in the collection.
     *
     * Runs in O(n) time.
     */
    бул содержит(V v)
    {
        return найдиЗначение(v) != конец;
    }

    /**
     * Removes the первый элемент that has the значение v.  Returns true if the
     * значение was present and was removed.
     *
     * Runs in O(n) time.
     */
    ДеревоКарта удали(V v)
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
    ДеревоКарта удали(V v, ref бул был_Удалён)
    {
        курсор обх = найдиЗначение(v);
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
     * Removes the элемент that has the given ключ.  Returns true if the
     * элемент was present and was removed.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоКарта удалиПо(K ключ)
    {
        курсор обх = найди(ключ);
        if(обх != конец)
            удали(обх);
        return this;
    }

    /**
     * Removes the элемент that has the given ключ.  Returns true if the
     * элемент was present and was removed.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоКарта удалиПо(K ключ, ref бул был_Удалён)
    {
        курсор обх = найди(ключ);
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
     * Removes all the elements whose ключи are in the поднабор.
     * 
     * returns this.
     */
    ДеревоКарта удали(Обходчик!(K) поднабор)
    {
        foreach(k; поднабор)
            удалиПо(k);
        return this;
    }

    /**
     * Removes all the elements whose ключи are in the поднабор.  Sets чло_Удалённых
     * to the number of ключ/значение pairs removed.
     * 
     * returns this.
     */
    ДеревоКарта удали(Обходчик!(K) поднабор, ref бцел чло_Удалённых)
    {
        бцел оригДлина = длина;
        удали(поднабор);
        чло_Удалённых = оригДлина - длина;
        return this;
    }

    /**
     * removes all elements in the map whose ключи are NOT in поднабор.
     *
     * returns this.
     */
    ДеревоКарта накладка(Обходчик!(K) поднабор, ref бцел чло_Удалённых)
    {
        //
        // create a wrapper iterator that generates elements from ключи.  Then
        // defer the intersection operation to the implementation.
        //
        // scope allocates on the stack.
        //
        scope w = new ТрансформОбходчик!(элемент, K)(поднабор, function проц(ref K k, ref элемент e) { e.ключ = k;});

        чло_Удалённых = _дерево.накладка(w);
        return this;
    }

    /**
     * removes all elements in the map whose ключи are NOT in поднабор.  Sets
     * чло_Удалённых to the number of elements removed.
     *
     * returns this.
     */
    ДеревоКарта накладка(Обходчик!(K) поднабор)
    {
        бцел пропущен;
        накладка(поднабор, пропущен);
        return this;
    }

    Обходчик!(K) ключи()
    {
        return _ключи;
    }

    /**
     * Returns the значение that is stored at the элемент which has the given
     * ключ.  Throws an exception if the ключ is not in the collection.
     *
     * Runs in O(lg(n)) time.
     */
    V opIndex(K ключ)
    {
        курсор обх = найди(ключ);
        if(обх == конец)
            throw new Искл("Index out of range");
        return обх.значение;
    }

    /**
     * assign the given значение to the элемент with the given ключ.  If the ключ
     * does not exist, adds the ключ and значение to the collection.
     *
     * Runs in O(lg(n)) time.
     */
    V opIndexAssign(V значение, K ключ)
    {
        установи(ключ, значение);
        return значение;
    }

    /**
     * установи a ключ and значение pair.  If the pair didn't already exist, добавь обх.
     *
     * returns this.
     */
    ДеревоКарта установи(K ключ, V значение)
    {
        бул пропущен;
        return установи(ключ, значение, пропущен);
    }

    /**
     * установи a ключ and значение pair.  If the pair didn't already exist, добавь обх.
     * был_добавлен is установи to true if the pair was добавленный.
     *
     * returns this.
     */
    ДеревоКарта установи(K ключ, V значение, ref бул был_добавлен)
    {
        элемент элт;
        элт.ключ = ключ;
        элт.знач = значение;
        был_добавлен = _дерево.добавь(элт);
        return this;
    }

    /**
     * установи all the elements from the given keyed iterator in the map.  Any ключ
     * that already exists will be overridden.
     *
     * Returns this.
     */
    ДеревоКарта установи(Ключник!(K, V) исток)
    {
        foreach(k, v; исток)
            установи(k, v);
        return this;
    }

    /**
     * установи all the elements from the given keyed iterator in the map.  Any ключ
     * that already exists will be overridden.  чло_добавленных is установи to the number
     * of ключ/значение pairs that were добавленный.
     *
     * Returns this.
     */
    ДеревоКарта установи(Ключник!(K, V) исток, ref бцел чло_добавленных)
    {
        бцел оригДлина = длина;
        установи(исток);
        чло_добавленных = длина - оригДлина;
        return this;
    }

    /**
     * Returns true if the given ключ is in the collection.
     *
     * Runs in O(lg(n)) time.
     */
    бул имеетКлюч(K ключ)
    {
        return найди(ключ) != конец;
    }

    /**
     * Returns the number of elements that contain the значение v
     *
     * Runs in O(n) time.
     */
    бцел счёт(V v)
    {
        бцел экземпляры = 0;
        foreach(x; this)
            if(x == v)
                экземпляры++;
        return экземпляры;
    }

    /**
     * Remove all the elements that contain the значение v.
     *
     * Runs in O(n + m lg(n)) time, where m is the number of elements removed.
     */
    ДеревоКарта удалиВсе(V v)
    {
        foreach(ref b, x; &очистить)
            b = cast(бул)(x == v);
        return this;
    }

    /**
     * Remove all the elements that contain the значение v.
     *
     * Runs in O(n + m lg(n)) time, where m is the number of elements removed.
     */
    ДеревоКарта удалиВсе(V v, ref бцел чло_Удалённых)
    {
        бцел оригДлина = длина;
        удалиВсе(v);
        чло_Удалённых = оригДлина - длина;
        return this;
    }

    /**
     * Get a duplicate of this tree map
     */
    ДеревоКарта dup()
    {
        return new ДеревоКарта(_дерево);
    }

    /**
     * Compare this ДеревоКарта with another Карта
     *
     * Returns 0 if o is not a Карта object, is null, or the ДеревоКарта does not
     * contain the same ключ/значение pairs as the given map.
     * Returns 1 if exactly the ключ/значение pairs contained in the given map are
     * in this ДеревоКарта.
     */
    цел opEquals(Объект o)
    {
        //
        // try casting to map, otherwise, don't compare
        //
        auto m = cast(Карта!(K, V))o;
        if(m !is null && m.length == длина)
        {
            auto _конец = конец;
            auto tm = cast(ДеревоКарта)o;
            if(tm !is null)
            {
                //
                // special case, we know that a tree map is sorted.
                //
                auto c1 = начало;
                auto c2 = tm.начало;
                while(c1 != _конец)
                {
                    if(c1.ключ != c2.ключ || c1++.значение != c2++.значение)
                        return 0;
                }
            }
            else
            {
                foreach(K k, V v; m)
                {
                    auto cu = найди(k);
                    if(cu is _конец || cu.значение != v)
                        return 0;
                }
            }
            return 1;
        }

        return 0;
    }

    /**
     * Набор all the elements from the given associative массив in the map.  Any
     * ключ that already exists will be overridden.
     *
     * returns this.
     */
    ДеревоКарта установи(V[K] исток)
    {
        foreach(K k, V v; исток)
            this[k] = v;
        return this;
    }

    /**
     * Набор all the elements from the given associative массив in the map.  Any
     * ключ that already exists will be overridden.
     *
     * sets чло_добавленных to the number of ключ значение pairs that were добавленный.
     *
     * returns this.
     */
    ДеревоКарта установи(V[K] исток, ref бцел чло_добавленных)
    {
        бцел оригДлина = длина;
        установи(исток);
        чло_добавленных = длина - оригДлина;
        return this;
    }

    /**
     * Remove all the given ключи from the map.
     *
     * return this.
     */
    ДеревоКарта удали(K[] поднабор)
    {
        foreach(k; поднабор)
            удалиПо(k);
        return this;
    }

    /**
     * Remove all the given ключи from the map.
     *
     * return this.
     *
     * чло_Удалённых is установи to the number of elements removed.
     */
    ДеревоКарта удали(K[] поднабор, ref бцел чло_Удалённых)
    {
        бцел оригДлина = длина;
        удали(поднабор);
        чло_Удалённых = оригДлина - длина;
        return this;
    }

    /**
     * Remove all the ключи that are not in the given массив.
     *
     * returns this.
     */
    ДеревоКарта накладка(K[] поднабор)
    {
        scope обход = new ОбходчикМассива!(K)(поднабор);
        return накладка(обход);
    }

    /**
     * Remove all the ключи that are not in the given массив.
     *
     * sets чло_Удалённых to the number of elements removed.
     *
     * returns this.
     */
    ДеревоКарта накладка(K[] поднабор, ref бцел чло_Удалённых)
    {
        scope обход = new ОбходчикМассива!(K)(поднабор);
        return накладка(обход, чло_Удалённых);
    }

}

version(UnitTest)
{
    unittest
    {
        auto tm = new ДеревоКарта!(бцел, бцел);
        Карта!(бцел, бцел) m = tm;
        for(цел i = 0; i < 10; i++)
            m[i * i + 1] = i;
        assert(m.length == 10);
        foreach(ref чистить_ли, k, v; &m.чисть_ключ)
        {
            чистить_ли = (v % 2 == 1);
        }
        assert(m.length == 5);
        assert(m.содержит(6));
        assert(m.имеетКлюч(6 * 6 + 1));
    }
}
