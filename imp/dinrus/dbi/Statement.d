module dbi.Statement;
private import stdrus, text.Util;
private import dbi.DataBase, dbi.DBIException, dbi.Result;

/**
 * Подготавливает инструкцию на SQL.
 *
 * Bugs:
 *	Инструкция сохраняется, не не подготавливается.
 *
 *	Эта версия индекса игнорирует свой первый параметр.
 *
 *	Обе формы связки нельзя использовать одновременно.
 *
 * Todo:
 *	make выполни/запрос("10", "20", 30); work (variable arguments for подвязing to ?, ?, ?, etc...)
 */
final class Инструкция {
	/**
	 * Создаёт новый экземпляр Инструкция.
	 *
	 * Params:
	 *	бд = The бд подключение to use.
	 *	эскюэл = The SQL code to подготовь.
	 */
	this (БазаДанных бд, ткст эскюэл) ;

	/**
	 * Bind a _value to the следщ "?".
	 *
	 * Params:
	 *	индекс = Currently ignored.  This is a bug.
	 *	значение = The _value to _подвяз.
	 */
	проц вяжи (т_мера индекс, ткст значение);

	/**
	 * Bind a _value to a ":имя:".
	 *
	 * Params:
	 *	fn = The имя to _подвяз значение to.
	 *	значение = The _value to _подвяз.
	 */
	проц вяжи (ткст fn, ткст значение);

	/**
	 * Execute a SQL statement that returns no результаты.
	 */
	проц выполни () ;

	/**
	 * Query the бд.
	 *
	 * Returns:
	 *	A Результат object with the queried information.
	 */
	Результат запрос () ;

	private:
	БазаДанных бд;
	ткст эскюэл;
	ткст[] подвязки;
	ткст[] подвязкиПНн;

	/**
	 * Escape a SQL statement.
	 *
	 * Params:
	 *	текст = An unescaped SQL statement.
	 *
	 * Returns:
	 *	The escaped form of текст.
	 */
	ткст искейп (ткст текст) ;

	/**
	 * Replace every "?" in the current SQL statement with its bound значение.
	 *
	 * Returns:
	 *	The current SQL statement with all occurences of "?" replaced.
	 *
	 * Todo:
	 *	Raise an exception if подвязки.length != счёт(эскюэл, "?")
	 */
	ткст дайЭсКюЭлпоКМ () ;

	/**
	 * Replace every ":имя:" in the current SQL statement with its bound значение.
	 *
	 * Returns:
	 *	The current SQL statement with all occurences of ":имя:" replaced.
	 *
	 * Todo:
	 *	Raise an exception if подвязки.length != (счёт(эскюэл, ":") * 2)
	 */
	ткст дайЭсКюЭлпоПН () ;

	/**
	 * Replace all variables with their bound значения.
	 *
	 * Returns:
	 *	The current SQL statement with all occurences of variables replaced.
	 */
	ткст дайЭсКюЭл () ;

	/**
	 * Get the значение bound to a ":имя:".
	 *
	 * Params:
	 *	fn = The ":имя:" to return the bound значение of.
	 *
	 * Returns:
	 *	The bound значение of fn.
	 *
	 * Thряды:
	 *	ИсклДБИ if fn is not bound
	 */
	ткст дайСвязанноеЗначение (ткст fn);
}
import stdrus;
unittest {
	

		проц s1 (ткст s) {
			скажифнс("%s", s);
		}

		проц s2 (ткст s) {
			скажифнс("   ...%s", s);
		}

	
	s1("dbi.Statement:");
	Инструкция инстр = new Инструкция(пусто, "SELECT * FROM люди");
	ткст резЭсКюЭл = "SELECT * FROM люди WHERE id = '10' OR имя LIKE 'John Mc\\'Donald'";

	s2("искейп");
	assert (инстр.искейп("John Mc'Donald") == "John Mc\\'Donald");

	s2("простой эскюэл");
	инстр = new Инструкция(пусто, "SELECT * FROM люди");
	assert (инстр.дайЭсКюЭл() == "SELECT * FROM люди");

	s2("вяжим по '?'");
	инстр = new Инструкция(пусто, "SELECT * FROM люди WHERE id = ? OR имя LIKE ?");
	инстр.вяжи(1, "10");
	инстр.вяжи(2, "John Mc'Donald");
	assert (инстр.дайЭсКюЭл() == резЭсКюЭл);

	/+
	s2("вяжи by '?' sent to дайЭсКюЭл via variable arguments");
	инстр = new Инструкция("SELECT * FROM люди WHERE id = ? OR имя LIKE ?");
	assert (инстр.дайЭсКюЭл("10", "John Mc'Donald") == резЭсКюЭл);
	+/

	s2("вяжим по ':имя_поля:'");
	инстр = new Инструкция(пусто, "SELECT * FROM люди WHERE id = :id: OR имя LIKE :имя:");
	инстр.вяжи("id", "10");
	инстр.вяжи("имя", "John Mc'Donald");
	assert (инстр.дайСвязанноеЗначение("имя") == "John Mc\\'Donald");
	assert (инстр.дайЭсКюЭл() == резЭсКюЭл);
}