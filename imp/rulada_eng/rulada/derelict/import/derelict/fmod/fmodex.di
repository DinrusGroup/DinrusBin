// D import file generated from 'fmodex.d'
module derelict.fmod.fmodex;
public 
{
    import derelict.fmod.fmodextypes;
    import derelict.fmod.fmodexfuncs;
}
private import derelict.util.loader2;

class DerelictFMODEXLoader : SharedLibLoader
{
    public 
{
    this()
{
super("fmodex.dll","libfmodex.so","");
}
    protected override void loadSymbols();


}
}
DerelictFMODEXLoader DerelictFMODEX;
static this();
