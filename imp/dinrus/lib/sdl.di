module lib.sdl;
import stdrus, cidrus;
pragma(lib,"dinrus.lib");

alias char* CCPTR;
alias шим* CWCPTR;
alias dchar* CDCPTR;
alias ббайт* CUBPTR;
alias ук CVPTR;
alias char* ICPTR;

alias UINT WPARAM;
alias LONG LPARAM;

alias ubyte Uint8;
alias byte Sint8;
alias ushort Uint16;
alias short Sint16;
alias uint Uint32;
alias int Sint32;
alias ulong Uint64;
alias long Sint64;

const bit СГЛАЖИВАНИЕ_ВЫКЛ = 0;
const bit СГЛАЖИВАНИЕ_ВКЛ  = 1;

проц грузи(Биб биб)
{
    // active.d
    вяжи(сдлДайСостПрил)("SDL_GetAppState", биб);
    // audio.d
    вяжи(сдлВклАудио)("SDL_AudioInit", биб);
    вяжи(сдлВыклАудио)("SDL_AudioQuit", биб);
    вяжи(сдлИмяАудиоДрайвера)("SDL_AudioDriverName", биб);
    вяжи(сдлОткрытьАудио)("SDL_OpenAudio", биб);
    вяжи(сдлСтатусАудио)("SDL_GetAudioStatus", биб);
    вяжи(сдлАудиоПауза)("SDL_PauseAudio", биб);
    вяжи(сдлЗагрузиВав_РВ)("SDL_LoadWAV_RW", биб);
    вяжи(сдлОсвободиВав)("SDL_FreeWAV", биб);
    вяжи(сдлПостройАудиоКонверт)("SDL_BuildAudioCVT", биб);
    вяжи(сдлПреобразуйАудио)("SDL_ConvertAudio", биб);
    вяжи(сдлАудиоМикс)("SDL_MixAudio", биб);
    вяжи(сдлБлокируйАудио)("SDL_LockAudio", биб);
    вяжи(сдлРазблокируйАудио)("SDL_UnlockAudio", биб);
    вяжи(сдлЗакройАудио)("SDL_CloseAudio", биб);
    // cdrom.d
    вяжи(сдлЧлоКдДрайвов)("SDL_CDNumDrives", биб);
    вяжи(сдлИмяКд)("SDL_CDName", биб);
    вяжи(сдлОткройКд)("SDL_CDOpen", биб);
    вяжи(сдлСтатусКд)("SDL_CDStatus", биб);
    вяжи(сдлИграйДорожкиКд)("SDL_CDPlayTracks", биб);
    вяжи(сдлИграйКд)("SDL_CDPlay", биб);
    вяжи(сдлКдПауза)("SDL_CDPause", биб);
    вяжи(сдлКдВозобнови)("SDL_CDResume", биб);
    вяжи(сдлКдСтоп)("SDL_CDStop", биб);
    вяжи(сдлКдВынь)("SDL_CDEject", биб);
    вяжи(сдлКдЗакрой)("SDL_CDClose", биб);
    // cpuinfo.d
    вяжи(сдлЕстьРДТСЦ)("SDL_HasRDTSC", биб);
    вяжи(сдлЕстьММЭкс)("SDL_HasMMX", биб);
    вяжи(сдлЕстьММЭксЭкст)("SDL_HasMMXExt", биб);
    вяжи(сдлЕсть3ДНау)("SDL_Has3DNow", биб);
    вяжи(сдлЕсть3ДНауЭкст)("SDL_Has3DNowExt", биб);
    вяжи(сдлЕстьССЭ)("SDL_HasSSE", биб);
    вяжи(сдлЕстьССЭ2)("SDL_HasSSE2", биб);
    вяжи(сдлЕстьАльтиВек)("SDL_HasAltiVec", биб);
    // error.d
    вяжи(сдлУстановиОш)("SDL_SetError", биб);
    вяжи(сдлДайОш)("SDL_GetError", биб);
    вяжи(сдлСотриОш)("SDL_ClearError", биб);
    // events.d
    вяжи(сдлСобыПамп)("SDL_PumpEvents", биб);
    вяжи(сдлСобыПип)("SDL_PeepEvents", биб);
    вяжи(сдлСобПолл)("SDL_PollEvent", биб);
    вяжи(сдлСобЖдать)("SDL_WaitEvent", биб);
    вяжи(сдлСобПуш)("SDL_PushEvent", биб);
    вяжи(сдлУстановиФильтрСоб)("SDL_SetEventFilter", биб);
    вяжи(сдлДайФильтрСоб)("SDL_GetEventFilter", биб);
    вяжи(сдлСостСоб)("SDL_EventState", биб);
    // joystick.d
    вяжи(сдлЧлоДжойстов)("SDL_NumJoysticks", биб);
    вяжи(сдлИмяДжойста)("SDL_JoystickName", биб);
    вяжи(сдлДжойстОткрой)("SDL_JoystickOpen", биб);
    вяжи(сдлДжойстОткрыт)("SDL_JoystickOpened", биб);
    вяжи(сдлИндексДжойста)("SDL_JoystickIndex", биб);
    вяжи(сдлЧлоОсейДжойста)("SDL_JoystickNumAxes", биб);
    вяжи(сдлЧлоШаровДжойста)("SDL_JoystickNumBalls", биб);
    вяжи(сдлЧлоШляпокДжойста)("SDL_JoystickNumHats", биб);
    вяжи(сдлЧлоКнопокДжойста)("SDL_JoystickNumButtons", биб);
    вяжи(сдлДжойстОбнови)("SDL_JoystickUpdate", биб);
    вяжи(сдлСостСобДжойста)("SDL_JoystickEventState", биб);
    вяжи(сдлДайОсьДжойста)("SDL_JoystickGetAxis", биб);
    вяжи(сдлДайШляпкуДжойста)("SDL_JoystickGetHat", биб);
    вяжи(сдлДайШарДжойста)("SDL_JoystickGetBall", биб);
    вяжи(сдлДайКнопкуДжойста)("SDL_JoystickGetButton", биб);
    вяжи(сдлЗакройДжойст)("SDL_JoystickClose", биб);
    // keyboard.d
    вяжи(сдлВключиЮ)("SDL_EnableUNICODE", биб);
    вяжи(сдлВключиПовторКл)("SDL_EnableKeyRepeat", биб);
    вяжи(сдлДайПовторКл)("SDL_GetKeyRepeat", биб);
    вяжи(сдлДайСостКл)("SDL_GetKeyState", биб);
    вяжи(сдлДайСостМод)("SDL_GetModState", биб);
    вяжи(сдлУстановиСостМод)("SDL_SetModState", биб);
    вяжи(сдлДайИмяКл)("SDL_GetKeyName", биб);
    // loadso.d
    вяжи(сдлЗагрузиОбъект)("SDL_LoadObject", биб);
    вяжи(сдлЗагрузиФункц)("SDL_LoadFunction", биб);
    вяжи(сдлВыгрузиОбъект)("SDL_UnloadObject", биб);
    // mouse.d
    вяжи(сдлДайСостМыши)("SDL_GetMouseState", биб);
    вяжи(сдлДайОтноситСостМыши)("SDL_GetRelativeMouseState", биб);
    вяжи(сдлВарпМышь)("SDL_WarpMouse", биб);
    вяжи(сдлСоздайКурсор)("SDL_CreateCursor", биб);
    вяжи(сдлУстановиКурсор)("SDL_SetCursor", биб);
    вяжи(сдлДайКурсор)("SDL_GetCursor", биб);
    вяжи(сдлОсвободиКурсор)("SDL_FreeCursor", биб);
    вяжи(сдлПокажиКурсор)("SDL_ShowCursor", биб);
    // mutex.d
    вяжи(сдлСоздайМютекс)("SDL_CreateMutex", биб);
    вяжи(сдлМютексП)("SDL_mutexP", биб);
    вяжи(сдлМютексВ)("SDL_mutexV", биб);
    вяжи(сдлУдалиМютекс)("SDL_DestroyMutex", биб);
    вяжи(сдлСоздайСемафор)("SDL_CreateSemaphore", биб);
    вяжи(сдлУдалиСемафор)("SDL_DestroySemaphore", биб);
    вяжи(сдлСемЖди)("SDL_SemWait", биб);
    вяжи(сдлСемПробуйЖди)("SDL_SemTryWait", биб);
    вяжи(сдлСемЖдиТаймаут)("SDL_SemWaitTimeout", биб);
    вяжи(сдлСемПост)("SDL_SemPost", биб);
    вяжи(сдлСемЗнач)("SDL_SemValue", биб);
    вяжи(сдлСоздайУслов)("SDL_CreateCond", биб);
    вяжи(сдлУдалиУслов)("SDL_DestroyCond", биб);
    вяжи(сдлУсловСигнал)("SDL_CondSignal", биб);
    вяжи(сдлУсловВещан)("SDL_CondBroadcast", биб);
    вяжи(сдлУсловЖди)("SDL_CondWait", биб);
    вяжи(сдлУсловЖдиТаймаут)("SDL_CondWaitTimeout", биб);
    // rwops.d
    вяжи(сдлЧЗИзФайла)("SDL_RWFromFile", биб);
    вяжи(сдлЧЗИзФП)("SDL_RWFromFP", биб);
    вяжи(сдлЧЗИзПам)("SDL_RWFromMem", биб);
    вяжи(сдлЧЗИзКонстПам)("SDL_RWFromConstMem", биб);
    вяжи(сдлРазместиЧЗ)("SDL_AllocRW", биб);
    вяжи(сдлОсвободиЧЗ)("SDL_FreeRW", биб);
    вяжи(сдлЧитайЛЭ16)("SDL_ReadLE16", биб);
    вяжи(сдлЧитайБЭ16)("SDL_ReadBE16", биб);
    вяжи(сдлЧитайЛЭ32)("SDL_ReadLE32", биб);
    вяжи(сдлЧитайБЭ32)("SDL_ReadBE32", биб);
    вяжи(сдлЧитайЛЭ64)("SDL_ReadLE64", биб);
    вяжи(сдлЧитайБЭ64)("SDL_ReadBE64", биб);
    вяжи(сдлПишиЛЭ16)("SDL_WriteLE16", биб);
    вяжи(сдлПишиБЭ16)("SDL_WriteBE16", биб);
    вяжи(сдлПишиЛЭ32)("SDL_WriteLE32", биб);
    вяжи(сдлПишиБЭ32)("SDL_WriteBE32", биб);
    вяжи(сдлПишиЛЭ64)("SDL_WriteLE64", биб);
    вяжи(сдлПишиБЭ64)("SDL_WriteBE64", биб);
    // sdlversion.d
    вяжи(сдлЛинкВерсия)("SDL_Linked_Version", биб);
    // thread.d
    вяжи(сдлТяниНить)("SDL_CreateThread", биб);
    вяжи(сдлИДНити)("SDL_ThreadID", биб);
    вяжи(сдлДайИДНити)("SDL_GetThreadID", биб);
    вяжи(сдлЖдиНить)("SDL_WaitThread", биб);
    вяжи(сдлРвиНить)("SDL_KillThread", биб);
    // timer.d
    вяжи(сдлДайТики)("SDL_GetTicks", биб);
    вяжи(сдлЗадержка)("SDL_Delay", биб);
    вяжи(сдлУстановиТаймер)("SDL_SetTimer", биб);
    вяжи(сдлДобавьТаймер)("SDL_AddTimer", биб);
    вяжи(сдлУдалиТаймер)("SDL_RemoveTimer", биб);
    // video.d
    вяжи(сдлВклВидео)("SDL_VideoInit", биб);
    вяжи(сдлВыклВидео)("SDL_VideoQuit", биб);
    вяжи(сдлИмяВидеоДрайвера)("SDL_VideoDriverName", биб);
    вяжи(сдлДайВидеоПоверхность)("SDL_GetVideoSurface", биб);
    вяжи(сдлДайИнфОВидео)("SDL_GetVideoInfo", биб);
    вяжи(сдлВидеоРежимОК)("SDL_VideoModeOK", биб);
    вяжи(сдлСписокРежимов)("SDL_ListModes", биб);
    вяжи(сдлУстановиВидеоРежим)("SDL_SetVideoMode", биб);
    вяжи(сдлОбновиПрямоуги)("SDL_UpdateRects", биб);
    вяжи(сдлОбновиПрямоуг)("SDL_UpdateRect", биб);
    вяжи(сдлФлип)("SDL_Flip", биб);
    вяжи(сдлУстановиГамму)("SDL_SetGamma", биб);
    вяжи(сдлУстановиРампуГаммы)("SDL_SetGammaRamp", биб);
    вяжи(сдлДайРампуГаммы)("SDL_GetGammaRamp", биб);
    вяжи(сдлУстановиЦвета)("SDL_SetColors", биб);
    вяжи(сдлУстановиПалитру)("SDL_SetPalette", биб);
    вяжи(сдлКартируйКЗС)("SDL_MapRGB", биб);
    вяжи(сдлКартируйКЗСА)("SDL_MapRGBA", биб);
    вяжи(сдлДайКЗС)("SDL_GetRGB", биб);
    вяжи(сдлДайКЗСА)("SDL_GetRGBA", биб);
    вяжи(сдлСоздайКЗСПоверхность)("SDL_CreateRGBSurface", биб);
    вяжи(сдлСоздайКЗСПоверхностьИз)("SDL_CreateRGBSurfaceFrom", биб);
    вяжи(сдлОсвободиПоверхность)("SDL_FreeSurface", биб);
    вяжи(сдлБлокируйПоверхность)("SDL_LockSurface", биб);
    вяжи(сдлРазблокируйПоверхность)("SDL_UnlockSurface", биб);
    вяжи(сдлЗагрузиБМП_ЧЗ)("SDL_LoadBMP_RW", биб);
    вяжи(сдлСохраниБМП_ЧЗ)("SDL_SaveBMP_RW", биб);
    вяжи(сдлУстановиКлючЦвета)("SDL_SetColorKey", биб);
    вяжи(сдлУстановиАльфу)("SDL_SetAlpha", биб);
    вяжи(сдлУстановиПрямоугОбрезки)("SDL_SetClipRect", биб);
    вяжи(сдлДайПрямоугОбрезки)("SDL_GetClipRect", биб);
    вяжи(сдлПреобразуйПоверхность)("SDL_ConvertSurface", биб);
    вяжи(сдлВерхнийБлит)("SDL_UpperBlit", биб);
    вяжи(сдлНижнийБлит)("SDL_LowerBlit", биб);
    вяжи(сдлЗаполниПрямоуг)("SDL_FillRect", биб);
    вяжи(сдлПоказФормат)("SDL_DisplayFormat", биб);
    вяжи(сдлПоказФорматАльфа)("SDL_DisplayFormatAlpha", биб);
    вяжи(сдлСоздайЮВНакладку)("SDL_CreateYUVOverlay", биб);
    вяжи(сдлБлокируйЮВНакладку)("SDL_LockYUVOverlay", биб);
    вяжи(сдлРазблокируйЮВНакладку)("SDL_UnlockYUVOverlay", биб);
    вяжи(сдлПокажиЮВНакладку)("SDL_DisplayYUVOverlay", биб);
    вяжи(сдлОсвободиЮВНакладку)("SDL_FreeYUVOverlay", биб);
    вяжи(сдлГлЗагрузи)("SDL_GL_LoadLibrary", биб);
    вяжи(сдлГлАдресПроц)("SDL_GL_GetProcAddress", биб);
    вяжи(сдлГлУстановиАтриб)("SDL_GL_SetAttribute", биб);
    вяжи(сдлГлДайАтриб)("SDL_GL_GetAttribute", биб);
    вяжи(сдлГлОбменяйБуферы)("SDL_GL_SwapBuffers", биб);
    вяжи(сдлГлОбновиПрямоуги)("SDL_GL_UpdateRects", биб);
    вяжи(сдлГлБлокируй)("SDL_GL_Lock", биб);
    вяжи(сдлГлРазблокируй)("SDL_GL_Unlock", биб);
    вяжи(сдлОкУстановиЗаг)("SDL_WM_SetCaption", биб);
    вяжи(сдлОкДайЗаг)("SDL_WM_GetCaption", биб);
    вяжи(сдлОкУстановиПикт)("SDL_WM_SetIcon", биб);
    вяжи(сдлОкСверни)("SDL_WM_IconifyWindow", биб);
    вяжи(сдлОкРазверни)("SDL_WM_ToggleFullScreen", биб);
    вяжи(сдлОкЗахватиВвод)("SDL_WM_GrabInput", биб);
    // sdl.d
    вяжи(сдлВкл)("SDL_Init", биб);
    вяжи(сдлВклПодсист)("SDL_InitSubSystem", биб);
    вяжи(сдлВыклПодсист)("SDL_QuitSubSystem", биб);
    вяжи(сдлВключен)("SDL_WasInit", биб);
    вяжи(сдлВыход)("SDL_Quit", биб);

    // syswm.d
    version(Windows)
        вяжи(сдлДайИнфОбОк)("SDL_GetWMInfo", биб);
}

