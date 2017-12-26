/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.pg.PgDatabase;

version(Rulada) {
	private import stdrus : toDString = вТкст, toCString = вТкст0;
	debug (UnitTest) private static import std.io;
} else {
	private import stdrus : toDString = вТкст, toCString = вТкст0;
	debug (UnitTest) private static import io.Stdout;
}
private import dbi.DataBase, dbi.DBIException, dbi.Result, dbi.Row, dbi.Statement;
private import dbi.pg.imp, dbi.pg.PgError, dbi.pg.PgResult;

/**
 * An implementation of БазаДанных for use with PostgreSQL databases.
 *
 * See_Also:
 *	БазаДанных is the interface that this provides an implementation of.
 */
class ПгБД : БазаДанных {
	public:
	/**
	 * Create a new instance of ПгБД, but don't подключись.
	 */
	this ();

	/**
	 * Create a new instance of ПгБД and подключись to a server.
	 *
	 * See_Also:
	 *	подключись
	 */
	this (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто) ;

	/**
	 * Connect to a бд on a PostgreSQL server.
	 *
	 * Params:
	 *	парамы = A текст in the form "keyword1=value1;keyword2=value2;etc."
	 *	имя_пользователя = The _userимя to _подключись with.
	 *	пароль = The _password to _подключись with.
	 *
	 * Keywords:
	 *	host = The имя of the host or socket to _подключись to.
	 *
	 *	hostaddr = The IP address of the host to _подключись to.
	 *
	 *	порт = The порт number or socket extension to use.
	 *
	 *	dbимя = The имя of the бд to use.
	 *
	 *	пользователь = The _userимя to _подключись with.
	 *
	 *	_password = The _password to _подключись with.
	 *
	 *	подключись_timeout = The number of секунды to wait for a подключение.
	 *
	 *	options = Command-line options to be sent to the server.
	 *
	 *	tty = Ignored.
	 *
	 *	sslmode = What priority should be placed on using SSL.
	 *
	 *	requiressl = Deprecated.  Use sslmode instead.
	 *
	 *	krbsrvимя = Kerberos 5 service имя.
	 *
	 *	service = Service имя that specifies additional parameters.
	 *
	 * Thряды:
	 *	ИсклДБИ if there was an ошибка подключисьing.
	 *
	 * Examples:
	 *	---
	 *	ПгБД бд = new ПгБД();
	 *	бд.подключись("host=localhost;dbимя=test", "имя_пользователя", "пароль");
	 *	---
	 *
	 * See_Also::
	 *	http://www.postgresql.org/docs/8.2/static/libpq.html
	 */
	override проц подключись (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто) ;

	/**
	 * Close the current подключение to the бд.
	 */
	override проц закрой ();

	/* Escape a _string using the бд's native method, if possible.
	 *
	 * Params:
	 *	текст = The _string to искейп.
	 *
	 * Returns:
	 *	The escaped _string.
	 */
	override ткст искейп (ткст текст) ;

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
	override ПгРезультат запрос (ткст эскюэл) ;

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
	deprecated override цел дайКодОшибки ();

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
	deprecated override ткст дайСообОшибки ();

	private:
	PGconn* подключение;
	цел кодОш;
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

	s1("dbi.pg.PgDatabase:");
	ПгБД бд = new ПгБД();
	s2("подключись");
	бд.подключись("dbимя=test", "test", "test");

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
	assert (ряд.дайТипПоля(1) == 1042);
//	assert (ряд.дайОбъявлПоля(1) == "char(40)");
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