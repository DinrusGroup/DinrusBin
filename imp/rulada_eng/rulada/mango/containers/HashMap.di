/*******************************************************************************

        @file HashMap.d

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

module mango.containers.HashMap;

private import mango.containers.Iterator;
private import mango.containers.Container;
private import mango.containers.Set;
private import mango.containers.HashSet;
private import mango.containers.Map;
private import mango.containers.Util;

private import mango.io.Stdout;

public class HashMap(K,V): AbstractMutableMap!(K,V) {
  private struct Node {
    K key;
    V value;
    Node* next;
  }

  private int items;
  private Node*[] array;

  private class HashMapIterator: MutableMapIterator!(K,V) {
    Node* node;
    K lastKey;
    int location;

    public this() {
      location = -1;
      advance();
    }

    private void advance() {
      if (node is null || node.next is null) {
	node = null;
	while (++location < array.length) {
	  if (array[location] !is null) {
	    node = array[location];
	    break;
	  }
	}
      } else {
	node = node.next;
      }
    }

    public bit hasNext() {
      return cast(bit)(node !is null);
    }

    public void next(out K key, out V value) {
      if (node is null) {
	throw new BoundsException("Nothing left in iterator");
      }
      key = node.key;
      lastKey = node.key;
      value = node.value;
      advance();
    }

    public void remove() {
      .HashMap!(K,V).remove(lastKey);
    }
  }

  private class HashMapKeyIterator: MutableIterator!(K) {
    Node* node;
    Node* last;
    int location;

    public this() {
      location=-1;
      advance();
    }

    private void advance() {
      if (node is null || node.next is null) {
	node = null;
	while (++location < array.length) {
	  if (array[location] !is null) {
	    node = array[location];
	    break;
	  }
	}
      } else {
	node = node.next;
      }
    }

    public bit hasNext() {
      return cast(bit)(node !is null);
    }

    public K next() {
      if (node is null) {
	throw new BoundsException("Nothing left in iterator");
      }
      K ret = node.key;
      last = node;
      advance();
      return ret;
    }

    public void remove() {
      if (last is null) {
	throw new BoundsException("Must call next() before remove()");
      }
      .HashMap!(K,V).remove(last.key);
      last = null;
    }
  }

  private class HashMapValueIterator: Iterator!(V) {
    Node* node;
    int location;

    public this() {
      location = -1;
      advance();
    }

    private void advance() {
      if (node is null || node.next is null) {
	node = null;
	while (++location < array.length) {
	  if (array[location] !is null) {
	    node = array[location];
	    break;
	  }
	}
      } else {
	node = node.next;
      }
    }

    public bit hasNext() {
      return cast(bit)(node !is null);
    }

    public V next() {
      if (node is null) {
	throw new BoundsException("Nothing left in iterator");
      }
      V ret = node.value;
      advance();
      return ret;
    }
  }

  public this(int initSize) {
    items = 0;
    array = new Node*[initSize];
  }

  public this() {
    this(5);
  }

  public this(Map!(K,V) map) {
    this(map.size());
    MapIterator!(K,V) iter = map.iterator();
    while (iter.hasNext()) {
      K key; V value;
      iter.next(key, value);
      put(key, value);
    }
  }

  private uint loc(K key) {
    return hash(key)%array.length;
  }
  
  private Node* getNode(K key) {
    Node* node = array[loc(key)];
    while (node !is null) {
      if (equals(node.key,key)) {
	break;
      } else {
	node = node.next;
      }
    }
    return node;
  }

  private void addNode(Node* node) {
    if (items >= array.length) {
      rehash();
    }
    uint l = loc(node.key);
    node.next = array[l];
    array[l] = node;
    items++;
  }

  public void rehash(int toSize=-1) {
    //Stdout("Before rehash...")(CR);
    //dump();
    Node*[] oldArray = array;
    if (toSize == -1) {
      toSize = oldArray.length*2;
    }
    array = new Node*[toSize];
    int oldItems = items;
    items = 0;
    for (int i=0; i<oldArray.length; i++) {
      Node* node = oldArray[i];
      while (node !is null) {
	uint l = loc(node.key);
	Node* next = node.next;
	node.next = array[l];
	array[l] = node;
	items++;
	node = next;
      }
    }
    //Stdout("After rehash...")(CR);
    //dump();
    assert(oldItems == items);
  }

  private void dump() {
    for (int i=0; i<array.length; i++) {
      Stdout("array["c)(i)("]"c)(CR);
      Node* node = array[i];
      if (node is null) {
	Stdout("\t(null)"c)(CR);
      }
      while (node !is null) {
	Stdout("\t"c)(hash(node.key))(CR);
	node = node.next;
      }
    }
  }

  public V get(K key) {
    Node* node = getNode(key);    
    if (node is null) {
      return V.init;
    } else {
      return node.value;
    }
  }

  public bit isThreadSafe() {
    return false;
  }

  public HashMap dup() {
    return new HashMap(this);
  }
  
  public int size() {
    return items;
  }

  public override uint toHash() {
    uint ret = 0;
    Iterator!(K) iter = keyIterator();
    while (iter.hasNext()) {
      ret += hash(iter.next());
    }
    return ret;
  }

  public MutableMapIterator!(K,V) iterator() {
    return new HashMapIterator();
  }
  
  public Iterator!(V) valueIterator() {
    return new HashMapValueIterator();
  }

  public MutableIterator!(K) keyIterator() {
    return new HashMapKeyIterator();
  }

  public Set!(K) keySet() {
    return new HashSet!(K,V)(this);
  }

  /*
    Creates a new set- avoid using if possible
   */
  public Set!(V) valueSet() {
    HashSet!(V) set = new HashSet!(V)(this.size());
    Iterator!(V) iter = valueIterator();
    while (iter.hasNext()) {
      set.add(iter.next());
    }
    return set;
  }

  public bit containsKey(K key) {
    return cast(bit)(getNode(key) !is null);
  }

  public HashMap put(K key, V value) {
    //Stdout("Map: ")(cast(int)&this)(" Put: ")(hash(key))(" Loc: ")(loc(key))(CR);
    Node* node = getNode(key);
    if (node is null) {
      node = new Node;
      node.key = key;
      node.value = value;
      addNode(node);
    } else {
      node.value = value;
    }
    return this;
  }

  public HashMap opIndexAssign(V value, K key) {
    return put(key, value);
  }

  public HashMap remove(K key, inout V value) {
    //Stdout("Remove: ")(hash(key))(CR);
    Node** node = &array[loc(key)];
    while (*node !is null) {
      if (equals((*node).key,key)) {
	value = (*node).value;
	*node = (*node).next;
	items--;
	return this;
      }
      node = &(*node).next;
    }
    throw new Exception("Item not found");
  }

  public HashMap remove(K key) {
    V value;
    return remove(key, value);
  }

  public HashMap clear() {
    array = new Node*[items];
    items = 0;
    return this;
  }
}

class HashMap(K,V, alias Equals, alias Cmp, alias Hash): mango.containers.HashMap.HashMap!(K,V) {
  public this(int initSize) {
    super(initSize);
  }

  public this() {
    super();
  }

  public this(Map!(K,V) map) {
    super(map);
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
