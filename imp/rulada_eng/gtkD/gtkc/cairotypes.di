/*
 * This file is part of gtkD.
 *
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
// generated automatically - do not change
// find conversion definition on APILookup.txt
// implement new conversion functionalities on the wrap.utils pakage

module gtkD.gtkc.cairotypes;


public import gtkD.gtkc.glibtypes;

//public import std.c.windows.windows;
private alias void* HDC;
public  alias void  cairo_path_data_t;

alias ubyte uchar;

/**
 * typedef int cairo_bool_t;
 * cairo_bool_t is used for boolean values. Returns of type
 * cairo_bool_t will always be either 0 or 1, but testing against
 * these values explicitly is not encouraged; just use the
 * value as a boolean condition.
 */
public alias int cairo_bool_t;
/**
 * Specifies the type of antialiasing to do when rendering text or shapes.
 * CAIRO_ANTIALIAS_DEFAULT
 */
public enum cairo_antialias_t
{
	DEFAULT,
	NONE,
	GRAY,
	SUBPIXEL
}
alias cairo_antialias_t CairoAntialias;

/**
 * cairo_fill_rule_t is used to select how paths are filled. For both
 * fill rules, whether or not a point is included in the fill is
 * determined by taking a ray from that point to infinity and looking
 * at intersections with the path. The ray can be in any direction,
 * as long as it doesn't pass through the end point of a segment
 * or have a tricky intersection such as intersecting tangent to the path.
 * (Note that filling is not actually implemented in this way. This
 * is just a description of the rule that is applied.)
 * The default fill rule is CAIRO_FILL_RULE_WINDING.
 * New entries may be added in future versions.
 * CAIRO_FILL_RULE_WINDING
 */
public enum cairo_fill_rule_t
{
	WINDING,
	EVEN_ODD
}
alias cairo_fill_rule_t CairoFillRule;

/**
 * Specifies how to render the endpoints of the path when stroking.
 * The default line cap style is CAIRO_LINE_CAP_BUTT.
 * CAIRO_LINE_CAP_BUTT
 */
public enum cairo_line_cap_t
{
	BUTT,
	ROUND,
	SQUARE
}
alias cairo_line_cap_t CairoLineCap;

/**
 * Specifies how to render the junction of two lines when stroking.
 * The default line join style is CAIRO_LINE_JOIN_MITER.
 * CAIRO_LINE_JOIN_MITER
 */
public enum cairo_line_join_t
{
	MITER,
	ROUND,
	BEVEL
}
alias cairo_line_join_t CairoLineJoin;

/**
 * cairo_operator_t is used to set the compositing operator for all cairo
 * drawing operations.
 * The default operator is CAIRO_OPERATOR_OVER.
 * The operators marked as unbounded modify their
 * destination even outside of the mask layer (that is, their effect is not
 * bound by the mask layer). However, their effect can still be limited by
 * way of clipping.
 * To keep things simple, the operator descriptions here
 * document the behavior for when both source and destination are either fully
 * transparent or fully opaque. The actual implementation works for
 * translucent layers too.
 * For a more detailed explanation of the effects of each operator, including
 * the mathematical definitions, see
 * http://cairographics.org/operators/.
 * CAIRO_OPERATOR_CLEAR
 */
public enum cairo_operator_t
{
	CLEAR,
	SOURCE,
	OVER,
	IN,
	OUT,
	ATOP,
	DEST,
	DEST_OVER,
	DEST_IN,
	DEST_OUT,
	DEST_ATOP,
	XOR,
	ADD,
	SATURATE
}
alias cairo_operator_t CairoOperator;

/**
 * cairo_path_data_t is used to describe the type of one portion
 * of a path when represented as a cairo_path_t.
 * See cairo_path_data_t for details.
 * CAIRO_PATH_MOVE_TO
 */
public enum cairo_path_data_type_t
{
	MOVE_TO,
	LINE_TO,
	CURVE_TO,
	CLOSE_PATH
}
alias cairo_path_data_type_t CairoPathDataType;

/**
 * Specifies variants of a font face based on their slant.
 * CAIRO_FONT_SLANT_NORMAL
 */
public enum cairo_font_slant_t
{
	NORMAL,
	ITALIC,
	OBLIQUE
}
alias cairo_font_slant_t CairoFontSlant;

/**
 * Specifies variants of a font face based on their weight.
 * CAIRO_FONT_WEIGHT_NORMAL
 */
