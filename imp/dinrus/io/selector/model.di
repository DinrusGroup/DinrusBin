/*******************************************************************************
  copyright:   Copyright (c) 2006 Juan Jose Comellas. все rights reserved
  license:     BSD стиль: $(LICENSE)
  author:      Juan Jose Comellas <juanjo@comellas.com.ar>
*******************************************************************************/

module io.selector.model;

public import time.Time;

public import io.model;

/**
 * События, используемые для регистрации Провода к селектору и возвращаемые
 * в КлючеВыбора после вызова ИСелектор.выбери().
 */
enum Событие: бцел
{
    Нет            = 0,        // No событие
    // IMPORTANT: Do not change the значения of the following symbols. They were
    //            установи in this way в_ карта the значения returned by the POSIX poll()
    //            system вызов.
    Чит            = (1 << 0), // POLLIN
    СрочноеЧтение      = (1 << 1), // POLLPRI
    Зап           = (1 << 2), // POLLOUT
    // The following события should not be использован when registering a провод в_ a
    // selector. They are only использован when returning события в_ the пользователь.
    Ошибка           = (1 << 3), // POLLERR
    Зависание          = (1 << 4), // POLLHUP
    НеверныйУк   = (1 << 5)  // POLLNVAL
}


/**
 * The КлючВыбора struct holds the information concerning the conduits и
 * their association в_ a selector. Each ключ keeps a reference в_ a registered
 * провод и the события that are в_ be tracked for it. The 'события' member
 * of the ключ can возьми two meanings, depending on where it's использован. If использован
 * with the регистрируй() метод of the selector it represents the события we want
 * в_ track; if использован внутри a foreach cycle on an ИНаборВыделений it represents
 * the события that have been detected for a провод.
 *
 * The КлючВыбора can also hold an optional объект via the 'атачмент'
 * member. This member is very convenient в_ keep application-specific данные
 * that will be needed when the tracked события are triggered.
 *
 * See $(LINK $(CODEURL)io.selector.ИСелектор),
 * $(LINK $(CODEURL)io.selector.ИНаборВыделений)
 */
struct КлючВыбора
{
    /**
     * The провод referred в_ by the КлючВыбора.
     */
    ИВыбираемый провод;

    /**
     * The registered (or selected) события as a bit маска of different Событие
     * значения.
     */
    Событие события;

    /**
     * The attached Объект referred в_ by the КлючВыбора.
     */
    Объект атачмент;

    /**
     * Check if a Чит событие имеется been associated в_ this КлючВыбора.
     */
    public бул читаем_ли()
    {
        return ((события & Событие.Чит) != 0);
    }

    /**
     * Check if an СрочноеЧтение событие имеется been associated в_ this КлючВыбора.
     */
    public бул срочноеЧтен_ли()
    {
        return ((события & Событие.СрочноеЧтение) != 0);
    }

    /**
     * Check if a Зап событие имеется been associated в_ this КлючВыбора.
     */
    public бул записываем_ли()
    {
        return ((события & Событие.Зап) != 0);
    }

    /**
     * Check if an Ошибка событие имеется been associated в_ this КлючВыбора.
     */
    public бул ошибка_ли()
    {
        return ((события & Событие.Ошибка) != 0);
    }

    /**
     * Check if a Зависание событие имеется been associated в_ this КлючВыбора.
     */
    public бул зависание_ли()
    {
        return ((события & Событие.Зависание) != 0);
    }

    /**
     * Check if an НеверныйУк событие имеется been associated в_ this КлючВыбора.
     */
    public бул невернУк_ли()
    {
        return ((события & Событие.НеверныйУк) != 0);
    }
}


/**
 * Контейнер that holds the КлючВыбора's for все the conduits that have
 * triggered события during a previous invocation в_ ИСелектор.выбери().
 * Instances of this container are normally returned из_ calls в_
 * ИСелектор.наборВыд().
 */
interface ИНаборВыделений
{
    /**
     * Returns the число of КлючВыбора's in the установи.
     */
    public abstract бцел длина();

    /**
     * Operator в_ iterate over a установи via a foreach блок.  Note that any
     * modifications в_ the КлючВыбора will be ignored.
     */
    public abstract цел opApply(цел delegate(ref КлючВыбора) дг);
}


