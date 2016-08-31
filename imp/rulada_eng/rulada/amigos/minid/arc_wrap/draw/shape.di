module amigos.minid.arc_wrap.draw.shape;

import amigos.minid.api;
import amigos.minid.bind;

import arc.draw.shape;

void init(MDThread* t)
{
	WrapModule!
	(
		"arc.draw.shape",
		WrapFunc!(arc.draw.shape.drawPixel),
		WrapFunc!(arc.draw.shape.drawLine),
		WrapFunc!(arc.draw.shape.drawCircle),
		WrapFunc!(arc.draw.shape.drawRectangle),
		WrapFunc!(arc.draw.shape.drawPolygon)
	)(t);
}
version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
