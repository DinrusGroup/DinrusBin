module amigos.dk.tcl;

extern (C):
//pragma(lib, "tk85.lib");
//pragma(lib,"tcl85.lib");
pragma(lib, "amigos.lib");

const uint TCL_OK	= 0;
const uint TCL_ERROR	= 1;


typedef void *ClientData;

alias void (Tcl_FreeInternalRepProc) (Tcl_Obj objPtr);
alias void (Tcl_CmdDeleteProc) (ClientData clientData);
alias int (Tcl_ObjCmdProc) (ClientData clientData,Tcl_Interp *interp, int objc, Tcl_Obj ** objv);
alias void (Tcl_DupInternalRepProc) (Tcl_Obj srcPtr,Tcl_Obj dupPtr);
alias void (Tcl_UpdateStringProc) (Tcl_Obj objPtr);
alias int (Tcl_SetFromAnyProc) (Tcl_Interp *interp,Tcl_Obj objPtr);
alias long		Tcl_WideInt;
alias ulong		Tcl_WideUInt;
alias void (Tcl_FreeProc) (char *blockPtr);

const Tcl_FreeProc* TCL_STATIC = cast(Tcl_FreeProc *) 0;

struct Tk_Window_   {}; 
alias  Tk_Window_* Tk_Window;
struct Tcl_Command_ {}; 
alias  Tcl_Command_* Tcl_Command;

struct Tcl_Interp {
    char *result;		/* If the last command returned a string
				 * result, this points to it. */
    void (*freeProc) (char *blockPtr);
				/* Zero means the string result is
				 * statically allocated. TCL_DYNAMIC means
				 * it was allocated with ckalloc and should
				 * be freed with ckfree. Other values give
				 * the address of procedure to invoke to
				 * free the result. Tcl_Eval must free it
				 * before executing next command. */
    int errorLine;              /* When TCL_ERROR is returned, this gives
                                 * the line number within the command where
                                 * the error occurred (1 if first line). */
}

struct Tcl_ObjType {
    char *name;			/* Name of the type, e.g. "int". */
    Tcl_FreeInternalRepProc *freeIntRepProc;
				/* Called to free any storage for the type's
				 * internal rep. NULL if the internal rep
				 * does not need freeing. */
    Tcl_DupInternalRepProc *dupIntRepProc;
    				/* Called to create a new object as a copy
				 * of an existing object. */
    Tcl_UpdateStringProc *updateStringProc;
    				/* Called to update the string rep from the
				 * type's internal representation. */
    Tcl_SetFromAnyProc *setFromAnyProc;
    				/* Called to convert the object's internal
				 * rep to this type. Frees the internal rep
				 * of the old type. Returns TCL_ERROR on
				 * failure. */
}


/*
 * One of the following structures exists for each object in the Tcl
 * system. An object stores a value as either a string, some internal
 * representation, or both.
 */

struct Tcl_Obj {
    int refCount;		/* When 0 the object will be freed. */
    char *bytes;		/* This points to the first byte of the
				 * object's string representation. The array
				 * must be followed by a null byte (i.e., at
				 * offset length) but may also contain
				 * embedded null characters. The array's
				 * storage is allocated by ckalloc. NULL
				 * means the string rep is invalid and must
				 * be regenerated from the internal rep.
				 * Clients should use Tcl_GetStringFromObj
				 * or Tcl_GetString to get a pointer to the
				 * byte array as a readonly value. */
    int length;			/* The number of bytes at *bytes, not
				 * including the terminating null. */
    Tcl_ObjType *typePtr;	/* Denotes the object's type. Always
				 * corresponds to the type of the object's
				 * internal rep. NULL indicates the object
				 * has no internal rep (has no type). */
    union internalRep_ {			/* The internal representation: */
	int intValue;		/*   - an int integer value */
	double doubleValue;	/*   - a double-precision floating value */
	void *otherValuePtr;	/*   - another, type-specific value */
	Tcl_WideInt wideValue;	/*   - a int value */
	struct twoPtrValue_ {		/*   - internal rep as two pointers */
	    void *ptr1;
	    void *ptr2;
	}
	twoPtrValue_ twoPtrValue;
    }
    internalRep_ internalRep;
}


extern(C) int Tcl_Eval (Tcl_Interp * interp,char * string);

extern(C) Tcl_Interp *	Tcl_CreateInterp ();

extern(C) char * Tcl_GetStringFromObj (Tcl_Obj * objPtr,int * lengthPtr);

extern(C) void	 Tcl_SetResult (Tcl_Interp * interp, char * str, Tcl_FreeProc * freeProc);

extern(C) Tcl_Command	Tcl_CreateObjCommand (Tcl_Interp * interp, char * cmdName, 
					      Tcl_ObjCmdProc * proc, ClientData clientData, 
					      Tcl_CmdDeleteProc * deleteProc);

extern(C) int		Tcl_Init (Tcl_Interp * interp);
extern(C) int		Tk_Init (Tcl_Interp * interp);
extern(C) Tk_Window	Tk_MainWindow (Tcl_Interp * interp);
extern(C) void		Tcl_DeleteInterp (Tcl_Interp * interp);
extern(C) void		Tk_MainLoop ();


version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
