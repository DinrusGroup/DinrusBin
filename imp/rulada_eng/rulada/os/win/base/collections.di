/**
 * Copyright: (c) 2009 John Chapman
 *
 * License: See $(LINK2 ..\..\licence.txt, licence.txt) for use and distribution terms.
 */
module os.win.base.collections;

import os.win.base.core,
  os.win.loc.core,
  std.math;
import std.c : memmove, memset;

alias EqualityComparison СравнениеНаРавенство;
alias Comparison Сравнение;
alias Predicate Предикат;
alias Converter Преобразователь;
alias Action Действие;
alias IEqualityComparer ИСравнивательНаРавенство;
alias EqualityComparer СравнивательНаРавенство;
alias IComparer ИСравниватель;
alias Comparer Сравниватель;
alias sort сортируй;
alias binarySearch бинарныйПоиск;
alias reverse реверсни;
alias copy копируй;
alias clear сотри;
alias convertAll преобразуйВсе;
alias IEnumerable ИПеречислимый;
alias ICollection ИПодборка;
alias IList ИСписок;
alias List Список;
alias ReadOnlyList СписокТолькоДляЧтения;
alias Collection Подборка;
alias getPrime дайПрайм;
alias KeyNotFoundException ИсклКлючНеНайден;
alias KeyValuePair ПараКлючЗначение;
alias IDictionary ИСловарь;
alias Dictionary Словарь;
alias Queue Очередь;
alias SortedList СортированныйСписок;


/**
 * <code>bool delegate(T a, T b)</code>
 */

template EqualityComparison(T) {
  alias bool delegate(T a, T b) EqualityComparison;
}

/**
 * <code>int delegate(T a, T b)</code>
 */
template Comparison(T) {
  alias int delegate(T a, T b) Comparison;
}

/**
 * <code>bool delegate(T obj)</code>
 */
template Predicate(T) {
  alias bool delegate(T) Predicate;
}

/**
 * <code>TOutput delegate(TInput input)</code>
 */
template Converter(TInput, TOutput) {
  alias TOutput delegate(TInput) Converter;
}

/**
 * <code>void delegate(T obj)</code>
 */
template Action(T) {
  alias void delegate(T obj) Action;
}

private bool equalityComparisonImpl(T)(T a, T b) {
  static if (is(T == class) || is(T == interface)) {
    if (a !is null) {
      if (b !is null) {
        static if (is(typeof(T.opEquals))) {
          return cast(bool)a.opEquals(b);
        }
        else {
          return cast(bool)typeid(T).equals(&a, &b);
        }
      }
      return false;
    }
    if (b !is null) {
      return false;
    }
    return true;
  }
  else static if (is(T == struct)) {
    static if (is(T.opEquals)) {
      return cast(bool)a.opEquals(b);
    }
    else {
      return cast(bool)typeid(T).equals(&a, &b);
    }
  }
  else {
    return cast(bool)typeid(T).equals(&a, &b);
  }
}

private int comparisonImpl(T)(T a, T b) {
  static if (is(T : string)) {
    return Culture.current.collator.compare(a, b);
  }
  else static if (is(T == class) || is(T == interface)) {
    if (a !is b) {
      if (a !is null) {
        if (b !is null) {
          static if (is(typeof(T.opCmp))) {
            return a.opCmp(b);
          }
          else {
            return typeid(T).compare(&a, &b);
          }
        }
        return 1;
      }
      return -1;
    }
    return 0;
  }
  else static if (is(T == struct)) {
    static if (is(typeof(T.opCmp))) {
      return a.opCmp(b);
    }
    else {
      return typeid(T).compare(&a, &b);
    }
  }
  else {
    return typeid(T).compare(&a, &b);
  }
}

interface IEqualityComparer(T) {

alias equals равны_ли;
alias getHash дайХэш;

  bool equals(T a, T b);
  uint getHash(T value);

}

abstract class EqualityComparer(T) : IEqualityComparer!(T) {

alias instance экземпляр;
alias equals равны_ли;
alias getHash дайХэш;

  static EqualityComparer instance();
  abstract bool equals(T a, T b);
  abstract uint getHash(T value);

}

interface IComparer(T) {

alias compare сравни;

  int compare(T a, T b);

}


abstract class Comparer(T) : IComparer!(T) {

alias instance экземпляр;
alias compare сравни;

  static Comparer instance() ;

