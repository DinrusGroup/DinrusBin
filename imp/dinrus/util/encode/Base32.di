/*******************************************************************************

        copyright:      Copyright (c) 2010 Ulrik Mikaelsson. все rights reserved

        license:        BSD стиль: $(LICENSE)

        author:         Ulrik Mikaelsson

        standards:      rfc3548, rfc4648

*******************************************************************************/

/*******************************************************************************

    This module is использован в_ раскодируй и кодируй base32 ткст массивы.

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

module util.encode.Base32;

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

    encodes данные и returns as an ASCII base32 ткст.

    Параметры:
    данные = что is в_ be кодирован
    buff = буфер large enough в_ hold кодирован данные
    pad  = Whether в_ pad аски вывод with '='-симвы

    Example:
    ---
    сим[512] encodebuf;
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?", encodebuf);
    Стдвыв(myEncodedString).нс; // JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7
    ---


*******************************************************************************/

ткст кодируй(ббайт[] данные, ткст буф, бул pad=да);

/*******************************************************************************

    encodes данные и returns as an ASCII base32 ткст.

    Параметры:
    данные = что is в_ be кодирован
    pad = whether в_ pad вывод with '='-симвы

    Example:
    ---
    ткст myEncodedString = кодируй(cast(ббайт[])"Hello, как are you today?");
    Стдвыв(myEncodedString).нс; // JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7
    ---


*******************************************************************************/


ткст кодируй(ббайт[] данные, бул pad=да);

/*******************************************************************************

    decodes an ASCII base32 ткст и returns it as ббайт[] данные. Pre-allocates
    the размер of the Массив.

    This decoder will ignore non-base32 characters. So:
    SGVsbG8sIGhvd
    yBhcmUgeW91IH
    RvZGF5Pw==

    Is действителен.

    Параметры:
    данные = что is в_ be decoded

    Example:
    ---
    ткст myDecodedString = cast(ткст)раскодируй("JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7");
    Стдвыв(myDecodeString).нс; // Hello, как are you today?
    ---

*******************************************************************************/

ббайт[] раскодируй(ткст данные);

/*******************************************************************************

    decodes an ASCII base32 ткст и returns it as ббайт[] данные.

    This decoder will ignore non-base32 characters. So:
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
    ткст myDecodedString = cast(ткст)раскодируй("JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7", decodebuf);
    Стдвыв(myDecodeString).нс; // Hello, как are you today?
    ---

*******************************************************************************/
ббайт[] раскодируй(ткст данные, ббайт[] буф);

debug (UnitTest)
{
    unittest
    {
        static ткст[] testBytes = [
            "",
            "foo",
            "fСПД",
            "fСПДa",
            "fСПДar",
            "Hello, как are you today?",
        ];
        static ткст[] testChars = [
            "",
            "MZXW6===",
            "MZXW6YQ=",
            "MZXW6YTB",
            "MZXW6YTBOI======",
            "JBSWY3DPFQQGQ33XEBQXEZJAPFXXKIDUN5SGC6J7",
        ];

        for (бцел i; i < testBytes.length; i++) {
            auto resultChars = кодируй(cast(ббайт[])testBytes[i]);
            assert(resultChars == testChars[i],
                    testBytes[i]~": ("~resultChars~") != ("~testChars[i]~")");

            auto resultBytes = раскодируй(testChars[i]);
            assert(resultBytes == cast(ббайт[])testBytes[i],
                    testChars[i]~": ("~cast(ткст)resultBytes~") != ("~testBytes[i]~")");
        }
    }
}

