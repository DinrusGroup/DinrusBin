/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.ArrayList;
public import col.model.List,
       col.model.Keyed;
	   
/+ ИНТЕРФЕЙС:

class МассивСписок(V) : СКлючом!(бцел, V), Список!(V) 
{
    private V[] _массив;
    private бцел _изменение;
    private МассивСписок!(V) _родитель;
    private МассивСписок!(V) _предок;

    final цел очистить(цел delegate(ref бул удалить_ли, ref V значение) дг);
    final цел чисть_ключ(цел delegate(ref бул удалить_ли, ref бцел ключ, ref V значение) дг);
    struct курсор
    {
        private V *укз;		alias укз ptr;

        V значение();
        V значение(V v);
        курсор opPostInc();
        курсор opPostDec();
        курсор opAddAssign(цел прир);
        курсор opSubAssign(цел прир);
        курсор opAdd(цел прир);
        курсор opSub(цел прир);
        цел opSub(курсор обх);
        цел opCmp(курсор обх);
        бул opEquals(курсор обх);
    this();
    this(V[] хранилище);
    МассивСписок!(V) очисти();
    бцел длина();
    курсор начало();
    курсор конец();;
    курсор удали(курсор старт, курсор последн);
    курсор удали(курсор элт);
    МассивСписок!(V) удали(V v, ref бул был_Удалён);
    МассивСписок!(V) удали(V v);
    курсор найди(курсор обх, V v);
    курсор найди(V v);
    бул содержит(V v);
    МассивСписок!(V) удалиПо(бцел ключ, ref бул был_Удалён);
    МассивСписок!(V) удалиПо(бцел ключ);
    V opIndex(бцел ключ);
    V opIndexAssign(V значение, бцел ключ);
    МассивСписок!(V) установи(бцел ключ, V значение, ref бул был_добавлен);
    МассивСписок!(V) установи(бцел ключ, V значение);
    цел opApply(цел delegate(ref V значение) дг);
    цел opApply(цел delegate(ref бцел ключ, ref V значение) дг);
    бул имеетКлюч(бцел ключ);
    МассивСписок!(V) добавь(V v, ref бул был_добавлен);
    МассивСписок!(V) добавь(V v);
    МассивСписок!(V) добавь(Обходчик!(V) колл);
    МассивСписок!(V) добавь(Обходчик!(V) колл, ref бцел чло_добавленных);
    МассивСписок!(V) добавь(V[] массив);
    МассивСписок!(V) добавь(V[] массив, ref бцел чло_добавленных);
    МассивСписок!(V) opCatAssign(Список!(V) rhs);
    МассивСписок!(V) opCatAssign(V[] массив);
    МассивСписок!(V) opCat(Список!(V) rhs);
    МассивСписок!(V) opCat(V[] массив);
    МассивСписок!(V) opCat_r(V[] массив); 
    бцел счёт(V v);
    МассивСписок!(V) удалиВсе(V v, ref бцел чло_Удалённых);
    МассивСписок!(V) удалиВсе(V v);
    МассивСписок!(V) opSlice(бцел b, бцел e);
    МассивСписок!(V) opSlice(курсор b, курсор e);
    МассивСписок!(V) dup();
    V[] какМассив();
    цел opEquals(Объект o);
    цел opEquals(V[] массив);
    V фронт();
    V тыл();
    V возьмиФронт();
    V возьмиТыл();
    бцел индексУ(V v);

    class ОсобоеИнфОТипе(бул использоватьФункцию) : ИнфОТипе
    {
        static if(использоватьФункцию)
            alias цел function(ref V v1, ref V v2) ФункцСравнения;
        else
            alias цел delegate(ref V v1, ref V v2) ФункцСравнения;
        private ФункцСравнения cf;
        private ИнфОТипе производныйОт;
		
