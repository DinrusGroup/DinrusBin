/*******************************************************************************

        copyright:      Copyright (c) 2008 Jeff Davey. все rights reserved

        license:        BSD стиль: $(LICENSE)

        author:         Jeff Davey

        standards:      rfc3548, rfc2045

        Since:          0.99.7

*******************************************************************************/

/*******************************************************************************

    This module is использован в_ раскодируй и кодируй base64 ткст массивы. 

    Example:
    ---
    ткст blah = "Hello there, my имя is Jeff.";
    scope encodebuf = new сим[вычислиРазмерКодир(cast(ббайт[])blah)];
    ткст кодирован = кодируй(cast(ббайт[])blah, encodebuf);

    scope decodebuf = new ббайт[кодирован.length];
    if (cast(ткст)раскодируй(кодирован, decodebuf) == "Hello there, my имя is Jeff.")
        Стдвыв("yay").нс;
    ---

*******************************************************************************/

module util.encode.Base64;

/*******************************************************************************

    calculates и returns the размер needed в_ кодируй the length of the 
    Массив passed.

    Параметры:
    данные = An Массив that will be кодирован

*******************************************************************************/


бцел вычислиРазмерКодир(ббайт[] данные);

/*******************************************************************************

    calculates и returns the размер needed в_ кодируй the length passed.

    Параметры:
    length = Число of байты в_ be кодирован

*******************************************************************************/

бцел вычислиРазмерКодир(бцел length);


/*******************************************************************************

    encodes данные преобр_в buff и returns the число of байты кодирован.
    this will not терминируй и pad any "leftover" байты, и will instead
    only кодируй up в_ the highest число of байты divisible by three.

    returns the число of байты left в_ кодируй

    Параметры:
    данные = что is в_ be кодирован
    buff = буфер large enough в_ hold кодирован данные
    bytesEncoded = ref that returns как much of the буфер was filled

*******************************************************************************/

цел кодируйЧанк(ббайт[] данные, ткст buff, ref цел bytesEncoded);

/*******************************************************************************

    encodes данные и returns as an ASCII base64 ткст.

    Параметры:
    данные = что is в_ be кодирован
    buff = буфер large enough в_ hold кодирован данные

    Example:
    ---
    сим[512] encodebuf;
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?", encodebuf);
    Стдвыв(myEncodedString).нс; // SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==
    ---


*******************************************************************************/

ткст кодируй(ббайт[] данные, ткст buff);

/*******************************************************************************

    encodes данные и returns as an ASCII base64 ткст.

    Параметры:
    данные = что is в_ be кодирован

    Example:
    ---
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?");
    Стдвыв(myEncodedString).нс; // SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==
    ---


*******************************************************************************/


ткст кодируй(ббайт[] данные);

/*******************************************************************************

    decodes an ASCCI base64 ткст и returns it as ббайт[] данные. Pre-allocates
    the размер of the Массив.

    This decoder will ignore non-base64 characters. So:
    SGVsbG8sIGhvd
    yBhcmUgeW91IH
    RvZGF5Pw==

    Is действителен.

    Параметры:
    данные = что is в_ be decoded

    Example:
    ---
    ткст myDecodedString = cast(ткст)раскодируй("SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==");
    Стдвыв(myDecodedString).нс; // Hello, как are you today?
    ---

*******************************************************************************/

ббайт[] раскодируй(ткст данные);

/*******************************************************************************

    decodes an ASCCI base64 ткст и returns it as ббайт[] данные.

    This decoder will ignore non-base64 characters. So:
    SGVsbG8sIGhvd
    yBhcmUgeW91IH
    RvZGF5Pw==

    Is действителен.

    Параметры:
    данные = что is в_ be decoded
    buff = a big enough Массив в_ hold the decoded данные

    Example:
    ---
    ббайт[512] decodebuf;
    ткст myDecodedString = cast(ткст)раскодируй("SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==", decodebuf);
    Стдвыв(myDecodedString).нс; // Hello, как are you today?
    ---

*******************************************************************************/
       
