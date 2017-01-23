/**
 * Copyright: Copyright (C) Thomas Dixon 2008. все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Thomas Dixon
 */

module util.cipher.RC6;

private import util.cipher.Cipher;

/**
 * Implementation of the RC6-32/20/b cipher designed by 
 * Ron Rivest et al. of RSA Security.
 * 
 * It should be noted that this algorithm is very similar в_ RC5.
 * Currently there are no plans в_ implement RC5, but should that change
 * in the future, it may be wise в_ rewrite Всё RC5 и RC6 в_ use some
 * kind of template or основа class.
 *
 * This algorithm is patented и trademarked.
 * 
 * References: http://people.csail.mit.edu/rivest/Rc6.pdf
 */
class RC6 : ШифрБлок
{
    private
    {
        static const бцел ROUNDS = 20,
                          BLOCK_SIZE = 16,
                          // Magic constants for a 32 bit word размер
                          P = 0xb7e15163,
                          Q = 0x9e3779b9;
        бцел[] S;
        ббайт[] workingKey;
    }
    
    final override ткст имя()
    {
        return "RC6";
    }
    
    final override бцел размерБлока()
    {
        return BLOCK_SIZE;
    }
    
    final проц init(бул зашифруй, СимметричныйКлюч keyParams)
    {
        _encrypt = зашифруй;
        
        бцел длин = keyParams.ключ.length;
        if (длин != 16 && длин != 24 && длин != 32)
            не_годится(имя()~": Неверный ключ length (требует 16/24/32 байты)");
        
        S = new бцел[2*ROUNDS+4];        
                   
        workingKey = keyParams.ключ;
        установи(workingKey);
        
        _initialized = да;
    }
    
    final override бцел обнови(проц[] input_, проц[] output_) {
        if (!_initialized)
            не_годится(имя()~": Шифр not инициализован");
            
        ббайт[] ввод = cast(ббайт[]) input_,
                вывод = cast(ббайт[]) output_;
                    
        if (ввод.length < BLOCK_SIZE)
            не_годится(имя()~": Ввод буфер too крат");
            
        if (вывод.length < BLOCK_SIZE)
            не_годится(имя()~": Вывод буфер too крат");
        
        бцел A = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(ввод[0..4]),
             B = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(ввод[4..8]),
             C = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(ввод[8..12]),
             D = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(ввод[12..16]),
             t,
             u;
             
        if (_encrypt)
        {
            B += S[0];
            D += S[1];
            
            for (цел i = 1; i <= ROUNDS; i++)
            {
                t = Побитно.вращайВлево(B*((B<<1)+1), 5u);
                u = Побитно.вращайВлево(D*((D<<1)+1), 5u);
                A = Побитно.вращайВлево(A^t, u) + S[i<<1];
                C = Побитно.вращайВлево(C^u, t) + S[(i<<1)+1];
                t = A;
                A = B;
                B = C;
                C = D;
                D = t;
            }
            
            A += S[2*ROUNDS+2];
            C += S[2*ROUNDS+3];
        }
        else
        {
            C -= S[2*ROUNDS+3];
            A -= S[2*ROUNDS+2];
            
            for (цел i = ROUNDS; i >= 1; i--)
            {
                t = D;
                D = C;
                C = B;
                B = A;
                A = t;
                u = Побитно.вращайВлево(D*((D<<1)+1), 5u);
                t = Побитно.вращайВлево(B*((B<<1)+1), 5u);
                C = Побитно.вращайВправо(C-S[(i<<1)+1], t) ^ u;
                A = Побитно.вращайВправо(A-S[i<<1], u) ^ t;
            }
            
            D -= S[1];
            B -= S[0];
        }

        вывод[0..4] = БайтКонвертер.ЛитлЭндиан.из_!(бцел)(A);
        вывод[4..8] = БайтКонвертер.ЛитлЭндиан.из_!(бцел)(B);
        вывод[8..12] = БайтКонвертер.ЛитлЭндиан.из_!(бцел)(C);
        вывод[12..16] = БайтКонвертер.ЛитлЭндиан.из_!(бцел)(D);
        
        return BLOCK_SIZE;
    }
    
    final override проц сбрось()
    {
        установи(workingKey);
    }
    
    private проц установи(ббайт[] ключ)
    {
        бцел c = ключ.length/4;
        бцел[] L = new бцел[c];
        for (цел i = 0, j = 0; i < c; i++, j+=4)
            L[i] = БайтКонвертер.ЛитлЭндиан.в_!(бцел)(ключ[j..j+цел.sizeof]);
            
        S[0] = P;
        for (цел i = 1; i <= 2*ROUNDS+3; i++)
            S[i] = S[i-1] + Q;
            
        бцел A, B, i, j, v = 3*(2*ROUNDS+4); // Relying on ints initializing в_ 0   
        for (цел s = 1; s <= v; s++)
        {
            A = S[i] = Побитно.вращайВлево(S[i]+A+B, 3u);
            B = L[j] = Побитно.вращайВлево(L[j]+A+B, A+B);
            i = (i + 1) % (2*ROUNDS+4);
            j = (j + 1) % c;
        }
    }
    
    /** Some RC6 тест vectors из_ the spec. */
    debug (UnitTest)
    {
        unittest
        {
            static ткст[] test_keys = [
                "00000000000000000000000000000000",
                "0123456789abcdef0112233445566778",
                "00000000000000000000000000000000"~
                "0000000000000000",
                "0123456789abcdef0112233445566778"~
                "899aabbccddeeff0",
                "00000000000000000000000000000000"~
                "00000000000000000000000000000000",
                "0123456789abcdef0112233445566778"~
                "899aabbccddeeff01032547698badcfe"
            ];
                 
            static ткст[] test_plaintexts = [
                "00000000000000000000000000000000",
                "02132435465768798a9bacbdcedfe0f1",
                "00000000000000000000000000000000",
                "02132435465768798a9bacbdcedfe0f1",
                "00000000000000000000000000000000",
                "02132435465768798a9bacbdcedfe0f1"
            ];
                
            static ткст[] test_ciphertexts = [
                "8fc3a53656b1f778c129df4e9848a41e",
                "524e192f4715c6231f51f6367ea43f18",
                "6cd61bcb190b30384e8a3f168690ae82",
                "688329d019e505041e52e92af95291d4",
                "8f5fbd0510d15fa893fa3fda6e857ec2",
                "c8241816f0d7e48920ad16a1674e5d48"
            ];
                
            RC6 t = new RC6();
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
