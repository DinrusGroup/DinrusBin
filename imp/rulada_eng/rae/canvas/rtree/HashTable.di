module rae.canvas.rtree.HashTable;

/+
//DEPRECATED


import tango.io.Stdout;
import Integer = tango.text.convert.Integer;
import Float = tango.text.convert.Float;
//import std.stdio;

import tango.util.container.LinkedList;

//import ptl.string;
alias char[] string;
//import ptl.list;

class HashTable(KeyType, T)
{
protected:

	class Node(KeyType, T)
	{
	public:
		KeyType key;
		T data;
		//int linkki;

		this()
		{
			//key = 0;
			//data = null;
			//linkki = -1;
		}

		this( KeyType set_key, T set_data )
		{
			key = set_key;
			data = set_data;
			//linkki = -1;
		}

		String toString()
		{
			return "("
			~ Integer.toString( key )//std.string.toString(key)
			~ ", "
			~ data.toString()
			//~ ", linkki: "
			//~ linkki
			~ ") ";
		}
	}

	//T[KeyType] m_data;

public:

	//typedef List!( Node!(KeyType, T )) ListOfNodes;
	//alias List!( Node!(KeyType, T )) ListOfNodes;
	alias LinkedList!( Node!(KeyType, T )) ListOfNodes;

	this( uint init_size = 100 )
	{
		debug(HashTable) writefln("HashTable.this()...START.").newline;
		//m_data = new T[KeyType[]];

		initSize = init_size;

		init();

		/*for( uint i = 0; i < init_size; i++ )
		{
			assert( dataArray[i] !is null );
		}*/

		/*foreach( ListOfNodes l; dataArray )
		{
			//This doesn't work because of a possible bug in DMD...
			//see ptl.list.List.unittest for some more thoughts...

			l = new ListOfNodes();
			assert( l !is null );
		}*/

		foreach( ListOfNodes l; dataArray )
		{
			assert( l !is null );
		}

		debug(HashTable) writefln("HashTable.this()...END.").newline;
	}

	protected void init()
	{
		dataArray = new ListOfNodes[initSize];

		for( uint i = 0; i < dataArray.size; i++ )
		{
			dataArray[i] = new ListOfNodes();
			assert( dataArray[i] !is null );
		}
	}

	void clear()
	{
		debug(HashTable) writefln("HashTable.clear()...START.").newline;
		//m_data.clear();

		//for( uint i = 0; i < dataArray.size; i++ )
		//{
		foreach( ListOfNodes l; dataArray )
		{
			//foreach( Node!(KeyType, T) u; l )
			//{
				//delete Nodes in this list?
			//}
			delete l;
		}

		delete dataArray;

		init();

		debug(HashTable) writefln("HashTable.clear()...END.").newline;
	}

	T remove(KeyType get_key)
	{
		debug(HashTable) writefln("HashTable.remove(KeyType set)...START.").newline;
		//T ret = dataArray[set];
		//m_data.remove(set);

		int place = get_key % dataArray.size;

		//ListOfNodes.Iterator iter = dataArray[place].begin();
		ListOfNodes.Iterator iter = dataArray[place].head();

		while( iter !is null )
		{
			//writefln( iter.object() );
			if( iter.object().key == get_key )
			{
				debug(HashTable) writefln("HashTable.remove(KeyType get_key) found...END: key:", get_key, " place:", place);
				T removed = iter.object().data;
				dataArray[place].remove( iter.object() );//remove the node from the list.
				return removed;
			}
			iter = iter.next();
		}

		debug(HashTable) writefln("HashTable.remove(KeyType set)...END.").newline;
		return null;//ret;
	}

	T get(KeyType get_key)
	{
		debug(HashTable) writefln("HashTable.get(KeyType get_key)...START.").newline;
		int place = get_key % dataArray.size;

		//ListOfNodes.Iterator iter = dataArray[place].begin();
		ListOfNodes.Iterator iter = dataArray[place].head();

		while( iter !is null )
		{
			//writefln( iter.object() );
			if( iter.object().key == get_key )
			{
				debug(HashTable) writefln("HashTable.get(KeyType get_key) found...END: key:", get_key, " place:", place);

				return iter.object().data;
			}
			iter = iter.next();
		}
		debug(HashTable) writefln("HashTable.get(KeyType get_key) not found...END: key:", get_key, " place:", place);
		return null;//dataArray[get_key];
	}

