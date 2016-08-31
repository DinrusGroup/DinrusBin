/*******************************************************************************

        @file HashMap.d
        
        This software is provided 'as-is', without any express or implied
        warranty. In no event will the authors be held liable for damages
        of any kind arising from the use of this software.
        
        Permission is hereby granted to anyone to use this software for any 
        purpose, including commercial applications, and to alter it and/or 
        redistribute it freely, subject to the following restrictions:
        
        1. The origin of this software must not be misrepresented; you must 
           not claim that you wrote the original software. If you use this 
           software in a product, an acknowledgment within documentation of 
           said product would be appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must 
           not be misrepresented as being the original software.

        3. This notice may not be removed or altered from any distribution
           of the source.

        4. Derivative works are permitted, but they must carry this notice
           in full and credit the original source.


                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


        Written by Doug Lea with assistance from members of JCP JSR-166
        Expert Group and released to the public domain, as explained at
        http://creativecommons.org/licenses/publicdomain
        
        @version        Initial version, July 2004      
        @author         Doug Lea; ported/modified by Kris;
			ported/modified into Containers package by John Demme

*******************************************************************************/

module mango.containers.ConcurrentHashMap;

private import mango.containers.Container;
private import mango.containers.HashSet;
private import mango.containers.Map;
private import mango.containers.Set;
private import mango.containers.Iterator;
private import mango.containers.Util;

/******************************************************************************

******************************************************************************/

/**
 * A hash table supporting full concurrency of retrievals and
 * adjustable expected concurrency for updates. This class obeys the
 * same functional specification as {@link java.util.Hashtable}, and
 * includes versions of methods corresponding to each method of
 * <tt>Hashtable</tt>. However, even though all operations are
 * thread-safe, retrieval operations do <em>not</em> entail locking,
 * and there is <em>not</em> any support for locking the entire table
 * in a way that prevents all access.  This class is fully
 * interoperable with <tt>Hashtable</tt> in programs that rely on its
 * thread safety but not on its synchronization details.
 *
 * <p> Retrieval operations (including <tt>get</tt>) generally do not
 * block, so may overlap with update operations (including
 * <tt>put</tt> and <tt>remove</tt>). Retrievals reflect the results
 * of the most recently <em>completed</em> update operations holding
 * upon their onset.  For aggregate operations such as <tt>putAll</tt>
 * and <tt>clear</tt>, concurrent retrievals may reflect insertion or
 * removal of only some entries.  Similarly, Iterators and
 * Enumerations return elements reflecting the state of the hash table
 * at some point at or since the creation of the iterator/enumeration.
 * They do <em>not</em> throw
 * {@link ConcurrentModificationException}.  However, iterators are
 * designed to be used by only one thread at a time.
 *
 * <p> The allowed concurrency among update operations is guided by
 * the optional <tt>concurrencyLevel</tt> constructor argument
 * (default 16), which is used as a hint for internal sizing.  The
 * table is internally partitioned to try to permit the indicated
 * number of concurrent updates without contention. Because placement
 * in hash tables is essentially random, the actual concurrency will
 * vary.  Ideally, you should choose a value to accommodate as many
 * threads as will ever concurrently modify the table. Using a
 * significantly higher value than you need can waste space and time,
 * and a significantly lower value can lead to thread contention. But
 * overestimates and underestimates within an order of magnitude do
 * not usually have much noticeable impact. A value of one is
 * appropriate when it is known that only one thread will modify and
 * all others will only read. Also, resizing this or any other kind of
 * hash table is a relatively slow operation, so, when possible, it is
 * a good idea to provide estimates of expected table sizes in
 * constructors.
 *
 * <p>This class and its views and iterators implement all of the
 * <em>optional</em> methods of the {@link Map} and {@link Iterator}
 * interfaces.
 *
 * <p> Like {@link java.util.Hashtable} but unlike {@link
 * java.util.HashMap}, this class does NOT allow <tt>null</tt> to be
 * used as a key or value.
 *
 * <p>This class is a member of the
 * <a href="{@docRoot}/../guide/collections/index.html">
 * Java Collections Framework</a>.
 *
 * @since 1.5
 * @author Doug Lea
 * @param <K> the type of keys maintained by this map
 * @param <V> the type of mapped values 
 */

