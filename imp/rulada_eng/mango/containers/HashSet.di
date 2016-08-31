/*******************************************************************************

        @file HashSet.d

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

module mango.containers.HashSet;

private import mango.containers.Iterator;
private import mango.containers.Container;
private import mango.containers.Set;
private import mango.containers.HashMap;
private import mango.containers.Map;
private import mango.containers.Util;

public class HashSet(V, D=ubyte): AbstractMutableSet!(V) {
  private MutableMap!(V,D) myMap;

  public this(int initSize=-1) {
    if (initSize > 0) {
      myMap = new HashMap!(V,D)(initSize);
    } else {
      myMap = new HashMap!(V,D)();
    }
  }

  package this(MutableMap!(V, D) map) {
    myMap = map;
  }

  public int size() {
    return myMap.size();
  }

  public bit contains(V item) {
    return myMap.containsKey(item);
  }

  public bit isThreadSafe() {
    return myMap.isThreadSafe();
  }

  public HashSet clear() {
    myMap.clear();
    return this;
  }
  
  public HashSet add(V item) {
    myMap.put(item, D.init);
    return this;
  }

  public HashSet remove(V item) {
    myMap.remove(item);
    return this;
  }

  public HashSet dup() {
    return new HashSet(myMap.dup());
  }

  public MutableIterator!(V) iterator() {
    return myMap.keyIterator();
  }

  public override int opEquals(Object o) {
    Set!(V) s = cast(Set!(V))o;
    assert(s);
    Iterator!(V) iter = s.iterator();
    while (iter.hasNext()) {
      if (!contains(iter.next)) {
	return false;
      }
    }
    return true;
  }

  public override uint toHash() {
    return myMap.toHash() + 5;  //+5 to differentiate from maps
  }
}

version (build) {
    debug {
        pragma(link, "mango");
    } else {
        pragma(link, "mango");
    }
}
