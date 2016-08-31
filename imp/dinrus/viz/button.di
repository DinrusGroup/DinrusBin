//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.button;

private import viz.common, viz.control, viz.app;


private extern(Windows) проц _initButton();

extern(D):

abstract class ОсноваКнопки: СуперКлассУпрЭлта // docmain
{

	проц разместиТекст(ПРасположение calign) ;
	ПРасположение разместиТекст();
	protected override проц создайПараметры(inout ПарамыСозд cp);
	protected override проц предшОкПроц(inout Сообщение сооб);
	protected override проц поОбратномуСообщению(inout Сообщение m);
	protected override проц окПроц(inout Сообщение сооб);
	this();
	
	protected:
	
	final проц дефолт_ли(бул подтвержд);	
	final бул дефолт_ли();
	protected override бул обработайМнемонику(дим кодСим);
	Размер дефРазм() ;
}


class Кнопка: ОсноваКнопки, ИУпрЭлтКнопка // docmain
{

	this();
	
	ПРезДиалога резДиалога();
	проц резДиалога(ПРезДиалога dr) ;
	проц сообщиДеф(бул подтвержд);
	проц выполниКлик();
	protected override проц приКлике(АргиСоб ea);	
	protected override проц окПроц(inout Сообщение m);
	override проц текст(Ткст txt) ;
	alias УпрЭлт.текст текст; // Overload.
		
	final Рисунок рисунок();	
	final проц рисунок(Рисунок img);
	protected override проц поСозданиюУказателя(АргиСоб ea);
	protected override проц поУдалениюУказателя(АргиСоб ea);
}


class Флажок: ОсноваКнопки // docmain
{

	final проц наружность(ПНаружность ap);
	final ПНаружность наружность() ;
	final проц автоУстанов(бул подтвержд) ;
	final бул автоУстанов() ;
	this();
	final проц установлен(бул подтвержд);
	final бул установлен();
	final проц состояние(ПСостУст st);
	final ПСостУст состояние();
	protected override проц поСозданиюУказателя(АргиСоб ea);

}

class РадиоКнопка: ОсноваКнопки // docmain
{

	final проц наружность(ПНаружность ap);
	final ПНаружность наружность() ;
	final проц автоУстанов(бул подтвержд);
	final бул автоУстанов();
	this();	
	protected override проц приКлике(АргиСоб ea);
	final проц установлен(бул подтвержд) ;
	final бул установлен() ;
	final проц состояние(ПСостУст st) ;
	final ПСостУст состояние();
	проц выполниКлик();
	protected override проц поСозданиюУказателя(АргиСоб ea);
}

