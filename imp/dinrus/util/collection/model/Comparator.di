/*
 Файл: Сравнитель.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ собериions.d  working файл

*/


module util.collection.model.Сравнитель;


/**
 *
 * Сравнитель is an interface for any class possessing an элемент
 * сравнение метод.
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

template Сравнитель(T)
{
        alias цел delegate(T, T) Сравнитель;
}

/+
public interface Сравнитель(T)
{
        /**
         * @param fst первый аргумент
         * @param snd секунда аргумент
         * Возвращает: a негатив число if fst is less than snd; a
         * positive число if fst is greater than snd; else 0
        **/
        public цел сравни(T fst, T snd);
}
+/
