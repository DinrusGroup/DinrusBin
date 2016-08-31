/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */

module dbi.mysql.MysqlStatement;

//version = MySQL_51;
version = dbi_mysql;

private import dbi.model.Statement,
               dbi.model.Result, dbi.mysql.MysqlError,
               dbi.model.Constants, dbi.mysql.c.mysql, dbi.mysql.imp;

private import dbi.Exception;

private import dbi.mysql.MysqlResult,
               dbi.mysql.MysqlError;

private import dbi.mysql.c.mysql;

private import tango.util.log.Log;
private import tango.stdc.string,
               tango.stdc.stringz;
private import tango.time.Time,
               tango.time.Clock;

class MysqlStatement : Statement, Prefetchable
{

private:
    MYSQL * connection;
    MYSQL_STMT * stmt;
	MYSQL_BIND[] paramBind;
	BindingHelper paramHelper;
	MYSQL_BIND[] resBind;
    ColumnInfo[] _metadata;
	BindingHelper resHelper;
    Logger log;

    Alloc _alloc;

    bool prefetched = false;
    Time _timestamp;
	
package:
    
    this(MYSQL_STMT * stmt, MYSQL * connection)
	{
		this.stmt = stmt;
        this.connection = connection;
        _timestamp = Clock.now;
        log = Log.lookup(this.classinfo.toString);
	}

public:

    override uint paramCount()
    {
        return mysql_stmt_param_count(stmt);
    }

    override void paramTypes(DbiType[] paramTypes ...)
    {
	    initBindings(paramTypes, paramBind, paramHelper);
    }

    override void resultTypes(DbiType[] resTypes ...)
    {
        initBindings(resTypes, resBind, resHelper);
    }

    override Alloc allocator()
    {
        return _alloc;
    }

    override void allocator(Alloc alloc)
    {
        _alloc = alloc;
    }

    override void execute(void*[] bind ...)
    {
        if (bind.length == 0)
            return exec();

		if(!bind || !paramBind) throw new DBIException("Attempting to execute a statement without having set parameters types or passed a valid bind array.");
		if(bind.length != paramBind.length) throw new DBIException("Incorrect number of pointers in bind array");
		
		auto len = bind.length;
		for(size_t i = 0; i < len; ++i)
		{
			switch(paramHelper.types[i])
			{
			case(DbiType.String):
			case(DbiType.Binary):
				ubyte[]* arr = cast(ubyte[]*)(bind[i]);
				paramBind[i].buffer = (*arr).ptr;
				auto l = (*arr).length;
				paramBind[i].buffer_length = l;
				paramHelper.len[i] = l;
				break;
			case(DbiType.Time):
				auto time = *cast(Time*)(bind[i]);
				auto dateTime = Clock.toDate(time); 
				paramHelper.time[i].year = dateTime.date.year;
				paramHelper.time[i].month = dateTime.date.month;
				paramHelper.time[i].day = dateTime.date.day;
				paramHelper.time[i].hour = dateTime.time.hours;
				paramHelper.time[i].minute = dateTime.time.minutes;
				paramHelper.time[i].second = dateTime.time.seconds;
				break;
			case(DbiType.DateTime):
				auto dateTime = *cast(DateTime*)(bind[i]);
				paramHelper.time[i].year = dateTime.date.year;
				paramHelper.time[i].month = dateTime.date.month;
				paramHelper.time[i].day = dateTime.date.day;
				paramHelper.time[i].hour = dateTime.time.hours;
				paramHelper.time[i].minute = dateTime.time.minutes;
				paramHelper.time[i].second = dateTime.time.seconds;
				break;
			default:
				paramBind[i].buffer = bind[i];
				break;
			}
		}
		
		auto res = mysql_stmt_bind_param(stmt, paramBind.ptr);
		if(res != 0) {
			throw new DBIException("Error binding parameters for execution of statement", res, dbi.mysql.MysqlError.specificToGeneral(res));
		}
        exec;
    }

