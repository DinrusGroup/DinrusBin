﻿
/* Digital Mars DMDScript source code.
 * Copyright (c) 2000-2002 by Chromium Communications
 * D version Copyright (c) 2004-2005 by Digital Mars
 * All Rights Reserved
 * written by Walter Bright
 * www.digitalmars.com
 * Use at your own risk. There is no warranty, express or implied.
 * License for redistribution is by the GNU General Public License in gpl.txt.
 *
 * A binary, non-exclusive license for commercial use can be
 * purchased from www.digitalmars.com/dscript/buy.html.
 *
 * DMDScript is implemented in the D Programming Language,
 * www.digitalmars.com/d/
 *
 * For a C++ implementation of DMDScript, including COM support,
 * see www.digitalmars.com/dscript/cppscript.html.
 */

module amigos.dmdscript.dboolean;

import amigos.dmdscript.script;
import amigos.dmdscript.dobject;
import amigos.dmdscript.value;
import amigos.dmdscript.threadcontext;
import amigos.dmdscript.dfunction;
import amigos.dmdscript.text;
import amigos.dmdscript.property;
import amigos.dmdscript.errmsgs;
import amigos.dmdscript.dnative;

/* ===================== Dboolean_constructor ==================== */

class Dboolean_constructor : Dfunction
{
    this(ThreadContext *tc)
    {
	super(1, tc.Dfunction_prototype);
	name = "Boolean";
    }

    void *Construct(CallContext *cc, Value *ret, Value[] arglist)
    {
	// ECMA 15.6.2
	d_boolean b;
	Dobject o;

	b = (arglist.length) ? arglist[0].toBoolean() : false;
	o = new Dboolean(b);
	ret.putVobject(o);
	return null;
    }

    void *Call(CallContext *cc, Dobject othis, Value* ret, Value[] arglist)
    {
	// ECMA 15.6.1
	d_boolean b;

	b = (arglist.length) ? arglist[0].toBoolean() : false;
	ret.putVboolean(b);
	return null;
    }
}


/* ===================== Dboolean_prototype_toString =============== */

void* Dboolean_prototype_toString(Dobject pthis, CallContext *cc, Dobject othis, Value *ret, Value[] arglist)
{
    // othis must be a Boolean
    if (!othis.isClass(TEXT_Boolean))
    {
	ErrInfo errinfo;

	ret.putVundefined();
	return Dobject.RuntimeError(&errinfo, errmsgtbl[ERR_FUNCTION_WANTS_BOOL],
		TEXT_toString,
		othis.classname);
    }
    else
    {	Value *v;

	v = &(cast(Dboolean)othis).value;
	ret.putVstring(v.toString());
    }
    return null;
}

/* ===================== Dboolean_prototype_valueOf =============== */

void* Dboolean_prototype_valueOf(Dobject pthis, CallContext *cc, Dobject othis, Value *ret, Value[] arglist)
{
    //FuncLog f("Boolean.prototype.valueOf()");
    //logflag = 1;

    // othis must be a Boolean
    if (!othis.isClass(TEXT_Boolean))
    {
	ErrInfo errinfo;

	ret.putVundefined();
	return Dobject.RuntimeError(&errinfo, errmsgtbl[ERR_FUNCTION_WANTS_BOOL],
		TEXT_valueOf,
		othis.classname);
    }
    else
    {	Value *v;

	v = &(cast(Dboolean)othis).value;
	Value.copy(ret, v);
    }
    return null;
}

/* ===================== Dboolean_prototype ==================== */

class Dboolean_prototype : Dboolean
{
    this(ThreadContext *tc)
    {
	super(tc.Dobject_prototype);
	Dobject f = tc.Dfunction_prototype;

	Put(TEXT_constructor, tc.Dboolean_constructor, DontEnum);

	static NativeFunctionData nfd[] =
	[
	    {	&TEXT_toString, &Dboolean_prototype_toString, 0 },
	    {   &TEXT_valueOf,  &Dboolean_prototype_valueOf,  0 },
	];

	DnativeFunction.init(this, nfd, DontEnum);
    }
}


/* ===================== Dboolean ==================== */

class Dboolean : Dobject
{
    this(d_boolean b)
    {
	super(Dboolean.getPrototype());
	value.putVboolean(b);
	classname = TEXT_Boolean;
    }

    this(Dobject prototype)
    {
	super(prototype);
	value.putVboolean(false);
	classname = TEXT_Boolean;
    }

    static Dfunction getConstructor()
    {
	ThreadContext *tc = ThreadContext.getThreadContext();
	assert(tc);
	return tc.Dboolean_constructor;
    }

    static Dobject getPrototype()
    {
	ThreadContext *tc = ThreadContext.getThreadContext();
	assert(tc);
	return tc.Dboolean_prototype;
    }

    static void init(ThreadContext *tc)
    {
	tc.Dboolean_constructor = new Dboolean_constructor(tc);
	tc.Dboolean_prototype = new Dboolean_prototype(tc);

	tc.Dboolean_constructor.Put(TEXT_prototype, tc.Dboolean_prototype, DontEnum | DontDelete | ReadOnly);
    }
}

