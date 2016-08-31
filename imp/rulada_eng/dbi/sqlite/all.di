/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.sqlite.all;

version (build) {
	pragma (ignore);
}

public import	dbi.sqlite.SqliteDatabase,
		dbi.sqlite.SqliteResult,
		dbi.all;
version (build) {
    debug {
        pragma(link, "dbi");
    } else {
        pragma(link, "dbi");
    }
}
