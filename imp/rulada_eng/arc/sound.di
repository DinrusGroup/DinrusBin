/******************************************************************************* 

	Uses OpenAL to play Ogg and Wav files. 

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Special thanks to Eric Poggel (JoeCoder) for contributing his OpenAL playing code
	to ArcLib. 

	Description:    
		Uses OpenAL to play Ogg and Wav sound files. Use the SoundFile class to load 
	a sound file, and use the Sound class which takes a SoundFile argument to play 
	the loaded sound class. 


	Examples:
	--------------------
	import arc.sound;
	
	int main()
	{
		arc.sound.open();

		Sound snd = new Sound(new SoundFile("vorbis.ogg"));

		while(gameloop)
		{
			if (playSound)
			{
				snd.stop(); 
				snd.play();
			}

			snd.process(); 
		}
		
		arc.sound.close(); 
	}
	--------------------

*******************************************************************************/

module arc.sound; 

public import derelict.openal.al;

import 	
	derelict.ogg.vorbis, 
	derelict.ogg.ogg,
	derelict.util.exception;

import 	
	std.mmfile,
	std.c,
	//std.c,
	//std.c,
	std.gc,
	std.string;

import 
	arc.log,
	arc.types,
	arc.math.routines,
	arc.math.point;
	
static import arc.templates.array;
import std.io;

public 
{
	/// Open OpenAL device 
	void open();    
	/// Close OpenAL device 
	void close();	
	/// calls process on all sounds
	void process();    
	/// turn sound on 
	void on();
	/// turn sound off
	void off();	
	/// tell if sound is on or off
	bool isSoundOn();	
	bool isSoundInitialized();
	/// Set position of sound listener 
	void setListenerPosition(Point pos);
	/// Set velocity of listener 
	void setListenerVelocity(Point vel);
	/// set orientation of listener 
	void setListenerOrientation(Point ori);
	/// get listener position 
	Point getListenerPos();	
	/// get listener velocity 
	Point getListenerVel();
	/// get listener orientation 
	Point getListenerOri();	
	/** 
		Makes a sound get processed when arc.sound.process is called.
		You must call unregisterAutoProcessSound (preferably in the destructor
		of the owning object): otherwise the sound can't get garbage collected
		and the sound might continue playing.
	**/
	void registerAutoProcessSound(Sound s);
	/// ditto
	void unregisterAutoProcessSound(Sound s);
}

private 
{
	// Audio
	ALCdevice	*al_device;
	ALCcontext	*al_context;
	
	// sound list of all created sounds
	Sound[] soundList;
}



/// A class that emits a sound, not to be mistaken with a SoundFile.
class Sound
{	protected:

	uint		al_source;		// OpenAL index of this Sound Resource
	SoundFile		sound;			// The Sound Resource (file) itself.

	arcfl		pitch = 1.0;
	arcfl		radius = 256;	// The radius of the Sound that plays.
	arcfl		volume = 1.0;
	arcfl 	gain   = 1.0; 
	bool		looping = false;
	bool		paused  = false;	// true if paused or stopped

	int			size;			// number of buffers that we use at one time
	bool		enqueue = true;	// Keep enqueue'ing more buffers, false if no loop and at end of track.
	uint		buffer_start;	// the first buffer in the array of currently enqueue'd buffers
	uint		buffer_end;		// the last buffer in the array of currently enqueue'd buffers
	uint		to_process;		// the number of buffers to queue next time.

	public:
	/// open with sound file 
	this(SoundFile argSound)
	{
		if(soundInitialized)
		{		
			alGenSources(1, &al_source); 
			setSound(argSound); 
	
			setPaused(paused);
			setPitch(pitch);
			setGain(gain); 
			setLoop(looping); 
			setVolume(volume); 
			setRadius(radius);
		}
	}
	
	/// Destructor
	~this()
	{
		if (soundInitialized)
		{
			if(al_context != null)
			{ // Error if this is destructed after Device de-init.
				stop();
				alDeleteSources(1, &al_source);
			}
		}
	}
	
	/// Return the Sound Resource that this SoundNode plays.
	SoundFile getSound();

	/// Set the Sound Resource that this SoundNode will play.
	void setSound(SoundFile _sound);
	/// set gain of sound 
	void setGain(arcfl argGain);
	/// set position of sound 
	void setPosition(Point pos);

	/// set velocity of sound
	void setVelocity(Point vel);

	/// Set the pitch of the SoundNode.
	arcfl getPitch();

	/** Set the pitch of the SoundNode.
	 *  This has nothing to do with the frequency of the loaded Sound Resource.
	 *  \param pitch Less than 1.0 is deeper, greater than 1.0 is higher. */
	void setPitch(arcfl _pitch);

	/// Get the radius of the SoundNode
	arcfl getRadius();

