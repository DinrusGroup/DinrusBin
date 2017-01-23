/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.Multiset;
public import col.model.Collection,
       col.model.Addable,
       col.model.Multi;

/**
 * Мультинабор is a container that allows multiple экземпляры of the same значение
 * to be добавленный.
 *
 * It is similar to a list, except there is no requirement for ordering.  That
 * is, elements may not be stored in the order добавленный.
 *
 * Since ordering is not important, the collection can reorder elements on
 * removal or addition to optimize the operations.
 */
interface Мультинабор(З) : Коллекция!(З), Добавляемый!(З), Мульти!(З)
{
    /**
     * covariant очисти (from Коллекция)
     */
    Мультинабор!(З) очисти();

    /**
     * covariant dup (from Коллекция)
     */
    Мультинабор!(З) dup();

    /**
     * Covariant удали (from Коллекция)
     */
    Мультинабор!(З) удали(З з);

    /**
     * Covariant удали (from Коллекция)
     */
    Мультинабор!(З) удали(З з, ref бул был_Удалён);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Мультинабор!(З) добавь(З з);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Мультинабор!(З) добавь(З з, ref бул был_добавлен);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Мультинабор!(З) добавь(Обходчик!(З) обх);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Мультинабор!(З) добавь(Обходчик!(З) обх, ref бцел чло_добавленных);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Мультинабор!(З) добавь(З[] массив);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Мультинабор!(З) добавь(З[] массив, ref бцел чло_добавленных);

    /**
     * covariant удалиВсе (from Мульти)
     */
    Мультинабор!(З) удалиВсе(З з);

    /**
     * covariant удалиВсе (from Мульти)
     */
    Мультинабор!(З) удалиВсе(З з, ref бцел чло_Удалённых);

    /**
     * gets the most convenient элемент in the multiset.  Note that no
     * particular order of elements is assumed, so this might be the последн
     * элемент добавленный, might be the первый, might be one in the middle.  This
     * элемент would be the первый iterated if the multiset is используется as an
     * iterator.  Therefore, the removal of this элемент via удали(дай())
     * would be less than the normal O(n) runtime.
     */
    З дай();

    /**
     * Remove the most convenient элемент in the multiset and return its
     * значение.  This is equivalent to удали(дай()), but only does one lookup.
     *
     * Undefined if called on an empty multiset.
     */
    З изыми();
}
