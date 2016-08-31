module viz.structs;
import winapi, sys.DStructs, viz.control;

alias typeof(""c[]) Ткст;
alias typeof(""c.ptr) Ткст0;
alias typeof(" "c[0]) Сим;
alias typeof(""w[]) Шткст;
alias typeof(""w.ptr) Шткст0;
alias typeof(" "w[0]) Шим;
alias typeof(""d[]) Дткст;
alias typeof(""d.ptr) Дткст0;
alias typeof(" "d[0]) Дим;

extern(D):

struct ШрифтЛога
{
	union
	{
		LOGFONTW шлш;
		LOGFONTA шла;
	}
	alias шлш шл;
	
	Ткст имяФаса;
}

struct КлассОкна
{
	union
	{
		WNDCLASSW кош;
		WNDCLASSA коа;
	}
	alias кош ко;
	
	Ткст имяКласса;
}

struct ДанныеВызова
{
	Объект delegate(Объект[]) дг;
	Объект[] арги;
	Объект результат;
	Объект исключение = пусто;
}

struct ПарамВызоваВиз
{
	проц function(УпрЭлт, т_мера[]) fp;
	т_мера nparams;
	т_мера[1] params;
}

struct ПростыеДанныеВызова
{
	проц delegate() дг;
	Объект исключение = пусто;
}

struct Сообщение
{
	union
	{
		struct
		{
			УОК уок; 
			бцел сооб; 
			бцел парам1; 
			цел парам2; 
		}
		
		package СООБ _винСооб;
	}
	цел результат; 	
	
	static Сообщение opCall(УОК уок, бцел сооб, бцел парам1, цел парам2);
}
/// X and Y coordinate.
struct Точка 
{

	union
	{
		struct
		{
			цел ш;
			цел в;
		}
		ТОЧКА точка; 
	}
		
	/// Construct а new Точка.
	static Точка opCall(цел ш, цел в);
		
	static Точка opCall();
		
	т_рав opEquals(Точка тчк);
	
	
	Точка opAdd(Размер разм);
		
	Точка opSub(Размер разм);
		
	проц opAddAssign(Размер разм);
		
	проц opSubAssign(Размер разм);
		
	Точка opNeg();
}

/// ширина и высота.
struct Размер 
{
	union
	{
		struct
		{
			цел ширина;
			цел высота;
		}
		РАЗМЕР размер;
	}
	
	/// Construct а new Размер.
	static Размер opCall(цел ширина, цел высота);
	
	static Размер opCall();
		
	т_рав opEquals(Размер разм);	
	
		Размер opAdd(Размер разм);	
	
		Размер opSub(Размер разм);	
	
		проц opAddAssign(Размер разм);	
	
		проц opSubAssign(Размер разм);
}


/// X, Y, ширина and высота rectangle dimensions.
struct Прям // docmain
{
	цел ш, в, ширина, высота;
	
	// Used internally.
	проц дайПрям(ПРЯМ* к);
		
	Точка положение() ;
		
	проц положение(Точка тчк) ;
		
	Размер размер() ;
		
	проц размер(Размер разм);
		
	цел право() ;
		
	цел низ() ;
		
	/// Construct а new Прям.
	static Прям opCall(цел ш, цел в, цел ширина, цел высота);
		
	static Прям opCall(Точка положение, Размер размер);
		
	static Прям opCall();
		
	// Used internally.
	static Прям opCall(ПРЯМ* прям) ;	
	
	/// Construct а new Прям from лево, верх, право and верх values.
	static Прям изЛВПН(цел лево, цел верх, цел право, цел низ);
		
	т_рав opEquals(Прям к);
		
	бул содержит(цел c_x, цел c_y);
		
	бул содержит(Точка поз);	
	
	// Contained entirely within -this-.
	бул содержит(Прям к);
	
	проц инфлируй(цел i_width, цел i_height);
	
	проц инфлируй(Размер insz);
	
		// Just tests if there's an intersection.
	бул пересекаетсяС(Прям к);
		
	проц смещение(цел ш, цел в);
		
	проц смещение(Точка тчк);	
	

}


