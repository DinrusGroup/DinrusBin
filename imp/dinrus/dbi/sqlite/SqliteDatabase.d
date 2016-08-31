/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.sqlite.SqliteDatabase;

version (Rulada) {
	private import stdrus : toDString = вТкст, toCString = вТкст0;
	debug (UnitTest) private import std.io;
} else {
	private import stdrus : toDString = вТкст, toCString = вТкст0;
}
private import dbi.DataBase, dbi.DBIException, dbi.Result, dbi.Row, dbi.Statement;
private import dbi.sqlite.imp, dbi.sqlite.SqliteError, dbi.sqlite.SqliteResult;

/**
 * An implementation of БазаДанных for use with SQLite databases.
 *
 * See_Also:
 *	БазаДанных is the interface that this provides an implementation of.
 */
class БДЭскюлайт : БазаДанных {

	public:

	/**
	 * Create a new instance of SqliteDatabase, but don't open a бд.
	 */
	this () ;

	/**
	 * Create a new instance of SqliteDatabase and open a бд.
	 *
	 * See_Also:
	 *	подключись
	 */
	this (ткст dbFile) ;

	/**
	 * Open a SQLite бд for use.
	 *
	 * Params:
	 *	парамы = The имя of the SQLite бд to open.
	 *	имя_пользователя = Unused.
	 *	пароль = Unused.
	 *
	 * Thряды:
	 *	ИсклДБИ if there was an ошибка accessing the бд.
	 *
	 * Examples:
	 *	---
	 *	БДЭскюлайт бд = new БДЭскюлайт();
	 *	бд.подключись("_test.бд", пусто, пусто);
	 *	---
	 */
	override проц подключись (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто) ;

	/**
	 * Close the current подключение to the бд.
	 */
	override проц закрой () ;

	/**
	 * Execute a SQL statement that returns no результаты.
	 *
	 * Params:
	 *	эскюэл = The SQL statement to _выполни.
	 *
	 * Thряды:
	 *	ИсклДБИ if the SQL code couldn't be выполниd.
	 */
	override проц выполни (ткст эскюэл) ;

	/**
	 * Query the бд.
	 *
	 * Params:
	 *	эскюэл = The SQL statement to выполни.
	 *
	 * Returns:
	 *	A Результат object with the queried information.
	 *
	 * Thряды:
	 *	ИсклДБИ if the SQL code couldn't be выполниd.
	 */
	override РезультатЭскюлайт запрос (ткст эскюэл) ;

	/**
	 * Get the ошибка code.
	 *
	 * Deprecated:
	 *	This functionality now есть in ИсклДБИ.  This will be
	 *	removed in version 0.3.0.
	 *
	 * Returns:
	 *	The бд specific ошибка code.
	 */
	deprecated override цел дайКодОшибки () ;

	/**
	 * Get the ошибка message.
	 *
	 * Deprecated:
	 *	This functionality now есть in ИсклДБИ.  This will be
	 *	removed in version 0.3.0.
	 *
	 * Returns:
	 *	The бд specific ошибка message.
	 */
	deprecated override ткст дайСообОшибки () ;

	/*
	 * Note: The following are not in the DBI API.
	 */

	/**
	 * Get the rowid of the last insert.
	 *
	 * Returns:
	 *	The ряд of the last insert or 0 if no inserts have been done.
	 */
	дол дайИдСтрокиПоследнейВставки () ;

	/**
	 * Get the number of ряды affected by the last SQL statement.
	 *
	 * Returns:
	 *	The number of ряды affected by the last SQL statement.
	 */
	цел дайИзменения () ;

	/**
	 * Get a list of all the таблица имяs.
	 *
	 * Returns:
	 *	An array of all the таблица имяs.
	 */
	ткст[] дайИменаТаблиц () ;

	/**
	 * Get a list of all the view имяs.
	 *
	 * Returns:
	 *	An array of all the view имяs.
	 */
	ткст[] дайИменаОбзора () ;

	/**
	 * Get a list of all the индекс имяs.
	 *
	 * Returns:
	 *	An array of all the индекс имяs.
	 */
	ткст[] дайИменаИндексов ();

