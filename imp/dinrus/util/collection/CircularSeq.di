/*
 Файл: CircularSeq.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ сохрани.d  working файл
 13Oct95  dl                 Changed protection statuses
*/

module util.collection.CircularSeq;

private import  util.collection.model.Iterator,
                util.collection.model.GuardIterator;

private import  util.collection.impl.CLCell,
                util.collection.impl.SeqCollection,
                util.collection.impl.AbstractIterator;


/**
 * Circular linked списки. Publically Implement only those
 * methods defined in interfaces.
 * author: Doug Lea
**/
deprecated public class CircularSeq(T) : SeqCollection!(T)
{
        alias CLCell!(T) CLCellT;

        alias SeqCollection!(T).удали     удали;
        alias SeqCollection!(T).удалиВсе  удалиВсе;

        // экземпляр variables

        /**
         * The голова of the список. Пусто if пустой
        **/
        package CLCellT список;

        // constructors

        /**
         * Make an пустой список with no элемент скринер
        **/
        public this ()
        {
                this(пусто, пусто, 0);
        }

        /**
         * Make an пустой список with supplied элемент скринер
        **/
        public this (Предикат скринер)
        {
                this(скринер, пусто, 0);
        }

        /**
         * Special version of constructor needed by клонируй()
        **/
        protected this (Предикат s, CLCellT h, цел c)
        {
                super(s);
                список = h;
                счёт = c;
        }

        /**
         * Make an independent копируй of the список. Elements themselves are not cloned
        **/
        public final CircularSeq!(T) дубликат()
        {
                if (список is пусто)
                    return new CircularSeq!(T) (скринер, пусто, 0);
                else
                   return new CircularSeq!(T) (скринер, список.копируйСписок(), счёт);
        }


        // Коллекция methods

        /**
         * Implements util.collection.impl.Collection.Коллекция.содержит
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.содержит
        **/
        public final бул содержит(T элемент)
        {
                if (!действительныйАргумент(элемент) || список is пусто)
                    return нет;
                return список.найди(элемент) !is пусто;
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.экземпляры
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.экземпляры
        **/
        public final бцел экземпляры(T элемент)
        {
                if (!действительныйАргумент(элемент) || список is пусто)
                    return 0;
                return список.счёт(элемент);
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


        // Seq methods

        /**
         * Implements util.collection.model.Seq.Seq.голова.
         * Время complexity: O(1).
         * See_Also: util.collection.model.Seq.Seq.голова
        **/
        public final T голова()
        {
                return перваяЯчейка().элемент();
        }

        /**
         * Implements util.collection.model.Seq.Seq.хвост.
         * Время complexity: O(1).
         * See_Also: util.collection.model.Seq.Seq.хвост
        **/
        public final T хвост()
        {
                return последняяЯчейка().элемент();
        }

        /**
         * Implements util.collection.model.Seq.Seq.получи.
         * Время complexity: O(n).
         * See_Also: util.collection.model.Seq.Seq.получи
        **/
        public final T получи(цел индекс)
        {
                return ячейкаПо(индекс).элемент();
        }

        /**
         * Implements util.collection.model.Seq.Seq.первый.
         * Время complexity: O(n).
         * See_Also: util.collection.model.Seq.Seq.первый
        **/
        public final цел первый(T элемент, цел startingIndex = 0)
        {
                if (startingIndex < 0)
                    startingIndex = 0;

                CLCellT p = список;
                if (p is пусто || !действительныйАргумент(элемент))
                    return -1;

                for (цел i = 0; да; ++i)
                    {
                    if (i >= startingIndex && p.элемент() == (элемент))
                        return i;

                    p = p.следщ();
                    if (p is список)
                        break;
                    }
                return -1;
        }


        /**
         * Implements util.collection.model.Seq.Seq.последний.
         * Время complexity: O(n).
         * See_Also: util.collection.model.Seq.Seq.последний
        **/
        public final цел последний(T элемент, цел startingIndex = 0)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                    return -1;

                if (startingIndex >= размер())
                    startingIndex = размер() - 1;

                if (startingIndex < 0)
                    startingIndex = 0;

                CLCellT p = ячейкаПо(startingIndex);
                цел i = startingIndex;
                for (;;)
                    {
                    if (p.элемент() == (элемент))
                        return i;
                    else
                       if (p is список)
                           break;
                       else
                          {
                          p = p.предш();
                          --i;
                          }
                    }
                return -1;
        }

        /**
         * Implements util.collection.model.Seq.Seq.subseq.
         * Время complexity: O(length).
         * See_Also: util.collection.model.Seq.Seq.subseq
        **/
        public final CircularSeq поднабор (цел из_, цел _length)
        {
                if (_length > 0)
                   {
                   проверьИндекс(из_);
                   CLCellT p = ячейкаПо(из_);
                   CLCellT новый_список = new CLCellT(p.элемент());
                   CLCellT текущ = новый_список;

                   for (цел i = 1; i < _length; ++i)
                       {
                       p = p.следщ();
                       if (p is пусто)
                           проверьИндекс(из_ + i); // force исключение

                       текущ.добавьСледщ(p.элемент());
                       текущ = текущ.следщ();
                       }
                   return new CircularSeq (скринер, новый_список, _length);
                   }
                else
                   return new CircularSeq ();
        }

        // MutableCollection methods

        /**
         * Implements util.collection.impl.Collection.Коллекция.очисть.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Коллекция.очисть
        **/
        public final проц очисть()
        {
                список = пусто;
                устСчёт(0);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.exclude.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.exclude
        **/
        public final проц удалиВсе (T элемент)
        {
                удали_(элемент, да);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.removeOneOf.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.removeOneOf
        **/
        public final проц удали (T элемент)
        {
                удали_(элемент, нет);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.replaceOneOf
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.replaceOneOf
        **/
        public final проц замени (T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, нет);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.replaceAllOf.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.replaceAllOf
        **/
        public final проц замениВсе (T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, да);
        }


        /**
         * Implements util.collection.impl.Collection.Коллекция.возьми.
         * Время complexity: O(1).
         * takes the последний элемент on the список.
         * See_Also: util.collection.impl.Collection.Коллекция.возьми
        **/
        public final T возьми()
        {
                auto v = хвост();
                удалиХвост();
                return v;
        }



        // MutableSeq methods

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.приставь.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.приставь
        **/
        public final проц приставь(T элемент)
        {
                проверьЭлемент(элемент);
                if (список is пусто)
                    список = new CLCellT(элемент);
                else
                   список = список.добавьПредш(элемент);
                incCount();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.замениГолову.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.замениГолову
        **/
        public final проц замениГолову(T элемент)
        {
                проверьЭлемент(элемент);
                перваяЯчейка().элемент(элемент);
                incVersion();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.удалиГолову.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.удалиГолову
        **/
        public final проц удалиГолову()
        {
                if (перваяЯчейка().isSingleton())
                   список = пусто;
                else
                   {
                   auto n = список.следщ();
                   список.отвяжи();
                   список = n;
                   }
                decCount();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавь.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавь
        **/
        public final проц добавь(T элемент)
        {
                if (список is пусто)
                    приставь(элемент);
                else
                   {
                   проверьЭлемент(элемент);
                   список.предш().добавьСледщ(элемент);
                   incCount();
                   }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.замениХвост.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.замениХвост
        **/
        public final проц замениХвост(T элемент)
        {
                проверьЭлемент(элемент);
                последняяЯчейка().элемент(элемент);
                incVersion();
        }


        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.удалиХвост.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.удалиХвост
        **/
        public final проц удалиХвост()
        {
                auto l = последняяЯчейка();
                if (l is список)
                    список = пусто;
                else
                   l.отвяжи();
                decCount();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавьПо.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавьПо
        **/
        public final проц добавьПо(цел индекс, T элемент)
        {
                if (индекс is 0)
                    приставь(элемент);
                else
                   {
                   проверьЭлемент(элемент);
                   ячейкаПо(индекс - 1).добавьСледщ(элемент);
                   incCount();
                   }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.замениПо.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.замениПо
        **/
        public final проц замениПо(цел индекс, T элемент)
        {
                проверьЭлемент(элемент);
                ячейкаПо(индекс).элемент(элемент);
                incVersion();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.удалиПо.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.удалиПо
        **/
        public final проц удалиПо(цел индекс)
        {
                if (индекс is 0)
                    удалиГолову();
                else
                   {
                   ячейкаПо(индекс - 1).отвяжиСледщ();
                   decCount();
                   }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.приставь.
         * Время complexity: O(число of элементы in e).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.приставь
        **/
        public final проц приставь(Обходчик!(T) e)
        {
                CLCellT hd = пусто;
                CLCellT текущ = пусто;
      
                while (e.ещё())
                      {
                      auto элемент = e.получи();
                      проверьЭлемент(элемент);
                      incCount();

                      if (hd is пусто)
                         {
                         hd = new CLCellT(элемент);
                         текущ = hd;
                         }
                      else
                         {
                         текущ.добавьСледщ(элемент);
                         текущ = текущ.следщ();
                         }
                      }

                if (список is пусто)
                    список = hd;
                else
                   if (hd !is пусто)
                      {
                      auto tl = список.предш();
                      текущ.следщ(список);
                      список.предш(текущ);
                      tl.следщ(hd);
                      hd.предш(tl);
                      список = hd;
                      }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавь.
         * Время complexity: O(число of элементы in e).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавь
        **/
        public final проц добавь(Обходчик!(T) e)
        {
                if (список is пусто)
                    приставь(e);
                else
                   {
                   CLCellT текущ = список.предш();
                   while (e.ещё())
                         {
                         T элемент = e.получи();
                         проверьЭлемент(элемент);
                         incCount();
                         текущ.добавьСледщ(элемент);
                         текущ = текущ.следщ();
                         }
                   }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавьПо.
         * Время complexity: O(размер() + число of элементы in e).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавьПо
        **/
        public final проц добавьПо(цел индекс, Обходчик!(T) e)
        {
                if (список is пусто || индекс is 0)
                    приставь(e);
                else
                   {
                   CLCellT текущ = ячейкаПо(индекс - 1);
                   while (e.ещё())
                         {
                         T элемент = e.получи();
                         проверьЭлемент(элемент);
                         incCount();
                         текущ.добавьСледщ(элемент);
                         текущ = текущ.следщ();
                         }
                   }
        }


        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.removeFromTo.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.removeFromTo
        **/
        public final проц удалиДиапазон (цел отИндекса, цел доИндекса)
        {
                проверьИндекс(доИндекса);
                CLCellT p = ячейкаПо(отИндекса);
                CLCellT последний = список.предш();
                for (цел i = отИндекса; i <= доИндекса; ++i)
                    {
                    decCount();
                    CLCellT n = p.следщ();
                    p.отвяжи();
                    if (p is список)
                       {
                       if (p is последний)
                          {
                          список = пусто;
                          return ;
                          }
                       else
                          список = n;
                       }
                    p = n;
                    }
        }


        // helper methods

        /**
         * return the первый ячейка, or throw исключение if пустой
        **/
        private final CLCellT перваяЯчейка()
        {
                if (список !is пусто)
                    return список;

                проверьИндекс(0);
                return пусто; // not reached!
        }

        /**
         * return the последний ячейка, or throw исключение if пустой
        **/
        private final CLCellT последняяЯчейка()
        {
                if (список !is пусто)
                    return список.предш();

                проверьИндекс(0);
                return пусто; // not reached!
        }

        /**
         * return the индекс'th ячейка, or throw исключение if bad индекс
        **/
        private final CLCellT ячейкаПо(цел индекс)
        {
                проверьИндекс(индекс);
                return список.н_ый(индекс);
        }

        /**
         * helper for удали/exclude
        **/
        private final проц удали_(T элемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(элемент) || список is пусто)
                    return;

                CLCellT p = список;
                for (;;)
                    {
                    CLCellT n = p.следщ();
                    if (p.элемент() == (элемент))
                       {
                       decCount();
                       p.отвяжи();
                       if (p is список)
                          {
                          if (p is n)
                             {
                             список = пусто;
                             break;
                             }
                          else
                             список = n;
                          }

                       if (! всеСлучаи)
                             break;
                       else
                          p = n;
                       }
                    else
                       if (n is список)
                           break;
                       else
                          p = n;
                    }
        }


        /**
         * helper for замени *
        **/
        private final проц замени_(T старЭлемент, T новЭлемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(старЭлемент) || список is пусто)
                    return;

                CLCellT p = список;
                do {
                   if (p.элемент() == (старЭлемент))
                      {
                      проверьЭлемент(новЭлемент);
                      incVersion();
                      p.элемент(новЭлемент);
                      if (! всеСлучаи)
                            return;
                      }
                   p = p.следщ();
                } while (p !is список);
        }

        // ImplementationCheckable methods

        /**
         * Implements util.collection.model.View.View.проверьРеализацию.
         * See_Also: util.collection.model.View.View.проверьРеализацию
        **/

        public override проц проверьРеализацию()
        {
                super.проверьРеализацию();

                assert(((счёт is 0) is (список is пусто)));
                assert((список is пусто || список._length() is счёт));

                if (список is пусто)
                    return;

                цел c = 0;
                CLCellT p = список;
                do {
                   assert(p.предш().следщ() is p);
                   assert(p.следщ().предш() is p);
                   assert(allows(p.элемент()));
                   assert(экземпляры(p.элемент()) > 0);
                   assert(содержит(p.элемент()));
                   p = p.следщ();
                   ++c;
                   } while (p !is список);

                assert(c is счёт);
        }


        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        static class CellIterator(T) : AbstractIterator!(T)
        {
                private CLCellT ячейка;

                public this (CircularSeq пследвтн)
                {
                        super (пследвтн);
                        ячейка = пследвтн.список;
                }

                public final T получи()
                {
                        decRemaining();
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
                auto Массив = new CircularSeq!(ткст);
                Массив.добавь ("foo");
                Массив.добавь ("bar");
                Массив.добавь ("wumpus");

                foreach (значение; Массив.элементы) {}

                auto элементы = Массив.элементы();
                while (элементы.ещё)
                       auto v = элементы.получи();

                foreach (значение; Массив)
                         Квывод (значение).нс;

                Массив.проверьРеализацию();
        }
}
