/**
 * A UUID is a Universally Уникум Identifier.
 * It is a 128-bit число generated either randomly or according в_ some
 * inscrutable algorithm, depending on the UUID version использован.
 *
 * Here, we implement a данные structure for holding и formatting UUIDs.
 * To generate a UUID, use one of the другой modules in the UUID package.
 * You can also создай a UUID by parsing a ткст containing a textual
 * representation of a UUID, or by provопрing the constituent байты.
 */
module util.uuid.Uuid;

import exception;
import Целое = text.convert.Integer;

private union UuidData
{
        бцел[4] ui;
        ббайт[16] ub;
} 

/** This struct represents a UUID. It offers static члены for creating и
 * parsing UUIDs.
 * 
 * This struct treats a UUID as an opaque тип. The specification имеется fields
 * for время, version, клиент MAC адрес, и several другой данные points, but
 * these are meaningless for most applications и means of generating a UUID.
 *
 * There are versions of UUID generation involving the system время и MAC 
 * адрес. These are not использован for several reasons:
 *      - One version содержит опрentifying information, which is undesirable.
 *      - Ensuring uniqueness between processes требует inter-process 
 *              communication. This would be unreasonably slow и комплексное.
 *      - Obtaining the MAC адрес is a system-dependent operation и beyond
 *              the scope of this module.
 *      - Using Java и .NET as a guопрe, they only implement randomized creation
 *              of UUIDs, not the MAC адрес/время based generation.
 *
 * When generating a random UUID, use a carefully seeded random число 
 * generator. A poorly chosen сей may произведи undesirably consistent results.
 */
struct Ууид
{
        private UuidData _data;

        /** Copy the givent байты преобр_в a UUID. If you supply ещё or fewer than
          * 16 байты, throws an ИсклНелегальногоАргумента. */
        public static Ууид opCall(ббайт[] данные);

        /** Attempt в_ разбор the representation of a UUID given in значение. If the
          * значение is not in the correct форматируй, throw ИсклНелегальногоАргумента.
          * If the значение is in the correct форматируй, return a UUID representing the
          * given значение. 
          *
          * The following is an example of a UUID in the ожидалось форматируй:
          *     67e55044-10b1-426f-9247-bb680e5fe0c8 
          */
        public static Ууид разбор(ткст значение);

        /** Attempt в_ разбор the representation of a UUID given in значение. If the
          * значение is not in the correct форматируй, return нет rather than throwing
          * an исключение. If the значение is in the correct форматируй, установи ууид в_ 
          * represent the given значение. 
          *
          * The following is an example of a UUID in the ожидалось форматируй:
          *     67e55044-10b1-426f-9247-bb680e5fe0c8 
          */
        public static бул пробуйРазбор(ткст значение, out Ууид ууид);
        
        /** Generate a UUID based on the given random число generator.
          * The generator must have a метод 'бцел натурал()' that returns
          * a random число. The generated UUID conforms в_ version 4 of the
          * specification. */
        public static Ууид random(Случай)(Случай generator)
        {
                Ууид u;
                with (u)
                {
                        _data.ui[0] = generator.натурал;
                        _data.ui[1] = generator.натурал;
                        _data.ui[2] = generator.натурал;
                        _data.ui[3] = generator.натурал;

                        // v4: 7th байты' первый half is 0b0100: 4 in hex
                        _data.ub[6] &= 0b01001111;
                        _data.ub[6] |= 0b01000000;

                        // v4: 9th байт's 1st half is 0b1000 в_ 0b1011: 8, 9, A, B in hex
                        _data.ub[8] &= 0b10111111;
                        _data.ub[8] |= 0b10000000;
                }
                return u;
        }

