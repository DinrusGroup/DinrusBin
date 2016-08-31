//|
//| PNG and JPEG image decoder/encoder library
//| 
//| Public Domain.
//|
//| Author: Andrew Fedoniouk, http://terrainformatica.com
//|

module auxc.imageio;

version( build )
{
	pragma(link, "auxC");
}
else
{
version (Windows)
{
  pragma(lib, "auxC");
}
else
{
  pragma(lib, "imageio.lib");
}
}
extern (C) 
{
  // ImageCtor.  Callback function.
  // Called by C side with parameters:
  // - pctorPrm - see DecodeImage, pctorPrm;
  // - width - width of image in pixels;
  // - height - height of image in pixels;
  // - bytesPerPixel - color capacity, possible values: 3 (rgb) and 4(rgba)
  // - rowPtrs - vector of ubyte* [height] - application shall fill it by valid pointers to
  //   rows of created image;
  //   Возвращает:
  // = non-zero, if application created image structure and filled rowPtrs by valid pointers;
  // = zero, otherwise.
 
  alias int function(void* pctorPrm, uint width, uint height, int bytesPerPixel, ubyte** rowPtrs) ImageCtor;
  
  // DecodeImage function, parameters:
  // - pctor - reference to the callback funtion;
  // - pctorPrm - parameter being passed "as is" to the calback function;
  // - src - pointer to start of the buffer containing PNG or JPEG encoded image;
  // - srclength - length of src buffer in bytes;
  //   Возвращает:
  // = non-zero, if image was decoded successfully;
  // = zero, otherwise.
  int DecodeImage(ImageCtor pctor, void* pctorPrm, ubyte* src, uint srclength);
}
