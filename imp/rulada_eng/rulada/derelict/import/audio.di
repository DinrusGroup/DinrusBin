// D import file generated from 'audio.d'
module derelict.sfml.audio;
public 
{
    import derelict.sfml.atypes;
    import derelict.sfml.afuncs;
}
private import derelict.util.loader2;

class DerelictSFMLAudioLoader : SharedLibLoader
{
    public 
{
    this()
{
super("csfml-audio.dll","libcsfml-audio.so","");
}
    protected override void loadSymbols();


}
}
DerelictSFMLAudioLoader DerelictSFMLAudio;
static this();
