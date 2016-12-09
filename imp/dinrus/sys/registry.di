module sys.registry;

alias цел  булево;


/// Перечисление распознаваемых режимов доступа к реестру
///
/// \ingroup group_D_win32_reg
enum ПРежимДоступаКРеестру
{
        ЗапросЗначения         =   0x0001 //!< Разрешение запроса данных подключа
    ,   УстановкаЗначения           =   0x0002 //!< Разрешение установки данных подключа
    ,   СозданиеПодключа      =   0x0004 //!< Разрешение создавать подключи
    ,   ПеречислениеПодключей  =   0x0008 //!< Разрешение перечислять подключи
    ,   Уведомление              =   0x0010 //!< Разрешение уведомления об изменении
    ,   СозданиеСссылки         =   0x0020 //!< Разрешение на создание символьной ссылки
    ,   KEY_WOW64_32KEY         =   0x0200 //!< Разрешает 64- или 32-битному приложению открывать 32-битный ключ
    ,   KEY_WOW64_64KEY         =   0x0100 //!< Разрешает 64- или 32-битному приложению открывать 64-битный ключ
    ,   KEY_WOW64_RES           =   0x0300 //!< 
    ,   Чтение                =   (   0x00020000L
                                    |   ЗапросЗначения
                                    |   ПеречислениеПодключей
                                    |   Уведомление)
                                &   ~(0x00100000L) //!< Combines the STANDARD_RIGHTS_READ, ЗапросЗначения, ПеречислениеПодключей, and Уведомление доступ rights
    ,   Запись               =   (   0x00020000L
                                    |   УстановкаЗначения
                                    |   СозданиеПодключа)
                                &   ~(0x00100000L) //!< Combines the STANDARD_RIGHTS_WRITE, УстановкаЗначения, and СозданиеПодключа доступ rights
    ,   Выполнение             =   Чтение
                                &   ~(0x00100000L) //!< Permission for read доступ
    ,   ПолныйДоступ          =   (   0x001F0000L
                                    |   ЗапросЗначения
                                    |   УстановкаЗначения
                                    |   СозданиеПодключа
                                    |   ПеречислениеПодключей
                                    |   Уведомление
                                    |   СозданиеСссылки)
                                &   ~(0x00100000L) //!< Combines the ЗапросЗначения, ПеречислениеПодключей, Уведомление, СозданиеПодключа, СозданиеСссылки, and УстановкаЗначения доступ rights, plus all the standard доступ rights except 0x00100000L
}

/// Перечень распознаваемых типов значений реестра
///
/// \ingroup group_D_win32_reg
public enum ПТипЗначенияРеестра
{
        Неизвестен                     =   -1 //!< 
    ,   Никакой                        =   0  //!< Тип значения null. (На практике рассматривается как бинарный массив нулевой длины в реестре Win32)
    ,   Ткст0                          =   1  //!< A zero-terminated ткст
    ,   Ткст0Развёрт                   =   2  //!< A zero-terminated ткст containing expandable environment variable references
    ,   Бинарный                      =   3  //!< A binary blob
    ,   Бцел                       =   4  //!< A 32-bit unsigned integer
    ,   БцелЛЕ         =   4  //!< A 32-bit unsigned integer, stored in little-эндиан байт order
    ,   БцелБЕ            =   5  //!< A 32-bit unsigned integer, stored in big-эндиан байт order
    ,   Ссылка                        =   6  //!< A registry link
    ,   МногоТкст0                    =   7  //!< A set of zero-terminated strings
    ,   СписокРесурсов               =   8  //!< A hardware resource list
    ,   ПолныйДескрипторРесурса    =   9  //!< A hardware resource descriptor
    ,   СписовТребуемыхРесурсов  =   10 //!< A hardware resource requirements list
    ,   Бцел64                       =   11 //!< A 64-bit unsigned integer
    ,   Бцел64ЛЕ         =   11 //!< A 64-bit unsigned integer, stored in little-эндиан байт order
}