ЖанБибгр СДЛ;

extern(C)
{

цел зумПоверхностиКЗСА (ПоверхностьСДЛ * src, ПоверхностьСДЛ * dst, цел smooth);
цел зумПоверхностиВ (ПоверхностьСДЛ * src, ПоверхностьСДЛ * dst);
проц трансформПоверхностиКЗСА (ПоверхностьСДЛ * src, ПоверхностьСДЛ * dst, цел cx, цел cy, цел isin, цел icos, цел smooth);
проц трансформПоверхностиВ (ПоверхностьСДЛ * src, ПоверхностьСДЛ * dst, цел cx, цел cy, цел isin, цел icos);		 
ПоверхностьСДЛ *ротозумПоверхности (ПоверхностьСДЛ * src, double angle, double zoom, int smooth);
ПоверхностьСДЛ *зумПоверхности (ПоверхностьСДЛ * src, double zoomx, double zoomy, int smooth);
проц ЗумКартинки (ПоверхностьСДЛ * экран, ПоверхностьСДЛ * картинка, int smooth);
проц ВращайКартинку (ПоверхностьСДЛ * экран, ПоверхностьСДЛ * картинка, int rotate, int smooth);
проц  ОчистиЭкран (ПоверхностьСДЛ * экран);
проц ОбработайСобытие();

    // SDL.h
    цел function(бцел) сдлВкл;
    цел function(бцел) сдлВклПодсист;
    цел function(бцел) сдлВыклПодсист;
    цел function(бцел) сдлВключен;
    проц function() сдлВыход;

    // SDL_active.h
    ббайт function() сдлДайСостПрил;

    // SDL_audio.h
    цел function(ткст0) сдлВклАудио;
    проц function() сдлВыклАудио;
    ткст0 function(ткст0,цел) сдлИмяАудиоДрайвера;
    цел function(АудиоСпец*,АудиоСпец*) сдлОткрытьАудио;
    статус_аудио function() сдлСтатусАудио;
    проц function(цел) сдлАудиоПауза;
    АудиоСпец* function(ЧЗоперации*,цел,АудиоСпец*,ббайт**,бцел*) сдлЗагрузиВав_РВ;
    проц function(ббайт*) сдлОсвободиВав;
    цел function(АудиоКонверт*,бкрат,ббайт,цел,бкрат,ббайт,цел) сдлПостройАудиоКонверт;
    цел function(АудиоКонверт*) сдлПреобразуйАудио;
    проц function(ббайт*,ббайт*,бцел,цел) сдлАудиоМикс;
    проц function() сдлБлокируйАудио;
    проц function() сдлРазблокируйАудио;
    проц function() сдлЗакройАудио;

    АудиоСпец* сдлЗагрузиВав(сим *файл, АудиоСпец *спец, ббайт **буф, бцел *длин)
    {
        return сдлЗагрузиВав_РВ(сдлЧЗИзФайла(файл, "rb"), 1, спец, буф, длин);
    }

    // SDL_cdrom.h
    цел function() сдлЧлоКдДрайвов;
    ткст0 function(цел) сдлИмяКд;
    КД* function(цел) сдлОткройКд;
    статусКД function(КД*) сдлСтатусКд;
    цел function(КД*,цел,цел,цел,цел) сдлИграйДорожкиКд;
    цел function(КД*,цел,цел) сдлИграйКд;
    цел function(КД*) сдлКдПауза;
    цел function(КД*) сдлКдВозобнови;
    цел function(КД*) сдлКдСтоп;
    цел function(КД*) сдлКдВынь;
    цел function(КД*) сдлКдЗакрой;

    // SDL_cpuinfo.h
    бул function() сдлЕстьРДТСЦ;
    бул function() сдлЕстьММЭкс;
    бул function() сдлЕстьММЭксЭкст;
    бул function() сдлЕсть3ДНау;
    бул function() сдлЕсть3ДНауЭкст;
    бул function() сдлЕстьССЭ;
    бул function() сдлЕстьССЭ2;
    бул function() сдлЕстьАльтиВек;

    // SDL_error.h
    проц function(ткст0,...) сдлУстановиОш;
    ткст0 function() сдлДайОш;
    проц function() сдлСотриОш;

    // SDL_events.h
    проц function() сдлСобыПамп;
    цел function(SDL_Event*,цел,SDL_eventaction,бцел) сдлСобыПип;
    цел function(SDL_Event*) сдлСобПолл;
    цел function(SDL_Event*) сдлСобЖдать;
    цел function(SDL_Event*) сдлСобПуш;
    проц function(сдлФильтрСобытий) сдлУстановиФильтрСоб;
    сдлФильтрСобытий function() сдлДайФильтрСоб;
    ббайт function(ббайт,цел) сдлСостСоб;


    цел сдлЗапрошенВыход()
    {
        сдлСобыПамп();
        return сдлСобыПип(пусто, 0, SDL_PEEKEVENT, SDL_QUITMASK);
    }

    // SDL_joystick.h
    цел function() сдлЧлоДжойстов;
    ткст0 function(цел) сдлИмяДжойста;
    SDL_Joystick* function(цел) сдлДжойстОткрой;
    цел function(цел) сдлДжойстОткрыт;
    цел function(SDL_Joystick*) сдлИндексДжойста;
    цел function(SDL_Joystick*) сдлЧлоОсейДжойста;
    цел function(SDL_Joystick*) сдлЧлоШаровДжойста;
    цел function(SDL_Joystick*) сдлЧлоШляпокДжойста;
    цел function(SDL_Joystick*) сдлЧлоКнопокДжойста;
    проц function() сдлДжойстОбнови;
    цел function(цел) сдлСостСобДжойста;
    крат function(SDL_Joystick*,цел) сдлДайОсьДжойста;
    ббайт function(SDL_Joystick*,цел) сдлДайШляпкуДжойста;
    цел function(SDL_Joystick*,цел,цел*,цел*) сдлДайШарДжойста;
    ббайт function(SDL_Joystick*,цел) сдлДайКнопкуДжойста;
    проц function(SDL_Joystick*)сдлЗакройДжойст;

    // SDL_keyboard.h
    цел function(цел) сдлВключиЮ;
    цел function(цел,цел) сдлВключиПовторКл;
    проц function(цел*,цел*) сдлДайПовторКл;
    ббайт* function(цел*) сдлДайСостКл;
    SDLMod function() сдлДайСостМод;
    проц function(SDLMod) сдлУстановиСостМод;
    ткст0 function(SDLKey key) сдлДайИмяКл;

    // SDL_loadso.h
    ук function(ткст0) сдлЗагрузиОбъект;
    ук function(ук,ткст0) сдлЗагрузиФункц;
    проц function(ук) сдлВыгрузиОбъект;

    // SDL_mouse.h
    ббайт function(цел*,цел*) сдлДайСостМыши;
    ббайт function(цел*,цел*) сдлДайОтноситСостМыши;
    проц function(бкрат,бкрат) сдлВарпМышь;
    SDL_Cursor* function(ббайт*,ббайт*,цел,цел,цел,цел) сдлСоздайКурсор;
    проц function(SDL_Cursor*) сдлУстановиКурсор;
    SDL_Cursor* function() сдлДайКурсор;
    проц function(SDL_Cursor*) сдлОсвободиКурсор;
    цел function(цел) сдлПокажиКурсор;

    // SDL_mutex.h
    SDL_mutex* function() сдлСоздайМютекс;
    цел function(SDL_mutex*) сдлМютексП;
    цел function(SDL_mutex*) сдлМютексВ;
    проц function(SDL_mutex*) сдлУдалиМютекс;
    SDL_sem* function(бцел) сдлСоздайСемафор;
    проц function(SDL_sem*) сдлУдалиСемафор;
    цел function(SDL_sem*) сдлСемЖди;
    цел function(SDL_sem*) сдлСемПробуйЖди;
    цел function(SDL_sem*,бцел) сдлСемЖдиТаймаут;
    цел function(SDL_sem*) сдлСемПост;
    бцел function(SDL_sem*) сдлСемЗнач;
    SDL_cond* function() сдлСоздайУслов;
    проц function(SDL_cond*) сдлУдалиУслов;
    цел function(SDL_cond*) сдлУсловСигнал;
    цел function(SDL_cond*) сдлУсловВещан;
    цел function(SDL_cond*,SDL_mutex*) сдлУсловЖди;
    цел function(SDL_cond*,SDL_mutex*,бцел) сдлУсловЖдиТаймаут;

    цел сдлБлокируйМютекс(SDL_mutex *mutex)
    {
        return сдлМютексП(mutex);
    }

    цел сдлРазблокируйМютекс(SDL_mutex *mutex)
    {
        return сдлМютексВ(mutex);
    }

    // SDL_rwops.h
    ЧЗоперации* function(ткст0,ткст0) сдлЧЗИзФайла;
    ЧЗоперации* function(cidrus.фук,цел) сдлЧЗИзФП;
    ЧЗоперации* function(ук,цел) сдлЧЗИзПам;
    ЧЗоперации* function(ук,цел) сдлЧЗИзКонстПам;
    ЧЗоперации* function() сдлРазместиЧЗ;
    проц function(ЧЗоперации*) сдлОсвободиЧЗ;
    бкрат function(ЧЗоперации*) сдлЧитайЛЭ16;
    бкрат function(ЧЗоперации*) сдлЧитайБЭ16;
    бцел function(ЧЗоперации*) сдлЧитайЛЭ32;
    бцел function(ЧЗоперации*) сдлЧитайБЭ32;
    бдол function(ЧЗоперации*) сдлЧитайЛЭ64;
    бдол function(ЧЗоперации*) сдлЧитайБЭ64;
    бкрат function(ЧЗоперации*,бкрат) сдлПишиЛЭ16;
    бкрат function(ЧЗоперации*,бкрат) сдлПишиБЭ16;
    бцел function(ЧЗоперации*,бцел) сдлПишиЛЭ32;
    бцел function(ЧЗоперации*,бцел) сдлПишиБЭ32;
    бдол function(ЧЗоперации*,бдол) сдлПишиЛЭ64;
    бдол function(ЧЗоперации*,бдол) сдлПишиБЭ64;

    // SDL_version.h
    SDL_version* function() сдлЛинкВерсия;

    // SDL_syswm.h
    цел function(SDL_SysWMinfo*) сдлДайИнфОбОк;

    // SDL_thread.h
    SDL_Thread* function(цел (*fm)(ук), ук) сдлТяниНить;
    бцел function() сдлИДНити;
    бцел function(SDL_Thread*) сдлДайИДНити;
    проц function(SDL_Thread*,цел*) сдлЖдиНить;
    проц function(SDL_Thread*) сдлРвиНить;

    // SDL_timer.h
    бцел function() сдлДайТики;
    проц function(бцел) сдлЗадержка;
    цел function(бцел,сдлОбрвызовТаймера) сдлУстановиТаймер;
    ИДТаймера function(бцел,сдлНовыйОбрвызовТаймера,ук) сдлДобавьТаймер;
    бул function(ИДТаймера) сдлУдалиТаймер;

    // SDL_video.h
    цел function(ткст0,бцел) сдлВклВидео;
    проц function() сдлВыклВидео;
    ткст0 function(ткст0,цел) сдлИмяВидеоДрайвера;
    ПоверхностьСДЛ* function() сдлДайВидеоПоверхность;
    ВидеоИнфоСДЛ* function() сдлДайИнфОВидео;
    цел function(цел,цел,цел,бцел) сдлВидеоРежимОК;
    ПрямоугСДЛ** function(ФорматПикселяСДЛ*,бцел) сдлСписокРежимов;
    ПоверхностьСДЛ* function(цел,цел,цел,бцел) сдлУстановиВидеоРежим;
    проц function(ПоверхностьСДЛ*,цел,ПрямоугСДЛ*) сдлОбновиПрямоуги;
    проц function(ПоверхностьСДЛ*,цел,цел,бцел,бцел) сдлОбновиПрямоуг;
    цел function(ПоверхностьСДЛ*) сдлФлип;
    цел function(float,float,float) сдлУстановиГамму;
    цел function(бкрат*,бкрат*,бкрат*) сдлУстановиРампуГаммы;
    цел function(бкрат*,бкрат*,бкрат*) сдлДайРампуГаммы;
    цел function(ПоверхностьСДЛ*,ЦветСДЛ*,цел,цел) сдлУстановиЦвета;
    цел function(ПоверхностьСДЛ*,цел,ЦветСДЛ*,цел,цел) сдлУстановиПалитру;
    бцел function(ФорматПикселяСДЛ*,ббайт,ббайт,ббайт) сдлКартируйКЗС;
    бцел function(ФорматПикселяСДЛ*,ббайт,ббайт,ббайт,ббайт) сдлКартируйКЗСА;
    проц function(бцел,ФорматПикселяСДЛ*,ббайт*,ббайт*,ббайт*) сдлДайКЗС;
    проц function(бцел,ФорматПикселяСДЛ*,ббайт*,ббайт*,ббайт*,ббайт*) сдлДайКЗСА;
    ПоверхностьСДЛ* function(бцел,цел,цел,цел,бцел,бцел,бцел,бцел) сдлСоздайКЗСПоверхность;
    ПоверхностьСДЛ* function(ук,цел,цел,цел,цел,бцел,бцел,бцел,бцел) сдлСоздайКЗСПоверхностьИз;
    проц function(ПоверхностьСДЛ*) сдлОсвободиПоверхность;
    цел function(ПоверхностьСДЛ*) сдлБлокируйПоверхность;
    проц function(ПоверхностьСДЛ*) сдлРазблокируйПоверхность;
    ПоверхностьСДЛ* function(ЧЗоперации*,цел) сдлЗагрузиБМП_ЧЗ;
    цел function(ПоверхностьСДЛ*,ЧЗоперации*,цел) сдлСохраниБМП_ЧЗ;
    цел function(ПоверхностьСДЛ*,бцел,бцел) сдлУстановиКлючЦвета;
    цел function(ПоверхностьСДЛ*,бцел,ббайт) сдлУстановиАльфу;
    бул function(ПоверхностьСДЛ*,ПрямоугСДЛ*) сдлУстановиПрямоугОбрезки;
    проц function(ПоверхностьСДЛ*,ПрямоугСДЛ*) сдлДайПрямоугОбрезки;
    ПоверхностьСДЛ* function(ПоверхностьСДЛ*,ФорматПикселяСДЛ*,бцел) сдлПреобразуйПоверхность;
    цел function(ПоверхностьСДЛ*,ПрямоугСДЛ*,ПоверхностьСДЛ*,ПрямоугСДЛ*) сдлВерхнийБлит;
    цел function(ПоверхностьСДЛ*,ПрямоугСДЛ*,ПоверхностьСДЛ*,ПрямоугСДЛ*) сдлНижнийБлит;
    цел function(ПоверхностьСДЛ*,ПрямоугСДЛ*,бцел) сдлЗаполниПрямоуг;
    ПоверхностьСДЛ* function(ПоверхностьСДЛ*) сдлПоказФормат;
    ПоверхностьСДЛ* function(ПоверхностьСДЛ*) сдлПоказФорматАльфа;
    SDL_Overlay* function(цел,цел,бцел,ПоверхностьСДЛ*) сдлСоздайЮВНакладку;
    цел function(SDL_Overlay*) сдлБлокируйЮВНакладку;
    проц function(SDL_Overlay*) сдлРазблокируйЮВНакладку;
    цел function(SDL_Overlay*,ПрямоугСДЛ*) сдлПокажиЮВНакладку;
    проц function(SDL_Overlay*) сдлОсвободиЮВНакладку;
    цел function(ткст0) сдлГлЗагрузи;
    ук function(ткст0) сдлГлАдресПроц;
    цел function(SDL_GLattr,цел) сдлГлУстановиАтриб;
    цел function(SDL_GLattr,цел*) сдлГлДайАтриб;
    проц function() сдлГлОбменяйБуферы;
    проц function(цел,ПрямоугСДЛ*) сдлГлОбновиПрямоуги;
    проц function() сдлГлБлокируй;
    проц function() сдлГлРазблокируй;
    проц function(ткст0,ткст0) сдлОкУстановиЗаг;
    проц function(ткст0*,ткст0*)сдлОкДайЗаг;
    проц function(ПоверхностьСДЛ*,ббайт*) сдлОкУстановиПикт;
    цел function() сдлОкСверни;
    цел function(ПоверхностьСДЛ*) сдлОкРазверни;
    SDL_GrabMode function(SDL_GrabMode) сдлОкЗахватиВвод;

    alias сдлСоздайКЗСПоверхность сдлРазместиПоверхность;
    alias сдлВерхнийБлит сдлБлитП;

    ПоверхностьСДЛ* сдлЗагрузиБмп(сим *файл)
    {
        return сдлЗагрузиБМП_ЧЗ(сдлЧЗИзФайла(файл, "rb"), 1);
    }

    цел сдлСохраниБмп(ПоверхностьСДЛ *поверхность, сим *файл)
    {
        return сдлСохраниБМП_ЧЗ(поверхность, сдлЧЗИзФайла(файл,"wb"), 1);
    }
}




