/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Mопр 2005: Initial release
                        Apr 2007: reshaped                        

        author:         John Chapman, Kris, schveiguy

******************************************************************************/

module time.chrono.Gregorian;

private import time.chrono.Calendar;

private import exception;

/**
 * $(ANCHOR _Gregorian)
 * Represents the Грегориан Календарь.
 *
 * Note that this is the Proleptic Грегориан Календарь.  Most Календарьs assume
 * that dates before 9/14/1752 were Julian Dates.  Julian differs из_
 * Грегориан in that leap годы occur every 4 годы, even on 100 год
 * increments.  The Proleptic Грегориан Календарь applies the Грегориан leap
 * год rules в_ dates before 9/14/1752, making the calculation of dates much
 * easier.
 */
class Грегориан : Календарь 
{
        // import baseclass воВремя()
        alias Календарь.воВремя воВремя;

        /// static shared экземпляр
        public static Грегориан генерный;

        enum Тип 
        {
                Локализованный = 1,               /// Refers в_ the localized version of the Грегориан Календарь.
                АнглСША = 2,               /// Refers в_ the US English version of the Грегориан Календарь.
                СреднеВостФранц = 9,        /// Refers в_ the Mопрdle East French version of the Грегориан Календарь.
                Арабский = 10,                 /// Refers в_ the _Arabic version of the Грегориан Календарь.
                ТранслитерАнгл = 11,  /// Refers в_ the transliterated English version of the Грегориан Календарь.
                ТранслитерФранц = 12    /// Refers в_ the transliterated French version of the Грегориан Календарь.
        }

        private Тип type_;                 

        /**
        * Represents the текущ эра.
        */
        enum {AD_ERA = 1, BC_ERA = 2, MAX_YEAR = 9999};

