module lib.sdlnet;

private
{
 import stdrus, lib.sdl;
pragma(lib,"dinrus.lib");
}


private проц грузи(Биб биб)
{
    вяжи(SDLNet_Linked_Version)("SDLNet_Linked_Version", биб);
    вяжи(SDLNet_Init)("SDLNet_Init", биб);
    вяжи(SDLNet_Quit)("SDLNet_Quit", биб);
    вяжи(SDLNet_ResolveHost)("SDLNet_ResolveHost", биб);
    вяжи(SDLNet_ResolveIP)("SDLNet_ResolveIP", биб);
    вяжи(SDLNet_TCP_Open)("SDLNet_TCP_Open", биб);
    вяжи(SDLNet_TCP_Accept)("SDLNet_TCP_Accept", биб);
    вяжи(SDLNet_TCP_GetPeerAddress)("SDLNet_TCP_GetPeerAddress", биб);
    вяжи(SDLNet_TCP_Send)("SDLNet_TCP_Send", биб);
    вяжи(SDLNet_TCP_Recv)("SDLNet_TCP_Recv", биб);
    вяжи(SDLNet_TCP_Close)("SDLNet_TCP_Close", биб);
    вяжи(SDLNet_AllocPacket)("SDLNet_AllocPacket", биб);
    вяжи(SDLNet_ResizePacket)("SDLNet_ResizePacket", биб);
    вяжи(SDLNet_FreePacket)("SDLNet_FreePacket", биб);
    вяжи(SDLNet_AllocPacketV)("SDLNet_AllocPacketV", биб);
    вяжи(SDLNet_FreePacketV)("SDLNet_FreePacketV", биб);
    вяжи(SDLNet_UDP_Open)("SDLNet_UDP_Open", биб);
    вяжи(SDLNet_UDP_Bind)("SDLNet_UDP_Bind", биб);
    вяжи(SDLNet_UDP_Unbind)("SDLNet_UDP_Unbind", биб);
    вяжи(SDLNet_UDP_GetPeerAddress)("SDLNet_UDP_GetPeerAddress", биб);
    вяжи(SDLNet_UDP_SendV)("SDLNet_UDP_SendV", биб);
    вяжи(SDLNet_UDP_Send)("SDLNet_UDP_Send", биб);
    вяжи(SDLNet_UDP_RecvV)("SDLNet_UDP_RecvV", биб);
    вяжи(SDLNet_UDP_Recv)("SDLNet_UDP_Recv", биб);
    вяжи(SDLNet_UDP_Close)("SDLNet_UDP_Close", биб);
    вяжи(SDLNet_AllocSocketSet)("SDLNet_AllocSocketSet", биб);
    вяжи(SDLNet_AddSocket)("SDLNet_AddSocket", биб);
    вяжи(SDLNet_DelSocket)("SDLNet_DelSocket", биб);
    вяжи(SDLNet_CheckSockets)("SDLNet_CheckSockets", биб);
    вяжи(SDLNet_FreeSocketSet)("SDLNet_FreeSocketSet", биб);
}

ЖанБибгр СДЛНет;
static this() {
    СДЛНет.заряжай( "SDL_net.dll", &грузи  );
	СДЛНет.загружай();
}

enum : Uint8
{
    SDL_NET_MAJOR_VERSION           = 1,
    SDL_NET_MINOR_VERSION           = 2,
    SDL_NET_PATCHLEVEL              = 7,
}

struct IPaddress
{
    Uint32 host;
    Uint16 port;
}

typedef void* TCPsocket;

enum : uint
{
    INADDR_ANY              = 0x00000000,
    INADDR_NONE             = 0xFFFFFFFF,
    INADDR_BROADCAST        = 0xFFFFFFFF,
    SDLNET_MAX_UDPCHANNELS  = 32,
    SDLNET_MAX_UDPADDRESSES = 4,
}

typedef void* UDPsocket;

struct UDPpacket
{
    int channel;
    Uint8 *data;
    int len;
    int maxlen;
    int status;
    IPaddress address;
}

typedef void* SDLNet_SocketSet;

struct _SDLNet_GenericSocket
{
    int готов;
}
alias _SDLNet_GenericSocket* SDLNet_GenericSocket;

alias сдлУстановиОш SDLNet_SetError;
alias сдлДайОш SDLNet_GetError;

