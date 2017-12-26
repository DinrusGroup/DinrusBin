module wx.DataObject;
public import wx.common;
public import wx.ArrayString;

	public abstract class DataObject : wxObject
	{
		public enum DataDirection
		{
			Get = 0x01,
			Set = 0x02,
			Both = 0x03
		}
		
		//---------------------------------------------------------------------

		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		override protected void dtor();
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxDataObjectSimple_ctor(IntPtr format);
		static extern (C) void wxDataObjectSimple_dtor(IntPtr self);
		static extern (C) void wxDataObjectSimple_SetFormat(IntPtr self, IntPtr format);
		static extern (C) uint wxDataObjectSimple_GetDataSize(IntPtr self);
		static extern (C) bool wxDataObjectSimple_GetDataHere(IntPtr self, IntPtr buf);
		static extern (C) bool wxDataObjectSimple_SetData(IntPtr self, uint len, IntPtr buf);
		//! \endcond
		
		//---------------------------------------------------------------------

	alias DataObjectSimple wxDataObjectSimple;
	public class DataObjectSimple : DataObject
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		override protected void dtor() ;
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxTextDataObject_ctor(string text);
		static extern (C) void wxTextDataObject_dtor(IntPtr self);
		static extern (C) void wxTextDataObject_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) int wxTextDataObject_GetTextLength(IntPtr self);
		static extern (C) IntPtr wxTextDataObject_GetText(IntPtr self);
		static extern (C) void wxTextDataObject_SetText(IntPtr self, string text);
		//! \endcond
		
		//---------------------------------------------------------------------

	alias TextDataObject wxTextDataObject;
	public class TextDataObject : DataObjectSimple
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		public this(string text);
		override protected void dtor();
		public int TextLength();
		public string Text();
		public void Text(string value) ;
	}
	
	//---------------------------------------------------------------------

		//! \cond EXTERN
		static extern (C) IntPtr wxFileDataObject_ctor();
		static extern (C) void wxFileDataObject_dtor(IntPtr self);
		static extern (C) void wxFileDataObject_RegisterDisposable(IntPtr self, Virtual_Dispose onDispose);
		static extern (C) void wxFileDataObject_AddFile(IntPtr self, string filename);
		static extern (C) IntPtr wxFileDataObject_GetFilenames(IntPtr self);
		//! \endcond
		
		//---------------------------------------------------------------------
		
	alias FileDataObject wxFileDataObject;
	public class FileDataObject : DataObjectSimple
	{
		public this(IntPtr wxobj);
		private this(IntPtr wxobj, bool memOwn);
		public this();
		override protected void dtor();
		public void AddFile(string filename);
		public string[] Filenames();
	}
