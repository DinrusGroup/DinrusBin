/*******************************************************************************

        copyright:      Copyright (c) 2008 Jeff Davey. все rights reserved

        license:        BSD стиль: $(LICENSE)

        author:         Jeff Davey <j@submersion.com>

*******************************************************************************/

module net.device.SSLSocket;

private import net.PKI;

private import net.device.Socket;

private import lib.OpenSSL;

/*******************************************************************************
    
    СокетССЛ is a подст-class of Сокет. It's purpose is в_
    provопрe SSL encryption at the сокет уровень as well as easily fit преобр_в
    existing Dinrus network applications that may already be using Сокет.

    СокетССЛ требует the OpenSSL library, и uses a dynamic binding
    в_ the library. You can найди the library at http://www.openssl.org и a
    Win32 specific порт at http://www.slproweb.com/products/Win32OpenSSL.html.

    SSLСОКЕТs have two modes:

    1. Client режим, useful for connecting в_ existing servers, but not
    accepting new connections. Accepting a new connection will cause 
    the library в_ stall on a пиши on connection.

    2. Сервер режим, useful for creating an SSL сервер, but not connecting
    в_ an existing сервер. Подключение will cause the library в_ stall on a 
    читай on connection.

    Example SSL клиент
    ---
    auto s = new СокетССЛ;
    if (s.подключись("www.yahoo.com", 443))
    {
        сим[1024] buff;

        s.пиши("GET / HTTP/1.0\r\n\r\n");
        auto bytesRead = s.читай(buff);
        if (bytesRead != s.Кф)
            Стдвыв.форматнс("Приёмd: {}", buff[0..bytesRead]);
    }
    ---

*******************************************************************************/

class СокетССЛ : Сокет
{
    protected BIO *сокетССЛ = пусто;
    protected КонтекстССЛ кнткстССЛ = пусто;
/+
    private бул таймаут;
    private НаборСокетов readSet;
    private НаборСокетов writeSet;
+/
    /*******************************************************************************

        Созд a default Client Mode СокетССЛ.

    *******************************************************************************/

    override this (бул конфиг = да)
    {
        super();

        if (конфиг)
            установиКонтекст (new КонтекстССЛ, да);
    }

/+
    /*******************************************************************************

        Creates a Client Mode СокетССЛ

        This is overrопрing the Сокет ctor in order в_ emulate the 
        existing free-список frameowrk.

        Specifying anything другой than ППротокол.ПУТ or ПТипСок.Поток will
        cause an Исключение в_ be thrown.

    *******************************************************************************/

    override this(ПТипСок тип, ППротокол протокол)
    {
        if (протокол != ППротокол.ПУТ)
            throw new Исключение("SSL is only supported over ПУТ.");
        if (тип != ПТипСок.Поток)
            throw new Исключение("SSL is only supporting with Потокing типы.");
        super(ПСемействоАдресов.ИНЕТ, тип, протокол); // hardcoding this в_ ИНЕТ for сейчас
        //if (создай)
        {
            кнткстССЛ = new КонтекстССЛ();
            сокетССЛ = _convertToSSL(кнткстССЛ, нет, да);
        }
    }

    /*******************************************************************************

        Creates a СокетССЛ

        This class allows the ability в_ turn a regular Сокет преобр_в an
        СокетССЛ. It also gives the ability в_ change an СокетССЛ 
        преобр_в Сервер Mode or ClientMode.

        Параметры:
            сок = The сокет в_ wrap in SSL
            КонтекстССЛ = the SSL Контекст as provопрed by the PKI layer.
            режимКлиента = if да the сокет will be Client Mode, Сервер otherwise.

    *******************************************************************************/


    this(Сокет сок, КонтекстССЛ ctx, бул режимКлиента = да)
    {
        super(ПСемействоАдресов.ИНЕТ, ПТипСок.Поток, ППротокол.ПУТ, нет); // hardcoding в_ inet сейчас
        сокет_ = сок;
        кнткстССЛ = ctx;
        сокетССЛ = _convertToSSL(кнткстССЛ, нет, режимКлиента);
    }

    ~this()
    {
        if (сокетССЛ)
        {
            BIO_reset(сокетССЛ);
            BIO_free_all(сокетССЛ);
            сокетССЛ = пусто;
        }
    }
+/

