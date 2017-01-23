/*
 Файл: BagCollection.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 13Oct95  dl                 Созд
 22Oct95  dl                 добавь добавьElements
 28jan97  dl                 сделай class public
*/


module util.collection.impl.BagCollection;

private import  util.collection.model.Bag,
                util.collection.model.Iterator;

private import  util.collection.impl.Collection;

/**
 *
 * MutableBagImpl extends MutableImpl в_ provопрe
 * default implementations of some Рюкзак operations. 
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public abstract class BagCollection(V) : Коллекция!(V), Рюкзак!(V)
{
        alias Рюкзак!(V).добавь               добавь;
        alias Коллекция!(V).удали     удали;
        alias Коллекция!(V).удалиВсе  удалиВсе;

        
        /**
         * Initialize at version 0, an пустой счёт, и пусто скринер
        **/

        protected this ()
        {
                super();
        }

        /**
         * Initialize at version 0, an пустой счёт, и supplied скринер
        **/
        protected this (Предикат скринер)
        {
                super(скринер);
        }

        /**
         * Implements util.collection.MutableBag.добавьElements
         * See_Also: util.collection.MutableBag.добавьElements
        **/

        public final проц добавь(Обходчик!(V) e)
        {
                foreach (значение; e)
                         добавь (значение);
        }


        // Default implementations of Рюкзак methods

version (VERBOSE)
{
        /**
         * Implements util.collection.Рюкзак.добавимЕслиНет
         * See_Also: util.collection.Рюкзак.добавимЕслиНет
        **/
        public final Рюкзак добавимЕсли(V элемент)
        {
                Рюкзак c = дубликат();
                c.добавьЕсли(элемент);
                return c;
        }


        /**
         * Implements util.collection.Рюкзак.добавим
         * See_Also: util.collection.Рюкзак.добавим
        **/

        public final Рюкзак добавим(V элемент)
        {
                Рюкзак c = дубликат();
                c.добавь(элемент);
                return c;
        }
} // version


        /***********************************************************************

                Implements util.collection.impl.Collection.Коллекция.удалиВсе
                See_Also: util.collection.impl.Collection.Коллекция.удалиВсе

                Has в_ be here rather than in the superclass в_ satisfy
                D interface опрioms

        ************************************************************************/

        public проц удалиВсе (Обходчик!(V) e)
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

        public проц удали (Обходчик!(V) e)
        {
                while (e.ещё)
                       удали (e.получи);
        }
}