// SDL.h
enum : бцел
{
    SDL_INIT_TIMER   = 0x00000001,
    SDL_INIT_AUDIO   = 0x00000010,
    SDL_INIT_VIDEO   = 0x00000020,
    SDL_INIT_CDROM   = 0x00000100,
    SDL_INIT_JOYSTICK  = 0x00000200,
    SDL_INIT_NOPARACHUTE = 0x00100000, // Don't catch fatal signals
    SDL_INIT_EVENTTHREAD = 0x00200000, // Not supported on all OS's
    SDL_INIT_EVERYTHING = 0x0000FFFF,
}


enum
{
    SDL_PRESSED     = 0x01,
    SDL_RELEASED    = 0x00
}

// SDL_active.h
enum : ббайт
{
    SDL_APPMOUSEFOCUS   = 0x01,
    SDL_APPINPUTFOCUS   = 0x02,
    SDL_APPACTIVE       = 0x04,
}

// SDL_audio.h
alias SDL_AudioSpec АудиоСпец;
struct SDL_AudioSpec
{
    цел freq;
    бкрат формат;
    ббайт channels;
    ббайт silence;
    бкрат samples;
    бкрат padding;
    бцел размер;
    extern(C) проц (*callback)(ук userdata, ббайт *поток, цел длин);
    ук userdata;
}

 // SDL_audio.h constants
