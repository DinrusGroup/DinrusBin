/*******************************************************************************

        Файл: КоллекцияКарт.d

        Originally записано by Doug Lea и released преобр_в the public домен. 
        Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
        Inc, Loral, и everyone contributing, testing, и using this код.

        History:
        Дата     Who                What
        13Oct95  dl                 Созд
        28jan97  dl                 сделай class public
        14Dec06  kb                 adapted for Dinrus usage

********************************************************************************/

module util.collection.impl.MapCollection;

private import  exception;

private import  util.collection.impl.Collection;

private import  util.collection.model.Map,
                util.collection.model.View,
                util.collection.model.MapView,
                util.collection.model.Iterator,
                util.collection.model.SortedKeys;


/*******************************************************************************

        КоллекцияКарт extends Коллекция в_ provопрe default implementations of
        some Карта operations. 
                
        author: Doug Lea
                @version 0.93

        <P> For an introduction в_ this package see <A HREF="индекс.html"
        > Overview </A>.

 ********************************************************************************/

public abstract class КоллекцияКарт(K, T) : Коллекция!(T), Карта!(K, T)
{
        alias MapView!(K, T)            MapViewT;
        alias Коллекция!(T).удали     удали;
        alias Коллекция!(T).удалиВсе  удалиВсе;


        /***********************************************************************

                Initialize at version 0, an пустой счёт, и пусто скринер

        ************************************************************************/

        protected this ()
        {
                super();
        }

        /***********************************************************************

                Initialize at version 0, an пустой счёт, и supplied скринер

        ************************************************************************/

        protected this (Предикат скринер)
        {
                super(скринер);
        }

        /***********************************************************************

                Implements util.collection.Map.allowsKey.
                Default ключ-screen. Just проверьs for пусто.
                
                See_Also: util.collection.Map.allowsKey

        ************************************************************************/

        public final бул allowsKey(K ключ)
        {
                return (ключ !is K.init);
        }

        protected final бул действительныйКлюч(K ключ)
        {
                static if (is (K /*: Объект*/))
                          {
                          if (ключ is пусто)
                              return нет;
                          }
                return да;
        }

        /***********************************************************************

                PrincИПal метод в_ throw a IllegalElementException for ключи

        ************************************************************************/

        protected final проц проверьКлюч(K ключ)
        {
                if (!действительныйКлюч(ключ))
                   {
                   throw new IllegalElementException("Attempt в_ include не_годится ключ _in Коллекция");
                   }
        }

        /***********************************************************************

                Implements util.collection.impl.MapCollection.КоллекцияКарт.opIndexAssign
                Just calls добавь(ключ, элемент).

                See_Also: util.collection.impl.MapCollection.КоллекцияКарт.добавь

        ************************************************************************/

        public final проц opIndexAssign (T элемент, K ключ)
        {
                добавь (ключ, элемент);
        }

        /***********************************************************************

                Implements util.collection.impl.Collection.Коллекция.совпадает
                Время complexity: O(n).
                Default implementation. Fairly sleazy approach.
                (Defensible only when you remember that it is just a default impl.)
                It tries в_ cast в_ one of the known collection interface типы
                и then applies the corresponding сравнение rules.
                This suffices for все currently supported collection типы,
                but must be overrопрden if you define new Коллекция subinterfaces
                и/or implementations.
                
                See_Also: util.collection.impl.Collection.Коллекция.совпадает

        ************************************************************************/

        public override бул совпадает(View!(T) другой)
        {
                if (другой is пусто)
                   {}
                else
                   if (другой is this)
                       return да;
                   else
                      {
                      auto врем = cast (MapViewT) другой;
                      if (врем)
                          if (cast(SortedKeys!(K, T)) this)
                              return sameOrderedPairs(this, врем);
                          else
                             return samePairs(this, врем);
                      }
                return нет;
        }


        public final static бул samePairs(MapViewT s, MapViewT t)
        {
                if (s.размер !is t.размер)
                    return нет;

                try { // установи up в_ return нет on collection exceptions
                    foreach (ключ, значение; t.ключи)
                             if (! s.содержитПару (ключ, значение))
                                   return нет;
                    } catch (НетЭлементаИскл ex)
                            {
                            return нет;
                            }
                return да;
        }

        public final static бул sameOrderedPairs(MapViewT s, MapViewT t)
        {
                if (s.размер !is t.размер)
                    return нет;

                auto ss = s.ключи();
                try { // установи up в_ return нет on collection exceptions
                    foreach (ключ, значение; t.ключи)
                            {
                            K sk;
                            auto sv = ss.получи (sk);
                            if (sk != ключ || sv != значение)
                                return нет;
                            }
                    } catch (НетЭлементаИскл ex)
                            {
                            return нет;
                            }
                return да;
        }


        // Объект methods

        /***********************************************************************

                Implements util.collection.impl.Collection.Коллекция.удалиВсе
                See_Also: util.collection.impl.Collection.Коллекция.удалиВсе

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц удалиВсе (Обходчик!(T) e)
        {
                while (e.ещё)
                       удалиВсе (e.получи);
        }

        /***********************************************************************

                Implements util.collection.impl.Collection.Коллекция.removeElements
                See_Also: util.collection.impl.Collection.Коллекция.removeElements

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц удали (Обходчик!(T) e)
        {
                while (e.ещё)
                       удали (e.получи);
        }
}