        this(ИнфОТипе производныйОт, ФункцСравнения comp);
        override hash_t дайХэш(ук p);
        override цел equals(ук p1, ук p2);
        override цел сравни(ук p1, ук p2);
        override size_t tsize();
        override проц swap(ук p1, ук p2);
        override ИнфОТипе следщ();
        override проц[] init();
        override бцел flags();
        override OffsetTypeInfo[] offTi();
		МассивСписок сортируй(цел delegate(ref V v1, ref V v2) comp);
		МассивСписок сортируй(цел function(ref V v1, ref V v2) comp);
		МассивСписок сортируй();
	}
}
+/
//=================================================================

private struct Array
{
    цел length;
    ук ptr;
}

private extern (C) дол _adSort(Array arr, ИнфОТипе иот);

/***
 * Как обёртка массиву, этот класс обеспечивает необходимую реализацию
 * интерфейса Список (Список)
 *
 * Adding or removing any элемент invalidates all cursors.
 *
 * Класс служит шлюзом между встроенными массивами и классами этого пакета.
 * Можно строить МассивСписок с помощью встроенного массива, в качестве
 * средства сохранения, и получать доступ к этому МассивСписку  с помощью функции какМассив.
 * Копии массива не делается, поэтому можно продолжать использовать
 * массив в обеих формах.
 */
class МассивСписок(V) : СКлючом!(бцел, V), Список!(V) 
{
    private V[] _массив;
    private бцел _изменение;
    //
    // Примечание о родителе и предке.  Родитель - это массив, список
    // является срезом которого.The ancestor is the highest родитель in the
    // lineage.  If a slice is добавленный to, обх now creates its own массив, и
    // becomes its own ancestor.  It is no longer in the lineage.  However, we
    // do not установи _родитель to пусто, because обх is needed for any slices that
    // were subslices of the slice.  Those should not be invalidated, и they
    // need to have a цепь to their ancestor.  So if you добавь data to a slice,
    // обх becomes an empty link in the original lineage цепь.
    //
    private МассивСписок!(V) _родитель;
    private МассивСписок!(V) _предок;

    /**
     * Iterate over the элементы in the МассивСписок, telling обх which ones
     * should be removed
     *
     * Use like this:
     *
     * -------------
     * // удали all odd элементы
     * foreach(ref удалить_ли, v; &arrayList.очистить)
     * {
     *   удалить_ли = (v & 1) != 0;
     * }
     * ------------
     */
    final цел очистить(цел delegate(ref бул удалить_ли, ref V значение) дг)
    {
        return _примени(дг, _начало, _конец);
    }

    /**
     * Iterate over the элементы in the МассивСписок, telling обх which ones
     * should be removed.
     *
     * Use like this:
     * -------------
     * // удали all odd indexes
     * foreach(ref удалить_ли, k, v; &arrayList.очистить)
     * {
     *   удалить_ли = (k & 1) != 0;
     * }
     * ------------
     */
    final цел чисть_ключ(цел delegate(ref бул удалить_ли, ref бцел ключ, ref V значение) дг)
    {
        return _примени(дг, _начало, _конец);
    }

    /**
     * The массив курсор is exactly like a pointer into the массив.  The only
     * difference between an МассивСписок курсор и a pointer is that the
     * МассивСписок курсор provides the значение property which is common
     * throughout the collection package.
     *
     * All operations on the курсор are O(1)
     */
    struct курсор
    {
        private V *укз;		alias укз ptr;
        
        /**
         * дай the значение pointed to
         */
        V значение()
        {
            return *укз;
        }

        /**
         * установи the значение pointed to
         */
        V значение(V v)
        {
            return (*укз = v);
        }

        /**
         * increment this курсор, returns что the курсор was перед
         * incrementing.
         */
        курсор opPostInc()
        {
            курсор врм = *this;
            укз++;
            return врм;
        }

        /**
         * decrement this курсор, returns что the курсор was перед
         * decrementing.
         */
        курсор opPostDec()
        {
            курсор врм = *this;
            укз--;
            return врм;
        }