public enum cairo_font_weight_t
{
	NORMAL,
	BOLD
}
alias cairo_font_weight_t CairoFontWeight;

/**
 * Specifies properties of a text cluster mapping.
 * CAIRO_TEXT_CLUSTER_FLAG_BACKWARD
 */
public enum cairo_text_cluster_flags_t
{
	BACKWARD = 0x00000001
}
alias cairo_text_cluster_flags_t CairoTextClusterFlags;

/**
 * cairo_extend_t is used to describe how pattern color/alpha will be
 * determined for areas "outside" the pattern's natural area, (for
 * example, outside the surface bounds or outside the gradient
 * geometry).
 * The default extend mode is CAIRO_EXTEND_NONE for surface patterns
 * and CAIRO_EXTEND_PAD for gradient patterns.
 * New entries may be added in future versions.
 * CAIRO_EXTEND_NONE
 */
public enum cairo_extend_t
{
	NONE,
	REPEAT,
	REFLECT,
	PAD
}
alias cairo_extend_t CairoExtend;

/**
 * cairo_filter_t is used to indicate what filtering should be
 * applied when reading pixel values from patterns. See
 * cairo_pattern_set_source() for indicating the desired filter to be
 * used with a particular pattern.
 * CAIRO_FILTER_FAST
 */
public enum cairo_filter_t
{
	FAST,
	GOOD,
	BEST,
	NEAREST,
	BILINEAR,
	GAUSSIAN
}
alias cairo_filter_t CairoFilter;

/**
 * cairo_pattern_type_t is used to describe the type of a given pattern.
 * The type of a pattern is determined by the function used to create
 * it. The cairo_pattern_create_rgb() and cairo_pattern_create_rgba()
 * functions create SOLID patterns. The remaining
 * cairo_pattern_create functions map to pattern types in obvious
 * ways.
 * The pattern type can be queried with cairo_pattern_get_type()
 * Most cairo_pattern_t functions can be called with a pattern of any
 * type, (though trying to change the extend or filter for a solid
 * pattern will have no effect). A notable exception is
 * cairo_pattern_add_color_stop_rgb() and
 * cairo_pattern_add_color_stop_rgba() which must only be called with
 * gradient patterns (either LINEAR or RADIAL). Otherwise the pattern
 * will be shutdown and put into an error state.
 * New entries may be added in future versions.
 * CAIRO_PATTERN_TYPE_SOLID
 */
public enum cairo_pattern_type_t
{
	SOLID,
	SURFACE,
	LINEAR,
	RADIAL
}
alias cairo_pattern_type_t CairoPatternType;

/**
 * cairo_font_type_t is used to describe the type of a given font
 * face or scaled font. The font types are also known as "font
 * backends" within gtkD.cairo.
 * The type of a font face is determined by the function used to
 * create it, which will generally be of the form
 * cairo_type_font_face_create(). The font face type can be queried
 * with cairo_font_face_get_type()
 * The various cairo_font_face_t functions can be used with a font face
 * of any type.
 * The type of a scaled font is determined by the type of the font
 * face passed to cairo_scaled_font_create(). The scaled font type can
 * be queried with cairo_scaled_font_get_type()
 * The various cairo_scaled_font_t functions can be used with scaled
 * fonts of any type, but some font backends also provide
 * type-specific functions that must only be called with a scaled font
 * of the appropriate type. These functions have names that begin with
 * cairo_type_scaled_font() such as cairo_ft_scaled_font_lock_face().
 * The behavior of calling a type-specific function with a scaled font
 * of the wrong type is undefined.
 * New entries may be added in future versions.
 * CAIRO_FONT_TYPE_TOY
 */
public enum cairo_font_type_t
{
	TOY,
	FT,
	WIN32,
	QUARTZ,
	USER
}
alias cairo_font_type_t CairoFontType;

/**
 * The subpixel order specifies the order of color elements within
 * each pixel on the display device when rendering with an
 * antialiasing mode of CAIRO_ANTIALIAS_SUBPIXEL.
 * CAIRO_SUBPIXEL_ORDER_DEFAULT
 */
public enum cairo_subpixel_order_t
{
	DEFAULT,
	RGB,
	BGR,
	VRGB,
	VBGR
}
alias cairo_subpixel_order_t CairoSubpixelOrder;

/**
 * Specifies the type of hinting to do on font outlines. Hinting
 * is the process of fitting outlines to the pixel grid in order
 * to improve the appearance of the result. Since hinting outlines
 * involves distorting them, it also reduces the faithfulness
 * to the original outline shapes. Not all of the outline hinting
 * styles are supported by all font backends.
 * New entries may be added in future versions.
 * CAIRO_HINT_STYLE_DEFAULT
 */
