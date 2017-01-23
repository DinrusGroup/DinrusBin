/*
 Файл: SetView.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ собериions.d  working файл

*/


module util.collection.model.SetView;

private import util.collection.model.View;

/**
 * Sets provопрe an include operations for добавим
 * an элемент only if it is not already present.
 * They also добавь a guarantee:
 * With sets,
 * you can be sure that the число of occurrences of any
 * элемент is either zero or one.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public interface SetView(T) : View!(T)
{
        public override SetView!(T) дубликат ();
        public alias дубликат dup;
version (VERBOSE)
{
        /**
         * Construct a new Коллекция that is a клонируй of сам except
         * that it имеется indicated элемент. This can be использован
         * в_ создай a series of собериions, each differing из_ the
         * другой only in that they contain добавьitional элементы.
         *
         * @param элемент the элемент в_ include in the new collection
         * Возвращает: a new collection c, with the совпадает as this, except that
         * c.имеется(элемент)
         * Throws: IllegalElementException if !canInclude(элемент)
        **/

        public Набор включая (T элемент);
        public alias включая opCat;
} // version
}

