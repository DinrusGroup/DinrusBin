/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

   This is a collection of useful iterators, and iterator
   functions.
**********************************************************/
module col.Iterators;

public import col.model.Iterator;

/**
 * This iterator transforms every элемент from another iterator using a
 * transformation function.
 */
class ТрансформОбходчик(V, U=V) : Обходчик!(V)
{
    private Обходчик!(U) _ист;
    private проц delegate(ref U, ref V) _дг;
    private проц function(ref U, ref V) _фн;

    /**
     * Construct a transform iterator using a transform delegate.
     *
     * The transform function transforms a type U object into a type V object.
     */
    this(Обходчик!(U) исток, проц delegate(ref U, ref V) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Construct a transform iterator using a transform function pointer.
     *
     * The transform function transforms a type U object into a type V object.
     */
    this(Обходчик!(U) исток, проц function(ref U, ref V) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Returns the длина that the исток provides.
     */
    бцел длина()
    {
        return _ист.length;
    }
	alias длина length;
    /**
     * Iterate through the исток iterator, working with temporary copies of a
     * transformed V элемент.
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел privateDG(ref U u)
        {
            V v;
            _дг(u, v);
            return дг(v);
        }

        цел privateFN(ref U u)
        {
            V v;
            _фн(u, v);
            return дг(v);
        }

        if(_дг is null)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }
}

/**
 * Transform for a keyed iterator
 */
class ТрансформКлючник(K, V, J=K, U=V) : Ключник!(K, V)
{
    private Ключник!(J, U) _ист;
    private проц delegate(ref J, ref U, ref K, ref V) _дг;
    private проц function(ref J, ref U, ref K, ref V) _фн;

    /**
     * Construct a transform iterator using a transform delegate.
     *
     * The transform function transforms a J, U pair into a K, V pair.
     */
    this(Ключник!(J, U) исток, проц delegate(ref J, ref U, ref K, ref V) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Construct a transform iterator using a transform function pointer.
     *
     * The transform function transforms a J, U pair into a K, V pair.
     */
    this(Ключник!(J, U) исток, проц function(ref J, ref U, ref K, ref V) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Returns the длина that the исток provides.
     */
    бцел длина()
    {
        return _ист.length;
    }
	alias длина length;

    /**
     * Iterate through the исток iterator, working with temporary copies of a
     * transformed V элемент.  Note that K can be пропущен if this is the only
     * use for the iterator.
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел privateDG(ref J j, ref U u)
        {
            K k;
            V v;
            _дг(j, u, k, v);
            return дг(v);
        }

        цел privateFN(ref J j, ref U u)
        {
            K k;
            V v;
            _фн(j, u, k, v);
            return дг(v);
        }

        if(_дг is null)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }

    /**
     * Iterate through the исток iterator, working with temporary copies of a
     * transformed K,V pair.
     */
    цел opApply(цел delegate(ref K k, ref V v) дг)
    {
        цел privateDG(ref J j, ref U u)
        {
            K k;
            V v;
            _дг(j, u, k, v);
            return дг(k, v);
        }

        цел privateFN(ref J j, ref U u)
        {
            K k;
            V v;
            _фн(j, u, k, v);
            return дг(k, v);
        }

        if(_дг is null)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }
}

/**
 * A Chain iterator chains several iterators together.
 */
class ОбходчикЦепи(V) : Обходчик!(V)
{
    private Обходчик!(V)[] _цепь;
    private бул _поддержкаДлины;

    /**
     * Constructor.  Pass in the iterators you wish to цепь together in the
     * order you wish them to be chained.
     *
     * If all of the iterators support длина, then this iterator supports
     * длина.  If one doesn't, then the длина is not supported.
     */
    this(Обходчик!(V)[] цепь ...)
    {
        _цепь = цепь.dup;
        _поддержкаДлины = true;
        foreach(обх; _цепь)
            if(обх.length == ~0)
            {
                _поддержкаДлины = false;
                break;
            }
    }

    /**
     * Returns the sum of all the iterator lengths in the цепь.
     *
     * returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ if a single iterator in the цепь does not support
     * длина
     */
    бцел длина()
    {
        if(_поддержкаДлины)
        {
            бцел рез = 0;
            foreach(обх; _цепь)
                рез += обх.length;
            return рез;
        }
        return ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ;
    }
	alias длина length;
    /**
     * Iterate through the цепь of iterators.
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел рез = 0;
        foreach(обх; _цепь)
        {
            if((рез = обх.opApply(дг)) != 0)
                break;
        }
        return рез;
    }
}

/**
 * A Chain iterator chains several iterators together.
 */
class КлючникЦепи(K, V) : Ключник!(K, V)
{
    private Ключник!(K, V)[] _цепь;
    private бул _поддержкаДлины;

    /**
     * Constructor.  Pass in the iterators you wish to цепь together in the
     * order you wish them to be chained.
     *
     * If all of the iterators support длина, then this iterator supports
     * длина.  If one doesn't, then the длина is not supported.
     */
    this(Ключник!(K, V)[] цепь ...)
    {
        _цепь = цепь.dup;
        _поддержкаДлины = true;
        foreach(обх; _цепь)
            if(обх.length == ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ)
            {
                _поддержкаДлины = false;
                break;
            }
    }

    /**
     * Returns the sum of all the iterator lengths in the цепь.
     *
     * returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ if any iterators in the цепь return -1 for длина
     */
    бцел длина()
    {
        if(_поддержкаДлины)
        {
            бцел рез = 0;
            foreach(обх; _цепь)
                рез += обх.length;
            return рез;
        }
        return ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ;
    }
	alias длина length;
    /**
     * Iterate through the цепь of iterators using values only.
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел рез = 0;
        foreach(обх; _цепь)
        {
            if((рез = обх.opApply(дг)) != 0)
                break;
        }
        return рез;
    }

    /**
     * Iterate through the цепь of iterators using ключи and values.
     */
    цел opApply(цел delegate(ref K, ref V) дг)
    {
        цел рез = 0;
        foreach(обх; _цепь)
        {
            if((рез = обх.opApply(дг)) != 0)
                break;
        }
        return рез;
    }
}

/**
 * A Filter iterator filters out unwanted elements based on a function or
 * delegate.
 */
class ФильтрОбходчик(V) : Обходчик!(V)
{
    private Обходчик!(V) _ист;
    private бул delegate(ref V) _дг;
    private бул function(ref V) _фн;

    /**
     * Construct a filter iterator with the given delegate deciding whether an
     * элемент will be iterated or not.
     *
     * The delegate should return true for elements that should be iterated.
     */
    this(Обходчик!(V) исток, бул delegate(ref V) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Construct a filter iterator with the given function deciding whether an
     * элемент will be iterated or not.
     *
     * the function should return true for elements that should be iterated.
     */
    this(Обходчик!(V) исток, бул function(ref V) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ
     */
    бцел длина()
    {
        //
        // cannot know what the filter delegate/function will decide.
        //
        return ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ;
    }
	alias длина length;
    /**
     * Iterate through the исток iterator, only accepting elements where the
     * delegate/function returns true.
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел privateDG(ref V v)
        {
            if(_дг(v))
                return дг(v);
            return 0;
        }

        цел privateFN(ref V v)
        {
            if(_фн(v))
                return дг(v);
            return 0;
        }

        if(_дг is null)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }
}

/**
 * A Filter iterator filters out unwanted elements based on a function or
 * delegate.  This version filters on a keyed iterator.
 */
class ФильтрКлючник(K, V) : Ключник!(K, V)
{
    private Ключник!(K, V) _ист;
    private бул delegate(ref K, ref V) _дг;
    private бул function(ref K, ref V) _фн;

    /**
     * Construct a filter iterator with the given delegate deciding whether a
     * ключ/значение pair will be iterated or not.
     *
     * The delegate should return true for elements that should be iterated.
     */
    this(Ключник!(K, V) исток, бул delegate(ref K, ref V) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Construct a filter iterator with the given function deciding whether a
     * ключ/значение pair will be iterated or not.
     *
     * the function should return true for elements that should be iterated.
     */
    this(Ключник!(K, V) исток, бул function(ref K, ref V) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Returns ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ
     */
    бцел длина()
    {
        //
        // cannot know what the filter delegate/function will decide.
        //
        return ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ;
    }
	alias длина length;
    /**
     * Iterate through the исток iterator, only iterating elements where the
     * delegate/function returns true.
     */
    цел opApply(цел delegate(ref V v) дг)
    {
        цел privateDG(ref K k, ref V v)
        {
            if(_дг(k, v))
                return дг(v);
            return 0;
        }

        цел privateFN(ref K k, ref V v)
        {
            if(_фн(k, v))
                return дг(v);
            return 0;
        }

        if(_дг is null)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }

    /**
     * Iterate through the исток iterator, only iterating elements where the
     * delegate/function returns true.
     */
    цел opApply(цел delegate(ref K k, ref V v) дг)
    {
        цел privateDG(ref K k, ref V v)
        {
            if(_дг(k, v))
                return дг(k, v);
            return 0;
        }

        цел privateFN(ref K k, ref V v)
        {
            if(_фн(k, v))
                return дг(k, v);
            return 0;
        }

        if(_дг is null)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }
}

/**
 * Simple iterator wrapper for an массив.
 */
class ОбходчикМассива(V) : Обходчик!(V)
{
    private V[] _массив;

    /**
     * Wrap a given массив.  Note that this does not make a copy.
     */
    this(V[] массив)
    {
        _массив = массив;
    }
	
    /**
     * Returns the массив длина
     */
    бцел длина()
    {
        return _массив.length;
    }
	alias длина length;
	
    /**
     * Iterate over the массив.
     */
    цел opApply(цел delegate(ref V) дг)
    {
        цел возврзнач = 0;
        foreach(ref x; _массив)
            if((возврзнач = дг(x)) != 0)
                break;
        return возврзнач;
    }
}

/**
 * Wrapper iterator for an associative массив
 */
class ОбходчикАМ(K, V) : Ключник!(K, V)
{
    private V[K] _массив;

    /**
     * Construct an iterator wrapper for the given массив
     */
    this(V[K] массив)
    {
        _массив = массив;
    }

    /**
     * Returns the длина of the wrapped AA
     */
    бцел длина()
    {
        return _массив.length;// || _массив.length;
    }

	alias длина length;
    /**
     * Iterate over the AA
     */
    цел opApply(цел delegate(ref K, ref V) дг)
    {
        цел возврзнач;
        foreach(k, ref v; _массив)
            if((возврзнач = дг(k, v)) != 0)
                break;
        return возврзнач;
    }
}

/**
 * Function that converts an iterator to an массив.
 *
 * More optimized for iterators that support a длина.
 */
V[] toArray(V)(Обходчик!(V) обх)
{
    V[] рез;
    бцел длин = обх.length;
    if(длин != ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ)
    {
        //
        // can optimize a bit
        //
        рез.length = длин;
        цел i = 0;
        foreach(v; обх)
            рез[i++] = v;
    }
    else
    {
        foreach(v; обх)
            рез ~= v;
    }
    return рез;
}

/**
 * Convert a keyed iterator to an associative массив.
 */
V[K] вАМ(K, V)(Ключник!(K, V) обх)
{
    V[K] рез;
    foreach(k, v; обх)
        рез[k] = v;
    return рез;
}