enum : бкрат
{
    AUDIO_U8           = 0x0008,// Unsigned 8-bit samples
    AUDIO_S8           = 0x8008,// Signed 8-bit samples
    AUDIO_U16LSB       = 0x0010,// Unsigned 16-bit samples
    AUDIO_S16LSB       = 0x8010,// Signed 16-bit samples
    AUDIO_U16MSB       = 0x1010, // As above, but big-endian байт o
    AUDIO_S16MSB       = 0x9010,// As above, but big-endian байт order
    AUDIO_U16          = AUDIO_U16LSB,
    AUDIO_S16          = AUDIO_S16LSB,
}

version(ЛитлЭндиан)
{
    enum : бкрат
    {
        AUDIO_U16SYS   = AUDIO_U16LSB,
        AUDIO_S16SYS   = AUDIO_S16LSB,
    }
}
else
{
    enum : бкрат
    {
        AUDIO_U16SYS   = AUDIO_U16MSB,
        AUDIO_S16SYS   = AUDIO_S16MSB,
    }
}

alias SDL_AudioCVT АудиоКонверт;
struct SDL_AudioCVT
{
    цел needed;
    бкрат src_format;
    бкрат dst_format;
    double rate_incr;
    ббайт *буф;
    цел длин;
    цел len_cvt;
    цел len_mult;
    double len_ratio;
    проц (*filters[10])(АудиоКонверт *cvt, бкрат формат);
    цел filter_index;
}

