module rae.canvas.RenderMethod;

/**
	* RenderMethod defines what rendering method will be used
	* for rendering.
	* NORMAL is just normal.
	* PIXELS draws a pixelperpixel rectangle according to the
	* texture size.
	* PIXELS_HORIZONTAL pixel per pixel in horizontal axis, but
	* the vertical will be stretched to Rectangle boundaries.
	* PIXELS_VERTICAL pixel per pixel in vertical axis, but
	* the horizontal will be stretched to Rectangle boundaries.
	* ASPECT draws a letterboxed rectangle inside x1,x2,y1,y2
	* which will be in the aspectratio defined by xAspect and yAspect.
	* BYPASS will bypass the rendering of this widget,
	* but it's children will be rendered. Usefull for invisible
	* containers that you can use for layout.
	*/
	
enum RenderMethod
{
	BYPASS,
	NORMAL,
	PIXELS,
	PIXELS_HORIZONTAL,
	PIXELS_VERTICAL,
	ASPECT
}



version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    }
}
