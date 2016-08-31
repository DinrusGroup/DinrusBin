/*
 Файл: AbstractIterator.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses
  9Apr97  dl                 made class public
*/


module util.collection.impl.AbstractIterator;

private import  exception;

private import  util.collection.model.View,
                util.collection.model.GuardIterator;
                


/**
 *
 * A convenient основа class for implementations of GuardIterator
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public abstract class AbstractIterator(T) : GuardIterator!(T)
{
        /**
         * The collection being enumerated
        **/

        private View!(T) view;

        /**
         * The version число of the collection we got upon construction
        **/

        private бцел мутация;

        /**
         * The число of элементы we think we have left.
         * Initialized в_ view.размер() upon construction
        **/

        private бцел togo;
        

        protected this (View!(T) v)
        {
                view = v;
                togo = v.размер();
                мутация = v.мутация();
        }

        /**
         * Implements util.collection.impl.Collection.CollectionIterator.corrupted.
         * Claim corruption if version numbers differ
         * See_Also: util.collection.impl.Collection.CollectionIterator.corrupted
        **/

        public final бул corrupted()
        {
                return мутация != view.мутация;
        }

        /**
         * Implements util.collection.impl.Collection.CollectionIterator.numberOfRemaingingElements.
         * See_Also: util.collection.impl.Collection.CollectionIterator.остаток
        **/
        public final бцел остаток()
        {
                return togo;
        }

        /**
         * Implements util.collection.model.Iterator.ещё.
         * Return да if остаток > 0 и not corrupted
         * See_Also: util.collection.model.Iterator.ещё
        **/
        public final бул ещё()
        {
                return togo > 0 && мутация is view.мутация;
        }

        /**
         * Subclass utility. 
         * Tries в_ декремент togo, raising exceptions
         * if it is already zero or if corrupted()
         * Always вызов as the первый строка of получи.
        **/
        protected final проц decRemaining()
        {
                if (мутация != view.мутация)
                    throw new CorruptedIteratorException ("Коллекция изменён during iteration");

                if (togo is 0)
                    throw new НетЭлементаИскл ("exhausted enumeration");

                --togo;
        }
}


public abstract class АбстрактныйОбходчикКарты(K, V) : AbstractIterator!(V), ОбходчикПар!(K, V) 
{
        abstract V получи (inout K ключ);

        protected this (View!(V) c)
        {
                super (c);
        }
}
