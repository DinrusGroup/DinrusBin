module winMain;

extern(C)	бул ртСтарт(ПередВходом передвхо = пусто, ОбработчикИсключения дг = пусто);
extern(C)	бул ртСтоп(ПередВыходом передвых = пусто, ОбработчикИсключения дг = пусто );


extern (Windows)
цел WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, цел nCmdShow)
{
    цел рез;

    проц обрИскл(Исключение e)
    {
        throw e;
    }

    try
    {
				
       ртСтарт(пусто, &обрИскл);

        рез = myWinMain(hInstance, hPrevInstance, lpCmdLine, nCmdShow);

        ртСтоп(пусто, &обрИскл);
    }
    catch (Объект o)		// catch any uncaught exceptions
    {
       // MessageBoxA(null, вТкст0(o.вТкст()), "Ошибка", MB_OK | MB_ICONEXCLAMATION);
        рез = 0;		// failed
    }

    return рез;
}

цел myWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, цел nCmdShow)
{
    /* ... insert user code here ... */
    throw new Exception("не реализовано");
    return 0;
}
