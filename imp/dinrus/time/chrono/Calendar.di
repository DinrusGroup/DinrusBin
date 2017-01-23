module time.chrono.Calendar;

public  import time.Time;



public abstract class Календарь
{
        /**
        * Indicates the текущ эра of the Календарь.
        */
        package enum {ТЕКУЩАЯ_ЭРА = 0};

        // Corresponds в_ Win32 Календарь IDs
        package enum 
        {
                ГРЕГОРИАНСКИЙ = 1,
                ГРЕГОРИАНСКИЙ_США = 2,
                ЯПОНСКИЙ = 3,
                ТАЙВАНЬСКИЙ = 4,
                КОРЕЙСКИЙ = 5,
                ХИДЖРИ = 6,
                ТАИ = 7,
                ЕВРЕЙСКИЙ = 8,
                ГРЕГОРИАН_СВ_ФРАНЦ = 9,
                ГРЕГОРИАН_АРАБ = 10,
                ГРЕГОРИАН_ТРАНСЛИТ_АНГЛ = 11,
                ГРЕГОРИАН_ТРАНСЛИТ_ФРАНЦ = 12
        }

        package enum ПравилоНедели 
        {
                ПервыйДень,         /// Indicates that the первый week of the год is the первый week containing the первый день of the год.
                ПерваяПолнаяНеделя,    /// Indicates that the первый week of the год is the первый full week following the первый день of the год.
                ПерваяНеделяС4Днями  /// Indicates that the первый week of the год is the первый week containing at least four дни.
        }

        package enum ЧастьДаты
        {
                Год,
                Месяц,
                День,
                ДеньГода
        }

        public enum ДеньНедели 
        {
                Воскресенье,    /// Indicates _Sunday.
                Понедельник,    /// Indicates _Monday.
                Вторник,   /// Indicates _Tuesday.
                Среда, /// Indicates _Wednesday.
                Четверг,  /// Indicates _Thursday.
                Пятница,    /// Indicates _Frопрay.
                Суббота   /// Indicates _Saturday.
        }


        /**
         * Get the components of a Время structure using the rules of the
         * Календарь.  This is useful if you want ещё than one of the given
         * components.  Note that this doesn't укз the время of день, as that
         * is calculated directly из_ the Время struct.
         *
         * The default implemenation is в_ вызов все the другой accessors
         * directly, a производный class may override if it имеется a ещё efficient
         * метод.
         */
        Дата вДату (Время время);

        /**
         * Get the components of a Время structure using the rules of the
         * Календарь.  This is useful if you want ещё than one of the given
         * components.  Note that this doesn't укз the время of день, as that
         * is calculated directly из_ the Время struct.
         *
         * The default implemenation is в_ вызов все the другой accessors
         * directly, a производный class may override if it имеется a ещё efficient
         * метод.
         */
        проц разбей (Время время, ref бцел год, ref бцел месяц, ref бцел день, ref бцел деньгода, ref бцел деньнед, ref бцел эра);

        /**
        * Returns a Время значение установи в_ the specified дата и время in the текущ эра.
        * Параметры:
        *   год = An целое representing the _year.
        *   месяц = An целое representing the _month.
        *   день = An целое representing the _day.
        *   час = An целое representing the _hour.
        *   минута = An целое representing the _minute.
        *   секунда = An целое representing the _second.
        *   миллисекунда = An целое representing the _millisecond.
        * Возвращает: The Время установи в_ the specified дата и время.
        */
        Время воВремя (бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел секунда, бцел миллисекунда=0) ;

        /**
        * Returns a Время значение for the given Дата, in the текущ эра 
        * Параметры:
        *   дата = a representation of the Дата
        * Возвращает: The Время установи в_ the specified дата.
        */
        Время воВремя (Дата d) ;

        /**
        * Returns a Время значение for the given ДатаВремя, in the текущ эра 
        * Параметры:
        *   dt = a representation of the дата и время
        * Возвращает: The Время установи в_ the specified дата и время.
        */
        Время воВремя (ДатаВремя dt) ;

        /**
        * Returns a Время значение for the given Дата и ВремяДня, in the текущ эра 
        * Параметры:
        *   d = a representation of the дата 
        *   t = a representation of the день время 
        * Возвращает: The Время установи в_ the specified дата и время.
        */
        Время воВремя (Дата d, ВремяДня t) ;

        /**
        * When overrопрden, returns a Время значение установи в_ the specified дата и время in the specified _era.
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
        abstract Время воВремя (бцел год, бцел месяц, бцел день, бцел час, бцел минута, бцел секунда, бцел миллисекунда, бцел эра);

        /**
        * When overrопрden, returns the день of the week in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: A ДеньНедели значение representing the день of the week of время.
        */
        abstract ДеньНедели дайДеньНедели (Время время);

        /**
        * When overrопрden, returns the день of the месяц in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the день of the месяц of время.
        */
        abstract бцел дайДеньМесяца (Время время);

        /**
        * When overrопрden, returns the день of the год in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the день of the год of время.
        */
        abstract бцел дайДеньГода (Время время);

        /**
        * When overrопрden, returns the месяц in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the месяц in время.
        */
        abstract бцел дайМесяц (Время время);

        /**
        * When overrопрden, returns the год in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the год in время.
        */
        abstract бцел дайГод (Время время);

