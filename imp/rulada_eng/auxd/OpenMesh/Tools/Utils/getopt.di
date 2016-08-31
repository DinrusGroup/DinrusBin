//============================================================================
// getopt.d - 
// Written in the D Programming Language (http://www.digitalmars.com/d)
/*****************************************************************************
 * Description: 
 *   <TODO:>
 *
 * Author:  William V. Baxter III, OLM Digital, Inc.
 * Created: 28 Aug 2007
 * Copyright:
 *     Copyright (c) 2007-2008 Bill Baxter, OLM Digital, Inc. (D version)
 *     Copyright (c) 1987, 1993, 1994
 *	   The Regents of the University of California.  All rights reserved.
 * License: 
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. All advertising materials mentioning features or use of this software
 *    must display the following acknowledgement:
 *	This product includes software developed by the University of
 *	California, Berkeley and its contributors.
 * 4. Neither the name of the University nor the names of its contributors
 *    may be used to endorse or promote products derived from this software
 *    without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 */
//============================================================================

module auxd.OpenMesh.Tools.Utils.getopt;

//import auxd.OpenMesh.Core.System.compiler;

import std.io;
import std.string;
import std.c;

// PUBLIC VARIABLES
int	opterr = 1,		/* if error message should be printed */
	optind = 1,		/* index into parent argv vector */
	optopt,			/* character checked for validity */
	optreset;		/* reset getopt */
string	optarg;		/* argument associated with option */

const BADCH	 = cast(int)'?';
const BADARG = cast(int)':';

/*
 * getopt --
 *  Parse argc/argv argument vector.
 *
 * The getopt function gets the next option argument from the
 * argument list specified by the argv and argc arguments. Normally
 * these values come directly from the arguments received by main.
 *
 * The options argument is a string that specifies the option
 * characters that are valid for this program. An option character in
 * this string can be followed by a colon (`:') to indicate that it
 * takes a required argument.
 *
 * getopt has three ways to deal with options that follow non-options
 * argv elements. The special argument `--' forces in all cases the
 * end of option scanning.
 *
 *       * The default is to permute the contents of argv while scanning it
 *         so that eventually all the non-options are at the end. This
 *         allows options to be given in any order, even with programs
 *         that were not written to expect this.
 *
 *       * If the options argument string begins with a hyphen (`-'), this
 *         is treated specially. It permits arguments that are not
 *          options to be returned as if they were associated with
 *          option character `\1'.
 *
 *    The getopt function returns the option character for the
 *    next command line option. When no more option arguments
 *    are available, it returns -1. There may still be more
 *    non-option arguments; you must compare the external
 *    variable optind against the argc parameter to check this.
 *
 * If the option has an argument, getopt returns the argument by
 * storing it in the variable optarg. You don't ordinarily need to
 * copy the optarg string, since it is a pointer into the original
 * argv array, not into a static area that might be overwritten.
 *
 *    If getopt finds an option character in argv that was not
 *    included in options, or a missing option argument, it returns
 *    `?' and sets the external variable optopt to the actual
 *    option character. If the first character of options is a
 *    colon (`:'), then getopt returns `:' instead of `?' to
 *    indicate a missing option argument. In addition, if the
 *    external variable opterr is nonzero (which is the default),
 *    getopt prints an error message.
 */
int getopt(string[] nargv, string ostr)
{
    int nargc = nargv.length;
    
    string __progname = nargv[0];

    static char* place = "";      /* option letter processing */
    char *oli;              /* option letter list index */

    if (optreset || !*place) {      /* update scanning pointer */
        optreset = 0;
        if (optind >= nargc || *(place = nargv[optind].ptr) != '-') {
            place = "";
            return (-1);
        }
        if (place[1] && *++place == '-') {  /* found "--" */
            ++optind;
            place = "";
            return (-1);
        }
    }                   /* option letter okay? */
    if ((optopt = cast(int)*place++) == cast(int)':' ||
        (null==(oli = strchr(toStringz(ostr), optopt)))) 
    {
        /*
         * if the user didn't specify '-' as an option,
         * assume it means -1.
         */
        if (optopt == cast(int)'-')
            return (-1);
        if (!*place)
            ++optind;
        if (opterr && *ostr != ':') {
            fwritefln(stderr,
                      "%s: illegal option -- %s\n", __progname, cast(char)optopt);
        }
        return (BADCH);
    }
    if (*++oli != ':') {            /* don't need argument */
        optarg = null;
        if (!*place)
            ++optind;
    }
    else {                  /* need an argument */
        if (*place)         /* no white space */
            optarg = place[0..strlen(place)];
        else if (nargc <= ++optind) {   /* no arg */
            place = "";
            if (*ostr == ':')
                return (BADARG);
            if (opterr) {
                fwritefln(stderr,
                          "%s: option requires an argument -- %c\n",
                          __progname, optopt);
            }
            return (BADCH);
        }
        else                /* white space */
            optarg = nargv[optind];
        place = "";
        ++optind;
    }
    return (optopt);            /* dump back option letter */
}


unittest {
    int c;
    uint ALL = 0xf;
    uint got = 0;
    while ( (c=getopt(["program", "-h", "-t", "-f", "filename", "-b"], "bhf:t")) != -1 )
    {
        switch (c) {
        case 'h':
            got |= 1u;
            break;
        case 't':
            got |= 2u;
            break;
        case 'f':
            got |= 4u;
            assert(optarg == "filename");
            break;
        case 'b':
            got |= 8u;
            break;
        default:
            std.io.writefln("ERROR: %s", cast(char)c);
        }
    }
    assert(got == ALL, std.string.format("Got was just ", got, ", not ", ALL));
}

//--- Emacs setup ---
// Local Variables:
// c-basic-offset: 4
// indent-tabs-mode: nil
// End:


version (build) {
    debug {
        pragma(link, "auxd");
    } else {
        pragma(link, "auxd");
    }
}
