/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.HashMap;

public import col.model.Map;
public import col.Functions;
private import col.Hash;

private import col.Iterators;

/+ ИНТЕРФЕЙС:

class ХэшКарта(К, З, alias ШаблРеализац=Хэш, alias хэшФункц=ДефХэш) : Карта!(К, З)
{

    struct элемент
    {
        К ключ;
        З знач;
        цел opEquals(элемент e);
    }
    struct курсор
    {
        З значение();
        К ключ();
        З значение(З з);
        курсор opPostInc();
        курсор opPostDec();
        курсор opAddAssign(цел прир);
        курсор opSubAssign(цел прир);
        бул opEquals(курсор обх);
    }

    final цел очистить(цел delegate(ref бул чистить_ли, ref З з) дг);
    final цел чисть_ключ(цел delegate(ref бул чистить_ли, ref К к, ref З з) дг);	
    цел opApply(цел delegate(ref К к, ref З з) дг);
    цел opApply(цел delegate(ref З з) дг);
    this();
    ХэшКарта очисти();
    бцел длина();
    курсор начало();
    курсор конец();
    курсор удали(курсор обх);
    курсор найдиЗначение(курсор обх, З з);
    курсор найдиЗначение(З з);
    курсор найди(К к);
    бул содержит(З з);
    ХэшКарта удали(З з);
    ХэшКарта удали(З з, ref бул был_Удалён);
    ХэшКарта удалиПо(К ключ);
    ХэшКарта удалиПо(К ключ, ref бул был_Удалён);
    З opIndex(К ключ);
    З opIndexAssign(З значение, К ключ);
    ХэшКарта установи(К ключ, З значение);
    ХэшКарта установи(К ключ, З значение, ref бул был_добавлен);
    ХэшКарта установи(Ключник!(К, З) исток);
    ХэшКарта установи(Ключник!(К, З) исток, ref бцел чло_добавленных);
    ХэшКарта удали(Обходчик!(К) поднабор);
    ХэшКарта удали(Обходчик!(К) поднабор, ref бцел чло_Удалённых);
    ХэшКарта накладка(Обходчик!(К) поднабор);
    ХэшКарта накладка(Обходчик!(К) поднабор, ref бцел чло_Удалённых);
    бул имеетКлюч(К ключ);
    бцел счёт(З з);
    ХэшКарта удалиВсе(З з);
    ХэшКарта удалиВсе(З з, ref бцел чло_Удалённых);
    Обходчик!(К) ключи();
    ХэшКарта dup();
    цел opEquals(Объект o);
    ХэшКарта установи(З[К] исток);
    ХэшКарта установи(З[К] исток, ref бцел чло_добавленных);
    ХэшКарта удали(К[] поднабор);
    ХэшКарта удали(К[] поднабор, ref бцел чло_Удалённых);
    ХэшКарта накладка(К[] поднабор);
    ХэшКарта накладка(К[] поднабор, ref бцел чло_Удалённых);
}
+///===========================================================

/**
 * Реализация карты, использующая Хэш для ближней вставки O(1),
 * удаления и поиска по времени.
 *
 * Добавка элемента может вывести из строя курсоры, в зависимости от реализации.
 *
 * Удаление элемента выводит из строя лишь те курсоры, которые указывали на
 * данный элемент.
 *
 * Реализацию Хэш можно заменить на адаптированную, этот
 * Хэш должен быть шаблонной структурой, инстанциируемой единственным
 * шаблонным аргументом З, и реализующей следующие члены (члены, не функции,
 * могут быть свойствами дай/установи, если иное не указано):
 *
 *
 * parameters -> must be a struct with at least the following members:
 *   хэшФункц -> the hash function to use (should be a ХэшФунк!(З))
 *   обновлФункц -> the update function to use (should be an
 *                     ФункцОбновления!(З))
 * 
 * проц установка(parameters p) -> initializes the hash with the given parameters.
 *
 * бцел счёт -> счёт of the elements in the hash
 *
 * позиция -> must be a struct/class with the following member:
 *   укз -> must define the following member:
 *     значение -> the значение which is pointed to by this позиция (cannot be a
 *                property)
 *   позиция следщ -> следщ позиция in the hash map
 *   позиция предш -> previous позиция in the hash map
 *
 * бул добавь(З з) -> добавь the given значение to the hash.  The hash of the значение
 * will be given by хэшФункц(з).  If the значение already exists in the hash,
 * this should call обновлФункц(з) and should not increment счёт.
 *
 * позиция начало -> must be a позиция that points to the very первый valid
 * элемент in the hash, or конец if no elements exist.
 *
 * позиция конец -> must be a позиция that points to just past the very последн
 * valid элемент.
 *
 * позиция найди(З з) -> returns a позиция that points to the элемент that
 * содержит з, or конец if the элемент doesn'т exist.
 *
 * позиция удали(позиция p) -> removes the given элемент from the hash,
 * returns the следщ valid элемент or конец if p was последн in the hash.
 *
 * проц очисти() -> removes all elements from the hash, sets счёт to 0.
 */
