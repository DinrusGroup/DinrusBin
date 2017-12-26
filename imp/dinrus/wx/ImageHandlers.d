
module wx.ImageHandlers;
public import wx.common;
public import wx.Image;

  //! \cond EXTERN
  public static extern (C) IntPtr BMPHandler_ctor();
  public static extern (C) IntPtr ICOHandler_ctor();
  public static extern (C) IntPtr CURHandler_ctor();
  public static extern (C) IntPtr ANIHandler_ctor();
  public static extern (C) IntPtr GIFHandler_ctor();
  public static extern (C) IntPtr PNGHandler_ctor();
  public static extern (C) IntPtr PCXHandler_ctor();
  public static extern (C) IntPtr JPEGHandler_ctor();
  public static extern (C) IntPtr XPMHandler_ctor();
  public static extern (C) IntPtr PNMHandler_ctor();
  public static extern (C) IntPtr TIFFHandler_ctor();
  //! \endcond
  
  
  
alias BMPHandler wxBMPHandler;
public class BMPHandler : ImageHandler 
{
  public this(IntPtr ptr) ;  
  public this();
}

alias ICOHandler wxICOHandler;
public class ICOHandler : BMPHandler 
{
  public this(IntPtr ptr) ;
  public this();
}

alias CURHandler wxCURHandler;
public class CURHandler : ICOHandler 
{
  public this(IntPtr ptr);
  public this();
}

alias ANIHandler wxANIHandler;
public class ANIHandler : CURHandler 
{
  public this(IntPtr ptr) ;
  public this();
}

alias PNGHandler wxPNGHandler;
public class PNGHandler : ImageHandler 
{
  public this(IntPtr ptr) ;
  public this();
}

alias GIFHandler wxGIFHandler;
public class GIFHandler : ImageHandler 
{
  public this(IntPtr ptr) ;
  public this();
}

alias PCXHandler wxPCXHandler;
public class PCXHandler : ImageHandler 
{
  public this(IntPtr ptr);
  public this();
}

alias JPEGHandler wxJPEGHandler;
public class JPEGHandler : ImageHandler 
{
  public this(IntPtr ptr);
  public this();
}


alias PNMHandler wxPNMHandler;
public class PNMHandler : ImageHandler 
{
  public this(IntPtr ptr);
  public this();
}

alias XPMHandler wxXPMHandler;
public class XPMHandler : ImageHandler 
{
  public this(IntPtr ptr) ;
  public this();
}

alias TIFFHandler wxTIFFHandler;
public class TIFFHandler : ImageHandler 
{
  public this(IntPtr ptr);
  public this();
}
