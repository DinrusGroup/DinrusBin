/******************************************************************************* 

	Font class renders truetype fonts. 

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
		Font class renders truetype fonts. Based on Tom S.'s font rendering code.

    Examples:
    -------------------------------------------------------------------------------
    import arc.font;

	int main() 
	{
		// initializes input
		arc.font.open();
		
		Font f = new Font("font.ttf", 12); 
		
		// while the user hasn't closed the window
		while (true)
		{
			f.draw(cast(dchar[])"Text UTF32", Point(x,y), Color(r,g,b,a)); 
			f.draw(cast(char[])"Text UTF16", Point(x,y), Color(r,g,b,a)); 
		}

		arc.font.close()
	
		return 0;
	}
    -------------------------------------------------------------------------------


*******************************************************************************/

module arc.font;

import 
	arc.math.point,
	arc.math.size,
	arc.math.arcfl,
	arc.texture,
	arc.draw.color,
	arc.memory.routines,
	arc.text.routines,
	arc.window,
	arc.internals.font.FontCache; 

import 
	std.utf,
	std.string,
	std.math,
	std.path,
	std.stdio,
	std.file : fileRead = read;
		
import 
	derelict.opengl.gl,
	derelict.freetype.ft,
	derelict.util.loader,
	derelict.util.exception,
	derelict.opengl.extension.ext.blend_color; 

///
struct Glyph 
{
	Point[2]	texCoords;
	Texture		texture;
	Size		size;
	Point		offset;
	Point		advance;
	uint		ftIndex; 
}

///
enum FontAntialiasing 
{
	None,		/// glyphs will be aliased
	Grayscale,	/// should be best for CRTs
	LCD_RGB,	/// optimal for most LCDs
	LCD_BGR		/// some LCDs may have BGR subpixel layouts
}

///
enum BlendingMode {
	Alpha,
	Subpixel,
	None
}


///
enum LCDFilter 
{
	Standard,	// this is standard FreeType's subpixel filter. Basically, a triangular kernel
	Crisp,		// this one is a compromise between the default lcd filter, no filter and non-lcd aliased renderings
	None		// doesn't do any subpixel filtering, will result in massive color fringes
}

/// initialize font
void open(bool castInt_=true) 
{
	// load freetype lib 
	if (ftLib is null) loadFtLib();
		
	// see if we should cast font to int or not 
	castInt = castInt_; 
	
	// load wanted the OpenGL Extension //
	
	// hack around static this() failing to work with .lib files, manually register extension
	DerelictGL.registerExtensionLoader(&EXTBlendColor.load);

	// try loading extension with static this
	DerelictGL.loadExtensions();
}

/// close font
void close()
{
}

/// Font class 
class Font
{
	/// load font with path and size 
	this(char[] fontPath, int size)
	{
		nameStr = fontPath ~ .toString(size); 
		
		if (!(nameStr in fontList))
		{
			this.fontData = cast(ubyte[])fileRead(fontPath);		// we'll store the data in a buffer, because FreeType doesn't copy it.

			FT_Open_Args args;
			args.memory_base = this.fontData.ptr;
			args.memory_size = this.fontData.length;
			args.flags = FT_OPEN_MEMORY | FT_OPEN_PARAMS;
			args.driver = null;
			
			// for debugging/testing/whatever reasons, we may want to see how the unpatented hinting behaves...
			version (UnpatentedHinting) {
				// ... if so, add the appropriate tag
				FT_Parameter[1] params;
				params[0].tag = FT_MAKE_TAG!('u', 'n', 'p', 'a');

				args.num_params = params.length;
				args.params = params.ptr;
			}
			
			const int faceIdx = 0;
			auto error = FT_Open_Face(ftLib, &args, faceIdx, &fontFace);
			assert (0 == error);
			
			// this could use a better approach, but it seems to work for all TrueType fonts I've tested so far
			error = FT_Set_Pixel_Sizes(fontFace, 0, size);
			assert (0 == error);
			
			height_ = size;
			lineSkip_ = FT_MulFix(fontFace.height, fontFace.size.metrics.y_scale) / 64;
			setLineGap(0);
			
			lcdFilter = LCDFilter.Crisp;		// we'll be using the Crisp filter by default, but it can be changed on a per-Font basis.
		}
		/// just use font resource that has already been loaded 
		else
		{
			this = fontList[nameStr]; 
		}
	}
	
