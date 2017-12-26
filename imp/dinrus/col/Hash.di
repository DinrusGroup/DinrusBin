/*********************************************************
   Авторское право: (C) 2008 принадлежит Steven Schveighoffer.
              Все права защищены

   Лицензия: $(LICENSE)

**********************************************************/
module col.Hash;

private import col.Link;
private import col.model.Iterator;
private import col.DefaultAllocator;

/+  ИНТЕРФЕЙС:

struct ДефолтыХэш
{
    const плав факторЗагрузки = .75;
    const бцел размерТаблицы = 31;
}


struct Хэш(З, alias хэшФункц, alias обновлФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель, бул допускатьДубликаты=нет, бул обновить_ли=да)
{
 Связка!(З).Узел узел;
 alias Разместитель!(Связка!(З)) разместитель;
 разместитель разм;
 узел[] таблица;
 бцел счёт;
    struct позиция
    {
        Хэш *владелец;
        узел укз; alias укз ptr;
        цел инд;
        позиция следщ();
        позиция предш();
    бул добавь(З з);
    проц перемерьПод(бцел ёмкость);
    проц проверьФакторЗагрузки();
    позиция начало();
    позиция конец();
    позиция найди(З з);
    позиция удали(позиция поз);
    проц очисти();
    бцел накладка(Обходчик!(З) поднабор);;
        бцел считайВсе(З з);
        бцел удалиВсе(З з);
        позиция найди(З з, позиция начатьС);
    проц копируйВ(ref Хэш цель);
    узел размести();
    узел размести(З з);
    проц установка();
}


template ХэшБезОбновлений(З, alias хэшФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель);

template ХэшДуб(З, alias хэшФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель);

+/
//==================================================================
struct ДефолтыХэш
{
    const плав факторЗагрузки = .75;
    const бцел размерТаблицы = 31;
}

/**
 *Реализация Хэш по умолчанию.  Используется в контейнерах Хэш* по
 * умолчанию.
 *
 * Реализация состоит из таблицы линкованных списков.  Индексный указатель таблицы
 * , то есть, входящий в неё элемент, основывается на хэш-коде.
 */
struct Хэш(З, alias хэшФункц, alias обновлФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель, бул допускатьДубликаты=нет, бул обновить_ли=да)
{
    /**
     * alias for Узел
     */
    alias Связка!(З).Узел узел;

    /**
     * alias for the Разместитель
     */
    alias Разместитель!(Связка!(З)) разместитель;

    /**
     * Разместитель для хэша
     */
    разместитель разм;

    /**
     * таблица бакетов
     */
    узел[] таблица;

    /**
     * Счёт элементов в таблице
     */
    бцел счёт;

    /**
     * Подобно указателю, используется для указания на данный элемент в хэше.
     */
    struct позиция
    {
        Хэш *владелец;
        узел укз; alias укз ptr;
        цел инд;

        /**
         * Возвращает позицию, которая идёт после p.
         */
        позиция следщ()
        {
            позиция p = *this;
            auto таблица = владелец.таблица;

            if(p.ptr !is пусто)
            {
                if(p.ptr.следщ is таблица[p.инд])
                    //
                    // особый случай, в конце бакета, переход к следщ
                    // бакет.
                    //
                    p.ptr = пусто;
                else
                {
                    //
                    // всё ещё в бакете
                    //
                    p.ptr = p.ptr.следщ;
                    return p;
                }
            }

            //
            //итерирует за бакет, переходит к следщ валидному бакету
            //
            while(p.инд < cast(цел)таблица.length && p.ptr is пусто)
            {
                if(++p.инд < таблица.length)
                    p.ptr = таблица[p.инд];
                else
                    p.ptr = пусто;
            }
            return p;
        }

        /**
         * Возвращает позицию, которая идёт перед p.
         */
        позиция предш()
        {
            позиция p = *this;
            auto таблица = владелец.таблица;
            if(p.ptr !is пусто)
            {
                if(p.ptr is таблица[p.инд])
                    p.ptr = пусто;
                else
                {
                    p.ptr = p.ptr.предш;
                    return p;
                }
            }

            while(p.инд > 0 && p.ptr is пусто)
                p.ptr = таблица[--p.инд];
            if(p.ptr)
                //
                // перейти в конец нового бакета
                //
                p.ptr = p.ptr.предш;
            return p;
        }
    }

