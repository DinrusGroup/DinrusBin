/******************************************************************************* 

	A more flexible signal mixin than std.signals
	
	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:     ArcLib team 

	Description:    
	A more flexible signal mixin than std.signals

	This only has minor modifications of the original that was
	Written by Bill Baxter, November 9, 2006.
	This code is released to the public domain

	Examples:      
	---------------------
		None provided.  
	---------------------

*******************************************************************************/

module arc.templates.flexsignal;

public import std.signals;

import
	std.io, 
	std.c,
	std.traits;

/** A simple opaque datatype which serves as a key for FlexSignal.fdisconnect.
 *  The primary use is internal, for keeping a mapping between user slots
 *  and their wrappers.  However, they can also be used as a key to a delegate
 *  literal for later disconnecting.
 */
struct slot_key {
    alias void delegate() slot_t;
    byte[slot_t.sizeof] data=0;
}

/** FlexSignal is a more flexible version the signal template.
 *
 *  Using the fconnect/fdisconnect methods it is possible to connect the 
 *  signal to most any callable entity with a signature that is 'compatible'.
 *  with the signal's signature.
 *
 *  Specifically one can connect 
 *  - functions and delegate literals.
 *  - slots that return values (the return value is simply ignored by the signal)
 *  - slots that take fewer parameters than the signal supplies 
 *    (trailing paramters from signal simply aren't passed to the slot).
 *  - delegates with fewer arguments 
 *  than the signal supplies are allowed, and any argument which can 
 *  be implicitly converted by D is allowed as well.
 */
template FlexSignal(T...)
{
	mixin Signal!(T);
	alias T param_t;
	alias void delegate(T) slot_t;
	slot_t[slot_key] thunkMap;
	
	/** A flexible version of connect.  Works for delegates to classes 
		* or structs, plain functions, delegate literals.  Also works for
		* things with or without return values, and with fewer
		* arguments than the signal supplies.
		*
		* So for example, an (int,char[]) FlexSignal can be connected to an
		* int funciton that returns a float.
		*
		* Also it can convert compatible argument types, any thing that can
		* be implicitly converted at runtime is allowed.
		* 
		* So for example, the (int, char[]) FlexSigal can be connected to a 
		* method taking a (double,char[]) because int is automatically 
		* promoted to double.
		*
		* Returns: a slot key which can be used to disconnect the item
		* later.  (You can also use the original slot to disconnect if you
		* have it.)
		*/
	slot_key fconnect(DT)(DT f)
	{
		// make the key
		static assert(DT.sizeof <= slot_t.sizeof);
		slot_key f_key = make_slot_key(f);
		
		//slot_t f_wrap = SlotAdapter!(slot_t).adapt(f);
		// wrap is safer for now.
		slot_t f_wrap = SlotAdapter!(slot_t).wrap(f);

		connect(f_wrap);

		thunkMap[f_key]=f_wrap;
		return f_key;
	}

	/** Disconnect a slot of any type */
	void fdisconnect(DT)(DT f) 
	{ 
		static if( is(DT==slot_t) ) {
				disconnect(f);
		}
		else {
			static if( is(DT==slot_key) ) {
				alias f f_key;
			}
			else {
				// make the key from the delegate
				static assert(DT.sizeof <= slot_t.sizeof);
				slot_key f_key = make_slot_key(f);
			}

			if (f_key in thunkMap) {
				disconnect(thunkMap[f_key]);
			} else {
				debug writefln("FlexSignal.fdisconnect: Slot not found");
			}
		}
	}
}


slot_key make_slot_key(T)(T fn) {
		alias void delegate() slot_t;
		slot_key f_key;
		static assert(T.sizeof <= slot_t.sizeof);
		memcpy(&f_key, &fn, T.sizeof);
		return f_key;
}

/**
SlotAdapter is a template that takes a signal's 'slot_t' delegate type.
It contains two functions, wrap() and adapt().

wrap() returns a slot_t delegate to object that wraps a passed in
delegate or function which may have a signature that differs from
'slot_t'.  As long as the callable entity passed in has argument
types compatible with 'slot_t' then the operation should succeed.  In
particular exact matching with slot_t's parameter types is not
necessary, any type implicitly convertable from the slot_t's argument
type is ok.

adapt() is the same as wrap(), except it will return the original
delegate without creating a wrapper if that delegate's matches the
slot_t exactly.

Usage:
	auto wrapped = SlotAdapter!(Signals_SlotType).wrap(target_slot)
	auto adapted = SlotAdapter!(Signals_SlotType).adapt(target_slot)
*/
template SlotAdapter(slot_t)
{
		alias ReturnType!(slot_t) slot_ret_t;
		alias ParameterTypeTuple!(slot_t) slot_arg_t;
		
		static assert( is(slot_ret_t==void), "Expected native slot type to return void."  );
		
		slot_t wrap(WrapSlotT)(WrapSlotT fn) {
				alias WrapSlotT wrap_slot_t;
				alias ReturnType!(fn) wrap_ret_t;
				alias ParameterTypeTuple!(fn) wrap_arg_t;

				// This has to be a class for std.signal's use, currently
				class Inner {
						wrap_slot_t thunked_slot;
						void slot(slot_arg_t arg) 
						{
								thunked_slot(arg[0..wrap_arg_t.length]);
						}
				}
				Inner inner = new Inner;
				inner.thunked_slot = fn; 
				return &inner.slot;
		}

		SigSlotT adapt(WrapSlotT)(WrapSlotT fn)
		{
				static if (is(slot_t==WrapSlotT)) {
						// This *does* need to be wrapped if this is 
						// a delegate to a struct method, but there's no way to ask D
						// for this information.  Well anyway, disallowing struct
						// is listed as a bug currently.
						//    http://www.digitalmars.com/d/phobos/std_signals.html
						// so there's hope it will change.
						// Use wrap instead of adapt if this is a concern.
						return fn;
				}
				else {
						return wrap(fn);
				}
		}
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