  abstract int compare(T a, T b);

void sort(T, TIndex = int, TLength = TIndex)(T[] array, TIndex index, TLength length, int delegate(T, T) comparison = null) {

  void quickSortImpl(int left, int right) {
    if (left >= right)
      return;

    int i = left, j = right;
    T pivot = array[i + ((j - i) >> 1)];

    do {
      while (i < right && comparison(array[i], pivot) < 0)
        i++;
      while (j > left && comparison(pivot, array[j]) < 0)
        j--;

      assert(i >= left && j <= right);

      if (i <= j) {
        T temp = array[j];
        array[j] = array[i];
        array[i] = temp;

        i++;
        j--;
      }
    } while (i <= j);

    if (left < j)
      quickSortImpl(left, j);
    if (i < right)
      quickSortImpl(i, right);
  }

  if (comparison is null) {
    comparison = (T a, T b) {
      return comparisonImpl(a, b);
    };
  }

  quickSortImpl(index, index + length - 1);
}

/**
 */
void sort(T)(T[] array, int delegate(T, T) comparison = null) {
  .sort(array, 0, array.length, comparison);
}

int binarySearch(T, TIndex = int, TLength = TIndex)(T[] array, TIndex index, TLength length, T value, int delegate(T, T) comparison = null) {
  if (comparison is null) {
    comparison = (T a, T b) {
      return comparisonImpl(a, b);
    };
  }

  int lo = cast(int)index;
  int hi = cast(int)(index + length - 1);
  while (lo <= hi) {
    int i = lo + ((hi - lo) >> 1);
    int order = comparison(array[i], value);
    if (order == 0)
      return i;
    if (order < 0)
      lo = i + 1;
    else
      hi = i - 1;
  }
  return ~lo;
}

void reverse(T, TIndex = int, TLength = TIndex)(T[] array, TIndex index, TLength length) {
  auto i = index;
  auto j = index + length - 1;
  while (i < j) {
    T temp = array[i];
    array[i] = array[j];
    array[j] = temp;
    i++, j--;
  }
}

/**
 */
void copy(T, TIndex = int, TLength = TIndex)(T[] source, TIndex sourceIndex, T[] target, TIndex targetIndex, TLength length) {
  if (length > 0)
    memmove(target.ptr + targetIndex, source.ptr + sourceIndex, length * T.sizeof);
}

void clear(T, TIndex = int, TLength = IIndex)(T[] array, TIndex index, TLength length) {
  if (length > 0)
    memset(array.ptr + index, 0, length * T.sizeof);
}

TOutput[] convertAll(TInput, TOutput)(TInput[] array, Converter!(TInput, TOutput) converter) {
  auto ret = new TOutput[array.length];
  for (auto i = 0; i < array.length; i++) {
    ret[i] = converter(array[i]);
  }
  return ret;
}

interface IEnumerable(T) {
alias opApply опПрименить;

  version (UseRanges) {
  
   alias empty пуст_ли;
  alias popFront выкиньФронт;
  alias front фронт;
  
    bool empty();

    void popFront();

    T front();
  }
  else {
    int opApply(int delegate(ref T) action);
  }

}

/**
 * Defines methods to manipulate collections.
 */
interface ICollection(T) : IEnumerable!(T) {

alias add добавь;
alias remove удали;
alias contains содержит_ли;
alias clear сотри;
alias count посчитай;

  /**
   * Adds an _item to the collection.
   * Параметры: item = The object to _add.
   */
  void add(T item);

  /**
   * Removes the first occurence of the specified object from the collection.
   * Параметры: item = The object to _remove.
   * Возвращает: true if item was successfully removed; otherwise, false.
   */
  bool remove(T item);

  /**
   * Determines whether the collection _contains the specified object.
   * Параметры: item = The object to locate.
   * Возвращает: true if item was found; otherwise, false.
   */
  bool contains(T item);

  /**
   * Removes all items from the collection.
   */
  void clear();

  /**
   * $(I Property.) Gets the number of elements in the collection.
   */
  int count();

}

/**
 * Represents a collection of objects that can be accessed by index.
 */
interface IList(T) : ICollection!(T) {

alias indexOf индексУ;
alias insert вставь;
alias removeAt удалиУ;
alias opIndexAssign опПрисвоитьИндекс;
alias opIndex опИндекс;

  int indexOf(T item);

  /**
   * Inserts an _item at the specified _index.
   * Параметры:
   *   index = The _index at which item should be inserted.
   *   item = The object to insert.
   */
  void insert(int index, T item);

  /**
   * Removes the item at the specified _index.
   * Параметры: index = The _index of the item to remove.
   */
  void removeAt(int index);

