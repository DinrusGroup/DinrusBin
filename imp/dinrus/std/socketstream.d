
module std.socketstream;

private import std.stream;
private import std.socket;

/**************
 * <b>SocketStream</b> is a stream for a blocking,
 * connected <b>Socket</b>.
 */
class SocketStream: Stream
{
    private:
	Socket sock;
	
    public:

	/**
	 * Constructs a SocketStream with the specified Socket and FileMode flags.
	 */
	this(Socket sock, FileMode mode)
	{
		if(mode & FileMode.In)
			readable = true;
		if(mode & FileMode.Out)
			writeable = true;
		
		this.sock = sock;
	}
	
	/**
	 * Uses mode <b>FileMode.In | FileMode.Out</b>.
	 */
	this(Socket sock)
	{
		writeable = readable = true;
		this.sock = sock;
	}
	
	/**
	 * Property to get the <b>Socket</b> that is being streamed.
	 */
	Socket socket()
	{
		return sock;
	}
	
	/**
	 * Attempts to read the entire block, waiting if necessary.
	 */
	override size_t readBlock(void* _buffer, size_t size)
	{
	  ubyte* buffer = cast(ubyte*)_buffer;
	  assertReadable();
	  
	  if (size == 0)
	    return size;
	  
	  auto len = sock.receive(buffer[0 .. size]);
	  readEOF = cast(bool)(len == 0);
	  if (len == sock.ERROR)
	    len = 0;
	  return len;
	}
	
	/**
	 * Attempts to write the entire block, waiting if necessary.
	 */
	override size_t writeBlock(void* _buffer, size_t size)
	{
	  ubyte* buffer = cast(ubyte*)_buffer;
	  assertWriteable();

	  if (size == 0)
	    return size;
	  
	  auto len = sock.send(buffer[0 .. size]);
	  readEOF = cast(bool)(len == 0);
	  if (len == sock.ERROR) 
	    len = 0;
	  return len;
	}
	
	/**
	 *
	 */
	override ulong seek(long offset, SeekPos whence)
	{
		throw new SeekException("Cannot seek a socket.");
	}
	
	/**
	 * Does not return the entire stream because that would
	 * require the remote connection to be closed.
	 */
	override char[] toString()
	{
		return sock.toString();
	}
	
	/**
	 * Close the <b>Socket</b>.
	 */
	override void close()
	{
		sock.close();
	}
}

