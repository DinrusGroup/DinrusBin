/***************************************************************
                           internal/aintern.h
 ***************************************************************/

module derelict.allegro.internal.aintern;

import derelict.allegro.internal._export;


/* length in bytes of the cpu_vendor string */
const int _AL_CPU_VENDOR_SIZE = 32;

/* packfile stuff */
mixin(_export!(
   "extern extern (C) {"
      "int _packfile_filesize;"
      "int _packfile_datasize;"
   "}"
));