/**
 * A selector is a multИПlexor for I/O события associated в_ a Провод.
 * все selectors must implement this interface.
 *
 * A selector needs в_ be инициализован by calling the открой() метод в_ пароль
 * it the начальное amount of conduits that it will укз и the maximum
 * amount of события that will be returned per вызов в_ выбери(). In Всё cases,
 * these значения are only hints и may not even be использован by the specific
 * ИСелектор implementation you choose в_ use, so you cannot сделай any
 * assumptions regarding что results из_ the вызов в_ выбери() (i.e. you
 * may принять ещё or less события per вызов в_ выбери() than что was passed
 * in the 'maxEvents' аргумент. The amount of conduits that the selector can
 * manage will be incremented dynamically if necessary.
 *
 * To добавь or modify провод registrations in the selector, use the регистрируй()
 * метод.  To удали провод registrations из_ the selector, use the
 * отмениРег() метод.
 *
 * To жди for события из_ the conduits you need в_ вызов any of the выбери()
 * methods. The selector cannot be изменён из_ другой нить while
 * блокируется on a вызов в_ these methods.
 *
 * Once the selector is no longer использован you must вызов the закрой() метод so
 * that the selector can free any resources it may have allocated in the вызов
 * в_ открой().
 *
 * Examples:
 * ---
 * import io.selector.model;
 * import io.СокетПровод;
 * import io.Stdout;
 *
 * ИСелектор selector;
 * СокетПровод conduit1;
 * СокетПровод conduit2;
 * MyClass object1;
 * MyClass object2;
 * цел eventCount;
 *
 * // Initialize the selector assuming that it will deal with 2 conduits и
 * // will принять 2 события per invocation в_ the выбери() метод.
 * selector.открой(2, 2);
 *
 * selector.регистрируй(провод, Событие.Чит, object1);
 * selector.регистрируй(провод, Событие.Зап, object2);
 *
 * eventCount = selector.выбери();
 *
 * if (eventCount > 0)
 * {
 *     сим[16] буфер;
 *     цел счёт;
 *
 *     foreach (КлючВыбора ключ, selector.наборВыд())
 *     {
 *         if (ключ.читаем_ли())
 *         {
 *             счёт = (cast(СокетПровод) ключ.провод).читай(буфер);
 *             if (счёт != ИПровод.Кф)
 *             {
 *                 Стдвыв.форматируй("Приёмd '{0}' из_ peer\n", буфер[0..счёт]);
 *                 selector.регистрируй(ключ.провод, Событие.Зап, ключ.атачмент);
 *             }
 *             else
 *             {
 *                 selector.отмениРег(ключ.провод);
 *                 ключ.провод.закрой();
 *             }
 *         }
 *
 *         if (ключ.записываем_ли())
 *         {
 *             счёт = (cast(СокетПровод) ключ.провод).пиши("MESSAGE");
 *             if (счёт != ИПровод.Кф)
 *             {
 *                 Стдвыв.выведи("Sent 'MESSAGE' в_ peer\n");
 *                 selector.регистрируй(ключ.провод, Событие.Чит, ключ.атачмент);
 *             }
 *             else
 *             {
 *                 selector.отмениРег(ключ.провод);
 *                 ключ.провод.закрой();
 *             }
 *         }
 *
 *         if (ключ.ошибка_ли() || ключ.зависание_ли() || ключ.невернУк_ли())
 *         {
 *             selector.отмениРег(ключ.провод);
 *             ключ.провод.закрой();
 *         }
 *     }
 * }
 *
 * selector.закрой();
 * ---
 */
interface ИСелектор
{
    /**
     * Initialize the selector.
     *
     * Параметры:
     * размер         = значение that provопрes a hint for the maximum amount of
     *                conduits that will be registered
     * maxEvents    = значение that provопрes a hint for the maximum amount of
     *                провод события that will be returned in the выделение
     *                установи per вызов в_ выбери.
     */
    public abstract проц открой(бцел размер, бцел maxEvents);

    /**
     * Free any operating system resources that may have been allocated in the
     * вызов в_ открой().
     *
     * Remarks:
     * Not все of the selectors need в_ free resources другой than allocated
     * память, but those that do will normally also добавь a вызов в_ закрой() in
     * their destructors.
     */
    public abstract проц закрой();

