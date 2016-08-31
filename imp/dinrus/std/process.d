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

private import std.string;
private import cidrus;

alias system sys;
alias система сис;
/*alias сис система;
alias spawnvp отдпроцп;
alias execv выпп;
alias execve выппс;
alias execvp выппроцп;
alias execvpe выппроцпс;
*/

проц пауза(){сис("pause");}

/**
 * Execute command in a _command shell.
 *
 * Returns: exit status of command
 */
цел система (ткст команда)
{
return cast(цел) system(cast(string) команда);
}

int system(string command)
{
    return cidrus.system(toStringz(command));
}

private void toAStringz(char[][] a, char**az)
{
    foreach(char[] s; a)
    {
        *az++ = toStringz(s);
    }
    *az = null;
}


/* ========================================================== */

//version (Windows)
//{
//    int spawnvp(int mode, string pathname, string[] argv)
//    {
//	char** argv_ = cast(char**)alloca((char*).sizeof * (1 + argv.length));
//
//	toAStringz(argv, argv_);
//
//	return cidrus.spawnvp(mode, toStringz(pathname), argv_);
//    }
//}

// Incorporating idea (for spawnvp() on linux) from Dave Fladebo

alias cidrus._P_WAIT P_WAIT;
alias cidrus._P_NOWAIT P_NOWAIT;

цел пускпрог(цел режим, ткст путь, ткст[] арги)
{
return cast(int) spawnvp(cast(int) режим, cast(string) путь, cast(string[]) арги);
}

int spawnvp(int mode, string pathname, string[] argv)
{
    auto argv_ = cast(char**)alloca((char*).sizeof * (1 + argv.length));

    toAStringz(argv, argv_);

    version (Posix)
    {
        return _spawnvp(mode, toStringz(pathname), argv_);
    }
    else
    {
        return cidrus.spawnvp(mode, toStringz(pathname), argv_);
    }
}

version (Posix)
{
private import os.posix;
int _spawnvp(int mode, char *pathname, char **argv)
{
    int retval = 0;
    pid_t pid = fork();

    if(!pid)
    {   // child
        cidrus.execvp(pathname, argv);
        goto Lerror;
    }
    else if(pid > 0)
    {   // parent
        if(mode == _P_NOWAIT)
        {
            retval = pid; // caller waits
        }
        else
        {
            while(1)
            {
                int status;
                pid_t wpid = waitpid(pid, &status, 0);
                if(exited(status))
                {
                    retval = exitstatus(status);
                    break;
                }
                else if(signaled(status))
                {
                    retval = -termsig(status);
                    break;
                }
                else if(stopped(status)) // ptrace support
                    continue;
                else
                    goto Lerror;
            }
        }

        return retval;
    }

Lerror:
    retval = getErrno;
    char[80] buf = void;
    throw new Exception(
        "Cannot spawn " ~ toString(pathname) ~ "; "
                      ~ toString(strerror_r(retval, buf.ptr, buf.length))
                      ~ " [errno " ~ toString(retval) ~ "]");
}   // _spawnvp
private
{
bool stopped(int status)    { return cast(bool)((status & 0xff) == 0x7f); }
bool signaled(int status)   { return cast(bool)((cast(char)((status & 0x7f) + 1) >> 1) > 0); }
int  termsig(int status)    { return status & 0x7f; }
bool exited(int status)     { return cast(bool)((status & 0x7f) == 0); }
int  exitstatus(int status) { return (status & 0xff00) >> 8; }
}   // private
}   // version (Posix)

/* ========================================================== */

/**
 * Execute program specified by pathname, passing it the arguments (argv)
 * and the environment (envp), returning the exit status.
 * The 'p' versions of exec search the PATH environment variable
 * setting for the program.
 */
цел выппрог(ткст путь, ткст[] арги)
{
return cast(цел) execv(cast(string) путь, cast(string[]) арги);
}

int execv(string pathname, string[] argv)
{
    auto argv_ = cast(char**)alloca((char*).sizeof * (1 + argv.length));

    toAStringz(argv, argv_);

    return cidrus.execv(toStringz(pathname), argv_);
}

/** ditto */
цел выппрог(ткст путь, ткст[] арги, ткст[] перемср)
{
return cast(цел) execve(cast(string) путь, cast(string[]) арги, cast(string[]) перемср);
}

int execve(string pathname, string[] argv, string[] envp)
{
    auto argv_ = cast(char**)alloca((char*).sizeof * (1 + argv.length));
    auto envp_ = cast(char**)alloca((char*).sizeof * (1 + envp.length));

    toAStringz(argv, argv_);
    toAStringz(envp, envp_);

    return cidrus.execve(toStringz(pathname), argv_, envp_);
}

/** ditto */
цел выппрогcp(ткст путь, ткст[] арги)
{
return cast(цел) execvp(cast(string) путь, cast(string[]) арги);
}

int execvp(string pathname, string[] argv)
{
    auto argv_ = cast(char**)alloca((char*).sizeof * (1 + argv.length));

    toAStringz(argv, argv_);

    return cidrus.execvp(toStringz(pathname), argv_);
}

/** ditto */
цел выппрогср(ткст путь, ткст[] арги, ткст[] перемср)
{
return cast(цел) execve(cast(string) путь, cast(string[]) арги, cast(string[]) перемср);
}

int execvpe(string pathname, string[] argv, string[] envp)
{
version (Posix)
{
    // Is pathname rooted?
    if(pathname[0] == '/')
    {
        // Yes, so just call execve()
        return execve(pathname, argv, envp);
    }
    else
    {
        // No, so must traverse PATHs, looking for first match
	string[]    envPaths    =   std.string.split(std.string.toString(cidrus.getenv("PATH")), ":");
        int         iRet        =   0;

        // Note: if any call to execve() succeeds, this process will cease 
        // execution, so there's no need to check the execve() result through
        // the loop.

        foreach(string pathDir; envPaths)
        {
            string  composite   =  pathDir ~ "/" ~ pathname;

            iRet = execve(composite, argv, envp);
        }
        if(0 != iRet)
        {
            iRet = execve(pathname, argv, envp);
        }

        return iRet;
    }
}
else version(Windows)
{
    auto argv_ = cast(char**)alloca((char*).sizeof * (1 + argv.length));
    auto envp_ = cast(char**)alloca((char*).sizeof * (1 + envp.length));

    toAStringz(argv, argv_);
    toAStringz(envp, envp_);

    return cidrus.execvpe(toStringz(pathname), argv_, envp_);
}
else
{
    static assert(0);
} // version
}

/* ////////////////////////////////////////////////////////////////////////// */

version(MainTest)
{
    int main(string[] args)
    {
        if(args.length < 2)
        {
            printf("Must supply executable (and optional arguments)\n");

            return 1;
        }
        else
        {
            string[]    dummy_env;
            
            dummy_env ~= "VAL0=value";
            dummy_env ~= "VAL1=value";

/+
            foreach(string arg; args)
            {
                printf("%.*s\n", arg);
            }
+/

//          int i = execv(args[1], args[1 .. args.length]);
//          int i = execvp(args[1], args[1 .. args.length]);
            int i = execvpe(args[1], args[1 .. args.length], dummy_env);

            printf("exec??() has returned! Error code: %d; errno: %d\n", i, /* cidrus.getErrno() */-1);

            return 0;
        }
    }
}

/* ////////////////////////////////////////////////////////////////////////// */