alias цел статус_аудио;
enum
{
    SDL_AUDIO_STOPPED       = 0,
    SDL_AUDIO_PLAYING,
    SDL_AUDIO_PAUSED
}

enum { SDL_MIX_MAXVOLUME = 128 }

// SDL_byteorder.h
enum : бцел
{
    SDL_LIL_ENDIAN           = 1234,
    SDL_BIG_ENDIAN           = 4321,
}

version(ЛитлЭндиан)
    const бцел SDL_BYTEORDER = SDL_LIL_ENDIAN;
else
    const бцел SDL_BYTEORDER = SDL_BIG_ENDIAN;

// SDL_cdrom.h
enum : цел { SDL_MAX_TRACKS = 99 }// The maximum number of CD-ROM tracks on a disk

enum : ббайт // The types of CD-ROM track possible
{
    SDL_AUDIO_TRACK     = 0x00,
    SDL_DATA_TRACK      = 0x04,
}

alias цел статусКД;
enum
{
    CD_TRAYEMPTY,
    CD_STOPPED,
    CD_PLAYING,
    CD_PAUSED,
    CD_ERROR = -1
}

struct SDL_CDtrack
{
    ббайт id;
    ббайт type;
    бкрат unused;
    бцел length;
    бцел offset;
}

alias SDL_CD КД;
struct SDL_CD
{
    цел id;
    статусКД status;
    цел numtracks;
    цел cur_track;
    цел cur_frame;
    SDL_CDtrack track[SDL_MAX_TRACKS + 1];
}

enum { CD_FPS = 75 }// Conversion functions from frames to Minute/Second/Frames and vice vers

цел CD_INDRIVE(цел status)
{
    return (cast(цел)status > 0);
}

проц FRAMES_TO_MSF(цел f, out цел M, out цел S, out цел F)
{
    цел значение = f;
    F = значение % CD_FPS;
    значение /= CD_FPS;
    S = значение % 60;
    значение /= 60;
    M = значение;
}

цел MSF_TO_FRAMES(цел M, цел S, цел F)
{
    return (M * 60 * CD_FPS + S * CD_FPS + F);
}

// SDL_endian.h
бкрат сдлРазвербит16(бкрат знач)
{
    return cast(бкрат)((знач<<8)|(знач>>8));
}

бцел сдлРазвербит32(бцел знач)
{
    return развербит(знач);
}

бдол сдлРазвербит64(бдол знач)
{
    бцел lo = cast(бцел)(знач & 0xFFFFFFFF);
    знач >>= 32;
    бцел hi = cast(бцел)(знач & 0xFFFFFFFF);
    знач = развербит(lo);
    знач <<= 32;
    знач |= развербит(hi);
    return знач;
}

version(ЛитлЭндиан)
{
    бкрат сдлРазвербитЛЕ16(бкрат знач)
    {
        return знач;
    }

    бцел сдлРазвербитЛЕ32(бцел знач)
    {
        return знач;
    }

    бдол сдлРазвербитЛЕ64(бдол знач)
    {
        return знач;
    }

    бкрат сдлРазвербитБЕ16(бкрат знач)
    {
        return cast(бкрат)((знач<<8)|(знач>>8));
    }

    бцел сдлРазвербитБЕ32(бцел знач)
    {
        return развербит(знач);
    }

    бдол сдлРазвербитБЕ64(бдол знач)
    {
        бцел lo = cast(бцел)(знач & 0xFFFFFFFF);
        знач >>= 32;
        бцел hi = cast(бцел)(знач & 0xFFFFFFFF);
        знач = развербит(lo);
        знач <<= 32;
        знач |= развербит(hi);
        return знач;
    }
}
else
{
    бкрат сдлРазвербитЛЕ16(бкрат знач)
    {
        return cast(бкрат)((знач<<8)|(знач>>8));
    }

    бцел сдлРазвербитЛЕ32(бцел знач)
    {
        return развербит(знач);
    }

    бдол сдлРазвербитЛЕ64(бдол знач)
    {
        бцел lo = cast(бцел)(знач & 0xFFFFFFFF);
        знач >>= 32;
        бцел hi = cast(бцел)(знач & 0xFFFFFFFF);
        знач = развербит(lo);
        знач <<= 32;
        знач |= развербит(hi);
        return знач;
    }

    бкрат сдлРазвербитБЕ16(бкрат знач)
    {
        return знач;
    }

    бцел сдлРазвербитБЕ32(бцел знач)
    {
        return знач;
    }

    бдол сдлРазвербитБЕ64(бдол знач)
    {
        return знач;
    }
}

// SDL_events.h
enum
{
    SDL_NOEVENT = 0,// Unused (do not remove)
    SDL_ACTIVEEVENT = 1,// Application loses/gains visibility
    SDL_KEYDOWN = 2,// Keys pressed
    SDL_KEYUP = 3,// Keys released
    SDL_MOUSEMOTION = 4,// Mouse moved
    SDL_MOUSEBUTTONDOWN = 5,// Mouse button pressed
    SDL_MOUSEBUTTONUP = 6,// Mouse button released
    SDL_JOYAXISMOTION = 7,// Joystick axis motion
    SDL_JOYBALLMOTION,// Joystick trackball motion
    SDL_JOYHATMOTION,// Joystick hat position change
    SDL_JOYBUTTONDOWN,// Joystick button pressed
    SDL_JOYBUTTONUP, // Joystick button released
    SDL_QUIT,// User-requested quit
    SDL_SYSWMEVENT,// System specific событие
    SDL_EVENT_RESERVEDA,
    SDL_EVENT_RESERVEDB,
    SDL_VIDEORESIZE,// User resized video mode
    SDL_VIDEOEXPOSE, // Screen needs to be redrawn
    SDL_EVENT_RESERVED2,
    SDL_EVENT_RESERVED3,
    SDL_EVENT_RESERVED4,
    SDL_EVENT_RESERVED5,
    SDL_EVENT_RESERVED6,
    SDL_EVENT_RESERVED7,
    SDL_USEREVENT = 24, // Events SDL_USEREVENT through SDL_MAXEVENTS-1 are for your use
	// This last событие is only for bounding internal arrays
  // It is the number of bits in the событие маска datatype -- UInt32
    SDL_NUMEVENTS = 32
}

enum
{
    SDL_ACTIVEEVENTMASK         = (1<<SDL_ACTIVEEVENT),
    SDL_KEYDOWNMASK             = (1<<SDL_KEYDOWN),
    SDL_KEYUPMASK               = (1<<SDL_KEYUP),
    SDL_KEYEVENTMASK            = SDL_KEYDOWNMASK | SDL_KEYUPMASK,
    SDL_MOUSEMOTIONMASK         = (1<<SDL_MOUSEMOTION),
    SDL_MOUSEBUTTONDOWNMASK     = (1<<SDL_MOUSEBUTTONDOWN),
    SDL_MOUSEBUTTONUPMASK       = (1<<SDL_MOUSEBUTTONUP),
    SDL_MOUSEEVENTMADK          = (SDL_MOUSEMOTIONMASK |
                                   SDL_MOUSEBUTTONDOWNMASK |
                                   SDL_MOUSEBUTTONUPMASK),
    SDL_JOYAXISMOTIONMASK       = (1<<SDL_JOYAXISMOTION),
    SDL_JOYBALLMOTIONMASK       = (1<<SDL_JOYBALLMOTION),
    SDL_JOYHATMOTIONMASK        = (1<<SDL_JOYHATMOTION),
    SDL_JOYBUTTONDOWNMASK       = (1<<SDL_JOYBUTTONDOWN),
    SDL_JOYBUTTONUPMASK         = (1<<SDL_JOYBUTTONUP),
    SDL_JOYEVENTMASK            = (SDL_JOYAXISMOTIONMASK |
                                   SDL_JOYBALLMOTIONMASK |
                                   SDL_JOYHATMOTIONMASK |
                                   SDL_JOYBUTTONDOWNMASK |
                                   SDL_JOYBUTTONUPMASK),
    SDL_VIDEORESIZEMASK         = (1<<SDL_VIDEORESIZE),
    SDL_VIDEOEXPOSEMASK         = (1<<SDL_VIDEOEXPOSE),
    SDL_QUITMASK                = (1<<SDL_QUIT),
    SDL_SYSWMEVENTMASK          = (1<<SDL_SYSWMEVENT)
}

