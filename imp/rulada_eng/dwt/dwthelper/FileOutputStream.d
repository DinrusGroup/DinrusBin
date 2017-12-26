/**
 * Authors: Frank Benoit <keinfarbton@googlemail.com>
 */
module dwt.dwthelper.FileOutputStream;

public import dwt.dwthelper.File;
public import dwt.dwthelper.OutputStream;

import dwt.dwthelper.utils;

import TangoFile = tango.io.device.File;

public class FileOutputStream : dwt.dwthelper.OutputStream.OutputStream {

    alias dwt.dwthelper.OutputStream.OutputStream.write write;
    alias dwt.dwthelper.OutputStream.OutputStream.close close;
    TangoFile.File fc;
    
    public this ( String name ){
        fc = new TangoFile.File( name, TangoFile.File.WriteCreate );
    }

    public this ( String name, bool append ){
        fc = new TangoFile.File( name, append ? TangoFile.File.WriteAppending : TangoFile.File.WriteCreate );
    }

    public this ( dwt.dwthelper.File.File file ){
        this( file.toString );
    }

    public this ( dwt.dwthelper.File.File file, bool append ){
        this( file.toString, append );
    }

    public override void write( int b ){
        ubyte[1] a;
        a[0] = b & 0xFF;
        fc.write(a);
    }

    public override void close(){
        fc.close();
    }

    public void finalize(){
        implMissing( __FILE__, __LINE__ );
    }


}


