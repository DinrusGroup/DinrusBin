/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.Collection;

public import col.model.Iterator;

/**
 * Интерфейс собраний (коллекций) определяет основной интерфейс для всех коллекций.
 *
 * Базовая коллекция должна позволять обход всех её элементов, сообщать о том,
 * содержится ли в ней данный элемент, а также удалять элементы. Добавление элементов
 * в данном случае не поддерживается, поскольку элементы не всегда добавляются простым
 * приёмом. Например, карта (мэп) требует добавления в обходчик и ключа, и самого элемента.
 */
interface Коллекция(V) : Обходчик!(V), Чистящий!(V) 
{
    /**
     * очистить контейнер от всех значений
     */
    Коллекция!(V) очисти();

    /**
     * удали an элемент with the specific значение.  This may be an O(n)
     * operation.  If the collection is keyed, the первый элемент whose значение
     * matches will be removed.
     *
     * returns this.
     */
    Коллекция!(V) удали(V v);

    /**
     * удали an элемент with the specific значение.  This may be an O(n)
     * operation.  If the collection is keyed, the первый элемент whose значение
     * matches will be removed.
     *
     * returns this.
     *
     * sets был_Удалён to true if the элемент existed and was removed.
     */
    Коллекция!(V) удали(V v, ref бул был_Удалён);

    /**
     * returns true if the collection содержит the значение.  can be O(n).
     */
    бул содержит(V v);

    /**
     * make a copy of this collection.  This does not do a deep copy of the
     * elements if they are ссылка or pointer types.
     */
    Коллекция!(V) dup();
}