        /**
         * increment the курсор by the given amount.
         */
        курсор opAddAssign(цел прир)
        {
            укз += прир;
            return *this;
        }

        /**
         * decrement the курсор by the given amount.
         */
        курсор opSubAssign(цел прир)
        {
            укз -= прир;
            return *this;
        }

        /**
         * return a курсор that is прир элементы beyond this курсор.
         */
        курсор opAdd(цел прир)
        {
            курсор рез = *this;
            рез.ptr += прир;
            return рез;
        }

        /**
         * return a курсор that is прир элементы перед this курсор.
         */
        курсор opSub(цел прир)
        {
            курсор рез = *this;
            рез.ptr -= прир;
            return рез;
        }

        /**
         * return the number of элементы between this курсор и the given
         * курсор.  If обх points to a later элемент, the рез is negative.
         */
        цел opSub(курсор обх)
        {
            return укз - обх.ptr;
        }

        /**
         * сравни two cursors.
         */
        цел opCmp(курсор обх)
        {
            if(укз < обх.ptr)
                return -1;
            if(укз > обх.ptr)
                return 1;
            return 0;
        }

        /**
         * сравни two cursors for equality.
         */
        бул opEquals(курсор обх)
        {
            return укз is обх.ptr;
        }
    }

    /**
     * create a new empty МассивСписок
     */
    this()
    {
        _предок = this;
        _родитель = пусто;
    }

    /**
     * Use an массив as the backing хранилище.  This does not дубликат the
     * массив.  Use new МассивСписок(хранилище.dup) to make a distinct копируй.
     */
    this(V[] хранилище)
    {
        this();
        _массив = хранилище;
    }

    private this(МассивСписок!(V) родитель, курсор s, курсор e)
    {
        _родитель = родитель;
        _предок = родитель._предок;
        _изменение = родитель._изменение;
        проверьИзменение();
        бцел ib = s - родитель._начало;
        бцел ie = e - родитель._начало;
        _массив = родитель._массив[ib..ie];
    }

    /**
     * очисти the container of all значения
     */
    МассивСписок!(V) очисти()
    {
        if(предок_ли)
        {
            _массив = пусто;
            _изменение++;
        }
        else
        {
            удали(_начало, _конец);
        }
        return this;
    }

    /**
     * return the number of элементы in the collection
     */
    бцел длина()
    {
        проверьИзменение();
        return _массив.length;
    }

	alias длина length;
    /**
     * return a курсор that points to the первый элемент in the list.
     */
    курсор начало()
    {
        проверьИзменение();
        return _начало;
    }

    private курсор _начало()
    {
        курсор обх;
        обх.ptr = _массив.ptr;
        return обх;
    }

    /**
     * return a курсор that points to just beyond the последн элемент in the
     * list.
     */
    курсор конец()
    {
        проверьИзменение();
        return _конец;
    }

    private курсор _конец()
    {
        курсор обх;
        обх.ptr = _массив.ptr + _массив.length;
        return обх;
    }


    private цел _примени(цел delegate(ref бул, ref бцел, ref V) дг, курсор старт, курсор последн)
    {
        return _примени(дг, старт, последн, _начало);
    }