class ConcurrentHashMap (K,V): AbstractMutableMap!(K,V)
{
    /*
     * The basic strategy is to subdivide the table among Segments,
     * each of which itself is a concurrently readable hash table.
     */

    /* ---------------- Constants -------------- */

    /**
     * The default initial number of table slots for this table.
     * Used when not otherwise specified in constructor.
     */
    private const uint DEFAULT_INITIAL_CAPACITY = 16;

    /**
     * The maximum capacity, used if a higher value is implicitly
     * specified by either of the constructors with arguments.  MUST
     * be a power of two <= 1<<30 to ensure that entries are indexible
     * using ints.
     */
    private const uint MAXIMUM_CAPACITY = 1 << 30; 

    /**
     * The default load factor for this table.  Used when not
     * otherwise specified in constructor.
     */
    private const float DEFAULT_LOAD_FACTOR = 0.75f;

    /**
     * The default number of concurrency control segments.
     **/
    private const uint DEFAULT_SEGMENTS = 16;

    /**
     * The maximum number of segments to allow; used to bound
     * constructor arguments.
     */
    private const uint MAX_SEGMENTS = 1 << 16; // slightly conservative


    /* ---------------- Fields -------------- */

    /**
     * Mask value for indexing into segments. The upper bits of a
     * key's hash code are used to choose the segment.
     **/
    private final int segmentMask;

    /**
     * Shift value for indexing within segments.
     **/
    private final int segmentShift;

    /**
     * The segments, each of which is a specialized hash table
     */
    private final Segment[] segments;


    /* ---------------- Small Utilities -------------- */


    /**
     * Returns the segment that should be used for key with given hash
     * @param hash the hash code for the key
     * @return the segment
     */
    private final Segment segmentFor(uint hash) 
    {
        return segments[(hash >>> segmentShift) & segmentMask];
    }

    /* ---------------- Inner Classes -------------- */

    /**
     * ConcurrentHashMap list entry. Note that this is never exported
     * out as a user-visible Map.Entry. 
     * 
     * Because the value field is volatile, not final, it is legal wrt
     * the Java Memory Model for an unsynchronized reader to see null
     * instead of initial value when read via a data race.  Although a
     * reordering leading to this is not likely to ever actually
     * occur, the Segment.readValueUnderLock method is used as a
     * backup in case a null (pre-initialized) value is ever seen in
     * an unsynchronized access method.
     */
    private static class HashEntry 
    {
        final K         key;
        final uint      hash;
        final V         value;
        final HashEntry next;

        this (K key, uint hash, HashEntry next, V value) 
        {
            this.key = key;
            this.hash = hash;
            this.next = next;
            this.value = value;
        }
    }

    /**
     * Segments are specialized versions of hash tables.  This
     * subclasses from ReentrantLock opportunistically, just to
     * simplify some locking and avoid separate construction.
     **/
    class Segment
    {
        /*
         * Segments maintain a table of entry lists that are ALWAYS
         * kept in a consistent state, so can be read without locking.
         * Next fields of nodes are immutable (final).  All list
         * additions are performed at the front of each bin. This
         * makes it easy to check changes, and also fast to traverse.
         * When nodes would otherwise be changed, new nodes are
         * created to replace them. This works well for hash tables
         * since the bin lists tend to be short. (The average length
         * is less than two for the default load factor threshold.)
         *
         * Read operations can thus proceed without locking, but rely
         * on selected uses of volatiles to ensure that completed
         * write operations performed by other threads are
         * noticed. For most purposes, the "count" field, tracking the
         * number of elements, serves as that volatile variable
         * ensuring visibility.  This is convenient because this field
         * needs to be read in many read operations anyway:
         *
         *   - All (unsynchronized) read operations must first read the
         *     "count" field, and should not look at table entries if
         *     it is 0.
         *
         *   - All (synchronized) write operations should write to
         *     the "count" field after structurally changing any bin.
         *     The operations must not take any action that could even
         *     momentarily cause a concurrent read operation to see
         *     inconsistent data. This is made easier by the nature of
         *     the read operations in Map. For example, no operation
         *     can reveal that the table has grown but the threshold
         *     has not yet been updated, so there are no atomicity
         *     requirements for this with respect to reads.
         *
         * As a guide, all critical volatile reads and writes to the
         * count field are marked in code comments.
         */

