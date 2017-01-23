/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

**********************************************************/
module col.model.Iterator;

enum : бцел
{
    /**
     * Возвращается из длина(), когда length не поддерживается
     */
    ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ = ~0
}

/**
 * Basic iterator.  Allows iterating over all the elements of an object.
 */
interface Обходчик(З)
{
    /**
     * If supported, returns the number of elements that will be iterated.
     *
     * If not supported, returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ.
     */
    бцел длина(); alias длина length;

    /**
     * foreach operator.
     */
    цел opApply(цел delegate(ref З з) дг);
}

/**
 * Обходчик с ключами.  This allows one to view the ключ of the элемент as well
 * as the значение while iterating.
 */
interface Ключник(К, З) : Обходчик!(З)
{
    alias Обходчик!(З).opApply opApply;

    /**
     * iterate over both ключи and values
     */
    цел opApply(цел delegate(ref К к, ref З з) дг);
}

/**
 * A очистить iterator is используется to очистить values from a collection.  This works by
 * telling the iterator that you want обх to удали the значение последн iterated.
 */
interface Чистящий(З)
{
    /**
     * iterate over the values of the iterator, telling обх which values to
     * удали.  To удали a значение, установи чистить_ли to true перед exiting the
     * loop.
     *
     * Make sure you specify ref for the чистить_ли parameter:
     *
     * -----
     * foreach(ref чистить_ли, з; &чистящий.очистить){
     * ...
     * -----
     */
    цел очистить(цел delegate(ref бул чистить_ли, ref З з) дг);
}

/**
 * A очистить iterator for keyed containers.
 */
interface ЧистящийКлючи(К, З) : Чистящий!(З)
{
    /**
     * iterate over the ключ/значение pairs of the iterator, telling обх which ones
     * to удали.
     *
     * Make sure you specify ref for the чистить_ли parameter:
     *
     * -----
     * foreach(ref чистить_ли, к, з; &чистящий.чисть_ключ){
     * ...
     * -----
     *
     * TODO: note this should have the name очистить, but because of asonine
     * lookup rules, обх makes обх difficult to specify this version over the
     * base version.  Once this is fixed, обх's highly likely that this goes
     * тыл to the name очистить.
     *
     * See bugzilla #2498
     */
    цел чисть_ключ(цел delegate(ref бул чистить_ли, ref К к, ref З з) дг);
}
