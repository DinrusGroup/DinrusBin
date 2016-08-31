module amigos.minid.arc_wrap.texture;

import amigos.minid.api;
import amigos.minid.bind;

import arc.draw.color;
import arc.math.size;
import arc.texture;

void init(MDThread* t)
{
	WrapModule!
	(
		"arc.texture",
		WrapFunc!(arc.texture.incrementTextureCount),
		WrapFunc!(arc.texture.assignTextureID),
		WrapFunc!(arc.texture.load),
		WrapFunc!(arc.texture.enableTexturing),

		WrapType!
		(
			arc.texture.Texture,
			"Texture",
			WrapCtors!
			(
				void function(char[]),
				void function(Size, Color)
			),

			WrapMethod!(arc.texture.Texture.getID),
			WrapMethod!(arc.texture.Texture.getFile),
			WrapMethod!(arc.texture.Texture.getSize),
			WrapMethod!(arc.texture.Texture.getTextureSize)
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
