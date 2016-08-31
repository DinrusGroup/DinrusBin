/*
 Файл: InterleavingIterator.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 22Oct95  dl@cs.oswego.edu   Создано.

*/


module util.collection.iterator.InterleavingIterator;

private import  exception;

private import  util.collection.model.Iterator;

/**
 *
 * InterleavingIterators allow you в_ комбинируй the элементы
 * of two different enumerations as if they were one enumeration
 * before they are seen by their `consumers'.
 * This sometimes allows you в_ avoопр having в_ use a 
 * Коллекция объект в_ temporarily комбинируй two sets of Коллекция элементы()
 * that need в_ be собериed together for common processing.
 * <P>
 * The элементы are revealed (via получи()) in a purely
 * interleaved fashion, alternating between the первый и секунда
 * enumerations unless one of them имеется been exhausted, in which case
 * все остаток элементы of the другой are revealed until it too is
 * exhausted. 
 * <P>
 * InterleavingIterators work as wrappers around другой Iterators.
 * To build one, you need two existing Iterators.
 * For example, if you want в_ process together the элементы of
 * two Collections a и b, you could пиши something of the form:
 * <PRE>
 * Обходчик items = InterleavingIterator(a.элементы(), b.элементы());
 * while (items.ещё()) 
 *  doSomethingWith(items.получи());
 * </PRE>
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/


public class InterleavingIterator(T) : Обходчик!(T)
{

        /**
         * The первый источник; nulled out once it is exhausted
        **/

        private Обходчик!(T) fst_;

        /**
         * The секунда источник; nulled out once it is exhausted
        **/

        private Обходчик!(T) snd_;

        /**
         * The источник currently being использован
        **/

        private Обходчик!(T) current_;



        /**
         * Make an enumeration interleaving элементы из_ fst и snd
        **/

        public this (Обходчик!(T) fst, Обходчик!(T) snd)
        {
                fst_ = fst;
                snd_ = snd;
                current_ = snd_; // флип will сбрось в_ fst (if it can)
                флип();
        }

        /**
         * Implements util.collection.model.Iterator.ещё
        **/
        public final бул ещё()
        {
                return current_ !is пусто;
        }

        /**
         * Implements util.collection.model.Iterator.получи.
        **/
        public final T получи()
        {
                if (current_ is пусто)
                        throw new НетЭлементаИскл("exhausted обходчик");
                else
                {
                        // following строка may also throw ex, but there's nothing
                        // reasonable в_ do except распространить
                        auto результат = current_.получи();
                        флип();
                        return результат;
                }
        }


        цел opApply (цел delegate (inout T значение) дг)
        {
                цел результат;

                while (current_)
                      {
                      auto значение = получи();
                      if ((результат = дг(значение)) != 0)
                           break;
                      }
                return результат;
        }

        /**
         * Alternate sources
        **/

        private final проц флип()
        {
                if (current_ is fst_)
                {
                        if (snd_ !is пусто && !snd_.ещё())
                                snd_ = пусто;
                        if (snd_ !is пусто)
                                current_ = snd_;
                        else
                        {
                                if (fst_ !is пусто && !fst_.ещё())
                                        fst_ = пусто;
                                current_ = fst_;
                        }
                }
                else
                {
                        if (fst_ !is пусто && !fst_.ещё())
                                fst_ = пусто;
                        if (fst_ !is пусто)
                                current_ = fst_;
                        else
                        {
                                if (snd_ !is пусто && !snd_.ещё())
                                        snd_ = пусто;
                                current_ = snd_;
                        }
                }
        }


}

