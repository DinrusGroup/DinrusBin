/*******************************************************************************

        copyright:      Copyright (c) 2010 Ulrik Mikaelsson. все rights reserved

        license:        BSD стиль: $(LICENSE)

        author:         Ulrik Mikaelsson

        standards:      rfc3548, rfc4648

*******************************************************************************/

/*******************************************************************************

    This module is использован в_ раскодируй и кодируй hex ткст массивы.

    Example:
    ---
    ткст blah = "Hello there, my имя is Jeff.";

    scope encodebuf = new сим[вычислиРазмерКодир(cast(ббайт[])blah)];
    ткст кодирован = кодируй(cast(ббайт[])blah, encodebuf);

    scope decodebuf = new ббайт[кодирован.length];
    if (cast(ткст)раскодируй(кодирован, decodebuf) == "Hello there, my имя is Jeff.")
        Стдвыв("yay").нс;
    ---

    Since v1.0

*******************************************************************************/

module util.encode.Base16;

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

бцел вычислиРазмерКодир(бцел длина);


/*******************************************************************************

    encodes данные и returns as an ASCII hex ткст.

    Параметры:
    данные = что is в_ be кодирован
    buff = буфер large enough в_ hold кодирован данные

    Example:
    ---
    сим[512] encodebuf;
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?", encodebuf);
    Стдвыв(myEncodedString).нс; // 48656C6C6F2C20686F772061726520796F7520746F6461793F
    ---


*******************************************************************************/

ткст кодируй(ббайт[] данные, ткст буф);

/*******************************************************************************

    encodes данные и returns as an ASCII hex ткст.

    Параметры:
    данные = что is в_ be кодирован

    Example:
    ---
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?");
    Стдвыв(myEncodedString).нс; // 48656C6C6F2C20686F772061726520796F7520746F6461793F
    ---


*******************************************************************************/


ткст кодируй(ббайт[] данные);

/*******************************************************************************

    decodes an ASCII hex ткст и returns it as ббайт[] данные. Pre-allocates
    the размер of the Массив.

    This decoder will ignore non-hex characters. So:
    SGVsbG8sIGhvd
    yBhcmUgeW91IH
    RvZGF5Pw==

    Is действителен.

    Параметры:
    данные = что is в_ be decoded

    Example:
    ---
    ткст myDecodedString = cast(ткст)раскодируй("48656C6C6F2C20686F772061726520796F7520746F6461793F");
    Стдвыв(myDecodeString).нс; // Hello, как are you today?
    ---

*******************************************************************************/

ббайт[] раскодируй(ткст данные);
}

/*******************************************************************************

    decodes an ASCII hex ткст и returns it as ббайт[] данные.

    This decoder will ignore non-hex characters. So:
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
    ткст myDecodedString = cast(ткст)раскодируй("48656C6C6F2C20686F772061726520796F7520746F6461793F", decodebuf);
    Стдвыв(myDecodeString).нс; // Hello, как are you today?
    ---

*******************************************************************************/

ббайт[] раскодируй(ткст данные, ббайт[] буф);


debug (UnitTest)
{
    unittest
    {
        static ткст[] testНеобр = [
            "",
            "A",
            "AB",
            "BAC",
            "BACD",
            "Hello, как are you today?",
            "AbCdEfGhIjKlMnOpQrStUvXyZ",
        ];
        static ткст[] testEnc = [
            "",
            "41",
            "4142",
            "424143",
            "42414344",
            "48656C6C6F2C20686F772061726520796F7520746F6461793F",
            "4162436445664768496A4B6C4D6E4F7051725374557658795A",
        ];

        for (т_мера i; i < testНеобр.length; i++) {
            auto resultChars = кодируй(cast(ббайт[])testНеобр[i]);
            assert(resultChars == testEnc[i],
                    testНеобр[i]~": ("~resultChars~") != ("~testEnc[i]~")");

            auto resultBytes = раскодируй(testEnc[i]);
            assert(resultBytes == cast(ббайт[])testНеобр[i],
                    testEnc[i]~": ("~cast(ткст)resultBytes~") != ("~testНеобр[i]~")");
        }
    }
}