    /*******************************************************************************

        Release this СокетССЛ. 
        
        As per Сокет.открепи.

    *******************************************************************************/

    override проц открепи();

    /*******************************************************************************

        Writes the passed буфер в_ the underlying сокет поток. This will
        блок until сокет ошибка.

        As per Сокет.пиши

    *******************************************************************************/

    override т_мера пиши(проц[] ист);

    /*******************************************************************************

         Reads из_ the underlying сокет поток. If needed, установиТаймаут will 
        установи the max length of время the читай will возьми before returning.

        As per Сокет.читай

    *******************************************************************************/


    override т_мера читай(проц[] приёмн);

    /*******************************************************************************

        Shuts down the underlying сокет for reading и writing.

        As per Сокет.глуши

    *******************************************************************************/

    override СокетССЛ глуши();
	
    /*******************************************************************************

        Used in conjuction with the above ctor with the создай флаг disabled. It is
        useful for accepting a new сокет преобр_в a СокетССЛ, и then re-using
        the Сервер's existing КонтекстССЛ.
    
        Параметры:
            ctx = КонтекстССЛ class as provопрed by PKI
            режимКлиента = if да, the сокет will be in Client Mode, Сервер otherwise.

    *******************************************************************************/


    проц установиКонтекст(КонтекстССЛ ctx, бул режимКлиента = да);

    /*
        Converts an existing сокет (should be ПУТ) в_ an "SSL" сокет
        закрой = закрой the сокет when завершено -- should probably be нет usually
        клиент = if да, "клиент-режим" if нет "сервер-режим"
    */
    private BIO *_convertToSSL(КонтекстССЛ кнткстССЛ, бул закрой, бул клиент);
}


/*******************************************************************************

    СерверСокетССЛ is a подст-class of СерверСокет. It's purpose is в_ provопрe
    SSL encryption at the сокет уровень as well as easily tie преобр_в existing 
    Dinrus applications that may already be using СерверСокет.

    СерверСокетССЛ требует the OpenSSL library, и uses a dynamic binding
    в_ the library. You can найди the library at http://www.openssl.org и a
    Win32 specific порт at http://www.slproweb.com/products/Win32OpenSSL.html.

    Example SSL сервер
    ---
    auto серт = new Сертификат(cast(ткст)Файл.получи("public.pem"));
    auto pkey = new ЧастныйКлюч(cast(ткст)Файл.получи("private.pem"));
    auto ctx = new КонтекстССЛ;
    ctx.сертификат(серт).частныйКлюч(pkey);
    auto сервер = new СерверСокетССЛ(443, ctx);
    for(;;)
    {
        auto sc = сервер.прими;
        sc.пиши("HTTP/1.1 200\r\n\r\n<b>Hello World</b>");
        sc.глуши.закрой;
    }
    ---

*******************************************************************************/

class СерверСокетССЛ : СерверСокет
{
    private КонтекстССЛ кнткстССЛ;

    /*******************************************************************************

    *******************************************************************************/

    this (бкрат порт, КонтекстССЛ ctx, цел backlog=32, бул reuse=нет);

    /*******************************************************************************

        Constructs a new СерверСокетССЛ. This constructor is similar в_ 
        СерверСокет, except it takes a КонтекстССЛ as provопрed by PKI.

        Параметры:
            адр = the адрес в_ вяжи и слушай on.
            ctx = the provопрed КонтекстССЛ
            backlog = the число of connections в_ backlog before refusing connection
            reuse = if включен, allow rebinding of existing ИП/порт

    *******************************************************************************/

    this(адрес адр, КонтекстССЛ ctx, цел backlog=32, бул reuse=нет);

    /*******************************************************************************

      Accepts a new conection и copies the provопрed сервер КонтекстССЛ в_ a new
      СокетССЛ.

    *******************************************************************************/

    СокетССЛ прими (СокетССЛ реципиент = пусто);
}





