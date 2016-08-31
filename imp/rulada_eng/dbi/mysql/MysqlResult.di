/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */

module dbi.mysql.MysqlResult;

private import dbi.Exception;
private import dbi.model.Result,
               dbi.model.Constants;
private import dbi.AbstractResult,
               dbi.ValidityToken;

private import dbi.mysql.c.mysql, dbi.mysql.imp;

private import tango.core.Variant;
private import tango.util.log.Log;
private import tango.time.Time,
               tango.time.Clock;

debug private import tango.io.Stdout;

class MysqlResult : AbstractResult, MultiResult
{
private:
    MysqlRows _rows;
    MYSQL* _dbase = null;
    TokenHolder _token;

package:
    MYSQL_RES* result = null;

public:

    alias AbstractResult.metadata metadata;

    this(MYSQL* dbase, TokenHolder token)
    in{
        assert (dbase !is null);
        assert (token !is null);
    }
    body {
       super();
       _dbase = dbase; 
       _token = token;
       token.registerHook(&invalidate);
    }

    this(MYSQL_RES* res, MYSQL* dbase, TokenHolder token)
    in {
        assert (res !is null);
    }
    body {
        this (dbase, token);
        result = res;
        _rows = null;
    }

    ~this()
    {
        if (valid)
            close;
    }

    void set(MYSQL_RES* res)
    {
        if (result !is null)
            close;

        result = res;
    }

    MysqlRows rows()
    {
        if (_rows is null)
            _rows = new MysqlRows(this);

        return _rows;
    }

    ColumnInfo[] metadata()
    {
        auto fields = mysql_fetch_fields(result);

        _metadata = new ColumnInfo[fieldCount];
        for (ulong i = 0; i < fieldCount; i++) {
            fromMysqlField(_metadata[i], fields[i]);
        }

        return _metadata;
    }

    ulong rowCount() { return mysql_num_rows(result); }
    ulong fieldCount() { return mysql_num_fields(result); }

    void close()
    {
        if (result is null)
            throw new Exception ("This result set was already closed.");

        mysql_free_result(result);
        if (_dbase !is null) {
            while (mysql_more_results(_dbase)) {
                auto res = mysql_next_result(_dbase);
                assert(res <= 0);
                result = mysql_store_result(_dbase);
                mysql_free_result(result);
            }
        }
        result = null;
    }

    bool more()
    in {
        assert (result !is null);
    }
    body {
        if (result is null)
            throw new DBIException ("This result set was already closed.");

        return cast(bool)mysql_more_results(_dbase);
    }

    MysqlResult next()
    in {
        assert (result !is null);
    }
    body {
        if (result is null)
            throw new DBIException ("This result set was already closed.");

        mysql_free_result(result);
        auto res = mysql_next_result(_dbase);
        if (res <= 0) {
            result = mysql_store_result(_dbase);
            return this;
        }
        else {
            throw new DBIException("Failed to retrieve next result set.");
        }
    }

    bool valid() { return result !is null; }

private:

    void invalidate(Object o) {
        _dbase = null;    
        if (valid) close;
    }
}

class MysqlRows : AbstractRows
{
private:

    MysqlResult _rows;
    ColumnInfo[] _metadata;

public:

    this (MysqlResult results)
    {
        super (results);
        _rows = results;
    }

    ColumnInfo[] metadata()
    {
        auto fields = mysql_fetch_fields(_rows.result);

        _metadata = new ColumnInfo[_rows.fieldCount];
        for (ulong i = 0; i < _rows.fieldCount; i++) {
            fromMysqlField(_metadata[i], fields[i]);
        }

        return _metadata;
    }

    int opApply (int delegate(inout Row) dg)
    {
        assert (_rows !is null);
        int result;
        MysqlRow host = new MysqlRow; 
        MYSQL_ROW row;
        assert (_rows !is null && _rows.valid);
        debug Stdout("Rows are valid.").newline;
        while ((row = mysql_fetch_row(_rows.result)) !is null) {
            host.set(row, mysql_fetch_lengths(_rows.result));
            Row r = host;
            if ((result = dg(r)) != 0)
                break;
        }
        return result;
    }

    MysqlRow next()
    {
        // TODO reuse
        return new MysqlRow(_rows);
    }

    bool fetch(Alloc alloc, void* ...)
    {
        // TODO
        return false;
    }

