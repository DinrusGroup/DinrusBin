/*
	Copyright (C) 2004-2006 Christopher E. Miller
	
	This software is provided 'as-is', without any express or implied
	warranty.  In no event will the authors be held liable for any damages
	arising from the use of this software.
	
	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:
	
	1. The origin of this software must not be misrepresented; you must not
	   claim that you wrote the original software. If you use this software
	   in a product, an acknowledgment in the product documentation would be
	   appreciated but is not requireauxd.
	2. Altered source versions must be plainly marked as such, and must not be
	   misrepresented as being the original software.
	3. This notice may not be removed or altered from any source distribution.
*/

/*

Update:
Объект Ини больше не сохраняется в деструкторе, если его удаляет
сборщик мусора, объект некоторого значения или раздела может быть
удалён первым, что приведёт к непредсказуемому поведению, например,
к нарушению прав доступа. Решение: использовать функцию сохрани()
перед выходом из программы.


Переносной модуль для чтения и записи файлов INI формата:

[раздел]
ключ=значение
...

Пробелы и табуляции в начале строк игнорируются.
Комментарии начинаются с ; и должны быть в отдельной строке.

If there are comments, spaces or ключи above the first раздел, a имяless раздел is created for them.
This means there need not be any разделы in the файл to have ключи.

Differences with Windows' profile (INI) functions:
* Windows 9x does not allow tabs in the значение.
* Some versions do not allow the файл to exceed 64 KB.
* If not a full файл path, it's relative to the Windows directory.
* Windows 9x strips trailing spaces from the значение.
* There might be a restriction on how long разделы/ключи/значениеs may be.
* If there are double quotes around a значение, Windows removes them.
* All ключ/значение pairs must be in a имяd раздел.

*/



/// Переносной модуль для чтения и записи файлов _INI. _ини.d version 0.6
module ini;

pragma(lib,"dinrus.lib");
private import stdrus, tpl.stream;


//debug = INI; //show файл being parsed

class СтрокаИни
{
	~this();
	
private:
	ткст данные;
}


/// Ключ в файле INI.
class КлючИни: СтрокаИни
{
protected:
	//these are slices in данные if unизменён
	//if изменён, данные is set to пусто
	ткст _имя;
	ткст _значение;

public:

	this(ткст имя);
	
	~this();

	/// Свойство: получить название ключа _имя.
	ткст имя();

	/// Свойство: получить значение ключа _значение.
	ткст значение();
}


/// Раздел ключей в файле INI.
class РазделИни
{
protected:
	Ини _ини;
	ткст _имя;
	СтрокаИни[] строки;

public:
	this(Ини ини, ткст имя);
	
	
	~this();

	/// Свойство: получить название секции _имя.
	ткст имя();

	/// Свойство: установить названии секции _имя.
	проц имя(ткст новИмя);

	/// foreach ключ.
	цел opApply(цел delegate(inout КлючИни) dg);

	/// Свойство: получить все ключи _keys.
	//better to use foreach unless this array is needed
	КлючИни[] ключи();

	/// Возвращает: ключ _key, соответствующий названию ключа имяКлюча, или пусто, если его нет.
	КлючИни ключ(ткст имяКлюча);

	/// Установить значение существующего ключа.
	проц устЗнач(КлючИни иключ, ткст новЗнач);

	/// Find or create ключ имяКлюча and set its _значение to новЗнач.
	проц устЗнач(ткст имяКлюча, ткст новЗнач);	
	
	/+
	///
	alias устЗнач значение;
	+/
	
	
	/// Same as устЗнач(иключ, новЗнач).
	проц значение(КлючИни иключ, ткст новЗнач);
	
	/// Same as устЗнач(имяКлюча, новЗнач).
	проц значение(ткст имяКлюча, ткст новЗнач);

	/// Возвращает: значение of the existing ключ имяКлюча, or дефЗначение if not present.
	ткст дайЗнач(ткст имяКлюча, ткст дефЗначение = пусто);
	
