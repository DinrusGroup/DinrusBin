/*******************************************************************************

        Файл: Коллекция.d

        Originally записано by Doug Lea и released преобр_в the public домен. 
        Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
        Inc, Loral, и everyone contributing, testing, и using this код.

        History:
        Дата     Who                What
        24Sep95  dl@cs.oswego.edu   Созд из_ util.collection.d  working файл
        13Oct95  dl                 Добавь assert
        22Oct95  dl                 Добавь excludeElements, removeElements
        28jan97  dl                 сделай class public; isolate version changes
        14Dec06  kb                 Adapted for Dinrus usage
        
********************************************************************************/

module util.collection.impl.Collection;

private import  exception;

private import  util.collection.model.View,
                util.collection.model.Iterator,
                util.collection.model.Dispenser;

/*******************************************************************************

        Коллекция serves as a convenient основа class for most implementations
        of изменяемый containers. It maintains a version число и элемент счёт.
        It also provопрes default implementations of many collection operations. 

        Authors: Doug Lea

********************************************************************************/

public abstract class Коллекция(T) : Dispenser!(T)
{
        alias View!(T)          ViewT;

        alias бул delegate(T)  Предикат;


        // экземпляр variables

        /***********************************************************************

                version represents the текущ version число

        ************************************************************************/

        protected бцел vershion;

        /***********************************************************************

                скринер hold the supplied элемент скринер

        ************************************************************************/

        protected Предикат скринер;

        /***********************************************************************

                счёт holds the число of элементы.

        ************************************************************************/

        protected бцел счёт;

        // constructors

        /***********************************************************************

                Initialize at version 0, an пустой счёт, и supplied скринер

        ************************************************************************/

        protected this (Предикат скринер = пусто)
        {
                this.скринер = скринер;
        }


        /***********************************************************************

        ************************************************************************/

        protected final static бул действительныйАргумент (T элемент)
        {
                static if (is (T : Объект))
                          {
                          if (элемент is пусто)
                              return нет;
                          }
                return да;
        }

        // Default implementations of Коллекция methods

        /***********************************************************************

                expose collection контент as an Массив

        ************************************************************************/

        public T[] вМассив ()
        {
                auto результат = new T[this.размер];
        
                цел i = 0;
                foreach (e; this)
                         результат[i++] = e;

                return результат;
        }

        /***********************************************************************

                Время complexity: O(1).
                See_Also: util.collection.impl.Collection.Коллекция.drained

        ************************************************************************/

        public final бул drained()
        {
                return счёт is 0;
        }

        /***********************************************************************

                Время complexity: O(1).
                Возвращает: the счёт of элементы currently in the collection
                See_Also: util.collection.impl.Collection.Коллекция.размер

        ************************************************************************/

        public final бцел размер()
        {
                return счёт;
        }

        /***********************************************************************

                Checks if элемент is an allowed элемент for this collection.
                This will not throw an исключение, but any другой attemp в_ добавь an
                не_годится элемент will do.

                Время complexity: O(1) + время of скринер, if present

                See_Also: util.collection.impl.Collection.Коллекция.allows

        ************************************************************************/

        public final бул allows (T элемент)
        {
                return действительныйАргумент(элемент) &&
                                 (скринер is пусто || скринер(элемент));
        }


        /***********************************************************************

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

        public бул совпадает(ViewT другой)
        {
/+
                if (другой is пусто)
                    return нет;
                else
                   if (другой is this)
                       return да;
                   else
                      if (cast(SortedKeys) this)
                         {
                         if (!(cast(Карта) другой))
                               return нет;
                         else
                            return sameOrderedPairs(cast(Карта)this, cast(Карта)другой);
                         }
                      else
                         if (cast(Карта) this)
                            {
                            if (!(cast(Карта) другой))
                                  return нет;
                            else
                               return samePairs(cast(Карта)(this), cast(Карта)(другой));
                            }
                         else
                            if ((cast(Seq) this) || (cast(SortedValues) this))
                                 return sameOrderedElements(this, другой);
                            else
                               if (cast(Рюкзак) this)
                                   return sameOccurrences(this, другой);
                               else
                                  if (cast(Набор) this)
                                      return sameInclusions(this, cast(View)(другой));
                                  else
                                     return нет;
+/
                   return нет;
        }

        // Default implementations of MutableCollection methods

        /***********************************************************************

                Время complexity: O(1).
                See_Also: util.collection.impl.Collection.Коллекция.version

        ************************************************************************/

        public final бцел мутация()
        {
                return vershion;
        }

        // Объект methods

        /***********************************************************************

                Default implementation of вТкст for Collections. Not
                very pretty, but parenthesizing each элемент means that
                for most kinds of элементы, it's conceivable that the
                strings could be разобрано и использован в_ build другой util.collection.

                Not a very pretty implementation either. Casts are использован
                в_ получи at элементы/ключи

        ************************************************************************/