	/// return width of last line in the text 
	float getWidthLastLine(charType)(charType[] str)
	{
		charType[][] lines = arc.text.routines.splitlines(str); 
		return getWidth(lines[lines.length-1]);
	}
	
	/// width in pixels, will return max width in multi line string as well 
	float getWidth(charType)(charType[] string_)
	{
		// split string up by newlines 
		char[][] strs = arc.text.routines.splitlines(string_);
		
		float max=0;

		foreach(char[] str; strs)
		{
			float width = 0; 
			
			layoutText!(charType)(str, (int charIndex, charType c, Point pen, inout Glyph g) {
				width = pen.x + g.advance.x;
			});
			
			if (width > max)
			{
				max = width;
			}
			
		}

		return max;
	}
	
	/// draw lines at location and color
	void draw(char[][] lines, Point location, Color color)
	{
		lineLoop: foreach (uint i, char[] line; lines)
		{
			Point pos = Point(location.x, location.y + i * getLineSkip);
			if (PrintResult.OUT_RIGHT == print_(pos, color, line)) break lineLoop;
		}
	}
	
	/// draw lines at location and color
	void draw(dchar[][] lines, Point location, Color color)
	{
		lineLoop: foreach (uint i, dchar[] line; lines)
		{
			Point pos = Point(location.x, location.y + i * getLineSkip);
			if (PrintResult.OUT_RIGHT == print_(pos, color, line)) break lineLoop;
		}
	}

	/// draw str at location and color using utf32
	void draw(char[] str, Point location, Color color)
	{
		draw(arc.text.routines.splitlines(str), location, color);
	}
	
	/// draw str at location and color using utf32
	void draw(dchar[] str, Point location, Color color)
	{
		draw(arc.text.routines.splitlines(str), location, color);
	}
	
	/// get height of font	
	int getHeight() { return height_; }
	
	/// line skip amount between newlines 
	int getLineSkip() { return lineSkip_; }
	
	///	Sets additional spacing between lines of text, as fractions of the font's height
	void setLineGap(float frac) 
	{
		lineGap_ = lrint(frac * getHeight);
	}
	
	/// sets the subpixel filter
	bool lcdFilter(LCDFilter f) 
	{
		if (FT_Library_SetLcdFilter !is null) 
		{
			switch (f) 
			{
				case LCDFilter.Standard:
					FT_Library_SetLcdFilter(ftLib, FT_LcdFilter.FT_LCD_FILTER_DEFAULT);
					break;

				case LCDFilter.Crisp:
				case LCDFilter.None:
					FT_Library_SetLcdFilter(ftLib, FT_LcdFilter.FT_LCD_FILTER_NONE);
					break;
			}
			
			lcdFilter_ = f;
			return true;
		} 
		else 
		{
			lcdFilter_ = LCDFilter.Standard;
			return false;
		}
	}

	/// calculate index of freetype font
	int calculateIndex(charType)(charType[] text, Point textpos, Point mousepos) 
	{
		int index = -1; 

		charType[][] lines = std.string.splitlines(text); 

		int i = 0;
		int prevLineCount = 0;
		foreach(charType[] line; lines)
		{
			i++;

			// calc width and height
			arcfl calcH = getLineSkip*i;
			
			//writefln("calulated height is ", calcH);

			// if mouse is on current line
			if (mousepos.y <= calcH+textpos.y && mousepos.y >= calcH-getLineSkip+textpos.y)
			{
				//writefln("at line ", line);
				index = searchIndex!(charType)(line, cast(int)mousepos.x, cast(int)textpos.x, 0, text.length);
				//writefln("ret2 ", index+prevLineCount);
                
                // note: the (i-1) accouts for the invisible newlines that are apart of our string
				return index + prevLineCount + (i-1); 
			}

			prevLineCount+=line.length+1;
		}

		return 0;
	}

