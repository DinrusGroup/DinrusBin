/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.msql.MsqlResult;

private import dbi.DBIException, dbi.Result, dbi.Row;
private import dbi.msql.imp;

/**
 * Manage a результат установи from a mSQL бд запрос.
 *
 * See_Also:
 *	Результат is the interface of which this provides an implementation.
 */
class РезультатМЭсКюЭл : Результат {
	public:
	this () ;

	/**
	 * Get the следщ ряд from a результат установи.
	 *
	 * Returns:
	 *	A Ряд object with the queried information or пусто for an empty установи.
	 */
	override Ряд получиРяд ();

	/**
	 * Free all бд resources used by a результат установи.
	 */
	override проц финиш () ;

}