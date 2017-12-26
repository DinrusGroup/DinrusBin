/*
 Файл: SortedKeys.d

 Originally записано by Doug Lea и released преобр_в the public домен.
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ собериions.d  working файл

*/


module util.collection.model.SortedKeys;

private import  util.collection.model.View,
                util.collection.model.Comparator;


/**
 *
 *
 * KeySorted is a mixin interface for Collections that
 * are always in sorted order with respect в_ a Сравнитель
 * held by the Коллекция.
 * <P>
 * KeySorted Collections guarantee that enumerations
 * appear in sorted order;  that is if a и b are two Keys
 * obtained in succession из_ ключи().nextElement(), that
 * <PRE>
 * сравнитель(a, b) <= 0.
 * </PRE>
 *
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public interface SortedKeys(K, V) : View!(V)
{

        /**
         * Report the Сравнитель использован for ordering
        **/

        public Сравнитель!(K) сравнитель();
}
