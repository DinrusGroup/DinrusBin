module sync;

alias Мютекс Стопор;

extern (D) class Условие
{

    this( Мютекс m );
    ~this();
    проц жди();
    бул жди( дол период );  
    проц уведоми();
    проц уведомиВсе(); 
}


extern (D) class Барьер
{
    this( бцел предел );
	проц жди();
}

 extern (D) class Семафор
{
    this( бцел счёт = 0 );
    ~this();
    проц жди();
    бул жди( дол период );
    проц уведоми();
    бул пробуйЖдать();

}

 extern (D) class Мютекс : Объект.Монитор
{

    this();
    this( Object o );
    ~this();
    проц блокируй();
    проц разблокируй();
    void lock();
	 void unlock();  
    бул пытайсяБлокировать();
}

 extern(D) class ЧЗМютекс
{
    enum Политика
    {
        ПОЧЁТ_ЧИТАТЕЛЮ, /// Readers get preference.  This may starve writers.
        ПОЧЁТ_ПИСАТЕЛЮ  /// Writers get preference.  This may starve readers.
    }


    this( Политика политика = Политика.ПОЧЁТ_ПИСАТЕЛЮ );

    Политика политика();
    Читатель читатель();
    Писатель писатель();
	
	class Читатель : Объект.Монитор
		{
			this();
			проц блокируй();
			проц разблокируй();
		 void lock();
		 void unlock();
			бул пытайсяБлокировать();
		}

	class Писатель :  Объект.Монитор
		{
			 this();
			проц блокируй();
			проц разблокируй();
		void lock();
		 void unlock();
			бул пытайсяБлокировать();
		
		}
}

extern (D) class ИсключениеСинх : Исключение
{
    this( string msg );
}

//////////////////////////////////////////////////////////////////
//////ШАБЛОНЫ АТОМНЫХ ОПЕРАЦИЙ

//////////////////////////////////////////////////////////////////
private
 {

    template целыйТип_ли( T )
    {
        const бул целыйТип_ли = целыйЗначныйТип_ли!(T) ||
                                   целыйБеззначныйТип_ли!(T);
    }

    template указательИлиКласс_ли(T)
    {
        const указательИлиКласс_ли = is(T == class);
    }

    template указательИлиКласс_ли(T : T*)
    {
            const указательИлиКласс_ли = true;
    }
  
    template целыйЗначныйТип_ли( T )
    {
        const бул целыйЗначныйТип_ли = is( T == byte )  ||
                                         is( T == short ) ||
                                         is( T == int )   ||
                                         is( T == long )/+||
                                         is( T == cent  )+/;
    }

    template целыйБеззначныйТип_ли( T )
    {
        const бул целыйБеззначныйТип_ли = is( T == ббайт )  ||
                                           is( T == ushort ) ||
                                           is( T == бцел )   ||
                                           is( T == ulong )/+||
                                           is( T == ucent  )+/;
    }
    
     template УкНаКласс(T){
        static if (is(T==class)){
            alias ук УкНаКласс;
        } else {
            alias T УкНаКласс;
        }
    }
}


template атомныеЗначенияПравильноРазмещены( T )
{
    бул атомныеЗначенияПравильноРазмещены( т_мера адр )
    {
        return адр % УкНаКласс!(T).sizeof == 0;
    }
}

