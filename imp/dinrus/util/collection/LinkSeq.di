/*
 Файл: LinkSeq.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 2Oct95  dl@cs.oswego.edu   repack из_ LLSeq.d
 9apr97  dl                 вставь bounds проверь in первый
*/


module util.collection.LinkSeq;

private import  util.collection.model.Iterator,
                util.collection.model.Sortable,
                util.collection.model.Сравнитель,
                util.collection.model.GuardIterator;

private import  util.collection.impl.LLCell,
                util.collection.impl.SeqCollection,
                util.collection.impl.AbstractIterator;

/**
 *
 * LinkedList implementation.
 * Publically реализует only those methods defined in its interfaces.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

deprecated public class LinkSeq(T) : SeqCollection!(T), Sortable!(T)
{
        alias LLCell!(T) LLCellT;

        alias SeqCollection!(T).удали     удали;
        alias SeqCollection!(T).удалиВсе  удалиВсе;

        // экземпляр variables

        /**
         * The голова of the список. Пусто iff счёт == 0
        **/

        package LLCellT список;

        // constructors

        /**
         * Созд a new пустой список
        **/

        public this ()
        {
                this(пусто, пусто, 0);
        }

        /**
         * Созд a список with a given элемент скринер
        **/

        public this (Предикат скринер)
        {
                this(скринер, пусто, 0);
        }

        /**
         * Special version of constructor needed by клонируй()
        **/

        protected this (Предикат s, LLCellT l, цел c)
        {
                super(s);
                список = l;
                счёт = c;
        }

        /**
         * Build an independent копируй of the список.
         * The элементы themselves are not cloned
        **/

        //  protected Объект клонируй() {
        public LinkSeq!(T) дубликат()
        {
                if (список is пусто)
                    return new LinkSeq!(T)(скринер, пусто, 0);
                else
                   return new LinkSeq!(T)(скринер, список.копируйСписок(), счёт);
        }


        // Коллекция methods

        /**
         * Implements util.collection.impl.Collection.Коллекция.содержит
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.содержит
        **/
        public final бул содержит(T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
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
                if (!действительныйАргумент(элемент) || счёт is 0)
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


        // Seq Methods

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
         * Время complexity: O(n).
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
                if (!действительныйАргумент(элемент) || список is пусто || startingIndex >= счёт)
                      return -1;

                if (startingIndex < 0)
                    startingIndex = 0;

                LLCellT p = список.н_ый(startingIndex);
                if (p !is пусто)
                   {
                   цел i = p.индекс(элемент);
                   if (i >= 0)
                       return i + startingIndex;
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
                if (!действительныйАргумент(элемент) || список is пусто)
                     return -1;

                цел i = 0;
                if (startingIndex >= размер())
                    startingIndex = размер() - 1;

                цел индекс = -1;
                LLCellT p = список;
                while (i <= startingIndex && p !is пусто)
                      {
                      if (p.элемент() == (элемент))
                          индекс = i;
                      ++i;
                      p = p.следщ();
                      }
                return индекс;
        }



        /**
         * Implements util.collection.model.Seq.Seq.subseq.
         * Время complexity: O(length).
         * See_Also: util.collection.model.Seq.Seq.subseq
        **/
        public final LinkSeq поднабор(цел из_, цел _length)
        {
                if (_length > 0)
                   {
                   LLCellT p = ячейкаПо(из_);
                   LLCellT новый_список = new LLCellT(p.элемент(), пусто);
                   LLCellT текущ = новый_список;
         
                   for (цел i = 1; i < _length; ++i)
                       {
                       p = p.следщ();
                       if (p is пусто)
                           проверьИндекс(из_ + i); // force исключение

                       текущ.вяжиСледщ(new LLCellT(p.элемент(), пусто));
                       текущ = текущ.следщ();
                       }
                   return new LinkSeq!(T)(скринер, новый_список, _length);
                   }
                else
                   return new LinkSeq!(T)(скринер, пусто, 0);
        }


        // MutableCollection methods

        /**
         * Implements util.collection.impl.Collection.Коллекция.очисть.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Коллекция.очисть
        **/
        public final проц очисть()
        {
                if (список !is пусто)
                   {
                   список = пусто;
                   устСчёт(0);
                   }
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
        public final проц замениВсе(T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, да);
        }


        /**
         * Implements util.collection.impl.Collection.Коллекция.возьми.
         * Время complexity: O(1).
         * takes the первый элемент on the список
         * See_Also: util.collection.impl.Collection.Коллекция.возьми
        **/
        public final T возьми()
        {
                T v = голова();
                удалиГолову();
                return v;
        }

        // Sortable methods

        /**
         * Implements util.collection.Sortable.сортируй.
         * Время complexity: O(n лог n).
         * Uses a merge-сортируй-based algorithm.
         * See_Also: util.collection.SortableCollection.сортируй
        **/
        public final проц сортируй(Сравнитель!(T) cmp)
        {
                if (список !is пусто)
                   {
                   список = LLCellT.mergeSort(список, cmp);
                   incVersion();
                   }
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
                список = new LLCellT(элемент, список);
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
                список = перваяЯчейка().следщ();
                decCount();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавь.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавь
        **/
        public final проц добавь(T элемент)
        {
                проверьЭлемент(элемент);
                if (список is пусто)
                    приставь(элемент);
                else
                   {
                   список.хвост().следщ(new LLCellT(элемент));
                   incCount();
                   }
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.замениХвост.
         * Время complexity: O(n).
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
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.удалиХвост
        **/
        public final проц удалиХвост()
        {
                if (перваяЯчейка().следщ() is пусто)
                    удалиГолову();
                else
                   {
                   LLCellT trail = список;
                   LLCellT p = trail.следщ();

                   while (p.следщ() !is пусто)
                         {
                         trail = p;
                         p = p.следщ();
                         }
                   trail.следщ(пусто);
                   decCount();
                   }
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
                   ячейкаПо(индекс - 1).вяжиСледщ(new LLCellT(элемент));
                   incCount();
                   }
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
         * Implements util.collection.impl.SeqCollection.SeqCollection.замениПо.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.замениПо
        **/
        public final проц замениПо(цел индекс, T элемент)
        {
                ячейкаПо(индекс).элемент(элемент);
                incVersion();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.приставь.
         * Время complexity: O(число of элементы in e).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.приставь
        **/
        public final проц приставь(Обходчик!(T) e)
        {
                splice_(e, пусто, список);
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавь.
         * Время complexity: O(n + число of элементы in e).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавь
        **/
        public final проц добавь(Обходчик!(T) e)
        {
                if (список is пусто)
                    splice_(e, пусто, пусто);
                else
                   splice_(e, список.хвост(), пусто);
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавьПо.
         * Время complexity: O(n + число of элементы in e).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавьПо
        **/
        public final проц добавьПо(цел индекс, Обходчик!(T) e)
        {
                if (индекс is 0)
                    splice_(e, пусто, список);
                else
                   {
                   LLCellT p = ячейкаПо(индекс - 1);
                   splice_(e, p, p.следщ());
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

                if (отИндекса <= доИндекса)
                   {
                   if (отИндекса is 0)
                      {
                      LLCellT p = перваяЯчейка();
                      for (цел i = отИндекса; i <= доИндекса; ++i)
                           p = p.следщ();
                      список = p;
                      }
                   else
                      {
                      LLCellT f = ячейкаПо(отИндекса - 1);
                      LLCellT p = f;
                      for (цел i = отИндекса; i <= доИндекса; ++i)
                           p = p.следщ();
                      f.следщ(p.следщ());
                      }
                  добавьToCount( -(доИндекса - отИндекса + 1));
                  }
        }



        // helper methods

        private final LLCellT перваяЯчейка()
        {
                if (список !is пусто)
                    return список;

                проверьИндекс(0);
                return пусто; // not reached!
        }

        private final LLCellT последняяЯчейка()
        {
                if (список !is пусто)
                    return список.хвост();

                проверьИндекс(0);
                return пусто; // not reached!
        }

        private final LLCellT ячейкаПо(цел индекс)
        {
                проверьИндекс(индекс);
                return список.н_ый(индекс);
        }

        /**
         * Helper метод for removeOneOf()
        **/

        private final проц удали_(T элемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                     return ;

                LLCellT p = список;
                LLCellT trail = p;

                while (p !is пусто)
                      {
                      LLCellT n = p.следщ();
                      if (p.элемент() == (элемент))
                         {
                         decCount();
                         if (p is список)
                            {
                            список = n;
                            trail = n;
                            }
                         else
                            trail.следщ(n);

                         if (!всеСлучаи || счёт is 0)
                             return ;
                         else
                            p = n;
                         }
                      else
                         {
                         trail = p;
                         p = n;
                         }
                      }
        }


        /**
         * Helper for замени
        **/

        private final проц замени_(T старЭлемент, T новЭлемент, бул всеСлучаи)
        {
                if (счёт is 0 || !действительныйАргумент(старЭлемент) || старЭлемент == (новЭлемент))
                    return ;

                LLCellT p = список.найди(старЭлемент);
                while (p !is пусто)
                      {
                      проверьЭлемент(новЭлемент);
                      p.элемент(новЭлемент);
                      incVersion();
                      if (!всеСлучаи)
                           return ;
                      p = p.найди(старЭлемент);
                      }
        }

        /**
         * Splice элементы of e between hd и tl. if hd is пусто return new hd
        **/

        private final проц splice_(Обходчик!(T) e, LLCellT hd, LLCellT tl)
        {
                if (e.ещё())
                   {
                   LLCellT новый_список = пусто;
                   LLCellT текущ = пусто;

                   while (e.ещё())
                        {
                        T v = e.получи();
                        проверьЭлемент(v);
                        incCount();

                        LLCellT p = new LLCellT(v, пусто);
                        if (новый_список is пусто)
                            новый_список = p;
                        else
                           текущ.следщ(p);
                        текущ = p;
                        }

                   if (текущ !is пусто)
                       текущ.следщ(tl);

                   if (hd is пусто)
                       список = новый_список;
                   else
                      hd.следщ(новый_список);
                   }
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

                цел c = 0;
                for (LLCellT p = список; p !is пусто; p = p.следщ())
                    {
                    assert(allows(p.элемент()));
                    assert(экземпляры(p.элемент()) > 0);
                    assert(содержит(p.элемент()));
                    ++c;
                    }
                assert(c is счёт);

        }


        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class CellIterator(T) : AbstractIterator!(T)
        {
                private LLCellT ячейка;

                public this (LinkSeq пследвтн)
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
                auto пследвтн = new LinkSeq!(ткст);
                пследвтн.добавь ("foo");
                пследвтн.добавь ("wumpus");
                пследвтн.добавь ("bar");

                foreach (значение; пследвтн.элементы) {}

                auto элементы = пследвтн.элементы();
                while (элементы.ещё)
                       auto v = элементы.получи();

                foreach (значение; пследвтн)
                         Квывод (значение).нс;

                пследвтн.проверьРеализацию();
        }
}
                