public enum cairo_hint_style_t
{
	DEFAULT,
	NONE,
	SLIGHT,
	MEDIUM,
	FULL
}
alias cairo_hint_style_t CairoHintStyle;

/**
 * Specifies whether to hint font metrics; hinting font metrics
 * means quantizing them so that they are integer values in
 * device space. Doing this improves the consistency of
 * letter and line spacing, however it also means that text
 * will be laid out differently at different zoom factors.
 * CAIRO_HINT_METRICS_DEFAULT
 */
public enum cairo_hint_metrics_t
{
	DEFAULT,
	OFF,
	ON
}
alias cairo_hint_metrics_t CairoHintMetrics;

/**
 * cairo_content_t is used to describe the content that a surface will
 * contain, whether color information, alpha information (translucence
 * vs. opacity), or both.
 * Note: The large values here are designed to keep cairo_content_t
 * values distinct from cairo_format_t values so that the
 * implementation can detect the error if users confuse the two types.
 * CAIRO_CONTENT_COLOR
 */
public enum cairo_content_t
{
	COLOR = 0x1000,
	ALPHA = 0x2000,
	COLOR_ALPHA = 0x3000
}
alias cairo_content_t CairoContent;

/**
 * cairo_surface_type_t is used to describe the type of a given
 * surface. The surface types are also known as "backends" or "surface
 * backends" within gtkD.cairo.
 * The type of a surface is determined by the function used to create
 * it, which will generally be of the form cairo_type_surface_create(),
 * (though see cairo_surface_create_similar() as well).
 * The surface type can be queried with cairo_surface_get_type()
 * The various cairo_surface_t functions can be used with surfaces of
 * any type, but some backends also provide type-specific functions
 * that must only be called with a surface of the appropriate
 * type. These functions have names that begin with
 * cairo_type_surface such as cairo_image_surface_get_width().
 * The behavior of calling a type-specific function with a surface of
 * the wrong type is undefined.
 * New entries may be added in future versions.
 * CAIRO_SURFACE_TYPE_IMAGE
 */
public enum cairo_surface_type_t
{
	IMAGE,
	PDF,
	PS,
	XLIB,
	XCB,
	GLITZ,
	QUARTZ,
	WIN32,
	BEOS,
	DIRECTFB,
	SVG,
	OS2,
	WIN32_PRINTING,
	QUARTZ_IMAGE
}
alias cairo_surface_type_t CairoSurfaceType;

/**
 * cairo_format_t is used to identify the memory format of
 * image data.
 * New entries may be added in future versions.
 * CAIRO_FORMAT_ARGB32
 */
public enum cairo_format_t
{
	ARGB32,
	RGB24,
	A8,
	A1
	/+* The value of 4 is reserved by a deprecated enum value.
	 * The next format added must have an explicit value of 5.
	RGB16_565 = 4,
	+/
}
alias cairo_format_t CairoFormat;

/**
 * cairo_ps_level_t is used to describe the language level of the
 * PostScript Language Reference that a generated PostScript file will
 * conform to.
 * CAIRO_PS_LEVEL_2
 */
public enum cairo_ps_level_t
{
	LEVEL_2,
	LEVEL_3
}
alias cairo_ps_level_t CairoPsLevel;

/**
 * cairo_svg_version_t is used to describe the version number of the SVG
 * specification that a generated SVG file will conform to.
 * CAIRO_SVG_VERSION_1_1
 */
public enum cairo_svg_version_t
{
	VERSION_1_1,
	VERSION_1_2
}
alias cairo_svg_version_t CairoSvgVersion;

/**
 * cairo_status_t is used to indicate errors that can occur when
 * using Cairo. In some cases it is returned directly by functions.
 * but when using cairo_t, the last error, if any, is stored in
 * the context and can be retrieved with cairo_status().
 * New entries may be added in future versions. Use cairo_status_to_string()
 * to get a human-readable representation of an error message.
 * CAIRO_STATUS_SUCCESS
 */