  /**
   * Gets or sets the object at the specified _index.
   * Параметры:
   *   value = The item at the specified _index.
   *   index = The _index of the item to get or set.
   */
  void opIndexAssign(T value, int index);

  /**
   * ditto
   */
  T opIndex(int index);

}

/**
 * Represents a list of elements that can be accessed by index.
 */
class List(T) : IList!(T) {

alias add добавь;
alias addRange добавьОхват;
alias insert вставь;
alias insertRange вставьОхват;
alias remove удали;
alias removeAt удалиУ;
alias removeRange удалиОхват;
alias contains содержит_ли;
alias clear сотри;
alias indexOf индексУ;
alias lastIndexOf последнийИндексУ;
alias sort сортируй;
alias binarySearch бинарныйПоиск;
alias copyTo копируйВ;
alias toArray вМассив;
alias find найди;
alias findLast найдиПоследний;
alias findAll найдиВсе;
alias findIndex найдиИндекс;
alias findLastIndex найдиПоследнийИндекс;
alias exists есть_ли;
alias forEach дляКаждого;
alias trueForAll верноДляВсех;
alias getRange дайОхват;
alias convert преобразуй;
alias count посчитай;
alias capacity объём;
alias opIndexAssign опПрисвоитьИндекс;
alias opIndex опИндекс;

  private const int DEFAULT_CAPACITY = 4;

  private T[] items_;
  private int size_;

  private int index_;

  /**
   * Initializes a new instance with the specified _capacity.
   * Параметры: capacity = The number of elements the new list can store.
   */
  this(int capacity = 0) {
    items_.length = capacity;
  }

  /**
   * Initializes a new instance containing elements copied from the specified _range.
   * Параметры: range = The _range whose elements are copied to the new list.
   */
  this(T[] range) {
    items_.length = size_ = range.length;
    items_ = range;
  }

  /**
   * ditto
   */
  this(IEnumerable!(T) range) {
    items_.length = DEFAULT_CAPACITY;
    foreach (item; range)
      add(item);
  }

  /**
   * Adds an element to the end of the list.
   * Параметры: item = The element to be added.
   */
  final void add(T item) ;
  /**
   * Adds the elements in the specified _range to the end of the list.
   * Параметры: The _range whose elements are to be added.
   */
  final void addRange(T[] range) ;

  /**
   * ditto
   */
  final void addRange(IEnumerable!(T) range) ;

  /**
   * Inserts an element into the list at the specified _index.
   * Параметры:
   *   index = The _index at which item should be inserted.
   *   item = The element to insert.
   */
  final void insert(int index, T item);
  /**
   * Inserts the elements of a _range into the list at the specified _index.
   * Параметры:
   *   index = The _index at which the new elements should be inserted.
   *   range = The _range whose elements should be inserted into the list.
   */
  final void insertRange(int index, T[] range);

  /**
   * ditto
   */
  final void insertRange(int index, IEnumerable!(T) range);

  /**
   */
  final bool remove(T item);

  final void removeAt(int index);

  /**
   */
  final void removeRange(int index, int count);

  /**
   */
  final bool contains(T item) ;

  /**
   */
  final void clear();

  /**
   */
  final int indexOf(T item);
  /**
   */
  final int indexOf(T item, EqualityComparison!(T) comparison);
  /**
   */
  final int lastIndexOf(T item, EqualityComparison!(T) comparison = null);

  /**
   */
  final void sort(Comparison!(T) comparison = null) ;
  /**
   */
  final int binarySearch(T item, Comparison!(T) comparison = null);

  /**
   */
  final void copyTo(T[] array);
  /**
   */
  final T[] toArray();

  /**
   */
  final T find(Predicate!(T) match);

  /**
   */
  final T findLast(Predicate!(T) match);

  /**
   */
  final List findAll(Predicate!(T) match);
  /**
   */
  final int findIndex(Predicate!(T) match) ;

  /**
   */
  final int findLastIndex(Predicate!(T) match);
  /**
   */
  final bool exists(Predicate!(T) match);
  /**
   */
  final void forEach(Action!(T) action) ;

  /**
   */
  final bool trueForAll(Predicate!(T) match);
  /**
   */
  final List!(T) getRange(int index, int count) ;

  /**
   */
  final List!(TOutput) convert(TOutput)(Converter!(T, TOutput) converter);

  final int count() ;

  final void capacity(int value) ;

  final void opIndexAssign(T value, int index);
  
  final T opIndex(int index) ;
  
