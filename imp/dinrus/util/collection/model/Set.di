/*
 Файл: Набор.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ собериions.d  working файл
 22Oct95  dl                 добавь добавьElements

*/


module util.collection.model.Set;

private import  util.collection.model.SetView,
                util.collection.model.Iterator,
                util.collection.model.Dispenser;


/**
 *
 * MutableSets support an include operations в_ добавь
 * an элемент only if it not present. 
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

public interface Набор(T) : SetView!(T), Dispenser!(T)
{
        public override Набор!(T) дубликат();
        public alias дубликат dup;

        /**
         * Include the indicated элемент in the collection.
         * No effect if the элемент is already present.
         * @param элемент the элемент в_ добавь
         * Возвращает: condition: 
         * <PRE>
         * имеется(элемент) &&
         * no spurious effects &&
         * Версия change iff !PREV(this).имеется(элемент)
         * </PRE>
         * Throws: IllegalElementException if !canInclude(элемент)
        **/

        public проц добавь (T элемент);


        /**
         * Include все элементы of the enumeration in the collection.
         * Behaviorally equivalent в_
         * <PRE>
         * while (e.ещё()) include(e.получи());
         * </PRE>
         * @param e the элементы в_ include
         * Throws: IllegalElementException if !canInclude(элемент)
         * Throws: CorruptedIteratorException propagated if thrown
        **/

        public проц добавь (Обходчик!(T) e);
        public alias добавь opCatAssign;
}

