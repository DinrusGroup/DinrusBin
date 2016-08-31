/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.sqlite.SqliteError;

private import dbi.ErrorCode;
private import dbi.sqlite.imp;

/**
 * Convert a SQLite _error code to an КодОшибки.
 *
 * Params:
 *	ошибка = The SQLite _error code.
 *
 * Returns:
 *	The КодОшибки representing ошибка.
 *
 * Note:
 *	Written against the SQLite 3.3.6 documentation.
 */
package КодОшибки спецВОбщ (цел ошибка);