public enum cairo_status_t
{
	SUCCESS = 0,
	NO_MEMORY,
	INVALID_RESTORE,
	INVALID_POP_GROUP,
	NO_CURRENT_POINT,
	INVALID_MATRIX,
	INVALID_STATUS,
	NULL_POINTER,
	INVALID_STRING,
	INVALID_PATH_DATA,
	READ_ERROR,
	WRITE_ERROR,
	SURFACE_FINISHED,
	SURFACE_TYPE_MISMATCH,
	PATTERN_TYPE_MISMATCH,
	INVALID_CONTENT,
	INVALID_FORMAT,
	INVALID_VISUAL,
	FILE_NOT_FOUND,
	INVALID_DASH,
	INVALID_DSC_COMMENT,
	INVALID_INDEX,
	CLIP_NOT_REPRESENTABLE,
	TEMP_FILE_ERROR,
	INVALID_STRIDE,
	FONT_TYPE_MISMATCH,
	USER_FONT_IMMUTABLE,
	USER_FONT_ERROR,
	NEGATIVE_COUNT,
	INVALID_CLUSTERS,
	INVALID_SLANT,
	INVALID_WEIGHT
	/+* after adding a new error: update LAST_STATUS inn cairoint.h +/
}
alias cairo_status_t CairoStatus;


/**
 * Main Gtk struct.
 * A cairo_t contains the current state of the rendering device,
 * including coordinates of yet to be drawn shapes.
 * Cairo contexts, as cairo_t objects are named, are central to
 * cairo and all drawing with cairo is always done to a cairo_t
 * object.
 * Memory management of cairo_t is done with
 * cairo_reference() and cairo_destroy().
 */
public struct cairo_t{}


/**
 * A data structure for holding a rectangle.
 * double x;
 */
public struct cairo_rectangle_t
{
	double x, y, width, height;
}


/**
 * A data structure for holding a dynamically allocated
 * array of rectangles.
 * cairo_status_t status;
 */
public struct cairo_rectangle_list_t
{
	cairo_status_t status;
	cairo_rectangle_t *rectangles;
	int numRectangles;
}


/**
 * A data structure for holding a path. This data structure serves as
 * the return value for cairo_copy_path() and
 * cairo_copy_path_flat() as well the input value for
 * cairo_append_path().
 * See cairo_path_data_t for hints on how to iterate over the
 * actual data within the path.
 * The num_data member gives the number of elements in the data
 * array. This number is larger than the number of independent path
 * portions (defined in cairo_path_data_type_t), since the data
 * includes both headers and coordinates for each portion.
 * cairo_status_t status;
 */
public struct cairo_path_t
{
	cairo_status_t status;
	cairo_path_data_t *data;
	int numData;
}


/**
 * The cairo_glyph_t structure holds information about a single glyph
 * when drawing or measuring text. A font is (in simple terms) a
 * collection of shapes used to draw text. A glyph is one of these
 * shapes. There can be multiple glyphs for a single character
 * (alternates to be used in different contexts, for example), or a
 * glyph can be a ligature of multiple
 * characters. Cairo doesn't expose any way of converting input text
 * into glyphs, so in order to use the Cairo interfaces that take
 * arrays of glyphs, you must directly access the appropriate
 * underlying font system.
 * Note that the offsets given by x and y are not cumulative. When
 * drawing or measuring text, each glyph is individually positioned
 * with respect to the overall origin
 * unsigned long index;
 */
public struct cairo_glyph_t
{
	ulong index;
	double x;
	double y;
}


/**
 * The cairo_text_cluster_t structure holds information about a single
 * text cluster. A text cluster is a minimal
 * mapping of some glyphs corresponding to some UTF-8 text.
 * For a cluster to be valid, both num_bytes and num_glyphs should
 * be non-negative, and at least one should be non-zero.
 * Note that clusters with zero glyphs are not as well supported as
 * normal clusters. For example, PDF rendering applications typically
 * ignore those clusters when PDF text is being selected.
 * See cairo_show_text_glyphs() for how clusters are used in advanced
 * text operations.
 * int num_bytes;
 */
public struct cairo_text_cluster_t
{
	int numBytes;
	int numGlyphs;
}


/**
 * Main Gtk struct.
 * A cairo_pattern_t represents a source when drawing onto a
 * surface. There are different subtypes of cairo_pattern_t,
 * for different types of sources; for example,
 * cairo_pattern_create_rgb() creates a pattern for a solid
 * opaque color.
 * Other than various cairo_pattern_create_type()
 * functions, some of the pattern types can be implicitly created
 * using various cairo_set_source_type() functions;
 * for example cairo_set_source_rgb().
 * The type of a pattern can be queried with cairo_pattern_get_type().
 * Memory management of cairo_pattern_t is done with
 * cairo_pattern_reference() and cairo_pattern_destroy().
 */