    private цел _примени(цел delegate(ref бул, ref бцел, ref V) дг, курсор старт, курсор последн, курсор ссылка)
    {
        цел возврдг;
        if(предок_ли)
        {
            курсор i = старт;
            курсор следщХор = старт;
            курсор конссыл = _конец;

            бул удалить_ли;

            //
            // loop перед removal
            //
            for(; возврдг == 0 && i != последн; i++, следщХор++)
            {
                удалить_ли = false;
                бцел ключ = i - ссылка;
                if((возврдг = дг(удалить_ли, ключ, *i.ptr)) == 0)
                {
                    if(удалить_ли)
                    {
                        //
                        // первый removal
                        //
                        _изменение++;
                        i++;
                        break;
                    }
                }
            }

            //
            // loop after первый removal
            //
            if(следщХор != i)
            {
                for(; i < конссыл; i++, следщХор++)
                {
                    удалить_ли = false;
                    бцел ключ = i - ссылка;
                    if(i >= последн || возврдг != 0 || (возврдг = дг(удалить_ли, ключ, *i.ptr)) != 0)
                    {
                        //
                        // not calling дг any more
                        //
                        следщХор.значение = i.значение;
                    }
                    else if(удалить_ли)
                    {
                        //
                        // дг requested a removal
                        //
                        следщХор--;
                    }
                    else
                    {
                        //
                        // дг did not request a removal
                        //
                        следщХор.значение = i.значение;
                    }
                }
            }

            //
            // shorten the длина
            //
            if(следщХор != конссыл)
            {
                _массив.length = следщХор - _начало;
                return конссыл - следщХор;
            }
        }
        else
        {
            //
            // use the ancestor to perform the apply, then adjust the массив
            // accordingly.
            //
            проверьИзменение();
            auto p = следщРодитель;
            auto оригДлина = p._массив.length;
            возврдг = p._примени(дг, старт, последн, _начало);
            auto чло_Удалённых = оригДлина - p._массив.length;
            if(чло_Удалённых > 0)
            {
                _массив = _массив[0..$-чло_Удалённых];
                _изменение = _предок._изменение;
            }
        }
        return возврдг;
    }

    private цел _примени(цел delegate(ref бул, ref V) дг, курсор старт, курсор последн)
    {
        цел _дг(ref бул b, ref бцел k, ref V v)
        {
            return дг(b, v);
        }
        return _примени(&_дг, старт, последн);
    }

    private проц проверьИзменение()
    {
        if(_изменение != _предок._изменение)
            throw new Искл("underlying МассивСписок changed");
    }

    private бул предок_ли()
    {
        return _предок is this;
    }

    //
    // Get the следщ родитель in the lineage.  Skip over any parents that do not
    // совместно our ancestor, they are not part of the lineage any more.
    //
    private МассивСписок!(V) следщРодитель()
    {
        auto возврзнач = _родитель;
        while(возврзнач._предок !is _предок)
            возврзнач = возврзнач._родитель;
        return возврзнач;
    }

    /**
     * удали all the элементы from старт to последн, not including the элемент
     * pointed to by последн.  Returns a действителен курсор that points to the
     * элемент последн pointed to.
     *
     * Runs in O(n) time.
     */
    курсор удали(курсор старт, курсор последн)
    {
        if(предок_ли)
        {
            цел проверь(ref бул b, ref V)
            {
                b = true;
                return 0;
            }
            _примени(&проверь, старт, последн);
        }
        else
        {
            проверьИзменение();
            следщРодитель.удали(старт, последн);
            _массив = _массив[0..($ - (последн - старт))];
            _изменение = _предок._изменение;
        }
        return старт;
    }

    /**
     * удали the элемент pointed to by элт.  Equivalent to удали(элт, элт
     * + 1).
     *
     * Runs in O(n) time
     */
    курсор удали(курсор элт)
    {
        return удали(элт, элт + 1);
    }

    /**
     * удали an элемент with the specific значение.  This is an O(n)
     * operation.  If the collection имеется дубликат экземпляры, the первый
     * элемент that совпадает is removed.
     *
     * returns this.
     *
     * Sets был_Удалён to true if the элемент existed и was removed.
     */
    МассивСписок!(V) удали(V v, ref бул был_Удалён)
    {
        auto обх = найди(v);
        if(обх == _конец)
            был_Удалён = false;
        else
        {
            удали(обх);
            был_Удалён = true;
        }
        return this;
    }