        /**
         * The number of elements in this segment's region.
         **/
        int count;

        /**
         * The table is rehashed when its size exceeds this threshold.
         * (The value of this field is always (int)(capacity *
         * loadFactor).)
         */
        int threshold;

        /**
         * The per-segment table. Declared as a raw type, casted
         * to HashEntry<K,V> on each use.
         */
        HashEntry[] table;

        /**
         * The load factor for the hash table.  Even though this value
         * is same for all segments, it is replicated to avoid needing
         * links to outer object.
         * @serial
         */
        final float loadFactor;

        this (int initialCapacity, float lf) 
        {
            loadFactor = lf;
            setTable (new HashEntry[initialCapacity]);
        }

        /**
         * Set table to new HashEntry array.
         * Call only while holding lock or in constructor.
         **/
        private final void setTable (HashEntry[] newTable) 
        {
            threshold = cast(int) (newTable.length * loadFactor);
            volatile table = newTable;
        }

        /**
         * Return properly casted first entry of bin for given hash
         */
        private final HashEntry getFirst (uint hash) 
        {
            HashEntry[] tab;
            
            volatile tab = table;
            return tab [hash & (tab.length - 1)];
        }

        /* Specialized implementations of map methods */

        final V get (K key, uint hash) 
        {
            int c;

            // read-volatile
            volatile c = count;
            if (c) 
               {
               HashEntry e = getFirst (hash);
               while (e) 
                     {
                     if (hash == e.hash && equals (key, e.key))
                        {
                        V v;
                        volatile v = e.value;
                        if (v)
                            return v;

                        synchronized (this)
                                      return e.value;
                        }
                     e = e.next;
                     }
               }
            return V.init;
        }


        final bool containsKey (K key, uint hash) 
        {
            int c;

            // read-volatile
            volatile c = count;
            if (c) 
               { 
               HashEntry e = getFirst (hash);
               while (e) 
                     {
                     if (e.hash == hash && equals (key, e.key))
                         return true;
                     e = e.next;
                     }
               }
            return false;
        }


        
        final synchronized V replace (K key, uint hash, V newValue) 
        {
                HashEntry e = getFirst(hash);
                while (e && (e.hash != hash || !equals (key, e.key)))
                       e = e.next;

                V oldValue;
                if (e) 
                    volatile 
                           {
                           oldValue = e.value;
                           e.value = newValue;
                           }
                return oldValue;
        }


        final synchronized V put (K key, uint hash, V value, bool onlyIfAbsent) 
        {
                int c;
                
                volatile c = count;
                if (c++ > threshold) 
                    rehash();

                HashEntry[] tab;
                volatile tab = table;
                uint index = hash & (tab.length - 1);
                HashEntry first = tab[index];
                HashEntry e = first;

                while (e && (e.hash != hash || !equals (key, e.key)))
                       e = e.next;

                V oldValue;
                if (e) 
                   {
                   volatile oldValue = e.value;
                   if (!onlyIfAbsent)
                        volatile e.value = value;
                   }
                else 
                   {
                   oldValue;
                   tab[index] = new HashEntry (key, hash, first, value);

                   // write-volatile
                   volatile count = c; 
                   }
                return oldValue;
        }


