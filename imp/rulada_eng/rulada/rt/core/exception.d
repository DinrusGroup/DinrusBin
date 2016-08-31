module rt.core.exception;
private import rt.core.c;
//Exceptions

private
{
    alias void  function( char[] file, size_t line, char[] msg = null ) assertHandlerType;
    alias TracedExceptionInfo function( void* ptr = null ) traceHandlerType;

    assertHandlerType   assertHandler   = null;
   traceHandlerType    trHandler    = null;
}


interface TracedExceptionInfo
{
    int opApply( int delegate( inout char[] ) );
}


////////////////////////////////////////////////////////////////////////////////
/*
- Exception
  - OutOfMemoryException

  - TracedException
    - SwitchException
    - AssertException
    - ArrayBoundsException
    - FinalizeException

    - PlatformException
      - ProcessException
      - ThreadException
        - FiberException
      - SyncException
      - IOException
        - SocketException
          - SocketAcceptException
        - AddressException
        - HostException
        - VfsException
        - ClusterException

    - NoSuchElementException
      - CorruptedIteratorException

    - IllegalArgumentException
      - IllegalElementException

    - TextException
      - RegexException
      - LocaleException
      - UnicodeException

    - PayloadException
*/
////////////////////////////////////////////////////////////////////////////////
//public import std.file: FileException;

/**
 * Thrown on an out of memory error.
 */
class OutOfMemoryException : Exception
{
		
	this()
    {
	super("Недостаток памяти: Размещение в памяти не удалось", null);
	
    }
	
    this( char[] file, size_t line )
    {
        super( "Размеещение в памяти не удалось", file, line );
		
    }

    override char[] toString()
    {
        return msg ? super.toString() : "Размещение в памяти не удалось";
    }
}



/**
 * Stores a stack trace when thrown.
 */
class TracedException : Exception
{
    this( char[] msg )
    {
        super( msg );
        m_info = traceContext();
		
    }

    this( char[] msg, Exception e )
    {
        super( msg, e );
        m_info = traceContext();
		
    }

    this( char[] msg, char[] file, size_t line )
    {
        super( msg, file, line );
        m_info = traceContext();
		
    }

    override char[] toString()
    {
        if( m_info is null )
            return super.toString();
        char[] buf = super.toString();
        buf ~= "\n----------------";
        foreach( line; m_info )
            buf ~= "\n" ~ line;
        return buf;
    }

    int opApply( int delegate( inout char[] buf ) dg )
    {
        if( m_info is null )
            return 0;
        return m_info.opApply( dg );
    }

private:
    TracedExceptionInfo m_info;
}


/**
 * Base class for operating system or library exceptions.
 */
class PlatformException : TracedException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}

/**
 * Thrown on an assert error.
 */
class AssertException : TracedException
{
    this( char[] file, size_t line )
    {
        super( "Неподтверждённая проверка", file, line );
		//
    }

    this( char[] msg, char[] file, size_t line )
    {
        super( msg, file, line );
		//
    }
}

class AssertError : Error
{
    uint linnum;
    char[] filename;

    this(char[] filename, uint linnum)
    {
	this(filename, linnum, null);
	
    }

    this(char[] filename, uint linnum, char[] msg)
    {
	this.linnum = linnum;
	this.filename = filename;

	char* buffer;
	size_t len;
	int count;

	/* This code is careful to not use gc allocated memory,
	 * as that may be the source of the problem.
	 * Instead, stick with C functions.
	 */

	len = 23 + filename.length + uint.sizeof * 3 + msg.length + 1;
	buffer = cast(char*)malloc(len);
	if (buffer == null)
	    super("ОшибкаПодтверждения - нехватка памяти");
	else
	{
	    version (Win32) alias _snprintf snprintf;
	    count = snprintf(buffer, len, "AssertError Failure %.*s(%u) %.*s",
		filename, linnum, msg);
	    if (count >= len || count == -1)
	    {	super("ОшибкаПодтверждения - внутренний сбой");
		free(buffer);
	    }
	    else
		super(buffer[0 .. count]);
	}
	
    }

