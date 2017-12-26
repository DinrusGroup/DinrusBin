module wx.Config;
public import wx.common;
public import wx.Font;
public import wx.Colour;
public import wx.wxString;

    public enum EntryType 
    {
        Unknown,
        String,
        Boolean,
        Integer,
        Float
    }
    
    // Style flags for constructor style parameter
    public enum ConfigStyleFlags
    {
    	wxCONFIG_USE_LOCAL_FILE = 1,
    	wxCONFIG_USE_GLOBAL_FILE = 2,
    	wxCONFIG_USE_RELATIVE_PATH = 4,
    	wxCONFIG_USE_NO_ESCAPE_CHARACTERS = 8
    }


		//! \cond EXTERN
        static extern (C) IntPtr wxConfigBase_Set(IntPtr pConfig);
        static extern (C) IntPtr wxConfigBase_Get(bool createOnDemand);
        static extern (C) IntPtr wxConfigBase_Create();
        static extern (C) void   wxConfigBase_DontCreateOnDemand();
        static extern (C) void   wxConfigBase_SetPath(IntPtr self, string strPath);
        static extern (C) IntPtr wxConfigBase_GetPath(IntPtr self);
        static extern (C) bool   wxConfigBase_GetFirstGroup(IntPtr self, IntPtr str, inout int lIndex);
        static extern (C) bool   wxConfigBase_GetNextGroup(IntPtr self, IntPtr str, inout int lIndex);
        static extern (C) bool   wxConfigBase_GetFirstEntry(IntPtr self, IntPtr str, inout int lIndex);
        static extern (C) bool   wxConfigBase_GetNextEntry(IntPtr self, IntPtr str, inout int lIndex);
        static extern (C) int    wxConfigBase_GetNumberOfEntries(IntPtr self, bool bRecursive);
        static extern (C) int    wxConfigBase_GetNumberOfGroups(IntPtr self, bool bRecursive);
        static extern (C) bool   wxConfigBase_HasGroup(IntPtr self, string strName);
        static extern (C) bool   wxConfigBase_HasEntry(IntPtr self, string strName);
        static extern (C) bool   wxConfigBase_Exists(IntPtr self, string strName);
        static extern (C) int    wxConfigBase_GetEntryType(IntPtr self, string name);
        static extern (C) bool   wxConfigBase_ReadStr(IntPtr self, string key, IntPtr pStr);
        static extern (C) bool   wxConfigBase_ReadStrDef(IntPtr self, string key, IntPtr pStr, string defVal);
        static extern (C) bool   wxConfigBase_ReadInt(IntPtr self, string key, inout int pl);
        static extern (C) bool   wxConfigBase_ReadIntDef(IntPtr self, string key, inout int pl, int defVal);
        static extern (C) bool   wxConfigBase_ReadDbl(IntPtr self, string key, inout double val);
        static extern (C) bool   wxConfigBase_ReadDblDef(IntPtr self, string key, inout double val, double defVal);
        static extern (C) bool   wxConfigBase_ReadBool(IntPtr self, string key, inout bool val);
        static extern (C) bool   wxConfigBase_ReadBoolDef(IntPtr self, string key, inout bool val, bool defVal);
        static extern (C) IntPtr wxConfigBase_ReadStrRet(IntPtr self, string key, string defVal);
        static extern (C) int    wxConfigBase_ReadIntRet(IntPtr self, string key, int defVal);
        static extern (C) bool   wxConfigBase_WriteStr(IntPtr self, string key, string val);
        static extern (C) bool   wxConfigBase_WriteInt(IntPtr self, string key, int val);
        static extern (C) bool   wxConfigBase_WriteDbl(IntPtr self, string key, double val);
        static extern (C) bool   wxConfigBase_WriteBool(IntPtr self, string key, bool val);
        static extern (C) bool   wxConfigBase_Flush(IntPtr self, bool bCurrentOnly);
        static extern (C) bool   wxConfigBase_RenameEntry(IntPtr self, string oldName, string newName);
        static extern (C) bool   wxConfigBase_RenameGroup(IntPtr self, string oldName, string newName);
        static extern (C) bool   wxConfigBase_DeleteEntry(IntPtr self, string key, bool bDeleteGroupIfEmpty);
        static extern (C) bool   wxConfigBase_DeleteGroup(IntPtr self, string key);
        static extern (C) bool   wxConfigBase_DeleteAll(IntPtr self);
        static extern (C) bool   wxConfigBase_IsExpandingEnvVars(IntPtr self);
        static extern (C) void   wxConfigBase_SetExpandEnvVars(IntPtr self, bool bDoIt);
        static extern (C) IntPtr wxConfigBase_ExpandEnvVars(IntPtr self, string str);
        static extern (C) void   wxConfigBase_SetRecordDefaults(IntPtr self, bool bDoIt);
        static extern (C) bool   wxConfigBase_IsRecordingDefaults(IntPtr self);
        static extern (C) IntPtr wxConfigBase_GetAppName(IntPtr self);
        static extern (C) void   wxConfigBase_SetAppName(IntPtr self, string appName);
        static extern (C) IntPtr wxConfigBase_GetVendorName(IntPtr self);
        static extern (C) void   wxConfigBase_SetVendorName(IntPtr self, string vendorName);
        static extern (C) void   wxConfigBase_SetStyle(IntPtr self, int style);
        static extern (C) int    wxConfigBase_GetStyle(IntPtr self);
		//! \endcond

		//---------------------------------------------------------------------

    // although it wxConfig is not derived from wxobj we do not change it.
    // Use Config.Get() to get an instance.
    alias Config wxConfig;
    public class Config : wxObject
    {
        public this(IntPtr wxobj);	
	    public static wxObject New(IntPtr ptr);
        public static Config Set(Config config);
        public static Config Get(bool createOnDemand);
	    public static Config Get();
        public static Config Create();
        public void DontCreateOnDemand();
        public void Path(string value) ;
        public string Path();
        public bool GetFirstGroup(inout string str, inout int lIndex);
        public bool GetNextGroup(inout string str, inout int lIndex);
        public bool GetFirstEntry(inout string str, inout int lIndex);
        public bool GetNextEntry(inout string str, inout int lIndex);
        public int GetNumberOfEntries(bool bRecursive);
        public int GetNumberOfGroups(bool bRecursive);
        public bool HasGroup(string strName);
        public bool HasEntry(string strName);
        public bool Exists(string strName);
        public EntryType GetEntryType(string name);
        public bool Read(string key, inout string str);
        public bool Read(string key, inout string str, string defVal);
        public bool Read(string key, inout int pl);
        public bool Read(string key, inout int pl, int defVal);
        public bool Read(string key, inout double val);
        public bool Read(string key, inout double val, double defVal);
        public bool Read(string key, inout bool val);
        public bool Read(string key, inout bool val, bool defVal);
        public bool Read(string key, inout Font val);
        public bool Read(string key, inout Font val, Font defVal);
        public bool Read(string key, inout Colour val);
	   private static int hex2int(string str);
        public bool Read(string key, inout Colour val, Colour defVal);
        //public string Read(string key, string defVal);
        public int Read(string key, int defVal);
        public bool Read(string key, bool defVal) ;
        public Colour Read(string key, Colour defVal);
        public Font Read(string key, Font defVal);
        public bool Write(string key, string val);
        public bool Write(string key, int val);
        public bool Write(string key, double val);
        public bool Write(string key, bool val);
    	private static void tohex(char* s,uint value);
        public bool Write(string key, Colour col);
        public bool Write(string key, Font val);
        public bool Flush(bool bCurrentOnly);
        public bool RenameEntry(string oldName, string newName);
        public bool RenameGroup(string oldName, string newName);
        public bool DeleteEntry(string key, bool bDeleteGroupIfEmpty);
        public bool DeleteGroup(string key);
        public bool DeleteAll();
        public bool ExpandEnvVars();
        public void ExpandEnvVars(bool value) ;
        //public string ExpandEnvVars(string str);
        public void RecordDefaults(bool value);
        public bool RecordDefaults() ;
        public string AppName();
        public void AppName(string value) ;
        public string VendorName();
        public void VendorName(string value);
        public void Style(int value);
        public int Style();
    }

