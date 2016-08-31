module dbi.connect;

enum ПТипБД
{
Sqlite,
ODBC,
MySQL,
Pg,
MSQL,
MSSQL
}

class ПодключениеКБазеДанных
{

public:

	this (ПТипБД тип);	
	проц подключи(ткст имяБазы, ткст имя_пользователя = пусто, ткст пароль = пусто);

}