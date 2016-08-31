module tpl.args;


	template ва_старт( T )
	{
		проц ва_старт( out спис_ва ap, inout T члопарам )
		{
			ap = cast(спис_ва) ( cast(ук) &члопарам + ( ( T.sizeof + цел.sizeof - 1 ) & ~( цел.sizeof - 1 ) ) );
		}
	}

	template ва_арг( T )
	{
		T ва_арг( inout спис_ва ap )
		{
			T арг = *cast(T*) ap;
			ap = cast(спис_ва) ( cast(ук) ap + ( ( T.sizeof + цел.sizeof - 1 ) & ~( цел.sizeof - 1 ) ) );
			return арг;
		}
	}

	проц ва_стоп( спис_ва ap )
	{

	}

	проц ва_копируй( out спис_ва куда, спис_ва откуда )
	{
		куда = откуда;
	}

alias ва_старт va_start;
alias ва_арг va_arg;
alias ва_стоп va_end;
alias ва_копируй va_copy;

extern (C) template ва_арг_ди(T)
{
    T va_arg(inout va_list _argptr)
    {
	T арг = *cast(T*)_argptr;
	_argptr = _argptr + ((T.sizeof + int.sizeof - 1) & ~(int.sizeof - 1));
	return арг;
    }
}