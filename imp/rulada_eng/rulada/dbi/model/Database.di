/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */

module dbi.model.Database;

private import dbi.model.Result,
               dbi.model.Statement,
               dbi.model.Constants;

/**
  * The Database interface is the main database abstraction in D DBI.
  * An instance of an implementation can represent a connection to a
  * specific database in a specific DBMS, or can be a further abstraction
  * aka factory.
  *
  * Note that many DBMS' are likely to implement additional interfaces
  * and/or sub-interfaces of Database for additional feature support.
  */

interface Database 
{
    void connect(char[] name,
                 char[][char[]] params = null,
                 DbiFeature[] features = null);

    /**
      * Returns true if this Database implementation supports
      * the given feature.
      */
    bool hasFeature(DbiFeature feature);
    /**
      * Returns true if the given feature has been enabled in
      * this Database instance.
      */
    bool enabled(DbiFeature feature);
    /**
      * Enables the given feature in the database instance.
      * 
      * Note that features typically will need to be enabled
      * prior to connection, thus pasing the features in the
      * constructor or connect method may be a better alternative.
      *
      * Throws:
      *     DbiException if the given feature isn't supported.
      */
    void enable(DbiFeature feature);
    /**
      * Disables the given feature in the database instance.
      *
      * For features that are enabled in the DBMS at connection,
      * this call will only have effect prior to calling connect.
      */
    void disable(DbiFeature feature);

    void close();

    void execute(in char[] sql);

    Result query(in char[] sql);

    Statement prepare(in char[] sql);

    char[] escape(in char[] query, char[] dst = null);

    /**
      * Returns a foreachable instance of tables  in the database,
      * with names filtered by the filter parameter.
      * 
      * If no filter, or null, is passed - all tables are returned.
      */
    Tables tables(char[] filter = null);

    bool hasTable(char[] name);
    ulong lastInsertID();
    ulong affectedRows();

    void beginTransact();
    void rollback();
    void commit();
}

interface AccessProtectedDatabase : Database
{
    void connect(char [] name, char[] user = null, 
                 char[] password = null,
                 char[][char[]] params = null,
                 DbiFeature[] features = null);

}

interface MultiResultSupport 
{
    MultiResult query(char[] sql);
}

interface Table : ColumnMetadata
{
    char [] name();
    Rows rows();
}

interface Tables  
{
    int opApply (int delegate(inout Table) dg);
    size_t tables();
}

version (build) {
    debug {
        pragma(link, "dbi");
    } else {
        pragma(link, "dbi");
    }
}
