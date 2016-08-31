module dbi.AbstractDatabase;

private import dbi.model.Database,
               dbi.model.Result;

class AbstractTable : Table
{

protected:    

    char[] _name = null;
    ulong _rowCount;
    ColumnInfo[] _metadata = null;

public:

    abstract ColumnInfo[] metadata();

    void set(char[] name)
    in {
        assert (name !is null);
    }
    body {
        _name = name;
    }

    char[] name() { 
        return _name; 
    }

}

version (build) {
    debug {
        pragma(link, "dbi");
    } else {
        pragma(link, "dbi");
    }
}