void SDL_NET_VERSION(SDL_version* X)
{
    X.major = SDL_NET_MAJOR_VERSION;
    X.minor = SDL_NET_MINOR_VERSION;
    X.patch = SDL_NET_PATCHLEVEL;
}

int SDLNet_TCP_AddSocket(SDLNet_SocketSet set, TCPsocket sock)
{
    return SDLNet_AddSocket(set, cast(SDLNet_GenericSocket)sock);
}

int SDLNet_TCP_DelSocket(SDLNet_SocketSet set, TCPsocket sock)
{
    return SDLNet_DelSocket(set, cast(SDLNet_GenericSocket)sock);
}

int SDLNet_UDP_AddSocket(SDLNet_SocketSet set, UDPsocket sock)
{
    return SDLNet_AddSocket(set, cast(SDLNet_GenericSocket)sock);
}

int SDLNet_UDP_DelSocket(SDLNet_SocketSet set, UDPsocket sock)
{
    return SDLNet_DelSocket(set, cast(SDLNet_GenericSocket)sock);
}

bool SDLNet_SocketReady(TCPsocket sock)
{
    return cast(bool)((sock !is null) && (cast(SDLNet_GenericSocket)sock).готов);
}

bool SDLNet_SocketReady(UDPsocket sock)
{
    return cast(bool)((sock !is null) && (cast(SDLNet_GenericSocket)sock).готов);
}

void SDLNet_Write16(Uint16 value, void* areap)
{
    Uint16* areap16 = cast(Uint16*)areap;
    *areap16 = сдлРазвербитБЕ16(value);
}

Uint16 SDLNet_Read16(void *areap)
{
    Uint16* areap16 = cast(Uint16*)areap;
    return сдлРазвербитБЕ16(*areap16);
}

void SDLNet_Write32(Uint32 value, void* areap)
{
    Uint32* areap32 = cast(Uint32*)areap;
    *areap32 = сдлРазвербитБЕ16(value);
}

Uint32 SDLNet_Read32(void* areap)
{
    Uint32* areap32 = cast(Uint32*)areap;
    return сдлРазвербитБЕ16(*areap32);
}

extern(C)
{
    SDL_version* function() SDLNet_Linked_Version;
    int function() SDLNet_Init;
    void function() SDLNet_Quit;
    int function(IPaddress*, char*, Uint16) SDLNet_ResolveHost;
    char* function(IPaddress*) SDLNet_ResolveIP;
    TCPsocket function(IPaddress*) SDLNet_TCP_Open;
    TCPsocket function(TCPsocket) SDLNet_TCP_Accept;
    IPaddress* function(TCPsocket) SDLNet_TCP_GetPeerAddress;
    int function(TCPsocket,void*,int) SDLNet_TCP_Send;
    int function(TCPsocket,void*,int) SDLNet_TCP_Recv;
    void function(TCPsocket) SDLNet_TCP_Close;
    UDPpacket* function(int) SDLNet_AllocPacket;
    int function(UDPpacket*) SDLNet_ResizePacket;
    void function(UDPpacket*) SDLNet_FreePacket;
    UDPpacket** function(int,int) SDLNet_AllocPacketV;
    void function(UDPpacket**) SDLNet_FreePacketV;
    UDPsocket function(Uint16) SDLNet_UDP_Open;
    int function(UDPsocket,int,IPaddress*) SDLNet_UDP_Bind;
    void function(UDPsocket,int) SDLNet_UDP_Unbind;
    IPaddress* function(UDPsocket,int) SDLNet_UDP_GetPeerAddress;
    int function(UDPsocket,UDPpacket**,int) SDLNet_UDP_SendV;
    int function(UDPsocket,int,UDPpacket*) SDLNet_UDP_Send;
    int function(UDPsocket,UDPpacket**) SDLNet_UDP_RecvV;
    int function(UDPsocket,UDPpacket*) SDLNet_UDP_Recv;
    void function(UDPsocket) SDLNet_UDP_Close;
    SDLNet_SocketSet function(int) SDLNet_AllocSocketSet;
    int function(SDLNet_SocketSet,SDLNet_GenericSocket) SDLNet_AddSocket;
    int function(SDLNet_SocketSet,SDLNet_GenericSocket) SDLNet_DelSocket;
    int function(SDLNet_SocketSet,Uint32) SDLNet_CheckSockets;
    void function(SDLNet_SocketSet) SDLNet_FreeSocketSet;
}