  version (UseRanges) {
  alias empty пуст_ли;
  alias popFront выкиньФронт;
  alias front фронт;
  
    final bool empty() ;

    final void popFront() ;
	
    final T front();

    /**
     * Ditto
     */
    final int opApply(int delegate(ref int, ref T) action);
  }

  final bool opIn_r(T item) ;
  
  private void ensureCapacity(int min) ;

}

/**
 */
class ReadOnlyList(T) : IList!(T) {

alias indexOf индексУ;
alias contains содержит_ли;
alias clear сотри;
alias count посчитай;
alias opIndex опИндекс;
alias add добавь;
alias insert вставь;
alias remove удали;
alias removeAt удалиУ;
alias list список;
alias opIndexAssign опПрисвоитьИндекс;
alias opApply опПрименить;

  private List!(T) list_;

  this(List!(T) list) {
    list_ = list;
  }

  final int indexOf(T item) {
    return list_.indexOf(item);
  }

  final bool contains(T item) {
    return list_.contains(item);
  }

  final void clear() {
    list_.clear();
  }

  final int count() {
    return list_.count;
  }

  final T opIndex(int index) {
    return list_[index];
  }

  version (UseRanges) {
  
  alias empty пуст_ли;
  alias popFront выкиньФронт;
  alias front фронт;
  
    final bool empty() {
      return list_.empty;
    }

    final void popFront() {
      list_.popFront();
    }

    final T front() {
      return list_.front;
    }
  }
  else {
    final int opApply(int delegate(ref T) action) {
      return list_.opApply(action);
    }
  }

  protected void add(T item) {
    throw new NotSupportedException;
  }

  protected void insert(int index, T item) {
    throw new NotSupportedException;
  }

  protected bool remove(T item) {
    throw new NotSupportedException;
  }

  protected void removeAt(int index) {
    throw new NotSupportedException;
  }

  protected void opIndexAssign(T item, int index) {
    throw new NotSupportedException;
  }

  protected final IList!(T) list() {
    return list_;
  }

}

class Collection(T) : IList!(T) {

alias add добавь;
alias insert вставь;
alias remove удали;
alias removeAt удалиУ;
alias clear сотри;
alias indexOf индексУ;
alias contains содержит_ли;
alias count посчитай;
alias opIndexAssign опПрисвоитьИндекс;
alias opIndex опИндекс;
alias opApply опПрименить;

  private IList!(T) items_;

  this() {
    this(new List!(T));
  }

  this(IList!(T) list) {
    items_ = list;
  }

  final void add(T item) {
    insertItem(items_.count, item);
  }

  final void insert(int index, T item) {
    insertItem(index, item);
  }

  final bool remove(T item) {
    int index = items_.indexOf(item);
    if (index < 0)
      return false;
    removeItem(index);
    return true;
  }

  final void removeAt(int index) {
    removeItem(index);
  }

  final void clear() {
    clearItems();
  }

  final int indexOf(T item) {
    return items_.indexOf(item);
  }

  final bool contains(T item) {
    return items_.contains(item);
  }

  final int count() {
    return items_.count;
  }

  final void opIndexAssign(T value, int index) {
    setItem(index, value);
  }
  final T opIndex(int index) {
    return items_[index];
  }

  version (UseRanges) {
  
  alias empty пуст_ли;
  alias popFront выкиньФронт;
  alias front фронт;
  
    final bool empty() {
      return items_.empty;
    }

    final void popFront() {
      items_.popFront();
    }

    final T front() {
      return items_.front;
    }
  }
  else {
    final int opApply(int delegate(ref T) action) {
      return items_.opApply(action);
    }
  }

  protected void insertItem(int index, T item) {
    items_.insert(index, item);
  }

  protected void removeItem(int index) {
    items_.removeAt(index);
  }

  protected void clearItems() {
    items_.clear();
  }

  protected void setItem(int index, T value) {
    items_[index] = value;
  }