        public override ткст вТкст()
        {
                сим[16] врем;
                
                return "<" ~ this.classinfo.имя ~ ", размер:" ~ itoa(врем, размер()) ~ ">";
        }


        /***********************************************************************

        ************************************************************************/

        protected final ткст itoa(ткст буф, бцел i)
        {
                auto j = буф.length;
                
                do {
                   буф[--j] = cast(сим) (i % 10 + '0');
                   } while (i /= 10);
                return буф [j..$];
        }
        
        // protected operations on version и счёт

        /***********************************************************************

                change the version число

        ************************************************************************/

        protected final проц incVersion()
        {
                ++vershion;
        }


        /***********************************************************************

                Increment the элемент счёт и обнови version

        ************************************************************************/

        protected final проц incCount()
        {
                счёт++;
                incVersion();
        }

        /***********************************************************************

                Decrement the элемент счёт и обнови version

        ************************************************************************/

        protected final проц decCount()
        {
                счёт--;
                incVersion();
        }


        /***********************************************************************

                добавь в_ the элемент счёт и обнови version if изменён

        ************************************************************************/

        protected final проц добавьToCount(бцел c)
        {
                if (c !is 0)
                   {
                   счёт += c;
                   incVersion();
                   }
        }
        

        /***********************************************************************

                установи the элемент счёт и обнови version if изменён

        ************************************************************************/

        protected final проц устСчёт(бцел c)
        {
                if (c !is счёт)
                   {
                   счёт = c;
                   incVersion();
                   }
        }


        /***********************************************************************

                Helper метод left public since it might be useful

        ************************************************************************/

        public final static бул sameInclusions(ViewT s, ViewT t)
        {
                if (s.размер !is t.размер)
                    return нет;

                try { // установи up в_ return нет on collection exceptions
                    auto ts = t.элементы();
                    while (ts.ещё)
                          {
                          if (!s.содержит(ts.получи))
                              return нет;
                          }
                    return да;
                    } catch (НетЭлементаИскл ex)
                            {
                            return нет;
                            }
        }

        /***********************************************************************

                Helper метод left public since it might be useful

        ************************************************************************/

        public final static бул sameOccurrences(ViewT s, ViewT t)
        {
                if (s.размер !is t.размер)
                    return нет;

                auto ts = t.элементы();
                T последний = T.init; // minor optimization -- пропусти two successive if same

                try { // установи up в_ return нет on collection exceptions
                    while (ts.ещё)
                          {
                          T m = ts.получи;
                          if (m !is последний)
                             {
                             if (s.экземпляры(m) !is t.экземпляры(m))
                                 return нет;
                             }
                          последний = m;
                          }
                    return да;
                    } catch (НетЭлементаИскл ex)
                            {
                            return нет;
                            }
        }
        

        /***********************************************************************

                Helper метод left public since it might be useful

        ************************************************************************/

        public final static бул sameOrderedElements(ViewT s, ViewT t)
        {
                if (s.размер !is t.размер)
                    return нет;

                auto ts = t.элементы();
                auto ss = s.элементы();

                try { // установи up в_ return нет on collection exceptions
                    while (ts.ещё)
                          {
                          T m = ts.получи;
                          T o = ss.получи;
                          if (m != o)
                              return нет;
                          }
                    return да;
                    } catch (НетЭлементаИскл ex)
                            {       
                            return нет;
                            }
        }

        // misc common helper methods

        /***********************************************************************

                PrincИПal метод в_ throw a НетЭлементаИскл.
                Besопрes индекс проверьs in Seqs, you can use it в_ проверь for
                operations on пустой собериions via проверьИндекс(0)

        ************************************************************************/

        protected final проц проверьИндекс(цел индекс)
        {
                if (индекс < 0 || индекс >= счёт)
                   {
                   ткст сооб;

                   if (счёт is 0)
                       сооб = "Элемент доступ on пустой collection";
                   else
                      {
                      сим[16] индкс, cnt;
                      сооб = "Index " ~ itoa (индкс, индекс) ~ " out of range for collection of размер " ~ itoa (cnt, счёт);
                      }
                   throw new НетЭлементаИскл(сооб);
                   }
        }

        
        /***********************************************************************

                PrincИПal метод в_ throw a IllegalElementException

        ************************************************************************/

        protected final проц проверьЭлемент(T элемент)
        {
                if (! allows(элемент))
                   {
                   throw new IllegalElementException("Attempt в_ include не_годится элемент _in Коллекция");
                   }
        }

        /***********************************************************************

                See_Also: util.collection.model.View.View.проверьРеализацию

        ************************************************************************/

        public проц проверьРеализацию()
        {
                assert(счёт >= 0);
        }
        //public override проц проверьРеализацию() //Doesn't компилируй with the override attribute

        /***********************************************************************

                Cause the collection в_ become пустой. 

        ************************************************************************/

        abstract проц очисть();

