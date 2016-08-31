/***************************************************************
                           lzss.h
 ***************************************************************/

module derelict.allegro.lzss;

import derelict.allegro.file : PACKFILE;


struct LZSS_PACK_DATA;
struct LZSS_UNPACK_DATA;

extern (C) {

LZSS_PACK_DATA * create_lzss_pack_data();
void free_lzss_pack_data (LZSS_PACK_DATA *dat);
int lzss_write (PACKFILE *file, LZSS_PACK_DATA *dat, int size, ubyte *buf, int last);

LZSS_UNPACK_DATA * create_lzss_unpack_data();
void free_lzss_unpack_data (LZSS_UNPACK_DATA *dat);
int lzss_read (PACKFILE *file, LZSS_UNPACK_DATA *dat, int s, ubyte *buf);

}