public struct cairo_pattern_t{}


/**
 * Main Gtk struct.
 * A cairo_font_face_t specifies all aspects of a font other
 * than the size or font matrix (a font matrix is used to distort
 * a font by sheering it or scaling it unequally in the two
 * directions) . A font face can be set on a cairo_t by using
 * cairo_set_font_face(); the size and font matrix are set with
 * cairo_set_font_size() and cairo_set_font_matrix().
 * There are various types of font faces, depending on the
 * font backend they use. The type of a
 * font face can be queried using cairo_font_face_get_type().
 * Memory management of cairo_font_face_t is done with
 * cairo_font_face_reference() and cairo_font_face_destroy().
 */
public struct cairo_font_face_t{}


/**
 * Main Gtk struct.
 * A cairo_scaled_font_t is a font scaled to a particular size and device
 * resolution. A cairo_scaled_font_t is most useful for low-level font
 * usage where a library or application wants to cache a reference
 * to a scaled font to speed up the computation of metrics.
 * There are various types of scaled fonts, depending on the
 * font backend they use. The type of a
 * scaled font can be queried using cairo_scaled_font_get_type().
 * Memory management of cairo_scaled_font_t is done with
 * cairo_scaled_font_reference() and cairo_scaled_font_destroy().
 */
public struct cairo_scaled_font_t{}


/**
 * The cairo_font_extents_t structure stores metric information for
 * a font. Values are given in the current user-space coordinate
 * system.
 * Because font metrics are in user-space coordinates, they are
 * mostly, but not entirely, independent of the current transformation
 * matrix. If you call cairo_scale(cr, 2.0, 2.0),
 * text will be drawn twice as big, but the reported text extents will
 * not be doubled. They will change slightly due to hinting (so you
 * can't assume that metrics are independent of the transformation
 * matrix), but otherwise will remain unchanged.
 * double ascent;
 */
public struct cairo_font_extents_t
{
	double ascent;
	double descent;
	double height;
	double maxXAdvance;
	double maxYAdvance;
}


/**
 * The cairo_text_extents_t structure stores the extents of a single
 * glyph or a string of glyphs in user-space coordinates. Because text
 * extents are in user-space coordinates, they are mostly, but not
 * entirely, independent of the current transformation matrix. If you call
 * cairo_scale(cr, 2.0, 2.0), text will
 * be drawn twice as big, but the reported text extents will not be
 * doubled. They will change slightly due to hinting (so you can't
 * assume that metrics are independent of the transformation matrix),
 * but otherwise will remain unchanged.
 * double x_bearing;
 */
public struct cairo_text_extents_t
{
	double xBearing;
	double yBearing;
	double width;
	double height;
	double xAdvance;
	double yAdvance;
}


/**
 * Main Gtk struct.
 * An opaque structure holding all options that are used when
 * rendering fonts.
 * Individual features of a cairo_font_options_t can be set or
 * accessed using functions named
 * cairo_font_options_set_feature_name and
 * cairo_font_options_get_feature_name, like
 * cairo_font_options_set_antialias() and
 * cairo_font_options_get_antialias().
 * New features may be added to a cairo_font_options_t in the
 * future. For this reason, cairo_font_options_copy(),
 * cairo_font_options_equal(), cairo_font_options_merge(), and
 * cairo_font_options_hash() should be used to copy, check
 * for equality, merge, or compute a hash value of
 * cairo_font_options_t objects.
 */
public struct cairo_font_options_t{}


/**
 * Main Gtk struct.
 * A cairo_surface_t represents an image, either as the destination
 * of a drawing operation or as source when drawing onto another
 * surface. To draw to a cairo_surface_t, create a cairo context
 * with the surface as the target, using cairo_create().
 * There are different subtypes of cairo_surface_t for
 * different drawing backends; for example, cairo_image_surface_create()
 * creates a bitmap image in memory.
 * The type of a surface can be queried with cairo_surface_get_type().
 * Memory management of cairo_surface_t is done with
 * cairo_surface_reference() and cairo_surface_destroy().
 */
public struct cairo_surface_t{}


/**
 * Main Gtk struct.
 * A cairo_matrix_t holds an affine transformation, such as a scale,
 * rotation, shear, or a combination of those. The transformation of
 * a point (x, y) is given by:
 */
public struct cairo_matrix_t
{
	double xx; double yx;
	double xy; double yy;
	double x0; double y0;
}


