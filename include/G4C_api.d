/* Converted to D from G4C_api.h by htod */
module G4C_api;
//
//	Gui4Cli API - D. Keletsekis - 1/4/2004
//
// Includes for writting DLLs for Gui4Cli - (to be extended)..	
//
//	Contents:										
// - Structure declarations for Gui4Cli
// - Gui4Cli API function definitions
//
// NOTE: To view this file correctly, TABs should be 3 spaces long.

// =============================================================================
//	Note: ARGUMENT TEMPLATES
// =============================================================================
/*
	Commands, Events and their arguments are declared by giving a simple string, 
	containing "Name Template Name Template".. etc. The template is series of 
	letters, defining the argunents the command expects. Example:

	char DLL_COMMANDS[] = "DOUBLE NS LIST 0";

	Rules:
	- Everything must be in capitals.
	- For now, you can have a maximum of 8 arguments
	- Event names must start with X, all othes must not
	- The strings must be global, valid throughout the life of the DLL
	
	The template is a series of letters defining the arguments, as follows:

	S - A string is expected

	N - A number. This is stored as a long integer. There are no floats or
	    other types. If needed, they can be passed as strings.

	K - A Keyword. This is also stored as a long integer. A "Keyword" is a
	    numeric representation on the first 4 letters of a string. It makes 
	    it easy to declare flags, switches etc..

	U - An Optional string argunent. This is the same as "S", but there is 
	    no error if it is not given. Of course, they must be the last letter
		 in the template.

	0 - (zero) - This can only be given alone, and it means that the command
	    does not take any arguments.

   T - This can only be given alone, or as the last argument. It will cause
	    the parser to consider the remainder of the line (or all of the line)
		 as one argument - ie no quotes are needed.
*/
// =============================================================================

// include is needed for IPicture interface
//C     #ifndef __ocidl_h__
//C     #include <ocidl.idl>
