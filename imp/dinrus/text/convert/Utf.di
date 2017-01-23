/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: Oct 2004

        authors:        Kris

        Быстрый Unicode transcoders. These are particularly sensitive в_
        minor changes on 32bit x86 devices, because the регистрируй установи of
        those devices is so small. Beware of subtle changes which might
        extend the execution-период by as much as 200%. Because of this,
        three of the six transcoders might читай past the конец of ввод by
        one, two, or three байты before arresting themselves. Note that
        support for Потокing добавьs a 15% overhead в_ the дим => сим
        conversion, but имеется little effect on the другие.

        These routines were tuned on an Intel P4; другой devices may work
        ещё efficiently with a slightly different approach, though this
        is likely в_ be reasonably optimal on AMD x86 CPUs also. These
        algorithms would benefit significantly из_ those extra AMD64
        registers. On a 3GHz P4, the дим/сим conversions возьми around
        2500ns в_ process an Массив of 1000 ASCII элементы. Invoking the
        память manager doubles that период, и quadruples the время for
        массивы of 100 элементы. Memory allocation can slow down notably
        in a multi-threaded environment, so avoопр that where possible.

        Surrogate-pairs are dealt with in a non-optimal fashion when
        transcoding between utf16 и utf8. Such cases are consопрered
        в_ be boundary-conditions for this module.

        There are three common cases where the ввод may be incomplete,
        включая each 'wопрening' case of utf8 => utf16, utf8 => utf32,
        и utf16 => utf32. An edge-case is utf16 => utf8, if surrogate
        pairs are present. Such cases will throw an исключение, unless
        Потокing-режим is включен ~ in the latter режим, an добавьitional
        целое is returned indicating как many элементы of the ввод
        have been consumed. In все cases, a correct срез of the вывод
        is returned.

        For details on Unicode processing see:
        $(UL $(LINK http://www.utf-8.com/))
        $(UL $(LINK http://www.hackcraft.net/xmlUnicode/))
        $(UL $(LINK http://www.azillionmonkeys.com/qed/unicode.html/))
        $(UL $(LINK http://icu.sourceforge.net/docs/papers/forms_of_unicode/))

*******************************************************************************/

module text.convert.Utf;

public extern (C) проц onUnicodeError (ткст сооб, т_мера индкс = 0);

/*******************************************************************************

        Symmetric calls for equivalent типы; these return the provопрed
        ввод with no conversion

*******************************************************************************/

ткст  вТкст (ткст ист, ткст приёмн, бцел* ate=пусто);
шим[] вТкст (шим[] ист, шим[] приёмн, бцел* ate=пусто) ;
дим[] вТкст (дим[] ист, дим[] приёмн, бцел* ate=пусто) ;

/*******************************************************************************

        Encode Utf8 up в_ a maximum of 4 байты дол (five & six байт
        variations are not supported).

        If the вывод is provопрed off the стэк, it should be large
        enough в_ encompass the entire transcoding; failing в_ do
        so will cause the вывод в_ be moved onto the куча instead.

        Returns a срез of the вывод буфер, corresponding в_ the
        преобразованый characters. For optimum performance, the returned
        буфер should be specified as 'вывод' on subsequent calls.
        For example:

        ---
        ткст вывод;

        ткст результат = вТкст (ввод, вывод);

        // сбрось вывод after a realloc
        if (результат.length > вывод.length)
            вывод = результат;
        ---

        Where 'ate' is provопрed, it will be установи в_ the число of 
        элементы consumed из_ the ввод, и the вывод буфер 
        will not be resized (or allocated). This represents a
        Потокing режим, where slices of the ввод are processed
        in sequence rather than все at one время (should use 'ate'
        as an индекс for slicing преобр_в unconsumed ввод).

*******************************************************************************/

ткст вТкст (шим[] ввод, ткст вывод=пусто, бцел* ate=пусто);

/*******************************************************************************

        Decode Utf8 produced by the above вТкст() метод.

        If the вывод is provопрed off the стэк, it should be large
        enough в_ encompass the entire transcoding; failing в_ do
        so will cause the вывод в_ be moved onto the куча instead.

        Returns a срез of the вывод буфер, corresponding в_ the
        преобразованый characters. For optimum performance, the returned
        буфер should be specified as 'вывод' on subsequent calls.

        Where 'ate' is provопрed, it will be установи в_ the число of 
        элементы consumed из_ the ввод, и the вывод буфер 
        will not be resized (or allocated). This represents a
        Потокing режим, where slices of the ввод are processed
        in sequence rather than все at one время (should use 'ate'
        as an индекс for slicing преобр_в unconsumed ввод).

*******************************************************************************/

шим[] вТкст16 (ткст ввод, шим[] вывод=пусто, бцел* ate=пусто);


/*******************************************************************************

        Encode Utf8 up в_ a maximum of 4 байты дол (five & six
        байт variations are not supported). Throws an исключение
        where the ввод дим is greater than 0x10ffff.

        If the вывод is provопрed off the стэк, it should be large
        enough в_ encompass the entire transcoding; failing в_ do
        so will cause the вывод в_ be moved onto the куча instead.

        Returns a срез of the вывод буфер, corresponding в_ the
        преобразованый characters. For optimum performance, the returned
        буфер should be specified as 'вывод' on subsequent calls.

        Where 'ate' is provопрed, it will be установи в_ the число of 
        элементы consumed из_ the ввод, и the вывод буфер 
        will not be resized (or allocated). This represents a
        Потокing режим, where slices of the ввод are processed
        in sequence rather than все at one время (should use 'ate'
        as an индекс for slicing преобр_в unconsumed ввод).

*******************************************************************************/

ткст вТкст (дим[] ввод, ткст вывод=пусто, бцел* ate=пусто);


/*******************************************************************************

        Decode Utf8 produced by the above вТкст() метод.

        If the вывод is provопрed off the стэк, it should be large
        enough в_ encompass the entire transcoding; failing в_ do
        so will cause the вывод в_ be moved onto the куча instead.

        Returns a срез of the вывод буфер, corresponding в_ the
        преобразованый characters. For optimum performance, the returned
        буфер should be specified as 'вывод' on subsequent calls.

        Where 'ate' is provопрed, it will be установи в_ the число of 
        элементы consumed из_ the ввод, и the вывод буфер 
        will not be resized (or allocated). This represents a
        Потокing режим, where slices of the ввод are processed
        in sequence rather than все at one время (should use 'ate'
        as an индекс for slicing преобр_в unconsumed ввод).

*******************************************************************************/

дим[] вТкст32 (ткст ввод, дим[] вывод=пусто, бцел* ate=пусто);

/*******************************************************************************

        Encode Utf16 up в_ a maximum of 2 байты дол. Throws an исключение
        where the ввод дим is greater than 0x10ffff.

        If the вывод is provопрed off the стэк, it should be large
        enough в_ encompass the entire transcoding; failing в_ do
        so will cause the вывод в_ be moved onto the куча instead.

        Returns a срез of the вывод буфер, corresponding в_ the
        преобразованый characters. For optimum performance, the returned
        буфер should be specified as 'вывод' on subsequent calls.

        Where 'ate' is provопрed, it will be установи в_ the число of 
        элементы consumed из_ the ввод, и the вывод буфер 
        will not be resized (or allocated). This represents a
        Потокing режим, where slices of the ввод are processed
        in sequence rather than все at one время (should use 'ate'
        as an индекс for slicing преобр_в unconsumed ввод).

*******************************************************************************/

шим[] вТкст16 (дим[] ввод, шим[] вывод=пусто, бцел* ate=пусто);

/*******************************************************************************

        Decode Utf16 produced by the above вТкст16() метод.

        If the вывод is provопрed off the стэк, it should be large
        enough в_ encompass the entire transcoding; failing в_ do
        so will cause the вывод в_ be moved onto the куча instead.

        Returns a срез of the вывод буфер, corresponding в_ the
        преобразованый characters. For optimum performance, the returned
        буфер should be specified as 'вывод' on subsequent calls.

        Where 'ate' is provопрed, it will be установи в_ the число of 
        элементы consumed из_ the ввод, и the вывод буфер 
        will not be resized (or allocated). This represents a
        Потокing режим, where slices of the ввод are processed
        in sequence rather than все at one время (should use 'ate'
        as an индекс for slicing преобр_в unconsumed ввод).

*******************************************************************************/

дим[] вТкст32 (шим[] ввод, дим[] вывод=пусто, бцел* ate=пусто);


/*******************************************************************************

        Decodes a single дим из_ the given ист текст, и indicates как
        many симвы were consumed из_ ист в_ do so.

*******************************************************************************/

дим раскодируй (ткст ист, ref бцел ate);

/*******************************************************************************

        Decodes a single дим из_ the given ист текст, и indicates как
        many wchars were consumed из_ ист в_ do so.

*******************************************************************************/

дим раскодируй (шим[] ист, ref бцел ate);

/*******************************************************************************

        Encode a дим преобр_в the provопрed приёмн Массив, и return a срез of 
        it representing the кодировка

*******************************************************************************/

ткст кодируй (ткст приёмн, дим c);

/*******************************************************************************

        Encode a дим преобр_в the provопрed приёмн Массив, и return a срез of 
        it representing the кодировка

*******************************************************************************/

шим[] кодируй (шим[] приёмн, дим c);

/*******************************************************************************

        Is the given character действителен?

*******************************************************************************/

бул действителен (дим c);

/*******************************************************************************

        Convert из_ a ткст преобр_в the тип of the приёмн provопрed. 

        Returns a срез of the given приёмн, where it is sufficiently large
        в_ house the результат, or a куча-allocated Массив otherwise. Returns
        the original ввод where no conversion is требуется.

*******************************************************************************/

T[] изТкст8(T) (ткст s, T[] приёмн)
{
        static if (is (T == сим))
                   return s;

        static if (is (T == шим))
                   return .вТкст16 (s, приёмн);

        static if (is (T == дим))
                   return .вТкст32 (s, приёмн);
}

/*******************************************************************************

        Convert из_ a шим[] преобр_в the тип of the приёмн provопрed. 

        Returns a срез of the given приёмн, where it is sufficiently large
        в_ house the результат, or a куча-allocated Массив otherwise. Returns
        the original ввод where no conversion is требуется.

*******************************************************************************/

T[] изТкст16(T) (шим[] s, T[] приёмн)
{
        static if (is (T == шим))
                   return s;

        static if (is (T == сим))
                   return .вТкст (s, приёмн);

        static if (is (T == дим))
                   return .вТкст32 (s, приёмн);
}

/*******************************************************************************

        Convert из_ a дим[] преобр_в the тип of the приёмн provопрed. 

        Returns a срез of the given приёмн, where it is sufficiently large
        в_ house the результат, or a куча-allocated Массив otherwise. Returns
        the original ввод where no conversion is требуется.

*******************************************************************************/

T[] изТкст32(T) (дим[] s, T[] приёмн)
{
        static if (is (T == дим))
                   return s;

        static if (is (T == сим))
                   return .вТкст (s, приёмн);

        static if (is (T == шим))
                   return .вТкст16 (s, приёмн);
}

/*******************************************************************************

        Adjust the контент such that no partial encodings exist on the 
        left sопрe of the provопрed текст.

        Returns a срез of the ввод

*******************************************************************************/

T[] отрежьЛево(T) (T[] s)
{
        static if (is (T == сим))
                   for (цел i=0; i < s.length && (s[i] & 0x80); ++i)
                        if ((s[i] & 0xc0) is 0xc0)
                             return s [i..$];

        static if (is (T == шим))
                   // пропусти if первый сим is a trailing surrogate
                   if ((s[0] & 0xfffffc00) is 0xdc00)
                        return s [1..$];

        return s;
}

/*******************************************************************************

        Adjust the контент such that no partial encodings exist on the 
        right sопрe of the provопрed текст.

        Returns a срез of the ввод

*******************************************************************************/

T[] отрежьПраво(T) (T[] s)
{
        if (s.length)
           {
           бцел i = s.length - 1;
           static if (is (T == сим))
                      while (i && (s[i] & 0x80))
                             if ((s[i] & 0xc0) is 0xc0)
                                {
                                // located the первый байт of a sequence
                                ббайт b = s[i];
                                цел d = s.length - i;

                                // is it a 3 байт sequence?
                                if (b & 0x20)
                                    --d;
   
                                // or a four байт sequence?
                                if (b & 0x10)
                                    --d;

                                // is the sequence complete?
                                if (d is 2)
                                    i = s.length;
                                return s [0..i];
                                }
                             else 
                                --i;

           static if (is (T == шим))
                      // пропусти if последний сим is a leading surrogate
                      if ((s[i] & 0xfffffc00) is 0xd800)
                           return s [0..$-1];
           }
        return s;
}



/*******************************************************************************

*******************************************************************************/

debug (Utf)
{
        import io.Console;

        проц main()
        {
                auto s = "[\xc2\xa2\xc2\xa2\xc2\xa2]";
                Квывод (s).нс;

                Квывод (отрежьЛево(s[0..$])).нс;
                Квывод (отрежьЛево(s[1..$])).нс;
                Квывод (отрежьЛево(s[2..$])).нс;
                Квывод (отрежьЛево(s[3..$])).нс;
                Квывод (отрежьЛево(s[4..$])).нс;
                Квывод (отрежьЛево(s[5..$])).нс;

                Квывод (отрежьПраво(s[0..$])).нс;
                Квывод (отрежьПраво(s[0..$-1])).нс;
                Квывод (отрежьПраво(s[0..$-2])).нс;
                Квывод (отрежьПраво(s[0..$-3])).нс;
                Квывод (отрежьПраво(s[0..$-4])).нс;
                Квывод (отрежьПраво(s[0..$-5])).нс;
        }
}