extern(D) class Ключ
{

 this(HKEY hkey, ткст имя, булево созд);

    ~this();

    /// Название ключа
    ткст имя();
	
    /// Число подключей
    бцел члоПодключей();
	
    /// Перечислительная последовательность подключей этого ключа
    РядКлючей ключи();
	
    /// An enumerable sequence of the names of all the sub-ключи of this ключ
    РядИмёнКлючей именаКлючей();
	
    /// The number of значения
    бцел члоЗначений();
	
    /// An enumerable sequence of all the значения of this ключ
    РядЗначений значения();

    /// An enumerable sequence of the names of all the значения of this ключ
    РядИмёнЗначений именаЗначений();

    /// Returns the named sub-ключ of this ключ
    ///
    /// \param имя The имя of the subkey to create. May not be null
    /// \return The created ключ
    /// \note If the ключ cannot be created, a ИсклРеестра is thrown.
    Ключ создайКлюч(ткст имя, ПРежимДоступаКРеестру доступ);
	
    /// Returns the named sub-ключ of this ключ
    ///
    /// \param имя The имя of the subkey to create. May not be null
    /// \return The created ключ
    /// \note If the ключ cannot be created, a ИсклРеестра is thrown.
    /// \note This function is equivalent to calling CreateKey(имя, ПРежимДоступаКРеестру.ПолныйДоступ), and returns a ключ with all доступ
    Ключ создайКлюч(ткст имя);

    /// Returns the named sub-ключ of this ключ
    ///
    /// \param имя The имя of the subkey to aquire. If имя is null (or the empty-ткст), then the called ключ is duplicated
    /// \param доступ The desired доступ; one of the ПРежимДоступаКРеестру enumeration
    /// \return The aquired ключ. 
    /// \note This function never returns null. If a ключ corresponding to the requested имя is not found, a ИсклРеестра is thrown
    Ключ дайКлюч(ткст имя, ПРежимДоступаКРеестру доступ);
	
    /// Returns the named sub-ключ of this ключ
    ///
    /// \param имя The имя of the subkey to aquire. If имя is null (or the empty-ткст), then the called ключ is duplicated
    /// \return The aquired ключ. 
    /// \note This function never returns null. If a ключ corresponding to the requested имя is not found, a ИсклРеестра is thrown
    /// \note This function is equivalent to calling GetKey(имя, ПРежимДоступаКРеестру.Чтение), and returns a ключ with read/enum доступ
    Ключ дайКлюч(ткст имя);
	
    /// Deletes the named ключ
    ///
    /// \param имя The имя of the ключ to delete. May not be null
    проц удалиКлюч(ткст имя);
	
    /// Returns the named значение
    ///
    /// \note if имя is null (or the empty-ткст), then the default значение is returned
    /// \return This function never returns null. If a значение corresponding to the requested имя is not found, a ИсклРеестра is thrown
    Значение дайЗначение(ткст имя);

    /// Sets the named значение with the given 32-bit unsigned integer значение
    ///
    /// \param имя The имя of the значение to set. If null, or the empty ткст, sets the default значение
    /// \param значение The 32-bit unsigned значение to set
    /// \note If a значение corresponding to the requested имя is not found, a ИсклРеестра is thrown
    проц установиЗначение(ткст имя, бцел значение);

    /// Sets the named значение with the given 32-bit unsigned integer значение, according to the desired байт-ordering
    ///
    /// \param имя The имя of the значение to set. If null, or the empty ткст, sets the default значение
    /// \param значение The 32-bit unsigned значение to set
    /// \param эндиан Can be Эндиан.Биг or Эндиан.Литтл
    /// \note If a значение corresponding to the requested имя is not found, a ИсклРеестра is thrown
    проц установиЗначение(ткст имя, бцел значение, Эндиан эндиан);

    /// Sets the named значение with the given 64-bit unsigned integer значение
    ///
    /// \param имя The имя of the значение to set. If null, or the empty ткст, sets the default значение
    /// \param значение The 64-bit unsigned значение to set
    /// \note If a значение corresponding to the requested имя is not found, a ИсклРеестра is thrown
    проц установиЗначение(ткст имя, бдол значение);

    /// Sets the named значение with the given ткст значение
    ///
    /// \param имя The имя of the значение to set. If null, or the empty ткст, sets the default значение
    /// \param значение The ткст значение to set
    /// \note If a значение corresponding to the requested имя is not found, a ИсклРеестра is thrown
    проц установиЗначение(ткст имя, ткст значение);

    /// Sets the named значение with the given ткст значение
    ///
    /// \param имя The имя of the значение to set. If null, or the empty ткст, sets the default значение
    /// \param значение The ткст значение to set
    /// \param asEXPAND_SZ If true, the значение will be stored as an expandable environment ткст, otherwise as a normal ткст
    /// \note If a значение corresponding to the requested имя is not found, a ИсклРеестра is thrown
    проц установиЗначение(ткст имя, ткст значение, булево asEXPAND_SZ);

    /// Sets the named значение with the given multiple-strings значение
    ///
    /// \param имя The имя of the значение to set. If null, or the empty ткст, sets the default значение
    /// \param значение The multiple-strings значение to set
    /// \note If a значение corresponding to the requested имя is not found, a ИсклРеестра is thrown
    проц установиЗначение(ткст имя, ткст[] значение);
	
    /// Sets the named значение with the given binary значение
    ///
    /// \param имя The имя of the значение to set. If null, or the empty ткст, sets the default значение
    /// \param значение The binary значение to set
    /// \note If a значение corresponding to the requested имя is not found, a ИсклРеестра is thrown
    проц установиЗначение(ткст имя, байт[] значение);
	
    /// Deletes the named значение
    ///
    /// \param имя The имя of the значение to delete. May not be null
    /// \note If a значение of the requested имя is not found, a ИсклРеестра is thrown
    проц удалиЗначение(ткст имя);

    /// Flushes any changes to the ключ to disk
    ///
    проц слей();

}