unittest
{
	Прям к = Прям(3, 3, 3, 3);
	
	assert(к.содержит(3, 3));
	assert(!к.содержит(3, 2));
	assert(к.содержит(6, 6));
	assert(!к.содержит(6, 7));
	assert(к.содержит(к));
	assert(к.содержит(Прям(4, 4, 2, 2)));
	assert(!к.содержит(Прям(2, 4, 4, 2)));
	assert(!к.содержит(Прям(4, 3, 2, 4)));
	
	к.инфлируй(2, 1);
	assert(к.ш == 1);
	assert(к.право == 8);
	assert(к.в == 2);
	assert(к.низ == 7);
	к.инфлируй(-2, -1);
	assert(к == Прям(3, 3, 3, 3));
	
	assert(к.пересекаетсяС(Прям(4, 4, 2, 9)));
	assert(к.пересекаетсяС(Прям(3, 3, 1, 1)));
	assert(к.пересекаетсяС(Прям(0, 3, 3, 0)));
	assert(к.пересекаетсяС(Прям(3, 2, 0, 1)));
	assert(!к.пересекаетсяС(Прям(3, 1, 0, 1)));
	assert(к.пересекаетсяС(Прям(5, 6, 1, 1)));
	assert(!к.пересекаетсяС(Прям(7, 6, 1, 1)));
	assert(!к.пересекаетсяС(Прям(6, 7, 1, 1)));
}

/// Цвет значение representation
struct Цвет // docmain
{
	/// Red, зелёный, синий and альфа channel цвет values.
	ббайт к() ;		
	ббайт з() ;		
	ббайт с();		
	ббайт а() ;
	
	/// Return the numeric цвет значение.
	ЦВПредст вАкзс();
		
	/// Return the numeric красный, зелёный and синий цвет значение.
	ЦВПредст вКзс();
		
	// Used internally.
	УКисть создайКисть() ;
	
	deprecated static Цвет opCall(ЦВПредст argb);
	
	/// Construct а new цвет.
	static Цвет opCall(ббайт альфа, Цвет ктрл);
		
	static Цвет opCall(ббайт красный, ббайт зелёный, ббайт синий);
	
	static Цвет opCall(ббайт альфа, ббайт красный, ббайт зелёный, ббайт синий);
	
	//alias opCall изАкзс;
	static Цвет изАкзс(ббайт альфа, ббайт красный, ббайт зелёный, ббайт синий);
	
	static Цвет изКзс(ЦВПредст кзс);
	
	static Цвет изКзс(ббайт альфа, ЦВПредст кзс);
	
	static Цвет пуст() ;
	
	/// Return а completely прозрачный цвет значение.
	static Цвет прозрачный();
		
	/// Blend colors; альфа channels are ignored.
	// Blends the цвет channels half way.
	// Does not consider альфа channels and discards them.
	// The new blended цвет is returned; -this- Цвет is not изменён.
	Цвет смешайСЦветом(Цвет ко);
	
	/// Alpha blend this цвет with а background цвет to return а solid цвет (100% opaque).
	// Blends with цветФона if this цвет has непрозрачность to produce а solid цвет.
	// Returns the new solid цвет, or the original цвет if нет непрозрачность.
	// If цветФона has непрозрачность, it is ignored.
	// The new blended цвет is returned; -this- Цвет is not изменён.
	Цвет плотныйЦвет(Цвет цветФона);
	
	package static Цвет системныйЦвет(цел индексЦвета);
	
	// Gets цвет индекс or ИНДЕКС_НЕВЕРНОГО_СИСТЕМНОГО_ЦВЕТА.
	package цел _systemColorIndex() ;
	
	package const ббайт ИНДЕКС_НЕВЕРНОГО_СИСТЕМНОГО_ЦВЕТА = ббайт.max;
		
	private:
	union _цвет
	{
		struct
		{
			align(1):
			ббайт красный;
			ббайт зелёный;
			ббайт синий;
			ббайт альфа;
		}
		ЦВПредст цпредст;
	}
	static assert(_цвет.sizeof == бцел.sizeof);
	_цвет цвет;
	
	ббайт sysIndex = ИНДЕКС_НЕВЕРНОГО_СИСТЕМНОГО_ЦВЕТА;
		
	проц оцениЦвет();
}

/// Параметры создания УпрЭлт.
struct ПарамыСозд
{
	Ткст имяКласса; 
	Ткст заглавие; 
	ук парам; 
	УОК родитель; 
	HMENU меню; 
	экз экземп; 
	цел ш; 
	цел в; 
	цел ширина; 
	цел высота; 
	DWORD стильКласса; 
	DWORD допСтиль; 
	DWORD стиль; 
}