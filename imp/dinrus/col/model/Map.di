/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.Map;
public import col.model.Collection,
       col.model.Keyed,
       col.model.Multi;

/**
 * В коллекции Карта для значений используются ключи. Допускается наличие
 * только одного экземпляра ключа в одно и то же время.
 */
interface Карта(K, V) : СКлючом!(K, V), Коллекция!(V), Мульти!(V)
{
    /**
     * установить в карту из данного итератора ключей все элементы.  Любой ключ,
     * ранее существовавший, будет перезаписан.
     *
     * Возвращает.
     */
    Карта!(K, V) установи(Ключник!(K, V) исток);

    /**
     * установить в карту из данного итератора ключей все элементы.  Любой ключ,
     * ранее существовавший, будет перезаписан.
     *
     * Возвращает.
     *
     * чло_добавленных is установи to the number of elements that were добавленный.
     */
    Карта!(K, V) установи(Ключник!(K, V) исток, ref бцел чло_добавленных);

    /**
     * установить в карту из данного итератора ключей все элементы.  Любой ключ,
     * ранее существовавший, будет перезаписан.
     *
     * Возвращает.
     */
    Карта!(K, V) установи(V[K] исток);

    /**
     * установить в карту из данного итератора ключей все элементы.  Любой ключ,
     * ранее существовавший, будет перезаписан.
     *
     * Возвращает.
     *
     * чло_добавленных is установи to the number of elements добавленный.
     */
    Карта!(K, V) установи(V[K] исток, ref бцел чло_добавленных);

    /**
     * Remove all the given ключи из the map.
     *
     * return this.
     */
    Карта!(K, V) удали(Обходчик!(K) поднабор);

    /**
     * Remove all the given ключи из the map.
     *
     * return this.
     *
     * чло_Удалённых is установи to the number of elements removed.
     */
    Карта!(K, V) удали(Обходчик!(K) поднабор, ref бцел чло_Удалённых);

    /**
     * Remove all the given ключи из the map.
     *
     * return this.
     */
    Карта!(K, V) удали(K[] поднабор);

    /**
     * Remove all the given ключи из the map.
     *
     * return this.
     *
     * чло_Удалённых is установи to the number of elements removed.
     */
    Карта!(K, V) удали(K[] поднабор, ref бцел чло_Удалённых);

    /**
     * Remove all the ключи that are not in the given iterator.
     *
     * returns this.
     */
    Карта!(K, V) накладка(Обходчик!(K) поднабор);

    /**
     * Remove all the ключи that are not in the given iterator.
     *
     * sets чло_Удалённых to the number of elements removed.
     *
     * returns this.
     */
    Карта!(K, V) накладка(Обходчик!(K) поднабор, ref бцел чло_Удалённых);

    /**
     * Remove all the ключи that are not in the given массив.
     *
     * returns this.
     */
    Карта!(K, V) накладка(K[] поднабор);

    /**
     * Remove all the ключи that are not in the given массив.
     *
     * sets чло_Удалённых to the number of elements removed.
     *
     * returns this.
     */
    Карта!(K, V) накладка(K[] поднабор, ref бцел чло_Удалённых);

    /**
     * Get a установи of the ключи that the map содержит.  This is not a copy of the
     * ключи, but an actual "window" into the ключи of the map.  If you добавь
     * values to the map, they will show up in the ключи iterator.
     *
     * This is not in СКлючом, because some СКлючом containers do not have user
     * defined ключи, and so this would be not quite that useful there.
     */
    Обходчик!(K) ключи();

    /**
     * ковариант с очисти (из Коллекция)
     */
    Карта!(K, V) очисти();

    /**
     * ковариант с dup (из Коллекция)
     */
    Карта!(K, V) dup();

    /**
     * ковариант с удали (из Коллекция)
     */
    Карта!(K, V) удали(V v);

    /**
     * ковариант с удали (из Коллекция)
     */
    Карта!(K, V) удали(V v, ref бул был_Удалён);

    /**
     * ковариант с удалиВсе (из Мульти)
     */
    Карта!(K, V) удалиВсе(V v);

    /**
     * ковариант с удалиВсе (из Мульти)
     */
    Карта!(K, V) удалиВсе(V v, ref бцел чло_Удалённых);

    /**
     * ковариант с удалиПо (из СКлючом)
     */
    Карта!(K, V) удалиПо(K ключ);

    /**
     * ковариант с удалиПо (из СКлючом)
     */
    Карта!(K, V) удалиПо(K ключ, ref бул был_Удалён);

    /**
     * ковариант с установи (из СКлючом)
     */
    Карта!(K, V) установи(K ключ, V значение);

    /**
     * ковариант с установи (из СКлючом)
     */
    Карта!(K, V) установи(K ключ, V значение, ref бул был_добавлен);

    /**
     * compare two maps.  Returns true if both maps have the same number of
     * elements, and both maps have elements whose ключи and values are equal.
     *
     * If o is not a map, then 0 is returned.
     */
    цел opEquals(Объект o);
}
