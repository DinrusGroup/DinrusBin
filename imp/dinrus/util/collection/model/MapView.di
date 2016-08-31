/*
 Файл: MapView.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ собериions.d  working файл

*/


module util.collection.model.MapView;

private import  util.collection.model.View,
                util.collection.model.GuardIterator;


/**
 *
 * Maps maintain keyed элементы. Any kind of Объект 
 * may serve as a ключ for an элемент.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/


public interface MapView(K, V) : View!(V)
{
        public override MapView!(K,V) дубликат();
        public alias дубликат dup;
        /**
         * Report whether the MapT COULD include k as a ключ
         * Always returns нет if k is пусто
        **/

        public бул allowsKey(K ключ);

        /**
         * Report whether there есть_ли any элемент with Key ключ.
         * Возвращает: да if there is such an элемент
        **/

        public бул содержитКлюч(K ключ);

        /**
         * Report whether there есть_ли a (ключ, значение) пара
         * Возвращает: да if there is such an элемент
        **/

        public бул содержитПару(K ключ, V значение);


        /**
         * Return an enumeration that may be использован в_ traverse through
         * the ключи (not элементы) of the collection. The corresponding
         * элементы can be looked at by using at(k) for each ключ k. For example:
         * <PRE>
         * Обходчик ключи = amap.ключи();
         * while (ключи.ещё()) {
         *   K ключ = ключи.получи();
         *   T значение = amap.получи(ключ)
         * // ...
         * }
         * </PRE>
         * Возвращает: the enumeration
        **/

        public ОбходчикПар!(K, V) ключи();

        /**
         traverse the collection контент. This is cheaper than using an
         обходчик since there is no creation cost involved.
        **/

        цел opApply (цел delegate (inout K ключ, inout V значение) дг);
        
        /**
         * Return the элемент associated with Key ключ. 
         * @param ключ a ключ
         * Возвращает: элемент such that содержит(ключ, элемент)
         * Throws: НетЭлементаИскл if !содержитКлюч(ключ)
        **/

        public V получи(K ключ);
        public alias получи opIndex;

        /**
         * Return the элемент associated with Key ключ. 
         * @param ключ a ключ
         * Возвращает: whether the ключ is contained or not
        **/

        public бул получи(K ключ, inout V элемент); 


        /**
         * Return a ключ associated with элемент. There may be any
         * число of ключи associated with any элемент, but this returns only
         * one of them (any arbitrary one), or нет if no such ключ есть_ли.
         * @param ключ, a place в_ return a located ключ
         * @param элемент, a значение в_ try в_ найди a ключ for.
         * Возвращает: да where значение is найдено; нет otherwise
        **/

        public бул ключК(inout K ключ, V значение);
}

