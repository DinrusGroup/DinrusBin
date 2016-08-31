/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */
module dbi.Exception;

private import tango.core.Vararg : va_arg;
private import dbi.ErrorCode;

/**
 * This is the exception class used within all of D DBI.
 *
 * Some functions may also throw different types of exceptions when they access the
 * standard library, so be sure to also catch Exception in your code.
 */
class DBIException : Exception {
	/**
	 * Create a new DBIException.
	 */
	this () {
		this("Unknown Error.");
	}

	/**
	 * Create a new DBIException.
	 *
	 * Params:
	 *	msg = The message to report to the users.
	 *
	 * Throws:
	 *	DBIException on invalid arguments.
	 */
	this (char[] msg, long errorNum = 0, ErrorCode errorCode = ErrorCode.NoError, char[] sql = null) {
		super("DBIException: " ~ msg);
		dbiCode = errorCode;
		this.sql = sql;
		this.specificCode = errorNum;
	}

	/**
	 * Get the database's DBI error code.
	 *
	 * Returns:
	 *	Database's DBI error code.
	 */
	ErrorCode getErrorCode () {
		return dbiCode;
	}

	/**
	 * Get the database's numeric error code.
	 *
	 * Returns:
	 *	Database's numeric error code.
	 */
	long getSpecificCode () {
		return specificCode;
	}

	/**
	 * Get the SQL statement that caused the error.
	 *
	 * Returns:
	 *	SQL statement that caused the error.
	 */
	char[] getSql () {
		return sql;
	}

	private:
	char[] sql;
	long specificCode = 0;
	ErrorCode dbiCode = ErrorCode.Unknown;
}

version (build) {
    debug {
        pragma(link, "dbi");
    } else {
        pragma(link, "dbi");
    }
}
