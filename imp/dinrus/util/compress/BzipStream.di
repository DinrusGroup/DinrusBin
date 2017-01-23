/*******************************************************************************

    copyright:  Copyright (C) 2007 Daniel Keep.  все rights reserved.

    license:    BSD стиль: $(LICENSE)

    version:    Initial release: July 2007

    author:     Daniel Keep

*******************************************************************************/

module util.compress.BzipStream;

private import lib.bzlib;

private import exception : ВВИскл;

private import io.device.Conduit : ФильтрВвода, ФильтрВывода;

private import io.model : ИПотокВвода, ИПотокВывода, ИПровод;

private
{
    /* This constant controls the размер of the ввод/вывод buffers we use
     * internally.  There's no particular резон в_ pick this размер.  It might
     * be an опрea в_ run some benchmarks в_ work out what a good число is.
     */
    const BUFFER_SIZE = 4*1024;

    const DEFAULT_BLOCKSIZE = 9;
    const DEFAULT_WORKFACTOR = 0;
}

/*******************************************************************************
  
    This вывод фильтр can be used в_ perform compression of данные преобр_в a bzip2
    поток.

*******************************************************************************/

class БзипВывод : ФильтрВывода
{
    /***************************************************************************

        This enumeration represents several pre-defined compression block
        sizes, measured in hundreds of kilobytes.  See the documentation for
        the БзипВывод class' constructor for ещё details.

    ***************************************************************************/

    enum РазмерБлока : цел
    {
        Нормальный = 9,
        Быстрый = 1,
        Наилучший = 9,
    }

    private
    {
        бул bzs_valid = нет;
        bz_stream bzs;
        ббайт[] out_chunk;
        т_мера _written = 0;
    }

    /***************************************************************************

        Constructs a new bzip2 compression фильтр.  You need в_ пароль in the
        поток that the compression фильтр will пиши в_.  If you are using
        this фильтр with a провод, the опрiom в_ use is:

        ---
        auto вывод = new БзипВывод(myConduit.вывод);
        вывод.пиши(myContent);
        ---

        размерБлока relates в_ the размер of the window bzip2 uses when
        compressing данные and determines как much память is required в_
        decompress a поток.  It is measured in hundreds of kilobytes.
        
        ccording в_ the bzip2 documentation, there is no dramatic difference
        between the various block sizes, so the default should suffice in most
        cases.

        РазмерБлока.Нормальный (the default) is the same as РазмерБлока.Наилучший
        (or 9).  The размерБлока may be any целое between 1 and 9 включительно.

    ***************************************************************************/

    this(ИПотокВывода поток, цел размерБлока = РазмерБлока.Нормальный)
    {
        if( размерБлока < 1 || размерБлока > 9 )
            throw new ИсключениеБзип("размер блока bzip2 должен находиться между"
                    " 1 и 9");

        super(поток);
        out_chunk = new ббайт[BUFFER_SIZE];
        
        auto возвр = BZ2_bzCompressInit(&bzs, размерБлока, 0, DEFAULT_WORKFACTOR);
        if( возвр != BZ_OK )
            throw new ИсключениеБзип(возвр);

        bzs_valid = да;
    }

    ~this()
    {
        if( bzs_valid )
            kill_bzs();
    }

    /***************************************************************************

        Compresses the given данные в_ the underlying провод.

        Returns the число of байты из_ ист that were compressed, which may
        be less than given.

    ***************************************************************************/

    т_мера пиши(проц[] ист)
    {
        проверьГожесть();
        scope(failure) kill_bzs();

        bzs.avail_in = ист.length;
        bzs.next_in = cast(ббайт*)ист.ptr;

        do
        {
            bzs.avail_out = out_chunk.length;
            bzs.next_out = out_chunk.ptr;

            auto возвр = BZ2_bzCompress(&bzs, BZ_RUN);
            if( возвр != BZ_RUN_OK )
                throw new ИсключениеБзип(возвр);

            // Push the compressed байты out в_ the поток, until it's either
            // записано them все, or choked.
            auto have = out_chunk.length-bzs.avail_out;
            auto out_buffer = out_chunk[0..have];
            do
            {
                auto w = сток.пиши(out_buffer);
                if( w == ИПровод.Кф )
                    return w;

                out_buffer = out_buffer[w..$];
                _written += w;
            }
            while( out_buffer.length > 0 );
        }
        // Loop while we are still using up the whole вывод буфер
        while( bzs.avail_out == 0 );

        assert( bzs.avail_in == 0, "не удалось сжатие предоставленных данных" );

        return ист.length;
    }

