/*
 Файл: TreeBag.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.TreeBag;

private import  util.collection.model.Iterator,
                util.collection.model.Сравнитель,
                util.collection.model.SortedValues,
                util.collection.model.GuardIterator;

private import  util.collection.impl.RBCell,
                util.collection.impl.BagCollection,
                util.collection.impl.AbstractIterator;

/**
 * RedBlack trees.
 * author: Doug Lea
**/

deprecated public class TreeBag(T) : BagCollection!(T), SortedValues!(T)
{
        alias RBCell!(T)        RBCellT;
        alias Сравнитель!(T)    ComparatorT;

        alias BagCollection!(T).удали     удали;
        alias BagCollection!(T).удалиВсе  удалиВсе;


        // экземпляр variables

        /**
         * The корень of the дерево. Пусто if пустой.
        **/

        package RBCellT дерево;

        /**
         * The сравнитель в_ use for ordering.
        **/
        protected ComparatorT cmp_;

        // constructors

        /**
         * Make an пустой дерево.
         * Initialize в_ use DefaultComparator for ordering
        **/
        public this ()
        {
                this(пусто, пусто, пусто, 0);
        }

        /**
         * Make an пустой дерево, using the supplied элемент скринер.
         * Initialize в_ use DefaultComparator for ordering
        **/

        public this (Предикат s)
        {
                this(s, пусто, пусто, 0);
        }

        /**
         * Make an пустой дерево, using the supplied элемент сравнитель for ordering.
        **/
        public this (ComparatorT c)
        {
                this(пусто, c, пусто, 0);
        }

        /**
         * Make an пустой дерево, using the supplied элемент скринер и сравнитель
        **/
        public this (Предикат s, ComparatorT c)
        {
                this(s, c, пусто, 0);
        }

        /**
         * Special version of constructor needed by клонируй()
        **/

        protected this (Предикат s, ComparatorT cmp, RBCellT t, цел n)
        {
                super(s);
                счёт = n;
                дерево = t;
                if (cmp !is пусто)
                    cmp_ = cmp;
                else
                   cmp_ = &сравни;
        }

        /**
         * The default сравнитель
         *
         * @param fst первый аргумент
         * @param snd секунда аргумент
         * Возвращает: a негатив число if fst is less than snd; a
         * positive число if fst is greater than snd; else 0
        **/

        private final цел сравни(T fst, T snd)
        {
                if (fst is snd)
                    return 0;

                return typeid(T).сравни (&fst, &snd);
        }


        /**
         * Make an independent копируй of the дерево. Does not клонируй элементы.
        **/ 

        public TreeBag!(T) дубликат()
        {
                if (счёт is 0)
                    return new TreeBag!(T)(скринер, cmp_);
                else
                   return new TreeBag!(T)(скринер, cmp_, дерево.copyTree(), счёт);
        }



        // Коллекция methods

        /**
         * Implements util.collection.impl.Collection.Коллекция.содержит
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.Collection.Коллекция.содержит
        **/
        public final бул содержит(T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                     return нет;

                return дерево.найди(элемент, cmp_) !is пусто;
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.экземпляры
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.Collection.Коллекция.экземпляры
        **/
        public final бцел экземпляры(T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                     return 0;

                return дерево.счёт(элемент, cmp_);
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


        // ElementSortedCollection methods


        /**
         * Implements util.collection.ElementSortedCollection.сравнитель
         * Время complexity: O(1).
         * See_Also: util.collection.ElementSortedCollection.сравнитель
        **/
        public final ComparatorT сравнитель()
        {
                return cmp_;
        }

        /**
         * Reset the сравнитель. Will cause a reorganization of the дерево.
         * Время complexity: O(n лог n).
        **/
        public final проц сравнитель(ComparatorT cmp)
        {
                if (cmp !is cmp_)
                   {
                   if (cmp !is пусто)
                       cmp_ = cmp;
                   else
                      cmp_ = &сравни;

                   if (счёт !is 0)
                      {       // must rebuild дерево!
                      incVersion();
                      RBCellT t = дерево.leftmost();
                      дерево = пусто;
                      счёт = 0;
                      while (t !is пусто)
                            {
                            добавь_(t.элемент(), нет);
                            t = t.successor();
                            }
                      }
                   }
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
                дерево = пусто;
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.удалиВсе.
         * Время complexity: O(лог n * экземпляры(элемент)).
         * See_Also: util.collection.impl.Collection.Коллекция.удалиВсе
        **/
        public final проц удалиВсе(T элемент)
        {
                удали_(элемент, да);
        }


        /**
         * Implements util.collection.impl.Collection.Коллекция.removeOneOf.
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.Collection.Коллекция.removeOneOf
        **/
        public final проц удали(T элемент)
        {
                удали_(элемент, нет);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.replaceOneOf
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.Collection.Коллекция.replaceOneOf
        **/
        public final проц замени(T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, нет);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.replaceAllOf.
         * Время complexity: O(лог n * экземпляры(старЭлемент)).
         * See_Also: util.collection.impl.Collection.Коллекция.replaceAllOf
        **/
        public final проц замениВсе(T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, да);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.возьми.
         * Время complexity: O(лог n).
         * Takes the least элемент.
         * See_Also: util.collection.impl.Collection.Коллекция.возьми
        **/
        public final T возьми()
        {
                if (счёт !is 0)
                   {
                   RBCellT p = дерево.leftmost();
                   T v = p.элемент();
                   дерево = p.удали(дерево);
                   decCount();
                   return v;
                   }

                проверьИндекс(0);
                return T.init; // not reached
        }


        // MutableBag methods

        /**
         * Implements util.collection.MutableBag.добавьIfAbsent
         * Время complexity: O(лог n).
         * See_Also: util.collection.MutableBag.добавьIfAbsent
        **/
        public final проц добавьЕсли (T элемент)
        {
                добавь_(элемент, да);
        }


        /**
         * Implements util.collection.MutableBag.добавь.
         * Время complexity: O(лог n).
         * See_Also: util.collection.MutableBag.добавь
        **/
        public final проц добавь (T элемент)
        {
                добавь_(элемент, нет);
        }


        // helper methods

        private final проц добавь_(T элемент, бул проверьOccurrence)
        {
                проверьЭлемент(элемент);

                if (дерево is пусто)
                   {
                   дерево = new RBCellT(элемент);
                   incCount();
                   }
                else
                   {
                   RBCellT t = дерево;

                   for (;;)
                       {
                       цел diff = cmp_(элемент, t.элемент());
                       if (diff is 0 && проверьOccurrence)
                           return ;
                       else
                          if (diff <= 0)
                             {
                             if (t.left() !is пусто)
                                 t = t.left();
                             else
                                {
                                дерево = t.insertLeft(new RBCellT(элемент), дерево);
                                incCount();
                                return ;
                                }
                             }
                          else
                             {
                             if (t.right() !is пусто)
                                 t = t.right();
                              else
                                 {
                                 дерево = t.insertRight(new RBCellT(элемент), дерево);
                                 incCount();
                                 return ;
                                 }
                              }
                          }
                   }
        }


        private final проц удали_(T элемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(элемент))
                    return ;

                while (счёт > 0)
                      {
                      RBCellT p = дерево.найди(элемент, cmp_);

                      if (p !is пусто)
                         {
                         дерево = p.удали(дерево);
                         decCount();
                         if (!всеСлучаи)
                             return ;
                         }
                      else
                         break;
                      }
        }

        private final проц замени_(T старЭлемент, T новЭлемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(старЭлемент) || счёт is 0 || старЭлемент == новЭлемент)
                    return ;

                while (содержит(старЭлемент))
                      {
                      удали(старЭлемент);
                      добавь (новЭлемент);
                      if (!всеСлучаи)
                          return ;
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
                assert(cmp_ !is пусто);
                assert(((счёт is 0) is (дерево is пусто)));
                assert((дерево is пусто || дерево.размер() is счёт));

                if (дерево !is пусто)
                   {
                   дерево.проверьРеализацию();
                   T последний = T.init;
                   RBCellT t = дерево.leftmost();
                   while (t !is пусто)
                         {
                         T v = t.элемент();
                         if (последний !is T.init)
                             assert(cmp_(последний, v) <= 0);
                         последний = v;
                         t = t.successor();
                         }
                   }
        }


        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class CellIterator(T) : AbstractIterator!(T)
        {
                private RBCellT ячейка;

                public this (TreeBag bag)
                {
                        super(bag);

                        if (bag.дерево)
                            ячейка = bag.дерево.leftmost;
                }

                public final T получи()
                {
                        decRemaining();
                        auto v = ячейка.элемент();
                        ячейка = ячейка.successor();
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
                auto bag = new TreeBag!(ткст);
                bag.добавь ("zebra");
                bag.добавь ("bar");
                bag.добавь ("barrel");
                bag.добавь ("foo");
                bag.добавь ("apple");

                foreach (значение; bag.элементы) {}

                auto элементы = bag.элементы();
                while (элементы.ещё)
                       auto v = элементы.получи();

                foreach (значение; bag.элементы)
                         Квывод (значение).нс;
                     
                bag.проверьРеализацию();
        }
}
