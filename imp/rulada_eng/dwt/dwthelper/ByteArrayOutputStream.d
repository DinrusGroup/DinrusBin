/**
 * Authors: Frank Benoit <keinfarbton@googlemail.com>
 */
module dwt.dwthelper.ByteArrayOutputStream;

public import dwt.dwthelper.OutputStream;
import dwt.dwthelper.utils;
import tango.io.device.Array;

public class ByteArrayOutputStream : dwt.dwthelper.OutputStream.OutputStream {

    protected Array buffer;

    public this (){
        buffer = new Array(0,0);
    }

    public this ( int par_size ){
        buffer = new Array(par_size);
    }

    public synchronized override void write( int b ){
        byte[1] a;
        a[0] = b & 0xFF;
        buffer.append(a);
    }

    public synchronized override void write( byte[] b, int off, int len ){
        buffer.append( b[ off .. off + len ]);
    }

    public synchronized override void write( byte[] b ){
        buffer.append( b );
    }

    public synchronized void writeTo( dwt.dwthelper.OutputStream.OutputStream out_KEYWORDESCAPE ){
        implMissing( __FILE__, __LINE__ );
    }

    public synchronized void reset(){
        implMissing( __FILE__, __LINE__ );
    }

    public synchronized byte[] toByteArray(){
        return cast(byte[])buffer.slice();
    }

    public int size(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }

    public override String toString(){
        implMissing( __FILE__, __LINE__ );
        return null;
    }

    public String toString( String enc ){
        implMissing( __FILE__, __LINE__ );
        return null;
    }

    public String toString( int hibyte ){
        implMissing( __FILE__, __LINE__ );
        return null;
    }

    public  override void close(){
        implMissing( __FILE__, __LINE__ );
    }
}


