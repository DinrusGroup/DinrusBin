/*
 Файл: Карта.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ собериions.d  working файл

*/


module util.collection.model.Map;

private import  util.collection.model.MapView,
                util.collection.model.Dispenser;


/**
 *
 *
 * MutableMap supports стандарт обнови operations on maps.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/


public interface Карта(K, T) : MapView!(K, T), Dispenser!(T)
{
        public override Карта!(K,T) дубликат();
        public alias дубликат dup;
        /**
         * Include the indicated пара in the Карта
         * If a different пара
         * with the same ключ was previously held, it is replaced by the
         * new пара.
         *
         * @param ключ the ключ for элемент в_ include
         * @param элемент the элемент в_ include
         * Возвращает: condition: 
         * <PRE>
         * имеется(ключ, элемент) &&
         * no spurious effects &&
         * Версия change iff !PREV(this).содержит(ключ, элемент))
         * </PRE>
        **/

        public проц добавь (K ключ, T элемент);

        /**
         * Include the indicated пара in the Карта
         * If a different пара
         * with the same ключ was previously held, it is replaced by the
         * new пара.
         *
         * @param элемент the элемент в_ include
         * @param ключ the ключ for элемент в_ include
         * Возвращает: condition: 
         * <PRE>
         * имеется(ключ, элемент) &&
         * no spurious effects &&
         * Версия change iff !PREV(this).содержит(ключ, элемент))
         * </PRE>
        **/

        public проц opIndexAssign (T элемент, K ключ);


        /**
         * Удали the пара with the given ключ
         * @param  ключ the ключ
         * Возвращает: condition: 
         * <PRE>
         * !содержитКлюч(ключ)
         * foreach (k in ключи()) at(k).равно(PREV(this).at(k)) &&
         * foreach (k in PREV(this).ключи()) (!k.равно(ключ)) --> at(k).равно(PREV(this).at(k)) 
         * (version() != PREV(this).version()) == 
         * содержитКлюч(ключ) !=  PREV(this).содержитКлюч(ключ))
         * </PRE>
        **/

        public проц удалиКлюч (K ключ);


        /**
         * Замени old пара with new пара with same ключ.
         * No effect if пара not held. (This имеется the case of
         * having no effect if the ключ есть_ли but is bound в_ a different значение.)
         * @param ключ the ключ for the пара в_ удали
         * @param старЭлемент the existing элемент
         * @param новЭлемент the значение в_ замени it with
         * Возвращает: condition: 
         * <PRE>
         * !содержит(ключ, старЭлемент) || содержит(ключ, новЭлемент);
         * no spurious effects &&
         * Версия change iff PREV(this).содержит(ключ, старЭлемент))
         * </PRE>
        **/

        public проц замениПару (K ключ, T старЭлемент, T новЭлемент);
}