ббайт[] раскодируй(ткст данные, ббайт[] buff);

version (Test)
{
    import scrapple.util.Test;
    import io.device.File;
    import time.StopWatch;
    import io.Stdout;

    unittest    
    {
        Test.Status encodeЧанкtest(ref ткст[] messages)
        {
            ткст стр = "Hello, как are you today?";
            ткст кодирован = new сим[вычислиРазмерКодир(cast(ббайт[])стр)];
            цел bytesEncoded = 0;
            цел numBytesLeft = кодируйЧанк(cast(ббайт[])стр, кодирован, bytesEncoded);
            ткст результат = кодирован[0..bytesEncoded] ~ кодируй(cast(ббайт[])стр[numBytesLeft..$], кодирован[bytesEncoded..$]);
            if (результат == "SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==")
                return Test.Status.Success;
            return Test.Status.Failure;
        }
        Test.Status encodeTest(ref ткст[] messages)
        {
            ткст кодирован = new сим[вычислиРазмерКодир(cast(ббайт[])"Hello, как are you today?")];
            ткст результат = кодируй(cast(ббайт[])"Hello, как are you today?", кодирован);
            if (результат == "SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==")
            {
                ткст result2 = кодируй(cast(ббайт[])"Hello, как are you today?");
                if (результат == "SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==")
                    return Test.Status.Success;
            }

            return Test.Status.Failure;
        }

        Test.Status decodeTest(ref ткст[] messages)
        {
            ббайт[1024] decoded;
            ббайт[] результат = раскодируй("SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==", decoded);
            if (результат == cast(ббайт[])"Hello, как are you today?")
            {
                результат = раскодируй("SGVsbG8sIGhvdyBhcmUgeW91IHRvZGF5Pw==");
                if (результат == cast(ббайт[])"Hello, как are you today?")
                    return Test.Status.Success;
            }
            return Test.Status.Failure;
        }
        
        Test.Status speedTest(ref ткст[] messages)
        {
            Стдвыв("Reading...").нс;
            ткст данные = cast(ткст)Файл.получи ("blah.b64");
            ббайт[] результат = new ббайт[данные.length];
            auto t1 = new Секундомер();
            Стдвыв("Decoding..").нс;
            t1.старт();
            бцел runs = 100000000;
            for (бцел i = 0; i < runs; i++)
                раскодируй(данные, результат);
            дво blah = t1.stop();
            Стдвыв.форматнс("Decoded {} MB in {} сек at {} MB/s", cast(дво)(cast(дво)(данные.length * runs) / 1024 / 1024), blah, (cast(дво)(данные.length * runs)) / 1024 / 1024 / blah );
            return Test.Status.Success;
        }

        Test.Status speedTest2(ref ткст[] messages)
        {
            Стдвыв("Reading...").нс;
//            ббайт[] данные = cast(ббайт[])FileData("blah.txt").читай;
            ббайт[] данные = cast(ббайт[])"I am a small ткст, Wee...";
            ткст результат = new сим[вычислиРазмерКодир(данные)];
            auto t1 = new Секундомер();
            бцел runs = 100000000;
            Стдвыв("Кодировка..").нс;
            t1.старт();
            for (бцел i = 0; i < runs; i++)
                кодируй(данные, результат);
            дво blah = t1.stop();
            Стдвыв.форматнс("Encoded {} MB in {} сек at {} MB/s", cast(дво)(cast(дво)(данные.length * runs) / 1024 / 1024), blah, (cast(дво)(данные.length * runs)) / 1024 / 1024 / blah );
            return Test.Status.Success;
        }

        auto t = new Test("util.encode.Base64");
        t["Encode"] = &encodeTest;
        t["Encode Поток"] = &encodeЧанкtest;
        t["Decode"] = &decodeTest;
//        t["Speed"] = &speedTest;
//        t["Speed2"] = &speedTest2;
        t.run();
    }
}

