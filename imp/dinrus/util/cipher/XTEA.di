/**
 * Copyright: Copyright (C) Thomas Dixon 2008. все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Thomas Dixon
 */

module util.cipher.XTEA;

private import util.cipher.Cipher;

/** Implementation of the XTEA cipher designed by
    David Wheeler и Roger Needham. */
class XTEA : ШифрБлок
{
    private
    {
        static const бцел ROUNDS = 32,
                          KEY_SIZE = 16,
                          BLOCK_SIZE = 8,
                          DELTA = 0x9e3779b9u;
        бцел[] subkeys,
               sum0,
               sum1;
    }
    
    final override проц сбрось();
    
    final override ткст имя();
    
    final override бцел размерБлока();
    
    final проц init(бул зашифруй, СимметричныйКлюч keyParams);
    
    final override бцел обнови(проц[] input_, проц[] output_);
    
    /** Some XTEA тест vectors. */
    debug (UnitTest)
    {
        unittest
        {
            static ткст[] test_keys = [
                "00000000000000000000000000000000",
                "00000000000000000000000000000000",
                "0123456712345678234567893456789a",
                "0123456712345678234567893456789a",
                "00000000000000000000000000000001",
                "01010101010101010101010101010101",
                "0123456789abcdef0123456789abcdef",
                "0123456789abcdef0123456789abcdef",
                "00000000000000000000000000000000",
                "00000000000000000000000000000000"
            ];
                 
            static ткст[] test_plaintexts = [
                "0000000000000000",
                "0102030405060708",
                "0000000000000000",
                "0102030405060708",
                "0000000000000001",
                "0101010101010101",
                "0123456789abcdef",
                "0000000000000000",
                "0123456789abcdef",
                "4141414141414141"
            ];
                
            static ткст[] test_ciphertexts = [
                "dee9d4d8f7131ed9",
                "065c1b8975c6a816",
                "1ff9a0261ac64264",
                "8c67155b2ef91ead",
                "9f25fa5b0f86b758",
                "c2eca7cec9b7f992",
                "27e795e076b2b537",
                "5c8eddc60a95b3e1",
                "7e66c71c88897221",
                "ed23375a821a8c2d"
            ];
                
            XTEA t = new XTEA();
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

