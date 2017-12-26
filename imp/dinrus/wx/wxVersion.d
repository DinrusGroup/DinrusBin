
module wx.wxVersion;
public import wx.common;


		//! \cond EXTERN
		static extern (C) int wxVersion_MAJOR_VERSION();
		static extern (C) int wxVersion_MINOR_VERSION();
		static extern (C) int wxVersion_RELEASE_NUMBER();
		static extern (C) int wxVersion_SUBRELEASE_NUMBER();
		static extern (C) IntPtr wxVersion_VERSION_STRING();
		static extern (C) int wxVersion_ABI_VERSION();
		//! \endcond

public int wxMAJOR_VERSION();
public int wxMINOR_VERSION() ;
public int wxRELEASE_NUMBER() ;
public int wxSUBRELEASE_NUMBER() ;
public string wxVERSION_STRING();
public int wxABI_VERSION();

