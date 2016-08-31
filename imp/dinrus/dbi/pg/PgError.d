/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.pg.PgError;

private import dbi.ErrorCode;

/**
 * Convert a PostgreSQL _error code to an КодОшибки.
 *
 * Params:
 *	ошибка = The PostgreSQL _error code.
 *
 * Returns:
 *	The КодОшибки representing ошибка.
 *
 * Note:
 *	Written against the PostgreSQL 8.1.4 documentation.
 */
package КодОшибки спецВОбщ (char* ошибка);