        private final void rehash () 
        {
            HashEntry[] oldTable;
            
            volatile oldTable = table;            
            int oldCapacity = oldTable.length;
            if (oldCapacity >= MAXIMUM_CAPACITY)
                return;

            /*
             * Reclassify nodes in each list to new Map.  Because we are
             * using power-of-two expansion, the elements from each bin
             * must either stay at same index, or move with a power of two
             * offset. We eliminate unnecessary node creation by catching
             * cases where old nodes can be reused because their next
             * fields won't change. Statistically, at the default
             * threshold, only about one-sixth of them need cloning when
             * a table doubles. The nodes they replace will be garbage
             * collectable as soon as they are no longer referenced by any
             * reader thread that may be in the midst of traversing table
             * right now.
             */

            HashEntry[] newTable = new HashEntry[oldCapacity << 1];
            threshold = cast(int) (newTable.length * loadFactor);
            int sizeMask = newTable.length - 1;

            for (int i = 0; i < oldCapacity ; ++i) 
                {
                // We need to guarantee that any existing reads of old Map can
                //  proceed. So we cannot yet null out each bin.
                HashEntry e = oldTable[i];

                if (e) 
                   {
                   HashEntry next = e.next;
                   uint idx = e.hash & sizeMask;

                   //  Single node on list
                   if (next is null)
                       newTable[idx] = e;
                   else 
                      {
                      // Reuse trailing consecutive sequence at same slot
                      HashEntry lastRun = e;
                      int lastIdx = idx;
                      for (HashEntry last=next; last; last = last.next) 
                          {
                          uint k = last.hash & sizeMask;
                          if (k != lastIdx) 
                             {
                             lastIdx = k;
                             lastRun = last;
                             }
                          }
                      newTable[lastIdx] = lastRun;

                      // Clone all remaining nodes
                      for (HashEntry p = e; p !is lastRun; p = p.next) 
                          {
                          uint k = p.hash & sizeMask;
                          HashEntry n = newTable[k];
                          newTable[k] = new HashEntry(p.key, p.hash, n, p.value);
                          }
                      }
                   }
                }
            volatile table = newTable;
        }

        /**
         * Remove; match on key only
         */
        final synchronized V remove (K key, uint hash) 
        {
                int c;
                HashEntry[] tab;

                volatile c = count - 1;
                volatile tab = table;

                uint index = hash & (tab.length - 1);
                HashEntry first = tab[index];
                HashEntry e = first;

                while (e && (e.hash != hash || !equals (key, e.key)))
                       e = e.next;

                V oldValue;
                if (e) 
                   {
                   V v;
                   volatile v = e.value;
                   oldValue = v;

                   // All entries following removed node can stay
                   // in list, but all preceding ones need to be
                   // cloned.                      
                   HashEntry newFirst = e.next;                         
                   for (HashEntry p = first; p !is e; p = p.next)
                        newFirst = new HashEntry (p.key, p.hash, newFirst, p.value);
                   tab[index] = newFirst;

                   // write-volatile
                   volatile count = c; 
                    
                }
                return oldValue;
        }


        final synchronized void clear() 
        {
            if (count) 
               {
                   HashEntry[] tab;
                   volatile tab = table;

                   for (int i = 0; i < tab.length ; i++)
                        tab[i] = null;
                   
                   // write-volatile
                   volatile count = 0; 
               }
        }

    	uint toHash() {
	  uint ret = 0;
	  foreach (HashEntry he; table) {
	    while (he !is null) {
	      ret += he.hash;
	      he = he.next;
	    }
	  }
	  return ret;
	}
    }



    /* ---------------- Public operations -------------- */

