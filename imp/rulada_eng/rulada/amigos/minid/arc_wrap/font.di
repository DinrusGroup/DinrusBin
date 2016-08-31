module amigos.minid.arc_wrap.font;

import amigos.minid.api;
import amigos.minid.bind;

import arc.draw.color;
import arc.font;
import arc.math.point;

void init(MDThread* t)
{
	WrapModule!
	(
		"arc.font",
		WrapFunc!(arc.font.open),
		WrapFunc!(arc.font.close),

		WrapNamespace!
		(
			"LCDFilter",
			WrapValue!("Standard", LCDFilter.Standard),
			WrapValue!("Crisp", LCDFilter.Crisp),
			WrapValue!("None", LCDFilter.None)
		),

		WrapType!
		(
			Font,
			"Font",
			WrapCtors!(void function(char[], int)),

			WrapMethod!(Font.getWidth!(char)),
			WrapMethod!(Font.getWidthLastLine!(char)),
			WrapMethod!(Font.getHeight),
			WrapMethod!(Font.getLineSkip),
			WrapMethod!(Font.setLineGap),
			WrapMethod!(Font.draw, void function(char[], Point, Color)),
			WrapMethod!(Font.calculateIndex!(char)),
			WrapMethod!(Font.searchIndex!(char)),
			WrapMethod!(Font.lcdFilter)
		)
	)(t);
}
version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