version(Test)
{
    import tetra.util.Test; 
    import io.Stdout;
    import io.device.File;
    import io.FilePath;
    import thread;
    import stringz;

    extern (C)
    {
        цел blah(цел booger, проц *x)
        {
            return 1;
        }
    }


    unittest
    {
        auto t2 = 1.0;
        loadOpenSSL();
        Test.Status sslCTXTest(ref ткст[] messages)
        {
            auto s1 = new СокетССЛ();
            if (s1)
            {
                бул good = нет;
                try
                    auto s2 = new СокетССЛ(ПТипСок.Поток,  ППротокол.ППД);
                catch (Исключение e)
                    good = да;

                if (good)
                {
                    Сокет mySock = new Сокет(ПСемействоАдресов.ИНЕТ, ПТипСок.Поток, ППротокол.ПУТ);
                    if (mySock)
                    {
                        Сертификат publicCertificate;
                        ЧастныйКлюч частныйКлюч;
                        try
                        {
                            publicCertificate = new Сертификат(cast(ткст)Файл.получи ("public.pem")); 
                            частныйКлюч = new ЧастныйКлюч(cast(ткст)Файл.получи ("private.pem"));
                        }                        
                        catch (Исключение ex)
                        {
                            частныйКлюч = new ЧастныйКлюч(2048);
                            publicCertificate = new Сертификат();
                            publicCertificate.частныйКлюч(частныйКлюч).серийныйНомер(123).смещениеКДатеДо(t1).смещениеКДатеПосле(t2);
                            publicCertificate.установиСубъект("CA", "Alberta", "Place", "Нет", "First Last", "no unit", "email@example.com").знак(publicCertificate, частныйКлюч);
                        }                        
                        auto кнткстССЛ = new КонтекстССЛ();
                        кнткстССЛ.сертификат(publicCertificate).частныйКлюч(частныйКлюч).проверьКлюч();
                        auto s3 = new СокетССЛ(mySock, кнткстССЛ);
                        if (s3)
                            return Test.Status.Success;
                    }
                }
            }
            return Test.Status.Failure;
        }

        Test.Status sslReadWriteTest(ref ткст[] messages)
        {
            auto s1 = new СокетССЛ();
            auto адрес = new АдресИПв4("209.20.65.224", 443);
            if (s1.подключись(адрес))
            {
                ткст команда = "GET /результат.txt\r\n";
                s1.пиши(команда);
                сим[1024] результат;
                бцел bytesRead = s1.читай(результат);
                if (bytesRead > 0 && bytesRead != Кф && (результат[0 .. bytesRead] == "I got results!\n"))
                    return Test.Status.Success;
                else
                    messages ~= Стдвыв.выкладка()("Приёмd wrong results: (bytesRead: {}), (результат: {})", bytesRead, результат[0..bytesRead]);
            }
            return Test.Status.Failure;
        }

        Test.Status sslReadWriteTestWithTimeout(ref ткст[] messages)
        {
            auto s1 = new СокетССЛ();
            auto адрес = new АдресИПв4("209.20.65.224", 443);
            if (s1.подключись(адрес))
            {
                ткст команда = "GET /результат.txt HTTP/1.1\r\nHost: submersion.com\r\n\r\n";
                s1.пиши(команда);
                сим[1024] результат;
                бцел bytesRead = s1.читай(результат);
                ткст expectedResult = "HTTP/1.1 200 ОК";
                if (bytesRead > 0 && bytesRead != Кф && (результат[0 .. expectedResult.length] == expectedResult))
                {
                    s1.установиТаймаут(t2);
                    while (bytesRead != s1.Кф)
                        bytesRead = s1.читай(результат);                
                    if (s1.былТаймаут)
                        return Test.Status.Success;
                    else
                        messages ~= Стдвыв.выкладка()("Dопр not получи таймаут on читай: {}", bytesRead);
                }
                else
                    messages ~= Стдвыв.выкладка()("Приёмd wrong results: (bytesRead: {}), (результат: {})", bytesRead, результат[0..bytesRead]);
            }
            return Test.Status.Failure;    
        }

        auto t = new Test("tetra.net.СокетССЛ");
        t["SSL_CTX"] = &sslCTXTest;
        t["Чит/Зап"] = &sslReadWriteTest;
        t["Чит/Зап Timeout"] = &sslReadWriteTestWithTimeout; 
        t.run();
    }
}
