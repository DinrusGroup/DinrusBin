/*
	Copyright (C) 2004 Christopher E. Miller
	
	This software is provided 'as-is', without any express or implied
	warranty.  In no event will the authors be held liable for any damages
	arising from the use of this software.
	
	Permission is granted to anyone to use this software for any purpose,
	including commercial applications, and to alter it and redistribute it
	freely, subject to the following restrictions:
	
	1. The origin of this software must not be misrepresented; you must not
	   claim that you wrote the original software. If you use this software
	   in a product, an acknowledgment in the product documentation would be
	   appreciated but is not required.
	2. Altered source versions must be plainly marked as such, and must not be
	   misrepresented as being the original software.
	3. This notice may not be removed or altered from any source distribution.
*/

/**************
 * <b>SocketStream</b> is a stream for a blocking,
 * connected <b>Socket</b>.
 *
 * For Win32 systems, link with <tt>ws2_32.lib</tt>.
 *
 * Пример:
 *	See <tt>/dmd/samples/d/htmlget.d</tt>
 * Authors: Christopher E. Miller
 * Ссылки:
 *	$(LINK2 std_stream.html, std.stream)
 * Macros: WIKI=Phobos/StdSocketstream
 */

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
	this(Socket sock, FileMode mode);
	
	/**
	 * Uses mode <b>FileMode.In | FileMode.Out</b>.
	 */
	this(Socket sock);
	
	/**
	 * Property to get the <b>Socket</b> that is being streamed.
	 */
	Socket socket();
	
	/**
	 * Attempts to read the entire block, waiting if necessary.
	 */
	override size_t readBlock(void* _buffer, size_t size);
	
	/**
	 * Attempts to write the entire block, waiting if necessary.
	 */
	override size_t writeBlock(void* _buffer, size_t size);
	
	/**
	 *
	 */
	override ulong seek(long offset, SeekPos whence);
	/**
	 * Does not return the entire stream because that would
	 * require the remote connection to be closed.
	 */
	override char[] toString();
	/**
	 * Close the <b>Socket</b>.
	 */
	override void close();
}

