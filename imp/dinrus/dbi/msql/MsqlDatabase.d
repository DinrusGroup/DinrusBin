/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.msql.MsqlDatabase;

private import dbi.DataBase, dbi.DBIException, dbi.Result, dbi.Row, dbi.Statement;
private import dbi.msql.imp, dbi.msql.MsqlResult;

/**
 * An implementation of БазаДанных for use with mSQL databases.
 *
 * Bugs:
 *	БазаДанных-specific ошибка codes are not converted to КодОшибки.
 *
 * See_Also:
 *	БазаДанных is the interface that this provides an implementation of.
 */
class ЭмЭсКюЭлБД : БазаДанных {
	public:
	/**
	 * Create a new instance of ЭмЭсКюЭлБД, but don't подключись.
	 */
	this ();

	/**
	 * Create a new instance of ЭмЭсКюЭлБД and подключись to a server.
	 *
	 * See_Also:
	 *	подключись
	 */
	this (ткст парамы, ткст имя_пользователя = пусто, ткст пароль = пусто) ;

	/**
	 *
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
	 *	эскюэл = The SQL statement to выполни.
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
	 */
	override РезультатМЭсКюЭл запрос (ткст эскюэл) ;

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
	deprecated override ткст дайСообОшибки () ;

	

}