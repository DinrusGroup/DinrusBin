/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.pg.PgResult;

version (Rulada) {
	private import stdrus : убери = strip, toDString = вТкст;
} else {
	private import stdrus : toDString = вТкст;
	private import text.Util : убери;
}
private import dbi.DBIException, dbi.Result, dbi.Row;
private import dbi.pg.imp, dbi.pg.PgError;

/**
 * Manage a результат установи from a PostgreSQL бд запрос.
 *
 * See_Also:
 *	Результат is the interface of which this provides an implementation.
 */
class ПгРезультат : Результат {
	public:
	this (PGconn* conn, PGresult* результаты) ;

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
	PGresult* результаты;
	цел индекс;
	const цел numРяды;
	const цел numFields;
}