module win;
public  import sys.DConsts, sys.DIfaces, sys.DStructs, sys.DFuncs, sys.uuid;

extern(C)
{
	проц  перейдиНаТочкуКонсоли( цел aX, цел aY);
	проц установиАтрыКонсоли(ПТекстКонсоли атр);
	цел гдеИксКонсоли();
	цел гдеИгрекКонсоли();
	ПТекстКонсоли дайАтрыКонсоли();
	проц сбросьЦветКонсоли();
	фук консВход();
	фук консВыход();
	фук консОш();

	struct Console
	{
			alias newline opCall;
			alias emit    opCall;
		
			/// emit a utf8 string to the console
			Console emit(char[] s);
			Console err(char[] s);
			/// emit an unsigned integer to the console
			Console emit(ulong i);
			/// emit a newline to the console
			Console newline();
			alias newline нс;
	}
}

extern(D):

	проц скажи(ткст ткт);
	проц скажи(бдол ткт);
	проц скажинс(ткст ткт);	
	проц скажинс(бдол ткт);
	проц ошибнс(ткст ткт);
	проц нс();
	проц таб();