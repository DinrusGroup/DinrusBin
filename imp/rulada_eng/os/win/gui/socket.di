// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


///
module os.win.gui.socket;


version(DFL_TANGO0951beta1)
	version = DFL_TANGObefore099rc3;
else version(DFL_TANGO097rc1)
	version = DFL_TANGObefore099rc3;
else version(DFL_TANGO098rc2)
	version = DFL_TANGObefore099rc3;


version(WINE)
{
}
else
{

private import os.win.gui.x.dlib, std.c;

private
{
	version(Tango)
	{
		version(DFL_TANGObefore099rc3)
			private import tango.core.Intrinsic;
		else
			private import std.intrinsic;
		private import tango.net.Socket;
		
		alias NetHost DInternetHost;
		alias IPv4Address DInternetAddress;
		
		socket_t getSocketHandle(Socket sock);
	}
	else
	{
		private import std.socket, std.intrinsic;
		private import os.windows;
		
		alias InternetHost DInternetHost;
		alias InternetAddress DInternetAddress;
		
		socket_t getSocketHandle(Socket sock);
	}
}

private import os.win.gui.x.winapi, os.win.gui.application, os.win.gui.base, os.win.gui.x.utf;


private
{
	enum
	{
		FD_READ =       0x01,
		FD_WRITE =      0x02,
		FD_OOB =        0x04,
		FD_ACCEPT =     0x08,
		FD_CONNECT =    0x10,
		FD_CLOSE =      0x20,
		FD_QOS =        0x40,
		FD_GROUP_QOS =  0x80,
	}
	
	
	extern(Windows) int WSAAsyncSelect(socket_t s, HWND hWnd, UINT wMsg, int lEvent);
}


///
// Can be OR'ed.
enum EventType
{
	NONE = 0, ///
	
	READ =       FD_READ, /// ditto
	WRITE =      FD_WRITE, /// ditto
	OOB =        FD_OOB, /// ditto
	ACCEPT =     FD_ACCEPT, /// ditto
	CONNECT =    FD_CONNECT, /// ditto
	CLOSE =      FD_CLOSE, /// ditto
	
	QOS =        FD_QOS,
	GROUP_QOS =  FD_GROUP_QOS,
}


///
// -err- will be 0 if no error.
// -type- will always contain only one flag.
alias void delegate(Socket sock, EventType type, int err) RegisterEventCallback;


// Calling this twice on the same socket cancels out previously
// registered events for the socket.
// Requires Application.run() or Application.doEvents() loop.
void registerEvent(Socket sock, EventType events, RegisterEventCallback callback);

void unregisterEvent(Socket sock) ;

///
class AsyncSocket: Socket // docmain
{
	///
	this(AddressFamily af, SocketType type, ProtocolType protocol);
	
	version(Tango)
	{
	}
	else
	{
		/// ditto
		this(AddressFamily af, SocketType type);
		
		/// ditto
		this(AddressFamily af, SocketType type, Dstring protocolName);
	}
	
	/// ditto
	// For use with accept().
	protected this();
	
	
	///
	void event(EventType events, RegisterEventCallback callback);
	
	version(Tango)
	{
	}
	else
	{
		protected override AsyncSocket accepting();
	}
	
	
	version(Tango)
		private const bool _IS_TANGO = true;
	else
		private const bool _IS_TANGO = false;
	
	static if(_IS_TANGO && is(typeof(&this.detach)))
	{
		override void detach();
	}
	else
	{
		override void close();
	}
	
	
	override bool blocking() ;
	
	
	override void blocking(bool byes) ;
}


///
class AsyncTcpSocket: AsyncSocket // docmain
{
	///
	this(AddressFamily family);
	
	/// ditto
	this();
	
	/// ditto
	// Shortcut.
	this(Address connectTo, EventType events, RegisterEventCallback eventCallback);
}


///
class AsyncUdpSocket: AsyncSocket // docmain
{
	///
	this(AddressFamily family);
	
	/// ditto
	this();
}


/+
private class GetHostWaitHandle: WaitHandle
{
	this(HANDLE h);
	
	final:
	
	alias WaitHandle.handle handle; // Overload.
	
	override void handle(HANDLE h) ;
	
	override void close();
	
	
	private void _gotEvent();
}


private class GetHostAsyncResult, IAsyncResult
{
	this(HANDLE h, GetHostCallback callback);
	
	
	WaitHandle asyncWaitHandle();
	
	bool completedSynchronously() ;
	
	bool isCompleted() ;
	
	private:
	GetHostWaitHandle wh;
	GetHostCallback callback;
	
	
	void _gotEvent(LPARAM lparam);
}
+/


private void _getHostErr();

private class _InternetHost: DInternetHost
{
	private:
	this(void* hostentBytes);
}


///
// If -err- is nonzero, it is a winsock error code and -inetHost- is null.
alias void delegate(DInternetHost inetHost, int err) GetHostCallback;


///
class GetHost // docmain
{
	///
	void cancel();
	
	private:
	HANDLE h;
	GetHostCallback callback;
	ubyte[/+MAXGETHOSTSTRUCT+/ 1024] hostentBytes;
	
	
	void _gotEvent(LPARAM lparam);
	
	this();
}


///
GetHost asyncGetHostByName(Dstring name, GetHostCallback callback);

///
GetHost asyncGetHostByAddr(uint32_t addr, GetHostCallback callback);
/// ditto
// Shortcut.
GetHost asyncGetHostByAddr(Dstring addr, GetHostCallback callback);
///
class SocketQueue // docmain
{
	///
	this(Socket sock);
	///
	final Socket socket();
	
	///
	void reset();
	
	/+
	// DMD 0.92 says error: function toString overrides but is not covariant with toString
	override Dstring toString();
	+/
	
	
	///
	void[] peek();
	
	/// ditto
	void[] peek(uint len);
	
	
	///
	void[] receive();
	
	/// ditto
	void[] receive(uint len);
	
	///
	void send(void[] buf);
	///
	// Number of bytes in send queue.
	uint sendBytes() ;
	
	///
	// Number of bytes in recv queue.
	uint receiveBytes() ;
	
	///
	// Same signature as RegisterEventCallback for simplicity.
	void event(Socket _sock, EventType type, int err);
	
	///
	// Call on a read event so that incoming data may be buffered.
	void readEvent();
	
	///
	// Call on a write event so that buffered outgoing data may be sent.
	void writeEvent();
	
	deprecated
	{
		alias receiveBytes recvBytes;
		alias receive recv;
	}
	
	
	private:
	ubyte[] writebuf;
	ubyte[] readbuf;
	uint rpos;
	Socket sock;
	//bool canwrite = false;
	
	
	bool canwrite() ;
}


private:

struct EventInfo
{
	Socket sock;
	RegisterEventCallback callback;
}


const UINT WM_DFL_NETEVENT = WM_USER + 104;
const UINT WM_DFL_HOSTEVENT = WM_USER + 105;
const Dstring NETEVENT_CLASSNAME = "DFL_NetEvent";

EventInfo[socket_t] allEvents;
GetHost[HANDLE] allGetHosts;
HWND hwNet;


extern(Windows) LRESULT netWndProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam);

void _init();

} // Not WINE.


