/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */

module dbi.mysql.MysqlDatabase;

private import dbi.model.Database,dbi.mysql.imp, dbi.mysql.c.mysql,
               dbi.model.Result,
               dbi.model.Constants;

private import dbi.Exception,
               dbi.AbstractDatabase,
               dbi.ValidityToken;

private import dbi.mysql.MysqlError,
               dbi.mysql.MysqlResult,
               dbi.mysql.MysqlStatement;

private import dbi.mysql.c.mysql;

private import tango.util.log.Log,
               tango.util.log.Config;
private import tango.core.Variant;
private import Integer = tango.text.convert.Integer;
private import tango.text.convert.Format;

private import tango.stdc.stringz;

class MysqlDatabase : AccessProtectedDatabase, MultiResultSupport
{

private:

    Logger log;
    static bool[DbiFeature] _supportedFeatures;
    bool[DbiFeature] _enabledFeatures;

    ValidityToken token;
    TokenHolder tokenholder;

    static this()
    {
        _supportedFeatures[DbiFeature.MultiStatements] = true;
        _supportedFeatures[DbiFeature.MultiResults] = true;
    }

package:
    MYSQL* connection = null;

public:

    this ()
    {
        log = Log.lookup(this.classinfo.toString);
        token = new ValidityToken();
        tokenholder = new TokenHolder(token);
        connection = mysql_init(null);
		if (connection is null)
			throw new DBIException("Failed to allocate a MYSQL connection");
    }

    this (char[] name, char[] user = null, 
          char[] password = null,
          char[][char[]] params = null,
          DbiFeature[] features = null)
    {
        this();
        connect(name, user, password, params, features);
    }

    ~this()
    {
        close;
    }   

    void connect (char[] name, 
                  char[][char[]] params = null, 
                  DbiFeature[] features = null)
    {
        connect(name, null, null, params, features);
    }
 
    void connect (char[] name, char[] user = null, 
                  char[] password = null,
                  char[][char[]] params = null, 
                  DbiFeature[] features = null)
    {
		scope (failure)
			connection = null;
        if (features !is null) {
            foreach (DbiFeature feature; features) {
                enable(feature);
            }
        }

        uint clientflag = 0;
		auto multiStatements = DbiFeature.MultiStatements in _enabledFeatures;
		auto multiResults = DbiFeature.MultiResults in _enabledFeatures;
        if (multiStatements && *multiStatements) {
            clientflag |= (1 << 16)/*CLIENT_MULTI_STATEMENTS*/;
        }
        else if (multiResults && *multiResults) {
            clientflag |= (1 << 17)/*CLIENT_MULTI_RESULTS*/;
        }
        
        char[] host = "localhost";
        char[] sock = null;
        uint port = 0;

		if ( connection is null )
			throw new DBIException ("This database connection has been closed.");

        if ("host" in params) 
			host = params["host"];
		if ("sock" in params) 
			sock = params["sock"];
		if ("port" in params)
            port = cast(uint)Integer.parse(params["port"]);

        // TODO: check docs - check for null?
        mysql_real_connect(connection, toStringz(host), toStringz(user), 
                           toStringz(password), toStringz(name), port, 
                           toStringz(sock), clientflag);
		check("Unable to connect to the MySQL database");
    }

    bool hasFeature(DbiFeature feature)
    {
        if (feature in _supportedFeatures)
            return _supportedFeatures[feature];

        return false;
    }

    bool enabled(DbiFeature feature)
    {
        if (feature in _enabledFeatures)
            return _enabledFeatures[feature];

        return false;
    }

    void enable(DbiFeature feature)
    {
         if ((feature in _supportedFeatures &&
             _supportedFeatures[feature])) {
                 _enabledFeatures[feature] = true;
         }
         else {
             throw new DBIException("Feature not supported: ", feature);
         }
    }

    void disable(DbiFeature feature)
    {
        _enabledFeatures[feature] = false;
    }

    void close()
    {		
        if (connection !is null) {
			mysql_close(connection);
			check("Unable to close the MySQL database");
			connection = null;
		}

        if (token !is null) {
            delete token;
            token = null;
        }
    }

    char[] escape(in char[] stmt, char[] dst = null)
    {
        if (dst is null) {
            dst = new char[2*stmt.length+1];
        }
        ulong r = mysql_real_escape_string(connection, dst.ptr, stmt.ptr, stmt.length);
        return dst[0..r];
    }

    void execute(in char[] sql)
    {
   		if (int error = mysql_real_query(connection, sql.ptr, sql.length)) {
			fail("Unable to execute a command on the MySQL database", sql);
		}
    }

    MysqlResult query(in char[] sql)
    {
        execute(sql);
        auto results = mysql_store_result(connection);

        if (results is null) {
			fail("Unable to query the MySQL database");
        }

        return new MysqlResult(results, connection, tokenholder);
    }

    MysqlStatement prepare(in char[] sql)
    {
        // TODO: prepared query syntax standardized? Will a dbms agnostic
        // frontend need to adjust it?
		auto stmt = mysql_stmt_init(connection);
		auto results = mysql_stmt_prepare(stmt, sql.ptr, sql.length);
		if(results != 0) {
			failStatement(stmt, "Unable to prepare statement", sql);
		}
		return new MysqlStatement(stmt, connection);
    }