	/// search index of font 
	int searchIndex(charType)(charType[] text, int mouseX, int posX, int left, int right)
	{
		//writefln(text.length, " is length"); 
		for (int j = 1; j <= text.length; j++)
		{
			//writefln("from 0 to ", j); 
			arcfl a = getWidth(text[0 .. j])+posX;

			//writefln(a, " compared to ", mouseX, " of text ", text[0 .. j], " letter is ", text[j-1]);

			if (a > mouseX)
			{
				if (j > 0)
				{
					//	writefln("return ", j-1); 
					return j-1;
				}
				else
				{
					//writefln("return 0");
					return 0;
				}
			} 
		}

		//	writefln("return ", text.length);
		return text.length;
		//assert(0);
	}
	
	private 
	{
		void layoutText(charType)(charType[] text, void delegate(int, charType, Point, inout Glyph) dg) {
			int	useKerning = FT_HAS_KERNING(fontFace);
			uint	previous = 0;
			int	penX = 0;
			int	cur = 0;
			
			foreach (i, charType chr; text) {
				uint glyphIndex = FT_Get_Char_Index(fontFace, chr);
				
				if (useKerning && previous && glyphIndex) {
					FT_Vector delta;
					FT_Get_Kerning(fontFace, previous, glyphIndex, FT_Kerning_Mode.FT_KERNING_DEFAULT, &delta);
					penX += delta.x >> 6;
				}
				
				uint index = getGlyph(chr, glyphIndex);
				if (uint.max == index) continue;
				
				auto glyph = &glyphs[index];
				dg(i, chr, Point(penX, 0), *glyph);
				++cur;
				
				penX += glyph.advance.x;//fontFace.glyph.advance.x >> 6;
				previous = glyphIndex;
			}
		}
		
		enum PrintResult {
			OK,
			OUT_RIGHT,
			OUT_LEFT,
			OUT_DOWN,
			OUT_UP
		}

		PrintResult print_(charType)(Point location, Color color, charType[] str) 
		{
			if (castInt)
			{
				location.x = cast(int)location.x; 
				location.y = cast(int)location.y; 
			}
			
			return printWorker!(charType)(Point(location.x, location.y), color, str);
		}
		
		PrintResult printWorker(charType)(Point location, Color color, charType[] str) 
		{
			// use this to reset location for the 2nd pass 
			Point origLoc = location; 
			
			glEnable(GL_COLOR_MATERIAL);
			glEnable(GL_TEXTURE_2D);
			glEnable(GL_BLEND);
			
			// Do 1 pass rendering if we have the glBlendColorEXT function
			if (EXTBlendColor.isEnabled)
			{
				if (0 == str.length) return PrintResult.OK;
				location.y += this.getHeight;
				
				layoutText!(charType)(str, (int charIndex, charType c, Point pen, inout Glyph g) {
					
					pen.x += g.offset.x;
					pen.y -= g.offset.y;
					pen += location;
					
					// use OpenGL extension for font rendering 
					glBlendFunc(GL_CONSTANT_COLOR_EXT, GL_ONE_MINUS_SRC_COLOR);
					glBlendColorEXT(color.r * color.a, color.g * color.a, color.b * color.a, 1);
					glColor3f(color.a, color.a, color.a);
					
					glBindTexture(GL_TEXTURE_2D, g.texture.getID);
					
					glBegin(GL_QUADS); 
									
					glTexCoord2d(g.texCoords[0].x, g.texCoords[1].y); glVertex2f(pen.x, pen.y+g.size.h); 
					glTexCoord2d(g.texCoords[1].x, g.texCoords[1].y); glVertex2f(pen.x + g.size.w, pen.y+g.size.h); 
					glTexCoord2d(g.texCoords[1].x, g.texCoords[0].y); glVertex2f(pen.x + g.size.w, pen.y); 
					glTexCoord2d(g.texCoords[0].x, g.texCoords[0].y); glVertex2f(pen.x, pen.y); 

					glEnd(); 
										
				});
			
			} // 1 pass rendering if we have the glBlendColorEXT function
			
			// we will need to render the font within two passes of layout text 
			else
			{
				// First Pass ///////////////////////////////////
				if (0 == str.length) return PrintResult.OK;
				location.y += this.getHeight;
				
				layoutText!(charType)(str, (int charIndex, charType c, Point pen, inout Glyph g) {
					
					pen.x += g.offset.x;
					pen.y -= g.offset.y;
					pen += location;

					// fist pass blend func 
					glBlendFunc(GL_ZERO, GL_ONE_MINUS_SRC_COLOR); glColor3f(color.a, color.a, color.a);
					
					glBindTexture(GL_TEXTURE_2D, g.texture.getID);
					
					glBegin(GL_QUADS); 
									
					glTexCoord2d(g.texCoords[0].x, g.texCoords[1].y); glVertex2f(pen.x, pen.y+g.size.h); 
					glTexCoord2d(g.texCoords[1].x, g.texCoords[1].y); glVertex2f(pen.x + g.size.w, pen.y+g.size.h); 
					glTexCoord2d(g.texCoords[1].x, g.texCoords[0].y); glVertex2f(pen.x + g.size.w, pen.y); 
					glTexCoord2d(g.texCoords[0].x, g.texCoords[0].y); glVertex2f(pen.x, pen.y); 

					glEnd(); 
					
				});
				
				// Second Pass ///////////////////////////////////////////////////
				// set location correctly for second pass 
				location = origLoc;
				
				if (0 == str.length) return PrintResult.OK;
				location.y += this.getHeight;
				
				layoutText!(charType)(str, (int charIndex, charType c, Point pen, inout Glyph g) {
					
					pen.x += g.offset.x;
					pen.y -= g.offset.y;
					pen += location;

					// second pass blend func 
					glBlendFunc(GL_SRC_ALPHA, GL_ONE); glColor4f(color.r, color.g, color.b, color.a); 
					
					glBindTexture(GL_TEXTURE_2D, g.texture.getID);
					
					glBegin(GL_QUADS); 
									
					glTexCoord2d(g.texCoords[0].x, g.texCoords[1].y); glVertex2f(pen.x, pen.y+g.size.h); 
					glTexCoord2d(g.texCoords[1].x, g.texCoords[1].y); glVertex2f(pen.x + g.size.w, pen.y+g.size.h); 
					glTexCoord2d(g.texCoords[1].x, g.texCoords[0].y); glVertex2f(pen.x + g.size.w, pen.y); 
					glTexCoord2d(g.texCoords[0].x, g.texCoords[0].y); glVertex2f(pen.x, pen.y); 

					glEnd(); 
					
				});

			}
			
			// disable color material and restore blend func to what it usually is 
			glDisable(GL_COLOR_MATERIAL);
			glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
			
			return PrintResult.OK;
		}
		
		uint getGlyph(dchar c, uint ftIndex) 
		{
			if (c < 128) {
				// fast path for ASCII
				uint mapped = asciiGlyphMap[c];
				if (uint.max == mapped) return cacheGlyph(c, ftIndex);
				else return mapped;
			} else {
				// AA for other Unicode chars
				uint* mapped = c in glyphMap;
				if (mapped is null) return cacheGlyph(c, ftIndex);
				else return *mapped;
			}
		}
		
		FT_Render_Mode renderMode() 
		{
			switch (antialiasing) 
			{
				case FontAntialiasing.None:	return FT_Render_Mode.FT_RENDER_MODE_MONO;
				case FontAntialiasing.Grayscale:return FT_Render_Mode.FT_RENDER_MODE_NORMAL;
				case FontAntialiasing.LCD_RGB:
				case FontAntialiasing.LCD_BGR:	return FT_Render_Mode.FT_RENDER_MODE_LCD;
			}
		}

		Size renderGlyph(inout ubyte[] buffer, out Glyph glyph, uint ftIndex) 
		{
			lcdFilter = lcdFilter_;
			FT_GlyphSlot slot = fontFace.glyph;
			
			Size size;
			buffer[] = 0;
			
			glyph.advance.x = fontFace.glyph.advance.x >> 6;
			glyph.advance.y = fontFace.glyph.advance.y >> 6;

			if (0 == FT_Render_Glyph(slot, renderMode))
			{
				auto bitmap = slot.bitmap;

				glyph.offset.x = slot.bitmap_left;
				glyph.offset.y = slot.bitmap_top;
				
				int glyphWidth = bitmap.width;
				switch (antialiasing) {
					case FontAntialiasing.None:			// fall thru
					case FontAntialiasing.Grayscale:	break;
					
					// FreeType gives three times wider bitmaps for subpixel renderings
					case FontAntialiasing.LCD_RGB:	// fall thru
					case FontAntialiasing.LCD_BGR:	glyphWidth /= 3; break;
				}
				
				// we need to expand the bitmap horizontally to do our own filtering
				if (isCrispLCDFilter) 
				{
					glyphWidth += 2;
					--glyph.offset.x;
				}
				
				glyph.size = size = Size(glyphWidth, bitmap.rows);
				
				// only realloc if the provided buffer can't hold the data
				int bytes = cast(int)(size.w * size.h * 4);
				if (buffer.length < bytes) buffer.realloc(bytes);
				
				// return 255 if the bit at (x,y) position is set. 0 otherwise.
				ubyte indexBinaryBitmap(FT_Bitmap bitmap, int x, int y) {
					return (bitmap.buffer[y * bitmap.pitch + (x >> 3)] & (0b10000000 >> (x & 7))) ? 255 : 0;
				}
				
				for (int y = 0; y < size.h; ++y) {
					for (int x = 0; x < size.w; ++x) {
						uint bufferIdx = cast(uint)((y * size.w + x) * 4);
						
						// set the alpha channel of the img to white. We're using RGB as subpixel alpha anyway.
						buffer[bufferIdx+3] = 255;

						// index the bitmap given by freetype at (x*3+xoffset-3, y). 0 when out of bounds. useful for filtering
						ubyte ftBuffer(int xoffset) {
							xoffset += x*3;
							xoffset -= 3;
							if (xoffset < 0) return 0;
							if (xoffset >= bitmap.width) return 0;
							return bitmap.buffer[y * bitmap.pitch + xoffset];
						}

						switch (antialiasing) {
							case FontAntialiasing.None:
								buffer[bufferIdx..bufferIdx+3] = indexBinaryBitmap(bitmap, x, y);
								break;
							case FontAntialiasing.Grayscale:
								buffer[bufferIdx..bufferIdx+3] = bitmap.buffer[y * bitmap.pitch + x];
								
								// antialiasing makes the glyph appear darker...
								gammaCorrect(buffer[bufferIdx..bufferIdx+3], 1.2);
								break;
							case FontAntialiasing.LCD_RGB:
							case FontAntialiasing.LCD_BGR:
								if (isCrispLCDFilter) {
									foreach (i, inout c; buffer[bufferIdx..bufferIdx+3]) {
										c = crispFilter(ftBuffer(i-2), ftBuffer(i-1), ftBuffer(i), ftBuffer(i+1), ftBuffer(i+2));
									}
								} else {
									buffer[bufferIdx..bufferIdx+3] = bitmap.buffer[y * bitmap.pitch + x*3 .. y * bitmap.pitch + x*3 + 3];
									
									// antialiasing makes the glyph appear darker...
									gammaCorrect(buffer[bufferIdx..bufferIdx+3], 1.2);
								}
								
								// swap byte order for bgr subpixel layout
								if (FontAntialiasing.LCD_BGR == antialiasing) {
									ubyte r = buffer[bufferIdx];
									buffer[bufferIdx] = buffer[bufferIdx+2];
									buffer[bufferIdx+2] = r;
								}
								break;
						}
					}
				}
				
				// the crisp filter requires a component of the mono-rendered glyph
				if (isCrispLCDFilter) {
					uint loadFlags = FT_LOAD_TARGET_(FT_Render_Mode.FT_RENDER_MODE_MONO);
					version (UnpatentedHinting) loadFlags |= FT_LOAD_FORCE_AUTOHINT;
					
					if (0 == FT_Load_Glyph(fontFace, ftIndex, loadFlags)) {
						FT_Glyph tmpGlyph;
						
						if (0 == FT_Get_Glyph(fontFace.glyph, &tmpGlyph) && 0 == FT_Render_Glyph(slot, FT_Render_Mode.FT_RENDER_MODE_MONO)) {
							for (int y = 0; y < size.h; ++y) {
								for (int x = 0; x < size.w; ++x) {
									uint bufferIdx = cast(uint)((y * size.w + x) * 4);
									
									ubyte monoColor = x > 0 && x+1 < size.w ? indexBinaryBitmap(slot.bitmap, x-1, y) : 0;
									
									foreach (inout c; buffer[bufferIdx..bufferIdx+3]) {
										c += monoColor / 4;
									}
									
									gammaCorrect(buffer[bufferIdx..bufferIdx+3], 1.1);
								}
							}
						}

						FT_Done_Glyph(tmpGlyph);
					}
				}
			}

			return size;
		}
		
		
		uint cacheGlyph(dchar c, uint ftIndex) 
		{
			uint index = uint.max;
			
			foreach (gi, gl; glyphs) 
			{
				if (gl.ftIndex == ftIndex) 
				{		// some fonts dont have lowecase glyphs, etc.
					index = gi;		// we can just skip the caching step and return an already cached glyph
				}
			}
			
			if (uint.max == index) 
			{
				ubyte[] buffer;
				
				Glyph g;
				g.ftIndex = ftIndex;
				
				FT_Glyph glyph;

				// ... usual FreeType stuff
				uint loadFlags = FT_LOAD_TARGET_(renderMode);
				version (UnpatentedHinting) loadFlags |= FT_LOAD_FORCE_AUTOHINT;

				if (0 != FT_Load_Glyph(fontFace, ftIndex, loadFlags)) return uint.max;
				if (0 != FT_Get_Glyph(fontFace.glyph, &glyph)) 
				{
					FT_Done_Glyph(glyph);
					return uint.max;
				}
				
				renderGlyph(buffer, g, ftIndex);
				FT_Done_Glyph(glyph);
				
				// Let's try to cut on a few pixels. Sometimes FreeType reports a bit larger bitmap than what is really needed.
				{
					// is any of the subpixels at (x,y) non-zero ?
					bool any(int x, int y) {
						int off = cast(int)((y * g.size.w + x) * 4);
						return buffer[off] != 0 || buffer[off+1] != 0 || buffer[off+2] != 0;
					}
					
					// compute the bounds of the rendered glyph
					int xmin = 0, xmax = cast(int)(g.size.w-1), ymin = 0, ymax = cast(int)(g.size.h-1);
					xloop1: for (; xmin < g.size.w; ++xmin) for (int y = 0; y < g.size.h; ++y) if (any(xmin, y)) break xloop1;
					yloop1: for (; ymin < g.size.h; ++ymin) for (int x = 0; x < g.size.w; ++x) if (any(x, ymin)) break yloop1;
					xloop2: for (; xmax > xmin; --xmax) for (int y = 0; y < g.size.h; ++y) if (any(xmax, y)) break xloop2;
					yloop2: for (; ymax > ymin; --ymax) for (int x = 0; x < g.size.w; ++x) if (any(x, ymax)) break yloop2;
					
					if (xmin > 0 || ymin > 0 || xmin < g.size.w-1 || ymin < g.size.h-1) {
						// Looks like we can strip a pixel here or there!
						
						Size size = Size(xmax+1-xmin, ymax+1-ymin);	// size of the new bitmap
						assert (size.w <= g.size.w);
						assert (size.h <= g.size.h);
						
						ubyte[] newBuf;
						newBuf.alloc(size.w*size.h*4);
						
						for (int y = 0; y < size.h; ++y) {
							int srcOff = cast(int)(((y + ymin) * g.size.w + xmin) * 4);
							int dstOff = cast(int)(y * size.w * 4);
							int len = cast(int)(size.w * 4);
							
							newBuf[dstOff .. dstOff + len] = buffer[srcOff .. srcOff + len];
						}
						
						// update the glyph info, because we'll be using the new buffer
						buffer.free();
						buffer = newBuf;
						g.size = size;
						g.offset.x += xmin;
						g.offset.y -= ymin;
					}
				}
				
				// tex coords; these will be set by the icon cache
				Point bl, tr;
				Point tbl, ttr;
				
				Texture tex = fontCache.get(g.size, bl, tr, tbl, ttr);
				
				// copy our bitmap into the texture
				updateTexture(tex, bl, g.size, buffer);

				// finish off the glyph struct
				g.texCoords[0] = tbl;
				g.texCoords[1] = ttr;
				g.texture = tex;
				glyphs ~= g;
				
				index = glyphs.length - 1;
				buffer.free();
			}
			
			if (c < 128) {		// ascii chars use a faster path
				asciiGlyphMap[c] = index;
			} else {
				glyphMap[c] = index;
				glyphMap.rehash;
			}
			
			return index;
		}
		
		// are we using any lcd filter ?
		bool isCrispLCDFilter() 
		{
	 		return lcdFilter_ == LCDFilter.Crisp && (FontAntialiasing.LCD_RGB == antialiasing || FontAntialiasing.LCD_BGR == antialiasing);
		}
		
		char[]		nameStr; 

		uint				height_;
		uint				lineSkip_;
		uint				lineGap_;
		LCDFilter		lcdFilter_ = LCDFilter.Standard;
		
		FT_Face		fontFace;
		ubyte[]			fontData;
		
		uint[dchar]	glyphMap;
		uint[128]		asciiGlyphMap = uint.max;
		Glyph[]			glyphs;

		public FontAntialiasing antialiasing = FontAntialiasing.LCD_RGB;
	}
}