version(D_InlineAsm_X86){
    проц барьерПамяти(bool ll, bool ls, bool sl,bool ss,bool device=false)(){
        static if (device) {
            if (ls || sl || ll || ss){
                // cpid should sequence even more than mfence
                volatile asm {
                    push EBX;
                    mov EAX, 0; // model, stepping
                    cpuid;
                    pop EBX;
                }
            }
        } else static if (ls || sl || (ll && ss)){ // use a sequencing operation like cpuid or simply cmpxch instead?
            volatile asm {
                mfence;
            }
            // this is supposedly faster and correct, but let's play it safe and use the specific instruction
            // push rax
            // xchg rax
            // pop rax
        } else static if (ll){
            volatile asm {
                lfence;
            }
        } else static if( ss ){
            volatile asm {
                sfence;
            }
        }
    }
} else version(D_InlineAsm_X86_64){
    проц барьерПамяти(bool ll, bool ls, bool sl,bool ss,bool device=false)(){
        static if (device) {
            if (ls || sl || ll || ss){
                // cpid should sequence even more than mfence
                volatile asm {
                    push RBX;
                    mov RAX, 0; // model, stepping
                    cpuid;
                    pop RBX;
                }
            }
        } else static if (ls || sl || (ll && ss)){ // use a sequencing operation like cpuid or simply cmpxch instead?
            volatile asm {
                mfence;
            }
            // this is supposedly faster and correct, but let's play it safe and use the specific instruction
            // push rax
            // xchg rax
            // pop rax
        } else static if (ll){
            volatile asm {
                lfence;
            }
        } else static if( ss ){
            volatile asm {
                sfence;
            }
        }
    }
} else {
    pragma(msg,"WARNING: no atomic operations on this architecture");
    pragma(msg,"WARNING: this is *slow* you probably want to change this!");
    цел dummy;
    // acquires a блокируй... probably you will want to skip this
    synchronized проц барьерПамяти(bool ll, bool ls, bool sl,bool ss,bool device=false)(){
        dummy =1;
    }
    enum{LockVersion = true}
}

static if (!is(typeof(LockVersion))) {
    enum{LockVersion= false}
}

// use stricter fences
enum{strictFences=false}

/// utility function for a пиши barrier (disallow store and store reorderig)
проц барьерЗаписи();
/// utility function for a read barrier (disallow load and load reorderig)
проц барьерЧтения();
/// utility function for a full barrier (disallow reorderig)
проц полныйБарьер();


 version(D_InlineAsm_X86) {
    T атомнаяПерестановка( T )( inout T val, T newval )
    in {
        // NOTE: 32 bit x86 systems support 8 byte CAS, which only requires
        //       4 byte alignment, so use т_мера as the align type here.
        static if( T.sizeof > т_мера.sizeof )
            assert( атомныеЗначенияПравильноРазмещены!(т_мера)( cast(т_мера) &val ) );
        else
            assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &val ) );
    } body {
        T*posVal=&val;
        static if( T.sizeof == byte.sizeof ) {
            volatile asm {
                mov AL, newval;
                mov ECX, posVal;
                lock; // блокируй always needed to make this op atomic
                xchg [ECX], AL;
            }
        }
        else static if( T.sizeof == short.sizeof ) {
            volatile asm {
                mov AX, newval;
                mov ECX, posVal;
                lock; // блокируй always needed to make this op atomic
                xchg [ECX], AX;
            }
        }
        else static if( T.sizeof == цел.sizeof ) {
            volatile asm {
                mov EAX, newval;
                mov ECX, posVal;
                lock; // блокируй always needed to make this op atomic
                xchg [ECX], EAX;
            }
        }
        else static if( T.sizeof == дол.sizeof ) {
            // 8 Byte swap on 32-Bit Processor, use CAS?
            static assert( false, "Указан неверный шаблонный тип, 8 байт в 32-битном режиме: "~T.stringof );
        }
        else
        {
            static assert( false, "Указан неверный шаблонный тип: "~T.stringof );
        }
    }
} else version (D_InlineAsm_X86_64){
    T атомнаяПерестановка( T )( inout T val, T newval )
    in {
        assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &val ) );
    } body {
        T*posVal=&val;
        static if( T.sizeof == byte.sizeof ) {
            volatile asm {
                mov AL, newval;
                mov RCX, posVal;
                lock; // блокируй always needed to make this op atomic
                xchg [RCX], AL;
            }
        }
        else static if( T.sizeof == short.sizeof ) {
            volatile asm {
                mov AX, newval;
                mov RCX, posVal;
                lock; // блокируй always needed to make this op atomic
                xchg [RCX], AX;
            }
        }
        else static if( T.sizeof == цел.sizeof ) {
            volatile asm {
                mov EAX, newval;
                mov RCX, posVal;
                lock; // блокируй always needed to make this op atomic
                xchg [RCX], EAX;
            }
        }
        else static if( T.sizeof == дол.sizeof ) {
            volatile asm {
                mov RAX, newval;
                mov RCX, posVal;
                lock; // блокируй always needed to make this op atomic
                xchg [RCX], RAX;
            }
        }
        else
        {
            static assert( false, "Указан неверный шаблонный тип: "~T.stringof );
        }
    }
} else {
    T атомнаяПерестановка( T )( inout T val, T newval )
    in {
        assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &val ) );
    } body {
        T oldVal;
        synchronized(typeid(T)){
            oldVal=val;
            val=newval;
        }
        return oldVal;
    }
}

