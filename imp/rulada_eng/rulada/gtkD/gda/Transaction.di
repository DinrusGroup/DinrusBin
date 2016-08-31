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
 * inFile  = libgda-GdaTransaction.html
 * outPack = gda
 * outFile = Transaction
 * strct   = GdaTransaction
 * realStrct=
 * ctorStrct=
 * clss    = Transaction
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = GObject
 * implements:
 * prefixes:
 * 	- gda_transaction_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * 	- gtkD.glib.Str
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.gda.Transaction;

public  import gtkD.gdac.gdatypes;

private import gtkD.gdac.gda;
private import gtkD.glib.ConstructionException;


private import gtkD.glib.Str;



private import gtkD.gobject.ObjectG;

/**
 * Description
 */
public class Transaction : ObjectG
{
	
	/** the main Gtk struct */
	protected GdaTransaction* gdaTransaction;
	
	
	public GdaTransaction* getTransactionStruct()
	{
		return gdaTransaction;
	}
	
	
	/** the main Gtk struct as a void* */
	protected override void* getStruct()
	{
		return cast(void*)gdaTransaction;
	}
	
	/**
	 * Sets our main struct and passes it to the parent class
	 */
	public this (GdaTransaction* gdaTransaction)
	{
		if(gdaTransaction is null)
		{
			this = null;
			return;
		}
		//Check if there already is a D object for this gtk struct
		void* ptr = getDObject(cast(GObject*)gdaTransaction);
		if( ptr !is null )
		{
			this = cast(Transaction)ptr;
			return;
		}
		super(cast(GObject*)gdaTransaction);
		this.gdaTransaction = gdaTransaction;
	}
	
	/**
	 */
	
	/**
	 * Creates a new GdaTransaction object, which allows a fine-tune and
	 * full control of transactions to be used with providers.
	 * Params:
	 * name =  name for the transaction.
	 * Throws: ConstructionException GTK+ fails to create the object.
	 */
	public this (string name)
	{
		// GdaTransaction* gda_transaction_new (const gchar *name);
		auto p = gda_transaction_new(Str.toStringz(name));
		if(p is null)
		{
			throw new ConstructionException("null returned by gda_transaction_new(Str.toStringz(name))");
		}
		this(cast(GdaTransaction*) p);
	}
	
	/**
	 * Gets the isolation level for the given transaction. This specifies
	 * the locking behavior for the database connection during the given
	 * transaction.
	 * Returns: the isolation level.
	 */
	public GdaTransactionIsolation getIsolationLevel()
	{
		// GdaTransactionIsolation gda_transaction_get_isolation_level  (GdaTransaction *xaction);
		return gda_transaction_get_isolation_level(gdaTransaction);
	}
	
	/**
	 * Sets the isolation level for the given transaction.
	 * Params:
	 * level =  the isolation level.
	 */
	public void setIsolationLevel(GdaTransactionIsolation level)
	{
		// void gda_transaction_set_isolation_level (GdaTransaction *xaction,  GdaTransactionIsolation level);
		gda_transaction_set_isolation_level(gdaTransaction, level);
	}
	
	/**
	 * Retrieves the name of the given transaction, as specified by the
	 * client application (via a non-NULL parameter in the call to
	 * gda_transaction_new, or by calling gda_transaction_set_name).
	 * Note that some providers may set, when you call
	 * gda_connection_begin_transaction, the name of the transaction if
	 * it's not been specified by the client application, so this function
	 * may return, for some providers, values that you don't expect.
	 * Returns: the name of the transaction.
	 */
	public string getName()
	{
		// const gchar* gda_transaction_get_name (GdaTransaction *xaction);
		return Str.toString(gda_transaction_get_name(gdaTransaction));
	}
	
	/**
	 * Sets the name of the given transaction. This is very useful when
	 * using providers that support named transactions.
	 * Params:
	 * name =  new name for the transaction.
	 */
	public void setName(string name)
	{
		// void gda_transaction_set_name (GdaTransaction *xaction,  const gchar *name);
		gda_transaction_set_name(gdaTransaction, Str.toStringz(name));
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