    MysqlRow opIndex(ulong idx)
    {
        // TODO
        return null;
    }

    void seek(ulong offset)
    {
        mysql_data_seek(_rows.result, offset);
    }
}

class MysqlRow : Row
{
private:
    MysqlResult _results = null;
    MYSQL_ROW _row;
    size_t* _lengths = null;
    private Logger log;

private:

    void initRow() {
        _row = mysql_fetch_row(_results.result);
        _lengths = mysql_fetch_lengths(_results.result);
    }


public:

    this () 
    {
        log = Log.getLogger(this.classinfo.toString);
    }

    this (MysqlResult results)
    in {
        assert (results !is null);
    }
    body {
        _results = results;
        initRow;
    }

    this (MYSQL_ROW row, size_t* lengths)
    {
        _row = row;
        _lengths = lengths;
    }


    MysqlRow set(MYSQL_ROW row, size_t* lengths)
    {
        _row = row;
        _lengths = lengths;
        return this;
    }

    MysqlRow set(MysqlResult results) {
        _results = results;
        initRow; 
        
        return this;
    }

    ColumnInfo[] metadata()
    {
        return _results.metadata();
    }

    ColumnInfo metadata(size_t idx)
    {
        return _results.metadata(idx);
    }

    ulong fieldCount()
    {
        return _results.fieldCount;
    }

    char[] stringAt(size_t idx)
    {
        return _row[idx][0 .. _lengths[idx]];
    }

    char[] stringAt(char[] name)
    {
        foreach (i, column; metadata) 
            if (name is column.name)
                return _row[i][0 .. _lengths[i]];

        return null;
    }

    void fetch(inout char[][] values)
    in {
        assert (values.length >= fieldCount);
    }
    body {
        for (int i = 0; i < fieldCount; i++) {
            values[i] = _row[i][0 .. _lengths[i]];
        }
    }

    void fetch(inout char[] value, size_t idx = 0)
    in {
        assert(idx < fieldCount);
    }
    body {
        value = _row[idx][0 .. _lengths[idx]];
    }
}

package:

DbiType fromMysqlType(enum_field_types type)
{
    with (enum_field_types) {
        switch (type) {
            case MYSQL_TYPE_DECIMAL:
                return DbiType.Decimal;
            case MYSQL_TYPE_TINY:
                return DbiType.Byte;
            case MYSQL_TYPE_SHORT:
                return DbiType.Short;
            case MYSQL_TYPE_LONG:
            case MYSQL_TYPE_ENUM:
                return DbiType.Int;
            case MYSQL_TYPE_FLOAT:
                return DbiType.Float;
            case MYSQL_TYPE_DOUBLE:
                return DbiType.Double;
            case MYSQL_TYPE_NULL:
                return DbiType.Null;
            case MYSQL_TYPE_TIMESTAMP:
                 return DbiType.DateTime;
            case MYSQL_TYPE_LONGLONG:
                return DbiType.Long;
            case MYSQL_TYPE_INT24:
                 return DbiType.Int;
            case MYSQL_TYPE_DATE:
            case MYSQL_TYPE_TIME:
            case MYSQL_TYPE_DATETIME:
            case MYSQL_TYPE_YEAR:
            case MYSQL_TYPE_NEWDATE:
                return DbiType.DateTime;
            case MYSQL_TYPE_BIT:
                assert(false);
            case MYSQL_TYPE_NEWDECIMAL:
                return DbiType.Decimal;
            case MYSQL_TYPE_SET:
                assert(false);
            case MYSQL_TYPE_TINY_BLOB:
            case MYSQL_TYPE_MEDIUM_BLOB:
            case MYSQL_TYPE_LONG_BLOB:
            case MYSQL_TYPE_BLOB:
                return DbiType.Binary;
            case MYSQL_TYPE_VARCHAR:
            case MYSQL_TYPE_VAR_STRING:
            case MYSQL_TYPE_STRING:
                return DbiType.String;
            case MYSQL_TYPE_GEOMETRY:
                assert(false);
            default:
                return DbiType.None;
        }
    }
}

void fromMysqlField(inout ColumnInfo column, MYSQL_FIELD field)
{
    column.name = field.name[0..field.name_length];
    column.name.length = field.name_length;
    column.type = fromMysqlType(field.type);
    column.flags = field.flags;
}

version (build) {
    debug {
        pragma(link, "dbi");
    } else {
        pragma(link, "dbi");
    }
}
