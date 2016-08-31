module os.windows;

version (Windows){public import rt.core.os.windows;}
else{ static assert(0);}		// Windows only