//---------------------
// internal conversion template
private T aCasT(T,V)(ref   T val, T newval, T equalTo){
    union UVConv{V v; T t;}
    union UVPtrConv{V *v; T *t;}
    UVConv vNew,vOld,vAtt;
    UVPtrConv valPtr;
    vNew.t=newval;
    vOld.t=equalTo;
    valPtr.t=&val;
    vAtt.v=atomicCAS(*valPtr.v,vNew.v,vOld.v);
    return vAtt.t;
}
/// internal reduction 
private T aCas(T)(ref   T val, T newval, T equalTo){
    static if (T.sizeof==1){
        return aCasT!(T,ббайт)(val,newval,equalTo);
    } else static if (T.sizeof==2){
        return aCasT!(T,ushort)(val,newval,equalTo);
    } else static if (T.sizeof==4){
        return aCasT!(T,бцел)(val,newval,equalTo);
    } else static if (T.sizeof==8){ // unclear if it is always supported...
        return aCasT!(T,ulong)(val,newval,equalTo);
    } else {
        static assert(0,"неверный тип "~T.stringof);
    }
}

version(D_InlineAsm_X86) {
    version(darwin){
        extern(C) ббайт OSAtomicCompareAndSwap64(дол oldValue, дол newValue,
                 дол *theValue); // assumes that in C sizeof(_Bool)==1 (as given in osx IA-32 ABI)
    }
    T atomicCAS( T )( ref   T val, T newval, T equalTo )
    in {
        // NOTE: 32 bit x86 systems support 8 byte CAS, which only requires
        //       4 byte alignment, so use т_мера as the align type here.
        static if( УкНаКласс!(T).sizeof > т_мера.sizeof )
            assert( атомныеЗначенияПравильноРазмещены!(т_мера)( cast(т_мера) &val ) );
        else
            assert( атомныеЗначенияПравильноРазмещены!(УкНаКласс!(T))( cast(т_мера) &val ) );
    } body {
        T*posVal=&val;
        static if( T.sizeof == byte.sizeof ) {
            volatile asm {
                mov DL, newval;
                mov AL, equalTo;
                mov ECX, posVal;
                lock; // блокируй always needed to make this op atomic
                cmpxchg [ECX], DL;
            }
        }
        else static if( T.sizeof == short.sizeof ) {
            volatile asm {
                mov DX, newval;
                mov AX, equalTo;
                mov ECX, posVal;
                lock; // блокируй always needed to make this op atomic
                cmpxchg [ECX], DX;
            }
        }
        else static if( УкНаКласс!(T).sizeof == цел.sizeof ) {
            volatile asm {
                mov EDX, newval;
                mov EAX, equalTo;
                mov ECX, posVal;
                lock; // блокируй always needed to make this op atomic
                cmpxchg [ECX], EDX;
            }
        }
        else static if( T.sizeof == дол.sizeof ) {
            // 8 Byte StoreIf on 32-Bit Processor
            version(darwin){
                union UVConv{дол v; T t;}
                union UVPtrConv{дол *v; T *t;}
                UVConv vEqual,vNew;
                UVPtrConv valPtr;
                vEqual.t=equalTo;
                vNew.t=newval;
                valPtr.t=&val;
                while(1){
                    if(OSAtomicCompareAndSwap64(vEqual.v, vNew.v, valPtr.v)!=0)
                    {
                        return equalTo;
                    } else {
                        volatile {
                            T res=val;
                            if (res!is equalTo) return res;
                        }
                    }
                }
            } else {
                T res;
                volatile asm
                {
                    push EDI;
                    push EBX;
                    lea EDI, newval;
                    mov EBX, [EDI];
                    mov ECX, 4[EDI];
                    lea EDI, equalTo;
                    mov EAX, [EDI];
                    mov EDX, 4[EDI];
                    mov EDI, val;
                    lock; // блокируй always needed to make this op atomic
                    cmpxch8b [EDI];
                    lea EDI, res;
                    mov [EDI], EAX;
                    mov 4[EDI], EDX;
                    pop EBX;
                    pop EDI;
                }
                return res;
            }
        }
        else
        {
            static assert( false, "Указан неверный шаблонный тип: "~T.stringof );
        }
    }
} else version (D_InlineAsm_X86_64){
    T atomicCAS( T )( ref   T val, T newval, T equalTo )
    in {
        assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &val ) );
    } body {
        T*posVal=&val;
        static if( T.sizeof == byte.sizeof ) {
            volatile asm {
                mov DL, newval;
                mov AL, equalTo;
                mov RCX, posVal;
                lock; // блокируй always needed to make this op atomic
                cmpxchg [RCX], DL;
            }
        }
        else static if( T.sizeof == short.sizeof ) {
            volatile asm {
                mov DX, newval;
                mov AX, equalTo;
                mov RCX, posVal;
                lock; // блокируй always needed to make this op atomic
                cmpxchg [RCX], DX;
            }
        }
        else static if( УкНаКласс!(T).sizeof == цел.sizeof ) {
            volatile asm {
                mov EDX, newval;
                mov EAX, equalTo;
                mov RCX, posVal;
                lock; // блокируй always needed to make this op atomic
                cmpxchg [RCX], EDX;
            }
        }
        else static if( УкНаКласс!(T).sizeof == дол.sizeof ) {
            volatile asm {
                mov RDX, newval;
                mov RAX, equalTo;
                mov RCX, posVal;
                lock; // блокируй always needed to make this op atomic
                cmpxchg [RCX], RDX;
            }
        }
        else
        {
            static assert( false, "Задан неправильный шаблонный тип: "~T.stringof );
        }
    }
} else {
    T atomicCAS( T )( ref   T val, T newval, T equalTo )
    in {
        assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &val ) );
    } body {
        T oldval;
        synchronized(typeid(T)){
            oldval=val;
            if(oldval==equalTo) {
                val=newval;
            }
        }
        return oldval;
    }
}

