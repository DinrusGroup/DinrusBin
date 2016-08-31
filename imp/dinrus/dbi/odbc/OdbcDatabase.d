/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.odbc.OdbcDatabase;

// Almost every cast involving chars and SQLCHARs shouldn't exist, but involve bugs in
// WindowsAPI revision 144.  I'll see about fixing their ODBC and SQL files soon.
// WindowsAPI should also include odbc32.lib itself.

version(Dinrus) {
	private static import stdrus;
	debug (UnitTest) private static import std.io;
} else {
	private static import text.Util;
	debug (UnitTest) private static import io.Stdout;
}
private import dbi.DataBase, dbi.DBIException, dbi.Result;
private import dbi.odbc.OdbcResult;
private import win32.odbcinst, win32.sql, win32.sqlext, win32.sqltypes, win32.sqlucode, win32.windef;
debug (UnitTest) private import dbi.Row, dbi.Statement;

version (Windows) pragma (lib, "odbc32.lib");

private SQLHENV environment;

/*
 * This is in the эскюэл headers, but wasn't ported in WindowsAPI revision 144.
 */
private бул SQL_SUCCEEDED (SQLRETURN ret);

static this () ;

static ~this () ;

/**
 * An implementation of БазаДанных for use with the ODBC interface.
 *
 * Bugs:
 *	БазаДанных-specific ошибка codes are not converted to КодОшибки.
 *
 * See_Also:
 *	БазаДанных is the interface that this provides an implementation of.
 */
class ОдбцБД : БазаДанных {
	public:
	/**
	 * Create a new instance of ОдбцБД, but don't подключись.
	 *
	 * Thряды:
	 *	ИсклДБИ if an ODBC подключение couldn't be created.
	 */
	this () ;

	/**
	 * Create a new instance of ОдбцБД and подключись to a server.
	 *
	 * Thряды:
	 *	ИсклДБИ if an ODBC подключение couldn't be created.
	 *
	 * See_Also:
	 *	подключись
	 */
	this (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто);

	/**
	 * Deallocate the подключение handle.
	 */
	~this () ;

	/**
	 * Connect to a бд using ODBC.
	 *
	 * This function will подключись without DSN if парамы has a '=' and with DSN
	 * otherwise.  For information on how to use подключись without DSN, see the
	 * ODBC documentation.
	 *
	 * Bugs:
	 *	Connecting without DSN ignores имя_пользователя and пароль.
	 *
	 * Params:
	 *	парамы = The DSN to use or the подключение parameters.
	 *	имя_пользователя = The _userимя to _подключись with.
	 *	пароль = The _password to _подключись with.
	 *
	 * Thряды:
	 *	ИсклДБИ if there was an ошибка подключисьing.
	 *
	 * Examples:
	 *	---
	 *	ОдбцБД бд = new ОдбцБД();
	 *	бд.подключись("Data Source Name", "_userимя", "_password");
	 *	---
	 *
	 * See_Also:
	 *	The ODBC documentation included with the MDAC 2.8 SDK.
	 */
	override проц подключись (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто) ;

	/**
	 * Close the current подключение to the бд.
	 *
	 * Thряды:
	 *	ИсклДБИ if there was an ошибка disподключисьing.
	 */
	override проц закрой ();

	/**
	 * Execute a SQL statement that returns no результаты.
	 *
	 * Params:
	 *	эскюэл = The SQL statement to _выполни.
	 *
	 * Thряды:
	 *	ИсклДБИ if an ODBC statement couldn't be created.
	 *
	 *	ИсклДБИ if the SQL code couldn't be выполниd.
	 *
	 *	ИсклДБИ if there is an ошибка while committing the changes.
	 *
	 *	ИсклДБИ if there is an ошибка while rolling back the changes.
	 *
	 *	ИсклДБИ if an ODBC statement couldn't be destroyed.
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
	 *	ИсклДБИ if an ODBC statement couldn't be created.
	 *
	 *	ИсклДБИ if the SQL code couldn't be выполниd.
	 *
	 *	ИсклДБИ if there is an ошибка while committing the changes.
	 *
	 *	ИсклДБИ if there is an ошибка while rolling back the changes.
	 *
	 *	ИсклДБИ if an ODBC statement couldn't be destroyed.
	 */
	override РезультатОДБЦ запрос (ткст эскюэл);

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
	 * Get a list of currently installed ODBC drivers.
	 *
	 * Returns:
	 *	A list of all the installed ODBC drivers.
	 */
	ткст[] дайДрайверы () ;

	/**
	 * Get a list of currently available ODBC data sources.
	 *
	 * Returns:
	 *	A list of all the installed ODBC data sources.
	 */
	ткст[] дайИсточникиДанных ();

	private:
	SQLHDBC подключение;
	SQLHSTMT инстр;

	/**
	 * Get the last ошибка message returned by the server.
	 *
	 * Returns:
	 *	The last ошибка message returned by the server.
	 */
	ткст дайСообПоследнОш ();

	/**
	 * Get the last ошибка code return by the server.  This is the native code.
	 *
	 * Returns:
	 *	The last ошибка message returned by the server.
	 */
	цел дайКодПоследнОш ();
}

unittest {
	version(Rulada) {
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

	s1("dbi.odbc.OdbcDatabase:");
	ОдбцБД бд = new ОдбцБД();
	s2("подключись (with DSN)");
	бд.подключись("DDBI Unittest", "test", "test");

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
	assert (ряд.дайТипПоля(0) == SQL_INTEGER);
	assert (ряд.дайТипПоля(1) == SQL_CHAR || ряд.дайТипПоля(1) == SQL_WCHAR);
	assert (ряд.дайТипПоля(2) == SQL_TYPE_DATE || ряд.дайТипПоля(2) == SQL_DATE);
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
	delete бд;
}