    /**
     * удали an элемент with the specific значение.  This is an O(n)
     * operation.  If the collection имеется дубликат экземпляры, the первый
     * элемент that совпадает is removed.
     *
     * returns this.
     */
    МассивСписок!(V) удали(V v)
    {
        бул пропущен;
        return удали(v, пропущен);
    }

    /**
     * same as найди(v), but старт at given позиция.
     */
    курсор найди(курсор обх, V v)
    {
        return _найди(обх, _конец, v);
    }

    // same as найди(v), but ищи only a given range at given позиция.
    private курсор _найди(курсор обх, курсор последн,  V v)
    {
        проверьИзменение();
        while(обх < последн && обх.значение != v)
            обх++;
        return обх;
    }

    /**
     * найди the первый occurrence of an элемент in the list.  Runs in O(n)
     * time.
     */
    курсор найди(V v)
    {
        return _найди(_начало, _конец, v);
    }

    /**
     * returns true if the collection содержит the значение.  Runs in O(n) time.
     */
    бул содержит(V v)
    {
        return найди(v) < _конец;
    }

    /**
     * удали the элемент at the given index.  Runs in O(n) time.
     */
    МассивСписок!(V) удалиПо(бцел ключ, ref бул был_Удалён)
    {
        if(ключ > длина)
        {
            был_Удалён = false;
        }
        else
        {
            удали(_начало + ключ);
            был_Удалён = true;
        }
        return this;
    }

    /**
     * удали the элемент at the given index.  Runs in O(n) time.
     */
    МассивСписок!(V) удалиПо(бцел ключ)
    {
        бул пропущен;
        return удалиПо(ключ, пропущен);
    }

    /**
     * дай the значение at the given index.
     */
    V opIndex(бцел ключ)
    {
        проверьИзменение();
        return _массив[ключ];
    }

    /**
     * установи the значение at the given index.
     */
    V opIndexAssign(V значение, бцел ключ)
    {
        проверьИзменение();
        //
        // does not change мутация because 
        return _массив[ключ] = значение;
    }

    /**
     * установи the значение at the given index
     */
    МассивСписок!(V) установи(бцел ключ, V значение, ref бул был_добавлен)
    {
        this[ключ] = значение;
        был_добавлен = false;
        return this;
    }

    /**
     * установи the значение at the given index
     */
    МассивСписок!(V) установи(бцел ключ, V значение)
    {
        this[ключ] = значение;
        return this;
    }

    /**
     * iterate over the collection
     */
    цел opApply(цел delegate(ref V значение) дг)
    {
        цел возврзнач;
        курсор конссыл = конец; // call проверьmutation
        for(курсор i = _начало; i != конссыл; i++)
        {
            if((возврзнач = дг(*i.ptr)) != 0)
                break;
        }
        return возврзнач;
    }

    /**
     * iterate over the collection with ключ и значение
     */
    цел opApply(цел delegate(ref бцел ключ, ref V значение) дг)
    {
        цел возврзнач = 0;
        auto ссылка = начало; // call проверьmutation
        auto конссыл = _конец;
        for(курсор i = ссылка; i != конссыл; i++)
        {
            бцел ключ = i - ссылка;
            if((возврзнач = дг(ключ, *i.ptr)) != 0)
                break;
        }
        return возврзнач;
    }

    /**
     * returns true if the given index is действителен
     *
     * Runs in O(1) time
     */
    бул имеетКлюч(бцел ключ)
    {
        return ключ < длина;
    }

    /**
     * добавь the given значение to the конец of the list.  Always returns true.
     */
    МассивСписок!(V) добавь(V v, ref бул был_добавлен)
    {
        //
        // поставь to this массив.  Reset the ancestor to this, because now we
        // are dealing with a new массив.
        //
        if(предок_ли)
        {
            _массив ~= v;
            _изменение++;
        }
        else
        {
            _предок = this;
            //
            // ensure that we don't just do an поставь.
            //
            _массив = _массив ~ v;

            //
            // no need to change the мутация, we are a new ancestor.
            //
        }

        // always succeeds
        был_добавлен = true;
        return this;
    }

