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
interface СКлючом(К, З) : Ключник!(К, З), ЧистящийКлючи!(К, З)
{
    /**
     * удали the значение at the given ключ location
     *
     * Returns this.
     */
    СКлючом!(К, З) удалиПо(К ключ);

    /**
     * удали the значение at the given ключ location
     *
     * Returns this.
     *
     * был_Удалён is установи to true if the элемент existed and was removed.
     */
    СКлючом!(К, З) удалиПо(К ключ, ref бул был_Удалён);

    /**
     * access a значение based on the ключ
     */
    З opIndex(К ключ);

    /**
     * assign a значение based on the ключ
     *
     * Use this to вставь a ключ/значение pair into the collection.
     *
     * Note that some containers do not use user-specified ключи.  For those
     * containers, the ключ must already have existed перед setting.
     */
    З opIndexAssign(З значение, К ключ);

    /**
     * установи the ключ/значение pair.  This is similar to opIndexAssign, but returns
     * this, so the function can be chained.
     */
    СКлючом!(К, З) установи(К ключ, З значение);

    /**
     * Same as установи, but has a был_добавлен boolean to tell the caller whether the
     * значение was добавленный or not.
     */
    СКлючом!(К, З) установи(К ключ, З значение, ref бул был_добавлен);

    /**
     * returns true if the collection содержит the ключ
     */
    бул имеетКлюч(К ключ);
}
