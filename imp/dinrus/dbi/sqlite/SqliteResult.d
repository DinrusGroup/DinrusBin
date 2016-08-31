/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.sqlite.SqliteResult;

version(Rulada) {
	private import stdrus : asString = вТкст;
} else {
	private import stdrus : asString = вТкст;
}
private import dbi.Result, dbi.Row;
private import dbi.sqlite.imp;

/**
 * Manage a результат установи from a SQLite бд запрос.
 *
 * See_Also:
 *	Результат is the interface of which this provides an implementation.
 */
class РезультатЭскюлайт : Результат {
	public:
	this (sqlite3_stmt* инстр);

	/**
	 * Get the следщ ряд from a результат установи.
	 *
	 * Returns:
	 *	A Ряд object with the queried information or пусто for an empty установи.
	 */
	override Ряд получиРяд () ;

	/**
	 * Free all бд resources used by a результат установи.
	 */
	override проц финиш () ;

	private:
	sqlite3_stmt* инстр;
}