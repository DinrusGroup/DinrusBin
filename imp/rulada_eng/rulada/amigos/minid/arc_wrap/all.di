module amigos.minid.arc_wrap.all;

import amigos.minid.api;

import amigos.minid.arc_wrap.draw.color;
import amigos.minid.arc_wrap.draw.image;
import amigos.minid.arc_wrap.draw.shape;
import amigos.minid.arc_wrap.font;
import amigos.minid.arc_wrap.input;
import amigos.minid.arc_wrap.math.collision;
import amigos.minid.arc_wrap.math.point;
import amigos.minid.arc_wrap.math.rect;
import amigos.minid.arc_wrap.math.size;
import amigos.minid.arc_wrap.sound;
import amigos.minid.arc_wrap.texture;
import amigos.minid.arc_wrap.time;
import amigos.minid.arc_wrap.window;

struct ArcLib
{
static:
	public void init(MDThread* t)
	{
		amigos.minid.arc_wrap.draw.color.init(t);
		amigos.minid.arc_wrap.draw.image.init(t);
		amigos.minid.arc_wrap.draw.shape.init(t);
		amigos.minid.arc_wrap.font.init(t);
		amigos.minid.arc_wrap.input.init(t);
		amigos.minid.arc_wrap.math.collision.init(t);
		amigos.minid.arc_wrap.math.point.init(t);
		amigos.minid.arc_wrap.math.rect.init(t);
		amigos.minid.arc_wrap.math.size.init(t);
		amigos.minid.arc_wrap.sound.init(t);
		amigos.minid.arc_wrap.texture.init(t);
		amigos.minid.arc_wrap.time.init(t);
		amigos.minid.arc_wrap.window.init(t);
	}
}
version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
