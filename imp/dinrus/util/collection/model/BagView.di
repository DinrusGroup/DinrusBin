/*
 Файл: BagView.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ собериions.d  working файл

*/


module util.collection.model.BagView;

private import util.collection.model.View;


/**
 *
 * Bags are собериions supporting multИПle occurrences of элементы.
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public interface BagView(V) : View!(V)
{
        public override BagView!(V) дубликат();
        public alias дубликат dup;

version (VERBOSE)
{
        public alias добавим opCat;

        /**
         * Construct a new Рюкзак that is a клонируй of сам except
         * that it включает indicated элемент. This can be использован
         * в_ создай a series of Рюкзак, each differing из_ the
         * другой only in that they contain добавьitional элементы.
         *
         * @param the элемент в_ добавь в_ the new Рюкзак
         * Возвращает: the new Рюкзак c, with the совпадает as this except that
         * c.occurrencesOf(элемент) == occurrencesOf(элемент)+1 
         * Throws: IllegalElementException if !canInclude(элемент)
        **/

        public Рюкзак добавим(V элемент);

        /**
         * Construct a new Коллекция that is a клонируй of сам except
         * that it добавьs the indicated элемент if not already present. This can be использован
         * в_ создай a series of собериions, each differing из_ the
         * другой only in that they contain добавьitional элементы.
         *
         * @param элемент the элемент в_ include in the new collection
         * Возвращает: a new collection c, with the совпадает as this, except that
         * c.occurrencesOf(элемент) = min(1, occurrencesOfElement)
         * Throws: IllegalElementException if !canInclude(элемент)
        **/

        public Рюкзак добавимЕслиНет(V элемент);
} // version

}