    /**
     * Associate a провод в_ the selector и track specific I/O события.
     * If the провод is already часть of the selector, modify the события or
     * atachment.
     *
     * Параметры:
     * провод      = провод that will be associated в_ the selector;
     *                must be a действителен провод (i.e. not пусто и открой).
     * события       = bit маска of Событие значения that represent the события that
     *                will be tracked for the провод.
     * атачмент   = optional объект with application-specific данные that will
     *                be available when an событие is triggered for the провод
     *
     * Examples:
     * ---
     * ИСелектор selector;
     * СокетПровод провод;
     * MyClass объект;
     *
     * selector.регистрируй(провод, Событие.Чит | Событие.Зап, объект);
     * ---
     */
    public abstract проц регистрируй(ИВыбираемый провод, Событие события,
                                  Объект атачмент = пусто);


    /**
     * Deprecated, use регистрируй instead
     */
    deprecated public abstract проц повториРег(ИВыбираемый провод, Событие
            события, Объект атачмент = пусто);

    /**
     * Удали a провод из_ the selector.
     *
     * Параметры:
     * провод      = провод that had been previously associated в_ the
     *                selector; it can be пусто.
     *
     * Remarks:
     * Unregistering a пусто провод is allowed и no исключение is thrown
     * if this happens.
     */
    public abstract проц отмениРег(ИВыбираемый провод);


    /**
     * Wait indefinitely for I/O события из_ the registered conduits.
     *
     * Возвращает:
     * The amount of conduits that have Приёмd события; 0 if no conduits
     * have Приёмd события внутри the specified таймаут и -1 if there
     * was an ошибка.
     */
    public abstract цел выбери();

    /**
     * Wait for I/O события из_ the registered conduits for a specified
     * amount of время.
     *
     * Параметры:
     * таймаут  = ИнтервалВремени with the maximum amount of время that the
     *            selector will жди for события из_ the conduits; the
     *            amount of время is relative в_ the текущ system время
     *            (i.e. just the число of milliseconds that the selector
     *            имеется в_ жди for the события).
     *
     * Возвращает:
     * The amount of conduits that have Приёмd события; 0 if no conduits
     * have Приёмd события внутри the specified таймаут.
     */
    public abstract цел выбери(ИнтервалВремени таймаут);

    /**
     * Wait for I/O события из_ the registered conduits for a specified
     * amount of время.
     *
     * Note: This representation of таймаут is not always accurate, so it is
     * possible that the function will return with a таймаут before the
     * specified период.  For ещё accuracy, use the ИнтервалВремени version.
     *
     * Note: Implementers should define this метод as:
     * -------
     * выбери(ИнтервалВремени.интервал(таймаут));
     * -------
     *
     * Параметры:
     * таймаут  = the maximum amount of время in сек that the
     *            selector will жди for события из_ the conduits; the
     *            amount of время is relative в_ the текущ system время
     *            (i.e. just the число of milliseconds that the selector
     *            имеется в_ жди for the события).
     *
     * Возвращает:
     * The amount of conduits that have Приёмd события; 0 if no conduits
     * have Приёмd события внутри the specified таймаут.
     */
    public abstract цел выбери(дво таймаут);

    /**
     * Return the выделение установи resulting из_ the вызов в_ any of the выбери()
     * methods.
     *
     * Remarks:
     * If the вызов в_ выбери() was unsuccessful or it dопр not return any
     * события, the returned значение will be пусто.
     */
    public abstract ИНаборВыделений наборВыд();

    /**
     * Return the выделение ключ resulting из_ the registration of a провод
     * в_ the selector.
     *
     * Remarks:
     * If the провод is not registered в_ the selector the returned
     * значение will КлючВыбора.init. No исключение will be thrown by this
     * метод.
     */
    public abstract КлючВыбора ключ(ИВыбираемый провод);

    /**
     * Iterate through the currently registered выделение ключи.  Note that you
     * should not erase or добавь any items из_ the selector while iterating,
     * although you can регистрируй existing conduits again.
     */
    public abstract цел opApply(цел delegate(ref КлючВыбора sk) дг);
}