    /**
     * Добавить значение в хэш.  Возвращает да, если значение отсутствовало,
     * нет, если обх был обновлён.
     */
    бул добавь(З з)
    {
        if(таблица is пусто)
            перемерьПод(исходнРазмерТаблицы);

        auto h = хэшФункц(з) % таблица.length;
        узел хвост = таблица[h];
        if(хвост is пусто)
        {
            //
            //Пока нет узла, добавить сюда новый
            //
            хвост = таблица[h] = размести(з);
            узел.крепи(хвост, хвост);
            счёт++;
            return да;
        }
        else
        {
            static if(!допускатьДубликаты)
            {
                узел элт = findInBucket(хвост, з, хвост);
                if(элт is пусто)
                {
                    счёт++;
                    хвост.приставь(размести(з));
                    // ни единого элемента, нужно проверить фактор загрузки
                    проверьФакторЗагрузки();
                    return да;
                }
                else
                {
                    //
                    //найден узел, установить значение вместо этого
                    //
                    static if(обновить_ли)
                        обновлФункц(элт.значение, з);
                    return нет;
                }
            }
            else
            {
                //
                // всегда добавлять, даже если узел уже существует.
                //
                счёт++;
                хвост.приставь(размести(з));
                // ни единого элемента, нужно проверить фактор загрузки
                проверьФакторЗагрузки();
                return да;
            }
        }
    }

    /**
     * Изменить размер хэш-таблицы на указанную ёмкость.  Как правило, вызывается только
     * приватно.
     */
    проц перемерьПод(бцел ёмкость)
    {
        if(ёмкость > таблица.length)
        {
            auto новТабл = new узел[ёмкость];

            foreach(голова; таблица)
            {
                if(голова)
                {
                    //
                    // сделать точку последн узела = пусто, чтобы отметить конец
                    //бакета
                    //
                    узел.крепи(голова.предш, пусто);
                    for(узел тек = голова, следщ = голова.следщ; тек !is пусто;
                            тек = следщ)
                    {
                        следщ = тек.следщ;
                        auto h = хэшФункц(тек.значение) % новТабл.length;
                        узел новГолова = новТабл[h];
                        if(новГолова is пусто)
                        {
                            новТабл[h] = тек;
                            узел.крепи(тек, тек);
                        }
                        else
                            новГолова.приставь(тек);
                    }
                }
            }
            delete таблица;
            таблица = новТабл;
        }
    }

    /**
     *Проверить, в порядке ли диктуемое фактором загрузки перемерьПод.
     */
    проц проверьФакторЗагрузки()
    {
        if(таблица !is пусто)
        {
            плав fc = cast(плав) счёт;
            плав ft = таблица.length;

            if(fc / ft > факторЗагрузки)
                перемерьПод(2 * cast(бцел)(fc / факторЗагрузки) + 1);
        }
    }

    /**
     * Возвращает позицию, которая указывает на первый элемент в хэше.
     */
    позиция начало()
    {
        if(счёт == 0)
            return конец;
        позиция рез;
        рез.ptr = пусто;
        рез.владелец = this;
        рез.инд = -1;
        //
        // находит первый валидный узел
        //
        return рез.следщ;
    }

    /**
     * Возвращает позицию, которая указывает после последн элемента в хэше.
     */
    позиция конец()
    {
        позиция рез;
        рез.инд = таблица.length;
        рез.владелец = this;
        return рез;
    }

    // приватная функция, используется для реализации общих частей
    private узел findInBucket(узел бакет, З з, узел начатьС)
    in
    {
        assert(bucket !is пусто);
    }
    body
    {
        if(начатьС.значение == з)
            return начатьС;
        узел n;
        for(n = начатьС.следщ; n !is бакет && n.значение != з; n = n.следщ)
        {
        }
        return (n is бакет ? пусто : n);
    }

    /**
     * Find the первый экземпляр a значение
     */
    позиция найди(З з)
    {
        if(счёт == 0)
            return конец;
        auto h = хэшФункц(з) % таблица.length;
        // если бакет пуст, или не содержит з, возвратить конец
        узел укз;
        if(таблица[h] is пусто || (укз = findInBucket(таблица[h], з, таблица[h])) is пусто)
            return конец;
        позиция p;
        p.владелец = this;
        p.инд = h;
        p.ptr = укз;
        return p;
    }

    /**
     * Удалить данную позицию из хэша.
     */
    позиция удали(позиция поз)
    {
        позиция возврзнач = поз.следщ;
        if(поз.ptr is таблица[поз.инд])
        {
            if(поз.ptr.следщ is поз.ptr)
                таблица[поз.инд] = пусто;
            else
                таблица[поз.инд] = поз.ptr.следщ;
        }
        поз.ptr.открепи;
        static if(разместитель.нужноСвоб)
            разм.освободи(поз.ptr);
        счёт--;
        return возврзнач;
    }

    /**
     * Удалить все значения из хэша
     */
    проц очисти()
    {
        static if(разместитель.нужноСвоб)
            разм.освободиВсе();
        delete таблица;
        таблица = пусто;
        счёт = 0;
    }