  protected IList!(T) items() {
    return items_;
  }

}

private const int[] PRIMES = [ 
  3, 7, 11, 17, 23, 29, 37, 47, 59, 71, 89, 107, 131, 163, 197, 239, 293, 353, 431, 521, 631, 761, 919, 
  1103, 1327, 1597, 1931, 2333, 2801, 3371, 4049, 4861, 5839, 7013, 8419, 10103, 12143, 14591, 
  17519, 21023, 25229, 30293, 36353, 43627, 52361, 62851, 75431, 90523, 108631, 130363, 156437, 
  187751, 225307, 270371, 324449, 389357, 467237, 560689, 672827, 807403, 968897, 1162687, 1395263, 
  1674319, 2009191, 2411033, 2893249, 3471899, 4166287, 4999559, 5999471, 7199369 ];

private int getPrime(int min) {
  
  bool isPrime(int candidate) {
    if ((candidate & 1) == 0)
      return candidate == 2;

    int limit = cast(int).sqrt(cast(double)candidate);
    for (int div = 3; div <= limit; div += 2) {
      if ((candidate % div) == 0)
        return false;
    }

    return true;
  }

  foreach (p; PRIMES) {
    if (p >= min)
      return p;
  }

  for (int p = min | 1; p < int.max; p += 2) {
    if (isPrime(p))
      return p;
  }

  return min;
}

/**
 */
class KeyNotFoundException : Exception {

  this(string message = "The key was not present.") {
    super(message);
  }

}

/**
 */
struct KeyValuePair(K, V) {
alias key ключ;
alias value значение;
  /**
   */
  K key;
  /**
   */
  V value;

}

/**
 */
interface IDictionary(K, V) : ICollection!(KeyValuePair!(K, V)) {
alias add добавь;
alias containsKey содержитКлюч_ли;
alias remove удали;
alias tryGetValue пробуйДатьЗначение;
alias opIndexAssign опПрисвоитьИндекс;
alias opIndex опИндекс;
alias keys ключи;
alias values значения;

  /**
   */
  void add(K key, V value);

  /**
   */
  bool containsKey(K key);

  /**
   */
  bool remove(K key);

  /**
   */
  bool tryGetValue(K key, out V value);

  /**
   */
  void opIndexAssign(V value, K key);
  /**
   * ditto
   */
  V opIndex(K key);

  /**
   */
  ICollection!(K) keys();

  /**
   */
  ICollection!(V) values();

}

/**
 */
class Dictionary(K, V) : IDictionary!(K, V) {

alias KeyCollection ПодборкаКлючей;
alias ValueCollection ПодборкаЗначений;
alias add добавь;
alias containsKey содержитКлюч_ли;
alias containsValue содержитЗначение_ли;
alias remove удали;
alias clear сотри;
alias tryGetValue пробуйДатьЗначение;
alias keys ключи;
alias values значения;
alias count посчитай;
alias opIndexAssign опПрисвоитьИндекс;
alias opIndex опИндекс;
alias opApply опПрименить;
alias initialize инициализовать;
alias insert вставь;
alias increaseCapacity увеличьОбъём;
alias contains содержит_ли;
alias findEntry найдиЗапись;
alias Entry Запись;

  private struct Entry {
    int hash; // -1 if not used
    int next; // -1 if last
    K key;
    V value;
  }

  /**
   */
  class KeyCollection : ICollection!(K) {

  	alias count посчитай;
	alias add добавь;
	alias remove удали;
	alias clear сотри;
	alias contains содержит_ли;
	
    version (UseRanges) {
      private int currentIndex_;
    }

    /**
     */
    int count() {
      return this.outer.count;
    }

    version (UseRanges) {
	
	alias empty пуст_ли;
	alias popFront выкиньФронт;
	alias front фронт;
	
      bool empty() {
        bool result = (currentIndex_ == this.outer.count_);
        if (result)
          currentIndex_ = 0;
        return result;
      }

      void popFront() {
        currentIndex_++;
      }

      K front() {
        return this.outer.entries_[currentIndex_].key;
      }
    }
    else {
      int opApply(int delegate(ref K) action) {
        int r;

        for (int i = 0; i < this.outer.count_; i++) {
          if (this.outer.entries_[i].hash >= 0) {
            if ((r = action(this.outer.entries_[i].key)) != 0)
              break;
          }
        }

        return r;
      }
    }

    protected void add(K item) {
    }

    protected void clear() {
    }

    protected bool contains(K item) {
      return false;
    }

    protected bool remove(K item) {
      return false;
    }

  }

  /**
   */
  class ValueCollection : ICollection!(V) {

  alias count посчитай;
	alias add добавь;
	alias remove удали;
	alias clear сотри;
	alias contains содержит_ли;
	
    version (UseRanges) {
      private int currentIndex_;
    }

    /**
     */
    int count() {
      return this.outer.count;
    }

