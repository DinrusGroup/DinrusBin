/*
Файл: Cell.d

Originally записано by Doug Lea и released преобр_в the public домен. 
Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
Inc, Loral, и everyone contributing, testing, и using this код.

History:
Дата     Who                What
24Sep95  dl@cs.oswego.edu   Созд из_ util.collection.d  working файл
9Apr97   dl                 made Serializable

*/


module util.collection.impl.Cell;

/**
 *
 *
 * Cell is the основа of a bunch of implementation classes
 * for списки и the like.
 * The основа version just holds an Объект as its элемент значение
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class Cell (T)
{
        // экземпляр variables
        private T element_;

        /**
         * Make a ячейка with элемент значение v
        **/

        public this (T v)
        {
                element_ = v;
        }

        /**
         * Make A ячейка with пусто элемент значение
        **/

        public this ()
        {
//                element_ = пусто;
        }

        /**
         * return the элемент значение
        **/

        public final T элемент()
        {
                return element_;
        }

        /**
         * установи the элемент значение
        **/

        public final проц элемент (T v)
        {
                element_ = v;
        }

        public final цел elementХэш ()
        {
                return typeid(T).дайХэш(&element_);
        }

        protected Cell дубликат()
        {
                return new Cell (element_);
        }
}
