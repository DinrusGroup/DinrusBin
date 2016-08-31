/***************************************************************
                           datafile.h
 ***************************************************************/

module derelict.allegro.datafile;

import derelict.allegro.base;
import derelict.allegro.file : PACKFILE, УПФАЙЛ;
import derelict.allegro.gfx : BITMAP, БИТМАП;
import derelict.allegro.palette : RGB, КЗС;
import derelict.allegro.internal.dversion;


alias derelict.allegro.base.AL_ID DAT_ID;
alias derelict.allegro.base._AL_ID _DAT_ID;

const int DAT_MAGIC        = _DAT_ID!('A','L','L','.');
const int DAT_FILE         = _DAT_ID!('F','I','L','E');
const int DAT_DATA         = _DAT_ID!('D','A','T','A');
const int DAT_FONT         = _DAT_ID!('F','O','N','T');
const int DAT_SAMPLE       = _DAT_ID!('S','A','M','P');
const int DAT_MIDI         = _DAT_ID!('M','I','D','I');
const int DAT_PATCH        = _DAT_ID!('P','A','T',' ');
const int DAT_FLI          = _DAT_ID!('F','L','I','C');
const int DAT_BITMAP       = _DAT_ID!('B','M','P',' ');
const int DAT_RLE_SPRITE   = _DAT_ID!('R','L','E',' ');
const int DAT_C_SPRITE     = _DAT_ID!('C','M','P',' ');
const int DAT_XC_SPRITE    = _DAT_ID!('X','C','M','P');
const int DAT_PALETTE      = _DAT_ID!('P','A','L',' ');
const int DAT_PROPERTY     = _DAT_ID!('p','r','o','p');
const int DAT_NAME         = _DAT_ID!('N','A','M','E');
const int DAT_END          = -1;


alias DATAFILE_PROPERTY СВОЙСТВО_ФАЙЛА_ДАННЫХ;
struct DATAFILE_PROPERTY
{
alias dat дан;
alias type тип;

   char *dat;                          /* pointer to the data */
   int type;                           /* property type */
}

alias DATAFILE ФАЙЛ_ДАННЫХ;
struct DATAFILE
{
alias dat дан;
alias type тип;
alias size размер;
alias prop свойство
;
   void *dat;                          /* pointer to the data */
   int type;                           /* object type */
   int size;                           /* size of the object */
   DATAFILE_PROPERTY *prop;            /* object properties */
}

alias DATAFILE_INDEX ИНДЕКС_ФАЙЛА_ДАННЫХ;
struct DATAFILE_INDEX
{
alias filename фимя;
alias offset смещение;

   char *filename;                     /* datafile name (path) */
   int *offset;                        /* list of offsets */
}

extern (C) {

DATAFILE * load_datafile (in char *filename);

DATAFILE * load_datafile_callback (in char *filename, void (*callback) (DATAFILE *));

DATAFILE_INDEX * create_datafile_index (in char *filename);
void unload_datafile (DATAFILE *dat);
void destroy_datafile_index (DATAFILE_INDEX *index);

DATAFILE * load_datafile_object (in char *filename, in char *objectname);
DATAFILE * load_datafile_object_indexed (in DATAFILE_INDEX *index, int item);
void unload_datafile_object (DATAFILE *dat);

DATAFILE * find_datafile_object (in DATAFILE *dat, in char *objectname);
stringz get_datafile_property (in DATAFILE *dat, int type);

void register_datafile_object (int id_, void * (*load) (PACKFILE *f, int size), void (*destroy) (void *data));

void fixup_datafile (DATAFILE *data);

BITMAP * load_bitmap (in char *filename, RGB *pal);
BITMAP * load_bmp (in char *filename, RGB *pal);
BITMAP * load_bmp_pf (PACKFILE *f, RGB *pal);
BITMAP * load_lbm (in char *filename, RGB *pal);
BITMAP * load_pcx (in char *filename, RGB *pal);
BITMAP * load_pcx_pf (PACKFILE *f, RGB *pal);
BITMAP * load_tga (in char *filename, RGB *pal);
BITMAP * load_tga_pf (PACKFILE *f, RGB *pal);

int save_bitmap (in char *filename, BITMAP *bmp, in RGB *pal);
int save_bmp (in char *filename, BITMAP *bmp, in RGB *pal);
int save_bmp_pf (PACKFILE *f, BITMAP *bmp, in RGB *pal);
int save_pcx (in char *filename, BITMAP *bmp, in RGB *pal);
int save_pcx_pf (PACKFILE *f, BITMAP *bmp, in RGB *pal);
int save_tga (in char *filename, BITMAP *bmp, in RGB *pal);
int save_tga_pf (PACKFILE *f, BITMAP *bmp, in RGB *pal);

void register_bitmap_file_type (in char*ext, BITMAP * (*load) (in char *filename, RGB *pal), int (*save) (in char *filename, BITMAP *bmp, in RGB *pal));

} // extern (C)


ФАЙЛ_ДАННЫХ * загрузи_файл_данных(in сим *фимя)
	{
	return cast(ФАЙЛ_ДАННЫХ *) load_datafile (фимя);
	}
/*
ФАЙЛ_ДАННЫХ * обрвызов_загрузи_файл_данных(in сим *фимя, проц (*callback) (ФАЙЛ_ДАННЫХ *))
	{
	return cast(ФАЙЛ_ДАННЫХ *) load_datafile_callback (cast(char) фимя, cast(void) (*callback)(cast(DATAFILE *));
	}
*/
alias load_datafile_callback обрвызов_загрузки_файла_данных;

