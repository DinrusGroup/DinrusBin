module win;
public  import sys.WinConsts, sys.WinIfaces, sys.WinStructs, sys.WinFuncs, sys.uuid;
/+
public static
{
ук КОНСВВОД;
ук КОНСВЫВОД;
ук КОНСОШ;
//бцел ИДПРОЦЕССА;
//ук   УКНАПРОЦЕСС;
//ук   УКНАНИТЬ;
}

static this()
{
//ИДПРОЦЕССА =  GetCurrentProcessId();
//УКНАПРОЦЕСС = cast(ук) OpenProcess(0x000F0000|0x00100000|0x0FFF,false,ИДПРОЦЕССА);
//УКНАНИТЬ  = GetCurrentThread();
			КОНСВВОД = ДайСтдДескр(ПСтд.Ввод);
			//КОНСВЫВОД = ДайСтдДескр(cast(ПСтд) 0xfffffff5);
			КОНСВЫВОД = ДайСтдДескр(ПСтд.Вывод);
			КОНСОШ = ДайСтдДескр(ПСтд.Ошибка);
}
+/
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