	void put(KeyType set_key, T set_data)
	{
		debug(HashTable) writefln("HashTable.put()...START. set_key = ",set_key, "\n set_data: ", set_data );
		//m_data[set] = ob;

		//I'm not sure if this is correct behaviour:
		if(set_key >= dataArray.size )
			growHashTable();

		int place = set_key % dataArray.size; //set_data.toHash();

			//System.out.print("\nYritetn hajauttaa avain: ");
			//System.out.print( avain );

			debug(HashTable) writefln("HashTable.put(..)...Trying to create a new hashtablenode at key:", set_key, " at place:", place);
			Node!(KeyType, T) new_node = new Node!(KeyType, T)( set_key, set_data );
			debug(HashTable) writefln("HashTable.put(..)...Trying to create a new hashtablenode.SUCCESS.");
			debug(HashTable) assert(new_node !is null);

			/*if( dataArray[place] !is null )
			{
				//epaonni++;
				//System.out.print( "\n			Eponnistuneita tutkimuksia: ");
				//System.out.print( epaonni );

				//System.out.print( "\n		Trmys! paikassa: " );
				//System.out.print( tulos );
				//System.out.print( " , edellinen luku: " );
				//System.out.print( taulu[tulos].avain );
				//System.out.print( " , uusi avain: " );
				//System.out.print( avain );

				//dataArray[place].linkki = ylivuotokasittely( uusi_tietue );
				return;
			}*/

			if(place < dataArray.size)
			{
				Node!(KeyType, T) old_node;
				foreach( Node!(KeyType, T) n; dataArray[place] )
				{
					if( n.key == set_key )
					{
						old_node = n;
						break;
					}
				}

				if( old_node !is null )//then overwrite:
				{
					dataArray[place].remove( old_node );
				}

				dataArray[place].pushBack( new_node );

				if( dataArray[place].size >= listLimit && areKeysDifferent( dataArray[place] ) )//allow growth only if keys are different.
				{
					growHashTable();
				}
			}
			else Stdout("HashTable.put() ...Error: place is bigger  than dataArray size.").newline;

		debug(HashTable) Stdout("HashTable.put() ...END. dataArray[")( place )("].size: ")( dataArray[place].size).newline;
	}

	bool containsKey(KeyType get_key)
	{
		//if( (set in m_data) is null)
		//	return false;
		//else return true;

		if( get( get_key ) !is null )
			return true;
		//else
			return false;
	}

	bool areKeysDifferent( ListOfNodes lon)
	{
		foreach( Node!(KeyType, T) u; lon )
		{
			foreach( Node!(KeyType, T) i; lon )
			{
				//if( u !is i )//don't compare the keys of the same object
				//{//which isn't necessary, because we are only interested in difference not similarity...
				if( u.key != i.key )
					return true;
				//}
			}
		}
		return false;//if we get this far, all the keys in the list were the same.
	}

	void growHashTable()
	{
		debug(HashTable) writefln("HashTable.growHashTable()...START.").newline;

		ListOfNodes[] oldDataArray = dataArray;

		dataArray = new ListOfNodes[ oldDataArray.size + growSize ];

		for( uint i = 0; i < dataArray.size; i++ )
		{
			dataArray[i] = new ListOfNodes();
			assert( dataArray[i] !is null );
		}

		foreach( ListOfNodes l; oldDataArray )
		{
			//writefln( "Printing dataArray ", i, ":" );
			foreach( Node!(KeyType, T) u; l )
			{
				//writefln( "foreach[]: = ", u );
				put( u.key, u.data );
				//assert( l !is null );
			}
			//i++;
		}

		debug(HashTable) writefln("HashTable.growHashTable()...END. new.size: ", dataArray.size);

	}

	String toString()
	{
		String ret;
		ret ~= "HashTable contents:  ";
		uint i = 0;
		foreach( ListOfNodes l; dataArray )
		{
			ret ~= "Printing dataArray ";
			ret ~= Integer.toString( i );//std.string.toString( i );
			ret ~= ":";

			foreach( Node!(KeyType, T) u; l )
			{
				ret ~= "foreach[]: = ";
				ret ~= u.toString();
				//assert( l !is null );
			}
			i++;
		}

		return ret;
	}

protected:

	//List!( Node!(KeyType, T ))
	ListOfNodes[] dataArray; //A dynamic array, of linkedlists, of nodes...
	//int dataArraySize;
	//Node!(KeyType, T)[] overflow;
	//int overflowSize;

	int initSize; //= 100;
	int growSize = 100;
	int listLimit = 30;

	//int epaonni;
}

//Unittests:

class UnittestValue2//(F)
{
	public:
		this(float set){ value = set; }
		float value;
		char[] toString() { return Float.toString( value );//std.string.toString( value ); 
		}
}

alias UnittestValue2 Uflo2;//!(float) Uflo2;

