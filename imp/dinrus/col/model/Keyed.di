/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.Keyed;

public import col.model.Iterator;

/**
 * Interface defining an object that accesses values by ключ.
 */
interface СКлючом(K, V) : Ключник!(K, V), ЧистящийКлючи!(K, V)
{
    /**
     * удали the значение at the given ключ location
     *
     * Returns this.
     */
    СКлючом!(K, V) удалиПо(K ключ);

    /**
     * удали the значение at the given ключ location
     *
     * Returns this.
     *
     * был_Удалён is установи to true if the элемент existed and was removed.
     */
    СКлючом!(K, V) удалиПо(K ключ, ref бул был_Удалён);

    /**
     * access a значение based on the ключ
     */
    V opIndex(K ключ);

    /**
     * assign a значение based on the ключ
     *
     * Use this to вставь a ключ/значение pair into the collection.
     *
     * Note that some containers do not use user-specified ключи.  For those
     * containers, the ключ must already have existed перед setting.
     */
    V opIndexAssign(V значение, K ключ);

    /**
     * установи the ключ/значение pair.  This is similar to opIndexAssign, but returns
     * this, so the function can be chained.
     */
    СКлючом!(K, V) установи(K ключ, V значение);

    /**
     * Same as установи, but has a был_добавлен boolean to tell the caller whether the
     * значение was добавленный or not.
     */
    СКлючом!(K, V) установи(K ключ, V значение, ref бул был_добавлен);

    /**
     * returns true if the collection содержит the ключ
     */
    бул имеетКлюч(K ключ);
}
