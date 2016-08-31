/*
 Файл: FilteringIterator.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 22Oct95  dl@cs.oswego.edu   Создано.

*/


module util.collection.iterator.FilteringIterator;

private import exception;

private import util.collection.model.Iterator;

/**
 *
 * FilteringIterators allow you в_ фильтр out элементы из_
 * другой enumerations before they are seen by their `consumers'
 * (i.e., the callers of `получи').
 *
 * FilteringIterators work as wrappers around другой Iterators.
 * To build one, you need an existing Обходчик (perhaps one
 * из_ coll.элементы(), for some Коллекция coll), и a Предикат
 * объект (i.e., implementing interface Предикат). 
 * For example, if you want в_ screen out everything but Panel
 * objects из_ a collection coll that might hold things другой than Panels,
 * пиши something of the form:
 * ---
 * Обходчик e = coll.элементы();
 * Обходчик panels = FilteringIterator(e, IsPanel);
 * while (panels.ещё())
 *  doSomethingWith(cast(Panel)(panels.получи()));
 * ---
 * To use this, you will also need в_ пиши a little class of the form:
 * ---
 * class IsPanel : Предикат {
 *  бул predicate(Объект v) { return cast(Panel) v !is пусто; }
 * }
 * ---
 * See_Also: util.collection.Предикат.predicate
 * author: Doug Lea
 *
**/

public class FilteringIterator(T) : Обходчик!(T)
{
        alias бул delegate(T) Предикат;
        
        // экземпляр variables

        /**
         * The enumeration we are wrapping
        **/

        private Обходчик!(T) src_;

        /**
         * The screening predicate
        **/

        private Предикат pred_;

        /**
         * The sense of the predicate. Нет means в_ invert
        **/

        private бул sign_;

        /**
         * The следщ элемент в_ hand out
        **/

        private T get_;

        /**
         * Да if we have a следщ элемент 
        **/

        private бул haveNext_;

        /**
         * Make a Фильтр using ист for the элементы, и p as the скринер,
         * selecting only those элементы of ист for which p is да
        **/

        public this (Обходчик!(T) ист, Предикат p)
        {
                this(ист, p, да);
        }

        /**
         * Make a Фильтр using ист for the элементы, и p as the скринер,
         * selecting only those элементы of ист for which p.predicate(v) == sense.
         * A значение of да for sense selects only значения for which p.predicate
         * is да. A значение of нет selects only those for which it is нет.
        **/
        public this (Обходчик!(T) ист, Предикат p, бул sense)
        {
                src_ = ист;
                pred_ = p;
                sign_ = sense;
                findNext();
        }

        /**
         * Implements util.collection.model.Iterator.ещё
        **/

        public final бул ещё()
        {
                return haveNext_;
        }

        /**
         * Implements util.collection.model.Iterator.получи.
        **/
        public final T получи()
        {
                if (! haveNext_)
                      throw new НетЭлементаИскл("exhausted enumeration");
                else
                   {
                   auto результат = get_;
                   findNext();
                   return результат;
                   }
        }


        цел opApply (цел delegate (inout T значение) дг)
        {
                цел результат;

                while (haveNext_)
                      {
                      auto значение = получи();
                      if ((результат = дг(значение)) != 0)
                           break;
                      }
                return результат;
        }


        /**
         * Traverse through src_ элементы finding one passing predicate
        **/
        private final проц findNext()
        {
                haveNext_ = нет;

                for (;;)
                    {
                    if (! src_.ещё())
                          return ;
                    else
                       {
                       try {
                           auto v = src_.получи();
                           if (pred_(v) is sign_)
                              {
                              haveNext_ = да;
                              get_ = v;
                              return;
                              }
                           } catch (НетЭлементаИскл ex)
                                   {
                                   return;
                                   }
                       }
                    }
        }
}

