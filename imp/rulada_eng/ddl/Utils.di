module ddl.Utils;

private import  mango.convert.Type,
                mango.convert.Format,
                mango.convert.Unicode;
          
/**
	Extended Sprintf class.  Features an internally expanding buffer for formatting data,
	and an optional opCall vararg syntax.
*/	
class ExtSprintClassT(T)
{
        package alias FormatStructT!(T) Format;

        private Unicode.Into!(T) into;
        private Format           format;
        private T[128]           tmp;
        private T[]              buffer;
        private T*               p, limit;

        /**********************************************************************

        **********************************************************************/

        this (int size, Format.DblFormat df = null, T[] workspace = null)
        {
                format.ctor (&sink, null, workspace.length ? workspace : tmp, df);
                buffer = new T[size];
				p = cast(T*) buffer;
                limit = p + buffer.length;
        }

        /**********************************************************************

        **********************************************************************/

        private uint sink (void[] v, uint type);

        /**********************************************************************

        **********************************************************************/

        T[] opCall (T[] fmt, ...)
        {
                p = cast(T*) buffer;
                return buffer [0 .. format (fmt, _arguments, _argptr)];
        }
        
      	T[] opCall (T[] fmt,TypeInfo[] arguments,void* argptr)
        {
            p = cast(T*) buffer;
            return buffer [0 .. format (fmt, arguments, argptr)];	        
        }        
}

alias ExtSprintClassT!(char) ExtSprintClass;

char[] dataDumper(void* data,uint length);

/*
debug{   
	private import mango.log.Logger;
	private import mango.log.DateLayout;
	
	Logger ddlLog;
	
	static this(){
		ddlLog = Logger.getLogger("ddl.logger");
		ddlLog.info("Logger Initalized");
		ddlLog.
	}
	
	public void debugLog(...){
		
	}
}*/
debug{
	private import mango.io.Stdout;
	
	public void debugLog(char[] s,...);
}

unittest{}
