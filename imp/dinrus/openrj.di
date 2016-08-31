/**
 * Open-RJ mapping for the D standard library.
 *
 * Authors:
 *	Matthew Wilson
 * References:
 *	$(LINK2 http://www.$(OPENRJ).org/, Open-RJ)
 * Macros:
 *	WIKI=Phobos/StdOpenrj
 *	OPENRJ=openrj
 */

module openrj;

private struct СтрокаПеречня
{
    цел     значение;
    ткст  стр;
};

private template перечень_в_ткст(T)
{
    ткст перечень_в_ткст(СтрокаПеречня[] строки, T t)
    {
        // 'Optimised' search.
        //
        // Since many enums start at 0 and are contiguously ordered, it's quite
        // likely that the значение will equal the индекс. If it does, we can just
        // return the string from that индекс.
        цел индекс   =   cast(цел)(t);

        if( индекс >= 0 &&
            индекс < строки.length &&
            строки[индекс].значение == индекс)
        {
            return строки[индекс].стр;
        }

        // Otherwise, just do a linear search
        foreach(СтрокаПеречня s; строки)
        {
            if(cast(цел)(t) == s.значение)
            {
                return s.стр;
            }
        }

        return "<неизвестно>";
    }
}

private struct Версия
{
    ткст  имя;
    ткст  описание;
    бцел    мажор;
    бцел    минор;
    бцел    ревизия;
    бцел    редакц;
    ulong   времяПостроения;
}

public static Версия   ВЕРСИЯ =
{
        "base.openrj"
    ,   "Record-JAR database reader"
    ,   1
    ,   0
    ,   7
    ,   7
    ,   0
};


/** Flags that moderate the creation of Databases */
public enum ОРДЖ_ФЛАГ
{
    УПОРЯДОЧИТЬ_ПОЛЯ                    =   0x0001,  /// Arranges the поля in alphabetical order
    ИГНОР_ПУСТЫЕ_ЗАПИСИ             =   0x0002,  /// Causes blank записи to be ignored
}

/** General error codes */
public enum ОРДЖК
{
    УСПЕХ                      =   0,          /// Operation was successful
    ДЖАРФАЙЛ_НЕ_ОТКРЫВАЕТСЯ,                        /// The given файл does not exist, or cannot be accessed
    НЕТ_ЗАПИСЕЙ,                                  /// The бд файл contained no записи
    НЕТ_ПАМЯТИ,                               /// The API suffered память exhaustion
    ФАЙЛ_НЕ_ЧИТАЕТСЯ,                               /// A read operation failed
    ОШИБКА_РАЗБОРА,                                 /// Parsing of the бд файл failed due to a syntax error
    НЕВЕРНЫЙ_ИНДЕКС,                               /// An invalid индекс was specified
    НЕОЖИДАННОЕ,                                  /// An unexpected condition was encountered
    ПОВРЕЖДЕНИЕ_КОНТЕНТА,                             /// The бд файл contained invalid content
}

public enum ОРДЖ_ОШИБКА_РАЗБОРА
{
    УСПЕХ                         =   0,       /// Parsing was successful
    РАЗДЕЛИТЕЛЬ_ЗАПИСИ_В_СТРОКЕ,            /// A запись separator was encountered during a content line continuation
    НЕОКОНЧЕННАЯ_СТРОКА,                             /// The last line in the бд was not terminated by a line-feed
    НЕОКОНЧЕННОЕ_ПОЛЕ,                            /// The last поле in the бд файл was not terminated by a запись separator
    НЕОКОНЧЕННАЯ_ЗАПИСЬ,                           /// The last запись in the бд файл was not terminated by a запись separator
}

extern(D):

ткст вТкст(ОРДЖ_ФЛАГ f);
ткст вТкст(ОРДЖК f);
ткст вТкст(ОРДЖ_ОШИБКА_РАЗБОРА f);

 class Поле
{
    this(ткст имя, ткст значение);
    final ткст  имя();
    final ткст  значение();
    Запись запись();

}

/// Представляет запись в БД, состоящую из полей
class Запись
{
/* \имя Типы */

public:
    alias base.size_t     тип_размера;
    alias base.size_t     тип_индекса;
    alias base.ptrdiff_t  тип_разницы;


/* \имя Построение */

    this(Поле[] поля, бцел флаги, БазаДанных бд);
    бцел члоПолей();
    бцел длина();
    Поле[] поля();
    Поле opIndex(тип_индекса индекс);
    ткст opIndex(ткст имяПоля);
    Поле   дайПоле(ткст имяПоля);
    Поле   найдиПоле(ткст имяПоля);
    цел естьПоле(ткст имяПоля);
    БазаДанных бд();
    цел opApply(цел delegate(inout Поле поле) дг);
    цел opApply(цел delegate(in ткст имя, in ткст значение) дг);

}

class БазаДанных
{

public:
    alias base.size_t     тип_размера;
    alias base.size_t     тип_индекса;
    alias base.ptrdiff_t  тип_разницы;

    this(ткст память, бцел флаги);
    this(ткст[] строчки, бцел флаги);
    тип_размера   члоЗаписей();
    тип_размера   члоПолей();
    тип_размера   члоСтрок();
    бцел флаги();
    Запись[] записи();
    Поле[] поля();
    бцел длина();
    Запись  opIndex(тип_индекса индекс);
    Запись[]    дайЗаписиСПолем(ткст имяПоля);
    Запись[]    дайЗаписиСПолем(ткст имяПоля, ткст значениеПоля);
    цел opApply(цел delegate(inout Запись запись) дг);
    цел opApply(цел delegate(inout Поле поле) дг);
}