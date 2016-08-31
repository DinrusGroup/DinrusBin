// Written in the D programming language

/*
 *  Copyright (C) 2003-2009 by Digital Mars, http://www.digitalmars.com
 *  Written by Matthew Wilson and Walter Bright
 *
 *  Incorporating idea (for execvpe() on Linux) from Russ Lewis
 *
 *  Updated: 21st August 2004
 *
 *  This software is provided 'as-is', without any express or implied
 *  warranty. In no event will the authors be held liable for any damages
 *  arising from the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute it
 *  freely, subject to the following restrictions:
 *
 *  o  The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *  o  Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *  o  This notice may not be removed or altered from any source
 *     distribution.
 */

/**
 * Macros:
 *	WIKI=Phobos/StdProcess
 */

module std.process;

private import std.c;
private import std.string;

проц пауза();
/**
 * Выполнить команду в _командной оболочке.
 *
 * Возвращает: статус выхода команды
 */

int system(string command);
цел система (ткст команда);

alias system sys;
alias система сис;

private void toAStringz(char[][] a, char**az);


/* ========================================================== */

alias std.c._P_WAIT P_WAIT;
alias std.c._P_NOWAIT P_NOWAIT;

int spawnvp(int mode, string pathname, string[] argv);
цел пускпрог(цел режим, ткст путь, ткст[] арги);

/* ========================================================== */

/**
 * Execute program specified by pathname, passing it the arguments (argv)
 * and the environment (envp), returning the exit status.
 * The 'p' versions of exec search the PATH environment variable
 * setting for the program.
 */

int execv(string pathname, string[] argv);
цел выппрог(ткст путь, ткст[] арги);
/** ditto */
int execve(string pathname, string[] argv, string[] envp);
цел выппрог(ткст путь, ткст[] арги, ткст[] перемср);

/** ditto */
int execvp(string pathname, string[] argv);
цел выппрогcp(ткст путь, ткст[] арги);

/** ditto */
int execvpe(string pathname, string[] argv, string[] envp);
цел выппрогср(ткст путь, ткст[] арги, ткст[] перемср);
