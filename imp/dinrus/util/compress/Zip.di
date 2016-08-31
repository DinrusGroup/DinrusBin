/*******************************************************************************
 *
 * copyright:   Copyright (c) 2007 Daniel Keep.  все rights reserved.
 *
 * license:     BSD стиль: $(LICENSE)
 *
 * version:     Initial release: December 2007
 *
 * author:      Daniel Keep
 *
 ******************************************************************************/

module util.compress.Zip;

/*

TODO
====

* Disable UTF кодировка until I've worked out what version of ZИП that's
  related в_... (actually; it's entirely possible that's it's merely a
  *proposal* at the moment.) (*Готово*)

* Make ЗаписьЗип safe: сделай them aware that their creating читатель есть been
  destroyed.

*/

import core.ByteSwap : ПерестановкаБайт;
import io.device.Array : Массив;
import io.device.File : Файл;
import io.FilePath : ФПуть, ПросмотрПути;
import io.device.FileMap : ФайлМэп;
import util.compress.ZlibStream : ВводЗлиб, ВыводЗлиб;
import util.digest.Crc32 : Crc32;
import io.model : ИПровод, ИПотокВвода, ИПотокВывода;
import io.stream.Digester : ДайджестВвод;
import time.Time : Время, ИнтервалВремени;
import time.WallClock : Куранты;
import time.chrono.Gregorian : Грегориан;

import Путь = io.Path;
import PathUtil = util.PathUtil;
import Целое = text.convert.Integer;


debug(ZИП) import io.Stdout : Стдош;

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Implementation crap
//
// Why is this here, you ask?  Because of bloody DMD forward reference bugs.
// For pete's sake, Walter, FIX THEM, please!
//
// To пропусти в_ the actual пользователь-visible stuff, search for "Shared stuff".