        /* Generate a UUID based on the given namespace и имя. This conforms в_ 
         * versions 3 и 5 of the стандарт -- version 3 if you use MD5, or version
         * 5 if you use SHA1.
         *
         * You should пароль 3 as the значение for uuопрVersion if you are using the
         * MD5 хэш, и 5 if you are using the SHA1 хэш. To do otherwise is an
         * Abomination Unto Nuggan.
         *
         * This метод is exposed mainly for the convenience methods in 
         * util.uuid.*. You can use this метод directly if you prefer.
         */
        public static Ууид поИмени(Дайджест)(Ууид namespace, ткст имя, Дайджест дайджест,
                                                                          ббайт uuопрVersion)
        {
                /* o  Compute the хэш of the имя пространство ID concatenated with the имя.
                   o  Набор octets zero through 15 в_ octets zero through 15 of the хэш.
                   o  Набор the four most significant биты (биты 12 through 15) of octet
                          6 в_ the appropriate 4-bit version число из_ Section 4.1.3.
                   o  Набор the two most significant биты (биты 6 и 7) of octet 8 в_ 
                          zero и one, respectively.  */
                auto nameBytes = namespace.вБайты;
                nameBytes ~= cast(ббайт[])имя;
                дайджест.обнови(nameBytes);
                nameBytes = дайджест.двоичныйДайджест;
                nameBytes[6] = (uuопрVersion << 4) | (nameBytes[6] & 0b1111);
                nameBytes[8] |= 0b1000_0000;
                nameBytes[8] &= 0b1011_1111;
                return Ууид(nameBytes[0..16]);
        }

        /** Return an пустой UUID (with все биты установи в_ 0). This doesn't conform
          * в_ any particular version of the specification. It's equivalent в_
          * using an uninitialized UUID. This метод is provопрed for clarity. */
        public static Ууид пустой();

        /** Get a копируй of this UUID's значение as an Массив of unsigned байты. */
        public ббайт[] вБайты();

        /** Gets the version of this UUID. 
          * RFC 4122 defines five типы of UUIDs:
          *     -       Версия 1 is based on the system's MAC адрес и the текущ время.
          *     -       Версия 2 uses the текущ пользователь's userопр и пользователь домен in 
          *                     добавьition в_ the время и MAC адрес.
          * -   Версия 3 is namespace-based, as generated by the NamespaceGenV3
          *                     module. It uses MD5 as a хэш algorithm. RFC 4122 states that
          *                     version 5 is preferred over version 3.
          * -   Версия 4 is generated randomly.
          * -   Версия 5 is like version 3, but uses SHA-1 rather than MD5. Use
          *                     the NamespaceGenV5 module в_ создай UUIDs like this.
          *
          * The following добавьitional versions exist:
          * -   Версия 0 is reserved for backwards compatibility.
          * -   Версия 6 is a non-стандарт Microsoft extension.
          * -   Версия 7 is reserved for future use.
          */
        public ббайт форматируй();

        /** Get the canonical ткст representation of a UUID.
          * The canonical representation is in hexопрecimal, with hyphens inserted
          * after the eighth, twelfth, sixteenth, и twentieth цифры. For example:
          *     67e55044-10b1-426f-9247-bb680e5fe0c8
          * This is the форматируй использован by the parsing functions.
          */
        public ткст вТкст();

        /** Determines if this UUID имеется the same значение as другой. */
        public бул opEquals(Ууид другой);

        /** Get a хэш код representing this UUID. */
        public т_хэш вХэш();
}


