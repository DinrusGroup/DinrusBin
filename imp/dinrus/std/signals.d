module std.signals;

import std.stdio;
import cidrus : calloc, realloc, free;
import exception : _d_OutOfMemory;

// Special function for internal use only.
// Use of this is where the slot had better be a delegate
// to an object or an interface that is part of an object.
extern  (C) Object _d_toObject(void* p);

//debug=signal;

/************************
 * Mixin to create a signal within a class object.
 *
 * Different signals can be added to a class by naming the mixins.
 *
 * Example:
---
import std.signals;
import std.stdio;

class Observer
{   // our slot
    void watch(char[] msg, int i)
    {
	writefln("Observed msg '%s' and value %s", msg, i);
    }
}

class Foo
{
    int value() { return _value; }

    int value(int v)
    {
	if (v != _value)
	{   _value = v;
	    // call all the connected slots with the two parameters
	    emit("setting new value", v);
	}
	return v;
    }

    // Mix in all the code we need to make Foo into a signal
    mixin Signal!(char[], int);

  private :
    int _value;
}

void main()
{
    Foo a = new Foo;
    Observer o = new Observer;

    a.value = 3;		// should not call o.watch()
    a.connect(&o.watch);	// o.watch is the slot
    a.value = 4;		// should call o.watch()
    a.disconnect(&o.watch);	// o.watch is no longer a slot
    a.value = 5;		// so should not call o.watch()
    a.connect(&o.watch);	// connect again
    a.value = 6;		// should call o.watch()
    delete o;			// destroying o should automatically disconnect it
    a.value = 7;		// should not call o.watch()
}
---
 * which should print:
 * <pre>
 * Observed msg 'setting new value' and value 4
 * Observed msg 'setting new value' and value 6
 * </pre>
 *
 */
alias Signal Сигнал;
template Signal(T1...)
{
alias emit подай;
alias connect подключи;
alias disconnect отключи;

    /***
     * A slot is implemented as a delegate.
     * The slot_t is the type of the delegate.
     * The delegate must be to an instance of a class or an interface
     * to a class instance.
     * Delegates to struct instances or nested functions must not be
     * used as slots.
     */
    alias void delegate(T1) slot_t;

    /***
     * Call each of the connected slots, passing the argument(s) i to them.
     */
    void emit( T1 i )
    {
        foreach (slot; slots[0 .. slots_idx])
	{   if (slot)
		slot(i);
	}
    }

    /***
     * Add a slot to the list of slots to be called when emit() is called.
     */
    void connect(slot_t slot)
    {
	/* Do this:
	 *    slots ~= slot;
	 * but use malloc() and friends instead
	 */
	auto len = slots.length;
	if (slots_idx == len)
	{
	    if (slots.length == 0)
	    {
		len = 4;
		auto p = std.signals.calloc(slot_t.sizeof, len);
		if (!p)
		    std.signals._d_OutOfMemory();
		slots = (cast(slot_t*)p)[0 .. len];
	    }
	    else
	    {
		len = len * 2 + 4;
		auto p = std.signals.realloc(slots.ptr, slot_t.sizeof * len);
		if (!p)
		    std.signals._d_OutOfMemory();
		slots = (cast(slot_t*)p)[0 .. len];
		slots[slots_idx + 1 .. length] = null;
	    }
	}
	slots[slots_idx++] = slot;

     L1:
	Object o = _d_toObject(slot.ptr);
	o.notifyRegister(&unhook);
    }

    /***
     * Remove a slot from the list of slots to be called when emit() is called.
     */
    void disconnect( slot_t slot)
    {
	debug (signal) writefln("Signal.disconnect(slot)");
	for (size_t i = 0; i < slots_idx; )
	{
	    if (slots[i] == slot)
	    {	slots_idx--;
		slots[i] = slots[slots_idx];
		slots[slots_idx] = null;	// not strictly necessary

		Object o = _d_toObject(slot.ptr);
		o.notifyUnRegister(&unhook);
	    }
	    else
		i++;
	}
    }

    /* **
     * Special function called when o is destroyed.
     * It causes any slots dependent on o to be removed from the list
     * of slots to be called by emit().
     */
    void unhook(Object o)
    {
	debug (signal) writefln("Signal.unhook(o = %s)", cast(void*)o);
	for (size_t i = 0; i < slots_idx; )
	{
	    if (_d_toObject(slots[i].ptr) is o)
	    {	slots_idx--;
		slots[i] = slots[slots_idx];
		slots[slots_idx] = null;	// not strictly necessary
	    }
	    else
		i++;
	}
    }

    /* **
     * There can be multiple destructors inserted by mixins.
     */
    ~this()
    {
	/* **
	 * When this object is destroyed, need to let every slot
	 * know that this object is destroyed so they are not left
	 * with dangling references to it.
	 */
	if (slots)
	{
	    foreach (slot; slots[0 .. slots_idx])
	    {
		if (slot)
		{   Object o = _d_toObject(slot.ptr);
		    o.notifyUnRegister(&unhook);
		}
	    }
	    std.signals.free(slots.ptr);
	    slots = null;
	}
    }

  private:
    slot_t[] slots;		// the slots to call from emit()
    size_t slots_idx;		// used length of slots[]
}

// A function whose sole purpose is to get this module linked in
// so the unittest will run.
void linkin() { }

unittest
{
    class Observer
    {
	void watch(char[] msg, int i)
	{
	    writefln("Observed msg '%s' and value %s", msg, i);
	}
    }

    class Foo
    {
	int value() { return _value; }

	int value(int v)
	{
	    if (v != _value)
	    {   _value = v;
		emit("setting new value", v);
	    }
	    return v;
	}

	mixin Signal!(char[], int);

      private:
	int _value;
    }

    Foo a = new Foo;
    Observer o = new Observer;

    a.value = 3;
    a.connect(&o.watch);
    a.value = 4;
    a.disconnect(&o.watch);
    a.value = 5;
    a.connect(&o.watch);
    a.value = 6;
    delete o;
    a.value = 7;
}