    version (UseRanges) {
	alias empty пуст_ли;
	alias popFront выкиньФронт;
	alias front фронт;
	
      bool empty() {
        bool result = (currentIndex_ == this.outer.count_);
        if (result)
          currentIndex_ = 0;
        return result;
      }

      void popFront() {
        currentIndex_++;
      }

      V front() {
        return this.outer.entries_[currentIndex_].value;
      }
    }
    else {
      int opApply(int delegate(ref V) action) {
        int r;

        for (int i = 0; i < this.outer.count_; i++) {
          if (this.outer.entries_[i].hash >= 0) {
            if ((r = action(this.outer.entries_[i].value)) != 0)
              break;
          }
        }

        return r;
      }
    }

    protected void add(V item) {
    }

    protected void clear() {
    }

    protected bool contains(V item) {
      return false;
    }

    protected bool remove(V item) {
      return false;
    }

  }

  private const int BITMASK = 0x7FFFFFFF;

  private IEqualityComparer!(K) comparer_;
  private int[] buckets_;
  private Entry[] entries_;
  private int count_;
  private int freeList_;
  private int freeCount_;

  private KeyCollection keys_;
  private ValueCollection values_;

  version (UseRanges) {
    private int currentIndex_;
  }

  /**
   */
  this(int capacity = 0, IEqualityComparer!(K) comparer = null) {
    if (capacity > 0)
      initialize(capacity);
    if (comparer is null)
      comparer = EqualityComparer!(K).instance;
    comparer_ = comparer;
  }

  /**
   */
  this(IEqualityComparer!(K) comparer) {
    this(0, comparer);
  }

  /**
   */
  final void add(K key, V value) {
    insert(key, value, true);
  }

  /**
   */
  final bool containsKey(K key) {
    return (findEntry(key) >= 0);
  }

  /**
   */
  final bool containsValue(V value) {
    auto comparer = EqualityComparer!(V).instance;
    for (auto i = 0; i < count_; i++) {
      if (entries_[i].hash >= 0 && comparer.equals(entries_[i].value, value))
        return true;
    }
    return false;
  }

  /**
   */
  final bool remove(K key) {
    if (buckets_ != null) {
      int hash = comparer_.getHash(key) & BITMASK;
      int bucket = hash % buckets_.length;
      int last = -1;
      for (int i = buckets_[bucket]; i >= 0; last = i, i = entries_[i].next) {
        if (entries_[i].hash == hash && comparer_.equals(entries_[i].key, key)) {
          if (last < 0)
            buckets_[bucket] = entries_[i].next;
          else
            entries_[last].next = entries_[i].next;
          entries_[i].hash = i;
          entries_[i].next = freeList_;
          entries_[i].key = K.init;
          entries_[i].value = V.init;
          freeList_ = i;
          freeCount_++;
          return true;
        }
      }
    }
    return false;
  }

  /**
   */
  final void clear() {
    if (count_ != 0) {
      buckets_[] = -1;
      entries_[0 .. count_] = Entry.init;
      freeList_ = -1;
      count_ = freeCount_ = 0;
    }
  }

  /**
   */
  final bool tryGetValue(K key, out V value) {
    int index = findEntry(key);
    if (index >= 0) {
      value = entries_[index].value;
      return true;
    }
    value = V.init;
    return false;
  }

  /**
   */
  final KeyCollection keys() {
    if (keys_ is null)
      keys_ = new KeyCollection;
    return keys_;
  }

  /**
   */
  final ValueCollection values() {
    if (values_ is null)
      values_ = new ValueCollection;
    return values_;
  }

  /**
   */
  final int count() {
    return count_ - freeCount_;
  }

  /**
   */
  final void opIndexAssign(V value, K key) {
    insert(key, value, false);
  }
  /**
   * ditto
   */
  final V opIndex(K key) {
    int index = findEntry(key);
    if (index >= 0)
      return entries_[index].value;
    throw new KeyNotFoundException;
  }

  version (UseRanges) {
    final bool empty() {
      bool result = (currentIndex_ == count_);
      if (result)
        currentIndex_ = 0;
      return result;
    }

    final void popFront() {
      currentIndex_++;
    }

    final KeyValuePair!(K, V) front() {
      return KeyValuePair!(K, V)(entries_[currentIndex_].key, entries_[currentIndex_].value);
    }
  }
  else {
    final int opApply(int delegate(ref KeyValuePair!(K, V)) action) {
      int r;

      for (auto i = 0; i < count_; i++) {
        if (entries_[i].hash >= 0) {
          auto pair = KeyValuePair!(K, V)(entries_[i].key, entries_[i].value);
          if ((r = action(pair)) != 0)
            break;
        }
      }

      return r;
    }
  }

