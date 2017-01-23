/*
 Файл: HashSet.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.HashSet;

private import  exception;

private import  util.collection.model.Iterator,
                util.collection.model.HashParams,
                util.collection.model.GuardIterator;

private import  util.collection.impl.LLCell,
                util.collection.impl.SetCollection,
                util.collection.impl.AbstractIterator;


/**
 *
 * Хэш таблица implementation of установи
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

deprecated public class HashSet(T) : SetCollection!(T), ПараметрыХэш
{
        private alias LLCell!(T) LLCellT;

        alias SetCollection!(T).удали     удали;
        alias SetCollection!(T).удалиВсе  удалиВсе;


        // экземпляр variables

        /**
         * The таблица. Each Запись is a список. Пусто if no таблица allocated
        **/
        private LLCellT таблица[];
        /**
         * The порог загрузи factor
        **/
        private плав факторЗагрузки;


        // constructors

        /**
         * Make an пустой ХэшedSet.
        **/

        public this ()
        {
                this(пусто, дефФакторЗагрузки);
        }

        /**
         * Make an пустой ХэшedSet using given элемент скринер
        **/

        public this (Предикат скринер)
        {
                this(скринер, дефФакторЗагрузки);
        }

        /**
         * Special version of constructor needed by клонируй()
        **/

        protected this (Предикат s, плав f)
        {
                super(s);
                таблица = пусто;
                факторЗагрузки = f;
        }

        /**
         * Make an independent копируй of the таблица. Does not клонируй элементы.
        **/

        public final HashSet!(T) дубликат()
        {
                auto c = new HashSet!(T) (скринер, факторЗагрузки);

                if (счёт !is 0)
                   {
                   цел cap = 2 * cast(цел)(счёт / факторЗагрузки) + 1;
                   if (cap < дефНачКорзины)
                       cap = дефНачКорзины;

                   c.корзины(cap);
                   for (цел i = 0; i < таблица.length; ++i)
                        for (LLCellT p = таблица[i]; p !is пусто; p = p.следщ())
                             c.добавь(p.элемент());
                   }
                return c;
        }


        // ХэшTableParams methods

        /**
         * Implements util.collection.ХэшTableParams.корзины.
         * Время complexity: O(1).
         * See_Also: util.collection.ХэшTableParams.корзины.
        **/

        public final цел корзины()
        {
                return (таблица is пусто) ? 0 : таблица.length;
        }

        /**
         * Implements util.collection.ХэшTableParams.корзины.
         * Время complexity: O(n).
         * See_Also: util.collection.ХэшTableParams.корзины.
        **/

        public final проц корзины(цел newCap)
        {
                if (newCap is корзины())
                    return ;
                else
                   if (newCap >= 1)
                       перемерь(newCap);
                   else
                      {
                      сим[16] врем;
                      throw new ИсклНелегальногоАргумента("Impossible Хэш таблица размер:" ~ itoa(врем, newCap));
                      }
        }

        /**
         * Implements util.collection.ХэшTableParams.thresholdLoadfactor
         * Время complexity: O(1).
         * See_Also: util.collection.ХэшTableParams.thresholdLoadfactor
        **/

        public final плав пороговыйФакторЗагрузки()
        {
                return факторЗагрузки;
        }

        /**
         * Implements util.collection.ХэшTableParams.thresholdLoadfactor
         * Время complexity: O(n).
         * See_Also: util.collection.ХэшTableParams.thresholdLoadfactor
        **/

        public final проц пороговыйФакторЗагрузки(плав desired)
        {
                if (desired > 0.0)
                   {
                   факторЗагрузки = desired;
                   проверьLoadFactor();
                   }
                else
                   throw new ИсклНелегальногоАргумента("Неверный Хэш таблица загрузи factor");
        }





        // Коллекция methods

        /**
         * Implements util.collection.impl.Collection.Коллекция.содержит
         * Время complexity: O(1) average; O(n) worst.
         * See_Also: util.collection.impl.Collection.Коллекция.содержит
        **/
        public final бул содержит(T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                     return нет;

                LLCellT p = таблица[hashOf(элемент)];
                if (p !is пусто)
                    return p.найди(элемент) !is пусто;
                else
                   return нет;
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.экземпляры
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.экземпляры
        **/
        public final бцел экземпляры(T элемент)
        {
                if (содержит(элемент))
                    return 1;
                else
                   return 0;
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.элементы
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Коллекция.элементы
        **/
        public final GuardIterator!(T) элементы()
        {
                return new CellIterator!(T)(this);
        }

        /**
         * Implements util.collection.model.View.View.opApply
         * Время complexity: O(n).
         * See_Also: util.collection.model.View.View.opApply
        **/
        цел opApply (цел delegate (inout T значение) дг)
        {
                auto scope обходчик = new CellIterator!(T)(this);
                return обходчик.opApply (дг);
        }

        // MutableCollection methods

        /**
         * Implements util.collection.impl.Collection.Коллекция.очисть.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Коллекция.очисть
        **/
        public final проц очисть()
        {
                устСчёт(0);
                таблица = пусто;
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.exclude.
         * Время complexity: O(1) average; O(n) worst.
         * See_Also: util.collection.impl.Collection.Коллекция.exclude
        **/
        public final проц удалиВсе(T элемент)
        {
                удали(элемент);
        }

        public final проц удали(T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                    return ;

                цел h = hashOf(элемент);
                LLCellT hd = таблица[h];
                LLCellT p = hd;
                LLCellT trail = p;

                while (p !is пусто)
                      {
                      LLCellT n = p.следщ();
                      if (p.элемент() == (элемент))
                         {
                         decCount();
                         if (p is таблица[h])
                            {
                            таблица[h] = n;
                            trail = n;
                            }
                         else
                            trail.следщ(n);
                         return ;
                         } 
                      else
                         {
                         trail = p;
                         p = n;
                         }
                      }
        }

        public final проц замени(T старЭлемент, T новЭлемент)
        {

                if (счёт is 0 || !действительныйАргумент(старЭлемент) || старЭлемент == (новЭлемент))
                    return ;

                if (содержит(старЭлемент))
                   {
                   проверьЭлемент(новЭлемент);
                   удали(старЭлемент);
                   добавь(новЭлемент);
                   }
        }

        public final проц замениВсе(T старЭлемент, T новЭлемент)
        {
                замени(старЭлемент, новЭлемент);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.возьми.
         * Время complexity: O(число of корзины).
         * See_Also: util.collection.impl.Collection.Коллекция.возьми
        **/
        public final T возьми()
        {
                if (счёт !is 0)
                   {
                   for (цел i = 0; i < таблица.length; ++i)
                       {
                       if (таблица[i] !is пусто)
                          {
                          decCount();
                          auto v = таблица[i].элемент();
                          таблица[i] = таблица[i].следщ();
                          return v;
                          }
                       }
                   }

                проверьИндекс(0);
                return T.init; // not reached
        }


        // MutableSet methods

        /**
         * Implements util.collection.impl.SetCollection.SetCollection.добавь.
         * Время complexity: O(1) average; O(n) worst.
         * See_Also: util.collection.impl.SetCollection.SetCollection.добавь
        **/
        public final проц добавь(T элемент)
        {
                проверьЭлемент(элемент);

                if (таблица is пусто)
                    перемерь(дефНачКорзины);

                цел h = hashOf(элемент);
                LLCellT hd = таблица[h];
                if (hd !is пусто && hd.найди(элемент) !is пусто)
                    return ;

                LLCellT n = new LLCellT(элемент, hd);
                таблица[h] = n;
                incCount();

                if (hd !is пусто)
                    проверьLoadFactor(); // only проверь if bin was Неукmpty
        }



        // Helper methods

        /**
         * Check в_ see if we are past загрузи factor порог. If so, перемерь
         * so that we are at half of the desired порог.
         * Also while at it, проверь в_ see if we are пустой so can just
         * отвяжи таблица.
        **/
        protected final проц проверьLoadFactor()
        {
                if (таблица is пусто)
                   {
                   if (счёт !is 0)
                       перемерь(дефНачКорзины);
                   }
                else
                   {
                   плав fc = cast(плав) (счёт);
                   плав ft = таблица.length;
                   if (fc / ft > факторЗагрузки)
                      {
                      цел newCap = 2 * cast(цел)(fc / факторЗагрузки) + 1;
                      перемерь(newCap);
                      }
                   }
        }

        /**
         * маска off и remainder the hashCode for элемент
         * so it can be использован as таблица индекс
        **/

        protected final цел hashOf(T элемент)
        {
                return (typeid(T).дайХэш(&элемент) & 0x7FFFFFFF) % таблица.length;
        }


        /**
         * перемерь таблица в_ new ёмкость, rehashing все элементы
        **/
        protected final проц перемерь(цел newCap)
        {
                LLCellT newtab[] = new LLCellT[newCap];

                if (таблица !is пусто)
                   {
                   for (цел i = 0; i < таблица.length; ++i)
                       {
                       LLCellT p = таблица[i];
                       while (p !is пусто)
                             {
                             LLCellT n = p.следщ();
                             цел h = (p.elementХэш() & 0x7FFFFFFF) % newCap;
                             p.следщ(newtab[h]);
                             newtab[h] = p;
                             p = n;
                             }
                       }
                   }

                таблица = newtab;
                incVersion();
        }

        /+
        private final проц readObject(java.io.ObjectInputПоток поток)

        {
                цел длин = поток.readInt();

                if (длин > 0)
                    таблица = new LLCellT[длин];
                else
                   таблица = пусто;

                факторЗагрузки = поток.readFloat();
                цел счёт = поток.readInt();

                while (счёт-- > 0)
                      {
                      T элемент = поток.readObject();
                      цел h = hashOf(элемент);
                      LLCellT hd = таблица[h];
                      LLCellT n = new LLCellT(элемент, hd);
                      таблица[h] = n;
                      }
        }

        private final проц writeObject(java.io.ObjectOutputПоток поток)
        {
                цел длин;

                if (таблица !is пусто)
                    длин = таблица.length;
                else
                   длин = 0;

                поток.writeInt(длин);
                поток.writeFloat(факторЗагрузки);
                поток.writeInt(счёт);

                if (длин > 0)
                   {
                   Обходчик e = элементы();
                   while (e.ещё())
                          поток.writeObject(e.значение());
                   }
        }

        +/

        // ImplementationCheckable methods

        /**
         * Implements util.collection.model.View.View.проверьРеализацию.
         * See_Also: util.collection.model.View.View.проверьРеализацию
        **/
        public override проц проверьРеализацию()
        {
                super.проверьРеализацию();

                assert(!(таблица is пусто && счёт !is 0));
                assert((таблица is пусто || таблица.length > 0));
                assert(факторЗагрузки > 0.0f);

                if (таблица !is пусто)
                   {
                   цел c = 0;
                   for (цел i = 0; i < таблица.length; ++i)
                       {
                       for (LLCellT p = таблица[i]; p !is пусто; p = p.следщ())
                           {
                           ++c;
                           assert(allows(p.элемент()));
                           assert(содержит(p.элемент()));
                           assert(экземпляры(p.элемент()) is 1);
                           assert(hashOf(p.элемент()) is i);
                           }
                       }
                   assert(c is счёт);
                   }
        }



        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class CellIterator(T) : AbstractIterator!(T)
        {
                private цел             ряд;
                private LLCellT         ячейка;
                private LLCellT[]       таблица;

                public this (HashSet установи)
                {
                        super (установи);
                        таблица = установи.таблица;
                }

                public final T получи()
                {
                        decRemaining();

                        while (ячейка is пусто)
                               ячейка = таблица [ряд++];

                        auto v = ячейка.элемент();
                        ячейка = ячейка.следщ();
                        return v;
                }

                цел opApply (цел delegate (inout T значение) дг)
                {
                        цел результат;

                        for (auto i=остаток(); i--;)
                            {
                            auto значение = получи();
                            if ((результат = дг(значение)) != 0)
                                 break;
                            }
                        return результат;
                }
        }
}



debug (Test)
{
        import io.Console;
        
        проц main()
        {
                auto установи = new HashSet!(ткст);
                установи.добавь ("foo");
                установи.добавь ("bar");
                установи.добавь ("wumpus");

                foreach (значение; установи.элементы) {}

                auto элементы = установи.элементы();
                while (элементы.ещё)
                       auto v = элементы.получи();

                установи.проверьРеализацию();

                foreach (значение; установи)
                         Квывод (значение).нс;
        }
}



debug (HashSet)
{
        import io.Stdout;
        import thread;
        import time.StopWatch;
        
        проц main()
        {
                // установи for benchmark, with a установи of целыйs. We
                // use a чанк разместитель, и presize the bucket[]
                auto тест = new HashSet!(цел);
                тест.корзины = 700_000;
                const счёт = 500_000;
                Секундомер w;

                // benchmark добавим
                w.старт;
                for (цел i=счёт; i--;)
                     тест.добавь(i);
                Стдвыв.форматнс ("{} добавьs: {}/s", тест.размер, тест.размер/w.stop);

                // benchmark reading
                w.старт;
                for (цел i=счёт; i--;)
                     тест.содержит(i);
                Стдвыв.форматнс ("{} lookups: {}/s", тест.размер, тест.размер/w.stop);

                // benchmark добавим without allocation overhead
                тест.очисть;
                w.старт;
                for (цел i=счёт; i--;)
                     тест.добавь(i);
                Стдвыв.форматнс ("{} добавьs (after очисть): {}/s", тест.размер, тест.размер/w.stop);

                // benchmark duplication
                w.старт;
                auto dup = тест.дубликат;
                Стдвыв.форматнс ("{} элемент dup: {}/s", dup.размер, dup.размер/w.stop);

                // benchmark iteration
                w.старт;
                foreach (значение; тест) {}
                Стдвыв.форматнс ("{} элемент iteration: {}/s", тест.размер, тест.размер/w.stop);
                Нить.сон (3);
        }
}
