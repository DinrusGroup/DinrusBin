/**
 * Authors: Frank Benoit <keinfarbton@googlemail.com>
 */
module dwt.dwthelper.System;

import dwt.dwthelper.utils;

import tango.sys.Environment;
import tango.core.Exception;
import tango.io.model.IFile : FileConst;
import tango.time.Clock;
import std.c : exit;

template SimpleType(T) {
    debug{
        static void validCheck(uint SrcLen, uint DestLen, uint copyLen){
            if(SrcLen < copyLen || DestLen < copyLen|| SrcLen < 0 || DestLen < 0){
                //Util.trace("Error : SimpleType.arraycopy(), out of bounds.");
                assert(0);
            }
        }
    }

    static void remove(inout T[] items, int index) {
        if(items.length == 0)
            return;

        if(index < 0 || index >= items.length){
            throw new ArrayBoundsException(__FILE__, __LINE__);
        }

        T element = items[index];

        int length = items.length;
        if(length == 1){
            items.length = 0;
            return;// element;
        }

        if(index == 0)
            items = items[1 .. $];
        else if(index == length - 1)
            items = items[0 .. index];
        else
            items = items[0 .. index] ~ items[index + 1 .. $];
    }

    static void insert(inout T[] items, T item, int index = -1) {
        if(index == -1)
            index = items.length;

        if(index < 0 || index > items.length ){
            throw new ArrayBoundsException(__FILE__, __LINE__);
        }

        if(index == items.length){
            items ~= item;
        }else if(index == 0){
            T[] newVect;
            newVect ~= item;
            items = newVect ~ items;
        }else if(index < items.length ){
            T[] arr1 = items[0 .. index];
            T[] arr2 = items[index .. $];

            // Important : if you write like the following commented,
            // you get wrong data
            // code:  T[] arr1 = items[0..index];
            //        T[] arr2 = items[index..$];
            //        items = arr1 ~ item;      // error, !!!
            //        items ~= arr2;            // item replace the arrr2[0] here
            items = arr1 ~ item ~ arr2;
        }
    }

    static void arraycopy(T[] src, uint srcPos, T[] dest, uint destPos, uint len)
    {
        if(len == 0) return;

        assert(src);
        assert(dest);
        debug{validCheck(src.length - srcPos, dest.length - destPos, len);}

        if(src is dest){
            if( destPos < srcPos ){
                for(int i=0; i<len; ++i){
                    dest[destPos+i] = src[srcPos+i];
                }
            }
            else{
                for(int i=len-1; i>=0; --i){
                    dest[destPos+i] = src[srcPos+i];
                }
            }
        }else{
            dest[destPos..(len+destPos)] = src[srcPos..(len+srcPos)];
        }
    }
}


class System {

    alias SimpleType!(int).arraycopy arraycopy;
    alias SimpleType!(byte).arraycopy arraycopy;
    alias SimpleType!(double).arraycopy arraycopy;
    alias SimpleType!(float).arraycopy arraycopy;
    alias SimpleType!(short).arraycopy arraycopy;
    alias SimpleType!(long).arraycopy arraycopy;
    alias SimpleType!(uint).arraycopy arraycopy;
    alias SimpleType!(ushort).arraycopy arraycopy;
    alias SimpleType!(ubyte).arraycopy arraycopy;
    alias SimpleType!(ulong).arraycopy arraycopy;
    alias SimpleType!(char).arraycopy arraycopy;
    alias SimpleType!(wchar).arraycopy arraycopy;
    alias SimpleType!(Object).arraycopy arraycopy;
    alias SimpleType!(void*).arraycopy arraycopy;

    alias SimpleType!(int[]).arraycopy arraycopy;
    alias SimpleType!(byte[]).arraycopy arraycopy;
    alias SimpleType!(double[]).arraycopy arraycopy;
    alias SimpleType!(float[]).arraycopy arraycopy;
    alias SimpleType!(short[]).arraycopy arraycopy;
    alias SimpleType!(long[]).arraycopy arraycopy;
    alias SimpleType!(uint[]).arraycopy arraycopy;
    alias SimpleType!(ushort[]).arraycopy arraycopy;
    alias SimpleType!(ubyte[]).arraycopy arraycopy;
    alias SimpleType!(ulong[]).arraycopy arraycopy;
    alias SimpleType!(String).arraycopy arraycopy;
    alias SimpleType!(wchar[]).arraycopy arraycopy;
    alias SimpleType!(Object[]).arraycopy arraycopy;
    alias SimpleType!(void*[]).arraycopy arraycopy;
    alias SimpleType!(void*[]).arraycopy arraycopy;

    static long currentTimeMillis(){
        return Clock.now().ticks() / 10000;
    }

    static void exit( int code ){
        .exit(code);
    }
    public static int identityHashCode(Object x){
        if( x is null ){
            return 0;
        }
        return (*cast(Object *)&x).toHash();
    }

    public static String getProperty( String key, String defval ){
        String res = getProperty(key);
        if( res ){
            return res;
        }
        return defval;
    }
    public static String getProperty( String key ){
        /* Get values for local dwt specific keys */
        String* p;
        if (key[0..3] == "dwt") {
            return ((p = key in localProperties) != null) ? *p : null;
        /* else get values for global system keys (environment) */
        } else {
            switch( key ){
                case "os.name": return "linux";
                case "user.name": return "";
                case "user.home": return "";
                case "user.dir" : return "";
                case "file.separator" : return FileConst.PathSeparatorString ;
                default: return null;
            }
        }
    }

    public static void setProperty ( String key, String value ) {
        /* set property for local dwt keys */
        if (key[0..3] == "dwt") {
            if (key !is null && value !is null)
                localProperties[ key ] = value;
        /* else set properties for global system keys (environment) */
        } else {

        }

    }

    static class Output {
        public void println( String str ){
            implMissing( __FILE__, __LINE__ );
        }
    }

    private static Output err__;
    public static Output err(){
        if( err__ is null ){
            err__ = new Output();
        }
        return err__;
    }
    private static Output out__;
    public static Output out_(){
        if( out__ is null ){
            out__ = new Output();
        }
        return out__;
    }

    private static String[String] localProperties;
}