    /**
     * Creates a new, empty map with the specified initial
     * capacity and the specified load factor.
     *
     * @param initialCapacity the initial capacity. The implementation
     * performs internal sizing to accommodate this many elements.
     * @param loadFactor  the load factor threshold, used to control resizing.
     * @param concurrencyLevel the estimated number of concurrently
     * updating threads. The implementation performs internal sizing
     * to try to accommodate this many threads.  
     * @throws IllegalArgumentException if the initial capacity is
     * negative or the load factor or concurrencyLevel are
     * nonpositive.
     */
    public this (uint initialCapacity, float loadFactor, uint concurrencyLevel) 
    {
        assert (loadFactor > 0);

        if (concurrencyLevel > MAX_SEGMENTS)
            concurrencyLevel = MAX_SEGMENTS;

        // Find power-of-two sizes best matching arguments
        int sshift = 0;
        int ssize = 1;
        while (ssize < concurrencyLevel) 
              {
              ++sshift;
              ssize <<= 1;
              }

        segmentShift = 32 - sshift;
        segmentMask = ssize - 1;
        this.segments = new Segment[ssize];

        if (initialCapacity > MAXIMUM_CAPACITY)
            initialCapacity = MAXIMUM_CAPACITY;

        int c = initialCapacity / ssize;
        if (c * ssize < initialCapacity)
            ++c;

        int cap = 1;
        while (cap < c)
               cap <<= 1;

        for (int i = 0; i < this.segments.length; ++i)
             this.segments[i] = new Segment (cap, loadFactor);
    }

    /**
     * Creates a new, empty map with the specified initial
     * capacity,  and with default load factor and concurrencyLevel.
     *
     * @param initialCapacity The implementation performs internal
     * sizing to accommodate this many elements.
     * @throws IllegalArgumentException if the initial capacity of
     * elements is negative.
     */
    public this (uint initialCapacity) 
    {
        this(initialCapacity, DEFAULT_LOAD_FACTOR, DEFAULT_SEGMENTS);
    }

    /**
     * Creates a new, empty map with a default initial capacity,
     * load factor, and concurrencyLevel.
     */
    public this () 
    {
        this(DEFAULT_INITIAL_CAPACITY, DEFAULT_LOAD_FACTOR, DEFAULT_SEGMENTS);
    }

    /**
     * Returns the value to which the specified key is mapped in this table.
     *
     * @param   key   a key in the table.
     * @return  the value to which the key is mapped in this table;
     *          <tt>null</tt> if the key is not mapped to any value in
     *          this table.
     * @throws  NullPointerException  if the key is
     *               <tt>null</tt>.
     */
    public V get (K key) 
    {
        uint hash = hash(key); // throws NullPointerException if key null
        return segmentFor(hash).get(key, hash);
    }


    public bit isThreadSafe() {
      return true;
    }


    /**
     * Tests if the specified object is a key in this table.
     *
     * @param   key   possible key.
     * @return  <tt>true</tt> if and only if the specified object
     *          is a key in this table, as determined by the
     *          <tt>equals</tt> method; <tt>false</tt> otherwise.
     * @throws  NullPointerException  if the key is
     *               <tt>null</tt>.
     */
    public bit containsKey (K key) 
    {
        uint hash = hash(key); // throws NullPointerException if key null
        return segmentFor(hash).containsKey(key, hash);
    }

    /**
     * Maps the specified <tt>key</tt> to the specified
     * <tt>value</tt> in this table. Neither the key nor the
     * value can be <tt>null</tt>. 
     *
     * <p> The value can be retrieved by calling the <tt>get</tt> method
     * with a key that is equal to the original key.
     *
     * @param      key     the table key.
     * @param      value   the value.
     * @return     the previous value of the specified key in this table,
     *             or <tt>null</tt> if it did not have one.
     * @throws  NullPointerException  if the key or value is
     *               <tt>null</tt>.
     */
    public ConcurrentHashMap put (K key, V value) 
    {
        uint hash = hash(key);
        segmentFor(hash).put(key, hash, value, false);
	return this;
    }

