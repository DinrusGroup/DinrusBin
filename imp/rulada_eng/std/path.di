// Written in the D programming language.

/**
 * Macros:
 *	WIKI = Phobos/StdPath
 * Copyright:
 *	Placed into public domain.
 *	http://www.digitalmars.com
 *
 * Grzegorz Adam Hankiewicz added some documentation.
 *
 * This module is used to parse file names. All the operations
 * work only on strings; they don't perform any input/output
 * operations. This means that if a path contains a directory name
 * with a dot, functions like getExt() will work with it just as
 * if it was a file. To differentiate these cases,
 * use the std.file module first (i.e. std.file.isDir()).
 */

module std.path;

//debug=path;		// uncomment to turn on debugging printf's
//private import std.io;


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

/*****************************
 * Compare file names.
 * Возвращает:
 *	<table border=1 cellpadding=4 cellspacing=0>
 *	<tr> <td> &lt; 0	<td> filename1 &lt; filename2
 *	<tr> <td> = 0	<td> filename1 == filename2
 *	<tr> <td> &gt; 0	<td> filename1 &gt; filename2
 *	</table>
 */

version (Windows) alias std.string.icmp fcmp;

version (Posix) alias std.string.cmp fcmp;

/**************************
 * Extracts the extension from a filename or path.
 *
 * This function will search fullname from the end until the
 * first dot, path separator or first character of fullname is
 * reached. Under Windows, the drive letter separator (<i>colon</i>)
 * also terminates the search.
 *
 * Возвращает: If a dot was found, characters to its right are
 * returned. If a path separator was found, or fullname didn't
 * contain any dots or path separators, returns null.
 *
 * Выводит исключение: Nothing.
 *
 * Примеры:
 * -----
 * version(Win32)
 * {
 *     getExt(r"d:\path\foo.bat") // "bat"
 *     getExt(r"d:\path.two\bar") // null
 * }
 * version(Posix)
 * {
 *     getExt(r"/home/user.name/bar.")  // ""
 *     getExt(r"d:\\path.two\\bar")     // "two\\bar"
 *     getExt(r"/home/user/.resource")  // "resource"
 * }
 * -----
 */

string getExt(string fullname);
alias getExt дайРасш;

/**************************
 * Returns the extensionless version of a filename or path.
 *
 * This function will search fullname from the end until the
 * first dot, path separator or first character of fullname is
 * reached. Under Windows, the drive letter separator (<i>colon</i>)
 * also terminates the search.
 *
 * Возвращает: If a dot was found, characters to its left are
 * returned. If a path separator was found, or fullname didn't
 * contain any dots or path separators, returns null.
 *
 * Выводит исключение: Nothing.
 *
 * Примеры:
 * -----
 * version(Win32)
 * {
 *     getName(r"d:\path\foo.bat") => "d:\path\foo"
 *     getName(r"d:\path.two\bar") => null
 * }
 * version(Posix)
 * {
 *     getName("/home/user.name/bar.")  => "/home/user.name/bar"
 *     getName(r"d:\path.two\bar") => "d:\path"
 *     getName("/home/user/.resource") => "/home/user/"
 * }
 * -----
 */

string getName(string fullname);
alias getName дайИмя;

/**************************
 * Extracts the base name of a path.
 *
 * This function will search fullname from the end until the
 * first path separator or first character of fullname is
 * reached. Under Windows, the drive letter separator (<i>colon</i>)
 * also terminates the search.
 *
 * Возвращает: If a path separator was found, all the characters to its
 * right are returned. Otherwise, fullname is returned.
 *
 * Выводит исключение: Nothing.
 *
 * Примеры:
 * -----
 * version(Win32)
 * {
 *     getBaseName(r"d:\path\foo.bat") => "foo.bat"
 * }
 * version(Posix)
 * {
 *     getBaseName("/home/user.name/bar.")  => "bar."
 * }
 * -----
 */

string getBaseName(string fullname);
alias getBaseName дайИмяОсн;


/**************************
 * Extracts the directory part of a path.
 *
 * This function will search fullname from the end until the
 * first path separator or first character of fullname is
 * reached. Under Windows, the drive letter separator (<i>colon</i>)
 * also terminates the search.
 *
 * Возвращает: If a path separator was found, all the characters to its
 * left are returned. Otherwise, fullname is returned.
 *
 * Under Windows, the found path separator will be included in the
 * returned string if it is preceeded by a colon.
 *
 * Выводит исключение: Nothing.
 *
 * Примеры:
 * -----
 * version(Win32)
 * {
 *     getDirName(r"d:\path\foo.bat") => "d:\path"
 *     getDirName(getDirName(r"d:\path\foo.bat")) => r"d:\"
 * }
 * version(Posix)
 * {
 *     getDirName("/home/user")  => "/home"
 *     getDirName(getDirName("/home/user"))  => ""
 * }
 * -----
 */

