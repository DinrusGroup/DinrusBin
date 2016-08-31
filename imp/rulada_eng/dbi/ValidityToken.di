module dbi.ValidityToken;

alias void delegate(Object) DisposeEvt;

private {
    extern (C) void  rt_attachDisposeEvent( Object obj, DisposeEvt evt );
    extern (C) void  rt_detachDisposeEvent( Object obj, DisposeEvt evt );
}


final class ValidityToken { }

class WeakRef(T : Object) {
private:
    size_t cast_ptr_;
    void unhook(Object o) {
        if (cast(size_t)cast(void*)o == cast_ptr_) {
            rt_detachDisposeEvent(o, &unhook);
            cast_ptr_ = 0;
        }
    }
public:

    this(T tptr) {
        cast_ptr_ = cast(size_t)cast(void*)tptr;
        rt_attachDisposeEvent(tptr, &unhook);
    }
    ~this() {
        T p = ptr();
        if (p) {
            rt_detachDisposeEvent(p, &unhook);
        }
    }
    T ptr() {
        return cast(T)cast(void*)cast_ptr_;
    }

    void registerHook(DisposeEvt hook) {
        T p = ptr();
        if (p) {
            rt_attachDisposeEvent(p, hook);
        }
    }

    void unregisterHook(DisposeEvt hook) {
        T p = ptr();
        if (p) {
            rt_detachDisposeEvent(p, hook);
        }
    }

    WeakRef dup() {
        return new WeakRef(ptr());
    }
}

alias WeakRef!(ValidityToken) TokenHolder;



version (build) {
    debug {
        pragma(link, "dbi");
    } else {
        pragma(link, "dbi");
    }
}
