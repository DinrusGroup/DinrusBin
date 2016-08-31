module amigos.dk.callback;

import amigos.dk.utils;
import amigos.dk.event;
import amigos.dk.widget;
import amigos.dk.tcl;
import std.io;
import std.c;
import std.string;

alias void delegate(Widget,Event) Callback;

struct Command{Widget   w; Callback c;}

alias  Command[int]  CallbackMap;
static CallbackMap   callbacks;
static int           callbackId=0;
const  string        callbackPrefix="dkinter::call";

extern (C)
int callbackHandler(ClientData cd,Tcl_Interp *interp,
		    int objc, Tcl_Obj ** objv)
{

  int slot = cast(int)cd;
  if(slot in callbacks)
    {
      Event e;
      if(objc>1)
	{
	  int len;
	  e.x=safeToInt(Tcl_GetStringFromObj(objv[1],&len));
	  e.y=safeToInt(Tcl_GetStringFromObj(objv[2],&len));
	  e.keycode=safeToInt(Tcl_GetStringFromObj(objv[3],&len));
	  e.width=safeToInt(Tcl_GetStringFromObj(objv[4],&len));
	  e.height=safeToInt(Tcl_GetStringFromObj(objv[5],&len));
	  e.width=safeToInt(Tcl_GetStringFromObj(objv[6],&len));
	  e.height=safeToInt(Tcl_GetStringFromObj(objv[7],&len));
 	}
      callbacks[slot].c(callbacks[slot].w,e);
      return 0;
    }
  else
    {
      Tcl_SetResult(interp, cast(char*)"Trying to invoke non-existent callback", TCL_STATIC);
      return TCL_ERROR;
    }
}

extern (C):
void callbackDeleter(ClientData cd)
{
  int slot = cast(int)(cd);
  callbacks.remove(slot);
}

int addCallback(Widget wid,Callback clb)
{
  int newSlot=callbackId;
  callbackId++;
  Command c={wid,clb};
  ClientData d=cast(ClientData)(newSlot);
  char* name=cast(char*)(callbackPrefix~.toString(newSlot));

  Tcl_CreateObjCommand(wid.interp(),name,
		       &callbackHandler,
		       d,
		       &callbackDeleter);
  callbacks[newSlot]=c;
  return  newSlot;
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