////////////////////////////////////////////////////////////////////////////////
// Значение

/// This class represents a значение of a registry ключ
///
/// \ingroup group_D_win32_reg

extern(D) class Значение
{
	this(Ключ ключ, ткст имя, ПТипЗначенияРеестра тип);

    /// The имя of the значение.
    ///
    /// \note If the значение represents a default значение of a ключ, which has no имя, the returned ткст will be of zero length
    ткст имя();

    /// The тип of значение
    ПТипЗначенияРеестра тип();

    /// Obtains the current значение of the значение as a ткст.
    ///
    /// \return The contents of the значение
    /// \note If the значение's тип is Ткст0Развёрт the returned значение is <b>not</b> expanded; Value_EXPAND_SZ() should be called
    /// \note Throws a ИсклРеестра if the тип of the значение is not Ткст0, Ткст0Развёрт, Бцел(_*) or Бцел64(_*):
    ткст значение_Ткст0();

    /// Obtains the current значение as a ткст, within which any environment
    /// variables have undergone expansion
    ///
    /// \return The contents of the значение
    /// \note This function works with the same значение-types as Value_SZ().
    ткст значение_Ткст0Развёрт();
	
    /// Obtains the current значение as an array of strings
    ///
    /// \return The contents of the значение
    /// \note Throws a ИсклРеестра if the тип of the значение is not МногоТкст0
    ткст[] многострочноеТкст0Значение();
	
    /// Obtains the current значение as a 32-bit unsigned integer, ordered correctly according to the current architecture
    ///
    /// \return The contents of the значение
    /// \note An exception is thrown for all types other than Бцел, БцелЛЕ and БцелБЕ.
    бцел значениеБцел();
	
    /// Obtains the значение as a 64-bit unsigned integer, ordered correctly according to the current architecture
    ///
    /// \return The contents of the значение
    /// \note Throws a ИсклРеестра if the тип of the значение is not Бцел64
    бдол значениеБдол();
	

    /// Obtains the значение as a binary blob
    ///
    /// \return The contents of the значение
    /// \note Throws a ИсклРеестра if the тип of the значение is not Бинарный
    байт[]  бинарноеЗначение();
	
}

