/*
 Файл: LinkMap.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses
 21Oct95  dl                 Fixed ошибка in удали

*/


module util.collection.LinkMap;

private import exception;

private import  io.protocol.model,
                io.protocol.model;

private import  util.collection.model.View,
                util.collection.model.GuardIterator;

private import  util.collection.impl.LLCell,
                util.collection.impl.LLPair,
                util.collection.impl.MapCollection,
                util.collection.impl.AbstractIterator;

/**
 * Linked списки of (ключ, элемент) pairs
 * author: Doug Lea
**/
deprecated public class LinkMap(K, T) : КоллекцияКарт!(K, T) // , ИЧитаемое, ИЗаписываемое
{
        alias LLCell!(T)               LLCellT;
        alias LLPair!(K, T)            LLPairT;

        alias КоллекцияКарт!(K, T).удали     удали;
        alias КоллекцияКарт!(K, T) .удалиВсе  удалиВсе;

        // экземпляр variables

        /**
         * The голова of the список. Пусто if пустой
        **/

        package LLPairT список;

        // constructors

        /**
         * Make an пустой список
        **/

        public this ()
        {
                this(пусто, пусто, 0);
        }

        /**
         * Make an пустой список with the supplied элемент скринер
        **/

        public this (Предикат скринер)
        {
                this(скринер, пусто, 0);
        }

        /**
         * Special version of constructor needed by клонируй()
        **/
        protected this (Предикат s, LLPairT l, цел c)
        {
                super(s);
                список = l;
                счёт = c;
        }

        /**
         * Make an independent копируй of the список. Does not клонируй элементы
        **/

        public LinkMap!(K, T) дубликат()
        {
                if (список is пусто)
                    return new LinkMap!(K, T) (скринер, пусто, 0);
                else
                   return new LinkMap!(K, T) (скринер, cast(LLPairT)(список.копируйСписок()), счёт);
        }


        // Коллекция methods

        /**
         * Implements util.collection.impl.Collection.Коллекция.содержит.
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
         * Implements util.collection.impl.Collection.Коллекция.экземпляры.
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
         * Implements util.collection.impl.Collection.Коллекция.элементы.
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


        // Карта methods


        /**
         * Implements util.collection.Map.содержитКлюч.
         * Время complexity: O(n).
         * See_Also: util.collection.Map.содержитКлюч
        **/
        public final бул содержитКлюч(K ключ)
        {
                if (!действительныйКлюч(ключ) || список is пусто)
                     return нет;

                return список.найдиКлюч(ключ) !is пусто;
        }

        /**
         * Implements util.collection.Map.содержитПару
         * Время complexity: O(n).
         * See_Also: util.collection.Map.содержитПару
        **/
        public final бул содержитПару(K ключ, T элемент)
        {
                if (!действительныйКлюч(ключ) || !действительныйАргумент(элемент) || список is пусто)
                    return нет;
                return список.найди(ключ, элемент) !is пусто;
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
         * Время complexity: O(n).
         * See_Also: util.collection.Map.получи
        **/
        public final T получи(K ключ)
        {
                проверьКлюч(ключ);
                if (список !is пусто)
                   {
                   auto p = список.найдиКлюч(ключ);
                   if (p !is пусто)
                       return p.элемент();
                   }
                throw new НетЭлементаИскл("no совпадают Key");
        }

        /**
         * Return the элемент associated with Key ключ. 
         * Параметры:
         *   ключ = a ключ
         * Возвращает: whether the ключ is contained or not
        **/

        public final бул получи(K ключ, inout T элемент)
        {
                проверьКлюч(ключ);
                if (список !is пусто)
                   {
                   auto p = список.найдиКлюч(ключ);
                   if (p !is пусто)
                      {
                      элемент = p.элемент();
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

                auto p = (cast(LLPairT)(список.найди(значение)));
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
                список = пусто;
                устСчёт(0);
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
         * Implements util.collection.impl.Collection.Коллекция.удалиВсе.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.удалиВсе
        **/
        public final проц удалиВсе(T элемент)
        {
                удали_(элемент, да);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.removeOneOf.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.removeOneOf
        **/
        public final проц удали(T элемент)
        {
                удали_(элемент, нет);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.возьми.
         * Время complexity: O(1).
         * takes the первый элемент on the список
         * See_Also: util.collection.impl.Collection.Коллекция.возьми
        **/
        public final T возьми()
        {
                if (список !is пусто)
                   {
                   auto v = список.элемент();
                   список = cast(LLPairT)(список.следщ());
                   decCount();
                   return v;
                   }
                проверьИндекс(0);
                return T.init; // not reached
        }


        // MutableMap methods

        /**
         * Implements util.collection.impl.MapCollection.КоллекцияКарт.добавь.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.MapCollection.КоллекцияКарт.добавь
        **/
        public final проц добавь (K ключ, T элемент)
        {
                проверьКлюч(ключ);
                проверьЭлемент(элемент);

                if (список !is пусто)
                   {
                   auto p = список.найдиКлюч(ключ);
                   if (p !is пусто)
                      {
                      if (p.элемент() != (элемент))
                         {
                         p.элемент(элемент);
                         incVersion();
                         }
                      return ;
                      }
                   }
                список = new LLPairT(ключ, элемент, список);
                incCount();
        }


        /**
         * Implements util.collection.impl.MapCollection.КоллекцияКарт.удали.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.MapCollection.КоллекцияКарт.удали
        **/
        public final проц удалиКлюч (K ключ)
        {
                if (!действительныйКлюч(ключ) || список is пусто)
                    return ;

                auto p = список;
                auto trail = p;

                while (p !is пусто)
                      {
                      auto n = cast(LLPairT)(p.следщ());
                      if (p.ключ() == (ключ))
                         {
                         decCount();
                         if (p is список)
                             список = n;
                         else
                            trail.отвяжиСледщ();
                         return ;
                         }
                      else
                         {
                         trail = p;
                         p = n;
                         }
                      }
        }

        /**
         * Implements util.collection.impl.MapCollection.КоллекцияКарт.replaceElement.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.MapCollection.КоллекцияКарт.replaceElement
        **/
        public final проц замениПару (K ключ, T старЭлемент, T новЭлемент)
        {
                if (!действительныйКлюч(ключ) || !действительныйАргумент(старЭлемент) || список is пусто)
                     return ;

                auto p = список.найди(ключ, старЭлемент);
                if (p !is пусто)
                   {
                   проверьЭлемент(новЭлемент);
                   p.элемент(новЭлемент);
                   incVersion();
                   }
        }

        private final проц удали_(T элемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                     return ;

                auto p = список;
                auto trail = p;

                while (p !is пусто)
                      {
                      auto n = cast(LLPairT)(p.следщ());
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
                if (список is пусто || !действительныйАргумент(старЭлемент) || старЭлемент == (новЭлемент))
                    return ;

                auto p = список.найди(старЭлемент);
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

                for (auto p = список; p !is пусто; p = cast(LLPairT)(p.следщ()))
                    {
                    assert(allows(p.элемент()));
                    assert(allowsKey(p.ключ()));
                    assert(содержитКлюч(p.ключ()));
                    assert(содержит(p.элемент()));
                    assert(экземпляры(p.элемент()) >= 1);
                    assert(содержитПару(p.ключ(), p.элемент()));
                    }
        }


        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class ОбходчикКарты(K, V) : АбстрактныйОбходчикКарты!(K, V)
        {
                private LLPairT пара;
                
                public this (LinkMap карта)
                {
                        super (карта);
                        пара = карта.список;
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
                        пара = cast(LLPairT) пара.следщ();
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


         
debug(Test)
{
        проц main()
        {
                auto карта = new LinkMap!(Объект, дво);

                foreach (ключ, значение; карта.ключи) {typeof(ключ) x; x = ключ;}

                foreach (значение; карта.ключи) {}

                foreach (значение; карта.элементы) {}

                auto ключи = карта.ключи();
                while (ключи.ещё)
                       auto v = ключи.получи();

                foreach (значение; карта) {}
                foreach (ключ, значение; карта) {}

                карта.проверьРеализацию();
        }
}
