/** Make it work with both version 1 and 2 of the D language. */

module derelict.allegro.internal.dversion;


static if(is(typeof((new char[1]).idup))) {
   const D_VERSION = 2;
}
else {
   const D_VERSION = 1;
}

// DMD Phobos 1.016 and later define a 'string' alias.  Define it here in case
// of older versions.  It's probably missing from Tango too.
static if(!is(string)) {
   static if(!is(typeof((new Object()).toString()) string)) {
      alias char[] string;
   }
}

// The stringz alias is useful when a function returns a const char * in C.
static if (D_VERSION < 2)
   alias char* stringz;
else
   mixin("alias const(char)* stringz;");
   
//alias stringz ткст0;