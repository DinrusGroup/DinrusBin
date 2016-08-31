/*
 Файл: ArrayIterator.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.iterator.ArrayIterator;

private import exception;

private import util.collection.model.GuardIterator;


/**
 *
 * ArrayIterator allows you в_ use массивы as Iterators
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class ArrayIterator(T) : GuardIterator!(T)
{
        private T [] arr_;
        private цел cur_;
        private цел size_;

        /**
         * Build an enumeration that returns successive элементы of the Массив
        **/
        public this (T масс[])
        {
                // arr_ = масс; cur_ = 0; size_ = масс._length;
                arr_ = масс;
                cur_ = -1;
                size_ = масс.length;
        }

        /**
         * Implements util.collection.impl.Collection.CollectionIterator.остаток
         * See_Also: util.collection.impl.Collection.CollectionIterator.остаток
        **/
        public бцел остаток()
        {
                return size_;
        }

        /**
         * Implements util.collection.model.Iterator.ещё.
         * See_Also: util.collection.model.Iterator.ещё
        **/
        public бул ещё()
        {
                return size_ > 0;
        }

        /**
         * Implements util.collection.impl.Collection.CollectionIterator.corrupted.
         * Always нет. Inconsistency cannot be reliably detected for массивы
         * Возвращает: нет
         * See_Also: util.collection.impl.Collection.CollectionIterator.corrupted
        **/

        public бул corrupted()
        {
                return нет;
        }

        /**
         * Implements util.collection.model.Iterator.получи().
         * See_Also: util.collection.model.Iterator.получи()
        **/
        public T получи()
        {
                if (size_ > 0)
                   {
                   --size_;
                   ++cur_;
                   return arr_[cur_];
                   }
                throw new НетЭлементаИскл ("Exhausted Обходчик");
        }


        цел opApply (цел delegate (inout T значение) дг)
        {
                цел результат;

                for (auto i=size_; i--;)
                    {
                    auto значение = получи();
                    if ((результат = дг(значение)) != 0)
                         break;
                    }
                return результат;
        }
}