    /***************************************************************************

        This читай-only property returns the число of compressed байты that
        have been записано в_ the underlying поток.  Following a вызов в_
        either закрой or подай, this will contain the total compressed размер of
        the ввод данные поток.

    ***************************************************************************/

    т_мера записано()
    {
        return _written;
    }

    /***************************************************************************

        подай the вывод

    ***************************************************************************/

    проц закрой()
    {
        if( bzs_valid ) подай;
        super.закрой;
    }

    /***************************************************************************

        Purge any buffered контент.  Calling this will implicitly конец the
        bzip2 поток, so it should not be called until you are завершено
        compressing данные.  Any calls в_ either пиши or подай after a
        compression фильтр есть been committed will throw an исключение.

    ***************************************************************************/

    проц подай()
    {
        проверьГожесть();
        scope(failure) kill_bzs();

        bzs.avail_in = 0;
        bzs.next_in = пусто;

        бул завершено = нет;

        do
        {
            bzs.avail_out = out_chunk.length;
            bzs.next_out = out_chunk.ptr;

            auto возвр = BZ2_bzCompress(&bzs, BZ_FINISH);
            switch( возвр )
            {
                case BZ_FINISH_OK:
                    break;

                case BZ_STREAM_END:
                    завершено = да;
                    break;

                default:
                    throw new ИсключениеБзип(возвр);
            }

            auto have = out_chunk.length - bzs.avail_out;
            auto out_buffer = out_chunk[0..have];
            if( have > 0 )
            {
                do
                {
                    auto w = сток.пиши(out_buffer);
                    if( w == ИПровод.Кф )
                        return;

                    out_buffer = out_buffer[w..$];
                    _written += w;
                }
                while( out_buffer.length > 0 );
            }
        }
        while( !завершено );

        kill_bzs();
    }

    // This function kills the поток: it deallocates the internal состояние, and
    // unsets the bzs_valid flag.
    private проц kill_bzs()
    {
        проверьГожесть();

        BZ2_bzCompressEnd(&bzs);
        bzs_valid = нет;
    }

    // Asserts that the поток is still valid and usable (except that this
    // check doesn't получи elопрed with -release).
    private проц проверьГожесть()
    {
        if( !bzs_valid )
            throw new ИсклЗакрытБзип;
    }
}

/*******************************************************************************
  
    This ввод фильтр can be used в_ perform decompression of bzip2 Потокs.

*******************************************************************************/

class БзипВвод : ФильтрВвода
{
    private
    {
        бул bzs_valid = нет;
        bz_stream bzs;
        ббайт[] in_chunk;
    }

    /***************************************************************************

        Constructs a new bzip2 decompression фильтр.  You need в_ пароль in the
        поток that the decompression фильтр will читай из_.  If you are using
        this фильтр with a провод, the опрiom в_ use is:

        ---
        auto ввод = new БзипВвод(myConduit.ввод);
        ввод.читай(myContent);
        ---

        The small аргумент, if установи в_ да, instructs bzip2 в_ perform
        decompression using half the regular amount of память, at the cost of
        running at half скорость.

    ***************************************************************************/

    this(ИПотокВвода поток, бул small=нет)
    {
        super(поток);
        in_chunk = new ббайт[BUFFER_SIZE];

        auto возвр = BZ2_bzDecompressInit(&bzs, 0, small?1:0);
        if( возвр != BZ_OK )
            throw new ИсключениеБзип(возвр);

        bzs_valid = да;
    }

