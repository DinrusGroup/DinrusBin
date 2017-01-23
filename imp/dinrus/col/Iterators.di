/*********************************************************
   Copyright: (C) 2008 by Steven Schveighoffer.
              All rights reserved

   License: $(LICENSE)

   This is a collection of useful iterators, and iterator
   functions.
**********************************************************/
module col.Iterators;

public import col.model.Iterator;

/+ ИНТЕРФЕЙС:

class ТрансформОбходчик(З, U=З) : Обходчик!(З)
{
    this(Обходчик!(U) исток, проц delegate(ref U, ref З) дг);
    this(Обходчик!(U) исток, проц function(ref U, ref З) фн);
    бцел длина();
	alias длина length;
    цел opApply(цел delegate(ref З з) дг);
}


class ТрансформКлючник(К, З, J=К, U=З) : Ключник!(К, З)
{
    this(Ключник!(J, U) исток, проц delegate(ref J, ref U, ref К, ref З) дг);
    this(Ключник!(J, U) исток, проц function(ref J, ref U, ref К, ref З) фн);
    бцел длина();
	alias длина length;
    цел opApply(цел delegate(ref З з) дг);
    цел opApply(цел delegate(ref К к, ref З з) дг);
}

class ОбходчикЦепи(З) : Обходчик!(З)
{

    this(Обходчик!(З)[] цепь ...);
    бцел длина();
	alias длина length;
    цел opApply(цел delegate(ref З з) дг);
}

class КлючникЦепи(К, З) : Ключник!(К, З)
{
    this(Ключник!(К, З)[] цепь ...);
    бцел длина();
	alias длина length;
    цел opApply(цел delegate(ref З з) дг);
    цел opApply(цел delegate(ref К, ref З) дг);
}

class ФильтрОбходчик(З) : Обходчик!(З)
{
    this(Обходчик!(З) исток, бул delegate(ref З) дг);
    this(Обходчик!(З) исток, бул function(ref З) фн);
    бцел длина();
	alias длина length;
    цел opApply(цел delegate(ref З з) дг);
}

class ФильтрКлючник(К, З) : Ключник!(К, З)
{
    this(Ключник!(К, З) исток, бул delegate(ref К, ref З) дг);
    this(Ключник!(К, З) исток, бул function(ref К, ref З) фн);
    бцел длина();
	alias длина length;
    цел opApply(цел delegate(ref З з) дг);
    цел opApply(цел delegate(ref К к, ref З з) дг);
}

class ОбходчикМассива(З) : Обходчик!(З)
{
    this(З[] массив);
    бцел длина();
	alias длина length;
    цел opApply(цел delegate(ref З) дг);
}

class ОбходчикАМ(К, З) : Ключник!(К, З)
{
    this(З[К] массив);
    бцел длина();
	alias длина length;
    цел opApply(цел delegate(ref К, ref З) дг);
}

З[] вМассив(З)(Обходчик!(З) обх);
З[К] вАМ(К, З)(Ключник!(К, З) обх);

+/

/**
 * Этот обходчик преобразует каждый элемент из другого обходчика
 * с помощью функции преобразования.
 */
class ТрансформОбходчик(З, U=З) : Обходчик!(З)
{
    private Обходчик!(U) _ист;
    private проц delegate(ref U, ref З) _дг;
    private проц function(ref U, ref З) _фн;