enum : бцел { SDL_ALLEVENTS = 0xFFFFFFFF }

struct SDL_ActiveEvent
{
    ббайт type;
    ббайт gain;
    ббайт state;
}

struct SDL_KeyboardEvent
{
    ббайт type;
    ббайт which;
    ббайт state;
    SDL_keysym keysym;
}

struct SDL_MouseMotionEvent
{
    ббайт type;
    ббайт which;
    ббайт state;
    бкрат x, y;
    крат xrel;
    крат yrel;
}

struct SDL_MouseButtonEvent
{
    ббайт type;
    ббайт which;
    ббайт button;
    ббайт state;
    бкрат x, y;
}

struct SDL_JoyAxisEvent
{
    ббайт type;
    ббайт which;
    ббайт axis;
    крат значение;
}

struct SDL_JoyBallEvent
{
    ббайт type;
    ббайт which;
    ббайт ball;
    крат xrel;
    крат yrel;
}

struct SDL_JoyHatEvent
{
    ббайт type;
    ббайт which;
    ббайт hat;
    ббайт значение;
}

struct SDL_JoyButtonEvent
{
    ббайт type;
    ббайт which;
    ббайт button;
    ббайт state;
}

struct SDL_ResizeEvent
{
    ббайт type;
    цел w;
    цел h;
}

struct SDL_ExposeEvent
{
    ббайт type;
}

struct SDL_QuitEvent
{
    ббайт type;
}

struct SDL_UserEvent
{
    ббайт type;
    цел код;
    ук data1;
    ук data2;
}

struct SDL_SysWMEvent
{
    ббайт type;
    SDL_SysWMmsg *msg;
}

alias SDL_Event СобытиеСДЛ;
union SDL_Event
{
    ббайт type;
    SDL_ActiveEvent active;
    SDL_KeyboardEvent key;
    SDL_MouseMotionEvent motion;
    SDL_MouseButtonEvent button;
    SDL_JoyAxisEvent jaxis;
    SDL_JoyBallEvent jball;
    SDL_JoyHatEvent jhat;
    SDL_JoyButtonEvent jbutton;
    SDL_ResizeEvent resize;
    SDL_ExposeEvent expose;
    SDL_QuitEvent quit;
    SDL_UserEvent user;
    SDL_SysWMEvent syswm;
}

alias цел SDL_eventaction;
enum
{
    SDL_ADDEVENT,
    SDL_PEEKEVENT,
    SDL_GETEVENT
}

extern(C) typedef цел function(SDL_Event *событие) сдлФильтрСобытий;


enum
{
    SDL_QUERY           = -1,
    SDL_IGNORE          = 0,
    SDL_DISABLE         = 0,
    SDL_ENABLE          = 1,
}

// SDL_joystick.h
struct SDL_Joystick {}

enum : ббайт
{
    SDL_HAT_CENTERED            = 0x00,
    SDL_HAT_UP                  = 0x01,
    SDL_HAT_RIGHT               = 0x02,
    SDL_HAT_DOWN                = 0x04,
    SDL_HAT_LEFT                = 0x08,
    SDL_HAT_RIGHTUP             = SDL_HAT_RIGHT | SDL_HAT_UP,
    SDL_HAT_RIGHTDOWN           = SDL_HAT_RIGHT | SDL_HAT_DOWN,
    SDL_HAT_LEFTUP              = SDL_HAT_LEFT | SDL_HAT_UP,
    SDL_HAT_LEFTDOWN            = SDL_HAT_LEFT | SDL_HAT_DOWN,
}

// SDL_keyboard.h
struct SDL_keysym
{
    ббайт scancode;
    SDLKey sym;
    SDLMod mod;
    бкрат unicode;
}

enum : бцел { SDL_ALL_HOTKEYS = 0xFFFFFFFF }

enum
{
    SDL_DEFAULT_REPEAT_DELAY      = 500,
    SDL_DEFAULT_REPEAT_INTERVAL   = 30,
}

// SDL_keysym.h
alias цел SDLKey;
enum
{
    /* The keyboard syms have been cleverly chosen to map to ASCII */
    SDLK_UNKNOWN        = 0,
    SDLK_FIRST      = 0,
    SDLK_BACKSPACE      = 8,
    SDLK_TAB        = 9,
    SDLK_CLEAR      = 12,
    SDLK_RETURN     = 13,
    SDLK_PAUSE      = 19,
    SDLK_ESCAPE     = 27,
    SDLK_SPACE      = 32,
    SDLK_EXCLAIM        = 33,
    SDLK_QUOTEDBL       = 34,
    SDLK_HASH       = 35,
    SDLK_DOLLAR     = 36,
    SDLK_AMPERSAND      = 38,
    SDLK_QUOTE      = 39,
    SDLK_LEFTPAREN      = 40,
    SDLK_RIGHTPAREN     = 41,
    SDLK_ASTERISK       = 42,
    SDLK_PLUS       = 43,
    SDLK_COMMA      = 44,
    SDLK_MINUS      = 45,
    SDLK_PERIOD     = 46,
    SDLK_SLASH      = 47,
    SDLK_0          = 48,
    SDLK_1          = 49,
    SDLK_2          = 50,
    SDLK_3          = 51,
    SDLK_4          = 52,
    SDLK_5          = 53,
    SDLK_6          = 54,
    SDLK_7          = 55,
    SDLK_8          = 56,
    SDLK_9          = 57,
    SDLK_COLON      = 58,
    SDLK_SEMICOLON      = 59,
    SDLK_LESS       = 60,
    SDLK_EQUALS     = 61,
    SDLK_GREATER        = 62,
    SDLK_QUESTION       = 63,
    SDLK_AT         = 64,
    /*
       Skip uppercase letters
     */
    SDLK_LEFTBRACKET    = 91,
    SDLK_BACKSLASH      = 92,
    SDLK_RIGHTBRACKET   = 93,
    SDLK_CARET      = 94,
    SDLK_UNDERSCORE     = 95,
    SDLK_BACKQUOTE      = 96,
    SDLK_a          = 97,
    SDLK_b          = 98,
    SDLK_c          = 99,
    SDLK_d          = 100,
    SDLK_e          = 101,
    SDLK_f          = 102,
    SDLK_g          = 103,
    SDLK_h          = 104,
    SDLK_i          = 105,
    SDLK_j          = 106,
    SDLK_k          = 107,
    SDLK_l          = 108,
    SDLK_m          = 109,
    SDLK_n          = 110,
    SDLK_o          = 111,
    SDLK_p          = 112,
    SDLK_q          = 113,
    SDLK_r          = 114,
    SDLK_s          = 115,
    SDLK_t          = 116,
    SDLK_u          = 117,
    SDLK_v          = 118,
    SDLK_w          = 119,
    SDLK_x          = 120,
    SDLK_y          = 121,
    SDLK_z          = 122,
    SDLK_DELETE     = 127,
    /* End of ASCII mapped keysyms */

