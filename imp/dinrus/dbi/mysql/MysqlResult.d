/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */

module dbi.mysql.MysqlResult;

private import dbi.DBIException;
private import dbi.model.Result,
               dbi.model.Constants;
private import dbi.AbstractResult,
               dbi.ValidityToken;

private import lib.mysql, dbi.mysql.imp;

private import core.Variant;
private import util.log.Log;
private import time.Time,
               time.Clock;

debug private import io.Stdout;

class РезультатМайЭсКюЭл : АбстрактныйРезультат, МультиРезультат
{
private:
    РядыМайЭсКюЭл _ряды;
    MYSQL* _дбаза = пусто;
    ТокеноДерж _token;

package:
    MYSQL_RES* результат = пусто;

public:

    alias АбстрактныйРезультат.метаданные метаданные;

    this(MYSQL* дбаза, ТокеноДерж токен);
	
    this(MYSQL_RES* рез, MYSQL* дбаза, ТокеноДерж токен);
	
    ~this();

    проц установи(MYSQL_RES* рез);

    РядыМайЭсКюЭл ряды();

    ИнфОСтолбце[] метаданные();

    бдол члоРядов() ;
    бдол члоПолей();

    проц закрой();
	
    бул ещё();
	
    РезультатМайЭсКюЭл следщ();
	
    бул действителен() ;

private:

    проц инвалидируй(Объект o);
}

class РядыМайЭсКюЭл : АбстрактныеРяды
{
private:

    РезультатМайЭсКюЭл _ряды;
    ИнфОСтолбце[] _метаданные;

public:

    this (РезультатМайЭсКюЭл результаты);
	
    ИнфОСтолбце[] метаданные();

    цел opApply (цел delegate(inout Ряд) дг);

    РядМайЭсКюЭл следщ();

    бул добудь(Размест размест, ук ...);

    РядМайЭсКюЭл opIndex(бдол инд);

    проц сместись(бдол offустанови);
}

class РядМайЭсКюЭл : Ряд
{
private:
    РезультатМайЭсКюЭл _results = пусто;
    MYSQL_ROW _row;
    т_мера* _lengths = пусто;
    private Логгер лог;

private:

    проц initRow() ;


public:

    this () ;

    this (РезультатМайЭсКюЭл результаты);

    this (MYSQL_ROW ряд, т_мера* lengths);


    РядМайЭсКюЭл установи(MYSQL_ROW ряд, т_мера* lengths);

    РядМайЭсКюЭл установи(РезультатМайЭсКюЭл результаты) ;

    ИнфОСтолбце[] метаданные();

    ИнфОСтолбце метаданные(т_мера инд);

    бдол члоПолей();

    ткст текстПо(т_мера инд);

    ткст текстПо(ткст имя);

    проц добудь(inout ткст[] значения);

    проц добудь(inout ткст значение, т_мера инд = 0);
}

package:

ТипДби изТипаМайЭсКюЭл(enum_field_types тип);

проц изПоляМайЭсКюЭл(inout ИнфОСтолбце column, MYSQL_FIELD field);
