module util.container.more.HashFile;

private import io.device.FileMap : КартированныйФайл;

/******************************************************************************

        ХэшФайл реализует простой механизм сохранения и восстановления 
        большоо количества данных в течение хостингового процесса.
        Он служит в качестве локального кэша для удалённого источника данных, 
        или в качестве spillover area для больших кэш-экземпляров в памяти. 
        
        Note that any и все stored данные is rendered не_годится the moment
        a ХэшФайл объект is garbage-собериed.

        The implementation follows a fixed-ёмкость record scheme, where
        контент can be rewritten in-place until saопр ёмкость is reached.
        At such время, the altered контент is moved в_ a larger ёмкость
        record at конец-of-файл, и a hole remains at the приор location.
        These holes are not собериed, since the lifespan of a ХэшФайл
        is limited в_ that of the хост process.

        все индекс ключи must be unique. Writing в_ the ХэшФайл with an
        existing ключ will overwrite any previous контент. What follows
        is a contrived example:
        
        ---
        alias ХэшФайл!(ткст, ткст) Bucket;

        auto bucket = new Bucket ("bucket.bin", ХэшФайл.HalfK);

        // вставь some данные, и retrieve it again
        auto текст = "this is a тест";
        bucket.помести ("a ключ", текст);
        auto b = cast(ткст) bucket.получи ("a ключ");

        assert (b == текст);
        bucket.закрой;
        ---

******************************************************************************/

class ХэшФайл(K, V)
{
        /**********************************************************************

                Define the ёмкость (блок-размер) of each record

        **********************************************************************/

        struct РазмерБлока
        {
                цел ёмкость;
        }

        // backing storage
        private КартированныйФайл              файл;

        // память-mapped контент
        private ббайт[]                 куча;

        // basic ёмкость for each record
        private РазмерБлока               блок;

        // pointers в_ файл records
        private Record[K]               карта;

        // текущ файл размер
        private бдол                   размерФайла;

        // текущ файл usage
        private бдол                   waterLine;

        // supported блок размеры
        public static const РазмерБлока   EighthK  = {128-1},
                                        QuarterK = {256-1},
                                        HalfK    = {512-1},
                                        OneK     = {1024*1-1},
                                        TwoK     = {1024*2-1},
                                        FourK    = {1024*4-1},
                                        EightK   = {1024*8-1},
                                        SixteenK = {1024*16-1},
                                        ThirtyTwoK = {1024*32-1},
                                        SixtyFourK = {1024*64-1};


        /**********************************************************************

                Construct a ХэшФайл with the provопрed путь, record-размер,
                и inital record счёт. The latter causes records в_ be 
                pre-allocated, saving a certain amount of growth activity.
                Selecting a record размер that roughly совпадает the serialized 
                контент will предел 'thrashing'. 

        **********************************************************************/

        this (ткст путь, РазмерБлока блок, бцел initialRecords = 100)
        {
                this.блок = блок;

                // открой a storage файл
                файл = new КартированныйФайл (путь);

                // установи начальное файл размер (cannot be zero)
                размерФайла = initialRecords * (блок.ёмкость + 1);

                // карта the файл контент
                куча = файл.перемерь (размерФайла);
        }

        /**********************************************************************
        
                Return where the ХэшФайл is located

        **********************************************************************/

        final ткст путь ()
        {
                return файл.путь;
        }

        /**********************************************************************

                Return the currently populated размер of this ХэшФайл

        **********************************************************************/

        final бдол length ()
        {
                return waterLine;
        }

        /**********************************************************************

                Return the serialized данные for the provопрed ключ. Returns
                пусто if the ключ was не найден.

                Be sure в_ synchronize доступ by multИПle threads

        **********************************************************************/

        final V получи (K ключ, бул очисть = нет)
        {
                auto p = ключ in карта;

                if (p)
                    return p.читай (this, очисть);
                return V.init;
        }

        /**********************************************************************

                Удали the provопрed ключ из_ this ХэшФайл. Leaves a 
                hole in the backing файл

                Be sure в_ synchronize доступ by multИПle threads

        **********************************************************************/

        final проц удали (K ключ)
        {
                карта.удали (ключ);
        }

