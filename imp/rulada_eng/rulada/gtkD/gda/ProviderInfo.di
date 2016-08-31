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
 * inFile  = 
 * outPack = gda
 * outFile = ProviderInfo
 * strct   = GdaProviderInfo
 * realStrct=
 * ctorStrct=
 * clss    = ProviderInfo
 * interf  = 
 * class Code: Yes
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- gda_provider_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * 	- gtkD.glib.ListG
 * structWrap:
 * 	- GdaProviderInfo* -> ProviderInfo
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gda.ProviderInfo;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;
private import gtkD.glib.ListG;




/**
 * Description
 *  The functions in this section allow applications an easy access to the libgda
 *  configuration, thus making them able to access the list of data sources
 *  configured in the system, for instance.
 */
public class ProviderInfo
{
	
	/** the main Gtk struct */
	protected GdaProviderInfo* gdaProviderInfo;
	
	
	public GdaProviderInfo* getProviderInfoStruct()
	{
		return gdaProviderInfo;
	}
	
	
	/** the main Gtk struct as a void* */
	protected void* getStruct()
	{
		return cast(void*)gdaProviderInfo;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaProviderInfo* gdaProviderInfo)
	{
		if(gdaProviderInfo is null)
		{
			this = null;
			return;
		}
		this.gdaProviderInfo = gdaProviderInfo;
	}
	
	/** */
	this (ListG glist) {
		this.gdaProviderInfo = cast(GdaProviderInfo *) glist.data;
	}
	/** */
string id() { return Str.toString(this.gdaProviderInfo.id); }
/** */
string location() { return Str.toString(this.gdaProviderInfo.location); }
/** */
string description() { return Str.toString(this.gdaProviderInfo.description); }
/** */
ListG gda_params() { return new ListG(this.gdaProviderInfo.gdaParams); }

/**
 */

/**
 * Returns:
 */
public static GType infoGetType()
{
	// GType gda_provider_info_get_type (void);
	return gda_provider_info_get_type();
}

/**
 * Creates a new GdaProviderInfo structure from an existing one.
 * Returns: a newly allocated GdaProviderInfo with contains a copy of information in src.
 */
public ProviderInfo infoCopy()
{
	// GdaProviderInfo* gda_provider_info_copy (GdaProviderInfo *src);
	auto p = gda_provider_info_copy(gdaProviderInfo);
	if(p is null)
	{
		return null;
	}
	return new ProviderInfo(cast(GdaProviderInfo*) p);
}

/**
 * Deallocates all memory associated to the given GdaProviderInfo.
 */
public void infoFree()
{
	// void gda_provider_info_free (GdaProviderInfo *provider_info);
	gda_provider_info_free(gdaProviderInfo);
}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-gda");
        } else version (DigitalMars) {
            pragma(link, "DD-gda");
        } else {
            pragma(link, "DO-gda");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-gda");
        } else version (DigitalMars) {
            pragma(link, "DD-gda");
        } else {
            pragma(link, "DO-gda");
        }
    }
}