unittest
{
	//debug(HashTable)
	writefln("Performing ptl.HashTable unittest...START." );

	scope HashTable!(int, Uflo2 ) new_hash = new HashTable!(int, Uflo2);

	//scope HashTable!(int, Uflo2) neue_hash;

	//HashTable!(int, Uflo2) new_hash = new HashTable!(int, Uflo2);

	for(uint i = 0; i < 20; i++)
	{
		UnittestValue2 blum = new UnittestValue2( cast(float)i * 0.123f );
		new_hash.put( i, blum );
	}

	for(uint i = 5; i < 15; i++)
	{
		UnittestValue2 blum = new UnittestValue2( cast(float)i * 0.823f );
		new_hash.put( i, blum );
	}

	for(uint i = 5; i < 8; i++)
	{
		UnittestValue2 blum = new UnittestValue2( cast(float)i * 0.623f );
		new_hash.put( i, blum );
	}

	for(uint i = 595; i < 610; i++)
	{
		UnittestValue2 blum = new UnittestValue2( cast(float)i * 1.0f );
		new_hash.put( i, blum );
	}

	debug(HashTable) writefln( new_hash );

	Uflo2 getuf = new_hash.get(5);

	assert(getuf !is null);
	debug(HashTable) writefln("get(0) value is: ", getuf);

	debug(HashTable)
	{
		if( new_hash.containsKey( 5 ) )
			writefln("YES, it contains key 5.");
		else writefln("NO, it doesn't contain key 5.");
	}

	debug(HashTable) writefln("Trying remove.");
	Uflo2 removed = new_hash.remove(5);
	assert( getuf.value == removed.value );
	debug(HashTable)
	{
		if( removed !is null )
			writefln("Removed value: ", removed.value );
		else writefln("Removed is null.");

		if( new_hash.containsKey( 5 ) )
			writefln("YES, it contains key 5. But it's: ", new_hash.get(5) );
		else writefln("NO, it doesn't contain key 5. That's good, as we removed it.");
	}

	//assert( new_hash.containsKey( 5 ) != true );//This doesn't work as the Hash might contain multiple data with the same keys.

	//.hajauta_jako( 23, "Tietoa" );
	//hajautin.hajauta_jako( 14, "Tietoa" );
	//hajautin.hajauta_jako( 8, "Tietoa" );
	//hajautin.hajauta_jako( 5, "Tietoa" );
	//hajautin.hajauta_jako( 13, "Tietoa" );
	//hajautin.hajauta_jako( 17, "Tietoa" );
	//hajautin.hajauta_jako( 2, "Tietoa" );
	//hajautin.hajauta_jako( 11, "Tietoa" );
	//hajautin.hajauta_jako( 25, "Tietoa" );

	//debug(HashTable)
	writefln("Performing ptl.HashTable unittest...END." );
}


/*
class JakoHajautin
{
	public JakoHajautin( int setkoko, int setylikoko )
	{

		System.out.println( "Luodaan hajautusalue koolla ");
		System.out.println( setkoko );

		koko = setkoko;
		taulu = new Tietue[koko];

		ylikoko = setylikoko;
		ylivuoto = new Tietue[ylikoko];

	}

	public void hajauta_jako( int avain, String tieto )
	{
		int tulos = avain % koko;

			System.out.print("\nYritetn hajauttaa avain: ");
			System.out.print( avain );

			Tietue uusi_tietue = new Tietue( avain, tieto );

			if( taulu[tulos] != null )
			{
				epaonni++;
				System.out.print( "\n			Eponnistuneita tutkimuksia: ");
				System.out.print( epaonni );

				System.out.print( "\n		Trmys! paikassa: " );
				System.out.print( tulos );
				System.out.print( " , edellinen luku: " );
				System.out.print( taulu[tulos].avain );
				System.out.print( " , uusi avain: " );
				System.out.print( avain );

				taulu[tulos].linkki = ylivuotokasittely( uusi_tietue );
				return;
			}

			taulu[tulos] = uusi_tietue;

	}

	int ylivuotokasittely( Tietue tie )
	{
		//Pitk ylivuotoalueella hajauttaa???
		int tulos = tie.avain % ylikoko;

		if( ylivuoto[tulos] != null )
		{
			epaonni++;
			System.out.print( "\n			Eponnistuneita tutkimuksia: ");
			System.out.print( epaonni );

			System.out.print( "\n		Trmys! ylivuotoalueella paikassa: " );

			for( int i = tulos+1; i < ylikoko; i++ )
			{
				if( ylivuoto[i] == null )
				{
					System.out.print( "\n		Ylivuotokasittely lysi paikan: " );
					System.out.print( i );
					ylivuoto[i] = tie;
					ylivuoto[tulos].linkki = i;
					return i;
				}
				else
				{
					epaonni++;
					System.out.print( "\n			Eponnistuneita tutkimuksia: ");
					System.out.print( epaonni );
				}
			}
			System.out.print( "\nYlivuotoksittely eponnistui, paikkaa ei lytynyt.");
			return -1;
		}

		System.out.print( "\n		Ylivuotokasittely lysi paikan: " );
		System.out.print( tulos );
		ylivuoto[tulos] = tie;
		return tulos;
	}

	public void tulosta()
	{
		System.out.print("\nHajautusalue:\n");

		for( int i = 0; i < koko; i++ )
		{
			System.out.print( i );
			System.out.print(" : ");
			if( taulu[i] != null ) taulu[i].tulosta();
			System.out.print( "\n" );
		}

		System.out.print("\nYlivuotoalue:\n");

		for( int i = 0; i < ylikoko; i++ )
		{
			System.out.print( i );
			System.out.print(" : ");
			if( ylivuoto[i] != null ) ylivuoto[i].tulosta();
			System.out.print( "\n" );
		}
	}


}
*/

+/



version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    }
}
