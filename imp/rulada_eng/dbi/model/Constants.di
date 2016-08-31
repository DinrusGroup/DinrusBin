/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */

module dbi.model.Constants;

enum DbiType : ubyte 
{ 
    Null, Bool, Byte, Short, 
    Int, Long, UByte, UShort, 
    UInt, ULong, Float, Double, 
    String, Binary, Time, 
    DateTime, Decimal, None
};

enum DbiFeature : ulong
{
    MultiResults, MultiStatements 
}


version (build) {
    debug {
        pragma(link, "dbi");
    } else {
        pragma(link, "dbi");
    }
}
