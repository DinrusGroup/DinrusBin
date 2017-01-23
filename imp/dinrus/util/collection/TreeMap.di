/*
 Файл: TreeMap.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.TreeMap;

private import  exception;

private import  util.collection.model.Сравнитель,
                util.collection.model.SortedKeys,
                util.collection.model.GuardIterator;

private import  util.collection.impl.RBPair,
                util.collection.impl.RBCell,
                util.collection.impl.MapCollection,
                util.collection.impl.AbstractIterator;


/**
 *
 *
 * RedBlack Trees of (ключ, элемент) pairs
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/


deprecated public class TreeMap(K, T) : КоллекцияКарт!(K, T), SortedKeys!(K, T)
{
        alias RBCell!(T)                RBCellT;
        alias RBPair!(K, T)             RBPairT;
        alias Сравнитель!(K)            ComparatorT;
        alias GuardIterator!(T)         GuardIteratorT;

        alias КоллекцияКарт!(K, T).удали     удали;
        alias КоллекцияКарт!(K, T).удалиВсе  удалиВсе;


        // экземпляр variables

        /**
         * The корень of the дерево. Пусто if пустой.
        **/

        package RBPairT дерево;

        /**
         * The Сравнитель в_ use for ordering
        **/

        protected ComparatorT           cmp;
        protected Сравнитель!(T)        cmpElem;

        /**
         * Make an пустой дерево, using DefaultComparator for ordering
        **/

        public this ()
        {
                this (пусто, пусто, пусто, 0);
        }


        /**
         * Make an пустой дерево, using given скринер for screening элементы (not ключи)
        **/
        public this (Предикат скринер)
        {
                this(скринер, пусто, пусто, 0);
        }

        /**
         * Make an пустой дерево, using given Сравнитель for ordering
        **/
        public this (ComparatorT c)
        {
                this(пусто, c, пусто, 0);
        }

        /**
         * Make an пустой дерево, using given скринер и Сравнитель.
        **/
        public this (Предикат s, ComparatorT c)
        {
                this(s, c, пусто, 0);
        }

        /**
         * Special version of constructor needed by клонируй()
        **/

        protected this (Предикат s, ComparatorT c, RBPairT t, цел n)
        {
                super(s);
                счёт = n;
                дерево = t;
                cmp = (c is пусто) ? &compareKey : c;
                cmpElem = &compareElem;
        }

        /**
         * The default ключ сравнитель
         *
         * @param fst первый аргумент
         * @param snd секунда аргумент
         * Возвращает: a негатив число if fst is less than snd; a
         * positive число if fst is greater than snd; else 0
        **/

        private final цел compareKey(K fst, K snd)
        {
                if (fst is snd)
                    return 0;

                return typeid(K).сравни (&fst, &snd);
        }


        /**
         * The default элемент сравнитель
         *
         * @param fst первый аргумент
         * @param snd секунда аргумент
         * Возвращает: a негатив число if fst is less than snd; a
         * positive число if fst is greater than snd; else 0
        **/

        private final цел compareElem(T fst, T snd)
        {
                if (fst is snd)
                    return 0;

                return typeid(T).сравни (&fst, &snd);
        }


        /**
         * Созд an independent копируй. Does not клонируй элементы.
        **/

        public TreeMap!(K, T) дубликат()
        {
                if (счёт is 0)
                    return new TreeMap!(K, T)(скринер, cmp);
                else
                   return new TreeMap!(K, T)(скринер, cmp, cast(RBPairT)(дерево.copyTree()), счёт);
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
                return дерево.найди(элемент, cmpElem) !is пусто;
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
                return дерево.счёт(элемент, cmpElem);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.элементы
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Коллекция.элементы
        **/
        public final GuardIterator!(T) элементы()
        {
                return ключи();
        }

        /***********************************************************************

                Implements util.collection.model.View.View.opApply
                Время complexity: O(n)
                
                See_Also: util.collection.model.View.View.opApply
        
        ************************************************************************/
        
        цел opApply (цел delegate (inout T значение) дг)
        {
                auto scope обходчик = new ОбходчикКарты!(K, T)(this);
                return обходчик.opApply (дг);
        }


        /***********************************************************************

                Implements util.collection.MapView.opApply
                Время complexity: O(n)
                
                See_Also: util.collection.MapView.opApply
        
        ************************************************************************/
        
        цел opApply (цел delegate (inout K ключ, inout T значение) дг)
        {
                auto scope обходчик = new ОбходчикКарты!(K, T)(this);
                return обходчик.opApply (дг);
        }

        // KeySortedCollection methods

        /**
         * Implements util.collection.KeySortedCollection.сравнитель
         * Время complexity: O(1).
         * See_Also: util.collection.KeySortedCollection.сравнитель
        **/
        public final ComparatorT сравнитель()
        {
                return cmp;
        }

        /**
         * Use a new Сравнитель. Causes a reorganization
        **/

        public final проц сравнитель (ComparatorT c)
        {
                if (cmp !is c)
                   {
                   cmp = (c is пусто) ? &compareKey : c;

                   if (счёт !is 0)
                      {       
                      // must rebuild дерево!
                      incVersion();
                      auto t = cast(RBPairT) (дерево.leftmost());
                      дерево = пусто;
                      счёт = 0;
                      
                      while (t !is пусто)
                            {
                            добавь_(t.ключ(), t.элемент(), нет);
                            t = cast(RBPairT)(t.successor());
                            }
                      }
                   }
        }

        // Карта methods

        /**
         * Implements util.collection.Map.содержитКлюч.
         * Время complexity: O(лог n).
         * See_Also: util.collection.Map.содержитКлюч
        **/
        public final бул содержитКлюч(K ключ)
        {
                if (!действительныйКлюч(ключ) || счёт is 0)
                    return нет;
                return дерево.найдиКлюч(ключ, cmp) !is пусто;
        }

        /**
         * Implements util.collection.Map.содержитПару.
         * Время complexity: O(n).
         * See_Also: util.collection.Map.содержитПару
        **/
        public final бул содержитПару(K ключ, T элемент)
        {
                if (счёт is 0 || !действительныйКлюч(ключ) || !действительныйАргумент(элемент))
                    return нет;
                return дерево.найди(ключ, элемент, cmp) !is пусто;
        }

        /**
         * Implements util.collection.Map.ключи.
         * Время complexity: O(1).
         * See_Also: util.collection.Map.ключи
        **/
        public final ОбходчикПар!(K, T) ключи()
        {
                return new ОбходчикКарты!(K, T)(this);
        }

        /**
         * Implements util.collection.Map.получи.
         * Время complexity: O(лог n).
         * See_Also: util.collection.Map.получи
        **/
        public final T получи(K ключ)
        {
                if (счёт !is 0)
                   {
                   RBPairT p = дерево.найдиКлюч(ключ, cmp);
                   if (p !is пусто)
                       return p.элемент();
                   }
                throw new НетЭлементаИскл("no совпадают Key ");
        }

        /**
         * Return the элемент associated with Key ключ. 
         * @param ключ a ключ
         * Возвращает: whether the ключ is contained or not
        **/

        public final бул получи(K ключ, inout T значение)
        {
                if (счёт !is 0)
                   {
                   RBPairT p = дерево.найдиКлюч(ключ, cmp);
                   if (p !is пусто)
                      {
                      значение = p.элемент();
                      return да;
                      }
                   }
                return нет;
        }



        /**
         * Implements util.collection.Map.ключК.
         * Время complexity: O(n).
         * See_Also: util.collection.Map.ключК
        **/
        public final бул ключК(inout K ключ, T значение)
        {
                if (!действительныйАргумент(значение) || счёт is 0)
                     return нет;

                auto p = (cast(RBPairT)( дерево.найди(значение, cmpElem)));
                if (p is пусто)
                    return нет;

                ключ = p.ключ();
                return да;
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
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.удалиВсе
        **/
        public final проц удалиВсе(T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                      return ;

                RBPairT p = cast(RBPairT)(дерево.найди(элемент, cmpElem));
                while (p !is пусто)
                      {
                      дерево = cast(RBPairT)(p.удали(дерево));
                      decCount();
                      if (счёт is 0)
                          return ;
                      p = cast(RBPairT)(дерево.найди(элемент, cmpElem));
                      }
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.removeOneOf.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.removeOneOf
        **/
        public final проц удали (T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                      return ;

                RBPairT p = cast(RBPairT)(дерево.найди(элемент, cmpElem));
                if (p !is пусто)
                   {
                   дерево = cast(RBPairT)(p.удали(дерево));
                   decCount();
                   }
        }


        /**
         * Implements util.collection.impl.Collection.Коллекция.replaceOneOf.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.replaceOneOf
        **/
        public final проц замени(T старЭлемент, T новЭлемент)
        {
                if (счёт is 0 || !действительныйАргумент(старЭлемент) || !действительныйАргумент(старЭлемент))
                    return ;

                RBPairT p = cast(RBPairT)(дерево.найди(старЭлемент, cmpElem));
                if (p !is пусто)
                   {
                   проверьЭлемент(новЭлемент);
                   incVersion();
                   p.элемент(новЭлемент);
                   }
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.replaceAllOf.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.replaceAllOf
        **/
        public final проц замениВсе(T старЭлемент, T новЭлемент)
        {
                RBPairT p = cast(RBPairT)(дерево.найди(старЭлемент, cmpElem));
                while (p !is пусто)
                      {
                      проверьЭлемент(новЭлемент);
                      incVersion();
                      p.элемент(новЭлемент);
                      p = cast(RBPairT)(дерево.найди(старЭлемент, cmpElem));
                      }
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.возьми.
         * Время complexity: O(лог n).
         * Takes the элемент associated with the least ключ.
         * See_Also: util.collection.impl.Collection.Коллекция.возьми
        **/
        public final T возьми()
        {
                if (счёт !is 0)
                   {
                   RBPairT p = cast(RBPairT)(дерево.leftmost());
                   T v = p.элемент();
                   дерево = cast(RBPairT)(p.удали(дерево));
                   decCount();
                   return v;
                   }

                проверьИндекс(0);
                return T.init; // not reached
        }


        // MutableMap methods

        /**
         * Implements util.collection.impl.MapCollection.КоллекцияКарт.добавь.
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.MapCollection.КоллекцияКарт.добавь
        **/
        public final проц добавь(K ключ, T элемент)
        {
                добавь_(ключ, элемент, да);
        }


        /**
         * Implements util.collection.impl.MapCollection.КоллекцияКарт.удали.
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.MapCollection.КоллекцияКарт.удали
        **/
        public final проц удалиКлюч (K ключ)
        {
                if (!действительныйКлюч(ключ) || счёт is 0)
                      return ;

                RBCellT p = дерево.найдиКлюч(ключ, cmp);
                if (p !is пусто)
                   {
                   дерево = cast(RBPairT)(p.удали(дерево));
                   decCount();
                   }
        }


        /**
         * Implements util.collection.impl.MapCollection.КоллекцияКарт.replaceElement.
         * Время complexity: O(лог n).
         * See_Also: util.collection.impl.MapCollection.КоллекцияКарт.replaceElement
        **/
        public final проц замениПару (K ключ, T старЭлемент,
                                              T новЭлемент)
        {
                if (!действительныйКлюч(ключ) || !действительныйАргумент(старЭлемент) || счёт is 0)
                    return ;

                RBPairT p = дерево.найди(ключ, старЭлемент, cmp);
                if (p !is пусто)
                   {
                   проверьЭлемент(новЭлемент);
                   p.элемент(новЭлемент);
                   incVersion();
                   }
        }


        // helper methods


        private final проц добавь_(K ключ, T элемент, бул проверьOccurrence)
        {
                проверьКлюч(ключ);
                проверьЭлемент(элемент);

                if (дерево is пусто)
                   {
                   дерево = new RBPairT(ключ, элемент);
                   incCount();
                   }
                else
                   {
                   RBPairT t = дерево;
                   for (;;)
                       {
                       цел diff = cmp(ключ, t.ключ());
                       if (diff is 0 && проверьOccurrence)
                          {
                          if (t.элемент() != элемент)
                             {
                             t.элемент(элемент);
                             incVersion();
                             }
                          return ;
                          }
                       else
                          if (diff <= 0)
                             {
                             if (t.left() !is пусто)
                                 t = cast(RBPairT)(t.left());
                             else
                                {
                                дерево = cast(RBPairT)(t.insertLeft(new RBPairT(ключ, элемент), дерево));
                                incCount();
                                return ;
                                }
                             }
                          else
                             {
                             if (t.right() !is пусто)
                                 t = cast(RBPairT)(t.right());
                             else
                                {
                                дерево = cast(RBPairT)(t.insertRight(new RBPairT(ключ, элемент), дерево));
                                incCount();
                                return ;
                                }
                             }
                       }
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
                assert(cmp !is пусто);
                assert(((счёт is 0) is (дерево is пусто)));
                assert((дерево is пусто || дерево.размер() is счёт));

                if (дерево !is пусто)
                   {
                   дерево.проверьРеализацию();
                   K последний = K.init;
                   RBPairT t = cast(RBPairT)(дерево.leftmost());

                   while (t !is пусто)
                         {
                         K v = t.ключ();
                         assert((последний is K.init || cmp(последний, v) <= 0));
                         последний = v;
                         t = cast(RBPairT)(t.successor());
                         }
                   }
        }


        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class ОбходчикКарты(K, V) : АбстрактныйОбходчикКарты!(K, V)
        {
                private RBPairT пара;

                public this (TreeMap карта)
                {
                        super (карта);

                        if (карта.дерево)
                            пара = cast(RBPairT) карта.дерево.leftmost;
                }

                public final V получи(inout K ключ)
                {
                        if (пара)
                            ключ = пара.ключ;
                        return получи();
                }

                public final V получи()
                {
                        decRemaining();
                        auto v = пара.элемент();
                        пара = cast(RBPairT) пара.successor();
                        return v;
                }

                цел opApply (цел delegate (inout V значение) дг)
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

                цел opApply (цел delegate (inout K ключ, inout V значение) дг)
                {
                        K   ключ;
                        цел результат;

                        for (auto i=остаток(); i--;)
                            {
                            auto значение = получи(ключ);
                            if ((результат = дг(ключ, значение)) != 0)
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
                auto карта = new TreeMap!(ткст, дво);
                карта.добавь ("foo", 1);
                карта.добавь ("baz", 1);
                карта.добавь ("bar", 2);
                карта.добавь ("wumpus", 3);

                foreach (ключ, значение; карта.ключи) {typeof(ключ) x; x = ключ;}

                foreach (значение; карта.ключи) {}

                foreach (значение; карта.элементы) {}

                auto ключи = карта.ключи();
                while (ключи.ещё)
                       auto v = ключи.получи();

                foreach (значение; карта) {}

                foreach (ключ, значение; карта)
                         Квывод (ключ).нс;
                
                карта.проверьРеализацию();
        }
}
