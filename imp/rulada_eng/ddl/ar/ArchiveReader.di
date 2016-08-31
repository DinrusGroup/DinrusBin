/+
    Copyright (c) 2005 Lars Ivar Igesund, J Duncan, Eric Anderton

    Permission is hereby granted, free of charge, to any person
    obtaining a copy of this software and associated documentation
    files (the "Software"), to deal in the Software without
    restriction, including without limitation the rights to use,
    copy, modify, merge, publish, distribute, sublicense, and/or
    sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following
    conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
    OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
    HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
    OTHER DEALINGS IN THE SOFTWARE.
+/
module ddl.ar.ArchiveReader;

private import ddl.DDLReader;
private import ddl.Utils;
private import ddl.DDLException;

private import mango.io.model.IBuffer;
private import mango.text.Text;
private import mango.convert.Atoi;

struct ArchiveHeader{ 
       char[16] ar_name;    /* file member name - `/' terminated */ 
       ubyte[12] ar_date;    /* file member date - decimal */ 
       ubyte[6] ar_uid;      /* file member user id - decimal */ 
       ubyte[6] ar_gid;      /* file member group id - decimal */ 
       ubyte[8] ar_mode;     /* file member mode - octal */ 
       char[10] ar_size;    /* file member size - decimal */ 
       char[2] ar_fmag;     /* ARFMAG - string to end header */ 
}

class ArchiveReader : DDLReader{

    public this(IBuffer buffer){
        super(buffer);
    }
    
    alias DDLReader.get get;

    public ArchiveReader get(inout ArchiveHeader arh){
        super.read(&arh,ArchiveHeader.sizeof,0);
        return this;
    }

    ArchiveReader getFile(out ArchiveHeader hdr, out char[] file, 
                          out char[] filename){

        const char[] ARFMAG = "`\n";

        debug debugLog("* Reading a file from the archive");

        void alignReader(){
            if(getPosition & 1){
                debug debugLog("* padding data address");
                ubyte dummy;
                get(dummy);
            }
        }
        
        alignReader();
        if(!hasMore())// re-alignment may cause EOF
            return null;

        // read member header
        get(hdr);  // throws "illegal library file" 
 
        assert(hdr.ar_fmag == ARFMAG);
        if( hdr.ar_fmag != ARFMAG ){
            throw new DDLException("Invalid link member signature: %d\n",hdr.ar_fmag[1]);
        }

        char [] fName = Text.trim(hdr.ar_name);
        uint fSize = Atoi.parse(Text.trim(hdr.ar_size));

        // read member data
        char[] memberData;
        try {
            get(memberData, fSize);
        } catch(Exception e) {
            throw new DDLException("Could not read member data - received message " ~ e.toString() ~ " - Archive library is invalid.");
        }

        debug debugLog("* Read %s from the archive", fName);

        file = memberData;
        filename = fName;
        return this;
    }
}



version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-ddl");
        } else version (DigitalMars) {
            pragma(link, "mango");
        } else {
            pragma(link, "DO-ddl");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-ddl");
        } else version (DigitalMars) {
            pragma(link, "mango");
        } else {
            pragma(link, "DO-ddl");
        }
    }
}
