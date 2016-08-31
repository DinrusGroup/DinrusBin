module mesh.Handles;
import tpl.Handles, stdrus: фм, скажинс;

//-----------------------------------------------------------------------------

// Original код использован struct inheritance и trivially derived 
// the handle types from BaseHandle.
// Here we make them distinct types by using a mixin for the guts.
// TODO: could we use a typedef here instead?
// TODO: D2.0 is supposed to fix this limitation of D structs at some point.

/// Handle for a vertex entity
struct УкзНаВектор {
    mixin МиксинХэндл!();
}

/// Handle for a halfedge entity
struct УкзНаПолукрай {
    mixin МиксинХэндл!();
}


/// Handle for a edge entity
struct УкзНаКрай {
    mixin МиксинХэндл!();
}


/// Handle for a face entity
struct УкзНаЛицо {
    mixin МиксинХэндл!();
}


unittest {
    УкзНаВектор x = 10;
    auto y = УкзНаВектор(15);
    assert(фм(x.инд()) == "10");
    assert(фм(y.инд()) == "15");
    assert(x<y);
    assert(y>x);
    y.__инкремент();
    x.__декремент();
    assert(фм(x.инд()) == "9");
    assert(фм(y.инд()) == "16");

    УкзНаВектор z = x;
    assert(фм(z.инд()) == "9");
    скажинс("Всё отлично");
}