private void gammaCorrect(ubyte[] rgb, float factor) 
{
	float scale = 1.f, temp = 0.f;
	float r = cast(float)rgb[0];
	float g = cast(float)rgb[1];
	float b = cast(float)rgb[2];
	r = r * factor / 255.f;
	g = g * factor / 255.f;
	b = b * factor / 255.f;
	if (r > 1.f && (temp = (1.f / r)) < scale) scale = temp;
	if (g > 1.f && (temp = (1.f / g)) < scale) scale = temp;
	if (b > 1.f && (temp = (1.f / b)) < scale) scale = temp;
	scale *= 255.0f;
	r *= scale;	
	g *= scale;	
	b *= scale;
	rgb[0] = cast(ubyte)r;
	rgb[1] = cast(ubyte)g;
	rgb[2] = cast(ubyte)b;
}

private ubyte crispFilter(ubyte[] data ...) 
{
	float total = 0.f;
	total += data[0] * 0.08f;
	total += data[4] * 0.08f;
	total += data[1] * 0.24f;
	total += data[3] * 0.24f;
	total += data[2] * 0.36f;
	
	total *= 0.55f;
	total += data[2] * 0.2f;
	
	if (total <= 0.f) return 0;
	if (total >= 255.f) return 255;
	return lrint(total);
}

bool continueIfMissing(char[] libName, char[] procName) { return true; }

void loadFtLib() 
{
	// continue loading derelict if missing functions
	Derelict_SetMissingProcCallback(&continueIfMissing);
	
	// load FreeType dynamic library, freetype.dll/.so is required for application to run
	DerelictFT.load();		
	
	assert (FT_Init_FreeType !is null);
	
	auto ftError = FT_Init_FreeType(&ftLib);  // initialize freetype library
	assert (0 == ftError);
	assert (ftLib !is null);
	
	if (FT_Library_SetLcdFilter !is null) {
		FT_Library_SetLcdFilter(ftLib, FT_LcdFilter.FT_LCD_FILTER_LIGHT);
	}
}
	
private
{
	Font[char[]] fontList; 
	FT_Library ftLib=null;
	bool castInt = false;
}
