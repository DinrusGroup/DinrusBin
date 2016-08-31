//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.menu;

private import winapi, viz.control, viz.common, viz.collections;
private import viz.app;


extern(D):

 class КонтекстноеМеню: Меню // docmain
	{
		final проц покажи(УпрЭлт упрэлт, Точка поз);
		Событие!(КонтекстноеМеню, АргиСоб) всплытие;		
		this(HMENU hmenu, бул owned = да);
		this();		
		~this();		
		protected override проц поОбратномуСообщению(inout Сообщение m);

	}


class ПунктМеню: Меню // docmain
	{
		final проц текст(Ткст txt);
		final Ткст текст() ;
		final проц родитель(Меню m);
		final Меню родитель() ;
		final проц barBreak(бул подтвержд);
		final бул barBreak() ;
		final проц breakItem(бул подтвержд) ;
		final бул breakItem();
		final проц установлен(бул подтвержд);		
		final бул установлен();
		final проц дефЭлт(бул подтвержд);
		final бул дефЭлт();
		final проц включен(бул подтвержд);		
		final бул включен();
		final проц индекс(цел idx);
		final цел индекс() ;		
		override бул родитель_ли();
		final сим мнемоника() ;
		final проц радиоФлажок(бул подтвержд);
		final бул радиоФлажок();
		final проц выполниКлик();
		final проц выполниВыделение();
		this(HMENU hmenu, бул owned = да);
		this(ПунктМеню[] элты);
		this(Ткст текст);
		this(Ткст текст, ПунктМеню[] элты);
		this();
		~this();
		Ткст вТкст();
		override т_рав opEquals(Объект o);		
		т_рав opEquals(Ткст val);		
		override цел opCmp(Объект o);
		цел opCmp(Ткст val);
		protected override проц поОбратномуСообщению(inout Сообщение m);
		Событие!(ПунктМеню, АргиСоб) клик; 		//СобОбработчик всплытие;
		Событие!(ПунктМеню, АргиСоб) всплытие; 		//СобОбработчик выдели;
		Событие!(ПунктМеню, АргиСоб) выдели; 		
		
		protected:
		final цел идМеню() ;
		проц приКлике(АргиСоб ea);
		проц поВсплытию(АргиСоб ea);
		проц поВыделению(АргиСоб ea);
	}


	abstract class Меню: Объект // docmain
	{

		static class КоллекцияЭлементовМеню
		{
			protected this(Меню хозяин);			
			package final проц _additem(ПунктМеню mi);
			package final проц _delitem(цел idx);
			проц добавь(ПунктМеню mi);
			проц добавь(Ткст значение);
			проц добавьДиапазон(ПунктМеню[] элты);
			проц добавьДиапазон(Ткст[] элты);
		}
		
		protected this();
		this(HMENU hmenu, бул owned = да);
		this(HMENU hmenu, ПунктМеню[] элты);
		this(ПунктМеню[] элты);		
		~this();		
		final проц тэг(Объект o);
		final Объект тэг();
		final HMENU указатель();
		final КоллекцияЭлементовМеню элтыМеню();
		бул родитель_ли();
		protected проц поОбратномуСообщению(inout Сообщение m);
	}


extern(D) class ГлавноеМеню: Меню // docmain
	{
		this(HMENU hmenu, бул owned = да);
		this();		
		this(ПунктМеню[] элты);
	}