/**
 * cairo_user_data_key_t is used for attaching user data to cairo
 * data structures. The actual contents of the struct is never used,
 * and there is no need to initialize the object; only the unique
 * address of a cairo_data_key_t object is used. Typically, you
 * would just use the address of a static cairo_data_key_t object.
 * int unused;
 */
public struct cairo_user_data_key_t
{
	int unused;
}


/*
 * This macro encodes the given cairo version into an integer. The numbers
 * returned by CAIRO_VERSION and cairo_version() are encoded using this macro.
 * Two encoded version numbers can be compared as integers. The encoding ensures
 * that later versions compare greater than earlier versions.
 * major :
 * the major component of the version number
 * minor :
 * the minor component of the version number
 * micro :
 * the micro component of the version number
 * Returns :
 * the encoded version.
 */
// TODO
// #define CAIRO_VERSION_ENCODE(major, minor, micro)

/*
 * This macro encodes the given cairo version into an string. The numbers
 * returned by CAIRO_VERSION_STRING and cairo_version_string() are encoded using this macro.
 * The parameters to this macro must expand to numerical literals.
 * major :
 * the major component of the version number
 * minor :
 * the minor component of the version number
 * micro :
 * the micro component of the version number
 * Returns :
 * a string literal containing the version.
 * Since 1.8
 */
// TODO
// #define CAIRO_VERSION_STRINGIZE(major, minor, micro)

/*
 * cairo_user_scaled_font_init_func_t is the type of function which is
 * called when a scaled-font needs to be created for a user font-face.
 * The cairo context cr is not used by the caller, but is prepared in font
 * space, similar to what the cairo contexts passed to the render_glyph
 * method will look like. The callback can use this context for extents
 * computation for example. After the callback is called, cr is checked
 * for any error status.
 * The extents argument is where the user font sets the font extents for
 * scaled_font. It is in font space, which means that for most cases its
 * ascent and descent members should add to 1.0. extents is preset to
 * hold a value of 1.0 for ascent, height, and max_x_advance, and 0.0 for
 * descent and max_y_advance members.
 * The callback is optional. If not set, default font extents as described
 * in the previous paragraph will be used.
 * Note that scaled_font is not fully initialized at this
 * point and trying to use it for text operations in the callback will result
 * in deadlock.
 * scaled_font :
 *  the scaled-font being created
 * cr :
 *  a cairo context, in font space
 * extents :
 *  font extents to fill in, in font space
 * Returns :
 *  CAIRO_STATUS_SUCCESS upon success, or
 * CAIRO_STATUS_USER_FONT_ERROR or any other error status on error.
 * Since 1.8
 */
// cairo_status_t (*cairo_user_scaled_font_init_func_t)  (cairo_scaled_font_t *scaled_font,  cairo_t *cr,  cairo_font_extents_t *extents);
public typedef extern(C) cairo_status_t  function (cairo_scaled_font_t*, cairo_t*, cairo_font_extents_t*) cairo_user_scaled_font_init_func_t;

/*
 * cairo_user_scaled_font_render_glyph_func_t is the type of function which
 * is called when a user scaled-font needs to render a glyph.
 * The callback is mandatory, and expected to draw the glyph with code glyph to
 * the cairo context cr. cr is prepared such that the glyph drawing is done in
 * font space. That is, the matrix set on cr is the scale matrix of scaled_font,
 * The extents argument is where the user font sets the font extents for
 * scaled_font. However, if user prefers to draw in user space, they can
 * achieve that by changing the matrix on cr. All cairo rendering operations
 * to cr are permitted, however, the result is undefined if any source other
 * than the default source on cr is used. That means, glyph bitmaps should
 * be rendered using cairo_mask() instead of cairo_paint().
 * Other non-default settings on cr include a font size of 1.0 (given that
 * it is set up to be in font space), and font options corresponding to
 * scaled_font.
 * The extents argument is preset to have x_bearing,
 * width, and y_advance of zero,
 * y_bearing set to -font_extents.ascent,
 * height to font_extents.ascent+font_extents.descent,
 * and x_advance to font_extents.max_x_advance.
 * The only field user needs to set in majority of cases is
 * x_advance.
 * If the width field is zero upon the callback returning
 * (which is its preset value), the glyph extents are automatically computed
 * based on the drawings done to cr. This is in most cases exactly what the
 * desired behavior is. However, if for any reason the callback sets the
 * extents, it must be ink extents, and include the extents of all drawing
 * done to cr in the callback.
 * scaled_font :
 *  user scaled-font
 * glyph :
 *  glyph code to render
 * cr :
 *  cairo context to draw to, in font space
 * extents :
 *  glyph extents to fill in, in font space
 * Returns :
 *  CAIRO_STATUS_SUCCESS upon success, or
 * CAIRO_STATUS_USER_FONT_ERROR or any other error status on error.
 * Since 1.8
 */
