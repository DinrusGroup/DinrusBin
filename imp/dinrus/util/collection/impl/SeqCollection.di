/*
 Файл: SeqCollection.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 13Oct95  dl                 Созд
 28jab97  dl                 сделай class public
*/


module util.collection.impl.SeqCollection;

private import  util.collection.model.Seq,
                util.collection.model.Iterator;

private import  util.collection.impl.Collection;



/**
 *
 * SeqCollection extends MutableImpl в_ provопрe
 * default implementations of some Seq operations. 
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public abstract class SeqCollection(T) : Коллекция!(T), Seq!(T)
{
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


        // Default implementations of Seq methods

version (VERBOSE)
{
        /**
         * Implements util.collection.model.Seq.Seq.insertingAt.
         * See_Also: util.collection.model.Seq.Seq.insertingAt
        **/
        public final Seq insertingAt(цел индекс, T элемент)
        {
                MutableSeq c = пусто;
                //      c = (cast(MutableSeq)клонируй());
                c = (cast(MutableSeq)дубликат());
                c.вставь(индекс, элемент);
                return c;
        }

        /**
         * Implements util.collection.model.Seq.Seq.removingAt.
         * See_Also: util.collection.model.Seq.Seq.removingAt
        **/
        public final Seq removingAt(цел индекс)
        {
                MutableSeq c = пусто;
                //      c = (cast(MutableSeq)клонируй());
                c = (cast(MutableSeq)дубликат());
                c.удали(индекс);
                return c;
        }


        /**
         * Implements util.collection.model.Seq.Seq.replacingAt
         * See_Also: util.collection.model.Seq.Seq.replacingAt
        **/
        public final Seq replacingAt(цел индекс, T элемент)
        {
                MutableSeq c = пусто;
                //      c = (cast(MutableSeq)клонируй());
                c = (cast(MutableSeq)дубликат());
                c.замени(индекс, элемент);
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

        /***********************************************************************

                Implements util.collection.model.Seq.opIndexAssign
                See_Also: util.collection.model.Seq.замениПо

                Calls замениПо(индекс, элемент);

        ************************************************************************/
        public final проц opIndexAssign (T элемент, цел индекс)
        {
                замениПо(индекс, элемент);
        }

        /***********************************************************************

                Implements util.collection.model.SeqView.opSlice
                See_Also: util.collection.model.SeqView.поднабор

                Calls поднабор(begin, (конец - begin));

        ************************************************************************/
        public SeqCollection opSlice(цел begin, цел конец)
        {
                return поднабор(begin, (конец - begin));
        }

}

