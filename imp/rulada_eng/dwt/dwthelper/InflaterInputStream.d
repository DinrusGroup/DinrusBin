/**
 * Authors: Frank Benoit <keinfarbton@googlemail.com>
 */
module dwt.dwthelper.InflaterInputStream;

public import dwt.dwthelper.InputStream;
import dwt.dwthelper.utils;
import tango.io.Stdout;
import tango.io.compress.ZlibStream;
version(Windows){
    version(build){
        pragma(link,"zlib");
    }
}
import tango.io.device.Conduit;

class InputStreamWrapper : tango.io.model.IConduit.InputStream {

    dwt.dwthelper.InputStream.InputStream istr;

    this( dwt.dwthelper.InputStream.InputStream istr ){
        this.istr = istr;
    }

    uint read (void[] dst){
        int res = istr.read( cast(byte[])dst );
        return res;
    }

    IOStream flush () {
            return this;
    }

    void[] load ( size_t max = -1 ) {
            return Conduit.load (this, max);
    }

    tango.io.model.IConduit.InputStream clear (){
        return this;
    }

    tango.io.model.IConduit.IConduit conduit (){
        return null;
    }

    void close (){
        istr.close();
    }
    tango.io.model.IConduit.InputStream input (){
        return null;
    }
    long seek (long offset, Anchor anchor = Anchor.Begin){
        return 0;
    }
}

public class InflaterInputStream : dwt.dwthelper.InputStream.InputStream {

    alias dwt.dwthelper.InputStream.InputStream.read read;
    alias dwt.dwthelper.InputStream.InputStream.skip skip;
    alias dwt.dwthelper.InputStream.InputStream.available available;
    alias dwt.dwthelper.InputStream.InputStream.close close;
    alias dwt.dwthelper.InputStream.InputStream.mark mark;
    alias dwt.dwthelper.InputStream.InputStream.reset reset;
    alias dwt.dwthelper.InputStream.InputStream.markSupported markSupported;

    protected byte[] buf;
    protected int len;
    package bool usesDefaultInflater = false;

    ZlibInput tangoIstr;

    public this ( dwt.dwthelper.InputStream.InputStream istr ){
        tangoIstr = new ZlibInput( new InputStreamWrapper(istr ));
    }

    public int read(){
        ubyte[1] data;
        uint res = tangoIstr.read( data );
        if( res !is 1 ){
            return data[0] & 0xFF;
        }
        return -1;
    }

    public int read( byte[] b, int off, int len ){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }

    public int available(){
        implMissing( __FILE__, __LINE__ );
        return 0;
    }

    public long skip( long n ){
        implMissing( __FILE__, __LINE__ );
        return 0L;
    }

    public void close(){
        implMissing( __FILE__, __LINE__ );
    }

    public void fill(){
        implMissing( __FILE__, __LINE__ );
    }

    public bool markSupported(){
        implMissing( __FILE__, __LINE__ );
        return false;
    }

    public synchronized void mark( int readlimit ){
        implMissing( __FILE__, __LINE__ );
    }

    public synchronized void reset(){
        implMissing( __FILE__, __LINE__ );
    }
}