ИНДЕКС_ФАЙЛА_ДАННЫХ * создай_индекс_файла_данных(in сим *фимя)
	{
	return cast(ИНДЕКС_ФАЙЛА_ДАННЫХ *) create_datafile_index (cast(char *) фимя);
	}

проц выгрузи_файл_данных(ФАЙЛ_ДАННЫХ *дан)
	{
	unload_datafile (cast(DATAFILE *) дан);
	}

проц уничтожь_индекс_файла_данных(ИНДЕКС_ФАЙЛА_ДАННЫХ *индекс)
	{
	destroy_datafile_index (индекс);
	}

ФАЙЛ_ДАННЫХ * загрузи_объект_файла_данных(in сим *фимя, in сим *имя_объекта)
	{
	return load_datafile_object (фимя, имя_объекта);
	}

ФАЙЛ_ДАННЫХ *  загрузи_индексированный_объект_файла_данных(in ИНДЕКС_ФАЙЛА_ДАННЫХ *индекс, цел элемент)
	{
	return cast(ФАЙЛ_ДАННЫХ *) load_datafile_object_indexed(cast(DATAFILE_INDEX *) индекс, cast(int) элемент);
	}

проц выгрузи_объект_файла_данных(ФАЙЛ_ДАННЫХ *дан)
	{
	unload_datafile_object (cast(DATAFILE *) дан);
	}

ФАЙЛ_ДАННЫХ * найди_объект_файла_данных (in ФАЙЛ_ДАННЫХ *дан, in сим *имя_объекта)
{
return cast(ФАЙЛ_ДАННЫХ *) find_datafile_object (cast(DATAFILE *) дан, имя_объекта);
}

ткст0 дай_свойство_файла_данных(in ФАЙЛ_ДАННЫХ *дан, цел тип)
{
return cast(ткст0) get_datafile_property (cast(DATAFILE *) дан, тип);
}
/*
проц зарегистрируй_объект_файла_данных(int id_, void * (*load) (PACKFILE *f, int size), void (*destroy) (void *data))
{
register_datafile_object (cast(int) id_, void * (*load) (PACKFILE *f, int size), void (*destroy) (void *data));
}
*/
alias register_datafile_object зарегистрируй_объект_файла_данных;

проц фиксируй_файл_данных(ФАЙЛ_ДАННЫХ *данные)
{
fixup_datafile (cast(DATAFILE *) данные);
}

БИТМАП *  загрузи_битмап(in сим *фимя, КЗС *пал)
{
return cast(БИТМАП *) load_bitmap(cast(char *) фимя ,cast(КЗС *) пал);
}

БИТМАП * загрузи_бмп (in сим *фимя, КЗС *пал)
{
return cast(БИТМАП *) load_bmp(cast(char *) фимя ,cast(КЗС *) пал);
}

БИТМАП * загрузи_бмп_уф(УПФАЙЛ *ф, КЗС *пал)
{
return cast(БИТМАП *) load_bmp_pf (ф, пал);
}

БИТМАП * загрузи_лбм(in char *фимя, КЗС *пал)
{
return cast(БИТМАП *)  load_lbm (фимя, пал);
}

БИТМАП * загрузи_псикс (in char *фимя, КЗС *пал)
{
return cast(БИТМАП *) load_pcx(фимя, пал);
}
БИТМАП *  загрузи_псикс_уф(УПФАЙЛ *ф, КЗС *пал)
{
return cast(БИТМАП *) load_pcx_pf(ф, пал);
}

БИТМАП *  загрузи_тга(in char *фимя, КЗС *пал)
{
return cast(БИТМАП *) load_tga(фимя, пал);
}

БИТМАП * загрузи_тга_уф(УПФАЙЛ *ф, КЗС *пал)
{
return cast(БИТМАП *) load_tga_pf(ф, пал);
}

цел сохрани_битмап(in сим *фимя, БИТМАП *бмп, in КЗС *пал)
{
return cast(цел) save_bitmap (фимя, бмп, пал);
}

цел сохрани_бмп(in сим *фимя, БИТМАП *бмп, in КЗС *пал)
{
return cast(цел) save_bmp (фимя, бмп, пал);
}

цел сохрани_бмп_уф(УПФАЙЛ *ф, БИТМАП *бмп, in КЗС *пал)
{
return cast(цел) save_bmp_pf (ф, бмп, пал);
}

цел сохрани_псикс(in сим *фимя, БИТМАП *бмп, in КЗС *пал)
{
return cast(цел) save_pcx (фимя, бмп, пал);
}

цел сохрани_псикс_уф(УПФАЙЛ *ф, БИТМАП *бмп, in КЗС *пал)
{
return cast(цел) save_pcx_pf (ф, бмп, пал);
}

цел сохрани_тга(in сим *фимя, БИТМАП *бмп, in КЗС *пал)
{
return cast(цел) save_tga (фимя, бмп, пал);
}

цел сохрани_тга_уф(УПФАЙЛ *ф, БИТМАП *бмп, in КЗС *пал)
{
return cast(цел) save_tga_pf (ф, бмп, пал);
}

/*
void register_bitmap_file_type (in сим*ext, БИТМАП * (*load) (in сим *фимя, КЗС *пал), int (*save) (in сим *фимя, БИТМАП *бмп, in КЗС *пал));

*/
alias register_bitmap_file_type  зарегистрируй_тип_битмап_файла;