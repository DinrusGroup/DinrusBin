/*********************************************************
   Авторское право: (C) 2008 принадлежит Steven Schveighoffer.
              Все права защищены

   Лицензия: $(LICENSE)

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
 * tree, the function should добавь обх after all equivalent elements.
 *
 * Узел начало -> must be a Узел that points to the very первый valid
 * элемент in the tree, or конец if no elements exist.
 *
 * Узел конец -> must be a Узел that points to just past the very последн
 *валидного элемента.
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
     * алиас для удобства
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
     * Iterate through the elements of the collection, specifying which ones
     * следует удалить.
     *
     * Используйте таким образом:
     * -------------
     * // удалить все нечётные элементы
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
     *Очистить все элементы коллекции
     */
    ДеревоМультинабор очисти()
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
     *Возвращает да, если данное значение есть в коллекции.
     *
     * Runs in O(lg(n)) time.
     */
    бул содержит(З з)
    {
        return найди(з) != конец;
    }

    /**
     *Удаляет первый элемент, у которого значение з.  Возвращает да, если
     * значение имелось и было удалено.
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
     *Удаляет первый элемент, у которого значение з.  Возвращает да, если
     * значение имелось и было удалено.
     *
     * Runs in O(lg(n)) time.
     */
    ДеревоМультинабор удали(З з, ref бул был_Удалён)
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
     *Возвращает this.
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
     *Возвращает this.
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
     * Возвращает число элементов в коллекции, равное з.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements that are з.
     */
    бцел счёт(З з)
    {
        return _дерево.считайВсе(з);
    }

    /**
     * Удаляет все элементы, равные з.
     *
     * Runs in O(m lg(n)) time, where m is the number of elements that are з.
     */
    ДеревоМультинабор удалиВсе(З з)
    {
        _дерево.удалиВсе(з);
        return this;
    }
    
    /**
     * Удаляет все элементы, равные з.  Sets чло_Удалённых to the
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
