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
interface Список(V) : Коллекция!(V), Добавляемый!(V), Мульти!(V)
{
    /**
     * Concatenate two lists together.  The резing list type is of the type
     * of the лево hand side.
     */
    Список!(V) opCat(Список!(V) rhs);

    /**
     * Concatenate this list and an массив together.
     *
     * The резing list is the same type as this list.
     */
    Список!(V) opCat(V[] массив);

    /**
     * Concatenate an массив and this list together.
     *
     * The резing list is the same type as this list.
     */
    Список!(V) opCat_r(V[] массив);

    /**
     * поставь the given list to this list.  Returns 'this'.
     */
    Список!(V) opCatAssign(Список!(V) rhs);

    /**
     * поставь the given массив to this list.  Returns 'this'.
     */
    Список!(V) opCatAssign(V[] массив);

    /**
     * covariant очисти (from Коллекция)
     */
    Список!(V) очисти();

    /**
     * covariant dup (from Коллекция)
     */
    Список!(V) dup();

    /**
     * Covariant удали (from Коллекция)
     */
    Список!(V) удали(V v);

    /**
     * Covariant удали (from Коллекция)
     */
    Список!(V) удали(V v, ref бул был_Удалён);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Список!(V) добавь(V v);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Список!(V) добавь(V v, ref бул был_добавлен);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Список!(V) добавь(Обходчик!(V) обх);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Список!(V) добавь(Обходчик!(V) обх, ref бцел чло_добавленных);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Список!(V) добавь(V[] массив);

    /**
     * Covariant добавь (from Добавляемый)
     */
    Список!(V) добавь(V[] массив, ref бцел чло_добавленных);

    /**
     * covariant удалиВсе (from Мульти)
     */
    Список!(V) удалиВсе(V v);

    /**
     * covariant удалиВсе (from Мульти)
     */
    Список!(V) удалиВсе(V v, ref бцел чло_Удалённых);

    /**
     * сортируй this list according to the default compare routine for V.  Returns
     * a ссылка to the list after обх is sorted.
     */
    Список!(V) сортируй();

    /**
     * сортируй this list according to the comparison routine given.  Returns a
     * ссылка to the list after обх is sorted.
     */
    Список!(V) сортируй(цел delegate(ref V v1, ref V v2) comp);

    /**
     * сортируй this list according to the comparison routine given.  Returns a
     * ссылка to the list after обх is sorted.
     */
    Список!(V) сортируй(цел function(ref V v1, ref V v2) comp);

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
    V фронт();

    /**
     * Returns the элемент at the конец of the list, or the most recent элемент
     * добавленный.  If the list is empty, calling тыл is undefined.
     */
    V тыл();

    /**
     * Takes the элемент at the фронт of the list, and return its значение.  This
     * operation can be as high as O(n).
     */
    V возьмиФронт();

    /**
     * Takes the элемент at the конец of the list, and return its значение.  This
     * operation can be as high as O(n).
     */
    V возьмиТыл();
}
