/*********************************************************
   Авторское право: (C) 2008 принадлежит Steven Schveighoffer.
              Все права защищены

   Лицензия: $(LICENSE)

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
 * Добавление элемента не влияет на валидность ни одно из курсоров.
 *
 * Removing an элемент only invalidates the cursors that were pointing at
 * that элемент.
 *
 * You can replace the Tree implementation with a custom implementation, the
 * implementation must be a struct template which can be instantiated with a
 * single template argument З, and must implement the following members
 * (члены-нефункции могут быть свойствами, если не задано иное):
 *
 * параметры -> должны быть структорой как минимум со следущими членами
 *   функцСравнения -> the compare function to use (should be a
 *                      ФункцСравнения!(З))
 *   обновлФункц -> используемая функция обновления (должна быть вроде
 *                     ФункцОбновления!(З))
 * 
 * проц установка(parameters p) -> initializes the tree with the given parameters.
 *
 * бцел счёт -> счёт of the elements in the tree
 *
 * Узел -> must be a struct/class with the following members:
 *   З значение -> the значение which is pointed to by this позиция (cannot be a
 *  каким-либо свойством)
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
 *валидного элемента.
 *
 * Узел найди(З з) -> returns a Узел that points to the элемент that
 * содержит з, или на конец , если его не существует.
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
         * Увеличивает этот курсор, возвращая то значение, которое было до
         * этого.
         */
        курсор opPostInc()
        {
            курсор врм = *this;
            укз = укз.следщ;
            return врм;
        }

        /**
         * Уменьшает этот курсор, возращая значение, которое было до
         * декрементации.
         */
        курсор opPostDec()
        {
            курсор врм = *this;
            укз = укз.предш;
            return врм;
        }

        /**
         * Увеличивает курсор на указанное количество.
         *
         * Это операция O(прир)!  * Следует лишь использовать этот оператор в 
         * такой форме:
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
         * Уменьшает курсор на заданное значение.
         *
         * Это операция O(прир)!  * Следует лишь использовать этот оператор в 
         * такой форме:
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
         * Сравнивает два курсора на равенство
         */
        бул opEquals(курсор обх)
        {
            return обх.ptr is укз;
        }
    }

    /**
     * Iterate through elements of the ДеревоНабор, specifying which ones to
     * удалить.
     *
     * Используйте таким образом:
     * -------------
     * // удалить все нечётные элементы
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
        курсор _конец = конец; //  ***
        while(!возврдг && обх != _конец)
        {
            //
            // не позволяет пользователю изменить значение
            //
            З врмзначение = обх.значение;
            чистить_ли = нет;
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
     * Итерирует по значениям коллекции
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
     *Очистить все элементы коллекции
     */
    ДеревоНабор очисти()
    {
        _дерево.очисти();
        return this;
    }

    /**
     * Возвращает число элементов в коллекции
     */
    бцел длина()
    {
        return _дерево.счёт;
    }
	alias длина length;

    /**
     * Возвращает курсор на первый элемент в коллекции.
     */
    курсор начало()
    {
        курсор обх;
        обх.ptr = _дерево.начало;
        return обх;
    }

    /**
     * Возвращает курсор, который указывает сразу после последнего элемента
     * коллекции.
     */
    курсор конец()
    {
        курсор обх;
        обх.ptr = _дерево.конец;
        return обх;
    }

    /**
     * Удаляет элемент, на который указывает данный курсор, возвращая
     * курсор, указывающий на следующий элемент в коллекции.
     *
     * Runs in O(lg(n)) time.
     */
    курсор удали(курсор обх)
    {
        обх.ptr = _дерево.удали(обх.ptr);
        return обх;
    }

    /**
     * находит экземпляр значения в коллекции.  Возвращает конец, если
     * значение отсутствует.
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
     *Возвращает да, если данное значение есть в коллекции.
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
            был_Удалён = нет;
        }
        else
        {
            удали(обх);
            был_Удалён = да;
        }
        return this;
    }

    /**
     * Adds a значение to the collection.
     * Возвращает да.
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
     * Возвращает да.
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
     * возвращает this.
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
     * возвращает this.
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
     * возвращает this.
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
        if(o !is пусто)
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
                    // равно
                    //
                    return 1;
                }
            }
        }
        //
        // сравнение невозможно.
        //
        return 0;
    }

    /**
     * Даёт наиболее подходящий элемент из набора.  * Это элемент, который
     *должен итерироваться первым.  Следовательно, вызов удали(дай())
     * гарантировано меньше, чем операция O(n).
     */
    З дай()
    {
        return начало.значение;
    }

    /**
     *Удалить наиболее подходящий элемент из набора, и вернуть его значение.
     * Это равносильно удали(дай()), только лишь один поиск
     * выполняется.
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