бул atomicCASB(T)( ref   T val, T newval, T equalTo ){
    return (equalTo is atomicCAS(val,newval,equalTo));
}


T атомнаяЗагрузка(T)(ref   T val)
in {
    assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &val ) );
    static assert(УкНаКласс!(T).sizeof<=т_мера.sizeof,"неверный размер для "~T.stringof);
} body {
    volatile T res=val;
    return res;
}


проц атомноеСохранение(T)(ref   T val, T newVal)
in {
        assert( атомныеЗначенияПравильноРазмещены!(T)( cast(т_мера) &val ), "неверная раскладка" );
        static assert(УкНаКласс!(T).sizeof<=т_мера.sizeof,"наверный размер для "~T.stringof);
} body {
    volatile val=newVal;
}


version (D_InlineAsm_X86){
    T атомнаяПрибавка(T,U=T)(ref   T val, U incV_){
        T incV=cast(T)incV_;
        static if (целыйТип_ли!(T)||указательИлиКласс_ли!(T)){
            T* posVal=&val;
            T res;
            static if (T.sizeof==1){
                volatile asm {
                    mov DL, incV;
                    mov ECX, posVal;
                    lock;
                    xadd byte ptr [ECX],DL;
                    mov byte ptr res[EBP],DL;
                }
            } else static if (T.sizeof==2){
                volatile asm {
                    mov DX, incV;
                    mov ECX, posVal;
                    lock;
                    xadd short ptr [ECX],DX;
                    mov short ptr res[EBP],DX;
                }
            } else static if (T.sizeof==4){
                volatile asm
                {
                    mov EDX, incV;
                    mov ECX, posVal;
                    lock;
                    xadd int ptr [ECX],EDX;
                    mov int ptr res[EBP],EDX;
                }
            } else static if (T.sizeof==8){
                return атомнаяОп(val,delegate (T x){ return x+incV; });
            } else {
                static assert(0,"Неподдерживаемый размер типа");
            }
            return res;
        } else {
            return атомнаяОп(val,delegate T(T a){ return a+incV; });
        }
    }
} else version (D_InlineAsm_X86_64){
    T атомнаяПрибавка(T,U=T)(ref   T val, U incV_){
        T incV=cast(T)incV_;
        static if (целыйТип_ли!(T)||указательИлиКласс_ли!(T)){
            T* posVal=&val;
            T res;
            static if (T.sizeof==1){
                volatile asm {
                    mov DL, incV;
                    mov RCX, posVal;
                    lock;
                    xadd byte ptr [RCX],DL;
                    mov byte ptr res[EBP],DL;
                }
            } else static if (T.sizeof==2){
                volatile asm {
                    mov DX, incV;
                    mov RCX, posVal;
                    lock;
                    xadd short ptr [RCX],DX;
                    mov short ptr res[EBP],DX;
                }
            } else static if (T.sizeof==4){
                volatile asm
                {
                    mov EDX, incV;
                    mov RCX, posVal;
                    lock;
                    xadd int ptr [RCX],EDX;
                    mov int ptr res[EBP],EDX;
                }
            } else static if (T.sizeof==8){
                volatile asm
                {
                    mov RAX, val;
                    mov RDX, incV;
                    lock; // блокируй always needed to make this op atomic
                    xadd qword ptr [RAX],RDX;
                    mov res[EBP],RDX;
                }
            } else {
                static assert(0,"Неподдерживаемый размер для типа:"~T.stringof);
            }
            return res;
        } else {
            return атомнаяОп(val,delegate T(T a){ return a+incV; });
        }
    }
} else {
    static if (LockVersion){
        T атомнаяПрибавка(T,U=T)(ref   T val, U incV_){
            T incV=cast(T)incV_;
            static assert( целыйТип_ли!(T)||указательИлиКласс_ли!(T),"неверный тип: "~T.stringof );
            synchronized(typeid(T)){
                T oldV=val;
                val+=incV;
                return oldV;
            }
        }
    } else {
        T атомнаяПрибавка(T,U=T)(ref   T val, U incV_){
            T incV=cast(T)incV_;
            static assert( целыйТип_ли!(T)||указательИлиКласс_ли!(T),"неверный тип: "~T.stringof );
            synchronized(typeid(T)){
                T oldV,newVal,nextVal;
                volatile nextVal=val;
                do{
                    oldV=nextVal;
                    newV=oldV+incV;
                    auto nextVal=atomicCAS!(T)(val,newV,oldV);
                } while(nextVal!=oldV)
                return oldV;
            }
        }
    }
}