////////////////////////////////////////////////////////////////////////////////
// Реестр

/// Represents the local system registry.
///
/// \ingroup group_D_win32_reg

extern(D) class Реестр
{
    this();

    /// Returns the root ключ for the HKEY_CLASSES_ROOT hive
    static Ключ  кореньКлассов() ;
	
    /// Returns the root ключ for the HKEY_CURRENT_USER hive
    static Ключ  текущийПользователь();
	
    /// Returns the root ключ for the HKEY_LOCAL_MACHINE hive
    static Ключ  локальнаяМашина() ;
	
    /// Returns the root ключ for the HKEY_USERS hive
    static Ключ  пользователи()      ;
	
    /// Returns the root ключ for the HKEY_PERFORMANCE_DATA hive
    static Ключ  данныеПроизводительности()  ;
	
    /// Returns the root ключ for the HKEY_CURRENT_CONFIG hive
    static Ключ  текущаяКонфигурация()   ;
	
    /// Returns the root ключ for the HKEY_DYN_DATA hive
    static Ключ  динДанные()       ;

}

////////////////////////////////////////////////////////////////////////////////
// РядИмёнКлючей

/// An enumerable sequence representing the names of the sub-ключи of a registry Ключ
///
/// It would be used as follows:
///
/// <код>&nbsp;&nbsp;Ключ&nbsp;ключ&nbsp;=&nbsp;. . .</код>
/// <br>
/// <код></код>
/// <br>
/// <код>&nbsp;&nbsp;foreach(сим[] kName; ключ.SubKeys)</код>
/// <br>
/// <код>&nbsp;&nbsp;{</код>
/// <br>
/// <код>&nbsp;&nbsp;&nbsp;&nbsp;process_Key(kName);</код>
/// <br>
/// <код>&nbsp;&nbsp;}</код>
/// <br>
/// <br>
///
/// \ingroup group_D_win32_reg

extern(D) class РядИмёнКлючей
{
	this(Ключ ключ);
	
    /// The number of ключи
    бцел количество();
	
    /// The имя of the ключ at the given индекс
    ///
    /// \param индекс The 0-based индекс of the ключ to retrieve
    /// \return The имя of the ключ corresponding to the given индекс
    /// \note Throws a ИсклРеестра if no corresponding ключ is retrieved
    ткст дайИмяКлюча(бцел индекс);
	

    /// The имя of the ключ at the given индекс
    ///
    /// \param индекс The 0-based индекс of the ключ to retrieve
    /// \return The имя of the ключ corresponding to the given индекс
    /// \note Throws a ИсклРеестра if no corresponding ключ is retrieved
    ткст opIndex(бцел индекс);
	
    цел opApply(цел delegate(inout ткст имя) dg);
}


////////////////////////////////////////////////////////////////////////////////
// РядКлючей

/// An enumerable sequence representing the sub-ключи of a registry Ключ
///
/// It would be used as follows:
///
/// <код>&nbsp;&nbsp;Ключ&nbsp;ключ&nbsp;=&nbsp;. . .</код>
/// <br>
/// <код></код>
/// <br>
/// <код>&nbsp;&nbsp;foreach(Ключ k; ключ.SubKeys)</код>
/// <br>
/// <код>&nbsp;&nbsp;{</код>
/// <br>
/// <код>&nbsp;&nbsp;&nbsp;&nbsp;process_Key(k);</код>
/// <br>
/// <код>&nbsp;&nbsp;}</код>
/// <br>
/// <br>
///
/// \ingroup group_D_win32_reg

extern(D) class РядКлючей
{

	this(Ключ ключ);

    /// The number of ключи
    бцел количество();

    /// The ключ at the given индекс
    ///
    /// \param индекс The 0-based индекс of the ключ to retrieve
    /// \return The ключ corresponding to the given индекс
    /// \note Throws a ИсклРеестра if no corresponding ключ is retrieved
    Ключ дайКлюч(бцел индекс);
	
    /// The ключ at the given индекс
    ///
    /// \param индекс The 0-based индекс of the ключ to retrieve
    /// \return The ключ corresponding to the given индекс
    /// \note Throws a ИсклРеестра if no corresponding ключ is retrieved
    Ключ opIndex(бцел индекс);
	
    цел opApply(цел delegate(inout Ключ ключ) dg);
}

