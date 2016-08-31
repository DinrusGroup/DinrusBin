module amigos.minid.arc_wrap.draw.image;

import amigos.minid.api;
import amigos.minid.bind;

import arc.draw.image;

void init(MDThread* t)
{
 	WrapModule!
	(
		"arc.draw.image",
		WrapFunc!(arc.draw.image.drawImage),
		WrapFunc!(arc.draw.image.drawImageTopLeft),
		WrapFunc!(arc.draw.image.drawImageSubsection)
	)(t);
}
version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
