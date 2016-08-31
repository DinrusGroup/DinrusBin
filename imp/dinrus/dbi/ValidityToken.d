module dbi.ValidityToken;

alias проц delegate(Объект) ДСобыт;

private {
    extern (C) проц  rt_attachDisposeEvent( Объект объ, ДСобыт соб );
    extern (C) проц  rt_detachDisposeEvent( Объект объ, ДСобыт соб );
}


final class ТокенВалидности { }

class СлабСсыл(T : Объект) {
private:
    т_мера cast_ptr_;
    проц отхукни(Объект o) {
        if (cast(т_мера)cast(ук)o == cast_ptr_) {
            rt_detachDisposeEvent(o, &отхукни);
            cast_ptr_ = 0;
        }
    }
public:

alias ptr укз;
    this(T tptr) {
        cast_ptr_ = cast(т_мера)cast(ук)tptr;
        rt_attachDisposeEvent(tptr, &отхукни);
    }
    ~this() {
        T p = укз();
        if (p) {
            rt_detachDisposeEvent(p, &отхукни);
        }
    }
    T ptr() {
        return cast(T)cast(ук)cast_ptr_;
    }

    проц зарегиХук(ДСобыт hook);

    проц отрегиХук(ДСобыт hook);

    СлабСсыл dup() ;
}

alias СлабСсыл!(ТокенВалидности) ТокеноДерж;