    /**
     * If the specified key is not already associated
     * with a value, associate it with the given value.
     * This is equivalent to
     * <pre>
     *   if (!map.containsKey(key)) 
     *      return map.put(key, value);
     *   else
     *      return map.get(key);
     * </pre>
     * Except that the action is performed atomically.
     * @param key key with which the specified value is to be associated.
     * @param value value to be associated with the specified key.
     * @return previous value associated with specified key, or <tt>null</tt>
     *         if there was no mapping for key. 
     * @throws NullPointerException if the specified key or value is
     *            <tt>null</tt>.
     */
    public ConcurrentHashMap putIfAbsent (K key, V value) 
    {
        uint hash = hash(key);
        segmentFor(hash).put(key, hash, value, true);
	return this;
    }


    /**
     * Removes the key (and its corresponding value) from this
     * table. This method does nothing if the key is not in the table.
     *
     * @param   key   the key that needs to be removed.
     * @return  the value to which the key had been mapped in this table,
     *          or <tt>null</tt> if the key did not have a mapping.
     * @throws  NullPointerException  if the key is
     *               <tt>null</tt>.
     */
    public ConcurrentHashMap remove (K key) 
    {
      	uint hash = hash(key);
        segmentFor(hash).remove(key, hash);
	return this;
    }


    public ConcurrentHashMap remove (K key, inout V value) 
    {
        uint hash = hash(key);
        value = segmentFor(hash).remove(key, hash);
	return this;
    }

    /**
     * Replace entry for key only if currently mapped to some value.
     * Acts as
     * <pre> 
     *  if ((map.containsKey(key)) {
     *     return map.put(key, value);
     * } else return null;
     * </pre>
     * except that the action is performed atomically.
     * @param key key with which the specified value is associated.
     * @param value value to be associated with the specified key.
     * @return previous value associated with specified key, or <tt>null</tt>
     *         if there was no mapping for key.  
     * @throws NullPointerException if the specified key or value is
     *            <tt>null</tt>.
     */
    public ConcurrentHashMap replace (K key, V value) 
    {
        uint hash = hash(key);
        segmentFor(hash).replace(key, hash, value);
	return this;
    }


    /**
     * Removes all mappings from this map.
     */
    public ConcurrentHashMap clear () 
    {
        for (int i = 0; i < segments.length; ++i)
             segments[i].clear();
	return this;
    }


    public MutableMapIterator!(K,V) iterator()
    {
      return new HashIterator(this);
    }

    /**
     * Returns an enumeration of the keys in this table.
     *
     * @return  an enumeration of the keys in this table.
     * @see     #keySet
     */
    public MutableIterator!(K) keyIterator () 
    {
        return new KeyIterator (this);
    }
    public alias keyIterator keys;

    /**
     * Returns an enumeration of the values in this table.
     *
     * @return  an enumeration of the values in this table.
     * @see     #values
     */
    public Iterator!(V) valueIterator () 
    {
        return new ValueIterator (this);
    }
    public alias valueIterator elements;

        /**********************************************************************

                Iterate over all keys in hashmap

        **********************************************************************/

        int opApply (int delegate(inout K) dg)
        {
                int result = 0;
                Iterator!(K) iterator = keyIterator();

                while (iterator.hasNext)
                      {
			K key = iterator.next();
			  if ((result = dg (key)) != 0) break;
                      }
                return result;
        }

        /**********************************************************************

                Iterate over all keys in hashmap

        **********************************************************************/

        int opApply (int delegate(inout K, inout V) dg)
        {
                int result = 0;
                MapIterator!(K,V) iterator = iterator ();
		
                while (iterator.hasNext)
		  {
		    K key;
		    V value;
		    iterator.next(key, value);
		    if ((result = dg (key, value)) != 0)
		      break;
		  }
                return result;
        }

    public int size() {
      int ret = 0;
      foreach (Segment segment; segments) {
	ret += segment.count;
      }
      return ret;
    }
	
