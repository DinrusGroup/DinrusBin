/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.Set;
public import col.model.Collection,
       col.model.Addable;

/**
 * Набор - это коллекция объектов, в которой может существовать только один
 * экземпляр объекта. Если добавляется 2 экземпляра объекта, то только первый
 * попадает в набор.
 */
interface Набор(З) : Коллекция!(З), Добавляемый!(З)
{
    /**
     * Remove all values that match the given iterator.
     */
    Набор!(З) удали(Обходчик!(З) поднабор);

    /**
     * Remove all values that match the given iterator.
     */
    Набор!(З) удали(Обходчик!(З) поднабор, ref бцел чло_Удалённых);

    /**
     * Remove all значение that are not in the given iterator.
     */
    Набор!(З) накладка(Обходчик!(З) поднабор);

    /**
     * Remove all значение that are not in the given iterator.
     */
    Набор!(З) накладка(Обходчик!(З) поднабор, ref бцел чло_Удалённых);

    /**
     * Covariant dup (from Коллекция)
     */
    Набор!(З) dup();

    /**
     * Covariant удали (from Коллекция)
     */
    Набор!(З) удали(З з);

    /**
     * Covariant удали (from Коллекция)
     */
    Набор!(З) удали(З з, ref бул был_Удалён);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Набор!(З) добавь(З з);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Набор!(З) добавь(З з, ref бул был_добавлен);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Набор!(З) добавь(Обходчик!(З) обх);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Набор!(З) добавь(Обходчик!(З) обх, ref бцел чло_добавленных);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Набор!(З) добавь(З[] массив);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Набор!(З) добавь(З[] массив, ref бцел чло_добавленных);

    /**
     * Compare two sets.  Returns true if both sets have the same number of
     * elements, and all elements in one установи exist in the other установи.
     *
     * if o is not a Набор, return false.
     */
    цел opEquals(Объект o);

    /**
     * дай the most convenient элемент in the установи.  This is the элемент that
     * would be iterated первый.  Therefore, calling удали(дай()) is
     * guaranteed to be less than an O(n) operation.
     */
    З дай();

    /**
     * Remove the most convenient элемент from the установи, and return its значение.
     * This is equivalent to удали(дай()), except that only one lookup is
     * performed.
     */
    З изыми();
}