    ~this()
    {
	if (msg.ptr && msg[12] == 'F')	// if it was allocated with malloc()
	{   free(msg.ptr);
	    msg = null;
	}
    }
}

/**
 * Thrown on an array bounds error.
 */
class ArrayBoundsException : TracedException
{
    this( char[] file, size_t line )
    {
        super( "Индекс массива вне его пределов", file, line );
		
    }
}

class ArrayBoundsError : Error
{
  private:

    uint linnum;
    char[] filename;

  public:
    this(char[] filename, uint linnum)
    {
	this.linnum = linnum;
	this.filename = filename;

	char[] buffer = new char[19 + filename.length + linnum.sizeof * 3 + 1];
	int len;
	len = sprintf(buffer.ptr, "ArrayBoundsError %.*s(%u)", filename, linnum);
	super(buffer[0..len]);
	
    }
}

/**
 * Thrown on finalize error.
 */
class FinalizeException : TracedException
{
    ClassInfo   info;

    this( ClassInfo c, Exception e = null )
    {
        super( "Ошибка финализации", e );
        info = c;
		
    }

    override char[] toString()
    {
        return "Выдана ошибка при финализации экземпляра класса " ~ info.name;
    }
}


/**
 * Thrown on a switch error.
 */
class SwitchException : TracedException
{
    this( char[] file, size_t line )
    {
        super( "Не найдено соответствующего элемента переключателя", file, line );
		
    }
}

class SwitchError : Error
{
  private:

    uint linnum;
    char[] filename;

    this(char[] filename, uint linnum)
    {
	this.linnum = linnum;
	this.filename = filename;

	char[] buffer = new char[17 + filename.length + linnum.sizeof * 3 + 1];
	int len = sprintf(buffer.ptr, "Switch Default %.*s(%u)", filename, linnum);
	super(buffer[0..len]);
	
    }


  public:

    /***************************************
     * If nobody catches the Assert, this winds up
     * getting called by the startup code.
     */

    override void print()
    {
	printf("Switch Default %s(%u)\n", cast(char *)filename, linnum);
    }
}

/**
 * Represents a text processing error.
 */
class TextException : TracedException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}

/**
 * Thrown on a unicode conversion error.
 */
class UnicodeException : TextException
{
    size_t idx;

    this( char[] msg, size_t idx )
    {
        super( msg );
        this.idx = idx;
		
    }
}


/**
 * Base class for thread exceptions.
 */
class ThreadException : PlatformException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}


/**
 * Base class for fiber exceptions.
 */
class FiberException : ThreadException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}


/**
 * Base class for synchronization exceptions.
 */
class SyncException : PlatformException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}



/**
 * The basic exception thrown by the tango.io package. One should try to ensure
 * that all Tango exceptions related to IO are derived from this one.
 */
class IOException : PlatformException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}

/**
 * The basic exception thrown by the tango.io.vfs package. 
 */
private class VfsException : IOException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}

/**
 * The basic exception thrown by the tango.io.cluster package. 
 */
private class ClusterException : IOException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}

/**
 * Base class for socket exceptions.
 */
class SocketException : IOException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}


/**
 * Base class for exception thrown by an InternetHost.
 */
class HostException : IOException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}


/**
 * Base class for exceptiond thrown by an Address.
 */
class AddressException : IOException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}


/**
 * Thrown when a socket failed to accept an incoming connection.
 */
class SocketAcceptException : SocketException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}


/**
 * Thrown on a process error.
 */
class ProcessException : PlatformException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}


/**
 * Base class for regluar expression exceptions.
 */
class RegexException : TextException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}


/**
 * Base class for locale exceptions.
 */
class LocaleException : TextException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}


