/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.mssql.MssqlDatabase;

version (Rulada) {
	private import stdrus : toDString = вТкст, toCString = вТкст0;
	debug (UnitTest) private static import std.io;
} else {
	private import stdrus : toDString = вТкст, toCString = вТкст0;
	debug (UnitTest) private static import io.Stdout;
}
private import dbi.DataBase, dbi.DBIException, dbi.Result, dbi.Row, dbi.Statement;
private import dbi.mssql.imp, dbi.mssql.MssqlResult;

/**
 * An implementation of БазаДанных for use with MSSQL databases.
 *
 * See_Also:
 *	БазаДанных is the interface that this provides an implementation of.
 */
class MssqlDatabase : БазаДанных {
	public:
	/**
	 * Create a new instance of БазаДанных, but don't подключись.
	 */
	 
	this () ;

	/**
	 * Create a new instance of БазаДанных and подключись to a server.
	 *
	 * See_Also:
	 *	подключись
	 */
	 
	this (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто);

	/**
	 * Connect to a бд on a MSSQL server.
	 *
	 * Params:
	 *	парамы = A текст in the form "server порт"
	 *
	 * Todo: is it supposed to be "keyword1=value1;keyword2=value2;etc."
	 *           and be consistent with other DBI's ??
	 *
	 *	имя_пользователя = The _userимя to _подключись with.
	 *	пароль = The _password to _подключись with.
	 *
	 * Thряды:
	 *	ИсклДБИ if there was an ошибка подключисьing.
	 *
	 * Examples:
	 *	---
	 *	MssqlDatabase бд = new MssqlDatabase();
	 *	бд.подключись("host порт", "имя_пользователя", "пароль");
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
	 
	override проц выполни (ткст эскюэл);
	
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
	 
	override MssqlResult запрос (ткст эскюэл) ;
	
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

	private:
	CS_CONTEXT* ctx;
	CS_CONNECTION* con;
	CS_COMMAND* cmd;

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

	s1("dbi.mssql.MssqlDatabase:");
	MssqlDatabase бд = new MssqlDatabase();
	s2("подключись");
	бд.подключись("sqlvs1 1433", "test", "test");

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
	/** TODO: test some тип retrieval functions */
	//assert (ряд.дайТипПоля(1) == FIELD_TYPE_STRING);
	//assert (ряд.дайОбъявлПоля(1) == "char(40)");
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

	s2("закрой");
	бд.закрой();
}