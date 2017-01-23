/*******************************************************************************

        Файл: ХэшКарта.d

        Originally записано by Doug Lea и released преобр_в the public домен. 
        Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
        Inc, Loral, и everyone contributing, testing, и using this код.

        History:
        Дата     Who                What
        24Sep95  dl@cs.oswego.edu   Созд из_ collection.d  working файл
        13Oct95  dl                 Changed protection statuses
        21Oct95  dl                 fixed ошибка in удалиПо
        9Apr97   dl                 made Serializable
        14Dec06  kb                 Converted, templated & reshaped for Dinrus
        
********************************************************************************/

module util.collection.HashMap;

private import  exception;

/+
private import  io.protocol.model,
                io.protocol.model;
+/
private import  util.collection.model.HashParams,
                util.collection.model.GuardIterator;

private import  util.collection.impl.LLCell,
                util.collection.impl.LLPair,
                util.collection.impl.MapCollection,
                util.collection.impl.AbstractIterator;

/*******************************************************************************

         Хэш таблица implementation of Карта
                
         author: Doug Lea
                @version 0.94

         <P> For an introduction в_ this package see <A HREF="индекс.html"
         > Overview </A>.

********************************************************************************/


deprecated public class ХэшКарта(K, V) : КоллекцияКарт!(K, V), ПараметрыХэш
{
        alias LLCell!(V)                LLCellT;
        alias LLPair!(K, V)             LLPairT;

        alias КоллекцияКарт!(K, V).удали     удали;
        alias КоллекцияКарт!(K, V).удалиВсе  удалиВсе;

        // экземпляр variables

        /***********************************************************************

                The таблица. Each Запись is a список. Пусто if no таблица allocated

        ************************************************************************/
  
        private LLPairT таблица[];

        /***********************************************************************

                The порог загрузи factor

        ************************************************************************/

        private плав факторЗагрузки;


        // constructors

        /***********************************************************************

                Make a new пустой карта в_ use given элемент скринер.
        
        ************************************************************************/

        public this (Предикат скринер = пусто)
        {
                this(скринер, дефФакторЗагрузки);
        }

        /***********************************************************************

                Special version of constructor needed by клонируй()
        
        ************************************************************************/

        protected this (Предикат s, плав f)
        {
                super(s);
                таблица = пусто;
                факторЗагрузки = f;
        }

        /***********************************************************************

                Make an independent копируй of the таблица. Elements themselves
                are not cloned.
        
        ************************************************************************/

        public final ХэшКарта!(K, V) дубликат()
        {
                auto c = new ХэшКарта!(K, V) (скринер, факторЗагрузки);

                if (счёт !is 0)
                   {
                   цел cap = 2 * cast(цел)((счёт / факторЗагрузки)) + 1;
                   if (cap < дефНачКорзины)
                       cap = дефНачКорзины;

                   c.корзины(cap);

                   for (цел i = 0; i < таблица.length; ++i)
                        for (LLPairT p = таблица[i]; p !is пусто; p = cast(LLPairT)(p.следщ()))
                             c.добавь (p.ключ(), p.элемент());
                   }
                return c;
        }


        // ПараметрыХэш methods

        /***********************************************************************

                Implements util.collection.ПараметрыХэш.корзины.
                Время complexity: O(1).
                
                See_Also: util.collection.ПараметрыХэш.корзины.
        
        ************************************************************************/

        public final цел корзины()
        {
                return (таблица is пусто) ? 0 : таблица.length;
        }

        /***********************************************************************

                Implements util.collection.ПараметрыХэш.корзины.
                Время complexity: O(n).
                
                See_Also: util.collection.ПараметрыХэш.корзины.
        
        ************************************************************************/

        public final проц корзины(цел newCap)
        {
                if (newCap is корзины())
                    return ;
                else
                   if (newCap >= 1)
                       перемерь(newCap);
                   else
                      throw new ИсклНелегальногоАргумента("Неверный Хэш таблица размер");
        }

        /***********************************************************************

                Implements util.collection.ПараметрыХэш.thresholdLoadfactor
                Время complexity: O(1).
                
                See_Also: util.collection.ПараметрыХэш.thresholdLoadfactor
        
        ************************************************************************/

        public final плав пороговыйФакторЗагрузки()
        {
                return факторЗагрузки;
        }

        /***********************************************************************

                Implements util.collection.ПараметрыХэш.thresholdLoadfactor
                Время complexity: O(n).
                
                See_Also: util.collection.ПараметрыХэш.thresholdLoadfactor
        
        ************************************************************************/

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



        // View methods

        /***********************************************************************

                Implements util.collection.model.View.View.содержит.
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.model.View.View.содержит
        
        ************************************************************************/
        
        public final бул содержит(V элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                    return нет;

                for (цел i = 0; i < таблица.length; ++i)
                    {
                    LLPairT hd = таблица[i];
                    if (hd !is пусто && hd.найди(элемент) !is пусто)
                        return да;
                    }
                return нет;
        }

        /***********************************************************************

                Implements util.collection.model.View.View.экземпляры.
                Время complexity: O(n).
                
                See_Also: util.collection.model.View.View.экземпляры
        
        ************************************************************************/
        
        public final бцел экземпляры(V элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                    return 0;
    
                бцел c = 0;
                for (бцел i = 0; i < таблица.length; ++i)
                    {
                    LLPairT hd = таблица[i];
                    if (hd !is пусто)
                        c += hd.счёт(элемент);
                    }
                return c;
        }

        /***********************************************************************

                Implements util.collection.model.View.View.элементы.
                Время complexity: O(1).
                
                See_Also: util.collection.model.View.View.элементы
        
        ************************************************************************/
        
        public final GuardIterator!(V) элементы()
        {
                return ключи();
        }

        /***********************************************************************

                Implements util.collection.model.View.View.opApply
                Время complexity: O(n)
                
                See_Also: util.collection.model.View.View.opApply
        
        ************************************************************************/
        
        цел opApply (цел delegate (inout V значение) дг)
        {
                auto scope обходчик = new ОбходчикКарты!(K, V)(this);
                return обходчик.opApply (дг);
        }


        /***********************************************************************

                Implements util.collection.MapView.opApply
                Время complexity: O(n)
                
                See_Also: util.collection.MapView.opApply
        
        ************************************************************************/
        
        цел opApply (цел delegate (inout K ключ, inout V значение) дг)
        {
                auto scope обходчик = new ОбходчикКарты!(K, V)(this);
                return обходчик.opApply (дг);
        }


        // Карта methods

        /***********************************************************************

                Implements util.collection.Map.содержитКлюч.
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.Map.содержитКлюч
        
        ************************************************************************/
        
        public final бул содержитКлюч(K ключ)
        {
                if (!действительныйКлюч(ключ) || счёт is 0)
                    return нет;

                LLPairT p = таблица[hashOf(ключ)];
                if (p !is пусто)
                    return p.найдиКлюч(ключ) !is пусто;
                else
                   return нет;
        }

        /***********************************************************************

                Implements util.collection.Map.содержитПару
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.Map.содержитПару
        
        ************************************************************************/
        
        public final бул содержитПару(K ключ, V элемент)
        {
                if (!действительныйКлюч(ключ) || !действительныйАргумент(элемент) || счёт is 0)
                    return нет;

                LLPairT p = таблица[hashOf(ключ)];
                if (p !is пусто)
                    return p.найди(ключ, элемент) !is пусто;
                else
                   return нет;
        }

        /***********************************************************************

                Implements util.collection.Map.ключи.
                Время complexity: O(1).
                
                See_Also: util.collection.Map.ключи
        
        ************************************************************************/
        
        public final ОбходчикПар!(K, V) ключи()
        {
                return new ОбходчикКарты!(K, V)(this);
        }

        /***********************************************************************

                Implements util.collection.Map.получи.
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.Map.at
        
        ************************************************************************/
        
        public final V получи(K ключ)
        {
                проверьКлюч(ключ);
                if (счёт !is 0)
                   {
                   LLPairT p = таблица[hashOf(ключ)];
                   if (p !is пусто)
                      {
                      LLPairT c = p.найдиКлюч(ключ);
                      if (c !is пусто)
                          return c.элемент();
                      }
                   }
                throw new НетЭлементаИскл("no совпадают ключ");
        }


        /***********************************************************************

                Return the элемент associated with Key ключ. 
                @param ключ a ключ
                Возвращает: whether the ключ is contained or not
        
        ************************************************************************/

        public бул получи(K ключ, inout V элемент)
        {
                проверьКлюч(ключ);
                if (счёт !is 0)
                   {
                   LLPairT p = таблица[hashOf(ключ)];
                   if (p !is пусто)
                      {
                      LLPairT c = p.найдиКлюч(ключ);
                      if (c !is пусто)
                         {
                         элемент = c.элемент();
                         return да;
                         }
                      }
                   }
                return нет;
        }



        /***********************************************************************

                Implements util.collection.Map.ключК.
                Время complexity: O(n).
                
                See_Also: util.collection.Map.akyOf
        
        ************************************************************************/
        
        public final бул ключК(inout K ключ, V значение)
        {
                if (!действительныйАргумент(значение) || счёт is 0)
                    return нет;

                for (цел i = 0; i < таблица.length; ++i)
                    { 
                    LLPairT hd = таблица[i];
                    if (hd !is пусто)
                       {
                       auto p = (cast(LLPairT)(hd.найди(значение)));
                       if (p !is пусто)
                          {
                          ключ = p.ключ();
                          return да;
                          }
                       }
                    }
                return нет;
        }


        // Коллекция methods

        /***********************************************************************

                Implements util.collection.impl.Collection.Коллекция.очисть.
                Время complexity: O(1).
                
                See_Also: util.collection.impl.Collection.Коллекция.очисть
        
        ************************************************************************/
        
        public final проц очисть()
        {
                устСчёт(0);
                таблица = пусто;
        }

        /***********************************************************************

                Implements util.collection.impl.Collection.Коллекция.удалиВсе.
                Время complexity: O(n).
                
                See_Also: util.collection.impl.Collection.Коллекция.удалиВсе
        
        ************************************************************************/
        
        public final проц удалиВсе (V элемент)
        {
                удали_(элемент, да);
        }


        /***********************************************************************

                Implements util.collection.impl.Collection.Коллекция.removeOneOf.
                Время complexity: O(n).
                
                See_Also: util.collection.impl.Collection.Коллекция.removeOneOf
        
        ************************************************************************/
        
        public final проц удали (V элемент)
        {
                удали_(элемент, нет);
        }


        /***********************************************************************

                Implements util.collection.impl.Collection.Коллекция.replaceOneOf.
                Время complexity: O(n).
                
                See_Also: util.collection.impl.Collection.Коллекция.replaceOneOf
        
        ************************************************************************/

        public final проц замени (V старЭлемент, V новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, нет);
        }

        /***********************************************************************

                Implements util.collection.impl.Collection.Коллекция.replaceOneOf.
                Время complexity: O(n).
                
                See_Also: util.collection.impl.Collection.Коллекция.replaceOneOf
        
        ************************************************************************/

        public final проц замениВсе (V старЭлемент, V новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, да);
        }

        /***********************************************************************

                Implements util.collection.impl.Collection.Коллекция.возьми.
                Время complexity: O(число of корзины).
                
                See_Also: util.collection.impl.Collection.Коллекция.возьми
        
        ************************************************************************/
        
        public final V возьми()
        {
                if (счёт !is 0)
                   {
                   for (цел i = 0; i < таблица.length; ++i)
                       {
                       if (таблица[i] !is пусто)
                          {
                          decCount();
                          auto v = таблица[i].элемент();
                          таблица[i] = cast(LLPairT)(таблица[i].следщ());
                          return v;
                          }
                       }
                   }
                проверьИндекс(0);
                return V.init; // not reached
        }

        // Карта methods

        /***********************************************************************

                Implements util.collection.Map.добавь.
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.Map.добавь
        
        ************************************************************************/
        
        public final проц добавь (K ключ, V элемент)
        {
                проверьКлюч(ключ);
                проверьЭлемент(элемент);

                if (таблица is пусто)
                    перемерь (дефНачКорзины);

                цел h = hashOf(ключ);
                LLPairT hd = таблица[h];
                if (hd is пусто)
                   {
                   таблица[h] = new LLPairT(ключ, элемент, hd);
                   incCount();
                   return;
                   }
                else
                   {
                   LLPairT p = hd.найдиКлюч(ключ);
                   if (p !is пусто)
                      {
                      if (p.элемент() != (элемент))
                         {
                         p.элемент(элемент);
                         incVersion();
                         }
                      }
                   else
                      {
                      таблица[h] = new LLPairT(ключ, элемент, hd);
                      incCount();
                      проверьLoadFactor(); // we only проверь загрузи factor on добавь в_ Неукmpty bin
                      }
                   }
        }


        /***********************************************************************

                Implements util.collection.Map.удали.
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.Map.удали
        
        ************************************************************************/
        
        public final проц удалиКлюч (K ключ)
        {
                if (!действительныйКлюч(ключ) || счёт is 0)
                    return;

                цел h = hashOf(ключ);
                LLPairT hd = таблица[h];
                LLPairT p = hd;
                LLPairT trail = p;

                while (p !is пусто)
                      {
                      LLPairT n = cast(LLPairT)(p.следщ());
                      if (p.ключ() == (ключ))
                         {
                         decCount();
                         if (p is hd)
                             таблица[h] = n;
                         else
                            trail.отвяжиСледщ();
                         return;
                         }
                      else
                         {
                         trail = p;
                         p = n;
                         }
                      }
        }

        /***********************************************************************

                Implements util.collection.Map.replaceElement.
                Время complexity: O(1) average; O(n) worst.
                
                See_Also: util.collection.Map.replaceElement
        
        ************************************************************************/
        
        public final проц замениПару (K ключ, V старЭлемент, V новЭлемент)
        {
                if (!действительныйКлюч(ключ) || !действительныйАргумент(старЭлемент) || счёт is 0)
                    return;

                LLPairT p = таблица[hashOf(ключ)];
                if (p !is пусто)
                   {
                   LLPairT c = p.найди(ключ, старЭлемент);
                   if (c !is пусто)
                      {
                      проверьЭлемент(новЭлемент);
                      c.элемент(новЭлемент);
                      incVersion();
                      }
                   }
        }

        // Helper methods

        /***********************************************************************

                Check в_ see if we are past загрузи factor порог. If so,
                перемерь so that we are at half of the desired порог.
                Also while at it, проверь в_ see if we are пустой so can just
                отвяжи таблица.
        
        ************************************************************************/
        
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

        /***********************************************************************

                маска off и remainder the hashCode for элемент
                so it can be использован as таблица индекс
        
        ************************************************************************/

        protected final цел hashOf(K ключ)
        {
                return (typeid(K).дайХэш(&ключ) & 0x7FFFFFFF) % таблица.length;
        }


        /***********************************************************************

        ************************************************************************/

        protected final проц перемерь(цел newCap)
        {
                LLPairT newtab[] = new LLPairT[newCap];

                if (таблица !is пусто)
                   {
                   for (цел i = 0; i < таблица.length; ++i)
                       {
                       LLPairT p = таблица[i];
                       while (p !is пусто)
                             {
                             LLPairT n = cast(LLPairT)(p.следщ());
                             цел h = (p.keyХэш() & 0x7FFFFFFF) % newCap;
                             p.следщ(newtab[h]);
                             newtab[h] = p;
                             p = n;
                             }
                       }
                   }
                таблица = newtab;
                incVersion();
        }

        // helpers

        /***********************************************************************

        ************************************************************************/

        private final проц удали_(V элемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                    return;

                for (цел h = 0; h < таблица.length; ++h)
                    {
                    LLCellT hd = таблица[h];
                    LLCellT p = hd;
                    LLCellT trail = p;
                    while (p !is пусто)
                          {
                          LLPairT n = cast(LLPairT)(p.следщ());
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
                             if (! всеСлучаи)
                                   return;
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
        }

        /***********************************************************************

        ************************************************************************/

        private final проц замени_(V старЭлемент, V новЭлемент, бул всеСлучаи)
        {
                if (счёт is 0 || !действительныйАргумент(старЭлемент) || старЭлемент == (новЭлемент))
                    return;

                for (цел h = 0; h < таблица.length; ++h)
                    {
                    LLCellT hd = таблица[h];
                    LLCellT p = hd;
                    LLCellT trail = p;
                    while (p !is пусто)
                          {
                          LLPairT n = cast(LLPairT)(p.следщ());
                          if (p.элемент() == (старЭлемент))
                             {
                             проверьЭлемент(новЭлемент);
                             incVersion();
                             p.элемент(новЭлемент);
                             if (! всеСлучаи)
                                   return ;
                             }
                          trail = p;
                          p = n;
                          }
                    }
        }

/+
        // ИЧитатель & ИПисатель methods

        /***********************************************************************

        ************************************************************************/

        public override проц читай (ИЧитатель ввод)
        {
                цел     длин;
                K       ключ;
                V       элемент;
                
                ввод (длин) (факторЗагрузки) (счёт);
                таблица = (длин > 0) ? new LLPairT[длин] : пусто;

                for (длин=счёт; длин-- > 0;)
                    {
                    ввод (ключ) (элемент);
                    
                    цел h = hashOf (ключ);
                    таблица[h] = new LLPairT (ключ, элемент, таблица[h]);
                    }
        }
                        
        /***********************************************************************

        ************************************************************************/

        public override проц пиши (ИПисатель вывод)
        {
                вывод (таблица.length) (факторЗагрузки) (счёт);

                if (таблица.length > 0)
                    foreach (ключ, значение; ключи)
                             вывод (ключ) (значение);
        }
        
+/
        // ImplementationCheckable methods

        /***********************************************************************

                Implements util.collection.model.View.View.проверьРеализацию.
                
                See_Also: util.collection.model.View.View.проверьРеализацию
        
        ************************************************************************/
                        
        public override проц проверьРеализацию()
        {
                super.проверьРеализацию();

                assert(!(таблица is пусто && счёт !is 0));
                assert((таблица is пусто || таблица.length > 0));
                assert(факторЗагрузки > 0.0f);

                if (таблица is пусто)
                    return;

                цел c = 0;
                for (цел i = 0; i < таблица.length; ++i)
                    {
                    for (LLPairT p = таблица[i]; p !is пусто; p = cast(LLPairT)(p.следщ()))
                        {
                        ++c;
                        assert(allows(p.элемент()));
                        assert(allowsKey(p.ключ()));
                        assert(содержитКлюч(p.ключ()));
                        assert(содержит(p.элемент()));
                        assert(экземпляры(p.элемент()) >= 1);
                        assert(содержитПару(p.ключ(), p.элемент()));
                        assert(hashOf(p.ключ()) is i);
                        }
                    }
                assert(c is счёт);


        }


        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        private static class ОбходчикКарты(K, V) : АбстрактныйОбходчикКарты!(K, V)
        {
                private цел             ряд;
                private LLPairT         пара;
                private LLPairT[]       таблица;

                public this (ХэшКарта карта)
                {
                        super (карта);
                        таблица = карта.таблица;
                }

                public final V получи(inout K ключ)
                {
                        auto v = получи();
                        ключ = пара.ключ;
                        return v;
                }

                public final V получи()
                {
                        decRemaining();

                        if (пара)
                            пара = cast(LLPairT) пара.следщ();

                        while (пара is пусто)
                               пара = таблица [ряд++];

                        return пара.элемент();
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
        import io.Console;
                        
        проц main()
        {
                auto карта = new ХэшКарта!(ткст, дво);
                карта.добавь ("foo", 3.14);
                карта.добавь ("bar", 6.28);

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

                Квывод (карта).нс;
        }
}