        private static final бцел[] ДниВМесОбщ = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365];

        private static final бцел[] ДниВМесВисокос   = [0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366];

        /**
        * создай a генерный экземпляр of this Календарь
        */
        static this()
        {       
                генерный = new Грегориан;
        }

        /**
        * Initializes an экземпляр of the Грегориан class using the specified GregorianTypes значение. If no значение is 
        * specified, the default is Грегориан.Types.Локализованный.
        */
        this (Тип тип = Тип.Локализованный) ;

        /**
        * Overrопрden. Returns a Время значение установи в_ the specified дата и время in the specified _era.
        * Параметры:
        *   год = An целое representing the _year.
        *   месяц = An целое representing the _month.
        *   день = An целое representing the _day.
        *   час = An целое representing the _hour.
        *   минута = An целое representing the _minute.
        *   секунда = An целое representing the _second.
        *   миллисекунда = An целое representing the _millisecond.
        *   эра = An целое representing the _era.
        * Возвращает: A Время установи в_ the specified дата и время.
        */
        override Время воВремя (бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел секунда, бцел миллисекунда, бцел эра);

        /**
        * Overrопрden. Returns the день of the week in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: A ДеньНедели значение representing the день of the week of время.
        */
        override ДеньНедели дайДеньНедели(Время время) ;

        /**
        * Overrопрden. Returns the день of the месяц in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the день of the месяц of время.
        */
        override бцел дайДеньМесяца(Время время) ;

        /**
        * Overrопрden. Returns the день of the год in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the день of the год of время.
        */
        override бцел дайДеньГода(Время время) ;

        /**
        * Overrопрden. Returns the месяц in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the месяц in время.
        */
        override бцел дайМесяц(Время время) ;

        /**
        * Overrопрden. Returns the год in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the год in время.
        */
        override бцел дайГод(Время время) ;

        /**
        * Overrопрden. Returns the эра in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the эра in время.
        */
        override бцел дайЭру(Время время) ;

        /**
        * Overrопрden. Returns the число of дни in the specified _year и _month of the specified _era.
        * Параметры:
        *   год = An целое representing the _year.
        *   месяц = An целое representing the _month.
        *   эра = An целое representing the _era.
        * Возвращает: The число of дни in the specified _year и _month of the specified _era.
        */
        override бцел дайДниМесяца(бцел год, бцел месяц, бцел эра) ;

        /**
        * Overrопрden. Returns the число of дни in the specified _year of the specified _era.
        * Параметры:
        *   год = An целое representing the _year.
        *   эра = An целое representing the _era.
        * Возвращает: The число of дни in the specified _year in the specified _era.
        */
        override бцел дайДниГода(бцел год, бцел эра) ;

        /**
        * Overrопрden. Returns the число of месяцы in the specified _year of the specified _era.
        * Параметры:
        *   год = An целое representing the _year.
        *   эра = An целое representing the _era.
        * Возвращает: The число of месяцы in the specified _year in the specified _era.
        */
        override бцел дайМесяцыГода(бцел год, бцел эра) ;

        /**
        * Overrопрden. Indicates whether the specified _year in the specified _era is a leap _year.
        * Параметры: год = An целое representing the _year.
        * Параметры: эра = An целое representing the _era.
        * Возвращает: да is the specified _year is a leap _year; otherwise, нет.
        */
        override бул високосен_ли(бцел год, бцел эра) ;

        /**
        * $(I Property.) Retrieves the GregorianTypes значение indicating the language version of the Грегориан.
        * Возвращает: The Грегориан.Тип значение indicating the language version of the Грегориан.
        */
        Тип типКалендаря() ;

        /**
        * $(I Property.) Overrопрden. Retrieves the список of эры in the текущ Календарь.
        * Возвращает: An целое Массив representing the эры in the текущ Календарь.
        */
        override бцел[] эры() ;

        /**
        * $(I Property.) Overrопрden. Retrieves the определитель associated with the текущ Календарь.
        * Возвращает: An целое representing the определитель of the текущ Календарь.
        */
        override бцел опр() ;

        /**
         * Overrопрden.  Get the components of a Время structure using the rules
         * of the Календарь.  This is useful if you want ещё than one of the
         * given components.  Note that this doesn't укз the время of день,
         * as that is calculated directly из_ the Время struct.
         */
        override проц разбей(Время время, ref бцел год, ref бцел месяц, ref бцел день, ref бцел деньгода, ref бцел деньнед, ref бцел эра);

        /**
         * Overrопрden. Returns a new Время with the specified число of месяцы
         * добавьed.  If the месяцы are негатив, the месяцы are subtracted.
         *
         * If the мишень месяц does not support the день component of the ввод
         * время, then an ошибка will be thrown, unless truncateDay is установи в_
         * да.  If truncateDay is установи в_ да, then the день is reduced в_
         * the maximum день of that месяц.
         *
         * For example, добавим one месяц в_ 1/31/2000 with truncateDay установи в_
         * да results in 2/28/2000.
         *
         * Параметры: t = A время в_ добавь the месяцы в_
         * Параметры: члоМес = The число of месяцы в_ добавь.  This can be
         * негатив.
         * Параметры: truncateDay = Round the день down в_ the maximum день of the
         * мишень месяц if necessary.
         *
         * Возвращает: A Время that represents the provопрed время with the число
         * of месяцы добавьed.
         */
        override Время добавьМесяцы(Время t, цел члоМес, бул truncateDay=нет);

        /**
         * Overrопрden.  Добавь the specified число of годы в_ the given Время.
         *
         * Note that the Грегориан Календарь takes преобр_в account that BC время
         * is негатив, и supports crossing из_ BC в_ AD.
         *
         * Параметры: t = A время в_ добавь the годы в_
         * Параметры: члоЛет = The число of годы в_ добавь.  This can be негатив.
         *
         * Возвращает: A Время that represents the provопрed время with the число
         * of годы добавьed.
         */
        override Время добавьГоды(Время t, цел члоЛет);

        package static проц разбейДату (дол тики, ref бцел год, ref бцел месяц, ref бцел день, ref бцел dayOfYear, ref бцел эра) ;

        package static бцел откиньЧасть (дол тики, ЧастьДаты часть) ;

        package static дол дайТикиДаты (бцел год, бцел месяц, бцел день, бцел эра) ;

        package static бул статВисокосен_ли(бцел год, бцел эра);
}

debug(Грегориан)
{
        import io.Stdout;

        проц вывод(Время t)
        {
                Дата d = Грегориан.генерный.вДату(t);
                ВремяДня tod = t.время;
                Стдвыв.форматируй("{}/{}/{:d4} {} {}:{:d2}:{:d2}.{:d3} деньнед:{}",
                                d.месяц, d.день, d.год, d.эра == Грегориан.AD_ERA ? "AD" : "BC",
                                tod.часы, tod.минуты, tod.сек, tod.миллисек, d.деньнед).нс;
        }

        проц main()
        {
                Время t = Время(365 * ИнтервалВремени.ТиковВДень);
                вывод(t);
                for(цел i = 0; i < 366 + 365; i++)
                {
                        t -= ИнтервалВремени.изДней(1);
                        вывод(t);
                }
        }
}

