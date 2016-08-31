// D import file generated from 'graphics.d'
module derelict.sfml.graphics;
public 
{
    import derelict.sfml.gtypes;
    import derelict.sfml.gfuncs;
}
private import derelict.util.loader2;

class DerelictSFMLGraphicsLoader : SharedLibLoader
{
    public 
{
    this()
{
super("csfml-graphics.dll","libcsfml-graphics.so","");
}
    protected override void loadSymbols();


}
}
DerelictSFMLGraphicsLoader DerelictSFMLGraphics;
static this();
