/*******************************************************************************

        @file PickleWriter.d
        
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


        @version        Initial version, April 2004      
        @author         Kris


*******************************************************************************/

module mango.io.PickleWriter;

private import  mango.io.EndianWriter;

private import  mango.io.model.IPickle;


/*******************************************************************************

        Serialize Objects via an EndianWriter. All Objects are written in
        Network-order such that they may cross machine boundaries.

        See PickleReader for an example of how to use this.

*******************************************************************************/

version (BigEndian)
         alias Writer SuperClass;
      else
         alias EndianWriter SuperClass;

class PickleWriter : SuperClass
{
        /***********************************************************************
        
                Construct a PickleWriter upon the given buffer. As
                Objects are serialized, their content is written to this
                buffer. The buffer content is then typically flushed to 
                some external conduit, such as a file or socket.

                Note that serialized data is always in Network order.

        ***********************************************************************/
        
        this (IBuffer buffer)
        {
                super (buffer);
        }

        /***********************************************************************
        
                Serialize an Object. Objects are written in Network-order, 
                and are prefixed by the guid exposed via the IPickle
                interface. This guid is used to identify the appropriate
                factory when reconstructing the instance. 

        ***********************************************************************/

        PickleWriter freeze (IPickle object)
        {
                put (object.getGuid);
                object.write (this);
                return this;
        }
}


version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
