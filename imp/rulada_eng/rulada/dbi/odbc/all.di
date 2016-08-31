/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.odbc.all;

version (build) {
	pragma (ignore);
}

public import	dbi.odbc.OdbcDatabase,
		dbi.odbc.OdbcResult,
		dbi.all;
version (build) {
    debug {
        pragma(link, "dbi");
    } else {
        pragma(link, "dbi");
    }
}
