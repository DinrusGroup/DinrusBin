/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.List;
public import col.model.Collection,
       col.model.Addable,
       col.model.Multi;

/**
 * Список - это коллекция, элементы которой находятся в порядке их добавления. Это
 * полезно, когда нужно проследить не только за значениями, но и за порядком
 * их появления.
 */
interface Список(З) : Коллекция!(З), Добавляемый!(З), Мульти!(З)
{
    /**
     * Concatenate two lists together.  The резing list type is of the type
     * of the лево hand side.
     */
    Список!(З) opCat(Список!(З) rhs);

    /**
     * Concatenate this list and an массив together.
     *
     * The резing list is the same type as this list.
     */
    Список!(З) opCat(З[] массив);

    /**
     * Concatenate an массив and this list together.
     *
     * The резing list is the same type as this list.
     */
    Список!(З) opCat_r(З[] массив);

    /**
     * поставь the given list to this list.  Returns 'this'.
     */
    Список!(З) opCatAssign(Список!(З) rhs);

    /**
     * поставь the given массив to this list.  Returns 'this'.
     */
    Список!(З) opCatAssign(З[] массив);

    /**
     * covariant очисти (from Коллекция)
     */
    Список!(З) очисти();

    /**
     * covariant dup (from Коллекция)
     */
    Список!(З) dup();

    /**
     * Covariant удали (from Коллекция)
     */
    Список!(З) удали(З з);

    /**
     * Covariant удали (from Коллекция)
     */
    Список!(З) удали(З з, ref бул был_Удалён);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Список!(З) добавь(З з);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Список!(З) добавь(З з, ref бул был_добавлен);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Список!(З) добавь(Обходчик!(З) обх);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Список!(З) добавь(Обходчик!(З) обх, ref бцел чло_добавленных);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Список!(З) добавь(З[] массив);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Список!(З) добавь(З[] массив, ref бцел чло_добавленных);

    /**
     * covariant удалиВсе (from Мульти)
     */
    Список!(З) удалиВсе(З з);

    /**
     * covariant удалиВсе (from Мульти)
     */
    Список!(З) удалиВсе(З з, ref бцел чло_Удалённых);

    /**
     * сортируй this list according to the default compare routine for З.  Returns
     * a ссылка to the list after обх is sorted.
     */
    Список!(З) сортируй();

    /**
     * сортируй this list according to the comparison routine given.  Returns a
     * ссылка to the list after обх is sorted.
     */
    Список!(З) сортируй(цел delegate(ref З v1, ref З v2) comp);

    /**
     * сортируй this list according to the comparison routine given.  Returns a
     * ссылка to the list after обх is sorted.
     */
    Список!(З) сортируй(цел function(ref З v1, ref З v2) comp);

    /**
     * compare this list to another list.  Returns true if they have the same
     * number of elements and all the elements are equal.
     *
     * If o is not a list, then 0 is returned.
     */
    цел opEquals(Объект o);

    /**
     * Returns the элемент at the фронт of the list, or the oldest элемент
     * добавленный.  If the list is empty, calling фронт is undefined.
     */
    З фронт();

    /**
     * Returns the элемент at the конец of the list, or the most recent элемент
     * добавленный.  If the list is empty, calling тыл is undefined.
     */
    З тыл();

    /**
     * Takes the элемент at the фронт of the list, and return its значение.  This
     * operation can be as high as O(n).
     */
    З возьмиФронт();

    /**
     * Takes the элемент at the конец of the list, and return its значение.  This
     * operation can be as high as O(n).
     */
    З возьмиТыл();
}
