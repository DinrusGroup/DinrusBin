module wx.Document;
public import wx.common;
public import wx.EvtHandler;

//! \cond VERSION
version(NOT_READY_YET){

		//! \cond EXTERN
        static extern (C) IntPtr wxDocument_ctor(IntPtr parent);
        static extern (C) void   wxDocument_SetFilename(IntPtr self, string filename, bool notifyViews);
        static extern (C) IntPtr wxDocument_GetFilename(IntPtr self);
        static extern (C) void   wxDocument_SetTitle(IntPtr self, string title);
        static extern (C) IntPtr wxDocument_GetTitle(IntPtr self);
        static extern (C) void   wxDocument_SetDocumentName(IntPtr self, string name);
        static extern (C) IntPtr wxDocument_GetDocumentName(IntPtr self);
        static extern (C) bool   wxDocument_GetDocumentSaved(IntPtr self);
        static extern (C) void   wxDocument_SetDocumentSaved(IntPtr self, bool saved);
        static extern (C) bool   wxDocument_Close(IntPtr self);
        static extern (C) bool   wxDocument_Save(IntPtr self);
        static extern (C) bool   wxDocument_SaveAs(IntPtr self);
        static extern (C) bool   wxDocument_Revert(IntPtr self);
        //static extern (C) IntPtr wxDocument_SaveObject(IntPtr self, IntPtr stream);
        //static extern (C) IntPtr wxDocument_LoadObject(IntPtr self, IntPtr stream);
        static extern (C) IntPtr wxDocument_GetCommandProcessor(IntPtr self);
        static extern (C) void   wxDocument_SetCommandProcessor(IntPtr self, IntPtr proc);
        static extern (C) bool   wxDocument_DeleteContents(IntPtr self);
        static extern (C) bool   wxDocument_Draw(IntPtr self, IntPtr wxDC);
        static extern (C) bool   wxDocument_IsModified(IntPtr self);
        static extern (C) void   wxDocument_Modify(IntPtr self, bool mod);
        static extern (C) bool   wxDocument_AddView(IntPtr self, IntPtr view);
        static extern (C) bool   wxDocument_RemoveView(IntPtr self, IntPtr view);
        static extern (C) IntPtr wxDocument_GetViews(IntPtr self);
        static extern (C) IntPtr wxDocument_GetFirstView(IntPtr self);
        static extern (C) void   wxDocument_UpdateAllViews(IntPtr self, IntPtr sender, IntPtr hint);
        static extern (C) void   wxDocument_NotifyClosing(IntPtr self);
        static extern (C) bool   wxDocument_DeleteAllViews(IntPtr self);
        static extern (C) IntPtr wxDocument_GetDocumentManager(IntPtr self);
        static extern (C) IntPtr wxDocument_GetDocumentTemplate(IntPtr self);
        static extern (C) void   wxDocument_SetDocumentTemplate(IntPtr self, IntPtr temp);
        static extern (C) bool   wxDocument_GetPrintableName(IntPtr self, IntPtr buf);
        static extern (C) IntPtr wxDocument_GetDocumentWindow(IntPtr self);
		//! \endcond

        //-----------------------------------------------------------------------------

    alias Document wxDocument;
    public class Document : EvtHandler
    {
        public  this(Document parent);
        public void SetFilename(string filename, bool notifyViews);
        public void Filename(string value);
        public string Filename() ;
        public void Title(string value);
        public string Title();
        public void DocumentName(string value);
        public string DocumentName();
        public bool DocumentSaved() ;
        public void DocumentSaved(bool value);
        public bool Close();
        public bool Save();
        public bool SaveAs();
        public bool Revert();
        public bool DeleteContents();
        public bool Draw(DC dc);
        public bool IsModified();
        public void IsModified(bool value) ;
        public void Modify(bool mod);
        public void NotifyClosing();
        public bool DeleteAllViews();
        public Window DocumentWindow() ;
    }
} // version(NOT_READY_YET)
//! \endcond