    /**
     * Конструирует трансформ-обходчик, используя делегат.
     *
     * Функция преобразования преобразует объект типа U в типа З.
     */
    this(Обходчик!(U) исток, проц delegate(ref U, ref З) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Конструирует обходчик, используя указатель на функцию преобразования.
     *
     * Функция преобразования преобразует объект типа U в объект типа З.
     */
    this(Обходчик!(U) исток, проц function(ref U, ref З) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Возвращает длину истока.
     */
    бцел длина()
    {
        return _ист.length;
    }
	alias длина length;
    /**
     * Обходит исток, работая с временными копиями
     * трансформируемого элемента З.
     */
    цел opApply(цел delegate(ref З з) дг)
    {
        цел privateDG(ref U u)
        {
            З з;
            _дг(u, з);
            return дг(з);
        }

        цел privateFN(ref U u)
        {
            З з;
            _фн(u, з);
            return дг(з);
        }

        if(_дг is null)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }
}

/**
 * Трансформ для обходчика с ключом
 */
class ТрансформКлючник(К, З, J=К, U=З) : Ключник!(К, З)
{
    private Ключник!(J, U) _ист;
    private проц delegate(ref J, ref U, ref К, ref З) _дг;
    private проц function(ref J, ref U, ref К, ref З) _фн;

    /**
     * Конструирует трансформ-обходчик с помощью трансформ-делегата.
     *
     * Функция преобразования преобразует пару J, U в пару К, З.
     */
    this(Ключник!(J, U) исток, проц delegate(ref J, ref U, ref К, ref З) дг)
    {
        _ист = исток;
        _дг = дг;
    }

    /**
     * Конструирует трансформ-обходчик с помощью указателя на трансформ-функцию.
     *
     * Функция преобразования преобразует пару J, U в пару К, З.
     */
    this(Ключник!(J, U) исток, проц function(ref J, ref U, ref К, ref З) фн)
    {
        _ист = исток;
        _фн = фн;
    }

    /**
     * Возвращает длину истока.
     */
    бцел длина()
    {
        return _ист.length;
    }
	alias длина length;

    /**
     * Iterate through the исток iterator, working with temporary copies of a
     * transformed З элемент.  Note that К can be пропущен if this is the only
     * use for the iterator.
     */
    цел opApply(цел delegate(ref З з) дг)
    {
        цел privateDG(ref J j, ref U u)
        {
            К к;
            З з;
            _дг(j, u, к, з);
            return дг(з);
        }

        цел privateFN(ref J j, ref U u)
        {
            К к;
            З з;
            _фн(j, u, к, з);
            return дг(з);
        }

        if(_дг is null)
            return _ист.opApply(&privateFN);
        else
            return _ист.opApply(&privateDG);
    }

    /**
     * Iterate through the исток iterator, working with temporary copies of a
     * transformed К,З pair.
     */
    цел opApply(цел delegate(ref К к, ref З з) дг)
    {
        цел privateDG(ref J j, ref U u)
        {
            К к;
            З з;
            _дг(j, u, к, з);
            return дг(к, з);
        }

        цел privateFN(ref J j, ref U u)
        {
            К к;
            З з;
            _фн(j, u, к, з);
            return дг(к, з);
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
class ОбходчикЦепи(З) : Обходчик!(З)
{
    private Обходчик!(З)[] _цепь;
    private бул _поддержкаДлины;

    /**
     * Constructor.  Pass in the iterators you wish to цепь together in the
     * order you wish them to be chained.
     *
     * If all of the iterators support длина, then this iterator supports
     * длина.  If one doesn'т, then the длина is not supported.
     */
    this(Обходчик!(З)[] цепь ...)
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
    цел opApply(цел delegate(ref З з) дг)
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
class КлючникЦепи(К, З) : Ключник!(К, З)
{
    private Ключник!(К, З)[] _цепь;
    private бул _поддержкаДлины;

    /**
     * Constructor.  Pass in the iterators you wish to цепь together in the
     * order you wish them to be chained.
     *
     * If all of the iterators support длина, then this iterator supports
     * длина.  If one doesn'т, then the длина is not supported.
     */
    this(Ключник!(К, З)[] цепь ...)
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
    цел opApply(цел delegate(ref З з) дг)
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
    цел opApply(цел delegate(ref К, ref З) дг)
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
class ФильтрОбходчик(З) : Обходчик!(З)
{
    private Обходчик!(З) _ист;
    private бул delegate(ref З) _дг;
    private бул function(ref З) _фн;

    /**
     * Construct a filter iterator with the given delegate deciding whether an
     * элемент will be iterated or not.
     *
     * The delegate should return true for elements that should be iterated.
     */
    this(Обходчик!(З) исток, бул delegate(ref З) дг)
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
    this(Обходчик!(З) исток, бул function(ref З) фн)
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
    цел opApply(цел delegate(ref З з) дг)
    {
        цел privateDG(ref З з)
        {
            if(_дг(з))
                return дг(з);
            return 0;
        }

        цел privateFN(ref З з)
        {
            if(_фн(з))
                return дг(з);
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
class ФильтрКлючник(К, З) : Ключник!(К, З)
{
    private Ключник!(К, З) _ист;
    private бул delegate(ref К, ref З) _дг;
    private бул function(ref К, ref З) _фн;

    /**
     * Construct a filter iterator with the given delegate deciding whether a
     * ключ/значение pair will be iterated or not.
     *
     * The delegate should return true for elements that should be iterated.
     */
    this(Ключник!(К, З) исток, бул delegate(ref К, ref З) дг)
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
    this(Ключник!(К, З) исток, бул function(ref К, ref З) фн)
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
    цел opApply(цел delegate(ref З з) дг)
    {
        цел privateDG(ref К к, ref З з)
        {
            if(_дг(к, з))
                return дг(з);
            return 0;
        }

        цел privateFN(ref К к, ref З з)
        {
            if(_фн(к, з))
                return дг(з);
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
    цел opApply(цел delegate(ref К к, ref З з) дг)
    {
        цел privateDG(ref К к, ref З з)
        {
            if(_дг(к, з))
                return дг(к, з);
            return 0;
        }

        цел privateFN(ref К к, ref З з)
        {
            if(_фн(к, з))
                return дг(к, з);
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
class ОбходчикМассива(З) : Обходчик!(З)
{
    private З[] _массив;

    /**
     * Wrap a given массив.  Note that this does not make a copy.
     */
    this(З[] массив)
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
    цел opApply(цел delegate(ref З) дг)
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
class ОбходчикАМ(К, З) : Ключник!(К, З)
{
    private З[К] _массив;

    /**
     * Construct an iterator wrapper for the given массив
     */
    this(З[К] массив)
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
    цел opApply(цел delegate(ref К, ref З) дг)
    {
        цел возврзнач;
        foreach(к, ref з; _массив)
            if((возврзнач = дг(к, з)) != 0)
                break;
        return возврзнач;
    }
}

/**
 * Function that converts an iterator to an массив.
 *
 * More optimized for iterators that support a длина.
 */
З[] вМассив(З)(Обходчик!(З) обх)
{
    З[] рез;
    бцел длин = обх.length;
    if(длин != ДЛИНА_НЕ_ПОДДЕРЖИВАЕТСЯ)
    {
        //
        // can optimize a bit
        //
        рез.length = длин;
        цел i = 0;
        foreach(з; обх)
            рез[i++] = з;
    }
    else
    {
        foreach(з; обх)
            рез ~= з;
    }
    return рез;
}

/**
 * Convert a keyed iterator to an associative массив.
 */
З[К] вАМ(К, З)(Ключник!(К, З) обх)
{
    З[К] рез;
    foreach(к, з; обх)
        рез[к] = з;
    return рез;
}
