/**
 * Authors: The D DBI project
 *
 * Version: 0.2.5
 *
 * Copyright: BSD license
 */
module dbi.mssql.MssqlDate;

version(Rulada) {
	private import stdrus : toDString = вТкст, toCString = вТкст0;
} else {
	private import stdrus : toCString = вТкст0;
	private import stdrus : toDString = вТкст;
}
private import dbi.DBIException;
private import dbi.mssql.imp;

class MssqlDate {
	public:
	this () {
	}

	this (CS_DATETIME dt) ;

	this (CS_DATETIME4 dt4) ;

	ткст getString () ;
	
	private:
	CS_DATEREC dr;

	цел dt_days;
	бцел dt_time;

	цел years, months, days, ydays, wday, часы, mins, secs, ms;
	цел l, n, i, j;

	CS_DATEREC convert(CS_DATETIME dt) ;

	CS_DATEREC convert(CS_DATETIME4 dt4) ;

	CS_DATEREC convert2() ;
	
}