version (TangoTest)
{
        import math.random.Kiss;
        unittest
        {
                // Generate them in the correct форматируй
                for (цел i = 0; i < 20; i++)
                {
                        auto uu = Ууид.random(&Kiss.экземпляр).вТкст;
                        auto c = uu[19];
                        assert (c == '9' || c == '8' || c == 'a' || c == 'b', uu);
                        auto d = uu[14];
                        assert (d == '4', uu);
                }

                // пустой
                assert (Ууид.пустой.вТкст == "00000000-0000-0000-0000-000000000000", Ууид.пустой.вТкст);

                ббайт[] байты = [0x6b, 0xa7, 0xb8, 0x10, 0x9d, 0xad, 0x11, 0xd1, 
                                          0x80, 0xb4, 0x00, 0xc0, 0x4f, 0xd4, 0x30, 0xc8];
                Ууид u = Ууид(байты.dup);
                auto стр = "64f2ad82-5182-4c6a-ade5-59728ca0567b";
                auto u2 = Ууид.разбор(стр);

                // вТкст
                assert (Ууид(байты) == u);
                assert (u2 != u);

                assert (u2.форматируй == 4);

                // пробуйРазбор
                Ууид u3;
                assert (Ууид.пробуйРазбор(стр, u3));
                assert (u3 == u2);
        }

        unittest
        {
                Ууид краш;
                // содержит 'r'
                assert (!Ууид.пробуйРазбор("fecr0a9b-4d5a-439e-8e4b-9d087ff49ba7", краш));
                // too крат
                assert (!Ууид.пробуйРазбор("fec70a9b-4d5a-439e-8e4b-9d087ff49ba", краш));
                // hyphens matter
                assert (!Ууид.пробуйРазбор("fec70a9b 4d5a-439e-8e4b-9d087ff49ba7", краш));
                // hyphens matter (2)
                assert (!Ууид.пробуйРазбор("fec70a9b-4d5a-439e-8e4b-9d08-7ff49ba7", краш));
                // hyphens matter (3)
                assert (!Ууид.пробуйРазбор("fec70a9b-4d5a-439e-8e4b-9d08-ff49ba7", краш));
        }

        unittest
        {
                // содержит 'r'
                try 
                {
                        Ууид.разбор("fecr0a9b-4d5a-439e-8e4b-9d087ff49ba7"); assert (нет);
                }
                catch (ИсклНелегальногоАргумента) {}

                // too крат
                try 
                {
                        Ууид.разбор("fec70a9b-4d5a-439e-8e4b-9d087ff49ba"); assert (нет);
                }
                catch (ИсклНелегальногоАргумента) {}

                // hyphens matter
                try 
                {
                        Ууид.разбор("fec70a9b 4d5a-439e-8e4b-9d087ff49ba7"); assert (нет);
                }
                catch (ИсклНелегальногоАргумента) {}

                // hyphens matter (2)
                try 
                {
                        Ууид.разбор("fec70a9b-4d5a-439e-8e4b-9d08-7ff49ba7"); assert (нет);
                }
                catch (ИсклНелегальногоАргумента) {}

                // hyphens matter (3)
                try 
                {
                        Ууид.разбор("fec70a9b-4d5a-439e-8e4b-9d08-ff49ba7"); assert (нет);
                }
                catch (ИсклНелегальногоАргумента) {}
        }

        import util.digest.Sha1;
        unittest
        {
                auto namespace = Ууид.разбор("15288517-c402-4057-9fc5-05711726df41");
                auto имя = "hello";
                // This was generated with the ууид utility on linux/amd64. It might have different results on
                // a ppc процессор -- the spec says something about network байт order, but it's using an Массив
                // of байты at that точка, so converting в_ NBO is a noop...
                auto ожидалось = Ууид.разбор("2b1c6704-a43f-5d43-9abb-b13310b4458a");
                auto generated = Ууид.поИмени(namespace, имя, new Sha1, 5);
                assert (generated == ожидалось, "\nexpected: " ~ ожидалось.вТкст ~ "\nbut was:  " ~ generated.вТкст);
        }
        
        import util.digest.Md5;
        unittest
        {
                auto namespace = Ууид.разбор("15288517-c402-4057-9fc5-05711726df41");
                auto имя = "hello";
                auto ожидалось = Ууид.разбор("31a2b702-85a8-349a-9b0e-213b1bd753b8");
                auto generated = Ууид.поИмени(namespace, имя, new Md5, 3);
                assert (generated == ожидалось, "\nexpected: " ~ ожидалось.вТкст ~ "\nbut was:  " ~ generated.вТкст);
        }
        проц main(){}
}

/** A основа interface for any UUID generator for UUIDs. That is,
  * this interface is specified so that you пиши your код dependent on a
  * UUID generator that takes an arbitrary random источник, и easily switch
  * в_ a different random источник. Since the default uses KISS, if you найди
  * yourself needing ещё безопасно random numbers, you could trivially switch 
  * your код в_ use the Mersenne twister, or some другой PRNG.
  *
  * You could also, if you wish, use this в_ switch в_ deterministic UUID
  * generation, if your needs require it.
  */
interface УуидГен
{
        Ууид следщ();
}

/** Given генератор случайных чисел conforming в_ Dinrus's стандарт random
  * interface, this will generate random UUIDs according в_ version 4 of
  * RFC 4122. */
class СлучГен(TRandom) : УуидГен
{
        TRandom random;
        this (TRandom random)
        {
                this.random = random;
        }

        Ууид следщ();
}

