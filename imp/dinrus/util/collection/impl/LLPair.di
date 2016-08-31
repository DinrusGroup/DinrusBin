/*
 Файл: LLPair.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ util.collection.d  working файл

*/


module util.collection.impl.LLPair;

private import util.collection.impl.LLCell;

private import util.collection.model.Iterator;


/**
 *
 *
 * LLPairs are LLCells with ключи, и operations that deal with them.
 * As with LLCells, the are pure implementation tools.
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class LLPair(K, T) : LLCell!(T) 
{
        alias LLCell!(T).найди найди;
        alias LLCell!(T).счёт счёт;
        alias LLCell!(T).элемент элемент;


        // экземпляр variables

        private K key_;

        /**
         * Make a ячейка with given ключ, elment, и следщ link
        **/

        public this (K k, T v, LLPair n)
        {
                super(v, n);
                key_ = k;
        }

        /**
         * Make a пара with given ключ и элемент, и пусто следщ link
        **/

        public this (K k, T v)
        {
                super(v, пусто);
                key_ = k;
        }

        /**
         * Make a пара with пусто ключ, elment, и следщ link
        **/

        public this ()
        {
                super(T.init, пусто);
                key_ = K.init;
        }

        /**
         * return the ключ
        **/

        public final K ключ()
        {
                return key_;
        }

        /**
         * установи the ключ
        **/

        public final проц ключ(K k)
        {
                key_ = k;
        }


        /**
         * установи the ключ
        **/

        public final цел keyХэш()
        {
                return typeid(K).дайХэш(&key_);
        }


        /**
         * return a ячейка with ключ() ключ or пусто if no such
        **/

        public final LLPair найдиКлюч(K ключ)
        {
                for (auto p=this; p; p = cast(LLPair)cast(ук) p.next_)
                     if (p.ключ() == ключ)
                         return p;
                return пусто;
        }

        /**
         * return a ячейка holding the indicated пара or пусто if no such
        **/

        public final LLPair найди(K ключ, T элемент)
        {
                for (auto p=this; p; p = cast(LLPair)cast(ук) p.next_)
                     if (p.ключ() == ключ && p.элемент() == элемент)
                         return p;
                return пусто;
        }

        /**
         * Return the число of cells traversed в_ найди a ячейка with ключ() ключ,
         * or -1 if not present
        **/

        public final цел индексируйКлюч(K ключ)
        {
                цел i = 0;
                for (auto p=this; p; p = cast(LLPair)cast(ук) p.next_)
                    {
                    if (p.ключ() == ключ)
                        return i;
                    else
                       ++i;
                    }
                return -1;
        }

        /**
         * Return the число of cells traversed в_ найди a ячейка with indicated пара
         * or -1 if not present
        **/
        public final цел индекс(K ключ, T элемент)
        {
                цел i = 0;
                for (auto p=this; p; p = cast(LLPair)cast(ук) p.next_)
                    {
                    if (p.ключ() == ключ && p.элемент() == элемент)
                        return i;
                    else
                       ++i;
                    }
                return -1;
        }

        /**
         * Return the число of cells with ключ() ключ.
        **/
        public final цел учтиКлюч(K ключ)
        {
                цел c = 0;
                for (auto p=this; p; p = cast(LLPair)cast(ук) p.next_)
                     if (p.ключ() == ключ)
                         ++c;
                return c;
        }

        /**
         * Return the число of cells with indicated пара
        **/
        public final цел счёт(K ключ, T элемент)
        {
                цел c = 0;
                for (auto p=this; p; p = cast(LLPair)cast(ук) p.next_)
                     if (p.ключ() == ключ && p.элемент() == элемент)
                         ++c;
                return c;
        }

        protected final LLPair дубликат()
        {
                return new LLPair(ключ(), элемент(), cast(LLPair)cast(ук)(следщ()));
        }
}