    ~this()
    {
        if( bzs_valid )
            kill_bzs();
    }

    /***************************************************************************

        Decompresses данные из_ the underlying провод преобр_в a мишень Массив.

        Returns the число of байты stored преобр_в приёмн, which may be less than
        requested.

    ***************************************************************************/ 

    т_мера читай(проц[] приёмн)
    {
        if( !bzs_valid )
            return ИПровод.Кф;

        scope(failure) kill_bzs();

        бул завершено = нет;

        bzs.avail_out = приёмн.length;
        bzs.next_out = cast(ббайт*)приёмн.ptr;

        do
        {
            if( bzs.avail_in == 0 )
            {
                auto длин = источник.читай(in_chunk);
                if( длин == ИПровод.Кф )
                    return ИПровод.Кф;

                bzs.avail_in = длин;
                bzs.next_in = in_chunk.ptr;
            }

            auto возвр = BZ2_bzDecompress(&bzs);
            if( возвр == BZ_STREAM_END )
            {
                kill_bzs();
                завершено = да;
            }
            else if( возвр != BZ_OK )
                throw new ИсключениеБзип(возвр);
        }
        while( !завершено && bzs.avail_out > 0 );

        return приёмн.length - bzs.avail_out;
    }

    /***************************************************************************

        Clear any buffered контент.  No-op.

    ***************************************************************************/ 

    override ИПотокВвода слей()
    {
        проверьГожесть();

        // TODO: What should this метод do?  We don't do any куча allocation,
        // so there's really nothing в_ сотри...  For сейчас, just invalidate the
        // поток...
        kill_bzs();
        super.слей();
        return this;
    }

    // This function kills the поток: it deallocates the internal состояние, and
    // unsets the bzs_valid flag.
    private проц kill_bzs()
    {
        проверьГожесть();

        BZ2_bzDecompressEnd(&bzs);
        bzs_valid = нет;
    }

    // Asserts that the поток is still valid and usable (except that this
    // check doesn't получи elопрed with -release).
    private проц проверьГожесть()
    {
        if( !bzs_valid )
            throw new ИсклЗакрытБзип;
    }
}

/*******************************************************************************
  
    This исключение is thrown when an ошибка occurs in the underlying bzip2
    library.

*******************************************************************************/

class ИсключениеБзип : ВВИскл
{
    this(in цел код)
    {
        super(имяКода(код));
    }

    this(ткст сооб)
    {
        super(сооб);
    }

    private ткст имяКода(in цел код)
    {
        ткст имя;

        switch( код )
        {
            case BZ_OK:                 имя = "BZ_OK";                 break;
            case BZ_RUN_OK:             имя = "BZ_RUN_OK";             break;
            case BZ_FLUSH_OK:           имя = "BZ_FLUSH_OK";           break;
            case BZ_STREAM_END:         имя = "BZ_STREAM_END";         break;
            case BZ_SEQUENCE_ERROR:     имя = "BZ_SEQUENCE_ERROR";     break;
            case BZ_PARAM_ERROR:        имя = "BZ_PARAM_ERROR";        break;
            case BZ_MEM_ERROR:          имя = "BZ_MEM_ERROR";          break;
            case BZ_DATA_ERROR:         имя = "BZ_DATA_ERROR";         break;
            case BZ_DATA_ERROR_MAGIC:   имя = "BZ_DATA_ERROR_MAGIC";   break;
            case BZ_IO_ERROR:           имя = "BZ_IO_ERROR";           break;
            case BZ_UNEXPECTED_EOF:     имя = "BZ_UNEXPECTED_EOF";     break;
            case BZ_OUTBUFF_FULL:       имя = "BZ_OUTBUFF_FULL";       break;
            case BZ_CONFIG_ERROR:       имя = "BZ_CONFIG_ERROR";       break;
            default:                    имя = "BZ_UNKNOWN";
        }

        return имя;
    }
}

/*******************************************************************************
  
    This исключение is thrown if you attempt в_ perform a читай, пиши or слей
    operation on a закрыт bzip2 фильтр поток.  This can occur if the ввод
    поток есть завершено, or an вывод поток was flushed.

*******************************************************************************/

