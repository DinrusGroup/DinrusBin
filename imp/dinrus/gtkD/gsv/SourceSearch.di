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

/*
 * Conversion parameters:
 * inFile  = gtksourceview-20-Searching-in-a-GtkSourceBuffer.html
 * outPack = gsv
 * outFile = SourceSearch
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = SourceSearch
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gtk_source_iter_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.gtk.TextIter
 * 	- gtkD.glib.Str
 * structWrap:
 * 	- GtkTextIter* -> TextIter
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gsv.SourceSearch;

public  import gtkD.gsvc.gsvtypes;

private import gtkD.gsvc.gsv;
private import gtkD.glib.ConstructionException;


private import gtkD.gtk.TextIter;
private import gtkD.glib.Str;




/**
 * Description
 */
public class SourceSearch
{
	
	/**
	 */
	
	/**
	 * Same as gtk_text_iter_backward_search(), but supports case insensitive
	 * searching.
	 * Params:
	 * iter =  a GtkTextIter where the search begins.
	 * str =  search string.
	 * flags =  bitmask of flags affecting the search.
	 * matchStart =  return location for start of match, or %NULL.
	 * matchEnd =  return location for end of match, or %NULL.
	 * limit =  location of last possible match_start, or %NULL for start of buffer.
	 * Returns: whether a match was found.
	 */
	public static int backwardSearch(TextIter iter, string str, GtkSourceSearchFlags flags, TextIter matchStart, TextIter matchEnd, TextIter limit)
	{
		// gboolean gtk_source_iter_backward_search (const GtkTextIter *iter,  const gchar *str,  GtkSourceSearchFlags flags,  GtkTextIter *match_start,  GtkTextIter *match_end,  const GtkTextIter *limit);
		return gtk_source_iter_backward_search((iter is null) ? null : iter.getTextIterStruct(), Str.toStringz(str), flags, (matchStart is null) ? null : matchStart.getTextIterStruct(), (matchEnd is null) ? null : matchEnd.getTextIterStruct(), (limit is null) ? null : limit.getTextIterStruct());
	}
	
	/**
	 * Searches forward for str. Any match is returned by setting
	 * match_start to the first character of the match and match_end to the
	 * first character after the match. The search will not continue past
	 * limit. Note that a search is a linear or O(n) operation, so you
	 * may wish to use limit to avoid locking up your UI on large
	 * buffers.
	 * If the GTK_SOURCE_SEARCH_VISIBLE_ONLY flag is present, the match may
	 * have invisible text interspersed in str. i.e. str will be a
	 * possibly-noncontiguous subsequence of the matched range. similarly,
	 * if you specify GTK_SOURCE_SEARCH_TEXT_ONLY, the match may have
	 * pixbufs or child widgets mixed inside the matched range. If these
	 * flags are not given, the match must be exact; the special 0xFFFC
	 * character in str will match embedded pixbufs or child widgets.
	 * If you specify the GTK_SOURCE_SEARCH_CASE_INSENSITIVE flag, the text will
	 * be matched regardless of what case it is in.
	 * Same as gtk_text_iter_forward_search(), but supports case insensitive
	 * searching.
	 * Params:
	 * iter =  start of search.
	 * str =  a search string.
	 * flags =  flags affecting how the search is done.
	 * matchStart =  return location for start of match, or %NULL.
	 * matchEnd =  return location for end of match, or %NULL.
	 * limit =  bound for the search, or %NULL for the end of the buffer.
	 * Returns: whether a match was found.
	 */
	public static int forwardSearch(TextIter iter, string str, GtkSourceSearchFlags flags, TextIter matchStart, TextIter matchEnd, TextIter limit)
	{
		// gboolean gtk_source_iter_forward_search (const GtkTextIter *iter,  const gchar *str,  GtkSourceSearchFlags flags,  GtkTextIter *match_start,  GtkTextIter *match_end,  const GtkTextIter *limit);
		return gtk_source_iter_forward_search((iter is null) ? null : iter.getTextIterStruct(), Str.toStringz(str), flags, (matchStart is null) ? null : matchStart.getTextIterStruct(), (matchEnd is null) ? null : matchEnd.getTextIterStruct(), (limit is null) ? null : limit.getTextIterStruct());
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gsv");
        } else version (DigitalMars) {
            pragma(link, "DD-gsv");
        } else {
            pragma(link, "DO-gsv");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gsv");
        } else version (DigitalMars) {
            pragma(link, "DD-gsv");
        } else {
            pragma(link, "DO-gsv");
        }
    }
}
