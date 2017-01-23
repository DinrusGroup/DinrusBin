/**
 * Copyright: Copyright (C) Thomas Dixon 2008. все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Thomas Dixon
 */

module util.cipher.TEA;

private import util.cipher.Cipher;

/** Implementation of the TEA cipher designed by
    David Wheeler и Roger Needham. */
class TEA : ШифрБлок
{
    private
    {
        static const бцел ROUNDS = 32,
                          KEY_SIZE = 16,
                          BLOCK_SIZE = 8,
                          DELTA = 0x9e3779b9u,
                          DECRYPT_SUM = 0xc6ef3720u;
        бцел sk0, sk1, sk2, sk3, sum;
    }
    
    final override проц сбрось();
    
    final override ткст имя();
    
    final override бцел размерБлока();
    
    final проц init(бул зашифруй, СимметричныйКлюч keyParams);
    
    final override бцел обнови(проц[] input_, проц[] output_);
    
    /** Some TEA тест vectors. */
    debug (UnitTest)
    {
        unittest
        {
            static ткст[] test_keys = [
                "00000000000000000000000000000000",
                "00000000000000000000000000000000",
                "0123456712345678234567893456789a",
                "0123456712345678234567893456789a"
            ];
                 
            static ткст[] test_plaintexts = [
                "0000000000000000",
                "0102030405060708",
                "0000000000000000",
                "0102030405060708"
            ];
                
            static ткст[] test_ciphertexts = [
                "41ea3a0a94baa940",
                "6a2f9cf3fccf3c55",
                "34e943b0900f5dcb",
                "773dc179878a81c0"
            ];
                
            
            TEA t = new TEA();
            foreach (бцел i, ткст test_key; test_keys)
            {
                ббайт[] буфер = new ббайт[t.размерБлока];
                ткст результат;
                СимметричныйКлюч ключ = new СимметричныйКлюч(БайтКонвертер.hexDecode(test_key));
                
                // Encryption
                t.init(да, ключ);
                t.обнови(БайтКонвертер.hexDecode(test_plaintexts[i]), буфер);
                результат = БайтКонвертер.hexEncode(буфер);
                assert(результат == test_ciphertexts[i],
                        t.имя~": ("~результат~") != ("~test_ciphertexts[i]~")");

                // Decryption
                t.init(нет, ключ);
                t.обнови(БайтКонвертер.hexDecode(test_ciphertexts[i]), буфер);
                результат = БайтКонвертер.hexEncode(буфер);
                assert(результат == test_plaintexts[i],
                        t.имя~": ("~результат~") != ("~test_plaintexts[i]~")");
            }
        }
    }
}