class ИсклЗакрытБзип : ВВИскл
{
    this()
    {
        super("невозможна работа с закрытым потоком bzip2");
    }
}

/* *****************************************************************************

    This section содержит a simple unit тест for this module.  It is скрытый
    behind a version statement because it introduces добавьitional dependencies.

***************************************************************************** */

debug(UnitTest):

import io.device.Array : Массив;

unittest
{
    const ткст сообщение =
        "all dwarfs are by nature dutiful, serious, literate, obedient "
        "and thoughtful people whose only minor failing is a tendency, "
        "after one drink, to rush at enemies screaming \"Arrrrrrgh!\" and "
        "axing their legs off at the knee.";

    const ббайт[] message_z = [
        0x42, 0x5a, 0x68, 0x39, 0x31, 0x41, 0x59, 0x26,
        0x53, 0x59, 0x40, 0x98, 0xbe, 0xaa, 0x00, 0x00,
        0x16, 0xd5, 0x80, 0x10, 0x00, 0x70, 0x05, 0x20,
        0x00, 0x3f, 0xef, 0xde, 0xe0, 0x30, 0x00, 0xac,
        0xd8, 0x8a, 0x3d, 0x34, 0x6a, 0x6d, 0x4c, 0x4f,
        0x24, 0x31, 0x0d, 0x08, 0x98, 0x9b, 0x48, 0x9a,
        0x7a, 0x80, 0x00, 0x06, 0xa6, 0xd2, 0xa7, 0xe9,
        0xaa, 0x37, 0xa8, 0xd4, 0xf5, 0x3f, 0x54, 0x63,
        0x51, 0xe9, 0x2d, 0x4b, 0x99, 0xe1, 0xcc, 0xca,
        0xda, 0x75, 0x04, 0x42, 0x14, 0xc8, 0x6a, 0x8e,
        0x23, 0xc1, 0x3e, 0xb1, 0x8a, 0x16, 0xd2, 0x55,
        0x9a, 0x3e, 0x56, 0x1a, 0xb1, 0x83, 0x11, 0xa6,
        0x50, 0x4f, 0xd3, 0xed, 0x21, 0x40, 0xaa, 0xd1,
        0x95, 0x2c, 0xda, 0xcb, 0xb7, 0x0e, 0xce, 0x65,
        0xfc, 0x63, 0xf2, 0x88, 0x5b, 0x36, 0xda, 0xf0,
        0xf5, 0xd2, 0x9c, 0xe6, 0xf1, 0x87, 0x12, 0x87,
        0xce, 0x56, 0x0c, 0xf5, 0x65, 0x4d, 0x2e, 0xd6,
        0x27, 0x61, 0x2b, 0x74, 0xcd, 0x5e, 0x3b, 0x02,
        0x42, 0x4e, 0x0b, 0x80, 0xa8, 0x70, 0x04, 0x48,
        0xfb, 0x93, 0x4c, 0x41, 0xa8, 0x2a, 0xdf, 0xf2,
        0x67, 0x37, 0x28, 0xad, 0x38, 0xd4, 0x5c, 0xd6,
        0x34, 0x8b, 0x49, 0x5e, 0x90, 0xb2, 0x06, 0xce,
        0x0a, 0x83, 0x29, 0x84, 0x20, 0xd7, 0x5f, 0xc5,
        0xdc, 0x91, 0x4e, 0x14, 0x24, 0x10, 0x26, 0x2f,
        0xaa, 0x80];

    scope cond = new Массив(1024, 1024);
    scope comp = new БзипВывод(cond);
    comp.пиши(сообщение);
    comp.закрой;

    assert( comp.записано == message_z.length );

    assert( message_z == cast(ббайт[])(cond.срез) );

    scope decomp = new БзипВвод(cond);
    auto буфер = new ббайт[256];
    буфер = буфер[0 .. decomp.читай(буфер)];

    assert( cast(ббайт[])сообщение == буфер );
}

