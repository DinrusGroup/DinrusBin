/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */

module dbi.model.Result;

private import dbi.model.Constants;


private import tango.core.Variant;
private import tango.time.Time;


public alias void* delegate(size_t) Alloc;

interface Result : ColumnMetadata
{
    Alloc allocator();
    void allocator(Alloc alloc);

    ulong fieldCount();

    void close();

    Time timestamp();
    bool valid();
}

interface FullResult : Result
{
    Rows rows();
    ulong rowCount();
}

interface MultiResult : FullResult
{
    bool more();
    MultiResult next();
}

interface Rows {

    int opApply (int delegate(inout Row) dg);

    Alloc allocator();
    void allocator(Alloc alloc);

    Row next();

    bool fetch(Alloc alloc, void* ...);

    /*
    Variant[] fetch ();
    bool fetch (inout Variant[] v);
    */

    void seek(ulong offset);
    Row opIndex(ulong idx);

    ulong rowCount();
    ulong fieldCount();

    bool valid();
}

interface Row : ColumnMetadata
{
    /*
    Variant opIndex(size_t idx);
    Variant opIndex(char[] name);

    Variant[] fetch ();
    bool fetch (inout Variant[] v);
    */

    void fetch (inout char[][] values);
    void fetch (inout char[], size_t idx = 0);

    /*
    void fetch (inout byte, size_t idx = 0);
    void fetch (inout ubyte, size_t idx = 0);
    void fetch (inout short, size_t idx = 0);
    void fetch (inout ushort, size_t idx = 0);

    void fetch (inout int, size_t idx = 0);
    void fetch (inout uint, size_t idx = 0);
    void fetch (inout long, size_t idx = 0);
    void fetch (inout ulong, size_t idx = 0);

    void fetch (inout float, size_t idx = 0);
    void fetch (inout double, size_t idx = 0);
    void fetch (inout real, size_t idx = 0);
    */

    char[] stringAt(size_t idx);
    char[] stringAt(char[] name);

    ulong fieldCount();
}

interface ColumnMetadata
{
    ColumnInfo[] metadata();
    ColumnInfo metadata(size_t idx);
}

enum ColumnFlag : ulong
{
    NotNull = 1,
    PrimaryKey = 2,
    UniqueKey = 4,
    MultipleKey = 8,
    Blob = 16,
    Unsigned = 32,
    ZeroFill = 64,
    Binary = 128
}

struct ColumnInfo 
{
    DbiType type;
    char[] name;
    ulong flags;

    bool notNull() { return cast(bool)(flags & ColumnFlag.NotNull); }
    bool primaryKey() { return cast(bool)(flags & ColumnFlag.PrimaryKey); }
    bool uniqueKey() { return cast(bool)(flags & ColumnFlag.UniqueKey); }
    bool multipleKey() { return cast(bool)(flags & ColumnFlag.MultipleKey); }
    bool blob() { return cast(bool)(flags & ColumnFlag.Blob); }
    bool unsigned() { return cast(bool)(flags & ColumnFlag.Unsigned); }
    bool binary() { return cast(bool)(flags & ColumnFlag.Binary); }
    bool zeroFill() { return cast(bool)(flags & ColumnFlag.ZeroFill); }
}


version (build) {
    debug {
        pragma(link, "dbi");
    } else {
        pragma(link, "dbi");
    }
}