string getDirName(string fullname);
alias getDirName дайИмяПапки;	

/********************************
 * Extracts the drive letter of a path.
 *
 * This function will search fullname for a colon from the beginning.
 *
 * Возвращает: If a colon is found, all the characters to its left
 * plus the colon are returned.  Otherwise, null is returned.
 *
 * Under Linux, this function always returns null immediately.
 *
 * Выводит исключение: Nothing.
 *
 * Примеры:
 * -----
 * getDrive(r"d:\path\foo.bat") => "d:"
 * -----
 */

string getDrive(string fullname);
alias getDrive дайДиск;

/****************************
 * Appends a default extension to a filename.
 *
 * This function first searches filename for an extension and
 * appends ext if there is none. ext should not have any leading
 * dots, one will be inserted between filename and ext if filename
 * doesn't already end with one.
 *
 * Возвращает: filename if it contains an extension, otherwise filename
 * + ext.
 *
 * Выводит исключение: Nothing.
 *
 * Примеры:
 * -----
 * defaultExt("foo.txt", "raw") => "foo.txt"
 * defaultExt("foo.", "raw") => "foo.raw"
 * defaultExt("bar", "raw") => "bar.raw"
 * -----
 */

string defaultExt(string filename, string ext);
alias defaultExt устДефРасш;

/****************************
 * Adds or replaces an extension to a filename.
 *
 * This function first searches filename for an extension and
 * replaces it with ext if found.  If there is no extension, ext
 * will be appended. ext should not have any leading dots, one will
 * be inserted between filename and ext if filename doesn't already
 * end with one.
 *
 * Возвращает: filename + ext if filename is extensionless. Otherwise
 * strips filename's extension off, appends ext and returns the
 * result.
 *
 * Выводит исключение: Nothing.
 *
 * Примеры:
 * -----
 * addExt("foo.txt", "raw") => "foo.raw"
 * addExt("foo.", "raw") => "foo.raw"
 * addExt("bar", "raw") => "bar.raw"
 * -----
 */

string addExt(string filename, string ext);
alias addExt добРасш;
/*************************************
 * Checks if path is absolute.
 *
 * Возвращает: non-zero if the path starts from the root directory (Linux) or
 * drive letter and root directory (Windows),
 * zero otherwise.
 *
 * Выводит исключение: Nothing.
 *
 * Примеры:
 * -----
 * version(Win32)
 * {
 *     isabs(r"relative\path") => 0
 *     isabs(r"\relative\path") => 0
 *     isabs(r"d:\absolute") => 1
 * }
 * version(Posix)
 * {
 *     isabs("/home/user") => 1
 *     isabs("foo") => 0
 * }
 * -----
 */

int isabs(string path);
alias isabs абс_ли;

/*************************************
 * Joins two path components.
 *
 * If p1 doesn't have a trailing path separator, one will be appended
 * to it before concatting p2.
 *
 * Возвращает: p1 ~ p2. However, if p2 is an absolute path, only p2
 * will be returned.
 *
 * Выводит исключение: Nothing.
 *
 * Примеры:
 * -----
 * version(Win32)
 * {
 *     join(r"c:\foo", "bar") => "c:\foo\bar"
 *     join("foo", r"d:\bar") => "d:\bar"
 * }
 * version(Posix)
 * {
 *     join("/foo/", "bar") => "/foo/bar"
 *     join("/foo", "/bar") => "/bar"
 * }
 * -----
 */

string join(string p1, string p2);
alias join объедени; 


/*********************************
 * Matches filename characters.
 *
 * Under Windows, the comparison is done ignoring case. Under Linux
 * an exact match is performed.
 *
 * Возвращает: non zero if c1 matches c2, zero otherwise.
 *
 * Выводит исключение: Nothing.
 *
 * Примеры:
 * -----
 * version(Win32)
 * {
 *     fncharmatch('a', 'b') => 0
 *     fncharmatch('A', 'a') => 1
 * }
 * version(Posix)
 * {
 *     fncharmatch('a', 'b') => 0
 *     fncharmatch('A', 'a') => 0
 * }
 * -----
 */