debug(UnitTest)
{
        unittest
        {
                //
                // проверь Грегориан дата handles positive время.
                //
                Время t = Время.эпоха + ИнтервалВремени.изДней(365);
                Дата d = Грегориан.генерный.вДату(t);
                assert(d.год == 2);
                assert(d.месяц == 1);
                assert(d.день == 1);
                assert(d.эра == Грегориан.AD_ERA);
                assert(d.деньгода == 1);
                //
                // note that this is in disagreement with the Julian Календарь
                //
                assert(d.деньнед == Грегориан.ДеньНедели.Вторник);

                //
                // проверь that it handles негатив время
                //
                t = Время.эпоха - ИнтервалВремени.изДней(366);
                d = Грегориан.генерный.вДату(t);
                assert(d.год == 1);
                assert(d.месяц == 1);
                assert(d.день == 1);
                assert(d.эра == Грегориан.BC_ERA);
                assert(d.деньгода == 1);
                assert(d.деньнед == Грегориан.ДеньНедели.Суббота);

                //
                // проверь that добавьМесяцы works properly, добавь 15 месяцы в_
                // 2/3/2004, 04:05:06.007008, then вычти 15 месяцы again.
                //
                t = Грегориан.генерный.воВремя(2004, 2, 3, 4, 5, 6, 7) + ИнтервалВремени.изМикросек(8);
                d = Грегориан.генерный.вДату(t);
                assert(d.год == 2004);
                assert(d.месяц == 2);
                assert(d.день == 3);
                assert(d.эра == Грегориан.AD_ERA);
                assert(d.деньгода == 34);
                assert(d.деньнед == Грегориан.ДеньНедели.Вторник);

                auto t2 = Грегориан.генерный.добавьМесяцы(t, 15);
                d = Грегориан.генерный.вДату(t2);
                assert(d.год == 2005);
                assert(d.месяц == 5);
                assert(d.день == 3);
                assert(d.эра == Грегориан.AD_ERA);
                assert(d.деньгода == 123);
                assert(d.деньнед == Грегориан.ДеньНедели.Вторник);

                t2 = Грегориан.генерный.добавьМесяцы(t2, -15);
                d = Грегориан.генерный.вДату(t2);
                assert(d.год == 2004);
                assert(d.месяц == 2);
                assert(d.день == 3);
                assert(d.эра == Грегориан.AD_ERA);
                assert(d.деньгода == 34);
                assert(d.деньнед == Грегориан.ДеньНедели.Вторник);

                assert(t == t2);

                //
                // проверь that illegal аргумент exceptions occur
                //
                try
                {
                        t = Грегориан.генерный.воВремя (0, 1, 1, 0, 0, 0, 0, Грегориан.AD_ERA);
                        assert(нет, "Dопр not throw illegal аргумент исключение");
                }
                catch(Исключение iae)
                {
                }
                try
                {
                        t = Грегориан.генерный.воВремя (1, 0, 1, 0, 0, 0, 0, Грегориан.AD_ERA);
                        assert(нет, "Dопр not throw illegal аргумент исключение");
                }
                catch(ИсклНелегальногоАргумента iae)
                {
                }
                try
                {
                        t = Грегориан.генерный.воВремя (1, 1, 0, 0, 0, 0, 0, Грегориан.BC_ERA);
                        assert(нет, "Dопр not throw illegal аргумент исключение");
                }
                catch(ИсклНелегальногоАргумента iae)
                {
                }

                try
                {
                    t = Грегориан.генерный.воВремя(2000, 1, 31, 0, 0, 0, 0);
                    t = Грегориан.генерный.добавьМесяцы(t, 1);
                    assert(нет, "Dопр not throw illegal аргумент исключение");
                }
                catch(ИсклНелегальногоАргумента iae)
                {
                }

                try
                {
                    t = Грегориан.генерный.воВремя(2000, 1, 31, 0, 0, 0, 0);
                    t = Грегориан.генерный.добавьМесяцы(t, 1, да);
                    assert(Грегориан.генерный.дайДеньМесяца(t) == 29);
                }
                catch(ИсклНелегальногоАргумента iae)
                {
                    assert(нет, "Should not throw illegal аргумент исключение");
                }



        }
}
