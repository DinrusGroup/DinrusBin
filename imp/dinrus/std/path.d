module std.path;
private import stdrus;

version(Windows)
{

    /** String used to separate directory names in a path. Under
     *  Windows this is a backslash, under Linux a slash. */
    const char[1] sep = "\\";
    /** Alternate version of sep[] used in Windows (a slash). Under
     *  Linux this is empty. */
    const char[1] altsep = "/";
    /** Path separator string. A semi colon under Windows, a colon
     *  under Linux. */
    const char[1] pathsep = ";";
    /** String used to separate lines, \r\n under Windows and \n
     * under Linux. */
    const char[2] linesep = "\r\n"; /// String used to separate lines.
    const char[1] curdir = ".";	 /// String representing the current directory.
    const char[2] pardir = ".."; /// String representing the parent directory.
}
version(Posix)
{
    /** String used to separate directory names in a path. Under
     *  Windows this is a backslash, under Linux a slash. */
    const char[1] sep = "/";
    /** Alternate version of sep[] used in Windows (a slash). Under
     *  Linux this is empty. */
    const char[0] altsep;
    /** Path separator string. A semi colon under Windows, a colon
     *  under Linux. */
    const char[1] pathsep = ":";
    /** String used to separate lines, \r\n under Windows and \n
     * under Linux. */
    const char[1] linesep = "\n";
    const char[1] curdir = ".";	 /// String representing the current directory.
    const char[2] pardir = ".."; /// String representing the parent directory.
}

alias stdrus.извлекиРасш getExt;
alias stdrus.дайИмяПути getName;
alias stdrus.извлекиИмяПути getBaseName;
alias stdrus.извлекиПапку getDirName;
alias stdrus.извлекиМеткуДиска getDrive;
alias stdrus.устДефРасш defaultExt;
alias stdrus.добРасш addExt;
alias stdrus.абсПуть_ли isabs;
alias stdrus.слейПути join;
alias stdrus.сравниПути fncharmatch;
alias stdrus.сравниПутьОбразец fnmatch;
alias stdrus.разверниТильду expandTilde;

