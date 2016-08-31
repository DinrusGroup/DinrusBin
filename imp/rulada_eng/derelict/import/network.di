// D import file generated from 'network.d'
module derelict.sfml.network;
public 
{
    import derelict.sfml.ntypes;
    import derelict.sfml.nfuncs;
}
private import derelict.util.loader2;

class DerelictSFMLNetworkLoader : SharedLibLoader
{
    public 
{
    this()
{
super("csfml-network.dll","libcsfml-network.so","");
}
    protected override void loadSymbols();


}
}
DerelictSFMLNetworkLoader DerelictSFMLNetwork;
static this();