T атомнаяОп(T)(ref   T val, T delegate(T) f){
    T oldV,newV,nextV;
    цел i=0;
    nextV=val;
    do {
        oldV=nextV;
        newV=f(oldV);
        nextV=aCas!(T)(val,newV,oldV);
        if (nextV is oldV || newV is oldV) return oldV;
    } while(++i<200)
    while (true){
        нить_жни();
        volatile oldV=val;
        newV=f(oldV);
        nextV=aCas!(T)(val,newV,oldV);
        if (nextV is oldV || newV is oldV) return oldV;
    }
}


T флагДай(T)(ref   T флаг){
    T res;
    volatile res=флаг;
    барьерПамяти!(true,false,strictFences,false)();
    return res;
}

T флагУст(T)(ref   T флаг,T newVal){
    барьерПамяти!(false,strictFences,false,true)();
    return атомнаяПерестановка(флаг,newVal);
}

T флагОп(T)(ref   T флаг,T delegate(T) op){
    барьерПамяти!(false,strictFences,false,true)();
    return атомнаяОп(флаг,op);
}

T флагДоб(T)(ref   T флаг,T incV=cast(T)1){
    static if (!LockVersion)
        барьерПамяти!(false,strictFences,false,true)();
    return атомнаяПрибавка(флаг,incV);
}

T следщЗнач(T)(ref   T val){
    return атомнаяПрибавка(val,cast(T)1);
}

