/*******************************************************************************

        copyright:      Copyright (c) 2009 Kris Bell. All rights reserved

        license:        BSD style: $(LICENSE)

        version:        rewritten: Nov 2009

        Различные низкоуровневые консольные утилиты

*******************************************************************************/

module std.console;


private import std.string;


/*******************************************************************************
        
        Внешние функции

*******************************************************************************/

version (Windows) 
        {
        enum {UTF8 = 65001};
        private extern (Windows) int GetStdHandle (int);
        private extern (Windows) int WriteFile (int, char*, int, int*, void*);
        private extern (Windows) bool GetConsoleMode (int, int*);
       private extern (Windows) bool WriteConsoleW (int, wchar*, int, int*, void*);
        private extern (Windows) int MultiByteToWideChar (int, int, char*, int, wchar*, int);
        } 
else 
version (Posix)
         extern(C) ptrdiff_t write (int, in void*, size_t);


/*******************************************************************************
        
        Вывести интегральное число в консоль

*******************************************************************************/
 extern(C) void consoleInteger (ulong i);

/*******************************************************************************

        Вывести строку utf8 в консоль. Кодовые страницы не поддерживаются.

*******************************************************************************/

 extern(C) void consoleString (char[] s);

version (Windows)
{
/*******************************************************************************

        Adjust the content such that no partial encodings exist on the 
        right side of the provided text.

        Returns a slice of the input

*******************************************************************************/

private char[] crop (char[] s);
}
alias Console Консоль;
struct Console
{
    alias newline opCall;
    alias emit opCall;
    Console emit(char[] s)
		{
		consoleString(s);
		return *this;
		}
    Console emit(ulong i)
		{
		consoleInteger(i);
		return *this;
		}
    Console nl()
	{
                version (Windows)
                         const eol = "\r\n";
                version (Posix)
                         const eol = "\n";

                return emit (eol);
    }
	Console newline (){return this.nl();}
	alias nl нс;
}

public Console console;
alias console say;
alias say консоль;
alias консоль скажи;

проц нс(){скажи("").нс;}