    /**
     * добавь the given значение to the конец of the list.
     */
    МассивСписок!(V) добавь(V v)
    {
        бул пропущен;
        return добавь(v, пропущен);
    }

    /**
     * adds all элементы from the given обходчик to the конец of the list.
     */
    МассивСписок!(V) добавь(Обходчик!(V) колл)
    {
        бцел пропущен;
        return добавь(колл, пропущен);
    }

    /**
     * adds all элементы from the given обходчик to the конец of the list.
     */
    МассивСписок!(V) добавь(Обходчик!(V) колл, ref бцел чло_добавленных)
    {
        auto al = cast(МассивСписок!(V))колл;
        if(al)
        {
            //
            // optimized case
            //
            return добавь(al._массив, чло_добавленных);
        }

        //
        // генерный case
        //
        проверьИзменение();
        чло_добавленных = колл.length;
        if(чло_добавленных != cast(бцел)-1)
        {
            if(чло_добавленных > 0)
            {
                цел i = _массив.length;
                if(предок_ли)
                {
                    _массив.length = _массив.length + чло_добавленных;
                }
                else
                {
                    _предок = this;
                    auto нов_массив = new V[_массив.length + чло_добавленных];
                    нов_массив[0.._массив.length] = _массив[];

                }
                foreach(v; колл)
                    _массив [i++] = v;
                _изменение++;
            }
        }
        else
        {
            auto исхдлина = _массив.length;
            бул firstdone = false;
            foreach(v; колл)
            {
                if(!firstdone)
                {
                    //
                    // trick to дай firstdone установи to true, because был_добавлен is
                    // always установи to true.
                    //
                    добавь(v, firstdone);
                }
                else
                    _массив ~= v;
            }
            чло_добавленных = _массив.length - исхдлина;
        }
        return this;
    }


    /**
     * appends the массив to the конец of the list
     */
    МассивСписок!(V) добавь(V[] массив)
    {
        бцел пропущен;
        return добавь(массив, пропущен);
    }

    /**
     * appends the массив to the конец of the list
     */
    МассивСписок!(V) добавь(V[] массив, ref бцел чло_добавленных)
    {
        проверьИзменение();
        чло_добавленных = массив.length;
        if(массив.length)
        {
            if(предок_ли)
            {
                _массив ~= массив;
                _изменение++;
            }
            else
            {
                _предок = this;
                _массив = _массив ~ массив;
            }
        }
        return this;
    }

    /**
     * поставь another list to the конец of this list
     */
    МассивСписок!(V) opCatAssign(Список!(V) rhs)
    {
        return добавь(rhs);
    }

    /**
     * поставь an массив to the конец of this list
     */
    МассивСписок!(V) opCatAssign(V[] массив)
    {
        return добавь(массив);
    }

    /**
     * returns a concatenation of the массив list и another list.
     */
    МассивСписок!(V) opCat(Список!(V) rhs)
    {
        return dup.добавь(rhs);
    }

    /**
     * returns a concatenation of the массив list и an массив.
     */
    МассивСписок!(V) opCat(V[] массив)
    {
        проверьИзменение();
        return new МассивСписок!(V)(_массив ~ массив);
    }

    /**
     * returns a concatenation of the массив list и an массив.
     */
    МассивСписок!(V) opCat_r(V[] массив)
    {
        проверьИзменение();
        return new МассивСписок!(V)(массив ~ _массив);
    }

    /**
     * returns the number of экземпляры of the given элемент значение
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
     * removes all the экземпляры of the given элемент значение
     *
     * Runs in O(n) time.
     */
    МассивСписок!(V) удалиВсе(V v, ref бцел чло_Удалённых)
    {
        auto оригДлина = длина;
        foreach(ref b, x; &очистить)
        {
            b = cast(бул)(x == v);
        }
        чло_Удалённых = длина - оригДлина;
        return this;
    }

