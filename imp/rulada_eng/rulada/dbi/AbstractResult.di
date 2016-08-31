module dbi.AbstractResult;

private import dbi.model.Result;

private import tango.util.log.Log;
private import tango.time.Time,
               tango.time.Clock;

abstract class AbstractResult : FullResult
{
private:
    Time _timestamp;
    Alloc _alloc;

protected:
    ColumnInfo[] _metadata;

    this()
    {
        _timestamp = Clock.now;
    }

public:

    alias FullResult.metadata metadata;

    Time timestamp() { return _timestamp; }

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

    Alloc allocator()
    {
        return _alloc;
    }

    void allocator(Alloc alloc)
    {
        _alloc = alloc;
    }

}

abstract class AbstractRows : Rows
{
private:
    FullResult _rows;

protected:

    Alloc _alloc;
    ColumnInfo[] _metadata;

    Logger log;

    Time _timestamp;

    this (FullResult results)
    {
        _rows = results;
        log = Log.lookup(this.classinfo.name);
        _timestamp = results.timestamp;
    }

public:

    ulong rowCount()
    {
        return _rows.rowCount;
    }

    ulong fieldCount()
    {
        return _rows.fieldCount;
    }

    Alloc allocator()
    {
        return _alloc;
    }

    void allocator(Alloc alloc)
    {
        _alloc = alloc;
    }

    Time timestamp() { return _timestamp; }

    override bool valid() 
    { 
        return (_rows.valid && _timestamp == _rows.timestamp); 
    }
}

version (build) {
    debug {
        pragma(link, "dbi");
    } else {
        pragma(link, "dbi");
    }
}