class ХэшКарта(К, З, alias ШаблРеализац=Хэш, alias хэшФункц=ДефХэш) : Карта!(К, З)
{
    /**
     * используется to implement the ключ/значение pair stored in the hash implementation
     */
    struct элемент
    {
        К ключ;
        З знач;

        /**
         * compare 2 elements for equality.  Only compares the ключи.
         */
        цел opEquals(элемент e)
        {
            return ключ == e.ключ;
        }
    }

    private КлючОбходчик _ключи;

    /**
     * Function to дай the hash of an элемент
     */
    static бцел _хэшФункция(ref элемент e)
    {
        return хэшФункц(e.ключ);
    }

    /**
     * Function to update an элемент according to the new элемент.
     */
    static проц _функцияОбнова(ref элемент исх, ref элемент новэлт)
    {
        //
        // only copy the значение, leave the ключ alone
        //
        исх.знач = новэлт.знач;
    }

    /**
     * convenience alias
     */
    alias ШаблРеализац!(элемент, _хэшФункция, _функцияОбнова) Реализ;

    private Реализ _хэш;

    /**
     * A курсор for the hash map.
     */
    struct курсор
    {
        private Реализ.позиция позиция;

        /**
         * дай the значение at this курсор
         */
        З значение()
        {
            return позиция.ptr.значение.знач;
        }

        /**
         * дай the ключ at this курсор
         */
        К ключ()
        {
            return позиция.ptr.значение.ключ;
        }

        /**
         * установи the значение at this курсор
         */
        З значение(З з)
        {
            позиция.ptr.значение.знач = з;
            return з;
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
            return обх.позиция is позиция;
        }
    }

    /**
     * Iterate over the values of the ХэшКарта, telling обх which ones to
     * удали.
     */
    final цел очистить(цел delegate(ref бул чистить_ли, ref З з) дг)
    {
        цел _дг(ref бул чистить_ли, ref К к, ref З з)
        {
            return дг(чистить_ли, з);
        }
        return _примени(&_дг);
    }

    /**
     * Iterate over the ключ/значение pairs of the ХэшКарта, telling обх which ones
     * to удали.
     */
    final цел чисть_ключ(цел delegate(ref бул чистить_ли, ref К к, ref З з) дг)
    {
        return _примени(дг);
    }

    private class КлючОбходчик : Обходчик!(К)
    {
        final бцел длина()
        {
            return this.outer.length;
        }

		alias длина length;
		
        final цел opApply(цел delegate(ref К) дг)
        {
            цел _дг(ref бул чистить_ли, ref К к, ref З з)
            {
                return дг(к);
            }
            return _примени(&_дг);
        }
    }

