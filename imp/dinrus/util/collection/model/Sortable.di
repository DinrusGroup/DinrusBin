/*
 Файл: Sortable.d

 Originally записано by Doug Lea и released преобр_в the public домен.
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ собериions.d  working файл

*/


module util.collection.model.Sortable;

private import  util.collection.model.Dispenser,
                util.collection.model.Comparator;


/**
 *
 *
 * Sortable is a mixin interface for MutableCollections
 * supporting a сортируй метод that accepts
 * a пользователь-supplied Сравнитель with a сравни метод that
 * accepts any two Objects и returns -1/0/+1 depending on whether
 * the первый is less than, equal в_, or greater than the секунда.
 * <P>
 * After sorting, but in the absence of другой mutative operations,
 * Sortable Collections guarantee that enumerations
 * appear in sorted order;  that is if a и b are two элементы
 * obtained in succession из_ nextElement(), that
 * <PRE>
 * сравнитель(a, b) <= 0.
 * </PRE>
 *
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public interface Sortable(T) : Dispenser!(T)
{

        /**
         * Sort the текущ элементы with respect в_ cmp.сравни.
        **/

        public проц сортируй(Сравнитель!(T) cmp);
}


