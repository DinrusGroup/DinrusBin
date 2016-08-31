// D import file generated from 'sfuncs.d'
module derelict.sfml.sfuncs;
private 
{
    import derelict.util.compat;
    import derelict.sfml.stypes;
}
extern (C) mixin(gsharedString!() ~ "\x0a    // Clock.h\x0a    sfClock* function() sfClock_Create;\x0a    void function(sfClock*) sfClock_Destroy;\x0a    float function(sfClock*) sfClock_GetTime;\x0a    void function(sfClock*) sfClock_Reset;\x0a\x0a    // Mutex.h\x0a    sfMutex* function() sfMutex_Create;\x0a    void function(sfMutex*) sfMutex_Destroy;\x0a    void function(sfMutex*) sfMutex_Lock;\x0a    void function(sfMutex*) sfMutex_Unlock;\x0a\x0a    // Rendomizer.h\x0a    void function(uint) sfRandom_SetSeed;\x0a    uint function() sfRandom_GetSeed;\x0a    float function(float, float) sfRandom_Float;\x0a    int function(int, int) sfRandom_Int;\x0a\x0a    // Sleep\x0a    void function(float) sfSleep;\x0a\x0a    // Thread.h\x0a    sfThread* function(void (*Function)(void*), void*) sfThread_Create;\x0a    void function(sfThread*) sfThread_Destroy;\x0a    void function(sfThread*) sfThread_Launch;\x0a    void function(sfThread*) sfThread_Wait;\x0a    void function(sfThread*) sfThread_Terminate;\x0a    ");

