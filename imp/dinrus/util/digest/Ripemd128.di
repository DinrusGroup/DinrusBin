/*******************************************************************************

        copyright:      Copyright (c) 2009 Dinrus. все rights reserved

        license:        BSD стиль: see doc/license.txt for details

        version:        Initial release: Sep 2009

        author:         Kai Nacke

        This module реализует the Ripemd128 algorithm by Hans Dobbertin, 
        Antoon Bosselaers и Bart Preneel.

        See http://homes.esat.kuleuven.be/~bosselae/rИПemd160.html for ещё
        information.
        
        The implementation is based on:        
        RИПEMD-160 software записано by Antoon Bosselaers, 
 		available at http://www.esat.kuleuven.ac.be/~cosicart/ps/AB-9601/

*******************************************************************************/

module util.digest.Ripemd128;

private import util.digest.MerkleDamgard;

public  import util.digest.Digest;

/*******************************************************************************

*******************************************************************************/

final class Ripemd128 : MerkleDamgard
{
        private бцел[4]        контекст;
        private const бцел     padChar = 0x80;

        /***********************************************************************

        ***********************************************************************/

        private static const бцел[4] начальное =
        [
  				0x67452301,
  				0xefcdab89,
  				0x98badcfe,
  				0x10325476
        ];
        
        /***********************************************************************

        	Construct a Ripemd128

         ***********************************************************************/

        this() ;

        /***********************************************************************

        	The размер of a Ripemd128 дайджест is 16 байты
        
         ***********************************************************************/

        override бцел размерДайджеста() ;


        /***********************************************************************

        	Initialize the cipher

        	Remarks:
        		Returns the cipher состояние в_ it's начальное значение

         ***********************************************************************/

        override проц сбрось();

        /***********************************************************************

        	Obtain the дайджест

        	Возвращает:
        		the дайджест

        	Remarks:
        		Returns a дайджест of the текущ cipher состояние, this may be the
        		final дайджест, or a дайджест of the состояние between calls в_ обнови()

         ***********************************************************************/

        override проц создайДайджест(ббайт[] буф);


        /***********************************************************************

         	блок размер

        	Возвращает:
        	the блок размер

        	Remarks:
        	Specifies the размер (in байты) of the блок of данные в_ пароль в_
        	each вызов в_ трансформируй(). For Ripemd128 the размерБлока is 64.

         ***********************************************************************/

        protected override бцел размерБлока() ;

        /***********************************************************************

        	Length паддинг размер

        	Возвращает:
        	the length паддинг размер

        	Remarks:
        	Specifies the размер (in байты) of the паддинг which uses the
        	length of the данные which имеется been ciphered, this паддинг is
        	carried out by the padLength метод. For Ripemd128 the добавьРазмер is 8.

         ***********************************************************************/

        protected бцел добавьРазмер()  ;

        /***********************************************************************

        	Pads the cipher данные

        	Параметры:
        	данные = a срез of the cipher буфер в_ заполни with паддинг

        	Remarks:
        	Fills the passed буфер срез with the appropriate паддинг for
        	the final вызов в_ трансформируй(). This паддинг will заполни the cipher
        	буфер up в_ размерБлока()-добавьРазмер().

         ***********************************************************************/

        protected override проц padMessage(ббайт[] at);

        /***********************************************************************

        	Performs the length паддинг

        	Параметры:
        	данные   = the срез of the cipher буфер в_ заполни with паддинг
        	length = the length of the данные which имеется been ciphered

        	Remarks:
        	Fills the passed буфер срез with добавьРазмер() байты of паддинг
        	based on the length in байты of the ввод данные which имеется been
        	ciphered.

         ***********************************************************************/

        protected override проц padLength(ббайт[] at, бдол length);

        /***********************************************************************

        	Performs the cipher on a блок of данные

        	Параметры:
        	данные = the блок of данные в_ cipher

        	Remarks:
        	The actual cipher algorithm is carried out by this метод on
        	the passed блок of данные. This метод is called for every
        	размерБлока() байты of ввод данные и once ещё with the остаток
        	данные псеп_в_конце в_ размерБлока().

         ***********************************************************************/

        protected override проц трансформируй(ббайт[] ввод);

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
            "a",
            "abc",
            "сообщение дайджест",
            "abcdefghijklmnopqrstuvwxyz",
            "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
            "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
    ];

    static ткст[] results =
    [
            "cdf26213a150dc3ecb610f18f6b38b46",
            "86be7afa339d0fc7cfc785e72f578d33",
            "c14a12199c66e4ba84636b0f69144c77",
            "9e327b3d6e523062afc1132d7df9d1b8",
            "fd2aa607f71dc8f510714922b371834e",
            "a1aa0689d0fafa2ddc22e88b49133a06",
            "d1e959eb179c911faea4624c60c5c702",
            "3f45ef194732c2dbb2c4a2c769795fa3"
    ];

    Ripemd128 h = new Ripemd128();

    foreach (цел i, ткст s; strings)
            {
            h.обнови(cast(ббайт[]) s);
            ткст d = h.гексДайджест;

            assert(d == results[i],":("~s~")("~d~")!=("~results[i]~")");
            }

    ткст s = new сим[1000000];
    for (auto i = 0; i < s.length; i++) s[i] = 'a';
    ткст результат = "4a7f5723f954eba1216c9d8f6320431f";
    h.обнови(cast(ббайт[]) s);
    ткст d = h.гексДайджест;

    assert(d == результат,":(1 million times \"a\")("~d~")!=("~результат~")");
    }
	
}