    /**
     * removes all the экземпляры of the given элемент значение
     *
     * Runs in O(n) time.
     */
    МассивСписок!(V) удалиВсе(V v)
    {
        бцел пропущен;
        return удалиВсе(v, пропущен);
    }

    /**
     * Returns a slice of an массив list.  A slice can be используется to view
     * элементы, удали элементы, but cannot be используется to добавь элементы.
     *
     * The returned slice begins at index b и ends at, but does not include,
     * index e.
     */
    МассивСписок!(V) opSlice(бцел b, бцел e)
    {
        return opSlice(_начало + b, _начало + e);
    }

    /**
     * Slice an массив given the cursors
     */
    МассивСписок!(V) opSlice(курсор b, курсор e)
    {
        if(e > конец || b < _начало) // call проверьИзменение once
            throw new Искл("значение среза вне диапазона");

        //
        // make an массив list that is a slice of this массив list
        //
        return new МассивСписок!(V)(this, b, e);
    }

    /**
     * Returns a копируй of an массив list
     */
    МассивСписок!(V) dup()
    {
        return new МассивСписок!(V)(_массив.dup);
    }

    /**
     * дай the массив that this массив represents.  This is NOT a копируй of the
     * data, so modifying элементы of this массив will modify элементы of the
     * original МассивСписок.  Appending элементы from this массив will not affect
     * the original массив list just like appending to an массив will not affect
     * the original.
     */
    V[] какМассив()
    {
        return _массив;
    }

