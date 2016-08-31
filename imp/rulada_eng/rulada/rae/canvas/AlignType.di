module rae.canvas.AlignType;

enum AlignType
{
	CENTER, //default?
	TOP,
	BOTTOM,
	BEGIN, //depending on reading direction
	END, //depending on reading direction
	LEFT, //absolutely, independant of reading direction
	RIGHT, //absolutely, independant of reading direction
	/*
	//TODO:
	TOP_LEFT, //absolutely, independant of reading direction ...
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT
	*/
	//CUSTOM //?
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