// cairo_status_t (*cairo_user_scaled_font_render_glyph_func_t)  (cairo_scaled_font_t *scaled_font,  unsigned long glyph,  cairo_t *cr,  cairo_text_extents_t *extents);
public typedef extern(C) cairo_status_t  function (cairo_scaled_font_t*, ulong, cairo_t*, cairo_text_extents_t*) cairo_user_scaled_font_render_glyph_func_t;

/*
 * cairo_user_scaled_font_text_to_glyphs_func_t is the type of function which
 * is called to convert input text to an array of glyphs. This is used by the
 * cairo_show_text() operation.
 * Using this callback the user-font has full control on glyphs and their
 * positions. That means, it allows for features like ligatures and kerning,
 * as well as complex shaping required for scripts like
 * Arabic and Indic.
 * The num_glyphs argument is preset to -1. The callback should allocate an
 * array for the resulting glyphs (using malloc()), and populate the glyph indices and
 * positions (in font space) assuming that the text is to be shown at the
 * origin. Cairo will free the glyph array when done with it, no matter what
 * the return value of the callback is.
 * If glyphs initially points to a non-NULL value, that array can be used
 * as a glyph buffer, and num_glyphs points to the number of glyph
 * entries available there. If the provided glyph array is too short for
 * the conversion (or for convenience), a new glyph array may be allocated
 * using cairo_glyph_allocate() and placed in glyphs. Upon return,
 * num_glyphs should contain the number of generated glyphs.
 * If the value glyphs points at has changed after the call, cairo will
 * free the allocated glyph array using cairo_glyph_free().
 * If clusters is not NULL, num_clusters and cluster_flags are also non-NULL,
 * and cluster mapping should be computed.
 * The semantics of how cluster array allocation works is similar to the glyph
 * array. That is,
 * if clusters initially points to a non-NULL value, that array may be used
 * as a cluster buffer, and num_clusters points to the number of cluster
 * entries available there. If the provided cluster array is too short for
 * the conversion (or for convenience), a new cluster array may be allocated
 * using cairo_text_cluster_allocate() and placed in clusters. Upon return,
 * num_clusters should contain the number of generated clusters.
 * If the value clusters points at has changed after the call, cairo will
 * free the allocated cluster array using cairo_text_cluster_free().
 * The callback is optional. If not set, or if num_glyphs is negative upon
 * the callback returning, the unicode_to_glyph callback
 * is tried. See cairo_user_scaled_font_unicode_to_glyph_func_t.
 * Note: While cairo does not impose any limitation on glyph indices,
 * some applications may assume that a glyph index fits in a 16-bit
 * unsigned integer. As such, it is advised that user-fonts keep their
 * glyphs in the 0 to 65535 range. Furthermore, some applications may
 * assume that glyph 0 is a special glyph-not-found glyph. User-fonts
 * are advised to use glyph 0 for such purposes and do not use that
 * glyph value for other purposes.
 * scaled_font :
 *  the scaled-font being created
 * utf8 :
 *  a string of text encoded in UTF-8
 * utf8_len :
 *  length of utf8 in bytes
 * glyphs :
 *  pointer to array of glyphs to fill, in font space
 * num_glyphs :
 *  pointer to number of glyphs
 * clusters :
 *  pointer to array of cluster mapping information to fill, or NULL
 * num_clusters :
 *  pointer to number of clusters
 * cluster_flags :
 *  pointer to location to store cluster flags corresponding to the
 *  output clusters
 * Returns :
 *  CAIRO_STATUS_SUCCESS upon success, or
 * CAIRO_STATUS_USER_FONT_ERROR or any other error status on error.
 * Since 1.8
 */
// cairo_status_t (*cairo_user_scaled_font_text_to_glyphs_func_t)  (cairo_scaled_font_t *scaled_font,  const char *utf8,  int utf8_len,  cairo_glyph_t **glyphs,  int *num_glyphs,  cairo_text_cluster_t **clusters,  int *num_clusters,  cairo_text_cluster_flags_t *cluster_flags);
public typedef extern(C) cairo_status_t  function (cairo_scaled_font_t*, char*, int, cairo_glyph_t**, int*, cairo_text_cluster_t**, int*, cairo_text_cluster_flags_t*) cairo_user_scaled_font_text_to_glyphs_func_t;

