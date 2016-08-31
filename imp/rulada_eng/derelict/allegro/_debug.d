/***************************************************************
                           debug.h
 ***************************************************************/

module derelict.allegro._debug;  // 'debug' is a keyword in D

version (Tango) {
   import tango.core.Exception;
   private alias AssertException AssertError;
}
else {
   import std.exception;
}

debug version = DEBUGMODE;

extern (C) {

void al_assert (in char *file, int linenr);
void al_trace (in char *msg, ...);

void register_assert_handler (int (*handler) (in char *msg));
void register_trace_handler (int (*handler) (in char *msg));

}  // extern (C)


version (DEBUGMODE) {
   alias al_trace TRACE;

   void ASSERT(bool condition, in char[] file, uint line)
   {
      if (!condition)
         al_assert(file.ptr, line);
   }

   void ASSERT(in void* ptr, in char[] file, uint line) {
      ASSERT(ptr !is null, file, line);
   }

   void ASSERT(in Object obj, in char[] file, uint line) {
      try {
         /*
          * D's assert as of dmd 2.002 is a bit odd for objects.  The second
          * assert actually checks the invariant, but it doesn't check that the
          * reference is not null before doing so.  So it can cause an access
          * violation. Combining both into 'assert(obj !is null && obj)'
          * does not work.
          */
         assert(obj !is null);
         assert(obj);
      }
      catch (AssertError e) {
         ASSERT(0, file, line);
      }
   }
}
else {
   void TRACE(lazy char* msg, ...) {}
   void ASSERT(lazy bool condition, in char[] file, uint line) {}
   void ASSERT(lazy void* ptr, in char[] file, uint line) {}
   void ASSERT(lazy Object obj, in char[] file, uint line) {}
}
