
module rt.core.os.pos.pthread;

version (linux)
{
    public import rt.core.os.lin.pthread;
}
else version (OSX)
{
    // We really should separate osx out from linux
    public import rt.core.os.lin.pthread;
}
else version (FreeBSD)
{
    public import rt.core.os.bsd.pthread;
}
else version (Solaris)
{
    public import rt.core.os.sol.pthread;
}
else
{
    static assert(0);
}