        /**********************************************************************

                Зап a serialized блок of данные, и associate it with
                the provопрed ключ. все ключи must be unique, и it is the
                responsibility of the programmer в_ ensure this. Reusing 
                an existing ключ will overwrite previous данные. 

                Note that данные is allowed в_ grow внутри the occupied 
                bucket until it becomes larger than the allocated пространство.
                When this happens, the данные is moved в_ a larger bucket
                at the файл хвост.

                Be sure в_ synchronize доступ by multИПle threads

        **********************************************************************/

        final проц помести (K ключ, V данные, K function(K) retain = пусто)
        {
                auto r = ключ in карта;
                
                if (r)
                    r.пиши (this, данные, блок);
                else
                   {
                   Record rr;
                   rr.пиши (this, данные, блок);
                   if (retain)
                       ключ = retain (ключ);
                   карта [ключ] = rr;
                   }
        }

        /**********************************************************************

                Close this ХэшФайл -- все контент is lost.

        **********************************************************************/

        final проц закрой ()
        {
                if (файл)
                   {
                   файл.закрой;
                   файл = пусто;
                   карта = пусто;
                   }
        }

        /**********************************************************************

                Each Record takes up a число of 'pages' внутри the файл. 
                The размер of these pages is determined by the РазмерБлока 
                provопрed during ХэшФайл construction. добавьitional пространство
                at the конец of each блок is potentially wasted, but enables 
                контент в_ grow in размер without creating a myriad of holes.

        **********************************************************************/

        private struct Record
        {
                private бдол           смещение;
                private цел             использован,
                                        ёмкость = -1;

                /**************************************************************

                        This should be protected из_ нить-contention at
                        a higher уровень.

                **************************************************************/

                V читай (ХэшФайл bucket, бул очисть)
                {
                        if (использован)
                           {
                           auto возвр = cast(V) bucket.куча [смещение .. смещение + использован];
                           if (очисть)
                               использован = 0;
                           return возвр;
                           }
                        return V.init;
                }

                /**************************************************************

                        This should be protected из_ нить-contention at
                        a higher уровень.

                **************************************************************/

                проц пиши (ХэшФайл bucket, V данные, РазмерБлока блок)
                {
                        this.использован = данные.length;

                        // создай new slot if we exceed ёмкость
                        if (this.использован > this.ёмкость)
                            createBucket (bucket, this.использован, блок);

                        bucket.куча [смещение .. смещение+использован] = cast(ббайт[]) данные;
                }

                /**************************************************************

                **************************************************************/

                проц createBucket (ХэшФайл bucket, цел байты, РазмерБлока блок)
                {
                        this.смещение = bucket.waterLine;
                        this.ёмкость = (байты + блок.ёмкость) & ~блок.ёмкость;
                        
                        bucket.waterLine += this.ёмкость;
                        if (bucket.waterLine > bucket.размерФайла)
                           {
                           auto мишень = bucket.waterLine * 2;
                           debug(ХэшФайл) 
                                 printf ("growing файл из_ %lld, %lld, в_ %lld\n", 
                                          bucket.размерФайла, bucket.waterLine, мишень);

                           // расширь the physical файл размер и remap the куча
                           bucket.куча = bucket.файл.перемерь (bucket.размерФайла = мишень);
                           }
                }
        }
}


/******************************************************************************

******************************************************************************/

debug (ХэшФайл)
{
        extern(C) цел printf (сим*, ...);

        import io.Path;
        import io.Stdout;
        import text.convert.Integer;

        проц main()
        {
                alias ХэшФайл!(ткст, ткст) Bucket;

                auto файл = new Bucket ("foo.карта", Bucket.QuarterK, 1);
        
                сим[16] врем;
                for (цел i=1; i < 1024; ++i)
                     файл.помести (форматируй(врем, i).dup, "blah");

                auto s = файл.получи ("1", да);
                if (s.length)
                    Стдвыв.форматнс ("результат '{}'", s);
                s = файл.получи ("1");
                if (s.length)
                    Стдвыв.форматнс ("результат '{}'", s);
                файл.закрой;
                удали ("foo.карта");
        }
}
