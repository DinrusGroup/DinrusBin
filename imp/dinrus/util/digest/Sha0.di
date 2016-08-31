/*******************************************************************************

        copyright:      Copyright (c) 2006 Dinrus. все rights reserved

        license:        BSD стиль: see doc/license.txt for details

        version:        Initial release: Feb 2006

        author:         Regan Heath, Oskar Linde

        This module реализует the SHA-0 Algorithm described by Secure 
        Хэш Standard, FИПS PUB 180

*******************************************************************************/

module util.digest.Sha0;

private import util.digest.Sha01;

public  import util.digest.Digest;

/*******************************************************************************

*******************************************************************************/

final class Sha0 : Sha01
{
        /***********************************************************************

                Construct an Sha0

        ***********************************************************************/

        this() { }

        /***********************************************************************

        ***********************************************************************/

        final protected override проц трансформируй(ббайт[] ввод);

        /***********************************************************************

        ***********************************************************************/

        final static protected проц расширь(бцел W[], бцел s);


}


/*******************************************************************************

*******************************************************************************/

debug(UnitTest)
{
        unittest 
        {
        static ткст[] strings = 
        [
                "",
                "abc",
                "сообщение дайджест",
                "abcdefghijklmnopqrstuvwxyz",
                "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
                "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
        ];

        static ткст[] results = 
        [
                "f96cea198ad1dd5617ac084a3d92c6107708c0ef",
                "0164b8a914cd2a5e74c4f7ff082c4d97f1edf880",
                "c1b0f222d150ebb9aa36a40cafdc8bcbed830b14",
                "b40ce07a430cfd3c033039b9fe9afec95dc1bdcd",
                "79e966f7a3a990df33e40e3d7f8f18d2caebadfa",
                "4aa29d14d171522ece47bee8957e35a41f3e9cff",
        ];

        Sha0 h = new Sha0();

        foreach (цел i, ткст s; strings) 
                {
                h.обнови(s);
                ткст d = h.гексДайджест();
                assert(d == results[i],":("~s~")("~d~")!=("~results[i]~")");
                }
        }
}