        /**
        * When overrопрden, returns the эра in the specified Время.
        * Параметры: время = A Время значение.
        * Возвращает: An целое representing the ear in время.
        */
        abstract бцел дайЭру (Время время);

        /**
        * Returns the число of дни in the specified _year и _month of the текущ эра.
        * Параметры:
        *   год = An целое representing the _year.
        *   месяц = An целое representing the _month.
        * Возвращает: The число of дни in the specified _year и _month of the текущ эра.
        */
        бцел дайДниМесяца (бцел год, бцел месяц) ;

        /**
        * When overrопрden, returns the число of дни in the specified _year и _month of the specified _era.
        * Параметры:
        *   год = An целое representing the _year.
        *   месяц = An целое representing the _month.
        *   эра = An целое representing the _era.
        * Возвращает: The число of дни in the specified _year и _month of the specified _era.
        */
        abstract бцел дайДниМесяца (бцел год, бцел месяц, бцел эра);

        /**
        * Returns the число of дни in the specified _year of the текущ эра.
        * Параметры: год = An целое representing the _year.
        * Возвращает: The число of дни in the specified _year in the текущ эра.
        */
        бцел дайДниГода (бцел год) ;

        /**
        * When overrопрden, returns the число of дни in the specified _year of the specified _era.
        * Параметры:
        *   год = An целое representing the _year.
        *   эра = An целое representing the _era.
        * Возвращает: The число of дни in the specified _year in the specified _era.
        */
        abstract бцел дайДниГода (бцел год, бцел эра);

        /**
        * Returns the число of месяцы in the specified _year of the текущ эра.
        * Параметры: год = An целое representing the _year.
        * Возвращает: The число of месяцы in the specified _year in the текущ эра.
        */
        бцел дайМесяцыГода (бцел год) ;

        /**
        * When overrопрden, returns the число of месяцы in the specified _year of the specified _era.
        * Параметры:
        *   год = An целое representing the _year.
        *   эра = An целое representing the _era.
        * Возвращает: The число of месяцы in the specified _year in the specified _era.
        */
        abstract бцел дайМесяцыГода (бцел год, бцел эра);

        /**
        * Returns the week of the год that включает the specified Время.
        * Параметры:
        *   время = A Время значение.
        *   правило = A ПравилоНедели значение defining a Календарь week.
        *   первыйДеньНед = A ДеньНедели значение representing the первый день of the week.
        * Возвращает: An целое representing the week of the год that включает the дата in время.
        */
        бцел дайНеделюГода (Время время, ПравилоНедели правило, ДеньНедели первыйДеньНед) ;

        /**
        * Indicates whether the specified _year in the текущ эра is a leap _year.
        * Параметры: год = An целое representing the _year.
        * Возвращает: да is the specified _year is a leap _year; otherwise, нет.
        */
        бул високосен_ли(бцел год) ;

        /**
        * When overrопрden, indicates whether the specified _year in the specified _era is a leap _year.
        * Параметры: год = An целое representing the _year.
        * Параметры: эра = An целое representing the _era.
        * Возвращает: да is the specified _year is a leap _year; otherwise, нет.
        */
        abstract бул високосен_ли(бцел год, бцел эра);

        /**
        * $(I Property.) When overrопрden, retrieves the список of эры in the текущ Календарь.
        * Возвращает: An целое Массив representing the эры in the текущ Календарь.
        */
        abstract бцел[] эры();

        /**
        * $(I Property.) Retrieves the определитель associated with the текущ Календарь.
        * Возвращает: An целое representing the определитель of the текущ Календарь.
        */
        бцел опр() ;

        /**
         * Returns a new Время with the specified число of месяцы добавьed.  If
         * the месяцы are негатив, the месяцы are subtracted.
         *
         * If the мишень месяц does not support the день component of the ввод
         * время, then an ошибка will be thrown, unless truncateDay is установи в_
         * да.  If truncateDay is установи в_ да, then the день is reduced в_
         * the maximum день of that месяц.
         *
         * For example, добавим one месяц в_ 1/31/2000 with truncateDay установи в_
         * да results in 2/28/2000.
         *
         * The default implementation uses information provопрed by the
         * Календарь в_ calculate the correct время в_ добавь.  Derived classes may
         * override if there is a ещё optimized метод.
         *
         * Note that the генерный метод does not возьми преобр_в account crossing
         * эра boundaries.  Derived classes may support this.
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
        Время добавьМесяцы(Время t, цел члоМес, бул truncateDay = нет);

        /**
         * Добавь the specified число of годы в_ the given Время.
         *
         * The генерный algorithm uses information provопрed by the abstract
         * methods.  Derived classes may re-implement this in order в_
         * оптимизируй the algorithm
         *
         * Note that the генерный algorithm does not возьми преобр_в account crossing
         * эра boundaries.  Derived classes may support this.
         *
         * Параметры: t = A время в_ добавь the годы в_
         * Параметры: члоЛет = The число of годы в_ добавь.  This can be негатив.
         *
         * Возвращает: A Время that represents the provопрed время with the число
         * of годы добавьed.
         */
        Время добавьГоды(Время t, цел члоЛет);

        package static дол дайТикиВремени (бцел час, бцел минута, бцел секунда) ;
}
