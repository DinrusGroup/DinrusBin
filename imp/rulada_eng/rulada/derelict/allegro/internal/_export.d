/* A D-specific workaround. */

module derelict.allegro.internal._export;

import derelict.allegro.internal.dversion;


/*
 * Workaround for the 'export' problem.  I couldn't figure out how to solve it
 * using a .def file, since the IMPORTS directive doesn't seem to work for
 * variables.
 *
 * NB! Putting this in dintern.d creates an import conflict, because dintern
 * imports system.d.
 */
version (Windows) {
   version (STATICLINK)
      private const ADD_EXPORT = false;
   else
      private const ADD_EXPORT = true;
}
else {
   private const ADD_EXPORT = false;
}

template _export(string def)
{
   static if (ADD_EXPORT)
      const string _export = "export " ~ def;
   else
      const string _export = def;
}
