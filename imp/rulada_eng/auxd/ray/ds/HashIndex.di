/**
	Copyright: Copyright (c) 2007, Artyom Shalkhakov. All rights reserved.
	License: BSD

	Version: Aug 2007: initial release
	Authors: Artyom Shalkhakov
*/
module auxd.ray.ds.HashIndex;

import Math = auxd.ray.base.Math;

/**
	Fast hash table for indices and arrays.
	Does not allocate memory until the first key/index pair is added.
	This is loosely based on code from id Software's Doom3 SDK
*/
final class HashIndex {
	this() {
		this( DEFAULT_HASH_SIZE, DEFAULT_HASH_SIZE );
	}

	this( int hashSize, int indexSize )
	in {
		assert( Math.isPowerOfTwo( hashSize ) );
	}
	body {
		this.hash = INVALID_INDEX;
		this.hashSize = hashSize;
		this.indexChain = INVALID_INDEX;
		this.indexSize = indexSize;
		this.hashMask = hashSize - 1;
	}

	HashIndex dup();

	/// add an index to the hash, assumes the index has not yet been added to the hash
	void add( int key, int index );

	/// remove an index from the hash
	void remove( int key, int index ) ;

	/// returns the first index from the hash, returns -1 if empty hash entry
	int first( int key );
	/// get the next index from the hash, returns -1 if at the end of the hash chain
	int next( int index );
	/// inserts an entry into the index and adds it to the hash, increasing all indexes >= index
	void insertIndex( int key, int index ) ;
	/// removes an entry from the index and from the hash, decreasing all indices >= index
	void removeIndex( int key, int index );

	/// clear the hash
	void clear() ;

	/// clear and resize
	void clear( size_t newHashSize, size_t newIndexSize );
	/// free allocated memory
	void free();

	/// get size of hash table
	int getHashSize();

	/// get size of the index
	int getIndexSize();

	/// force resizing the index, current hash table stays intact
	void resizeIndex( int newIndexSize ) ;

	private {
		int			hashSize;
		int[]		hash;
		int			indexSize;
		int[]		indexChain;
		int			hashMask;
		int			lookupMask;

		const {
			int[1]	INVALID_INDEX		= [ -1 ];
			int		DEFAULT_HASH_SIZE	= 1024;
		}

		void allocate( int newHashSize, int newIndexSize );
	}
}

unittest {
	HashIndex	indexHash = new HashIndex;
	int[]		indices;

	assert( indexHash.first( 0 ) == -1 );
	indexHash.add( 0, 10 );
	assert( indexHash.first( 0 ) == 10 );
	indexHash.add( 0, 11 );
	assert( indexHash.first( 0 ) == 11 );
	assert( indexHash.next( 11 ) == 10 );
	indexHash.remove( 0, 11 );
	assert( indexHash.first( 0 ) == 10 );
	assert( indexHash.next( 10 ) == -1 );
}

version (build) {
    debug {
        pragma(link, "ray");
    } else {
        pragma(link, "ray");
    }
}
