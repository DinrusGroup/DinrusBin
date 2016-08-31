/*
 Файл: SetCollection.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 13Oct95  dl                 Созд
 22Oct95  dl                 добавь includeElements
 28jan97  dl                 сделай class public
*/


module util.collection.impl.SetCollection;

private import  util.collection.model.Set,
                util.collection.model.Iterator;

private import  util.collection.impl.Collection;

/**
 *
 * SetCollection extends MutableImpl в_ provопрe
 * default implementations of some Набор operations. 
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public abstract class SetCollection(T) : Коллекция!(T), Набор!(T)
{
        alias Набор!(T).добавь               добавь;
        alias Коллекция!(T).удали     удали;
        alias Коллекция!(T).удалиВсе  удалиВсе;


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
         * Implements util.collection.impl.SetCollection.SetCollection.includeElements
         * See_Also: util.collection.impl.SetCollection.SetCollection.includeElements
        **/

        public проц добавь (Обходчик!(T) e)
        {
                foreach (значение; e)
                         добавь (значение);
        }


        version (VERBOSE)
        {
        // Default implementations of Набор methods

        /**
         * Implements util.collection.Набор.включая
         * See_Also: util.collection.Набор.включая
        **/
        public final Набор включая (T элемент)
        {
                auto c = cast(MutableSet) дубликат();
                c.include(элемент);
                return c;
        }
        } // version

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


