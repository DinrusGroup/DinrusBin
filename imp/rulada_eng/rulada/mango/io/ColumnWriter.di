/*******************************************************************************

        @file ColumnWriter.d
        
        Copyright (c) 2004 Kris Bell
        
        This software is provided 'as-is', without any express or implied
        warranty. In no event will the authors be held liable for damages
        of any kind arising from the use of this software.
        
        Permission is hereby granted to anyone to use this software for any 
        purpose, including commercial applications, and to alter it and/or 
        redistribute it freely, subject to the following restrictions:
        
        1. The origin of this software must not be misrepresented; you must 
           not claim that you wrote the original software. If you use this 
           software in a product, an acknowledgment within documentation of 
           said product would be appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must 
           not be misrepresented as being the original software.

        3. This notice may not be removed or altered from any distribution
           of the source.

        4. Derivative works are permitted, but they must carry this notice
           in full and credit the original source.


                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


        @version        Initial version, March 2004      
        @author         Kris


*******************************************************************************/

module mango.io.ColumnWriter;

private import  mango.io.Exception;

private import  mango.convert.Type;

public  import  mango.io.DisplayWriter;

/*******************************************************************************

        Print readable output to an IWriter, distributed across a set of
        columns. Columns start at zero rather than one, so adjust counts
        appropriately. All output is currently left-aligned. 

        This is how one might use ColumnWriter:
        
        @code
        static int[] columns = [0, 4, 14, 24];

        // map a ColumnWriter directly onto Stdout
        ColumnWriter write = new ColumnWriter (Stdout.getBuffer(), new ColumnList(columns));

        // set 2 digits of precision
        write.setPrecision (2);

        // Mango style     
        write (1) (20.34944) ("test") (CR);

        // iostream style     
        write << 1 << 20.34944 << "test" << CR;
        
        // put() style
        write.put(1).put(20.34944).put("test").cr();
        @endcode

        Note that ColumnWriter may be used with files, sockets, or any other
        buffer-oriented construct.

*******************************************************************************/

class ColumnWriter : DisplayWriter
{
        alias DisplayWriter.put put;

        private int             output;
        private ColumnList      columns;
        private static ubyte    spaces[256];

        /***********************************************************************
        
                Construct a ColumnWriter upon the given IBuffer, with the
                specified set of columns.
                
        ***********************************************************************/

        this (IBuffer buffer, ColumnList columns)
        in {
           assert (buffer);
           assert (columns);
           }
        body
        {
                super (buffer);
                
                this.columns = columns;
                reset ();
        }
     
        /***********************************************************************
        
                Populate the space padding with valid spaces.

        ***********************************************************************/

        static this ()
        {
                spaces[] = ' ';
        }
     
        /***********************************************************************
        
                Reset everything back to zero. Typical usage will invoke
                this whenever a Newline is emitted. 
                
                Note that we maintain our own internal count of how many 
                bytes have been output: this is because we cannot depend 
                on the Buffer to provide that for us if (a) the buffer is 
                very small, or (b) the buffer is flushed after each write 
                (Stdout etc).

        ***********************************************************************/

        void reset ()
        {
                output = 0;
                columns.reset ();
        }
/+     
        /***********************************************************************
        
                Return the width of the current column.

        ***********************************************************************/

        override int getWidth ()
        {
                return columns.getWidth;
        }
+/
        /***********************************************************************
        
                Intercept the IWritable type so we can reset our columns
                when a newline is emitted.

        ***********************************************************************/

        override IWriter put (IWritable x)
        {                       
               // have superclass print the IWritable
                super.put (x);

                // reset columns on a newline
                if (cast (INewlineWriter) x)
                    reset ();

                return this;
        }
     
        /***********************************************************************
        
                Intercept the output so we can write some spaces first. 
                Note that our superclass (DisplayWriter) converts each
                of its arguments to a char[] first, so this override is
                able to catch everything emitted.

                @todo - add the equivalent intercepts for both wchar[] 
                        and dchar[] methods.

        ***********************************************************************/

        protected override IWriter encode (void* src, uint bytes, int type)
        {
                pad();
/+
                // encode the string
                void[] x = buffer.getCodec.from (src[0..bytes], type);

                // adjust output with the encoded length
                int t = buffer.type();
                output += (x.length / ((t is Type.Raw) ? 1 : Type.widths[t]));

                // append encoded string
                buffer.append (x);
                return this;
+/
                output += bytes;
                return super.encode (src, bytes, type);
        }

        /***********************************************************************

                Pad the output with spaces to reach the next column
                position. This should be invoked before anything is
                written to the buffer.
        
        ***********************************************************************/

        private final void pad ()
        {    
                int padding = columns.next() - output;

                // pad output to next column position?
                if (padding > 0)
                   if (padding <= spaces.sizeof)
                      {
                      // yep - write a set of spaces
                      super.encode (cast(void*) spaces, padding, Type.Utf8);
                      output += padding;
                      }
                   else
                      throw new IOException ("Invalid column step (> 256)");
        }
}


/*******************************************************************************

        A list of columns for the ColumnWriter to utilize.

*******************************************************************************/

class ColumnList
{
        private int     index;
        private int[]   columns;

        private bool    rightAlign;  // this needs to be per column instead

        /***********************************************************************
        
                Construct a ColumnList via an array of integers.

        ***********************************************************************/

        this (int[] columns)
        in {
           assert (columns);
           }
        body
        {
                reset ();
                this.columns = columns;
        }

        /***********************************************************************
        
                Start returning columns from the beginning.

        ***********************************************************************/

        void reset ()
        {
                index = 0;
        }

        /***********************************************************************
        
                Return width of the current column

        ***********************************************************************/

        int getWidth ()
        {
                if (rightAlign)
                   {
                   int i = index;
                
                   if (i == 0)
                       ++i;

                   if (i < columns.length)
                       return columns[i] - columns[i-1];
                   }
                return 0;
        }

        /***********************************************************************
        
                Returns next column in the sequence. Assume that we'll be
                invoked (quasi-legally) when there's no more columns left.

        ***********************************************************************/

        int next ()
        {
                if (index < columns.length)
                    ++index;

                return columns [index-1];
        }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