  private void initialize(int capacity) {
    buckets_.length = entries_.length = getPrime(capacity);
    buckets_[] = -1;
  }

  private void insert(K key, V value, bool add) {
    if (buckets_ == null)
      initialize(0);
    int hash = comparer_.getHash(key) & BITMASK;
    for (int i = buckets_[hash % $]; i >= 0; i = entries_[i].next) {
      if (entries_[i].hash == hash && comparer_.equals(entries_[i].key, key)) {
        entries_[i].value = value;
        return;
      }
    }

    int index;
    if (freeCount_ > 0) {
      index = freeList_;
      freeList_ = entries_[index].next;
      freeCount_--;
    }
    else {
      if (count_ == entries_.length)
        increaseCapacity();
      index = count_;
      count_++;
    }

    int bucket = hash % buckets_.length;
    entries_[index].hash = hash;
    entries_[index].next = buckets_[bucket];
    entries_[index].key = key;
    entries_[index].value = value;
    buckets_[bucket] = index;
  }

  private void increaseCapacity() {
    int newSize = getPrime(count_ * 2);
    int[] newBuckets = new int[newSize];
    Entry[] newEntries = new Entry[newSize];

    newBuckets[] = -1;
    newEntries = entries_;

    for (auto i = 0; i < count_; i++) {
      int bucket = newEntries[i].hash % newSize;
      newEntries[i].next = newBuckets[bucket];
      newBuckets[bucket] = i;
    }

    buckets_ = newBuckets;
    entries_ = newEntries;
  }

  private int findEntry(K key) {
    if (buckets_ != null) {
      int hash = comparer_.getHash(key) & BITMASK;
      for (int i = buckets_[hash % $]; i >= 0; i = entries_[i].next) {
        if (entries_[i].hash == hash && comparer_.equals(entries_[i].key, key))
          return i;
      }
    }
    return -1;
  }

  protected void add(KeyValuePair!(K, V) pair) {
    add(pair.key, pair.value);
  }

  protected bool remove(KeyValuePair!(K, V) pair) {
    int index = findEntry(pair.key);
    if (index >= 0 && EqualityComparer!(V).instance.equals(entries_[index].value, pair.value)) {
      remove(pair.key);
      return true;
    }
    return false;
  }

  protected bool contains(KeyValuePair!(K, V) pair) {
    int index = findEntry(pair.key);
    return index >= 0 && EqualityComparer!(V).instance.equals(entries_[index].value, pair.value);
  }

}

/**
 */
class Queue(T) : IEnumerable!(T) {
alias enqueue вочередь;
alias dequeue изочереди;
alias peek рассмотреть;
alias contains содержит_ли;
alias clear  сотри;
alias count посчитай;
alias opApply опПрименить;


  private const int DEFAULT_CAPACITY = 4;

  private T[] array_;
  private int head_;
  private int tail_;
  private int size_;

  version (UseRanges) {
    private int currentIndex_ = -2;
  }

  /**
   */
  this(int capacity = 0) {
    array_.length = capacity;
  }

  /**
   */
  this(T[] range) {
    array_.length = DEFAULT_CAPACITY;
    foreach (item; range) {
      enqueue(item);
    }
  }

  /**
   */
  this(IEnumerable!(T) range) {
    array_.length = DEFAULT_CAPACITY;
    foreach (item; range) {
      enqueue(item);
    }
  }

  /**
   */
  final void enqueue(T item) {
    if (size_ == array_.length) {
      int newCapacity = array_.length * 200 / 100;
      if (newCapacity < array_.length + 4)
        newCapacity = array_.length + 4;
      setCapacity(newCapacity);
    }

    array_[tail_] = item;
    tail_ = (tail_ + 1) % array_.length;
    size_++;
  }

  /**
   */
  final T dequeue() {
    T removed = array_[head_];
    array_[head_] = T.init;
    head_ = (head_ + 1) % array_.length;
    size_--;
    return removed;
  }

  /**
   */
  final T peek() {
    return array_[head_];
  }

  /**
   */
  final bool contains(T item) {
    int index = head_;
    int count = size_;

    auto comparer = EqualityComparer!(T).instance;
    while (count-- > 0) {
      if (comparer.equals(array_[index], item))
        return true;
      index = (index + 1) % array_.length;
    }

    return false;
  }

  /**
   */
  final void clear() {
    if (head_ < tail_) {
      .clear(array_, head_, size_);
    }
    else {
      .clear(array_, head_, array_.length - head_);
      .clear(array_, 0, tail_);
    }

    head_ = 0;
    tail_ = 0;
    size_ = 0;
  }

