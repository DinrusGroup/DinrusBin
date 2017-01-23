/*
 Файл: SortedValues.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ собериions.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.model.SortedValues;

private import  util.collection.model.View,
                util.collection.model.Сравнитель;


/**
 *
 *
 * ElementSorted is a mixin interface for Collections that
 * are always in sorted order with respect в_ a Сравнитель
 * held by the Коллекция.
 * <P>
 * ElementSorted Collections guarantee that enumerations
 * appear in sorted order;  that is if a и b are two Elements
 * obtained in succession из_ элементы().nextElement(), that 
 * <PRE>
 * сравнитель(a, b) <= 0.
 * </PRE>
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public interface SortedValues(T) : View!(T)
{

        /**
         * Report the Сравнитель использован for ordering
        **/

        public Сравнитель!(T) сравнитель();
}