int fncharmatch(dchar c1, dchar c2);
alias fncharmatch  сверьсимиф;
/************************************
 * Matches a pattern against a filename.
 *
 * Some characters of pattern have special a meaning (they are
 * <i>meta-characters</i>) and <b>can't</b> be escaped. These are:
 * <p><table>
 * <tr><td><b>*</b></td>
 *     <td>Matches 0 or more instances of any character.</td></tr>
 * <tr><td><b>?</b></td>
 *     <td>Matches exactly one instances of any character.</td></tr>
 * <tr><td><b>[</b><i>chars</i><b>]</b></td>
 *     <td>Matches one instance of any character that appears
 *     between the brackets.</td></tr>
 * <tr><td><b>[!</b><i>chars</i><b>]</b></td>
 *     <td>Matches one instance of any character that does not appear
 *     between the brackets after the exclamation mark.</td></tr>
 * </table><p>
 * Internally individual character comparisons are done calling
 * fncharmatch(), so its rules apply here too. Note that path
 * separators and dots don't stop a meta-character from matching
 * further portions of the filename.
 *
 * Возвращает: non zero if pattern matches filename, zero otherwise.
 *
 * See_Also: fncharmatch().
 *
 * Выводит исключение: Nothing.
 *
 * Примеры:
 * -----
 * version(Win32)
 * {
 *     fnmatch("foo.bar", "*") => 1
 *     fnmatch(r"foo/foo\bar", "f*b*r") => 1
 *     fnmatch("foo.bar", "f?bar") => 0
 *     fnmatch("Goo.bar", "[fg]???bar") => 1
 *     fnmatch(r"d:\foo\bar", "d*foo?bar") => 1
 * }
 * version(Posix)
 * {
 *     fnmatch("Go*.bar", "[fg]???bar") => 0
 *     fnmatch("/foo*home/bar", "?foo*bar") => 1
 *     fnmatch("foobar", "foo?bar") => 1
 * }
 * -----
 */

int fnmatch(string filename, string pattern);
alias fnmatch сверьиф;    

/**
 * Performs tilde expansion in paths.
 *
 * There are two ways of using tilde expansion in a path. One
 * involves using the tilde alone or followed by a path separator. In
 * this case, the tilde will be expanded with the value of the
 * environment variable <i>HOME</i>.  The second way is putting
 * a username after the tilde (i.e. <tt>~john/Mail</tt>). Here,
 * the username will be searched for in the user database
 * (i.e. <tt>/etc/passwd</tt> on Unix systems) and will expand to
 * whatever path is stored there.  The username is considered the
 * string after the tilde ending at the first instance of a path
 * separator.
 *
 * Note that using the <i>~user</i> syntax may give different
 * values from just <i>~</i> if the environment variable doesn't
 * match the value stored in the user database.
 *
 * When the environment variable version is used, the path won't
 * be modified if the environment variable doesn't exist or it
 * is empty. When the database version is used, the path won't be
 * modified if the user doesn't exist in the database or there is
 * not enough memory to perform the query.
 *
 * Возвращает: inputPath with the tilde expanded, or just inputPath
 * if it could not be expanded.
 * For Windows, expandTilde() merely returns its argument inputPath.
 *
 * Выводит исключение: std.exception.OutOfMemoryException if there is not enough
 * memory to perform
 * the database lookup for the <i>~user</i> syntax.
 *
 * Примеры:
 * -----
 * import std.path;
 *
 * void process_file(string filename)
 * {
 *     string path = expandTilde(filename);
 *     ...
 * }
 * -----
 *
 * -----
 * import std.path;
 *
 * const string RESOURCE_DIR_TEMPLATE = "~/.applicationrc";
 * string RESOURCE_DIR;    // This gets expanded in main().
 *
 * int main(string[] args)
 * {
 *     RESOURCE_DIR = expandTilde(RESOURCE_DIR_TEMPLATE);
 *     ...
 * }
 * -----
 * Version: Available since v0.143.
 * Authors: Grzegorz Adam Hankiewicz, Thomas Kühne.
 */

string expandTilde(string inputPath);
alias expandTilde раскройТильду;

/**
 * Replaces the tilde from path with the environment variable HOME.
 */
private string expandFromEnvironment(string path);
//alias expandFromEnvironment раскойИзСреды; 
/**
 * Joins a path from a C string to the remainder of path.
 *
 * The last path separator from c_path is discarded. The result
 * is joined to path[char_pos .. length] if char_pos is smaller
 * than length, otherwise path is not appended to c_path.
 */
private string combineCPathWithDPath(char* c_path, string path, int char_pos);

/**
 * Replaces the tilde from path with the path from the user database.
 */
private string expandFromDatabase(string path);



