/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.DBIException;

private import dinrus: ва_арг;
private import dbi.ErrorCode;

/**
 * This is the exception class used within all of D DBI.
 *
 * Some functions may also throw different types of exceptions when they access the
 * standard library, so be sure to also catch Exception in your code.
 */
class ИсклДБИ : Искл {
	/**
	 * Create a new ИсклДБИ.
	 */
	this ();

	/**
	 * Create a new ИсклДБИ.
	 *
	 * Params:
	 *	сооб = The message to report to the users.
	 *
	 * Thряды:
	 *	ИсклДБИ on invalid arguments.
	 */
	this (ткст сооб, дол номОш = 0, КодОшибки кодОш = КодОшибки.ОшибкиНет, ткст эскюэл = пусто);

	/**
	 * Get the бд's DBI ошибка code.
	 *
	 * Returns:
	 *	БазаДанных's DBI ошибка code.
	 */
	КодОшибки дайКодОшибки ();

	/**
	 * Get the бд's numeric ошибка code.
	 *
	 * Returns:
	 *	БазаДанных's numeric ошибка code.
	 */
	дол дайСпецКод () ;

	/**
	 * Get the SQL statement that caused the ошибка.
	 *
	 * Returns:
	 *	SQL statement that caused the ошибка.
	 */
	ткст дайЭсКюЭл ();

	private:
	ткст эскюэл;
	дол спецКод = 0;
	КодОшибки кодДби = КодОшибки.Неизвестен;
}