////////////////////////////////////////////////////////////////////////////////
// РядИмёнЗначений

/// An enumerable sequence representing the names of the значения of a registry Ключ
///
/// It would be used as follows:
///
/// <код>&nbsp;&nbsp;Ключ&nbsp;ключ&nbsp;=&nbsp;. . .</код>
/// <br>
/// <код></код>
/// <br>
/// <код>&nbsp;&nbsp;foreach(сим[] vName; ключ.Values)</код>
/// <br>
/// <код>&nbsp;&nbsp;{</код>
/// <br>
/// <код>&nbsp;&nbsp;&nbsp;&nbsp;process_Value(vName);</код>
/// <br>
/// <код>&nbsp;&nbsp;}</код>
/// <br>
/// <br>
///
/// \ingroup group_D_win32_reg

extern(D) class РядИмёнЗначений
{

	this(Ключ ключ);

    /// The number of значения
    бцел количество();

    /// The имя of the значение at the given индекс
    ///
    /// \param индекс The 0-based индекс of the значение to retrieve
    /// \return The имя of the значение corresponding to the given индекс
    /// \note Throws a ИсклРеестра if no corresponding значение is retrieved
    ткст дайИмяЗначения(бцел индекс);
	
    /// The имя of the значение at the given индекс
    ///
    /// \param индекс The 0-based индекс of the значение to retrieve
    /// \return The имя of the значение corresponding to the given индекс
    /// \note Throws a ИсклРеестра if no corresponding значение is retrieved
    ткст opIndex(бцел индекс);

    цел opApply(цел delegate(inout ткст имя) dg);
}

////////////////////////////////////////////////////////////////////////////////
// РядЗначений

/// An enumerable sequence representing the значения of a registry Ключ
///
/// It would be used as follows:
///
/// <код>&nbsp;&nbsp;Ключ&nbsp;ключ&nbsp;=&nbsp;. . .</код>
/// <br>
/// <код></код>
/// <br>
/// <код>&nbsp;&nbsp;foreach(Значение v; ключ.Values)</код>
/// <br>
/// <код>&nbsp;&nbsp;{</код>
/// <br>
/// <код>&nbsp;&nbsp;&nbsp;&nbsp;process_Value(v);</код>
/// <br>
/// <код>&nbsp;&nbsp;}</код>
/// <br>
/// <br>
///
/// \ingroup group_D_win32_reg

extern(D) class РядЗначений
{
///Конструктор
this(Ключ ключ);

    ///Число значения
    бцел количество();

    /// Значение по указанному индекс
    ///
    /// \param индекс The 0-based индекс of the значение to retrieve
    /// \return The значение corresponding to the given индекс
    /// \note Throws a ИсклРеестра if no corresponding значение is retrieved
    Значение дайЗначение(бцел индекс);

    /// The значение at the given индекс
    ///
    /// \param индекс The 0-based индекс of the значение to retrieve
    /// \return The значение corresponding to the given индекс
    /// \note Throws a ИсклРеестра if no corresponding значение is retrieved
    Значение opIndex(бцел индекс);

    цел opApply(цел delegate(inout Значение значение) dg);


}
/+
unittest
{
/* ////////////////////////////////////////////////////////////////////////// */
	import sys.registry;
	void main()
	{
		Ключ HKCR    =   Реестр.кореньКлассов;
		Ключ CLSID   =   HKCR.дайКлюч("CLSID");

		foreach(Ключ ключ; CLSID.ключи())
		{
			foreach(Значение зн; ключ.значения())
			{
			скажинс(зн.имя());
			}
		}
	}
}
/* ////////////////////////////////////////////////////////////////////////// */
+/