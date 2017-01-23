// stdafx.h: включаемый файл для стандартных системных включаемых файлов
// или включаемых файлов для конкретного проекта, которые часто используются, но
// не часто изменяются
//

#pragma once
#include "targetver.h"
#define WIN32_LEAN_AND_MEAN 

 // Исключите редко используемые компоненты из заголовков Windows
 // Файлы заголовков Windows:
 
#include <windows.h>

// TODO: Установите здесь ссылки на дополнительные заголовки, требующиеся для программы

#include ".\DIR.H"
#include ".\DIRENT.H"
#include ".\ERRNO.H"
#include ".\FCNTL.H"
#include ".\LOCKING.H"
#include ".\SIGNAL.H"
#include ".\STAT.H"
#include ".\STROPTS.H"
#include ".\TERMIO.H"
#include ".\TERMIOS.H"
#include ".\TIME.H"
#include ".\TIMEB.H"
#include ".\TIMES.H"
#include ".\TYPES.H"
#include ".\UNISTD.H"
#include ".\UTIME.H"
