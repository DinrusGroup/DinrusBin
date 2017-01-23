/*
 Файл: Dispenser.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ собериions.d  working файл

*/


module util.collection.model.Dispenser;

private import  util.collection.model.View,
                util.collection.model.Iterator;

/**
 *
 * Dispenser is the корень interface of все изменяемый собериions; i.e.,
 * собериions that may have элементы dynamically добавьed, removed,
 * и/or replaced in accord with their collection semantics.
 *
 * author: Doug Lea
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public interface Dispenser(T) : View!(T)
{
        public override Dispenser!(T) дубликат ();
        public alias дубликат dup;
        /**
         * Cause the collection в_ become пустой. 
         * Возвращает: condition:
         * <PRE>
         * пуст_ли() &&
         * Версия change iff !PREV(this).пуст_ли();
         * </PRE>
        **/

        public проц очисть ();

        /**
         * Замени an occurrence of старЭлемент with новЭлемент.
         * No effect if does not hold старЭлемент or if старЭлемент.равно(новЭлемент).
         * The operation имеется a consistent, but slightly special interpretation
         * when applied в_ Sets. For Sets, because элементы occur at
         * most once, if новЭлемент is already included, replacing старЭлемент with
         * with новЭлемент имеется the same effect as just removing старЭлемент.
         * Возвращает: condition:
         * <PRE>
         * let цел delta = старЭлемент.равно(новЭлемент)? 0 : 
         *               max(1, PREV(this).экземпляры(старЭлемент) in
         *  экземпляры(старЭлемент) == PREV(this).экземпляры(старЭлемент) - delta &&
         *  экземпляры(новЭлемент) ==  (this instanceof Набор) ? 
         *         max(1, PREV(this).экземпляры(старЭлемент) + delta):
         *                PREV(this).экземпляры(старЭлемент) + delta) &&
         *  no другой элемент changes &&
         *  Версия change iff delta != 0
         * </PRE>
         * Throws: IllegalElementException if имеется(старЭлемент) и !allows(новЭлемент)
        **/

        public проц замени (T старЭлемент, T новЭлемент);

        /**
         * Замени все occurrences of старЭлемент with новЭлемент.
         * No effect if does not hold старЭлемент or if старЭлемент.равно(новЭлемент).
         * The operation имеется a consistent, but slightly special interpretation
         * when applied в_ Sets. For Sets, because элементы occur at
         * most once, if новЭлемент is already included, replacing старЭлемент with
         * with новЭлемент имеется the same effect as just removing старЭлемент.
         * Возвращает: condition:
         * <PRE>
         * let цел delta = старЭлемент.равно(новЭлемент)? 0 : 
                           PREV(this).экземпляры(старЭлемент) in
         *  экземпляры(старЭлемент) == PREV(this).экземпляры(старЭлемент) - delta &&
         *  экземпляры(новЭлемент) ==  (this instanceof Набор) ? 
         *         max(1, PREV(this).экземпляры(старЭлемент) + delta):
         *                PREV(this).экземпляры(старЭлемент) + delta) &&
         *  no другой элемент changes &&
         *  Версия change iff delta != 0
         * </PRE>
         * Throws: IllegalElementException if имеется(старЭлемент) и !allows(новЭлемент)
        **/

        public проц замениВсе(T старЭлемент, T новЭлемент);

        /**
         * Удали и return an элемент.  Implementations
         * may strengthen the guarantee about the nature of this элемент.
         * but in general it is the most convenient or efficient элемент в_ удали.
         * <P>
         * Example usage. One way в_ перемести все элементы из_ 
         * Dispenser a в_ MutableBag b is:
         * <PRE>
         * while (!a.пустой()) b.добавь(a.возьми());
         * </PRE>
         * Возвращает: an элемент v such that PREV(this).имеется(v) 
         * и the postconditions of removeOneOf(v) hold.
         * Throws: НетЭлементаИскл iff пуст_ли.
        **/

        public T возьми ();


        /**
         * Exclude все occurrences of each элемент of the Обходчик.
         * Behaviorally equivalent в_
         * <PRE>
         * while (e.ещё()) удалиВсе(e.значение());
         * @param e the enumeration of элементы в_ exclude.
         * Throws: CorruptedIteratorException is propagated if thrown
        **/

        public проц удалиВсе (Обходчик!(T) e);

        /**
         * Удали an occurrence of each элемент of the Обходчик.
         * Behaviorally equivalent в_
         * <PRE>
         * while (e.ещё()) удали (e.значение());
         * @param e the enumeration of элементы в_ удали.
         * Throws: CorruptedIteratorException is propagated if thrown
        **/

        public проц удали (Обходчик!(T) e);

        /**
         * Exclude все occurrences of the indicated элемент из_ the collection. 
         * No effect if элемент not present.
         * @param элемент the элемент в_ exclude.
         * Возвращает: condition: 
         * <PRE>
         * !имеется(элемент) &&
         * размер() == PREV(this).размер() - PREV(this).экземпляры(элемент) &&
         * no другой элемент changes &&
         * Версия change iff PREV(this).имеется(элемент)
         * </PRE>
        **/

        public проц удалиВсе (T элемент);


        /**
         * Удали an экземпляр of the indicated элемент из_ the collection. 
         * No effect if !имеется(элемент)
         * @param элемент the элемент в_ удали
         * Возвращает: condition: 
         * <PRE>
         * let occ = max(1, экземпляры(элемент)) in
         *  размер() == PREV(this).размер() - occ &&
         *  экземпляры(элемент) == PREV(this).экземпляры(элемент) - occ &&
         *  no другой элемент changes &&
         *  version change iff occ == 1
         * </PRE>
        **/

        public проц удали (T элемент);
}