    MysqlTables tables(in char[] filter = null)
    {
        auto results = mysql_list_tables(connection, toStringz(filter)); 
   	    if(!results) {
			fail("Table request returned null from MySQL");
		}
    
        return new MysqlTables(this, new MysqlResult(results, connection, 
                                                     tokenholder));
    }

    override bool hasTable(char[] name)
    {
   	    auto results = mysql_list_tables(connection, toStringz(name));
	    if(!results) {
			fail("Has Table request returned null from MySQL");
		}
		bool exists = mysql_num_rows(results) > 0;
		mysql_free_result(results);
		return exists;
    }

    override ulong lastInsertID()
    {
        return mysql_insert_id(connection);
    }

    override ulong affectedRows()
    {
        return mysql_affected_rows(connection);
    }

    override void beginTransact()
    {
   		const char[] sql = "START TRANSACTION;";
		mysql_real_query(connection, sql.ptr, sql.length);
    }

    override void rollback()
    {
   	    mysql_rollback(connection);
    }

    override void commit()
    {
        mysql_commit(connection);
    }

	private void check(char[] failureMessage, char[] sql = "")
	{
		auto errno = mysql_errno(connection);
		if (errno)
			fail(failureMessage, sql, errno);
	}

	private void fail(char[] failureMessage, char[] sql = "", uint errno = 0)
	{
		if (errno == 0) errno = mysql_errno(connection);
		auto error = mysql_error(connection);
		if (error)
			failureMessage ~= ": " ~ fromStringz(error);
		throw new DBIException(failureMessage, errno, specificToGeneral(errno), sql);
	}
}

private void failStatement(MYSQL_STMT* stmt, char[] failureMessage, char[] sql = "", uint errno = 0)
{
	if (errno == 0) errno = mysql_stmt_errno(stmt);
	auto error = mysql_stmt_error(stmt);
	if (error)
		failureMessage ~= ": " ~ fromStringz(error);
	throw new DBIException(failureMessage, errno, specificToGeneral(errno), sql);
}

class MysqlTables : Tables
{
private:

    MysqlRows _rows;
    MysqlDatabase _dbase;

public:

    this (MysqlDatabase dbase, MysqlResult results)
    {
        _rows = new MysqlRows(results);
        _dbase = dbase;
    }

    int opApply (int delegate(inout Table) dg)
    {
        if (!_rows.valid)
            throw new DBIException("The underlying result set is no longer valid");

        int  result;
        MysqlTable table = new MysqlTable(_dbase);
        foreach (Row tablerow; _rows) {    
            table.set(tablerow.stringAt(0));
            Table t = table;
            if ((result = dg(t)) != 0)
                 break;
        } 
        return result;
    }

    size_t tables() { return _rows.rowCount; }
}

class MysqlTable : AbstractTable
{
private:

    MysqlDatabase _dbase;

public:

    this(MysqlDatabase dbase) 
    {
        _dbase = dbase;
    }

    this(MysqlDatabase dbase, char[] name)
    {
        this(dbase);
        _name = name;
    }

    override ColumnInfo[] metadata()
    {
        char[96] fieldquerybuf;
        // TODO: look into using mysql_list_fields here
        auto fieldquery = Format.sprint(fieldquerybuf, "SELECT * FROM {} LIMIT 1;", name);
        fieldquerybuf[fieldquery.length] = 0;

        mysql_real_query(_dbase.connection, fieldquery.ptr, fieldquery.length);
        auto results = mysql_store_result(_dbase.connection);
        auto fields = mysql_fetch_fields(results);

        _metadata = new ColumnInfo[mysql_num_fields(results)];
        for (ulong i = 0; i < mysql_num_fields(results); i++) {
            fromMysqlField(_metadata[i], fields[i]);
        }

        mysql_free_result(results);

        return _metadata;
    }

    ColumnInfo metadata(size_t idx)
    in {
        if (_metadata !is null)
            assert (idx > 0 && idx < _metadata.length);
    }
    body {
        if (_metadata is null)
            metadata();
        return _metadata[idx];
    }

    ulong fieldCount() 
    { 
        if (_metadata is null)
            metadata();
        return _metadata.length;
    }

    ulong rowCount() { 
        return _rowCount; 
    }

    MysqlRows rows()
    {
        char[96] rowquerybuf;
        auto rowquery = Format.sprint(rowquerybuf, "SELECT * FROM {};", name);
        rowquerybuf[rowquery.length] = 0;

        mysql_real_query(_dbase.connection, rowquery.ptr, rowquery.length); 
        auto results = mysql_store_result(_dbase.connection);

        _rowCount = mysql_num_rows(results);
        if (results is null) {
            throw new DBIException("Unable to query the MySQL database for rows.");
        }

        return (new MysqlResult(results, _dbase.connection, _dbase.tokenholder)).rows;
    }

    char[] toString() { return name; }
}


version (build) {
    debug {
        pragma(link, "dbi");
    } else {
        pragma(link, "dbi");
    }
}