    /* International keyboard syms */
    SDLK_WORLD_0        = 160,      /* 0xA0 */
    SDLK_WORLD_1        = 161,
    SDLK_WORLD_2        = 162,
    SDLK_WORLD_3        = 163,
    SDLK_WORLD_4        = 164,
    SDLK_WORLD_5        = 165,
    SDLK_WORLD_6        = 166,
    SDLK_WORLD_7        = 167,
    SDLK_WORLD_8        = 168,
    SDLK_WORLD_9        = 169,
    SDLK_WORLD_10       = 170,
    SDLK_WORLD_11       = 171,
    SDLK_WORLD_12       = 172,
    SDLK_WORLD_13       = 173,
    SDLK_WORLD_14       = 174,
    SDLK_WORLD_15       = 175,
    SDLK_WORLD_16       = 176,
    SDLK_WORLD_17       = 177,
    SDLK_WORLD_18       = 178,
    SDLK_WORLD_19       = 179,
    SDLK_WORLD_20       = 180,
    SDLK_WORLD_21       = 181,
    SDLK_WORLD_22       = 182,
    SDLK_WORLD_23       = 183,
    SDLK_WORLD_24       = 184,
    SDLK_WORLD_25       = 185,
    SDLK_WORLD_26       = 186,
    SDLK_WORLD_27       = 187,
    SDLK_WORLD_28       = 188,
    SDLK_WORLD_29       = 189,
    SDLK_WORLD_30       = 190,
    SDLK_WORLD_31       = 191,
    SDLK_WORLD_32       = 192,
    SDLK_WORLD_33       = 193,
    SDLK_WORLD_34       = 194,
    SDLK_WORLD_35       = 195,
    SDLK_WORLD_36       = 196,
    SDLK_WORLD_37       = 197,
    SDLK_WORLD_38       = 198,
    SDLK_WORLD_39       = 199,
    SDLK_WORLD_40       = 200,
    SDLK_WORLD_41       = 201,
    SDLK_WORLD_42       = 202,
    SDLK_WORLD_43       = 203,
    SDLK_WORLD_44       = 204,
    SDLK_WORLD_45       = 205,
    SDLK_WORLD_46       = 206,
    SDLK_WORLD_47       = 207,
    SDLK_WORLD_48       = 208,
    SDLK_WORLD_49       = 209,
    SDLK_WORLD_50       = 210,
    SDLK_WORLD_51       = 211,
    SDLK_WORLD_52       = 212,
    SDLK_WORLD_53       = 213,
    SDLK_WORLD_54       = 214,
    SDLK_WORLD_55       = 215,
    SDLK_WORLD_56       = 216,
    SDLK_WORLD_57       = 217,
    SDLK_WORLD_58       = 218,
    SDLK_WORLD_59       = 219,
    SDLK_WORLD_60       = 220,
    SDLK_WORLD_61       = 221,
    SDLK_WORLD_62       = 222,
    SDLK_WORLD_63       = 223,
    SDLK_WORLD_64       = 224,
    SDLK_WORLD_65       = 225,
    SDLK_WORLD_66       = 226,
    SDLK_WORLD_67       = 227,
    SDLK_WORLD_68       = 228,
    SDLK_WORLD_69       = 229,
    SDLK_WORLD_70       = 230,
    SDLK_WORLD_71       = 231,
    SDLK_WORLD_72       = 232,
    SDLK_WORLD_73       = 233,
    SDLK_WORLD_74       = 234,
    SDLK_WORLD_75       = 235,
    SDLK_WORLD_76       = 236,
    SDLK_WORLD_77       = 237,
    SDLK_WORLD_78       = 238,
    SDLK_WORLD_79       = 239,
    SDLK_WORLD_80       = 240,
    SDLK_WORLD_81       = 241,
    SDLK_WORLD_82       = 242,
    SDLK_WORLD_83       = 243,
    SDLK_WORLD_84       = 244,
    SDLK_WORLD_85       = 245,
    SDLK_WORLD_86       = 246,
    SDLK_WORLD_87       = 247,
    SDLK_WORLD_88       = 248,
    SDLK_WORLD_89       = 249,
    SDLK_WORLD_90       = 250,
    SDLK_WORLD_91       = 251,
    SDLK_WORLD_92       = 252,
    SDLK_WORLD_93       = 253,
    SDLK_WORLD_94       = 254,
    SDLK_WORLD_95       = 255,      /* 0xFF */

    /* Numeric keypad */
    SDLK_KP0        = 256,
    SDLK_KP1        = 257,
    SDLK_KP2        = 258,
    SDLK_KP3        = 259,
    SDLK_KP4        = 260,
    SDLK_KP5        = 261,
    SDLK_KP6        = 262,
    SDLK_KP7        = 263,
    SDLK_KP8        = 264,
    SDLK_KP9        = 265,
    SDLK_KP_PERIOD      = 266,
    SDLK_KP_DIVIDE      = 267,
    SDLK_KP_MULTIPLY    = 268,
    SDLK_KP_MINUS       = 269,
    SDLK_KP_PLUS        = 270,
    SDLK_KP_ENTER       = 271,
    SDLK_KP_EQUALS      = 272,

    /* Arrows + Home/End pad */
    SDLK_UP         = 273,
    SDLK_DOWN       = 274,
    SDLK_RIGHT      = 275,
    SDLK_LEFT       = 276,
    SDLK_INSERT     = 277,
    SDLK_HOME       = 278,
    SDLK_END        = 279,
    SDLK_PAGEUP     = 280,
    SDLK_PAGEDOWN       = 281,

    /* Function keys */
    SDLK_F1         = 282,
    SDLK_F2         = 283,
    SDLK_F3         = 284,
    SDLK_F4         = 285,
    SDLK_F5         = 286,
    SDLK_F6         = 287,
    SDLK_F7         = 288,
    SDLK_F8         = 289,
    SDLK_F9         = 290,
    SDLK_F10        = 291,
    SDLK_F11        = 292,
    SDLK_F12        = 293,
    SDLK_F13        = 294,
    SDLK_F14        = 295,
    SDLK_F15        = 296,

    /* Key state modifier keys */
    SDLK_NUMLOCK        = 300,
    SDLK_CAPSLOCK       = 301,
    SDLK_SCROLLOCK      = 302,
    SDLK_RШИФТ     = 303,
    SDLK_LШИФТ     = 304,
    SDLK_RCTRL      = 305,
    SDLK_LCTRL      = 306,
    SDLK_RALT       = 307,
    SDLK_LALT       = 308,
    SDLK_RMETA      = 309,
    SDLK_LMETA      = 310,
    SDLK_LSUPER     = 311,      /* Left "Windows" key */
    SDLK_RSUPER     = 312,      /* Right "Windows" key */
    SDLK_MODE       = 313,      /* "Alt Gr" key */
    SDLK_COMPOSE        = 314,      /* Multi-key compose key */

    /* Miscellaneous function keys */
    SDLK_HELP       = 315,
    SDLK_PRINT      = 316,
    SDLK_SYSREQ     = 317,
    SDLK_BREAK      = 318,
    SDLK_MENU       = 319,
    SDLK_POWER      = 320,      /* Power Macintosh power key */
    SDLK_EURO       = 321,      /* Some european keyboards */
    SDLK_UNDO       = 322,      /* Atari keyboard has Undo */

    /* Add any other keys here */

    SDLK_LAST
}

alias цел SDLMod;
enum
{
    KMOD_NONE  = 0x0000,
    KMOD_LШИФТ= 0x0001,
    KMOD_RШИФТ= 0x0002,
    KMOD_LCTRL = 0x0040,
    KMOD_RCTRL = 0x0080,
    KMOD_LALT  = 0x0100,
    KMOD_RALT  = 0x0200,
    KMOD_LMETA = 0x0400,
    KMOD_RMETA = 0x0800,
    KMOD_NUM   = 0x1000,
    KMOD_CAPS  = 0x2000,
    KMOD_MODE  = 0x4000,
    KMOD_RESERVED = 0x8000,
    KMOD_CTRL         = KMOD_LCTRL | KMOD_RCTRL,
    KMOD_ШИФТ        = KMOD_LШИФТ | KMOD_RШИФТ,
    KMOD_ALT          = KMOD_LALT | KMOD_RALT,
    KMOD_META         = KMOD_LMETA | KMOD_RMETA,
}

// SDL_mouse.h

struct WMcursor {}

struct SDL_Cursor
{
    ПрямоугСДЛ area;
    крат hot_x, hot_y;
    ббайт *data;
    ббайт *маска;
    ббайт *save[2];
    WMcursor *wm_cursor;
}

enum : ббайт
{
    SDL_BUTTON_LEFT         = 1,
    SDL_BUTTON_MIDDLE       = 2,
    SDL_BUTTON_RIGHT        = 3,
    SDL_BUTTON_WHEELUP      = 4,
    SDL_BUTTON_WHEELDOWN    = 5,
    SDL_BUTTON_X1           = 6,
    SDL_BUTTON_X2           = 7,
    SDL_BUTTON_LMASK        = 1 << (SDL_BUTTON_LEFT-1),
    SDL_BUTTON_MMASK        = 1 << (SDL_BUTTON_MIDDLE-1),
    SDL_BUTTON_RMASK        = 1 << (SDL_BUTTON_RIGHT-1),
    SDL_BUTTON_X1MASK       = 1 << (SDL_BUTTON_X1-1),
    SDL_BUTTON_X2MASK       = 1 << (SDL_BUTTON_X2-1),
}

ббайт SDL_BUTTON(ббайт x)
{
    return cast(ббайт)(1 << (x - 1));
}

// SDL_mutex.h
enum { SDL_MUTEX_TIMEOUT = 1 }

enum : бцел { SDL_MUTEX_MAXWAIT = (~(cast(бцел)0)) }

struct SDL_mutex {//was empty!!!!
	HANDLE id;
	}

struct SDL_sem {
	HANDLE id;
    бцел count;}

struct SDL_cond {// Generic Cond structure ( was empty too!!!)
    SDL_mutex* lock;
    цел waiting;
    цел signals;
    SDL_sem* wait_sem;
    SDL_sem* wait_done;
	}

// SDL_rwops.h
enum
{
    RW_SEEK_SET       = 0,
    RW_SEEK_CUR       = 1,
    RW_SEEK_END       = 2,
}

alias SDL_RWops ЧЗоперации;
struct SDL_RWops
{
    extern(C)
    {
        цел (*seek)(ЧЗоперации *контекст, цел offset, цел whence);
        цел (*read)(ЧЗоперации *контекст, ук указ, цел размер, цел максчло);
        цел (*write)(ЧЗоперации *контекст, ук указ, цел размер, цел чло);
        цел (*close)(ЧЗоперации *контекст);
    }

    бцел type;
    union Hidden
    {
        version(Windows)
        {
            struct Win32io
            {
                цел append;
                ук h;
            }
            Win32io win32io;
        }

        struct Stdio
        {
            цел autoclose;
            фук fp;
        }
        Stdio stdio;

        struct Mem
        {
            ббайт *base;
            ббайт *here;
            ббайт *stop;
        }
        Mem mem;

