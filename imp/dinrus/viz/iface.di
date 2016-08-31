module viz.iface;
import viz.structs, viz.consts, viz.data, viz.control;


interface ИУпрЭлтКонтейнер // docmain
{
		УпрЭлт активныйУпрЭлт(); // getter
	
	deprecated проц активныйУпрЭлт(УпрЭлт); // setter
	
	deprecated бул активируйУпрЭлт(УпрЭлт);
}
/// Interface to а данные object. The данные can have different formats by setting different formats.
interface ИОбъектДанных // docmain
{
	Данные получитьДанные(Ткст фмт);	
	Данные получитьДанные(ИнфОТипе тип);	
	Данные получитьДанные(Ткст фмт, бул doConvert);	
		бул дайИмеющиесяДанные(Ткст фмт); // Check.	
	бул дайИмеющиесяДанные(ИнфОТипе тип); // Check.	
	бул дайИмеющиесяДанные(Ткст фмт, бул можноПреобразовать); // Check.	
		Ткст[] дайФорматы();
	//Ткст[] дайФорматы(бул onlyNative);	
	проц установиДанные(Данные объ);	
	проц установиДанные(Ткст фмт, Данные объ);	
	проц установиДанные(ИнфОТипе тип, Данные объ);	
	проц установиДанные(Ткст фмт, бул можноПреобразовать, Данные объ);
}

interface ИФильтрСооб // docmain
{
		// Return нет to allow the сообщение to be dispatched.
	// Filter functions cannot modify messages.
	бул предфильтровкаСообщения(inout Сообщение m);
}
/+
interface ИАсинхРез
{
	ЖдиУк ждиУкАсинх(); // getter	
	// Usually just returns нет.
	бул выполненоСинхронно(); // getter	
	// When да, it is safe to release its ресурсы.
	бул выполнено_ли(); // getter
}
+/
interface ИУпрЭлтКнопка {
		ПРезДиалога резДиалога(); // getter	
	проц резДиалога(ПРезДиалога); // setter	
		проц сообщиДеф(бул); // True if default кнопка.	
		проц выполниКлик(); // Raise клик событие.
}

interface ИРезДиалога
{
	// 	ПРезДиалога резДиалога(); // getter
	// 
	проц резДиалога(ПРезДиалога); // setter
}

interface ИОкно // docmain
{
		УОК указатель(); // getter
}