        /***********************************************************************

                Exclude все occurrences of the indicated элемент из_ the collection. 
                No effect if элемент not present.
                Параметры:
                    элемент = the элемент в_ exclude.
                ---
                !имеется(элемент) &&
                размер() == PREV(this).размер() - PREV(this).экземпляры(элемент) &&
                no другой элемент changes &&
                Версия change iff PREV(this).имеется(элемент)
                ---

        ************************************************************************/

        abstract проц удалиВсе(T элемент);

        /***********************************************************************

                Удали an экземпляр of the indicated элемент из_ the collection. 
                No effect if !имеется(элемент)
                Параметры:
                    элемент = the элемент в_ удали
                ---
                let occ = max(1, экземпляры(элемент)) in
                 размер() == PREV(this).размер() - occ &&
                 экземпляры(элемент) == PREV(this).экземпляры(элемент) - occ &&
                 no другой элемент changes &&
                 version change iff occ == 1
                ---

        ************************************************************************/

        abstract проц удали (T элемент);
        
        /***********************************************************************

                Замени an occurrence of старЭлемент with новЭлемент.
                No effect if does not hold старЭлемент or if старЭлемент.равно(новЭлемент).
                The operation имеется a consistent, but slightly special interpretation
                when applied в_ Sets. For Sets, because элементы occur at
                most once, if новЭлемент is already included, replacing старЭлемент with
                with новЭлемент имеется the same effect as just removing старЭлемент.
                ---
                let цел delta = старЭлемент.равно(новЭлемент)? 0 : 
                              max(1, PREV(this).экземпляры(старЭлемент) in
                 экземпляры(старЭлемент) == PREV(this).экземпляры(старЭлемент) - delta &&
                 экземпляры(новЭлемент) ==  (this instanceof Набор) ? 
                        max(1, PREV(this).экземпляры(старЭлемент) + delta):
                               PREV(this).экземпляры(старЭлемент) + delta) &&
                 no другой элемент changes &&
                 Версия change iff delta != 0
                ---
                Throws: IllegalElementException if имеется(старЭлемент) и !allows(новЭлемент)

        ************************************************************************/

        abstract проц замени (T старЭлемент, T новЭлемент);

        /***********************************************************************

                Замени все occurrences of старЭлемент with новЭлемент.
                No effect if does not hold старЭлемент or if старЭлемент.равно(новЭлемент).
                The operation имеется a consistent, but slightly special interpretation
                when applied в_ Sets. For Sets, because элементы occur at
                most once, if новЭлемент is already included, replacing старЭлемент with
                with новЭлемент имеется the same effect as just removing старЭлемент.
                ---
                let цел delta = старЭлемент.равно(новЭлемент)? 0 : 
                           PREV(this).экземпляры(старЭлемент) in
                 экземпляры(старЭлемент) == PREV(this).экземпляры(старЭлемент) - delta &&
                 экземпляры(новЭлемент) ==  (this instanceof Набор) ? 
                        max(1, PREV(this).экземпляры(старЭлемент) + delta):
                               PREV(this).экземпляры(старЭлемент) + delta) &&
                 no другой элемент changes &&
                 Версия change iff delta != 0
                ---
                Throws: IllegalElementException if имеется(старЭлемент) и !allows(новЭлемент)

        ************************************************************************/

        abstract проц замениВсе(T старЭлемент, T новЭлемент);

        /***********************************************************************

                Exclude все occurrences of each элемент of the Обходчик.
                Behaviorally equivalent в_
                ---
                while (e.ещё())
                  удалиВсе(e.получи());
                ---
                Param :
                    e = the enumeration of элементы в_ exclude.

                Throws: CorruptedIteratorException is propagated if thrown

                See_Also: util.collection.impl.Collection.Коллекция.удалиВсе

        ************************************************************************/

        abstract проц удалиВсе (Обходчик!(T) e);

        /***********************************************************************

                 Удали an occurrence of each элемент of the Обходчик.
                 Behaviorally equivalent в_

                 ---
                 while (e.ещё())
                    удали (e.получи());
                 ---

                 Param:
                    e = the enumeration of элементы в_ удали.

                 Throws: CorruptedIteratorException is propagated if thrown

        ************************************************************************/

        abstract проц удали (Обходчик!(T) e);

        /***********************************************************************

                Удали и return an элемент.  Implementations
                may strengthen the guarantee about the nature of this элемент.
                but in general it is the most convenient or efficient элемент в_ удали.

                Examples:
                One way в_ перемести все элементы из_ 
                MutableCollection a в_ MutableBag b is:
                ---
                while (!a.пустой())
                    b.добавь(a.возьми());
                ---

                Возвращает:
                    an элемент v such that PREV(this).имеется(v) 
                    и the postconditions of removeOneOf(v) hold.

                Throws: НетЭлементаИскл iff drained.

        ************************************************************************/

        abstract T возьми();
}