    bool fetch(void*[] bind ...)
    {
		if(!bind || !resBind) throw new DBIException("Attempting to fetch from a statement without having set parameters types or passed a valid bind array.");
		if(bind.length != resBind.length) throw new DBIException("Incorrect number of pointers in bind array");
		
		auto len = bind.length;
		for(size_t i = 0; i < len; ++i)
		{
			with(enum_field_types)
			{
			switch(resBind[i].buffer_type)
			{
			case(MYSQL_TYPE_STRING):
			case(MYSQL_TYPE_BLOB):
				ubyte[]* arr = cast(ubyte[]*)(bind[i]);
				resHelper.buffer[i] = *arr;
				resBind[i].buffer_length = arr.length;
				resHelper.len[i] = 0;
				resBind[i].buffer = arr.ptr;
				break;
			case(MYSQL_TYPE_DATETIME):
				break;
			default:
				resBind[i].buffer = bind[i];
				break;
			}
			}
		}
		
		my_bool bindres = mysql_stmt_bind_result(stmt, resBind.ptr);
		if(bindres != 0) {
			debug {
				log.error("Unable to bind result params");
                log.error(fromStringz(mysql_error(connection)));
			}
			return false;
		}
		int res = mysql_stmt_fetch(stmt);
		if(res == 1) {
			debug(Log) {
                // TODO : fix
				log.error("Error fetching result data");
                log.error(fromStringz(mysql_error(connection)));
			}
			return false;
		}
		if(res == 100 /*MYSQL_NO_DATA*/) {
			reset;
			return false;
		}
		
		foreach(i, mysqlTime; resHelper.time)
		{
			if(resHelper.types[i] == DbiType.Time) {
				Time* time = cast(Time*)(bind[i]);
				DateTime dt;
				dt.date.year = mysqlTime.year;
				dt.date.month = mysqlTime.month;
				dt.date.day = mysqlTime.day;
				dt.time.hours = mysqlTime.hour;
				dt.time.minutes = mysqlTime.minute;
				dt.time.seconds = mysqlTime.second;
				*time = Clock.fromDate(dt);
			}
			else if(resHelper.types[i] == DbiType.DateTime) {
				DateTime* dt = cast(DateTime*)(bind[i]);
				(*dt).date.year = mysqlTime.year;
				(*dt).date.month = mysqlTime.month;
				(*dt).date.day = mysqlTime.day;
				(*dt).time.hours = mysqlTime.hour;
				(*dt).time.minutes = mysqlTime.minute;
				(*dt).time.seconds = mysqlTime.second;
			}
		}
		
		if(res == 0) {
			foreach(i, buf; resHelper.buffer)
			{
				ubyte[]* arr = cast(ubyte[]*)(bind[i]);
				auto l = resHelper.len[i];
				*arr = buf[0 .. l];
			}
			return true;
		}
		else if(res == 101/*MYSQL_DATA_TRUNCATED*/)
		{
			foreach(i, buf; resHelper.buffer)
			{
				ubyte[]* arr = cast(ubyte[]*)(bind[i]);
				auto l = resHelper.len[i];
				
				if(resBind[i].error) {
					if(_alloc) {
						ubyte* ptr = cast(ubyte*)_alloc(l);
						buf = ptr[0 .. l];
					}
					else {
						buf = new ubyte[l];
					}
					resBind[i].buffer_length = l;
					resBind[i].buffer = buf.ptr;
					if(mysql_stmt_fetch_column(stmt, &resBind[i], i, 0) != 0) {
						debug(Log) {
							log.error("Error fetching String of Binary that failed due to truncation");
							logError;
						}
						return false;
					}
				}
				*arr = buf[0 .. l];
			}
			return true;
		}
		else if(res == 100/*MYSQL_NO_DATA*/) return false;
		else return false;

    }

    override void close()
    {
        if (stmt !is null) {
	        mysql_stmt_close(stmt);
	        stmt = null;
	    }
    }
	
	override void reset()
	{
		mysql_stmt_free_result(stmt);
	}

    override ulong lastInsertID()
	{
		return mysql_stmt_insert_id(stmt);
	}

    override void prefetch()
    {
        prefetched = true;
        mysql_stmt_store_result(stmt);
    }

    /**
      * Returns the number of rows available in the result from this statement.
      * However, this value is not available unless prefetch was called. If it
      * wasn't, the count is set to 0.
      *
      * Returns:
      *     The number of rows in the result if prefetched, 0 otherwise.
      */
    override ulong rowCount()
    {
        if (prefetched)
            return mysql_stmt_num_rows(stmt);
        else
            return 0;
    }

    override ulong fieldCount()
    {
        return mysql_stmt_field_count(stmt);
    }

    override ulong affectedRows()
    {
        return mysql_stmt_affected_rows(stmt);
    }

