/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */

module dbi.model.Statement;

private import dbi.model.Result,
               dbi.model.Constants;

// TODO : Consider if Statement should stop inheriting Result, the original
// reasoning being that the concepts are difficult to split in for instance
// Mysql.
interface Statement : Result
{
    void paramTypes(DbiType[] paramTypes ...);
    void resultTypes(DbiType[] resTypes ...);

    // TODO : proper variadics here
    void execute(void*[] bind ...);

    bool fetch(void*[] bind ...);

    ulong affectedRows();
    uint paramCount();
    ulong lastInsertID();

    void reset();
    void close();
}

interface Prefetchable
{
    void prefetch();
    ulong rowCount();
}

version (build) {
    debug {
        pragma(link, "dbi");
    } else {
        pragma(link, "dbi");
    }
}
