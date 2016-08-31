module dbi.mysql.MysqlStatement;

//version = MySQL_51;
version = dbi_mysql;

private import dbi.model.Statement,
               dbi.model.Result, dbi.mysql.MysqlError,
               dbi.model.Constants, lib.mysql, dbi.mysql.imp;

private import dbi.DBIException;

private import dbi.mysql.MysqlResult,
               dbi.mysql.MysqlError;

private import lib.mysql;

private import util.log.Log;
private import cidrus,
               stringz;
private import time.Time,
               time.Clock;

class ИнструкцияМайЭсКюЭл : Инструкция, Преддоб
{

private:
    MYSQL * подключение;
    MYSQL_STMT * инстр;
	MYSQL_BIND[] paramBind;
	BindingHelper paramHelper;
	MYSQL_BIND[] resBind;
    ИнфОСтолбце[] _метаданные;
	BindingHelper resHelper;
    Логгер лог;

    Размест _размест;

    бул преддобудьed = false;
    Время _штампврем;
	
package:
    
    this(MYSQL_STMT * инстр, MYSQL * подключение);

public:

    override бцел члоПарамов();

    override проц типыПарамов(ТипДби[] типыПарамов ...);

    override проц типыРезультата(ТипДби[] типыРез ...);

    override Размест разместитель();

    override проц разместитель(Размест размест);

    override проц выполни(ук[] вяжи ...);
	
    бул добудь(ук[] вяжи ...);
	
    override проц закрой();
	
	override проц сбрось();

    override бдол идПоследнейВставки();

    override проц преддобудь();

    override бдол члоРядов();

    override бдол члоПолей();

    override бдол задействованныеРяды();
	
	override ИнфОСтолбце[] метаданные();
	
    override ИнфОСтолбце метаданные(т_мера инд);

    override Время штампВремени() ;

    override бул действителен() ;

private:
 
    override проц exec();
	
	static struct BindingHelper
	{	
		проц установиДлину(т_мера l);
		
		my_bool[] ошибка;
		my_bool[] is_null;
		т_мера[] len;
		MYSQL_TIME[бцел] время;
		ббайт[][бцел] буфер;
		ТипДби[] types;
	}

    static проц иницПодвязку(ТипДби[] types, inout MYSQL_BIND[] вяжи, 
                             inout BindingHelper helper);
}