	// /// Возвращает: _значение of the existing ключ имяКлюча, or пусто if not present.
	/// Same as дайЗнач(имяКлюча, пусто).
	ткст значение(ткст имяКлюча);

	/// Shortcut for дайЗнач(имяКлюча).
	ткст opIndex(ткст имяКлюча);

	/// Shortcut for устЗнач(имяКлюча, новЗнач).
	проц opIndexAssign(ткст новЗнач, ткст имяКлюча);	
	
	/// _Remove ключ имяКлюча.
	проц удали(ткст имяКлюча);
}


/// Файл INI .
class Ини
{
protected:
	ткст файл;
	бул _изменён = нет;
	РазделИни[] исекции;
	сим начСекц = '[', конСекц = ']';


	проц разбор();

	проц откройПервым(ткст файл);

public:
	this(ткст файл, сим начСекц, сим конСекц);

	/// Конструирует новый файл INI.
	this(ткст файл);

	~this();

	/// Функция для сравнния имён ключей и разделов. Следует переписать, чтобы изменить поведение.
	бул совпадают(ткст s1, ткст s2);

	//использование одного объекта с другим файлом
	/// Открыть файл INI.
	проц открой(ткст файл);

	/// Перезагрузить файл INI; любые несохранённые изменения будут потеряны.
	проц рехэшируй();

	/// Release memory without saving changes; contents become empty.
	проц дамп();

	/// Property: get whether or not the INI файл was _изменён since it was loaded or saveauxd.
	бул изменён();	
	
	/// Параметры:
	/// f = an opened-for-write stream; сохрани() uses БуфФайл by default. Override сохрани() to change stream.
	protected final проц сохраниВПоток(Поток f);

	/// Write contents to disk, even if no changes were made. It is common to do if(изменён)сохрани();
	проц сохрани();
	
	/// Finds a _section; returns пусто if one имяd имя does not exist.
	РазделИни раздел(ткст имя);
	
	/// Shortcut for раздел(имяРаздела).
	РазделИни opIndex(ткст имяРаздела);

	/// The раздел is created if one имяd имя does not exist.
	/// Возвращает: Section имяd имя.
	РазделИни добавьРаздел(ткст имя);

	/// foreach раздел.
	цел opApply(цел delegate(inout РазделИни) dg);

	/// Property: get all _sections.
	РазделИни[] разделы();
	
	/// _Remove раздел имяd имяРаздела.
	проц удали(ткст имяРаздела);
}


unittest
{
	ткст инифайл = "unittest.ini";
	Ини ини;

	ини = new Ини(инифайл);
	with(ини.добавьРаздел("foo"))
	{
		значение("asdf", "jkl");
		значение("bar", "wee!");
		значение("hi", "hello");
	}
	ини.добавьРаздел("BAR");
	with(ини.добавьРаздел("fOO"))
	{
		значение("yes", "no");
	}
	with(ини.добавьРаздел("Hello"))
	{
		значение("world", "да");
	}
	with(ини.добавьРаздел("test"))
	{
		значение("1", "2");
		значение("3", "4");
	}
	ини["test"]["значение"] = "да";
	assert(ини["Foo"]["yes"] == "no");
	ини.сохрани();
	delete ини;

	ини = new Ини(инифайл);
	assert(ини["FOO"]["Bar"] == "wee!");
	assert(ини["Foo"]["yes"] == "no");
	assert(ини["hello"]["world"] == "да");
	assert(ини["FOO"]["Bar"] == "wee!");
	assert(ини["55"] is пусто);
	assert(ини["hello"]["Yes"] is пусто);
	
	ини.открой(инифайл);
	ини["bar"].удали("notta");
	ини["foo"].удали("bar");
	ини.удали("bar");
	assert(ини["bar"] is пусто);
	assert(ини["foo"] !is пусто);
	assert(ини["foo"]["bar"] is пусто);
	ини.удали("foo");
	assert(ини["foo"] is пусто);
	ини.сохрани();
	delete ини;
}

