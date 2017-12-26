/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.odbc.OdbcResult;

// Almost every cast involving chars and SQLCHARs shouldn't exist, but involve bugs in
// WindowsAPI revision 144.  I'll see about fixing their ODBC and SQL files soon.
// WindowsAPI should also include odbc32.lib itself.

version(Dinrus) {
	private import stdrus : убери;
} else {
	private import text.Util : убери;
}
private import dbi.DBIException, dbi.Result, dbi.Row;
private import win32.odbcinst, win32.sql, win32.sqlext, win32.sqltypes, win32.sqlucode, win32.windef;



/*
 * This is in the эскюэл headers, but wasn't ported in WindowsAPI revision 144.
 */
private бул SQL_SUCCEEDED (SQLRETURN ret);

/**
 * Manage a результат установи from an ODBC interface запрос.
 *
 * See_Also:
 *	Результат is the interface of which this provides an implementation.
 */
class РезультатОДБЦ : Результат {
	public:

	this (SQLHSTMT инстр);

	/**
	 * Get the следщ ряд from a результат установи.
	 *
	 * Returns:
	 *	A Ряд object with the queried information or пусто for an empty установи.
	 */

	override Ряд получиРяд () ;

	/**
	 * Free all бд resources used by a результат установи.
	 *
	 * Thряды:
	 *	ИсклДБИ if an ODBC statement couldn't be destroyed.
	 */

	override проц финиш () ;

	private:
	SQLHSTMT инстр;
	SQLSMALLINT numColumns;
	цел[] columnTypesNum;
	ткст[] columnTypesName;
	ткст[] columnNames;
	char[512][] columnData;

	/**
	 * Get the last ошибка message returned by the server.
	 */
	ткст дайСообПоследнОш ();

	/**
	 * Get the last ошибка code return by the server.  This is the native code.
	 */
	цел дайКодПоследнОш ();
}
