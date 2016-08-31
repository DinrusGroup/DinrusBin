/*
 Файл: Обходчик.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ собериions.d  working файл

*/


module util.collection.model.Iterator;


/**
 *
 **/

public interface Обходчик(V)
{
        public бул ещё();

        public V получи();

        цел opApply (цел delegate (inout V значение) дг);        
}