/**
 * RegistryException is thrown when the NetworkRegistry encounters a
 * problem during proxy registration, or when it sees an unregistered
 * guid.
 */
class RegistryException : TracedException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}


/**
 * Thrown when an illegal argument is encountered.
 */
class IllegalArgumentException : TracedException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}


/**
 *
 * IllegalElementException is thrown by Collection methods
 * that add (or replace) elements (and/or keys) when their
 * arguments are null or do not pass screeners.
 *
 */
class IllegalElementException : IllegalArgumentException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}


/**
 * Thrown on past-the-end errors by iterators and containers.
 */
class NoSuchElementException : TracedException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}


/**
 * Thrown when a corrupt iterator is detected.
 */
class CorruptedIteratorException : NoSuchElementException
{
    this( char[] msg )
    {
        super( msg );
		
    }
}

/**
 * Thrown on finalize error.
 */
class FinalizeError : Exception
{
    ClassInfo   info;

    this( ClassInfo c, Exception e = null )
    {
        super( "Ошибка финализации", e );
        info = c;
		
    }

    override string toString()
    {
        return "Выдана ошибка при финализации экземпляра класса " ~ info.name;
    }
}

/**
 * Thrown on a range error.
 */
class RangeError : Exception
{
    this( string file, size_t line )
    {
        super( "Нарушение диапазона", file, line );
		
    }
}

/**
 * Thrown on hidden function error.
 */
class HiddenFuncError : Exception
{
    this( ClassInfo ci )
    {
        super( "Вызван скрытый метод для " ~ ci.name );
		
    }
}

////////////////////////////////////////////////////////////////////////////////
// Overrides
////////////////////////////////////////////////////////////////////////////////


/**
 * Overrides the default assert hander with a user-supplied version.
 *
 * Параметры:
 *  h = The new assert handler.  Set to null to use the default handler.
 */
void setAssertHandler( assertHandlerType h )
{
    assertHandler = h;
}


/**
 * Overrides the default trace hander with a user-supplied version.
 *
 * Параметры:
 *  h = The new trace handler.  Set to null to use the default handler.
 */
void setTraceHandler( traceHandlerType h )
{
    trHandler = h;
}


////////////////////////////////////////////////////////////////////////////////
// Overridable Callbacks
////////////////////////////////////////////////////////////////////////////////


/**
 * A callback for assert errors in D.  The user-supplied assert handler will
 * be called if one has been supplied, otherwise an AssertException will be
 * thrown.
 *
 * Параметры:
 *  file = The name of the file that signaled this error.
 *  line = The line number on which this error occurred.
 */
extern  (C) void onAssertError( char[] file, size_t line )
{
    if( assertHandler is null )
        throw new AssertException( file, line );
    assertHandler( file, line );
}


/**
 * A callback for assert errors in D.  The user-supplied assert handler will
 * be called if one has been supplied, otherwise an AssertException will be
 * thrown.
 *
 * Параметры:
 *  file = The name of the file that signaled this error.
 *  line = The line number on which this error occurred.
 *  msg  = An error message supplied by the user.
 */
extern  (C) void onAssertErrorMsg( char[] file, size_t line, char[] msg )
{
    if( assertHandler is null )
        throw new AssertException( msg, file, line );
    assertHandler( file, line, msg );
}


/**
 * This function will be called when a TracedException is constructed.  The
 * user-supplied trace handler will be called if one has been supplied,
 * otherwise no trace will be generated.
 *
 * Параметры:
 *  ptr = A pointer to the location from which to generate the trace, or null
 *        if the trace should be generated from within the trace handler
 *        itself.
 *
 * Возвращает:
 *  An object describing the current calling context or null if no handler is
 *  supplied.
 */
TracedExceptionInfo traceContext( void* ptr = null )
{
    if( trHandler is null )
        return null;
    return trHandler( ptr );
}


