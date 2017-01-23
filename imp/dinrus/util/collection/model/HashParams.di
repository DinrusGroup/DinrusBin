/*
 Файл: ПараметрыХэш.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ собериions.d  working файл

*/


module util.collection.model.HashParams;


/**
 *
 * База interface for хэш таблица based собериions.
 * Provопрes common ways of dealing with корзины и threshholds.
 * (It would be nice в_ совместно some of the код too, but this
 * would require multИПle inheritance here.)
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/


public interface ПараметрыХэш
{

        /**
         * The default начальное число of корзины of a non-пустой HT
        **/

        public static цел дефНачКорзины = 31;

        /**
         * The default загрузи factor for a non-пустой HT. When the proportion
         * of элементы per корзины exceeds this, the таблица is resized.
        **/

        public static плав дефФакторЗагрузки = 0.75f;

        /**
         * return the текущ число of хэш таблица корзины
        **/

        public цел корзины();

        /**
         * Набор the desired число of корзины in the хэш таблица.
         * Any значение greater than or equal в_ one is ОК.
         * if different than текущ корзины, causes a version change
         * Throws: ИсклНелегальногоАргумента if newCap less than 1
        **/

        public проц корзины(цел newCap);


        /**
         * Return the текущ загрузи factor порог
         * The Хэш таблица occasionally проверьa against the загрузи factor
         * resizes itself if it имеется gone past it.
        **/

        public плав пороговыйФакторЗагрузки();

        /**
         * Набор the текущ desired загрузи factor. Any значение greater than 0 is ОК.
         * The текущ загрузи is проверьed against it, possibly causing перемерь.
         * Throws: ИсклНелегальногоАргумента if desired is 0 or less
        **/

        public проц пороговыйФакторЗагрузки(плав desired);
}
