/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.mssql.MssqlResult;

import dbi.DBIException, dbi.Result, dbi.Row;
import dbi.mssql.imp, dbi.mssql.MssqlDate;

/**
 * Manage a результат установи from a MSSQL бд запрос.
 *
 * See_Also:
 *	Результат is the interface of which this provides an implementation.
 */
class MssqlResult : Результат
 {


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

	private:
	CS_COMMAND* cmd;
	CS_RETCODE restype;

	цел numРяды = -1;
	цел numFields = -1;

	CS_DATAFMT[] поля;
	ткст[] strings;
	CS_FLOAT[] floats;
	CS_INT[] ints;
	CS_DATETIME[] dts;
	CS_DATETIME4[] dt4s;
	цел[] lengths;
	крат[] inds;

	проц установиЧлоПолей() ;

	проц установиПоля() ;

}
