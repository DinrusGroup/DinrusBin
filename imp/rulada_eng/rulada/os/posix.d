module os.posix;
version (linux){ public import rt.core.os.linux;}
else version (OSX)
{ public import rt.core.os.linux;}
else version (FreeBSD)
{  public import rt.core.os.freebsd;}
else version (Solaris)
{    public import rt.core.os.solaris;}
else
{    static assert(0);}

