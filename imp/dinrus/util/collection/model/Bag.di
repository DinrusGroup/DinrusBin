/*
 Файл: Рюкзак.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ собериions.d  working файл

*/


module util.collection.model.Bag;

private import  util.collection.model.BagView,
                util.collection.model.Iterator,
                util.collection.model.Dispenser;

/**
 * Bags are собериions supporting multИПle occurrences of элементы.
 * author: Doug Lea
**/

public interface Рюкзак(V) : BagView!(V), Dispenser!(V)
{
        public override Рюкзак!(V) дубликат();
        public alias дубликат dup;

        public alias добавь opCatAssign;

        проц добавь (V);

        проц добавьЕсли (V);

        проц добавь (Обходчик!(V));
}