	/** Set the radius of the SoundNode.  The volume of the sound falls off at a rate of
	 *  inverse distance squared.  The default radius is 256.
	 *	\param The sound will be 1/2 its volume at this distance.
	 *  The accuracy of this code should probably be checked. */
	void setRadius(arcfl _radius);
	/// Get the volume (gain) of the SoundNode
	arcfl getVolume();

	/** Set the volume (gain) of the SoundNode.
	 *  \param volume 1.0 is the default. */
	void setVolume(arcfl _volume);

	/// Does the Sound loop when playback is finished?
	bool getLooping();

	/// Set whether the playback of the SoundNode loops when playback is finished.
	void setLoop(bool _looping=true);

	/// Is the sound currently paused (or stopped?)
	bool getPaused() ;

	/// Set whether the playback of the SoundNode is paused.
	void setPaused(bool _paused=true);

	/// Alias of setPaused(false);
	void play();

	/// Alias of setPaused(true);
	void pause();

	/** Seek to the position in the track.  Seek has a precision of .05 secs.
	 *  seek() throws an exception if the value is outside the range of the Sound */
	void seek(double seconds);

	/// Tell how many seconds we've played of the file
	double tell();
	/// Stop the SoundNode from playing and rewind it to the beginning.
	void stop();

	/** Enqueue new buffers for this SoundNode to play
	 *  Takes into account pausing, looping and all kinds of other things. */
	void updateBuffers();

	/// Update overridden to update buffers.
	void process();
}

// Sound Resource Files //////////////////////////////////////////////////////////

/** A Sound is a represenation of sound data in system memory.
 *  Sounds use a BaseSoundFile as a member variable, which abstracts away
 *  the differences between different sound formats.
 *  During initialization, a Sound loads the sound data from a file and
 *  passes it on to OpenAL for playback, as it's needed. */
class SoundFile
{	protected:

	ubyte		format;  		// wav, ogg, etc.
	BaseSoundFile	sound_file;
	uint		al_format;		// Number of channels and uncompressed bit-rate.

	uint[]		buffers;		// holds the OpenAL id name of each buffer for the song
	uint[]		buffers_ref;	// counts how many SoundNodes are using each buffer
	uint		buffer_num;		// total number of buffers
	uint		buffer_size;	// size of each buffer in bytes, always a multiple of 4.
	uint		buffers_per_sec = 25;// ideal is between 5 and 500.  Higher values give more seek precision.
									// but limit the number of sounds that can be playing concurrently.

	public:

	/** Load a sound from a file.
	 *  Note that the file is not closed until the destructor is called.
	 *  \param source Filename of the sound to load.*/
	this(char[] filename)
	{
		if (soundInitialized)
		{	
			if (!std.file.exists(filename))
			{
				writefln("Sound File ", filename, " does not exist!"); 
			} 
	
			if (!(filename in soundFileList))
			{
				// Get first four bytes of sound file to determine type
				// And then load the file.  sound_file will have all of our important info
				MmFile file = new MmFile(filename);
				if (file[0..4]=="RIFF")
					sound_file = new WaveFile(filename);
				else if (file[0..4]=="OggS")
					sound_file = new VorbisFile(filename);
				else throw new Exception("Unrecognized sound format '"~cast(char[])file[0..4]~"' for file '"~filename~"'.");
				delete file;
	
				// Determine OpenAL format
				if (sound_file.channels==1 && sound_file.bits==8)  		al_format = AL_FORMAT_MONO8;
				else if (sound_file.channels==1 && sound_file.bits==16) al_format = AL_FORMAT_MONO16;
				else if (sound_file.channels==2 && sound_file.bits==8)  al_format = AL_FORMAT_STEREO8;
				else if (sound_file.channels==2 && sound_file.bits==16) al_format = AL_FORMAT_STEREO16;
				else throw new Exception("Sound must be 8 or 16 bit and mono or stero format.");
	
				// Calculate the parameters for our buffers
				int one_second_size = (sound_file.bits/8)*sound_file.frequency*sound_file.channels;
				arcfl seconds = sound_file.size/cast(double)one_second_size;
				buffer_num = cast(int)(seconds*buffers_per_sec);
				buffer_size= one_second_size/buffers_per_sec;
				int sample_size = sound_file.channels*sound_file.bits/8;
				buffer_size = (buffer_size/sample_size)*sample_size;	// ensure a multiple of our sample size
				buffers.length = buffers_ref.length = buffer_num;	// allocate empty buffers
				
				soundFileList[filename] = this; 
				soundFileList.rehash; 
			}
			else
			{
				// set to one already loaded 
				this = soundFileList[filename]; 
			}
		}
	}

	/// Tell OpenAL to release the sound, close the file
	~this()
	{	
		if (soundInitialized)
		{
			freeBuffers(0, buffer_num);	// ensure every buffer is released
		}
	}

	/// Get the frequency of the sound (usually 22050 or 44100)
	uint getFrequency()	;