    private цел _примени(цел delegate(ref бул чистить_ли, ref К к, ref З з) дг)
    {
        курсор обх = начало;
        бул чистить_ли;
        цел возврдг = 0;
        курсор _конец = конец; // cache конец so обх isn'т always being generated
        while(!возврдг && обх != _конец)
        {
            //
            // don'т allow user to change ключ
            //
            К врмключ = обх.ключ;
            чистить_ли = false;
            if((возврдг = дг(чистить_ли, врмключ, обх.позиция.ptr.значение.знач)) != 0)
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
    цел opApply(цел delegate(ref К к, ref З з) дг)
    {
        цел _дг(ref бул чистить_ли, ref К к, ref З з)
        {
            return дг(к, з);
        }

        return _примени(&_дг);
    }

    /**
     * iterate over the collection's values
     */
    цел opApply(цел delegate(ref З з) дг)
    {
        цел _дг(ref бул чистить_ли, ref К к, ref З з)
        {
            return дг(з);
        }
        return _примени(&_дг);
    }

    /**
     * Instantiate the hash map
     */
    this()
    {
        // установка any hash info that needs to be done
        _хэш.установка();
        _ключи = new КлючОбходчик;
    }

    //
    // private constructor for dup
    //
    private this(ref Реализ дубИз)
    {
        дубИз.копируйВ(_хэш);
        _ключи = new КлючОбходчик;
    }

    /**
     * Clear the collection of all elements
     */
    ХэшКарта очисти()
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
     * найди a given значение in the collection starting at a given курсор.
     * This is useful to iterate over all elements that have the same значение.
     *
     * Runs in O(n) time.
     */
    курсор найдиЗначение(курсор обх, З з)
    {
        return _найдиЗначение(обх, конец, з);
    }

    /**
     * найди an instance of a значение in the collection.  Equivalent to
     * найдиЗначение(начало, з);
     *
     * Runs in O(n) time.
     */
    курсор найдиЗначение(З з)
    {
        return _найдиЗначение(начало, конец, з);
    }

    private курсор _найдиЗначение(курсор обх, курсор последн, З з)
    {
        while(обх != последн && обх.значение != з)
            обх++;
        return обх;
    }

    /**
     * найди the instance of a ключ in the collection.  Returns конец if the ключ
     * is not present.
     *
     * Runs in average O(1) time.
     */
    курсор найди(К к)
    {
        курсор обх;
        элемент врм;
        врм.ключ = к;
        обх.позиция = _хэш.найди(врм);
        return обх;
    }

    /**
     * Returns true if the given значение exists in the collection.
     *
     * Runs in O(n) time.
     */
    бул содержит(З з)
    {
        return найдиЗначение(з) != конец;
    }

    /**
     * Removes the первый элемент that has the значение з.  Returns true if the
     * значение was present and was removed.
     *
     * Runs in O(n) time.
     */
    ХэшКарта удали(З з)
    {
        бул пропущен;
        return удали(з, пропущен);
    }

    /**
     * Removes the первый элемент that has the значение з.  Returns true if the
     * значение was present and was removed.
     *
     * Runs in O(n) time.
     */
    ХэшКарта удали(З з, ref бул был_Удалён)
    {
        курсор обх = найдиЗначение(з);
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
     * Removes the элемент that has the given ключ.  Returns true if the
     * элемент was present and was removed.
     *
     * Runs on average in O(1) time.
     */
    ХэшКарта удалиПо(К ключ)
    {
        бул пропущен;
        return удалиПо(ключ, пропущен);
    }

    /**
     * Removes the элемент that has the given ключ.  Returns true if the
     * элемент was present and was removed.
     *
     * Runs on average in O(1) time.
     */
    ХэшКарта удалиПо(К ключ, ref бул был_Удалён)
    {
        курсор обх = найди(ключ);
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
     * Returns the значение that is stored at the элемент which has the given
     * ключ.  Throws an exception if the ключ is not in the collection.
     *
     * Runs on average in O(1) time.
     */
    З opIndex(К ключ)
    {
        курсор обх = найди(ключ);
        if(обх == конец)
            throw new Искл("Индекс вне диапазона");
        return обх.значение;
    }

    /**
     * assign the given значение to the элемент with the given ключ.  If the ключ
     * does not exist, adds the ключ and значение to the collection.
     *
     * Runs on average in O(1) time.
     */
    З opIndexAssign(З значение, К ключ)
    {
        установи(ключ, значение);
        return значение;
    }

    /**
     * Набор a ключ/значение pair.  If the ключ/значение pair doesn'т already exist, обх
     * is добавленный.
     */
    ХэшКарта установи(К ключ, З значение)
    {
        бул пропущен;
        return установи(ключ, значение, пропущен);
    }

    /**
     * Набор a ключ/значение pair.  If the ключ/значение pair doesn'т already exist, обх
     * is добавленный, and the был_добавлен parameter is установи to true.
     */
    ХэшКарта установи(К ключ, З значение, ref бул был_добавлен)
    {
        элемент элт;
        элт.ключ = ключ;
        элт.знач = значение;
        был_добавлен = _хэш.добавь(элт);
        return this;
    }

    /**
     * Набор all the values from the iterator in the map.  If any elements did
     * not previously exist, they are добавленный.
     */
    ХэшКарта установи(Ключник!(К, З) исток)
    {
        бцел пропущен;
        return установи(исток, пропущен);
    }

    /**
     * Набор all the values from the iterator in the map.  If any elements did
     * not previously exist, they are добавленный.  чло_добавленных is установи to the number of
     * elements that were добавленный in this operation.
     */
    ХэшКарта установи(Ключник!(К, З) исток, ref бцел чло_добавленных)
    {
        бцел исхдлина = длина;
        бул пропущен;
        foreach(к, з; исток)
        {
            установи(к, з, пропущен);
        }
        чло_добавленных = длина - исхдлина;
        return this;
    }

    /**
     * Remove all ключи from the map which are in поднабор.
     */
    ХэшКарта удали(Обходчик!(К) поднабор)
    {
        foreach(к; поднабор)
            удалиПо(к);
        return this;
    }

    /**
     * Remove all ключи from the map which are in поднабор.  чло_Удалённых is установи to
     * the number of ключи that were actually removed.
     */
    ХэшКарта удали(Обходчик!(К) поднабор, ref бцел чло_Удалённых)
    {
        бцел исхдлина = длина;
        удали(поднабор);
        чло_Удалённых = исхдлина - длина;
        return this;
    }

    ХэшКарта накладка(Обходчик!(К) поднабор)
    {
        бцел пропущен;
        return накладка(поднабор, пропущен);
    }

    /**
     * Эта функция сохраняет только элементы, наблюдаемые в поднаборе.
     */
    ХэшКарта накладка(Обходчик!(К) поднабор, ref бцел чло_Удалённых)
    {
        //
        // this one is a bit trickier than removing.  We want to найди each
        // Хэш элемент, then move обх to a new таблица.  However, we do not own
        // the implementation and cannot make assumptions about the
        // implementation.  So we defer the intersection to the hash
        // implementation.
        //
        // If we didn'т care about runtime, this could be done with:
        //
        // удали((new ХэшНабор!(К)).добавь(this.ключи).удали(поднабор));
        //

        //
        // need to create a wrapper iterator to pass to the implementation,
        // one that wraps each ключ in the поднабор as an элемент
        //
        // scope allocates on the stack.
        //
        scope w = new ТрансформОбходчик!(элемент, К)(поднабор, function проц(ref К к, ref элемент e) { e.ключ = к;});

        чло_Удалённых = _хэш.накладка(w);
        return this;
    }

    /**
     * Returns true if the given ключ is in the collection.
     *
     * Runs on average in O(1) time.
     */
    бул имеетКлюч(К ключ)
    {
        return найди(ключ) != конец;
    }

    /**
     * Returns the number of elements that contain the значение з
     *
     * Runs in O(n) time.
     */
    бцел счёт(З з)
    {
        бцел экземпляры = 0;
        foreach(x; this)
        {
            if(x == з)
                экземпляры++;
        }
        return экземпляры;
    }

    /**
     * Remove all the elements that contain the значение з.
     *
     * Runs in O(n) time.
     */
    ХэшКарта удалиВсе(З з)
    {
        бцел пропущен;
        return удалиВсе(з, пропущен);
    }
    /**
     * Remove all the elements that contain the значение з.
     *
     * Runs in O(n) time.
     */
    ХэшКарта удалиВсе(З з, ref бцел чло_Удалённых)
    {
        бцел исхдлина = длина;
        foreach(ref b, x; &очистить)
        {
            b = cast(бул)(x == з);
        }
        чло_Удалённых = исхдлина - длина;
        return this;
    }

    /**
     * return an iterator that can be используется to read all the ключи
     */
    Обходчик!(К) ключи()
    {
        return _ключи;
    }

    /**
     * Make a shallow copy of the hash map.
     */
    ХэшКарта dup()
    {
        return new ХэшКарта(_хэш);
    }

    /**
     * Compare this ХэшКарта with another Карта
     *
     * Returns 0 if o is not a Карта object, is null, or the ХэшКарта does not
     * contain the same ключ/значение pairs as the given map.
     * Returns 1 if exactly the ключ/значение pairs contained in the given map are
     * in this ХэшКарта.
     */
    цел opEquals(Объект o)
    {
        //
        // try casting to map, otherwise, don'т compare
        //
        auto m = cast(Карта!(К, З))o;
        if(m !is null && m.length == длина)
        {
            auto _конец = конец;
            foreach(К к, З з; m)
            {
                auto cu = найди(к);
                if(cu is _конец || cu.значение != з)
                    return 0;
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
    ХэшКарта установи(З[К] исток)
    {
        foreach(К к, З з; исток)
            this[к] = з;
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
    ХэшКарта установи(З[К] исток, ref бцел чло_добавленных)
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
    ХэшКарта удали(К[] поднабор)
    {
        foreach(к; поднабор)
            удалиПо(к);
        return this;
    }

    /**
     * Remove all the given ключи from the map.
     *
     * return this.
     *
     * чло_Удалённых is установи to the number of elements removed.
     */
    ХэшКарта удали(К[] поднабор, ref бцел чло_Удалённых)
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
    ХэшКарта накладка(К[] поднабор)
    {
        scope обход = new ОбходчикМассива!(К)(поднабор);
        return накладка(обход);
    }

    /**
     * Remove all the ключи that are not in the given массив.
     *
     * sets чло_Удалённых to the number of elements removed.
     *
     * returns this.
     */
    ХэшКарта накладка(К[] поднабор, ref бцел чло_Удалённых)
    {
        scope обход = new ОбходчикМассива!(К)(поднабор);
        return накладка(обход, чло_Удалённых);
    }
}

version(UnitTest)
{
    unittest
    {
        ХэшКарта!(бцел, бцел) хк = new ХэшКарта!(бцел, бцел);
        Карта!(бцел, бцел) m = хк;
        for(цел i = 0; i < 10; i++)
            хк[i * i + 1] = i;
        assert(хк.length == 10);
        foreach(ref бул чистить_ли, бцел к, бцел з; &хк.чисть_ключ)
        {
            чистить_ли = (з % 2 == 1);
        }
        assert(хк.length == 5);
        assert(хк.содержит(6));
        assert(хк.имеетКлюч(6 * 6 + 1));
    }
}
