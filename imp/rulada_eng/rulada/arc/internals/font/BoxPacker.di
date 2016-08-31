module arc.internals.font.BoxPacker;


private {
	import arc.math.point; 
	import arc.math.size; 
	import arc.memory.routines;
	import std.math : lrint;
	
	import std.io;
}



private {
	const float acceptableHeightRatio = 0.6f;
	const float heightExtraMult = 1.15f;
	
	static assert (1.f / heightExtraMult >= acceptableHeightRatio);
	static assert (heightExtraMult >= 1.f);
	
	
	int extendedHeight(int h) {
		int h2 = lrint(heightExtraMult * h);
		while (cast(float)h / h2 < acceptableHeightRatio) --h2;
		assert (h2 >= h);
		return h2;
	}
}



// TODO: garbage collection
class BoxPacker {
	Block* getBlock(Size size) {
		Block* res;
		
		float				bestRatio = 0.f;
		PackerLine*	bestLine = null;
		
		foreach (inout page; pages) {
			foreach (inout line; page.lines) {
				if (line.size.h < size.h) continue;
				if (line.size.w - line.xoffset < size.w) continue;
				
				float ratio = cast(float)size.h / line.size.h;
				if (ratio > bestRatio) {
					bestRatio = ratio;
					bestLine = &line;
				}
			}
		}
		
		if (bestLine !is null && bestRatio >= acceptableHeightRatio) {
			return bestLine.getBlock(size);
		} else {
			foreach (inout page; pages) {
				auto line = page.extendCache(size);
				if (line) return line.getBlock(size);
			}
			
			return extendCache(size).getBlock(size);
		}
	}
	
	
	PackerPage extendCache(Size minSize) {
		debug writefln(`BoxPacker: Creating a new cache page: %s`, pages.length);
		pages ~= new PackerPage(pageSizeContaining(minSize), pages.length);
		return pages[$-1];
	}
	
	
	Size pageSizeContaining(Size minSize) {
		assert (minSize.w <= pageSize.w);
		assert (minSize.h <= pageSize.h);
		return pageSize;
	}
	
	
	Size			pageSize = {w: 512, h: 512};
	PackerPage[]	pages;
}



class PackerPage {
	this (Size size, int page) {
		this.size = size;
		this.page = page;
	}
	
	
	Block* getBlock(Size size) {
		Block* res;
		
		foreach (inout line; lines) {
			if ((res = line.getBlock(size)) !is null) return res;
		}
		
		auto ext = extendCache(Size(size.w, extendedHeight(cast(int)size.h)));
		if (ext is null) return null;
		
		return ext.getBlock(size);
	}
	
	
	PackerLine* extendCache(Size size) {
		if (this.size.h < size.h) return null;
		lines.append(PackerLine(Point(0, this.size.h - size.h), Size(this.size.w, size.h), page));
		this.size.h -= size.h;
		return &lines[$-1];
	}
	
	
	int				page;
	PackerLine[]	lines;
	Size			size;
}



struct PackerLine {
	static PackerLine opCall(Point origin, Size size, int page) {
		PackerLine res;
		res.origin = origin;
		res.size = size;
		res.page = page;
		debug writefln(`* creating a new cache line. origin: %s   size: %s   page: %s`, origin, size, page);
		return res;
	}
	
	
	Block* getBlock(Size size) {
		if (this.size.w < size.w || this.size.h < size.h) return null;
		blocks.append(Block(this.origin + Point(xoffset, 0), size, page));
		this.xoffset += size.w;
		return &blocks[$-1];
	}


	Point	origin;
	Size	size;
	int		xoffset;
	int		page;
	
	Block[]	blocks;
}



struct Block {
	Point	origin;
	Size	size;
	int		page;

	static Block opCall(Point origin, Size size, int page) {
		Block res;
		res.origin = origin;
		res.size = size;
		res.page = page;
		return res;
	}
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
