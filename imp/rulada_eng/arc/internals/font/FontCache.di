module arc.internals.font.FontCache;
import arc.internals.font.BoxPacker;

import arc.templates.singleton;
import arc.math.point;
import arc.math.size; 
import arc.draw.color; 
import arc.memory.routines;

import arc.texture; 

import derelict.opengl.gl;

///
class FontCache {
	mixin SingletonMix;
	///
	Texture get(Size size, out Point bl, out Point tr, out Point blCoords, out Point trCoords) {
		auto block = packer.getBlock(size);
		if (block.page >= textures.length) {
			textures ~= Texture(Size(texSize.w,	texSize.h), Color(1, 1, 1, 1)); 
		}
		
		bl = block.origin;
		tr = block.origin + block.size;

		blCoords = Point(cast(float)bl.x / texSize.w, cast(float)bl.y / texSize.h);
		trCoords = Point(cast(float)tr.x / texSize.w, cast(float)tr.y / texSize.h);
		
		return textures[block.page];
	}
	
	///
	final Point texelSize() {
		return Point(1.f / texSize.w, 1.f / texSize.h);
	}
	///
	void initialize() {
		packer = new BoxPacker;
		packer.pageSize = texSize;
	}
	
	BoxPacker		packer;
	Texture[]		textures;
	
	Size			texSize = {w: 512, h: 512};
}

///
FontCache fontCache() { return FontCache.getInstance(); } 



version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