	/**
	 * Check if a таблица есть.
	 *
	 * Param:
	 *	имя = Name of the таблица to проверь for the existance of.
	 *
	 * Returns:
	 *	да if it есть or false otherwise.
	 */
	бул естьТаблица (ткст имя) ;

	/**
	 * Check if a view есть.
	 *
	 * Params:
	 *	имя = Name of the view to проверь for the existance of.
	 *
	 * Returns:
	 *	да if it есть or false otherwise.
	 */
	бул естьОбзор_ли (ткст имя);

	/**
	 * Check if an индекс есть.
	 *
	 * Params:
	 *	имя = Name of the индекс to проверь for the existance of.
	 *
	 * Returns:
	 *	да if it есть or false otherwise.
	 */
	бул естьИндекс_ли (ткст имя);

	private:
	sqlite3* бд;
	бул isOpen = false;
	цел кодОш;

	/**
	 *
	 */
	ткст[] дайИменаЭлементов(ткст тип) ;

	/**
	 *
	 */
	бул естьЭлемент(ткст тип, ткст имя) ;
}

unittest {
	version (Phobos) {
		проц s1 (ткст s) {
			std.io.writefln("%s", s);
		}

		проц s2 (ткст s) {
			std.io.writefln("   ...%s", s);
		}
	} else {
		проц s1 (ткст s) {
			io.Stdout.Стдвыв(s).нс();
		}

		проц s2 (ткст s) {
			io.Stdout.Стдвыв("   ..." ~ s).нс();
		}
	}

	s1("dbi.sqlite.SqliteDatabase:");
	БДЭскюлайт бд = new БДЭскюлайт();
	s2("подключись");
	бд.подключись("test.бд");

	s2("запрос");
	Результат рез = бд.запрос("SELECT * FROM test");
	assert (рез !is пусто);

	s2("получиРяд");
	Ряд ряд = рез.получиРяд();
	assert (ряд !is пусто);
	assert (ряд.дайИндексПоля("id") == 0);
	assert (ряд.дайИндексПоля("имя") == 1);
	assert (ряд.дайИндексПоля("dateofbirth") == 2);
	assert (ряд.дай("id") == "1");
	assert (ряд.дай("имя") == "John Doe");
	assert (ряд.дай("dateofbirth") == "1970-01-01");
	assert (ряд.дайТипПоля(1) == SQLITE_TEXT);
	assert (ряд.дайОбъявлПоля(1) == "char(40)");
	рез.финиш();

	s2("подготовь");
	Инструкция инстр = бд.подготовь("SELECT * FROM test WHERE id = ?");
	инстр.вяжи(1, "1");
	рез = инстр.запрос();
	ряд = рез.получиРяд();
	рез.финиш();
	assert (ряд[0] == "1");

	s2("fetchOne");
	ряд = бд.запросПолучиОдин("SELECT * FROM test");
	assert (ряд[0] == "1");

	s2("выполни(INSERT)");
	бд.выполни("INSERT INTO test VALUES (2, 'Jane Doe', '2000-12-31')");

	s2("выполни(DELETE via подготовь statement)");
	инстр = бд.подготовь("DELETE FROM test WHERE id=?");
	инстр.вяжи(1, "2");
	инстр.выполни();

	s2("дайИзменения");
	assert (бд.дайИзменения() == 1);

	s2("дайИменаТаблиц, дайИменаОбзора, дайИменаИндексов");
	assert (бд.дайИменаТаблиц().length == 1);
	assert (бд.дайИменаИндексов().length == 1);
	assert (бд.дайИменаОбзора().length == 0);

	s2("естьТаблица, естьОбзор_ли, естьИндекс_ли");
	assert (бд.естьТаблица("test") == да);
	assert (бд.естьТаблица("doesnotexist") == false);
	assert (бд.естьИндекс_ли("doesnotexist") == false);
	assert (бд.естьОбзор_ли("doesnotexist") == false);

	s2("закрой");
	бд.закрой();
}