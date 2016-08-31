/***************************************************************
                           config.h
 ***************************************************************/
module derelict.allegro.config;

import derelict.allegro.internal.dversion;


extern (C) {

void set_config_file (in char *filename);
void set_config_data (in char *data, int length);
void override_config_file (in char *filename);
void override_config_data (in char *data, int length);
void flush_config_file();
void reload_config_texts (in char *new_language);

void push_config_state();
void pop_config_state();

void hook_config_section (in char *section, int (*intgetter) (in char *, int), in char * (*stringgetter) (in char *, in char *), void (*stringsetter) (in char *, in char *));
int config_is_hooked (in char *section);

char * get_config_string (in char *section, in char *name, in char *def);
int get_config_int (in char *section, in char *name, int def);
int get_config_hex (in char *section, in char *name, int def);
float get_config_float (in char *section, in char *name, float def);
int get_config_id (in char *section, in char *name, int def);
char ** get_config_argv (in char *section, in char *name, int *argc);
stringz get_config_text (in char *msg);

void set_config_string (in char *section, in char *name, in char *val);
void set_config_int (in char *section, in char *name, int val);
void set_config_hex (in char *section, in char *name, int val);
void set_config_float (in char *section, in char *name, float val);
void set_config_id (in char *section, in char *name, int val);

int list_config_entries (in char *section, in char ***names);
int list_config_sections (in char ***names);
void free_config_entries (in char ***names);

}  // extern (C)
