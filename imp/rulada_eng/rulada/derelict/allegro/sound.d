/***************************************************************
                           sound.h
 ***************************************************************/

module derelict.allegro.sound;

public import derelict.allegro.digi;
public import derelict.allegro.stream;
public import derelict.allegro.midi;

extern (C) {

void reserve_voices (int digi_voices, int midi_voices);
void set_volume_per_voice (int scale);

int install_sound (int digi, int midi, in char *cfg_path);
void remove_sound ();

int install_sound_input (int digi, int midi);
void remove_sound_input ();

void set_volume (int digi_volume, int midi_volume);
void set_hardware_volume (int digi_volume, int midi_volume);

void get_volume (int *digi_volume, int *midi_volume);
void get_hardware_volume (int *digi_volume, int *midi_volume);

void set_mixer_quality (int quality);
int get_mixer_quality ();
int get_mixer_frequency ();
int get_mixer_bits ();
int get_mixer_channels ();
int get_mixer_voices ();
int get_mixer_buffer_length ();

}  // extern (C)

проц резервируй_голоса(цел диги_голоса, цел миди_голоса)
	{
	 reserve_voices (cast(int) диги_голоса, cast(int) миди_голоса);
	}

проц уст_громкость_голоса(цел шкала)
	{
	 set_volume_per_voice (cast(int) шкала);
	}

цел установи_звук(цел диги, цел миди, in сим *конф_путь)
	{
	return cast(цел) install_sound (cast(int) диги, cast(int) миди, cast(char *) конф_путь);
	}

проц удали_звук()
	{
	remove_sound ();
	}

цел установи_ввод_звука(цел диги, цел миди)
	{
	return cast(цел) install_sound_input (cast(int) диги, cast(int) миди);
	}

проц удали_ввод_звука()
	{
	 remove_sound_input ();
	}

проц уст_громкость(цел диги_громкость, цел миди_громкость)
	{
	set_volume (cast(int) диги_громкость, cast(int) миди_громкость);
	}

проц уст_аппаратн_громкость(цел диги_громкость, цел миди_громкость)
	{
	 set_hardware_volume (cast(int) диги_громкость, cast(int) миди_громкость);
	}

проц дай_громкость(цел *диги_громкость, цел *миди_громкость)
	{
	 get_volume (cast(int *) диги_громкость, cast(int *) миди_громкость);
	}

проц дай_аппаратн_громкость(цел *диги_громкость, цел *миди_громкость)
	{
	get_hardware_volume (cast(int *) диги_громкость, cast(int *) миди_громкость);
	}

проц уст_качество_микшера(цел качество)
	{
	set_mixer_quality (cast(int) качество);
	}

цел дай_качество_микшера()
	{
	return cast(цел) get_mixer_quality ();
	}

цел дай_частоту_микшера()
	{
	return cast(цел) get_mixer_frequency ();
	}

цел дай_биты_микшера()
	{
	return cast(цел) get_mixer_bits ();
	}

цел дай_каналы_микшера()
	{
	return cast(цел) get_mixer_channels ();
	}

цел дай_голоса_микшера()
	{
	return cast(цел) get_mixer_voices ();
	}

цел дай_длину_буфера_микшера()
	{
	return cast(цел) get_mixer_buffer_length ();
	}