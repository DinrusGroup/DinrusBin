/*******************************************************************************

        @file Map.d

        Copyright (c) 2005 John Demme
        
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

      
        @version        Initial version, June 2005
        @author         John Demme (me@teqdruid.com)


*******************************************************************************/

module mango.containers.Map;

private import mango.containers.Set;
private import mango.containers.Iterator;
private import mango.containers.Util;

public abstract class Map(K,V) {
	public abstract V get(K key);
	public alias get opIndex;

	public abstract bit isThreadSafe();
	public abstract Map dup();

	public abstract int size();

	public abstract override int opEquals(Object o);
	public abstract override uint toHash();

	public abstract Iterator!(V) valueIterator();
	public abstract Iterator!(K) keyIterator();
	public abstract MapIterator!(K,V) iterator();

	public abstract Set!(K) keySet();
	public abstract Set!(V) valueSet();

	public abstract bit containsKey(K key);
	public abstract bit containsValue(V value);

	public int opApply(int delegate(inout K, inout V) dg);

	
	/**********************************************************************
	  Comparison operators for the elements
	***********************************************************************/
	public abstract int equals(K a, K b);
	public abstract int cmp(K a, K b);
	public abstract uint hash(K k);
}

public class AbstractMap(K,V): Map!(K,V) {
  	public bit containsValue(V value) {
    		Iterator!(V) iter = valueIterator();
		while (iter.hasNext()) {
		  if (value == iter.next()) {
		    return true;
		  }
		}
		return false;
	}

	
	public override int opEquals(Object o) {
	  	Map!(K,V) map = cast(Map!(K,V))o;
		if (map is null) {
			assert(false); //Map is only comparable to other Maps
		}
		
		MapIterator!(K,V) iter = map.iterator();
		int count;
		while (iter.hasNext()) {
			K key; V value;
			iter.next(key, value);
			if (Util!(V).equals(value, get(key)) == false) {
				return false;
			}
			count++;
		}
		return (count == size);
	}

	public int equals(K a, K b) {
		return Util!(K).equals(a,b);
	}
	
	public int cmp(K a, K b) {
		return Util!(K).cmp(a,b);
	}
	
	public uint hash(K k) {
		return Util!(K).hash(k);
	}


	int opApply(int delegate(inout K, inout V) dg) {
		MapIterator!(K,V) iter = iterator();
		while (iter.hasNext()) {
			V v; K k;
			iter.next(k,v);
			if (dg(k,v) != 0)
			 	return -1;
		}
		return 0;
	}	
}

public abstract class MutableMap(K,V): AbstractMap!(K,V) {
	public abstract MutableMap put(K key, V value);
	public abstract MutableMap opIndexAssign(V value, K key);

       /***********************************************************************
        
                Removes everything in the container

       ************************************************************************/
	public abstract MutableMap clear();

	public abstract MutableMap remove(K key);

	public abstract MutableMap remove(K key, inout V Value);

	public abstract MutableMap dup();

	public abstract MutableIterator!(K) keyIterator();

	public abstract MutableMapIterator!(K,V) iterator();
}

public class AbstractMutableMap(K,V): MutableMap!(K,V) {
	public MutableMap!(K,V) opIndexAssign(V value, K key) {
		return put(key,value);
	}

	public MutableMap!(K,V) remove(K key) {
		V value;
		return MutableMap!(K,V).remove(key,value);
	}
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
