/***********************************************************************\
*                                 rpc.d                                 *
*                                                                       *
*                       Windows API header module                       *
*                                                                       *
*                 Translated from MinGW Windows headers                 *
*                                                                       *
*                       Placed into public domain                       *
\***********************************************************************/
module os.win32.rpc;

/* Moved to rpcdecp (duplicate definition).
	typedef void *I_RPC_HANDLE;
	alias long RPC_STATUS;
	// Moved to rpcdce:
	RpcImpersonateClient
	RpcRevertToSelf
*/

public import os.win32.unknwn;
public import os.win32.rpcdce;  // also pulls in rpcdcep
public import os.win32.rpcnsi;
public import os.win32.rpcnterr;
public import os.win32.winerror;

alias MIDL_user_allocate midl_user_allocate;
alias MIDL_user_free midl_user_free;

extern (Windows) {
	int I_RpcMapWin32Status(RPC_STATUS);
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win32");
        } else version (DigitalMars) {
            pragma(link, "auxC");
        } else {
            pragma(link, "DO-win32");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win32");
        } else version (DigitalMars) {
            pragma(link, "auxC");
        } else {
            pragma(link, "DO-win32");
        }
    }
}
