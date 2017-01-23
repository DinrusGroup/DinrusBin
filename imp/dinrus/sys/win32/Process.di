/*
 * Written by Sean Kelly
 * Placed преобр_в Public Domain
 */

module sys.win32.Process;

//pragma(lib,"DinrusTango.lib");

private
{
    import rt.core.stdc.stdint;
    import rt.core.stdc.stddef;
}

extern (C):

enum
{
    P_WAIT,
    P_NOWAIT,
    P_OVERLAY,
    P_NOWAITO,
    P_DETACH,
}

enum
{
    WAIT_CHILD,
    WAIT_GRANDCHILD,
}

private
{
    extern (C) alias проц function(проц*) bt_fptr;
    extern (Windows) alias бцел function(проц*) btex_fptr;
}

uintptr_t _beginthread(bt_fptr, бцел, проц*);
проц _endthread();
uintptr_t _beginthreadex(проц*, бцел, btex_fptr, проц*, бцел, бцел *);
проц _endthreadex(бцел);

проц abort();
проц exit(цел);
проц _exit(цел);
проц _cexit();
проц _c_exit();

intptr_t cwait(цел*, intptr_t, цел);
intptr_t жди(цел*);

цел getpid();
цел system(сим*);

intptr_t spawnl(цел, сим*, сим*, ...);
intptr_t spawnle(цел, сим*, сим*, ...);
intptr_t spawnlp(цел, сим*, сим*, ...);
intptr_t spawnlpe(цел, сим*, сим*, ...);
intptr_t spawnv(цел, сим*, сим**);
intptr_t spawnve(цел, сим*, сим**, сим**);
intptr_t spawnvp(цел, сим*, сим**);
intptr_t spawnvpe(цел, сим*, сим**, сим**);

intptr_t execl(сим*, сим*, ...);
intptr_t execle(сим*, сим*, ...);
intptr_t execlp(сим*, сим*, ...);
intptr_t execlpe(сим*, сим*, ...);
intptr_t execv(сим*, сим**);
intptr_t execve(сим*, сим**, сим**);
intptr_t execvp(сим*, сим**);
intptr_t execvpe(сим*, сим**, сим**);

цел _wsystem(wchar_t*);

intptr_t _wspawnl(цел, wchar_t*, wchar_t*, ...);
intptr_t _wspawnle(цел, wchar_t*, wchar_t*, ...);
intptr_t _wspawnlp(цел, wchar_t*, wchar_t*, ...);
intptr_t _wspawnlpe(цел, wchar_t*, wchar_t*, ...);
intptr_t _wspawnv(цел, wchar_t*, wchar_t**);
intptr_t _wspawnve(цел, wchar_t*, wchar_t**, wchar_t**);
intptr_t _wspawnvp(цел, wchar_t*, wchar_t**);
intptr_t _wspawnvpe(цел, wchar_t*, wchar_t**, wchar_t**);

intptr_t _wexecl(wchar_t*, wchar_t*, ...);
intptr_t _wexecle(wchar_t*, wchar_t*, ...);
intptr_t _wexeclp(wchar_t*, wchar_t*, ...);
intptr_t _wexeclpe(wchar_t*, wchar_t*, ...);
intptr_t _wexecv(wchar_t*, wchar_t**);
intptr_t _wexecve(wchar_t*, wchar_t**, wchar_t**);
intptr_t _wexecvp(wchar_t*, wchar_t**);
intptr_t _wexecvpe(wchar_t*, wchar_t**, wchar_t**);