    public override uint toHash() {
      uint ret = 0;
      foreach (Segment s; segments) {
	ret += s.toHash();
      }
      return ret;
    }
    
    public Set!(K) keySet() {
      return new HashSet!(K,V)(this);
    }

    /*
    Creates a new set- avoid using if possible
   */
    public Set!(V) valueSet() {
      HashSet!(V) ret = new HashSet!(V)(size());
      foreach(K key, V value; this) {
	ret.add(value);
      }
      return ret;
    }

    public ConcurrentHashMap dup() {
      ConcurrentHashMap ret = new ConcurrentHashMap(size());
      foreach(K key, V value; this) {
	ret.put(key,value);
      }
      return ret;
    }


    /* ---------------- Iterator Support -------------- */

    static class HashIterator: MutableMapIterator!(K,V)
    {
        int nextSegmentIndex;
        int nextTableIndex;
        HashEntry[] currentTable;
        HashEntry nextEntry;
        HashEntry lastReturned;
        ConcurrentHashMap   map;

        this (ConcurrentHashMap map) 
        {
            this.map = map;
            nextSegmentIndex = map.segments.length - 1;
            nextTableIndex = -1;
            advance();
        }

        final void advance () 
        {
            if (nextEntry !is null && (nextEntry = nextEntry.next) !is null)
                return;

            while (nextTableIndex >= 0) 
                  {
                  if ( (nextEntry = currentTable[nextTableIndex--]) !is null)
                        return;
                  }

            while (nextSegmentIndex >= 0) 
                  {
                  Segment seg = map.segments[nextSegmentIndex--];
                  volatile if (seg.count) 
                     {
                     currentTable = seg.table;
                     for (int j = currentTable.length - 1; j >= 0; --j) 
                         {
                         if ((nextEntry = currentTable[j]) !is null) 
                            {
                            nextTableIndex = j - 1;
                            return;
                            }
                         }
                     }
                  }
        }

        public bit hasNext () 
        { 
            return cast(bit)(nextEntry !is null); 
        }

        HashEntry nextElement () 
        {
            if (nextEntry is null)
                throw new Exception ("no such element in HashMap");

            lastReturned = nextEntry;
            advance ();
            return lastReturned;
        }

	public void next(out K key, out V value) {
	  HashEntry he = nextElement();
	  key = he.key;
	  value = he.value;
	}

	public void remove() {
	  if (lastReturned is null) {
	    throw new BoundsException("Must call next() before remove()");
	  }
	  map.segmentFor(lastReturned.hash).remove(lastReturned.key, lastReturned.hash);
	}
    }

    static class KeyIterator : HashIterator, MutableIterator!(K) 
    {
        this (ConcurrentHashMap map) {super (map);}
	K last;

	public bit hasNext() {
	  return super.hasNext();
	}
        public K next() { 
	  last = super.nextElement().key;
	  return last;
	}
	public void remove() {
	  map.remove(last);
	}
    }

    static class ValueIterator : HashIterator, Iterator!(V)
    {
        this (ConcurrentHashMap map) {super (map);}
	public bit hasNext() {
	  return super.hasNext();
	}
        public V next() { volatile return super.nextElement().value; }
    }

}

class ConcurrentHashMap (K,V, alias Equals, alias Cmp, alias Hash): mango.containers.ConcurrentHashMap.ConcurrentHashMap!(K,V) {
  public this (uint initialCapacity, float loadFactor, uint concurrencyLevel) {
    super(initialCapacity, loadFactor, concurrencyLevel);
  }

  public this (uint initialCapacity) {
    super(initialCapacity);
  }

  public this () {
    super();
  }

  public int equals(K a, K b) {
    return Equals(a,b);
  }
  
  public int cmp(K a, K b) {
    return Cmp(a,b);
  }
    
  public uint hash(K k) {
    return Hash(k);
  }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