  /**
   * $(I Property.)
   */
  final int count() {
    return size_;
  }

  version (UseRanges) {
    /**
     */
    final bool empty() {
      bool result = (currentIndex_ == size_);
      // Reset current index.
      if (result)
        currentIndex_ = -2;
      return result;
    }

    /**
     */
    final void popFront() {
      currentIndex_++;
    }

    /**
     */
    final T front() {
      if (currentIndex_ == -2)
        currentIndex_ = 0;
      return array_[currentIndex_];
    }
  }
  else {
    final int opApply(int delegate(ref T) action) {
      int r;

      for (auto i = 0; i < size_; i++) {
        if ((r = action(array_[i])) != 0)
          break;
      }

      return r;
    }
  }

  private void setCapacity(int capacity) {
    T[] newArray = new T[capacity];
    if (size_ > 0) {
      if (head_ < tail_) {
        .copy(array_, head_, newArray, 0, size_);
      }
      else {
        .copy(array_, head_, newArray, 0, array_.length - head_);
        .copy(array_, 0, newArray, cast(int)array_.length - head_, tail_);
      }
    }

    array_ = newArray;
    head_ = 0;
    tail_ = (size_ == capacity) ? 0 : size_;
  }

}

class SortedList(K, V) {
alias add добавь;
alias remove удали;
alias removeAt удалиУ;
alias clear сотри;
alias indexOfKey индексКлюча;
alias  indexOfValue индексЗначения;
alias containsKey содержитКлюч_ли;
alias containsValue содержитЗначение_ли;
alias count посчитай;
alias capacity объём;
alias keys ключи;
alias values значения;
alias opIndex опИндекс;
alias insert вставь;
alias ensureCapacity предоставьОбъём;

  private const int DEFAULT_CAPACITY = 4;

  private IComparer!(K) comparer_;
  private K[] keys_;
  private V[] values_;
  private int size_;

  this() {
    comparer_ = Comparer!(K).instance;
  }

  this(int capacity) {
    keys_.length = capacity;
    values_.length = capacity;
    comparer_ = Comparer!(K).instance;
  }

  final void add(K key, V value) {
    int index = binarySearch!(K)(keys_, 0, size_, key, &comparer_.compare);
    insert(~index, key, value);
  }

  final bool remove(K key) {
    int index = indexOfKey(key);
    if (index >= 0)
      removeAt(index);
    return index >= 0;
  }

  final void removeAt(int index) {
    size_--;
    if (index < size_) {
      .copy(keys_, index + 1, keys_, index, size_ - index);
      .copy(values_, index + 1, values_, index, size_ - index);
    }
    keys_[size_] = K.init;
    values_[size_] = V.init;
  }

  final void clear() {
    .clear(keys_, 0, size_);
    .clear(values_, 0, size_);
    size_ = 0;
  }

  final int indexOfKey(K key) {
    int index = binarySearch!(K)(keys_, 0, size_, key, &comparer_.compare);
    if (index < 0)
      return -1;
    return index;
  }

  final int indexOfValue(V value) {
    foreach (i, v; values_) {
      if (equalityComparisonImpl(v, value))
        return i;
    }
    return -1;
  }

  final bool containsKey(K key) {
    return indexOfKey(key) >= 0;
  }

  final bool containsValue(V value) {
    return indexOfValue(value) >= 0;
  }

  final int count() {
    return size_;
  }

  final void capacity(int value) {
    if (value != keys_.length) {
      keys_.length = value;
      values_.length = value;
    }
  }
  final int capacity() {
    return keys_.length;
  }

  final K[] keys() {
    return keys_.dup;
  }

  final V[] values() {
    return values_.dup;
  }

  final V opIndex(K key) {
    int index = indexOfKey(key);
    if (index >= 0)
      return values_[index];
    return V.init;
  }

  private void insert(int index, K key, V value) {
    if (size_ == keys_.length)
      ensureCapacity(size_ + 1);

    if (index < size_) {
      .copy(keys_, index, keys_, index + 1, size_ - index);
      .copy(values_, index, values_, index + 1, size_ - index);
    }

    keys_[index] = key;
    values_[index] = value;
    size_++;
  }

  private void ensureCapacity(int min) {
    int n = (keys_.length == 0) ? DEFAULT_CAPACITY : keys_.length * 2;
    if (n < min)
      n = min;
    this.capacity = n;
  }

}
version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    }
}
