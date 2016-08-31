// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.


// Not actually part of forms, but is handy.

///
module os.win.gui.environment;

private import os.win.gui.x.dlib, std.c;

private import os.win.gui.x.winapi, os.win.gui.base, os.win.gui.x.utf, os.win.gui.event;


///
final class Environment // docmain
{
	private this();
	
	
	static:
	
	///
	Dstring commandLine() ;
	
	
	///
	void currentDirectory(Dstring cd) ;
	
	/// ditto
	Dstring currentDirectory();
	
	///
	Dstring machineName() ;
	
	///
	Dstring newLine() ;
	
	///
	OperatingSystem osVersion() ;
	
	///
	Dstring systemDirectory() ;
	
	
	// Should return int ?
	DWORD tickCount() ;
	
	///
	Dstring userName() ;
	
	///
	void exit(int code);
	
	
	///
	Dstring expandEnvironmentVariables(Dstring str);
	
	///
	Dstring[] getCommandLineArgs();
	
	///
	Dstring getEnvironmentVariable(Dstring name);
	
	
	//Dstring[Dstring] getEnvironmentVariables()
	//Dstring[] getEnvironmentVariables()
	
	
	///
	Dstring[] getLogicalDrives();
}


/+
enum PowerModes: ubyte
{
	STATUS_CHANGE,
	RESUME,
	SUSPEND,
}


class PowerModeChangedEventArgs: EventArgs
{
	this(PowerModes pm);
	
	final PowerModes mode() ;
	
	private:
	PowerModes _pm;
}
+/


/+
///
enum SessionEndReasons: ubyte
{
	SYSTEM_SHUTDOWN, ///
	LOGOFF, /// ditto
}


///
class SystemEndedEventArgs: EventArgs
{
	///
	this(SessionEndReasons reason);
	
	///
	final SessionEndReasons reason() ;
	
	private:
	SessionEndReasons _reason;
}


///
class SessionEndingEventArgs: EventArgs
{
	///
	this(SessionEndReasons reason);
	
	///
	final SessionEndReasons reason() ;
	
	
	///
	final void cancel(bool byes) ;
	/// ditto
	final bool cancel() ;
	
	
	private:
	SessionEndReasons _reason;
	bool _cancel = false;
}
+/


/+
final class SystemEvents // docmain
{
	private this();
	
	
	static:
	EventHandler displaySettingsChanged;
	EventHandler installedFontsChanged;
	EventHandler lowMemory; // GC automatically collects before this event.
	EventHandler paletteChanged;
	//PowerModeChangedEventHandler powerModeChanged; // WM_POWERBROADCAST
	SystemEndedEventHandler systemEnded;
	SessionEndingEventHandler systemEnding;
	SessionEndingEventHandler sessionEnding;
	EventHandler timeChanged;
	// user preference changing/changed. WM_SETTINGCHANGE ?
	
	
	/+
	void useOwnThread(bool byes) ;
	
	
	bool useOwnThread() ;
	+/
	
	
	private:
	//package Thread _ownthread = null;
	
	
	SessionEndReasons sessionEndReasonFromLparam(LPARAM lparam);
	
	
	void _realCheckMessage(inout Message m);
	
	package void _checkMessage(inout Message m);
}
+/


package Dstring[] parseArgs(Dstring args);


unittest
{
	Dstring[] args;
	
	args = parseArgs(`"foo" bar`);
	assert(args.length == 2);
	assert(args[0] == "foo");
	assert(args[1] == "bar");
	
	args = parseArgs(`"environment"`);
	assert(args.length == 1);
	assert(args[0] == "environment");
	
	/+
	writefln("commandLine = '%s'", Environment.commandLine);
	foreach(Dstring arg; Environment.getCommandLineArgs())
	{
		writefln("\t'%s'", arg);
	}
	+/
}


///
// Any version, not just the operating system.
class Version // docmain ?
{
	private:
	int _major = 0, _minor = 0;
	int _build = -1, _revision = -1;
	
	
	public:
	
	///
	this();
	
	
	final:
	
	/// ditto
	// A string containing "major.minor.build.revision".
	// 2 to 4 parts expected.
	this(Dstring str);
	
	/// ditto
	this(int major, int minor);
	/// ditto
	this(int major, int minor, int build);
	/// ditto
	this(int major, int minor, int build, int revision);
	
	/+ // D2 doesn't like this without () but this invariant doesn't really even matter.
	invariant
	{
		assert(_major >= 0);
		assert(_minor >= 0);
		assert(_build >= -1);
		assert(_revision >= -1);
	}
	+/
	
	
	///
	override Dstring toString();
	
	
	///
	int major() ;
	/// ditto
	int minor() ;
	/// ditto
	// -1 if no build.
	int build();
	
	/// ditto
	// -1 if no revision.
	int revision() ;
}


///
enum PlatformId: DWORD
{
	WIN_CE = cast(DWORD)-1,
	WIN32s = VER_PLATFORM_WIN32s,
	WIN32_WINDOWS = VER_PLATFORM_WIN32_WINDOWS,
	WIN32_NT = VER_PLATFORM_WIN32_NT,
}


///
final class OperatingSystem // docmain
{
	final
	{
		///
		this(PlatformId platId, Version ver);
		
		///
		override Dstring toString();
		
		///
		PlatformId platform() ;
		
		///
		// Should be version() :p
		Version ver();
	}
	
	
	private:
	PlatformId platId;
	Version vers;
}