////////////////////////////////////////////////////////////////////////////////
// Internal Error Callbacks
////////////////////////////////////////////////////////////////////////////////


/**
 * A callback for array bounds errors in D.  An ArrayBoundsException will be
 * thrown.
 *
 * Параметры:
 *  file = The name of the file that signaled this error.
 *  line = The line number on which this error occurred.
 *
 * Выводит:
 *  ArrayBoundsException.
 */
extern  (C) void onArrayBoundsError( char[] file, size_t line )
{
    throw new ArrayBoundsException( file, line );
}


/**
 * A callback for finalize errors in D.  A FinalizeException will be thrown.
 *
 * Параметры:
 *  e = The exception thrown during finalization.
 *
 * Выводит:
 *  FinalizeException.
 */
extern  (C) void onFinalizeError( ClassInfo info, Exception ex )
{
    throw new FinalizeException( info, ex );
}


/**
 * A callback for out of memory errors in D.  An OutOfMemoryException will be
 * thrown.
 *
 * Выводит:
 *  OutOfMemoryException.
 */
extern  (C) void onOutOfMemoryError()
{
    // NOTE: Since an out of memory condition exists, no allocation must occur
    //       while generating this object.
    throw cast(OutOfMemoryException) cast(void*) OutOfMemoryException.classinfo.init;
}
//{
    // NOTE: Since an out of memory condition exists, no allocation must occur
    //       while generating this object.
   // throw cast(OutOfMemoryException) cast(void*) OutOfMemoryException.classinfo.init;
//}


/**
 * A callback for switch errors in D.  A SwitchException will be thrown.
 *
 * Параметры:
 *  file = The name of the file that signaled this error.
 *  line = The line number on which this error occurred.
 *
 * Выводит:
 *  SwitchException.
 */
extern  (C) void onSwitchError( char[] file, size_t line )
{
    throw new SwitchException( file, line );
}


/**
 * A callback for unicode errors in D.  A UnicodeException will be thrown.
 *
 * Параметры:
 *  msg = Information about the error.
 *  idx = String index where this error was detected.
 *
 * Выводит:
 *  UnicodeException.
 */
extern  (C) void onUnicodeError( char[] msg, size_t idx )
{
    throw new UnicodeException( msg, idx );
}

class XmlException : TextException
{
    this(char[] msg)
{
super(msg);
}
}

/**
 * A callback for array bounds errors in D.  A RangeError will be thrown.
 *
 * Параметры:
 *  file = The name of the file that signaled this error.
 *  line = The line number on which this error occurred.
 *
 * Выводит:
 *  RangeError.
 */
extern  (C) void onRangeError( string file, size_t line )
{
    throw new RangeError( file, line );
}



/**
 * A callback for hidden function errors in D.  A HiddenFuncError will be
 * thrown.
 *
 * Выводит:
 *  HiddenFuncError.
 */
extern  (C) void onHiddenFuncError( Object o )
{
    throw new HiddenFuncError( o.classinfo );
}

/***********************************
 * These are internal callbacks for various language errors.
 */
extern  (C) void _d_assert( char[] file, uint line )
{
    onAssertError( file, cast(size_t) line );
}

extern  (C) static void _d_assert_msg( char[] msg, char[] file, uint line )
{
    onAssertErrorMsg( file, cast(size_t) line, msg );
}

extern  (C) void _d_array_bounds( char[] file, uint line )
{
    onArrayBoundsError( file, cast(size_t) line );
	printf(" _d_assert(%s, %d)\n", cast(char *)file, line);
    ArrayBoundsError a = new ArrayBoundsError(file, cast(size_t) line);
    printf("assertion %p created\n", a);
    throw a;
}

extern  (C) void _d_switch_error( char[] file, uint line )
{
    onSwitchError( file, cast(size_t) line );
}

extern  (C) void _d_OutOfMemory()
{
	onOutOfMemoryError();
}



//static module!!!!
static this()
{
}