    /**
     *оставить только элементы, которые в поднабор
     *
     * возвращает число удалённых элементов
     */
    бцел накладка(Обходчик!(З) поднабор)
    {
        if(счёт == 0)
            return 0;
        //
        // стартует удаление всех узлов, затем фильтрует те, которые
        //в наборе.
        //
        бцел рез = счёт;
        auto врм = new узел[таблица.length];

        foreach(ref з; поднабор)
        {
            позиция p = найди(з);
            if(p.инд != таблица.length)
            {
                //
                //Найти узел в текущей таблице, добавить обх в новую
                // таблицу.
                //
                узел голова = врм[p.инд];

                //
                //нужно обновить указатель на таблицу, если это головной узел в этой ячейке
                //
                if(p.ptr is таблица[p.инд])
                {
                    if(p.ptr.следщ is p.ptr)
                        таблица[p.инд] = пусто;
                    else
                        таблица[p.инд] = p.ptr.следщ;
                }

                if(голова is пусто)
                {
                    врм[p.инд] = p.ptr.открепи;
                    узел.крепи(p.ptr, p.ptr);
                }
                else
                    голова.приставь(p.ptr.открепи);
                рез--;
            }
        }

        static if(разместитель.нужноСвоб)
        {
            //
            //теперь нужно освободить все неиспользуемые узлы
            //
            foreach(голова; таблица)
            {
                if(голова !is пусто)
                {
                    //
                    //так как нужно освободить голову, пометим конец списка
                    // указателем пусто
                    //
                    узел.крепи(голова.предш, пусто);
                    while(голова !is пусто)
                    {
                        auto newhead = голова.следщ;
                        разм.освободи(голова);
                        голова = newhead;
                    }
                }
            }
        }
        таблица = врм;
        счёт -= рез;
        return рез;
    }

    static if(допускатьДубликаты)
    {
        // приватная функция для выполнения грязной работы считайВсе и удалиВсе
        private бцел _applyAll(З з, бул удали)
        {
            позиция p = найди(з);
            бцел рез = 0;
            if(p.инд != таблица.length)
            {
                auto бакет = таблица[p.инд];
                do
                {
                    if(p.ptr.значение == з)
                    {
                        рез++;
                        if(удали)
                        {
                            auto исх = p.ptr;
                            p.ptr = p.ptr.следщ;
                            исх.открепи();
                            static if(разместитель.нужноСвоб)
                            {
                                разм.освободи(исх);
                            }
                            continue;
                        }
                    }

                    p.ptr = p.ptr.следщ;
                }
                while(p.ptr !is бакет)
            }
            return рез;
        }

        /**
         * посчитать число раз, которое данное значение пояляется в Хэше
         */
        бцел считайВсе(З з)
        {
            return _applyAll(з, нет);
        }

        /**
         * Удалить все экземпляры  з, которые есть в хэше
         */
        бцел удалиВсе(З з)
        {
            return _applyAll(з, да);
        }

        /**
         * Найти данное значение в хэше, начиная с указанной позиции.
         *Если позиция после последн экземпляр з (что может быть
         * определено, если бакет позиции после бакета, в который з
         * должно отправиться).
         */
        позиция найди(З з, позиция начатьС)
        {
            if(счёт == 0)
                return конец;
            auto h = хэшФункц(з) % таблица.length;
            if(начатьС.инд < h)
            {
                // если бакет пуст, return конец
                if(таблица[h] is пусто)
                    return конец;

                // старт от бакета, в котором значение должно быть
                начатьС.инд = h;
                начатьС.ptr = таблица[h];
            }
            else if(начатьС.инд > h)
                // после бакета, return конец
                return конец;

            if((начатьС.ptr = findInBucket(таблица[h], з, начатьС.ptr)) !is
                    пусто)
                return начатьС;
            return конец;
        }
    }

    /**
     * Копировать все элементы из хэша в цель.
     */
    проц копируйВ(ref Хэш цель)
    {
        //
        // копировать все локальные значения
        //
        цель = *this;

        //
        // reset разместитель
        //
        цель.разм = цель.разм.init;

        //
        // переразместить все узлы в таблице
        //
        цель.таблица = new узел[таблица.length];
        foreach(i, n; таблица)
        {
            if(n !is пусто)
                цель.таблица[i] = n.dup(&цель.размести);
        }
    }

    узел размести()
    {
        return разм.размести();
    }

    узел размести(З з)
    {
        auto рез = размести();
        рез.значение = з;
        return рез;
    }

    /**
     * Выполнить любую установку, необходимую (или никакой для реализ этого хэша)
     */
    проц установка()
    {
    }
}

/**
 * используется для определения Хэш, который не обновляется
 */
template ХэшБезОбновлений(З, alias хэшФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель)
{
    //заметьте, что второй хэшФункц не используется, так как обновлять_ли = нет
    alias Хэш!(З, хэшФункц, хэшФункц, факторЗагрузки, исходнРазмерТаблицы, Разместитель, нет, нет) ХэшБезОбновлений;
}

/**
 * используется для определения Хэш, который принимает дубликаты
 */
template ХэшДуб(З, alias хэшФункц, плав факторЗагрузки=ДефолтыХэш.факторЗагрузки, бцел исходнРазмерТаблицы=ДефолтыХэш.размерТаблицы, alias Разместитель=ДефолтныйРазместитель)
{
    //заметьте, что второй хэшФункц не используется, так как обновлять_ли = нет
    alias Хэш!(З, хэшФункц, хэшФункц, факторЗагрузки, исходнРазмерТаблицы, Разместитель, да, нет) ХэшДуб;
}