	override ColumnInfo[] metadata()
    {
		MYSQL_RES* res = mysql_stmt_result_metadata(stmt);
		if(!res) return null;
		size_t numfields = mysql_num_fields(res);
		if(!numfields) return null;
		
		MYSQL_FIELD* fields = mysql_fetch_fields(res);
		
		_metadata.length = numfields;
		
		for(uint i = 0; i < numfields; i++)
		{
			_metadata[i].name = fields[i].name[0 .. fields[i].name_length].dup;
			_metadata[i].type = fromMysqlType(fields[i].type);
		}
		mysql_free_result(res);
		return _metadata;
    }

    override ColumnInfo metadata(size_t idx)
    {
        if (_metadata is null)
            metadata;

        return _metadata[idx];
    }

    override Time timestamp() { return _timestamp; }

    override bool valid() { return stmt !is null; }

private:
 
    override void exec()
    {
        auto res = mysql_stmt_execute(stmt);

		if(res) {
			throw new DBIException("Error executing statement", res, specificToGeneral(res));
		}
    }
   	
	static struct BindingHelper
	{	
		void setLength(size_t l)
		{
			error.length = l;
			is_null.length = l;
			len.length = l;
			time = null;
			buffer = null;
			foreach(ref n; is_null)
			{
				n = false;
			}
			
			foreach(ref e; error)
			{
				e = false;
			}
			
			foreach(ref i; len)
			{
				i = 0;
			}
		}
		my_bool[] error;
		my_bool[] is_null;
		size_t[] len;
		MYSQL_TIME[uint] time;
		ubyte[][uint] buffer;
		DbiType[] types;
	}

    static void initBindings(DbiType[] types, inout MYSQL_BIND[] bind, 
                             inout BindingHelper helper)
	{
		size_t l = types.length;
		bind.length = l;
		foreach(ref b; bind)
		{
			memset(&b, 0, MYSQL_BIND.sizeof);
		}
		helper.setLength(l);
		for(size_t i = 0; i < l; ++i)
		{
			switch(types[i])
			{
			case(DbiType.Bool):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_TINY;
				bind[i].is_unsigned = false;
				break;
			case(DbiType.Byte):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_TINY;
				bind[i].is_unsigned = false;
				break;
			case(DbiType.Short):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_SHORT;
				bind[i].is_unsigned = false;
				break;
			case(DbiType.Int):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_LONG;
				bind[i].buffer_length = 4;
				bind[i].is_unsigned = false;
				break;
			case(DbiType.Long):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_LONGLONG;
				bind[i].buffer_length = 8;
				bind[i].is_unsigned = false;
				break;
			case(DbiType.UByte):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_TINY;
				bind[i].is_unsigned = true;
				break;
			case(DbiType.UShort):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_SHORT;
				bind[i].is_unsigned = true;
				break;
			case(DbiType.UInt):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_LONG;
				bind[i].buffer_length = 4;
				bind[i].is_unsigned = true;
				break;
			case(DbiType.ULong):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_LONGLONG;
				bind[i].buffer_length = 8;
				bind[i].is_unsigned = true;
				break;
			case(DbiType.Float):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_FLOAT;
				bind[i].is_unsigned = false;
				break;
			case(DbiType.Double):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_DOUBLE;
				bind[i].is_unsigned = false;
				break;
			case(DbiType.String):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_STRING;
				bind[i].is_unsigned = false;
				break;
			case(DbiType.Binary):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_BLOB;
				bind[i].is_unsigned = false;
				break;
			case(DbiType.Time):
				helper.time[i] = MYSQL_TIME();
				bind[i].buffer = &helper.time[i];
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_DATETIME;
				bind[i].is_unsigned = false;
				break;
			case(DbiType.DateTime):
				helper.time[i] = MYSQL_TIME();
				bind[i].buffer = &helper.time[i];
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_DATETIME;
				bind[i].is_unsigned = false;
				break;
			case(DbiType.Null):
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_NULL;
				break;
			default:
				assert(false, "Unhandled bind type"); //TODO more detailed information;
				bind[i].buffer_type = enum_field_types.MYSQL_TYPE_NULL;
				break;
			}
			
			bind[i].length = &helper.len[i];
			bind[i].error = &helper.error[i];
			bind[i].is_null = &helper.is_null[i];
		}
		
		helper.types = types;
	}

}

version (build) {
    debug {
        pragma(link, "dbi");
    } else {
        pragma(link, "dbi");
    }
}