private
{

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ЛокалФайлЗаг
//

    align(1)
    struct ДанныеЛокалФайлЗага
    {
        бкрат      extract_version = бкрат.max;
        бкрат      general_flags = 0;
        бкрат      метод_сжатия = 0;
        бкрат      modification_file_time = 0;
        бкрат      modification_file_date = 0;
        бцел        crc_32 = 0; // offsetof = 10
        бцел        сжатый_размер = 0;
        бцел        разжатый_размер = 0;
        бкрат      file_name_length = 0;
        бкрат      extra_field_length = 0;

        debug(ZИП) проц dump();
    }

struct ЛокалФайлЗаг
{
    const бцел сигнатура = 0x04034b50;

    alias ДанныеЛокалФайлЗага Данные;
    Данные данные;
    static assert( Данные.sizeof == 26 );

    ткст имя_файла;
    ббайт[] допполе;

    проц[] массив_данн();

    проц помести(ИПотокВывода вывод);

    проц заполни(ИПотокВвода ист);

    /*
     * This метод will check в_ сделай sure that the local and central заголовки
     * are the same; if they're not, then that indicates that the архив is
     * corrupt.
     */
    бул agrees_with(ФайлЗаг h);
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ФайлЗаг
//

    align(1)
    struct ДанныеФайлЗага
    {
        ббайт       версия_зип;
        ббайт       тип_файл_атров;
        бкрат      extract_version;
        бкрат      general_flags;
        бкрат      метод_сжатия;
        бкрат      modification_file_time;
        бкрат      modification_file_date;
        бцел        crc_32;
        бцел        сжатый_размер;
        бцел        разжатый_размер;
        бкрат      file_name_length;
        бкрат      extra_field_length;
        бкрат      file_comment_length;
        бкрат      disk_number_start;
        бкрат      internal_file_attributes = 0;
        бцел        external_file_attributes = 0;
        цел         relative_offset_of_local_header;

        debug(ZИП) проц dump();

        проц fromLocal(ЛокалФайлЗаг.Данные данные);
    }

struct ФайлЗаг
{
    const бцел сигнатура = 0x02014b50;

    alias ДанныеФайлЗага Данные;
    Данные* данные;
    static assert( Данные.sizeof == 42 );

    ткст имя_файла;
    ббайт[] допполе;
    ткст комментарий_файла;

    бул используетДескрипторДанных();

    бцел опцииСжатия();

    бул используетУтф8();

    проц[] массив_данн();

    проц помести(ИПотокВывода вывод);

    дол карта(проц[] ист);
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// EndOfCDRecord
//

    align(1)
    struct EndOfCDRecordData
    {
        бкрат      disk_number = 0;
        бкрат      disk_with_start_of_central_directory = 0;
        бкрат      central_directory_entries_on_this_disk;
        бкрат      central_directory_entries_total;
        бцел        size_of_central_directory;
        бцел        offset_of_start_of_cd_from_starting_disk;
        бкрат      file_comment_length;

        debug(ZИП) проц dump();
    }

struct EndOfCDRecord
{
    const бцел  сигнатура = 0x06054b50;

    alias EndOfCDRecordData Данные;
    Данные данные;
    static assert( данные.sizeof == 18 );

    ткст комментарий_файла;

    проц[] массив_данн();

    проц помести(ИПотокВывода вывод);

    проц заполни(проц[] ист);
}

// End of implementation crap
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Shared stuff

public
{
    /**
     * This enumeration denotes the kind of compression used on a файл.
     */
    enum Метод
    {
        /// No compression should be used.
        Store,
        /// Deflate compression.
        Deflate,
        /**
         * This is a special значение used for unsupported or unrecognised
         * compression methods.  This значение is only used internally.
         */
        Unsupported
    }
}

private
{
    const бкрат ZИП_VERSION = 20;
    const бкрат MAX_EXTRACT_VERSION = 20;

    /*                                     compression флаги
                                  uses trailing descrИПtor |
                               utf-8 кодировка            | |
                                            ^            ^ /\               */
    const бкрат SUPPORTED_FLAGS = 0b00_0_0_0_0000_0_0_0_1_11_0;
    const бкрат UNSUPPORTED_FLAGS = ~SUPPORTED_FLAGS;

    Метод toMethod(бкрат метод);

    бкрат fromMethod(Метод метод);

    /* NOTE: This doesn't actually appear в_ work.  Using the default magic
     * число with Dinrus's Crc32 дайджест works, however.
     */
    //const CRC_MAGIC = 0xdebb20e3u;
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ЧитательЗип

interface ЧитательЗип
{
    бул поточно();
    проц закрой();
    бул ещё();
    ЗаписьЗип получи();
    ЗаписьЗип получи(ЗаписьЗип);
    цел opApply(цел delegate(ref ЗаписьЗип));
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ПисательЗип

interface ПисательЗип
{
    проц финиш();
    проц поместиФайл(ИнфоОЗаписиЗип инфо, ткст путь);
    проц поместиФайл(ИнфоОЗаписиЗип инфо, ткст путь);
    проц поместиПоток(ИнфоОЗаписиЗип инфо, ИПотокВвода источник);
    проц поместиЗапись(ИнфоОЗаписиЗип инфо, ЗаписьЗип Запись);
    проц поместиДанные(ИнфоОЗаписиЗип инфо, проц[] данные);
    Метод метод();
    Метод метод(Метод);
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ЧитательБлокаЗип

/**
 * The ЧитательБлокаЗип class is used в_ разбор a ZИП архив.  It exposes the
 * contents of the архив via an iteration interface.  For экземпляр, в_ loop
 * over все файлы in an архив, one can use either
 *
 * -----
 *  foreach( Запись ; читатель )
 *      ...
 * -----
 *
 * Or
 *
 * -----
 *  while( читатель.ещё )
 *  {
 *      auto Запись = читатель.получи;
 *      ...
 *  }
 * -----
 *
 * See the ЗаписьЗип class for ещё information on the contents of записи.
 *
 * Note that this class can only be used with ввод sources which can be
 * freely seeked.  Also note that you may открой a ЗаписьЗип экземпляр produced by
 * this читатель at any время until the ЧитательЗип that создан it is закрыт.
 */
class ЧитательБлокаЗип : ЧитательЗип
{
    /**
     * Creates a ЧитательБлокаЗип using the specified файл on the local
     * filesystem.
     */
    this(ткст путь);

version( Неук )
{
    /**
     * Creates a ЧитательБлокаЗип using the provопрed Файл экземпляр.  Where
     * possible, the провод will be wrapped in a память-mapped буфер for
     * optimum performance.  If you do not want the Файл память-mapped,
     * either cast it в_ an ИПотокВвода first, or пароль источник.ввод в_ the
     * constructor.
     */
    this(Файл источник);
}

    /**
     * Creates a ЧитательБлокаЗип using the provопрed ИПотокВвода.  Please note
     * that this ИПотокВвода must be attached в_ a провод implementing the 
     * ИПровод.ИШаг interface.
     */
    this(ИПотокВвода источник);

    бул поточно();

    /**
     * Closes the читатель, and releases все resources.  After this operation,
     * все ЗаписьЗип instances создан by this ЧитательЗип are не_годится and should
     * not be used.
     */
    проц закрой();

    /**
     * Returns да if and only if there are добавьitional файлы in the архив
     * which have not been читай via the получи метод.  This returns да before
     * the first вызов в_ получи (assuming the opened архив is non-пустой), and
     * нет after the последний файл есть been использовался.
     */
    бул ещё();

    /**
     * Retrieves the следщ файл из_ the архив.  Note that although this does
     * perform IO operations, it will not читай the contents of the файл.
     *
     * The optional reuse аргумент can be used в_ instruct the читатель в_ reuse
     * an existing ЗаписьЗип экземпляр.  If passed a пусто reference, it will
     * создай a new ЗаписьЗип экземпляр.
     */
    ЗаписьЗип получи();

    /// ditto
    ЗаписьЗип получи(ЗаписьЗип reuse);

    /**
     * This is used в_ iterate over the contents of an архив using a foreach
     * loop.  Please note that the iteration will reuse the ЗаписьЗип экземпляр
     * passed в_ your loop.  If you wish в_ keep the экземпляр and re-use it
     * later, you $(B must) use the dup member в_ создай a копируй.
     */
    цел opApply(цел delegate(ref ЗаписьЗип) дг);

private:
    ИПотокВвода источник;
    ИПотокВвода шагун; //ИПровод.ИШаг шагун;

    enum Состояние { Init, Open, Готово }
    Состояние состояние;
    т_мера current_index = 0;
    ФайлЗаг[] заголовки;

    // These should be killed when the читатель is закрыт.
    ббайт[] cd_data;
    Файл file_source = пусто;
    ФайлМэп mm_source = пусто;

    /*
     * This function will читай the contents of the central дир.  разбей
     * or spanned archives aren't supported.
     */
    проц read_cd();

    /*
     * This will locate the конец of CD record in the открой поток.
     *
     * This код sucks, but that's because ZИП sucks.
     *
     * Basically, the EOCD record is stuffed somewhere at the конец of the файл.
     * In a brilliant перемести, the record is *variably sized*, which means we
     * have в_ do a linear backwards search в_ найди it.
     *
     * The заголовок itself (включая the сигнатура) is at minimum 22 байты
     * дол, plus anywhere between 0 and 2^16-1 байты of коммент.  That means
     * we need в_ читай the последний 2^16-1 + 22 байты из_ the файл, and look for
     * the сигнатура [0x50,0x4b,0x05,0x06] in [0 .. $-18].
     *
     * If we найди the EOCD record, we'll return its contents.  If we couldn't
     * найди it, we'll throw an исключение.
     */
    EndOfCDRecord read_eocd_record();

    /*
     * Opens the specified файл for reading.  If the необр аргумент passed is
     * да, then the файл is *not* decompressed.
     */
    ИПотокВвода open_file(ФайлЗаг заголовок, бул необр);

    /*
     * Opens a файл's необр ввод поток.  Basically, this returns a срез of
     * the архив's ввод поток.
     */
    ИПотокВвода open_file_Необр(ФайлЗаг заголовок);
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ПисательБлокаЗип

/**
 * The ПисательБлокаЗип class is used в_ создай a ZИП архив.  It uses a
 * writing iterator interface.
 *
 * Note that this class can only be used with вывод Потокs which can be
 * freely seeked.
 */

class ПисательБлокаЗип : ПисательЗип
{
    /**
     * Creates a ПисательБлокаЗип using the specified файл on the local
     * filesystem.
     */
    this(ткст путь);

    /**
     * Creates a ПисательБлокаЗип using the provопрed ИПотокВывода.  Please note
     * that this ИПотокВывода must be attached в_ a провод implementing the 
     * ИПровод.ИШаг interface.
     */
    this(ИПотокВывода вывод);

    /**
     * Finalises the архив, writes out the central дир, and closes the
     * вывод поток.
     */
    проц финиш();

    /**
     * добавьs a файл из_ the local filesystem в_ the архив.
     */
    проц поместиФайл(ИнфоОЗаписиЗип инфо, ткст путь);

    /**
     * добавьs a файл using the contents of the given ИПотокВвода в_ the архив.
     */
    проц поместиПоток(ИнфоОЗаписиЗип инфо, ИПотокВвода источник);

    /**
     * Transfers a файл из_ другой архив преобр_в this архив.  Note that
     * this метод will not perform any compression: whatever compression was
     * applied в_ the файл originally will be preserved.
     */
    проц поместиЗапись(ИнфоОЗаписиЗип инфо, ЗаписьЗип Запись);

    /**
     * добавьs a файл using the contents of the given Массив в_ the архив.
     */
    проц поместиДанные(ИнфоОЗаписиЗип инфо, проц[] данные);

    /**
     * This property allows you в_ control what compression метод should be
     * used for файлы being добавьed в_ the архив.
     */
    Метод метод();
    Метод метод(Метод v);

private:
    ИПотокВывода вывод;
    ИПотокВывода шагун;
    Файл file_output;

    Метод _method;

    struct Запись
    {
        ДанныеФайлЗага данные;
        дол header_position;
        ткст имяф;
        ткст коммент;
        ббайт[] extra;
    }
    Запись[] записи;

    проц put_cd();

    проц put_Необр(ИнфоОЗаписиЗип инфо, ЗаписьЗип Запись);

    проц put_compressed(ИнфоОЗаписиЗип инфо, ИПотокВвода источник);
    /*
     * Patches the local файл заголовок starting at the current вывод location
     * with updated crc and размер information.  Also updates the current последний
     * Запись.
     */
    проц patch_local_header(бцел crc_32, бцел сжатый_размер,
            бцел разжатый_размер);
    /*
     * Generates and outputs a local файл заголовок из_ the given инфо block and
     * compression метод.  Note that the crc_32, сжатый_размер and
     * разжатый_размер заголовок fields will be установи в_ zero, and must be
     * patched.
     */
    проц put_local_header(ИнфоОЗаписиЗип инфо, Метод метод);

    /*
     * Writes the given local файл заголовок данные and имяф out в_ the вывод
     * поток.  It also appends a new Запись with the данные and имяф.
     */
    проц put_local_header(ДанныеЛокалФайлЗага данные,
            ткст имя_файла);
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// ЗаписьЗип

/**
 * This class is used в_ represent a single Запись in an архив.
 * Specifically, it combines meta-данные about the файл (see the инфо field)
 * along with the two basic operations on an Запись: открой and проверь.
 */
class ЗаписьЗип
{
    /**
     * Header information on the файл.  See the ИнфоОЗаписиЗип structure for
     * ещё information.
     */
    ИнфоОЗаписиЗип инфо;

    /**
     * Size (in байты) of the файл's uncompressed contents.
     */
    бцел размер();

    /**
     * Opens a поток for reading из_ the файл.  The contents of this поток
     * represent the decompressed contents of the файл stored in the архив.
     *
     * You should not assume that the returned поток is seekable.
     *
     * Note that the returned поток may be safely закрыт without affecting
     * the underlying архив поток.
     *
     * If the файл есть not yet been verified, then the поток will be checked
     * as you читай из_ it.  When the поток is either exhausted or закрыт,
     * then the integrity of the файл's данные will be checked.  This means that
     * if the файл is corrupt, an исключение will be thrown only after you have
     * завершено reading из_ the поток.  If you wish в_ сделай sure the данные is
     * valid before you читай из_ the файл, вызов the проверь метод.
     */
    ИПотокВвода открой();

    /**
     * Verifies the contents of this файл by computing the CRC32 checksum,
     * and comparing it against the stored one.  Throws an исключение if the
     * checksums do not match.
     *
     * Not valid on поточно ZИП archives.
     */
    проц проверь();

    /**
     * Creates a new, independent копируй of this экземпляр.
     */
    ЗаписьЗип dup();

private:
    /*
     * Callback used в_ открой the файл.
     */
    alias ИПотокВвода delegate(ФайлЗаг, бул необр) open_dg_t;
    open_dg_t open_dg;

    /*
     * Необр ZИП заголовок.
     */
    ФайлЗаг заголовок;

    /*
     * The flag used в_ keep track of whether the файл's contents have been
     * verified.
     */
    бул verified = нет;

    /*
     * Opens a поток that does not perform any decompression or
     * transformation of the файл contents.  This is used internally by
     * ПисательЗип в_ perform fast zИП в_ zИП transfers without having в_
     * decompress and then recompress the contents.
     *
     * Note that because zИП stores CRCs for the *uncompressed* данные, this
     * метод currently does not do any verification.
     */
    ИПотокВвода open_Необр();

    /*
     * Creates a new ЗаписьЗип из_ the ФайлЗаг.
     */
    this(ФайлЗаг заголовок, open_dg_t open_dg);

    /*
     * Resets the current экземпляр with new values.
     */
    ЗаписьЗип сбрось(ФайлЗаг заголовок, open_dg_t open_dg);
}

/**
 * This structure содержит various pieces of meta-данные on a файл.  The
 * contents of this structure may be safely mutated.
 *
 * This structure is also used в_ specify meta-данные about a файл when добавьing
 * it в_ an архив.
 */
struct ИнфоОЗаписиЗип
{
    /// Full путь and файл имя of this файл.
    ткст имя;
    /// Modification timestamp.  If this is left uninitialised when passed в_
    /// a ПисательЗип, it will be сбрось в_ the current system время.
    Время изменён = Время.мин;
    /// Комментарий on the файл.
    ткст коммент;
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Exceptions
//

/**
 * This is the основа class из_ which все exceptions generated by this module
 * derive из_.
 */
class ИсклЗип : Исключение
{
    this(ткст сооб);

private:
    alias typeof(this) thisT;
    static проц opCall(ткст сооб);

    static проц badsig();

    static проц badsig(ткст тип);

    static проц incons(ткст имя);

    static проц missingdir();

    static проц toomanyentries();

    static проц toolong();

    static проц cdtoolong();

    static проц fntoolong();

    static проц eftoolong();

    static проц cotoolong();

    static проц fnencode();

    static проц coencode();

    static проц tooold();
}

/**
 * This исключение is thrown if a ЧитательЗип detects that a файл's contents do
 * not match the stored checksum.
 */
class ИсклКСЗип : ИсклЗип
{
    this(ткст имя);

private:
    static проц opCall(ткст имя);
}

/**
 * This исключение is thrown if you вызов получи читатель метод when there are no
 * ещё файлы in the архив.
 */
class ZИПExhaustedException : ИсклЗип
{
    this() ;

private:
    static проц opCall();
}

/**
 * This исключение is thrown if you attempt в_ читай an архив that uses
 * features not supported by the читатель.
 */
class ZИПNotSupportedException : ИсклЗип
{
    this(ткст сооб) ;

private:
    alias ZИПNotSupportedException thisT;

    static проц opCall(ткст сооб);

    static проц spanned();

    static проц zИПver(бкрат ver);

    static проц флаги();

    static проц метод(бкрат m);
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Convenience methods

проц создайАрхив(ткст архив, Метод метод, ткст[] файлы...);

проц извлекиАрхив(ткст архив, ткст приёмник);


//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Private implementation stuff
//

private:

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Verification stuff

/*
 * This class wraps an ввод поток, and computes the CRC as it проходки
 * through.  On the событие of either a закрой or EOF, it checks the CRC against
 * the one in the provопрed ЗаписьЗип.  If they don't match, it throws an
 * исключение.
 */

class СверщикЗаписиЗип : ИПотокВвода
{
    this(ЗаписьЗип Запись, ИПотокВвода источник);

    ИПровод провод();

    ИПотокВвода ввод();

    дол сместись (дол ofs, Якорь якорь = Якорь.Нач) ;

    проц закрой();

    т_мера читай(проц[] приёмн);

    override проц[] загрузи(т_мера max=-1);

private:
    Crc32 дайджест;
    ИПотокВвода источник;
    ЗаписьЗип Запись;

    проц check();
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// IO functions

/*
 * Really, seriously, читай some байты without having в_ go through a sodding
 * буфер.
 */
проц читайРовно(ИПотокВвода s, проц[] приёмн);

/*
 * Really, seriously, пиши some байты.
 */
проц пишиРовно(ИПотокВывода s, проц[] ист);

проц пиши(T)(ИПотокВывода s, T значение)
{
    version( БигЭндиан ) своп(значение);
    пишиРовно(s, (&значение)[0..1]);
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Endian garbage

проц свопВсе(T)(inout T данные)
{
    static if( is(typeof(T.record_fields)) )
        const fields = T.record_fields;
    else
        const fields = данные.tupleof.length;

    foreach( i,_ ; данные.tupleof )
    {
        if( i == fields ) break;
        своп(данные.tupleof[i]);
    }
}

проц своп(T)(inout T данные)
{
    static if( T.sizeof == 1 )
        {}
    else static if( T.sizeof == 2 )
        ПерестановкаБайт.своп16(&данные, 2);
    else static if( T.sizeof == 4 )
        ПерестановкаБайт.своп32(&данные, 4);
    else static if( T.sizeof == 8 )
        ПерестановкаБайт.своп64(&данные, 8);
    else static if( T.sizeof == 10 )
        ПерестановкаБайт.своп80(&данные, 10);
    else
        static assert(нет, "Can't своп "~T.stringof~"s.");
}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// IBM Code Page 437 stuff
//

const ткст[] cp437_to_utf8_map_low = [
    "\u0000"[], "\u263a",   "\u263b",   "\u2665",
    "\u2666",   "\u2663",   "\u2660",   "\u2022",
    "\u25d8",   "\u25cb",   "\u25d9",   "\u2642",
    "\u2640",   "\u266a",   "\u266b",   "\u263c",

    "\u25b6",   "\u25c0",   "\u2195",   "\u203c",
    "\u00b6",   "\u00a7",   "\u25ac",   "\u21a8",
    "\u2191",   "\u2193",   "\u2192",   "\u2190",
    "\u221f",   "\u2194",   "\u25b2",   "\u25bc"
];

const ткст[] cp437_to_utf8_map_high = [
    "\u00c7"[], "\u00fc",   "\u00e9",   "\u00e2",
    "\u00e4",   "\u00e0",   "\u00e5",   "\u00e7",
    "\u00ea",   "\u00eb",   "\u00e8",   "\u00ef",
    "\u00ee",   "\u00ec",   "\u00c4",   "\u00c5",

    "\u00c9",   "\u00e6",   "\u00c6",   "\u00f4",
    "\u00f6",   "\u00f2",   "\u00fb",   "\u00f9",
    "\u00ff",   "\u00d6",   "\u00dc",   "\u00f8",
    "\u00a3",   "\u00a5",   "\u20a7",   "\u0192",

    "\u00e1",   "\u00ed",   "\u00f3",   "\u00fa",
    "\u00f1",   "\u00d1",   "\u00aa",   "\u00ba",
    "\u00bf",   "\u2310",   "\u00ac",   "\u00bd",
    "\u00bc",   "\u00a1",   "\u00ab",   "\u00bb",

    "\u2591",   "\u2592",   "\u2593",   "\u2502",
    "\u2524",   "\u2561",   "\u2562",   "\u2556",
    "\u2555",   "\u2563",   "\u2551",   "\u2557",
    "\u255d",   "\u255c",   "\u255b",   "\u2510",

    "\u2514",   "\u2534",   "\u252c",   "\u251c",
    "\u2500",   "\u253c",   "\u255e",   "\u255f",
    "\u255a",   "\u2554",   "\u2569",   "\u2566",
    "\u2560",   "\u2550",   "\u256c",   "\u2567",

    "\u2568",   "\u2564",   "\u2565",   "\u2559",
    "\u2558",   "\u2552",   "\u2553",   "\u256b",
    "\u256a",   "\u2518",   "\u250c",   "\u2588",
    "\u2584",   "\u258c",   "\u2590",   "\u2580",
    "\u03b1",   "\u00df",   "\u0393",   "\u03c0",
    "\u03a3",   "\u03c3",   "\u00b5",   "\u03c4",
    "\u03a6",   "\u0398",   "\u03a9",   "\u03b4",
    "\u221e",   "\u03c6",   "\u03b5",   "\u2229",

    "\u2261",   "\u00b1",   "\u2265",   "\u2264",
    "\u2320",   "\u2321",   "\u00f7",   "\u2248",
    "\u00b0",   "\u2219",   "\u00b7",   "\u221a",
    "\u207f",   "\u00b2",   "\u25a0",   "\u00a0"
];

ткст cp437_to_utf8(ббайт[] s);

debug( UnitTest )
{
    unittest
    {
        ткст c(ткст s) { return cp437_to_utf8(cast(ббайт[]) s); }

        auto s = c("Hi there \x01 old \x0c!");
        assert( s == "Hi there \u263a old \u2640!", "\""~s~"\"" );
        s = c("Marker \x7f and divопрe \xf6.");
        assert( s == "Marker \u2302 and divопрe \u00f7.", "\""~s~"\"" );
    }
}

const сим[дим] utf8_to_cp437_map;

static this()
{
    utf8_to_cp437_map = [
        '\u0000': '\x00', '\u263a': '\x01', '\u263b': '\x02', '\u2665': '\x03',
        '\u2666': '\x04', '\u2663': '\x05', '\u2660': '\x06', '\u2022': '\x07',
        '\u25d8': '\x08', '\u25cb': '\x09', '\u25d9': '\x0a', '\u2642': '\x0b',
        '\u2640': '\x0c', '\u266a': '\x0d', '\u266b': '\x0e', '\u263c': '\x0f',

        '\u25b6': '\x10', '\u25c0': '\x11', '\u2195': '\x12', '\u203c': '\x13',
        '\u00b6': '\x14', '\u00a7': '\x15', '\u25ac': '\x16', '\u21a8': '\x17',
        '\u2191': '\x18', '\u2193': '\x19', '\u2192': '\x1a', '\u2190': '\x1b',
        '\u221f': '\x1c', '\u2194': '\x1d', '\u25b2': '\x1e', '\u25bc': '\x1f',

        /*
         * Printable ASCII range (well, most of it) is handled specially.
         */

        '\u00c7': '\x80', '\u00fc': '\x81', '\u00e9': '\x82', '\u00e2': '\x83',
        '\u00e4': '\x84', '\u00e0': '\x85', '\u00e5': '\x86', '\u00e7': '\x87',
        '\u00ea': '\x88', '\u00eb': '\x89', '\u00e8': '\x8a', '\u00ef': '\x8b',
        '\u00ee': '\x8c', '\u00ec': '\x8d', '\u00c4': '\x8e', '\u00c5': '\x8f',

        '\u00c9': '\x90', '\u00e6': '\x91', '\u00c6': '\x92', '\u00f4': '\x93',
        '\u00f6': '\x94', '\u00f2': '\x95', '\u00fb': '\x96', '\u00f9': '\x97',
        '\u00ff': '\x98', '\u00d6': '\x99', '\u00dc': '\x9a', '\u00f8': '\x9b',
        '\u00a3': '\x9c', '\u00a5': '\x9d', '\u20a7': '\x9e', '\u0192': '\x9f',

        '\u00e1': '\xa0', '\u00ed': '\xa1', '\u00f3': '\xa2', '\u00fa': '\xa3',
        '\u00f1': '\xa4', '\u00d1': '\xa5', '\u00aa': '\xa6', '\u00ba': '\xa7',
        '\u00bf': '\xa8', '\u2310': '\xa9', '\u00ac': '\xaa', '\u00bd': '\xab',
        '\u00bc': '\xac', '\u00a1': '\xad', '\u00ab': '\xae', '\u00bb': '\xaf',

        '\u2591': '\xb0', '\u2592': '\xb1', '\u2593': '\xb2', '\u2502': '\xb3',
        '\u2524': '\xb4', '\u2561': '\xb5', '\u2562': '\xb6', '\u2556': '\xb7',
        '\u2555': '\xb8', '\u2563': '\xb9', '\u2551': '\xba', '\u2557': '\xbb',
        '\u255d': '\xbc', '\u255c': '\xbd', '\u255b': '\xbe', '\u2510': '\xbf',

        '\u2514': '\xc0', '\u2534': '\xc1', '\u252c': '\xc2', '\u251c': '\xc3',
        '\u2500': '\xc4', '\u253c': '\xc5', '\u255e': '\xc6', '\u255f': '\xc7',
        '\u255a': '\xc8', '\u2554': '\xc9', '\u2569': '\xca', '\u2566': '\xcb',
        '\u2560': '\xcc', '\u2550': '\xcd', '\u256c': '\xce', '\u2567': '\xcf',

        '\u2568': '\xd0', '\u2564': '\xd1', '\u2565': '\xd2', '\u2559': '\xd3',
        '\u2558': '\xd4', '\u2552': '\xd5', '\u2553': '\xd6', '\u256b': '\xd7',
        '\u256a': '\xd8', '\u2518': '\xd9', '\u250c': '\xda', '\u2588': '\xdb',
        '\u2584': '\xdc', '\u258c': '\xdd', '\u2590': '\xde', '\u2580': '\xdf',

        '\u03b1': '\xe0', '\u00df': '\xe1', '\u0393': '\xe2', '\u03c0': '\xe3',
        '\u03a3': '\xe4', '\u03c3': '\xe5', '\u00b5': '\xe6', '\u03c4': '\xe7',
        '\u03a6': '\xe8', '\u0398': '\xe9', '\u03a9': '\xea', '\u03b4': '\xeb',
        '\u221e': '\xec', '\u03c6': '\xed', '\u03b5': '\xee', '\u2229': '\xef',

        '\u2261': '\xf0', '\u00b1': '\xf1', '\u2265': '\xf2', '\u2264': '\xf3',
        '\u2320': '\xf4', '\u2321': '\xf5', '\u00f7': '\xf6', '\u2248': '\xf7',
        '\u00b0': '\xf8', '\u2219': '\xf9', '\u00b7': '\xfa', '\u221a': '\xfb',
        '\u207f': '\xfc', '\u00b2': '\xfd', '\u25a0': '\xfe', '\u00a0': '\xff'
    ];
}

ббайт[] utf8_to_cp437(ткст s);

debug( UnitTest )
{
    unittest
    {
        alias cp437_to_utf8 x;
        alias utf8_to_cp437 y;

        ббайт[256] s;
        foreach( i,ref c ; s )
            c = i;

        auto a = x(s);
        auto b = y(a);
        if(!( b == s ))
        {
            // Display список of characters that неудачно в_ преобразуй as ожидалось,
            // and what значение we got.
            auto hex = "0123456789abcdef";
            auto сооб = "".dup;
            foreach( i,ch ; b )
            {
                if( ch != i )
                {
                    сооб ~= hex[i>>4];
                    сооб ~= hex[i&15];
                    сооб ~= " (";
                    сооб ~= hex[ch>>4];
                    сооб ~= hex[ch&15];
                    сооб ~= "), ";
                }
            }
            сооб ~= "неудачно.";

            assert( нет, сооб );
        }
    }
}

/*
 * This is here в_ simplify the код elsewhere.
 */
ткст utf8_to_utf8(ббайт[] s);
ббайт[] utf8_to_utf8(ткст s) ;

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//
// Date/время stuff

проц dosToTime(бкрат dostime, бкрат dosdate, out Время время);

проц timeToDos(Время время, out бкрат dostime, out бкрат dosdate);

// ************************************************************************** //
// ************************************************************************** //
// ************************************************************************** //

// Dependencies
private:

import io.device.Conduit : Провод;

/*******************************************************************************

    copyright:  Copyright © 2007 Daniel Keep.  все rights reserved.

    license:    BSD стиль: $(LICENSE)

    version:    Prerelease

    author:     Daniel Keep

*******************************************************************************/

//module tangox.io.поток.CounterПоток;

//import io.device.Conduit : Провод;
//import io.model : ИПровод, ИПотокВвода, ИПотокВывода;

/**
 * The counter поток classes are used в_ keep track of как many байты flow
 * through a поток.
 *
 * To use them, simply wrap it around an existing поток.  The число of байты
 * that have flowed through the wrapped поток may be использовался using the
 * счёт member.
 */
class ВводСоСчётом : ИПотокВвода
{
    ///
    this(ИПотокВвода ввод);

    override ИПровод провод();

    ИПотокВвода ввод();

    дол сместись (дол ofs, Якорь якорь = Якорь.Нач) ;

    override проц закрой();

    override т_мера читай(проц[] приёмн);

    override проц[] загрузи(т_мера max=-1);

    override ИПотокВвода слей();

    ///
    дол счёт();

private:
    ИПотокВвода источник;
    дол _count;
}

/// ditto
class ВыводСоСчётом : ИПотокВывода
{
    ///
    this(ИПотокВывода вывод);

    override ИПровод провод();

    ИПотокВывода вывод();

    дол сместись (дол ofs, Якорь якорь = Якорь.Нач) ;

    override проц закрой();

    override т_мера пиши(проц[] приёмн);

    override ИПотокВывода копируй(ИПотокВвода ист, т_мера max=-1);

    override ИПотокВывода слей();

  ///
    дол счёт() ;

private:
    ИПотокВывода сток;
    дол _count;
}

/*******************************************************************************

    copyright:  Copyright © 2007 Daniel Keep.  все rights reserved.

    license:    BSD стиль: $(LICENSE)

    version:    Prerelease

    author:     Daniel Keep

*******************************************************************************/

//module tangox.io.поток.SliceПоток;

//import io.device.Conduit : Провод;
//import io.model : ИПровод, ИПотокВвода, ИПотокВывода;

/**
 * This поток can be used в_ provопрe поток-based access в_ a поднабор of
 * другой поток.  It is akin в_ slicing an Массив.
 *
 * This поток fully supports seeking, and as such requires that the
 * underlying поток also support seeking.
 */
class SliceSeekInputПоток : ИПотокВвода
{
    //alias ИПровод.ИШаг.Якорь Якорь;

    /**
     * Create a new срез поток из_ the given источник, covering the контент
     * starting at позиция begin, for length байты.
     */
    this(ИПотокВвода источник, дол begin, дол length);

    override ИПровод провод();

    override проц закрой();

    override т_мера читай(проц[] приёмн);

    override проц[] загрузи(т_мера max=-1);

    override ИПотокВвода слей();

    ИПотокВвода ввод();

    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0);

private:
    ИПотокВвода источник;
    ИПотокВвода шагун;

    дол _position, begin, length;

    invariant
    {
        assert( cast(Объект) источник is cast(Объект) шагун );
        assert( begin >= 0 );
        assert( length >= 0 );
        assert( _position >= 0 );
    }
}

/**
 * This поток can be used в_ provопрe поток-based access в_ a поднабор of
 * другой поток.  It is akin в_ slicing an Массив.
 */
class SliceInputПоток : ИПотокВвода
{
    /**
     * Create a new срез поток из_ the given источник, covering the контент
     * starting at the current сместись позиция for length байты.
     */
    this(ИПотокВвода источник, дол length);

    override ИПровод провод();

    override проц закрой();

    ИПотокВвода ввод();

    дол сместись (дол ofs, Якорь якорь = Якорь.Нач);

    override т_мера читай(проц[] приёмн);

    override проц[] загрузи(т_мера max=-1);

    override ИПотокВвода слей();

private:
    ИПотокВвода источник;
    дол _length;

    invariant
    {
        if( _length > 0 ) assert( источник !is пусто );
    }
}

/**
 * This поток can be used в_ provопрe поток-based access в_ a поднабор of
 * другой поток.  It is akin в_ slicing an Массив.
 *
 * This поток fully supports seeking, and as such requires that the
 * underlying поток also support seeking.
 */
class SliceSeekOutputПоток : ИПотокВывода
{
    //alias ИПровод.ИШаг.Якорь Якорь;

    /**
     * Create a new срез поток из_ the given источник, covering the контент
     * starting at позиция begin, for length байты.
     */
    this(ИПотокВывода источник, дол begin, дол length);

    override ИПровод провод();

    override проц закрой();

    т_мера пиши(проц[] ист);

    override ИПотокВывода копируй(ИПотокВвода ист, т_мера max=-1);

    override ИПотокВывода слей();

    override ИПотокВывода вывод();

    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0);

private:
    ИПотокВывода источник;
    ИПотокВывода шагун;

    дол _position, begin, length;

    invariant
    {
        assert( cast(Объект) источник is cast(Объект) шагун );
        assert( begin >= 0 );
        assert( length >= 0 );
        assert( _position >= 0 );
    }
}

/*******************************************************************************

    copyright:  Copyright © 2007 Daniel Keep.  все rights reserved.

    license:    BSD стиль: $(LICENSE)

    version:    Prerelease

    author:     Daniel Keep

*******************************************************************************/

//module tangox.io.поток.WrapПоток;

//import io.device.Conduit : Провод;
//import io.model : ИПровод, ИПотокВвода, ИПотокВывода;

/**
 * This поток can be used в_ provопрe access в_ другой поток.
 * Its distinguishing feature is that users cannot закрой the underlying
 * поток.
 *
 * This поток fully supports seeking, and as such requires that the
 * underlying поток also support seeking.
 */
class WrapSeekInputПоток : ИПотокВвода
{
    //alias ИПровод.ИШаг.Якорь Якорь;

    /**
     * Create a new wrap поток из_ the given источник.
     */
    this(ИПотокВвода источник);

    /// ditto
    this(ИПотокВвода источник, дол позиция);

    override ИПровод провод();

    override проц закрой();

    override т_мера читай(проц[] приёмн);

    override проц[] загрузи(т_мера max=-1);

    override ИПотокВвода слей();

    ИПотокВвода ввод();

    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0);

private:
    ИПотокВвода источник;
    ИПотокВвода шагун;
    дол _position;

    invariant
    {
        assert( cast(Объект) источник is cast(Объект) шагун );
        assert( _position >= 0 );
    }
}

/**
 * This поток can be used в_ provопрe access в_ другой поток.
 * Its distinguishing feature is that the users cannot закрой the underlying
 * поток.
 *
 * This поток fully supports seeking, and as such requires that the
 * underlying поток also support seeking.
 */
class WrapSeekOutputПоток : ИПотокВывода
{
    //alias ИПровод.ИШаг.Якорь Якорь;

    /**
     * Create a new wrap поток из_ the given источник.
     */
    this(ИПотокВывода источник);

    /// ditto
    this(ИПотокВывода источник, дол позиция);

    override ИПровод провод();

    override проц закрой();

    т_мера пиши(проц[] ист);

    override ИПотокВывода копируй(ИПотокВвода ист, т_мера max=-1);

    override ИПотокВывода слей();

    override ИПотокВывода вывод();

    override дол сместись(дол смещение, Якорь якорь = cast(Якорь)0);

private:
    ИПотокВывода источник;
    ИПотокВывода шагун;
    дол _position;

    invariant
    {
        assert( cast(Объект) источник is cast(Объект) шагун );
        assert( _position >= 0 );
    }
}