	/** Get a pointer to the array of OpenAL buffer id's used for this sound.
	 *  allocBuffers() and freeBuffers() are used to assign and release buffers from the sound source.*/
	uint[] getBuffers();

	/// Get the number of buffers this sound was divided into
	uint getBuffersLength();

	/// Get the number of buffers created for each second of this sound
	uint getBuffersPerSecond();

	/// Get the length of the sound in seconds
	double getLength();

	/// Return the size of the uncompressed sound data, in bytes.
	uint getSize();
	/// Get the filename this Sound was loaded from.
	char[] getSource();
	/// get buffers 
	uint[] getBuffers(int first, int last);

	/** Return an array of OpenAL Buffers starting at first.
	 *  This can accept buffers outside of the range of buffers and
	 *  will wrap them around to support easy looping. */
	void allocBuffers(int first, int number);

	/** Mark the range of buffers for freeing.
	 *  This will decrement the reference count for each of the buffers
	 *  and will release it once it's at zero. */
	void freeBuffers(int first, int number);

	/// Print useful information about the loaded sound file.
	void print();
}



/** BaseSoundFile is an abstract class for loading and seeking
 *  sound data in a multimedia file.  A file is opened and closed
 *  in its constructor / destructor and getBuffer() can be used for fetching any data.
 *  To add support for a new sound file format, create a class
 *  that inherits from BaseSoundFile and override its methods. */
private abstract class BaseSoundFile
{
	ubyte	channels;
	int		frequency;	// 22050hz, 44100hz?
	int		bits;		// 8bit, 16bit?
	int		size;		// in bytes
	char[]	source;
	char[][]comments;	// Header info from audio file (not used yet)

	/// Load the given file and parse its headers
	this(char[] filename)
	{	source = filename;
		//Log.write("Loading sound '" ~ filename ~ "'.");
	}

	/** Return a buffer of uncompressed sound data.
	 *  Both parameters are measured in bytes. */
	ubyte[] getBuffer(int offset, int size);
	/// Print useful information about the loaded sound file.
	void print();
}


/// A Wave implementation of BaseSoundFile
private class WaveFile : BaseSoundFile
{
	MmFile	file;

	/// Open a wave file and store attributes from its headers
	this(char[] filename)
	{	
		super(filename);
		file = new MmFile(filename);

		// First 4 bytes of Wave file should be "RIFF"
		if (file[0..4] != "RIFF")
			throw new Exception("'"~filename~"' is not a RIFF file.");
		// Skip size value (4 bytes)
		if (file[8..12] != "WAVE")
			throw new Exception("'"~filename~"' is not a WAVE file.");
		// Skip "fmt ", format length, format tag (10 bytes)
		channels 	= (cast(ushort[])file[22..24])[0];
		frequency	= (cast(uint[])file[24..28])[0];
		// Skip average bytes per second, block align, bytes by capture (6 bytes)
		bits		= (cast(ushort[])file[34..36])[0];
		// Skip 'data' (4 bytes)
		size		= (cast(uint[])file[40..44])[0];
	}

	/// Free the file we loaded
	~this()
	{	
		//delete file;
	}

	/** Return a buffer of uncompressed sound data.
	 *  Both parameters are measured in bytes. */
	ubyte[] getBuffer(int offset, int _size);

}

/// An Ogg Vorbis implementation of BaseSoundFile
private class VorbisFile : BaseSoundFile
{
	OggVorbis_File vf;		// struct for our open ov file.
	int current_section;	// used interally by ogg vorbis
	FILE *file;
	ubyte[] buffer;			// used for returning data

	/// Open an ogg vorbis file and store attributes from its headers
	this(char[] filename)
	{	
		super(filename);

		// Open the file
		file = fopen(toStringz(filename), "rb");
		if(ov_open(file, &vf, null, 0) < 0)
			throw new Exception("'"~filename~"' is not an Ogg Vorbis file.\n");
		vorbis_info *vi = ov_info(&vf, -1);

		// Get relevant data from the file
		channels = vi.channels;
		frequency = vi.rate;
		bits = 16;	// always 16-bit for ov?
		size = ov_pcm_total(&vf, -1)*(bits/8)*channels;
	}

	/// Free memory and close file
	~this()
	{	ov_clear(&vf);
		fclose(file);
		//delete buffer;
	}

	/** Return a buffer of uncompressed sound data.
	 *  Both parameters are measured in bytes. */
	ubyte[] getBuffer(int offset, int _size);
    
}

private
{
    // handle missing OpenAL functions 
    bool handleMissingOpenAL(char[] libname, char[] procName);
    // load up derelict functions from dll/so
    void loadDerelict();
    
    // unload derelict from mem 
    void unloadDerelict();
    
}

private 
{
	// list of soundfiles that are already loaded 
	SoundFile[char[]] soundFileList;
	
	// whether sound is 'on' or not
	bool soundOn = true;
	
	// whether sound has been initialized properly
	bool soundInitialized = false;
}


version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
