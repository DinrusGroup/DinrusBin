/**
 * Authors: Frank Benoit <keinfarbton@googlemail.com>
 */
module dwt.dwthelper.OutputStream;

import dwt.dwthelper.utils;

public abstract class OutputStream {

    public this(){
    }

    public abstract void write( int b );

    public void write( byte[] b ){
        foreach( bv; b ){
            write(bv);
        }
    }

    public void write( byte[] b, int off, int len ){
        write(b[off .. off+len]);
    }

    public void flush(){
    }

    public void close(){
    }
}