        struct Unknown
        {
            ук data1;
        }
        Unknown unknown;
    }
    Hidden hidden;
}

цел сдлЧЗПерейди(ЧЗоперации *контекст, цел offset, цел whence)
{
    return контекст.seek(контекст, offset, whence);
}

цел сдлЧЗСкажи(ЧЗоперации *контекст)
{
    return контекст.seek(контекст, 0, RW_SEEK_CUR);
}

цел сдлЧЗЧитай(ЧЗоперации *контекст, ук указ, цел размер, цел максчло)
{
    return контекст.read(контекст, указ, размер, максчло);
}

цел сдлЧЗПиши(ЧЗоперации *контекст, ук указ, цел размер, цел чло)
{
    return контекст.write(контекст, указ, размер, чло);
}

цел сдлЧЗЗакрой(ЧЗоперации *контекст)
{
    return контекст.close(контекст);
}

// SDL_version.h
enum : ббайт
{
    SDL_MAJOR_VERSION   = 1,
    SDL_MINOR_VERSION   = 2,
    SDL_PATCHLEVEL      = 13,
}

struct SDL_version
{
    ббайт major;
    ббайт minor;
    ббайт patch;
}

проц SDL_VERSION(SDL_version *X)
{
    X.major = SDL_MAJOR_VERSION;
    X.minor = SDL_MINOR_VERSION;
    X.patch = SDL_PATCHLEVEL;
}

бцел SDL_VERSIONNUM(ббайт major, ббайт minor, ббайт patch)
{
    return (major * 1000 + minor * 100 + patch);
}

const бцел SDL_COMPILEDVERSION =  SDL_MAJOR_VERSION * 1000 +
                                  SDL_MINOR_VERSION * 100 + SDL_PATCHLEVEL;

бул SDL_VERSION_ATLEAST(ббайт major, ббайт minor, ббайт patch)
{
    return cast(бул)(SDL_COMPILEDVERSION >= SDL_VERSIONNUM(major,minor,patch));
}

// SDL_syswm.h
version(Windows)
{
    

    struct SDL_SysWMmsg
    {
        // this is named 'version' in SDL_syswm.h, but since version is a keyword,
        // 'ver' will have to do
        SDL_version ver;
        HWND hwnd;
        UINT msg;
        WPARAM wParam;
        LPARAM lParam;
    }

    struct SDL_SysWMinfo
    {
        // this is named 'version' in SDL_syswm.h, but since version is a keyword,
        // 'ver' will have to do
        SDL_version ver;
        HWND window;
        HGLRC hglrc;
    }
}
else
{
    struct SDL_SysWMmsg;
    struct SDL_SysWMinfo;
}

// SDL_thread.h
struct SDL_Thread {}

// SDL_timer.h

enum : бцел
{
    SDL_TIMESLICE          = 10,// This is the OS scheduler timeslice, in milliseconds
    SDL_RESOLUTION         = 10,// This is the maximum resolution of the SDL timer on all platforms. Experimentally determined.
}

extern(C)
{
    typedef бцел function(бцел) SDL_TimerCallback;
    typedef бцел function(бцел,ук) SDL_NewTimerCallback;
	alias SDL_TimerCallback сдлОбрвызовТаймера;
	alias SDL_NewTimerCallback сдлНовыйОбрвызовТаймера;
}

alias ук SDL_TimerID;
alias SDL_TimerID ИДТаймера;
// SDL_video.h

enum : ббайт
{
    SDL_ALPHA_OPAQUE            = 255,
    SDL_ALPHA_TRANSPARENT       = 0,
}

alias SDL_Rect ПрямоугСДЛ;
struct SDL_Rect
{
    крат x, y;
    бкрат w, h;
}

alias SDL_Color ЦветСДЛ;
struct SDL_Color
{
    ббайт r;
    ббайт g;
    ббайт b;
    ббайт unused;
}

alias  SDL_Palette ПалитраСДЛ;
struct SDL_Palette
{
    цел ncolors;
    ЦветСДЛ *colors;
}

alias SDL_PixelFormat ФорматПикселяСДЛ;
struct SDL_PixelFormat
{
    ПалитраСДЛ *palette;
    ббайт BitsPerPixel;
    ббайт BytesPerPixel;
    ббайт Rloss;
    ббайт Gloss;
    ббайт Bloss;
    ббайт Aloss;
    ббайт Rshift;
    ббайт Gshift;
    ббайт Bshift;
    ббайт Ashift;
    бцел Rmask;
    бцел Gmask;
    бцел Bmask;
    бцел Amask;
    бцел colorkey;
    ббайт alpha;
}

alias SDL_Surface ПоверхностьСДЛ;
struct SDL_Surface
{
    бцел flags;
    ФорматПикселяСДЛ *format;
    цел w, h;
    бкрат pitch;
    ук pixels;
    цел offset;
    ук hwdata;
    ПрямоугСДЛ clip_rect;
    бцел unused1;
    бцел locked;
    ук map;
    бцел format_version;
    цел refcount;
}

enum : бцел
{
    SDL_SWSURFACE                  = 0x00000000,
    SDL_HWSURFACE                  = 0x00000001,
    SDL_ASYNCBLIT                  = 0x00000004,
    SDL_ANYFORMAT                  = 0x10000000,
    SDL_HWPALETTE                  = 0x20000000,
    SDL_DOUBLEBUF                  = 0x40000000,
    SDL_FULLSCREEN                 = 0x80000000,
    SDL_OPENGL                     = 0x00000002,
    SDL_OPENGLBLIT                 = 0x0000000A,
    SDL_RESIZABLE                  = 0x00000010,
    SDL_NOFRAME                    = 0x00000020,
    SDL_HWACCEL                    = 0x00000100,
    SDL_SRCCOLORKEY                = 0x00001000,
    SDL_RLEACCELOK                 = 0x00002000,
    SDL_RLEACCEL                   = 0x00004000,
    SDL_SRCALPHA                   = 0x00010000,
    SDL_PREALLOC                   = 0x01000000,
}

alias SDL_VideoInfo ВидеоИнфоСДЛ;
struct SDL_VideoInfo
{
    бцел flags;
    бцел video_mem;
    ФорматПикселяСДЛ *vfmt;
    цел current_w;
    цел current_h;
}

enum : бцел
{
    SDL_YV12_OVERLAY               = 0x32315659,
    SDL_IYUV_OVERLAY               = 0x56555949,
    SDL_YUY2_OVERLAY               = 0x32595559,
    SDL_UYVY_OVERLAY               = 0x59565955,
    SDL_YUYU_OVERLAY               = 0x55595659,
}

struct SDL_Overlay
{
    бцел format;
    цел w, h;
    цел planes;
    бкрат *pitches;
    ббайт **pixels;
    ук hwfuncs;
    ук hwdata;
    бцел flags;
}

alias цел SDL_GLattr;
enum
{
    SDL_GL_RED_SIZE,
    SDL_GL_GREEN_SIZE,
    SDL_GL_BLUE_SIZE,
    SDL_GL_ALPHA_SIZE,
    SDL_GL_BUFFER_SIZE,
    SDL_GL_DOUBLEBUFFER,
    SDL_GL_DEPTH_SIZE,
    SDL_GL_STENCIL_SIZE,
    SDL_GL_ACCUM_RED_SIZE,
    SDL_GL_ACCUM_GREEN_SIZE,
    SDL_GL_ACCUM_BLUE_SIZE,
    SDL_GL_ACCUM_ALPHA_SIZE,
    SDL_GL_STEREO,
    SDL_GL_MULTISAMPLEBUFFERS,
    SDL_GL_MULTISAMPLESAMPLES,
    SDL_GL_ACCELERATED_VISUAL,
    SDL_GL_SWAP_CONTROL
}

enum : ббайт
{
    SDL_LOGPAL          = 0x01,
    SDL_PHYSPAL         = 0x02,
}

alias цел SDL_GrabMode;
enum
{
    SDL_GRAB_QUERY = -1,
    SDL_GRAB_OFF = 0,
    SDL_GRAB_ON = 1,
    SDL_GRAB_FULLSCREEN
}

бул SDL_MUSTLOCK(ПоверхностьСДЛ* поверхность)
{
    return cast(бул)(поверхность.offset ||
        ((поверхность.flags & (SDL_HWSURFACE|SDL_ASYNCBLIT|SDL_RLEACCEL)) != 0));
}


static this() {
    СДЛ.заряжай("SDL.dll", &грузи );
	СДЛ.загружай();
}

static ~this() {
	СДЛ.выгружай();
}

debug(Sdl)
{
	void main()
	{
		auto дисп = сдлУстановиВидеоРежим(640,480,0,SDL_HWSURFACE|SDL_DOUBLEBUF);
		auto r = ПрямоугСДЛ(0,190,100,100);
		auto c = сдлКартируйКЗСА(дисп.формат,255,100,0,255);
		while (r.x < дисп.w-100)
		{
			сдлЗаполниПрямоуг(дисп, пусто, 0);
			сдлЗаполниПрямоуг(дисп, &r, c);
			сдлФлип(дисп);
			r.x++;
		}
	}
}