    /**
     * operator to сравни two objects.
     *
     * If o is a Список!(V), then this does a list сравни.
     * If o is пусто or not an МассивСписок, then the return значение is 0.
     */
    цел opEquals(Объект o)
    {
        if(o !is пусто)
        {
            auto li = cast(Список!(V))o;
            if(li !is пусто && li.length == длина)
            {
                auto al = cast(МассивСписок!(V))o;
                if(al !is пусто)
                    return _массив == al._массив;
                else
                {
                    цел i = 0;
                    foreach(элт; li)
                    {
                        if(элт != _массив[i++])
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
     * Сравни to a V массив.
     *
     * equivalent to какМассив == массив.
     */
    цел opEquals(V[] массив)
    {
        return _массив == массив;
    }

    /**
     *  Look at the элемент at the фронт of the МассивСписок.
     */
    V фронт()
    {
        return начало.значение;
    }

    /**
     * Look at the элемент at the конец of the МассивСписок.
     */
    V тыл()
    {
        return (конец - 1).значение;
    }

    /**
     * Remove the элемент at the фронт of the МассивСписок и return its значение.
     * This is an O(n) operation.
     */
    V возьмиФронт()
    {
        auto c = начало;
        auto возврзнач = c.значение;
        удали(c);
        return возврзнач;
    }

    /**
     * Remove the элемент at the конец of the МассивСписок и return its значение.
     * This can be an O(n) operation.
     */
    V возьмиТыл()
    {
        auto c = конец - 1;
        auto возврзнач = c.значение;
        удали(c);
        return возврзнач;
    }

    /**
     * Get the index of a particular значение.  Equivalent to найди(v) - начало.
     *
     * If the значение isn't in the collection, returns длина.
     */
    бцел индексУ(V v)
    {
        return найди(v) - начало;
    }

    class ОсобоеИнфОТипе(бул использоватьФункцию) : ИнфОТипе
    {
        static if(использоватьФункцию)
            alias цел function(ref V v1, ref V v2) ФункцСравнения;
        else
            alias цел delegate(ref V v1, ref V v2) ФункцСравнения;
        private ФункцСравнения cf;
        private ИнфОТипе производныйОт;
        this(ИнфОТипе производныйОт, ФункцСравнения comp)
        {
            this.производныйОт = производныйОт;
            this.cf = comp;
        }

        /// Returns a хэш of the instance of a type.
        override hash_t дайХэш(ук p) { return производныйОт.дайХэш(p); }

        /// Compares two экземпляры for equality.
        override цел equals(ук p1, ук p2) { return производныйОт.equals(p1, p2); }

        /// Compares two экземпляры for &lt;, ==, or &gt;.
        override цел сравни(ук p1, ук p2)
        {
            return cf(*cast(V *)p1, *cast(V *)p2);
        }

        /// Returns размер of the type.
        override size_t tsize() { return производныйОт.tsize(); }

        /// Swaps two экземпляры of the type.
        override проц swap(ук p1, ук p2)
        {
            return производныйОт.swap(p1, p2);
        }

        /// Get ИнфОТипе for 'следщ' type, as defined by что kind of type this is,
        /// пусто if none.
        override ИнфОТипе следщ() { return производныйОт; }

        /// Return default initializer, пусто if default initialize to 0
        override проц[] init() { return производныйОт.init(); }

        /// Get flags for type: 1 means GC should scan for pointers
        override бцел flags() { return производныйОт.flags(); }

        /// Get type information on the contents of the type; пусто if not available
        override OffsetTypeInfo[] offTi() { return производныйОт.offTi(); }
    }

    /**
     * Sort according to a given comparison function
     */
    МассивСписок сортируй(цел delegate(ref V v1, ref V v2) comp)
    {
        //
        // can't really do this without extra library помощь.  Luckily, the
        // function to сортируй an массив is always defined by the runtime.  We
        // just need to доступ обх.  However, обх требует that we pass in a
        // ИнфОТипе structure to do all the dirty work.  What we need is a
        // derivative of the real ИнфОТипе structure with the сравни function
        // overridden to call the comp function.
        //
        //scope ОсобоеИнфОТипе!(typeof(typeid(V))) sti = new ОсобоеИнфОТипе(comp);
        scope sti = new ОсобоеИнфОТипе!(false)(typeid(V), comp);
        цел x;
        Array ar;
        ar.length = _массив.length;
        ar.ptr = _массив.ptr;
        _adSort(ar, sti);
        return this;
    }

    /**
     * Sort according to a given comparison function
     */
    МассивСписок сортируй(цел function(ref V v1, ref V v2) comp)
    {
        //
        // can't really do this without extra library помощь.  Luckily, the
        // function to сортируй an массив is always defined by the runtime.  We
        // just need to доступ обх.  However, обх требует that we pass in a
        // ИнфОТипе structure to do all the dirty work.  What we need is a
        // derivative of the real ИнфОТипе structure with the сравни function
        // overridden to call the comp function.
        //
        //scope ОсобоеИнфОТипе!(typeof(typeid(V))) sti = new ОсобоеИнфОТипе(comp);
        scope sti = new ОсобоеИнфОТипе!(true)(typeid(V), comp);
        цел x;
        Array ar;
        ar.length = _массив.length;
        ar.ptr = _массив.ptr;
        _adSort(ar, sti);
        return this;
    }

    /**
     * Sort according to the default comparison routine for V
     */
    МассивСписок сортируй()
    {
        _массив.sort;
        return this;
    }
}

version(UnitTest)
{
    void main()
    {
        auto al = new МассивСписок!(бцел);
        al.добавь([0U, 1, 2, 3, 4, 5]);
        assert(al.length == 6);
        al.добавь(al[0..3]);
        assert(al.length == 9);
        foreach(ref бул dp, бцел инд, бцел знач; &al.чисть_ключ)
            dp = (знач % 2 == 1);
        assert(al.length == 5);
        assert(al == [0U, 2, 4, 0, 2]);
        assert(al == new МассивСписок!(бцел)([0U, 2, 4, 0, 2].dup));
        assert(al.начало.ptr is al.какМассив.ptr);
        assert(al.конец.ptr is al.какМассив.ptr + al.length);
    }
}