/*
 * cairo_user_scaled_font_unicode_to_glyph_func_t is the type of function which
 * is called to convert an input Unicode character to a single glyph.
 * This is used by the cairo_show_text() operation.
 * This callback is used to provide the same functionality as the
 * text_to_glyphs callback does (see cairo_user_scaled_font_text_to_glyphs_func_t)
 * but has much less control on the output,
 * in exchange for increased ease of use. The inherent assumption to using
 * this callback is that each character maps to one glyph, and that the
 * mapping is context independent. It also assumes that glyphs are positioned
 * according to their advance width. These mean no ligatures, kerning, or
 * complex scripts can be implemented using this callback.
 * The callback is optional, and only used if text_to_glyphs callback is not
 * set or fails to return glyphs. If this callback is not set, an identity
 * mapping from Unicode code-points to glyph indices is assumed.
 * Note: While cairo does not impose any limitation on glyph indices,
 * some applications may assume that a glyph index fits in a 16-bit
 * unsigned integer. As such, it is advised that user-fonts keep their
 * glyphs in the 0 to 65535 range. Furthermore, some applications may
 * assume that glyph 0 is a special glyph-not-found glyph. User-fonts
 * are advised to use glyph 0 for such purposes and do not use that
 * glyph value for other purposes.
 * scaled_font :
 *  the scaled-font being created
 * unicode :
 *  input unicode character code-point
 * glyph_index :
 *  output glyph index
 * Returns :
 *  CAIRO_STATUS_SUCCESS upon success, or
 * CAIRO_STATUS_USER_FONT_ERROR or any other error status on error.
 * Since 1.8
 */
// cairo_status_t (*cairo_user_scaled_font_unicode_to_glyph_func_t)  (cairo_scaled_font_t *scaled_font,  unsigned long unicode,  unsigned long *glyph_index);
public typedef extern(C) cairo_status_t  function (cairo_scaled_font_t*, ulong, ulong*) cairo_user_scaled_font_unicode_to_glyph_func_t;

/*
 * cairo_read_func_t is the type of function which is called when a
 * backend needs to read data from an input stream. It is passed the
 * closure which was specified by the user at the time the read
 * function was registered, the buffer to read the data into and the
 * length of the data in bytes. The read function should return
 * CAIRO_STATUS_SUCCESS if all the data was successfully read,
 * CAIRO_STATUS_READ_ERROR otherwise.
 * closure :
 *  the input closure
 * data :
 *  the buffer into which to read the data
 * length :
 *  the amount of data to read
 * Returns :
 *  the status code of the read operation
 */
// cairo_status_t (*cairo_read_func_t) (void *closure,  unsigned char *data,  unsigned int length);
public typedef extern(C) cairo_status_t  function (void*, uchar*, uint) cairo_read_func_t;

/*
 * cairo_write_func_t is the type of function which is called when a
 * backend needs to write data to an output stream. It is passed the
 * closure which was specified by the user at the time the write
 * function was registered, the data to write and the length of the
 * data in bytes. The write function should return
 * CAIRO_STATUS_SUCCESS if all the data was successfully written,
 * CAIRO_STATUS_WRITE_ERROR otherwise.
 * closure :
 *  the output closure
 * data :
 *  the buffer containing the data to write
 * length :
 *  the amount of data to write
 * Returns :
 *  the status code of the write operation
 */
// cairo_status_t (*cairo_write_func_t) (void *closure,  unsigned char *data,  unsigned int length);
public typedef extern(C) cairo_status_t  function (void*, uchar*, uint) cairo_write_func_t;

/*
 * cairo_destroy_func_t the type of function which is called when a
 * data element is destroyed. It is passed the pointer to the data
 * element and should free any memory and resources allocated for it.
 * data :
 *  The data element being destroyed.
 */
// void (*cairo_destroy_func_t) (void *data);
public typedef extern(C) void  function (void*) cairo_destroy_func_t;

// skipped union cairo_path_data_t


version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gtkc");
        } else version (DigitalMars) {
            pragma(link, "DD-gtkc");
        } else {
            pragma(link, "DO-gtkc");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gtkc");
        } else version (DigitalMars) {
            pragma(link, "DD-gtkc");
        } else {
            pragma(link, "DO-gtkc");
        }
    }
}
