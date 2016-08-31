
module rt.core.os.pos.socket;

version (linux)
{
    public import rt.core.os.lin.socket;
}
else version (OSX)
{
    // We really should separate osx out from linux
    public import rt.core.os.lin.socket;
}
else version (FreeBSD)
{
    public import rt.core.os.bsd.socket;
}
else version (Solaris)
{
    public import rt.core.os.sol.socket;
}
else
{
    static assert(0);
}

