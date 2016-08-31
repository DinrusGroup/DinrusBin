//Автор Кристофер Миллер. Переработано для Динрус Виталием Кулич.
//Библиотека визуальных конпонентов VIZ (первоначально DFL).


module viz.textbox;
private import viz.control, viz.common, viz.app, viz.menu;

private extern(Windows) проц _initTextBox();

extern(D) abstract class ОсноваТекстБокса: СуперКлассУпрЭлта // docmain
{
	final проц acceptsTab(бул подтвержд);
	final бул acceptsTab() ;
	проц стильКромки(ПСтильКромки bs);
	ПСтильКромки стильКромки();
	final бул можноОтменить();
	final проц скройВыделение(бул подтвержд);
	final бул скройВыделение();
	final проц строки(Ткст[] lns);
	final Ткст[] строки();
	проц максДлина(бцел len);
	бцел максДлина();
	final бцел дайЧлоСтрок();
	final проц изменён(бул подтвержд);	
	final бул изменён() ;
	проц многострок(бул подтвержд);
	бул многострок() ;
	final проц толькоЧтение(бул подтвержд);
	final бул толькоЧтение();
	проц выделенныйТекст(Ткст sel);
	Ткст выделенныйТекст();
	проц длинаВыделения(бцел len);
	бцел длинаВыделения();
	проц началоВыделения(бцел поз) ;
	бцел началоВыделения() ;
	бцел длинаТекста();
	final проц wordWrap(бул подтвержд);
	final бул wordWrap();
	final проц добавьТекст(Ткст txt);
	final проц сотри();
	final проц сотриОтмену();
	final проц копируй();
	final проц вырежь();
	final проц вставь();
	final проц прокрутиДоКаретки();
	final проц выдели(бцел старт, бцел length);
	alias УпрЭлт.выдели выдели;
	final проц выделиВсе();
	Ткст вТкст();
	final проц отмени();
	override проц создайУказатель();
	protected override проц создайПараметры(inout ПарамыСозд cp);
	protected override проц поСозданиюУказателя(АргиСоб ea);
	this();
	override Цвет цветФона();
	alias УпрЭлт.цветФона цветФона; 
	static Цвет дефЦветФона();
	override Цвет цветПП() ;
	alias УпрЭлт.цветПП цветПП; 
	static Цвет дефЦветПП();
	override Курсор курсор();
	alias УпрЭлт.курсор курсор;
	цел getFirstCharIndexFromLine(цел line);
	цел getFirstCharIndexOfCurrentLine();
	цел getLineFromCharIndex(цел charIndex);
	Точка getPositionFromCharIndex(цел charIndex);
	цел getCharIndexFromPosition(Точка тчк);
	protected:
	override проц поОбратномуСообщению(inout Сообщение m);
	override проц предшОкПроц(inout Сообщение сооб);
	override бул обработайАргиСобКлавиш(inout Сообщение сооб);
	override проц окПроц(inout Сообщение сооб);
	override Размер дефРазм();
}


extern(D) class ТекстБокс: ОсноваТекстБокса // docmain
{
	final проц acceptsReturn(бул подтвержд);
	final бул acceptsReturn();
	final проц characterCasing(ПРегистрСимволов cc);
	final ПРегистрСимволов characterCasing();
	final проц passwordChar(дим pwc);
	final дим passwordChar();
	final проц полосыПрокрутки(ППолосыПрокрутки sb);
	final ППолосыПрокрутки полосыПрокрутки() ;
	final проц разместиТекст(ПГоризРасположение ha);
	final ПГоризРасположение разместиТекст();
	this();
	protected override проц поСозданиюУказателя(АргиСоб ea);
}

