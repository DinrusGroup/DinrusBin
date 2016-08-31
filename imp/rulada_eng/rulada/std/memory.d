/**
 * Модуль memory предоставляет интерфейс к мусоросборщику, а так же
 * к прочим средствам управления памятью на уровне OS или API.
 *
 * Copyright: Copyright (C) 2005-2006 Sean Kelly.  All rights reserved.
 * License:   BSD style: $(LICENSE)
 * Authors:   Sean Kelly
 */
module std.memory;


private
{
    extern (C) void gc_init();
    extern (C) void gc_term();

    extern (C) void gc_enable();
    extern (C) void gc_disable();
    extern (C) void gc_collect();
    extern (C) void gc_minimize();

    extern (C) uint gc_getAttr( void* p );
    extern (C) uint gc_setAttr( void* p, uint a );
    extern (C) uint gc_clrAttr( void* p, uint a );

    extern (C) void*  gc_malloc( size_t sz, uint ba = 0 );
    extern (C) void*  gc_calloc( size_t sz, uint ba = 0 );
    extern (C) void*  gc_realloc( void* p, size_t sz, uint ba = 0 );
    extern (C) size_t gc_extend( void* p, size_t mx, size_t sz );
    extern (C) size_t gc_reserve( size_t sz );
    extern (C) void   gc_free( void* p );

    extern (C) void*   gc_addrOf( void* p );
    extern (C) size_t  gc_sizeOf( void* p );

    struct BlkInfo_
    {
        void*  base;
        size_t size;
        uint   attr;
    }

    extern (C) BlkInfo_ gc_query( void* p );

    extern (C) void gc_addRoot( void* p );
    extern (C) void gc_addRange( void* p, size_t sz );

    extern (C) void gc_removeRoot( void* p );
    extern (C) void gc_removeRange( void* p );

    extern(C) Object gc_weakpointerGet(void* wp);
    extern(C) void*  gc_weakpointerCreate(Object r);
    extern(C) void   gc_weakpointerDestroy(void* wp);

    alias extern(D) void delegate() ddel;
    alias extern(D) void delegate(int, int) dint;

    extern (C) void gc_monitor(ddel begin, dint end );
}

extern  (C) void* rt_stackBottom();
extern  (C) void* rt_stackTop();

alias void delegate( void*, void* ) scanFn;

extern  (C) void rt_scanStaticData( scanFn scan );



/**
 * Данная структура инкапсулирует в себе всю функциональность сборщика мусора
 * языка программирования Ди.
 */
struct GC
{
    /**
     * Активирует сборку мусора, если она ранее была приостановлена
     *вызовом disable.  Это функция повторно-входимая, она должна
     * вызываться единожды для каждого вызова disable, перед активацией
     * мусоросборщика.
     */
    static void enable()
    {
        gc_enable();
    }


    /**
     * Отключает мусоросборщик.  This function is reentrant, but
     * enable must be called once for each call to disable.
     */
    static void disable()
    {
        gc_disable();
    }


    /**
     * Активирует полную сборку.  Хотя значение этой функции может меняться
	* в зависимости от реализации сборщика мусора,
     * как правило, она сканирует все сегменты стека на наличие
     * корней (ветвлений), помечает доступные блоки памяти как "живые",
     * а затем отзывает свободное пространство.  Для этого действа может
     * потребоваться приостановка всех запущенных нитей, как  минимум,
	  * для соответствующей части процесса сборки.
	  */
    static void collect()
    {
        gc_collect();
    }

    /**
     * Указывает на то, что можно уменьшить обрабатываемое пространство
	 * памяти путём возврата свободной физической памяти операционной системе.
	 * Количество возвращаемой свободной памяти зависит от
     * дизайна разместителя и от поведения программы.
     */
    static void minimize()
    {
        gc_minimize();
    }


    /**
     * Элементы бит-поля, представляющего атрибуты блока памяти. Ими
     * можно манипулировать функциями getAttr, setAttr, clrAttr.
     */
    enum BlkAttr : uint
    {
        FINALIZE = 0b0000_0001, /// Финализовать данные этого блока при сборке.
        NO_SCAN  = 0b0000_0010, /// Не сканировать при сборке данный блок.
        NO_MOVE  = 0b0000_0100  /// Не перемещать данный блок при сборке.
    }


    /**
     * Содержит инфоагрегат о блоке управляемой памяти. Назначение этой
     * структуры заключается в поддержке более эффективного стиля опроса
     * в тех экземплярах, где требуется более подробная информация.
     *
     * base = Указатель на основание опрашиваемого блока.
     * size = Размер блока, вычисляемый от основания.
     * attr = Биты установленных на блоке памяти атрибутов.
     */
    alias BlkInfo_ BlkInfo;


    /**
     * Возвращает бит-поле, представляющее собой все атрибуты блока, установленные для
	 * памяти, на которую ссылается p. Если p ссылается на пямять, изначально распределенную
	 * не этим мусоросборщиком, то указывает на внутренности блока памяти, или если if p
     * нулевой, возвращает ноль.
     *
     * Параметры:
     *  p = Указатель на корень действительного блока памяти или на null.
     *
     * Возвращает:
     *  Бит-поле, содержащее какие-либо биты, установленные для блока памяти, на который
	 * указывает  p, или ноль при ошибке.
     */
    static uint getAttr( void* p )
    {
        return gc_getAttr( p );
    }


    /**
     * Sets the specified bits for the memory references by p.  If p references
     * memory not originally allocated by this garbage collector, points to the
     * interior of a memory block, or if p is null, no action will be performed.
     *
     * Параметры:
     *  p = A pointer to the root of a valid memory block or to null.
     *  a = A bit field containing any bits to set for this memory block.
     *
     *  The result of a call to getAttr after the specified bits have been
     *  set.
     */
    static uint setAttr( void* p, uint a )
    {
        return gc_setAttr( p, a );
    }


    /**
     * Clears the specified bits for the memory references by p.  If p
     * references memory not originally allocated by this garbage collector,
     * points to the interior of a memory block, or if p is null, no action
     * will be performed.
     *
     * Параметры:
     *  p = A pointer to the root of a valid memory block or to null.
     *  a = A bit field containing any bits to clear for this memory block.
     *
     * Возвращает:
     *  The result of a call to getAttr after the specified bits have been
     *  cleared.
     */
    static uint clrAttr( void* p, uint a )
    {
        return gc_clrAttr( p, a );
    }


    /**
     * Запрашивает размеченный блок управляемой памяти у мусоросборщика.
     * Эту память при желании можно удалить, вызвав free, либо её можно
     * сбросить и освободить автоматически, при пуске очистки. Если
     * распределение неудачно, то эта функция вызывает onOutOfMemory,
     * от которого ожидается вывод OutOfMemoryException.
     *
     * Параметры:
     *  sz = Желаемый размер размещения в байтах.
     *  ba = Битмаска атрибутов, для установки на данном блоке.
     *
     * Возвращает:
     *  Ссылку на распределенную память или null, если памяти
     *  недостаточно.
     *
     * Выводит:
     *  OutOfMemoryException при неудачном распределении.
     */
    static void* malloc( size_t sz, uint ba = 0 )
    {
        return gc_malloc( sz, ba );
    }


    /**
     * Requests an aligned block of managed memory from the garbage collector,
     * which is initialized with all bits set to zero.  This memory may be
     * deleted at will with a call to free, or it may be discarded and cleaned
     * up automatically during a collection run.  If allocation fails, this
     * function will call onOutOfMemory which is expected to throw an
     * OutOfMemoryException.
     *
     * Параметры:
     *  sz = The desired allocation size in bytes.
     *  ba = A bitmask of the attributes to set on this block.
     *
     * Возвращает:
     *  A reference to the allocated memory or null if insufficient memory
     *  is available.
     *
     * Выводит:
     *  OutOfMemoryException on allocation failure.
     */
    static void* calloc( size_t sz, uint ba = 0 )
    {
        return gc_calloc( sz, ba );
    }


    /**
     * Если sz равно нулю, то память, на которую указывает p, будет освобождена,
     * как это бывает при вызове free.  Затем новый блок памяти размером в sz
	 * будет распределен, как это бывает при вызове malloc, либо вместо этого
	 * реализация может на месте изменить блок в размере. Содержимое нового
     * блока памяти будет таким же, как у старого блока, до наименьшего общего
     * между новым и старым размерами. Запомните, что существующая память будет
     * освобождена только, если sz равно нулю. Впоследствии от сборщика мусора
     * ожидается отзыв этого блока памяти, если он более не используется.
     * Если распределение не удалось, эта функция вызывает onOutOfMemory,
	 * от которого ожидается вывод исключения OutOfMemoryException.Если же p
	  * указывает на память, ранее размещенную не этим мусоросборщиком, 
	  * либо если он указывает вовнутрь блока памяти, никакого действия
	  * не предпринимается. Если ba равно нулю (по умолчанию),
	  * а p указывает на главу действительного, известного блока памяти,
     * тогда все биты, установленные на текущем блоке, будут перенесены на новый блок,
	 * если потребуется перемещение. Если ba не равно нулю, а p указывает на
     * главу действительного, известного блока памяти, тогда биты из ba заменят
     * биты в текущем блоке памяти, а также будут установлены на новом блоке,
     * если понадобится перемещение.
     *
     * Параметры:
     *  p  = Указатель на корень действительного блока памяти или на null.
     *  sz = Необходимый размер размещения в байтах.
     *  ba = Бит-маска атрибутов, которые нужно установить на данном блоке.
     *
     * Возвращает:
     *  Ссылку на размещенную память при успехе, либо null, если sz равно
     *  нулю. При неудаче возвращается исходное значение p.
     *
     * Выводит:
     *  OutOfMemoryException при неудачном размещении.
     */
    static void* realloc( void* p, size_t sz, uint ba = 0 )
    {
        return gc_realloc( p, sz, ba );
    }


    /**
     * Запрашивает, чтобы блок управляемой памяти,  на который ссылается p,
	 * был увеличен на месте, как минимум на mx байт, с желательным расширением на
	 * sz байт. Если расширение требуемой памяти невозможно,
     * и p ссылается на память, ранее размещенную другим сборщиком,
	 * либо же p указывает внутрь блока память,
	 * то никаких действий не предпринимается.
     *
     * Параметры:
     *  mx = The minimum extension size in bytes.
     *  sz = The  desired extension size in bytes.
     *
     * Возвращает:
     *  The size in bytes of the extended memory block referenced by p or zero
     *  if no extension occurred.
     */
    static size_t extend( void* p, size_t mx, size_t sz )
    {
        return gc_extend( p, mx, sz );
    }


    /**
     * Запрашивает получение от операционной системы как минимум sz байтов
     * с пометкой их как "свободные".
     *
     * Параметры:
     *  sz = Требуемый размер в байтах.
     *
     * Возвращает:
     *  Действительное число размещенных байтов или ноль при ошибке.
     */
    static size_t reserve( size_t sz )
    {
        return gc_reserve( sz );
    }


    /**
     * Вымещает память, на которую показывает p.  Если p равен нулю, никаких
     * действий не предпринимается. Если p ссылается на память, ранее размещенную другим
	 * мусоросборщиком, или он указывает внутрь блока памяти,
     * действий не последует. Этот блок останется не финализированным, несмотря на то,
	 * установлен или нет атрибут FINALIZE. Если требуется финализация,
     * то следует использовать delete.
     *
     * Параметры:
     *  p = A pointer to the root of a valid memory block or to null.
     */
    static void free( void* p )
    {
        gc_free( p );
    }


    /**
     * Returns the base address of the memory block containing p.  This value
     * is useful to determine whether p is an interior pointer, and the result
     * may be passed to routines such as sizeOf which may otherwise fail.  If p
     * references memory not originally allocated by this garbage collector, if
     * p is null, or if the garbage collector does not support this operation,
     * null will be returned.
     *
     * Параметры:
     *  p = A pointer to the root or the interior of a valid memory block or to
     *      null.
     *
     * Возвращает:
     *  The base address of the memory block referenced by p or null on error.
     */
    static void* addrOf( void* p )
    {
        return gc_addrOf( p );
    }


    /**
     * Returns the true size of the memory block referenced by p.  This value
     * represents the maximum number of bytes for which a call to realloc may
     * resize the existing block in place.  If p references memory not
     * originally allocated by this garbage collector, points to the interior
     * of a memory block, or if p is null, zero will be returned.
     *
     * Параметры:
     *  p = A pointer to the root of a valid memory block or to null.
     *
     * Возвращает:
     *  The size in bytes of the memory block referenced by p or zero on error.
     */
    static size_t sizeOf( void* p )
    {
        return gc_sizeOf( p );
    }


    /**
     * Returns aggregate information about the memory block containing p.  If p
     * references memory not originally allocated by this garbage collector, if
     * p is null, or if the garbage collector does not support this operation,
     * BlkInfo.init will be returned.  Typically, support for this operation
     * is dependent on support for addrOf.
     *
     * Параметры:
     *  p = A pointer to the root or the interior of a valid memory block or to
     *      null.
     *
     * Возвращает:
     *  Information regarding the memory block referenced by p or BlkInfo.init
     *  on error.
     */
    static BlkInfo query( void* p )
    {
        return gc_query( p );
    }


    /**
     * Adds the memory address referenced by p to an internal list of roots to
     * be scanned during a collection.  If p is null, no operation is
     * performed.
     *
     * Параметры:
     *  p = A pointer to a valid memory address or to null.
     */
    static void addRoot( void* p )
    {
        gc_addRoot( p );
    }


    /**
     * Adds the memory block referenced by p and of size sz to an internal list
     * of ranges to be scanned during a collection.  If p is null, no operation
     * is performed.
     *
     * Параметры:
     *  p  = A pointer to a valid memory address or to null.
     *  sz = The size in bytes of the block to add.  If sz is zero then the
     *       no operation will occur.  If p is null then sz must be zero.
     */
    static void addRange( void* p, size_t sz )
    {
        gc_addRange( p, sz );
    }


    /**
     * Removes the memory block referenced by p from an internal list of roots
     * to be scanned during a collection.  If p is null or does not represent
     * a value previously passed to add(void*) then no operation is performed.
     *
     *  p  = A pointer to a valid memory address or to null.
     */
    static void removeRoot( void* p )
    {
        gc_removeRoot( p );
    }


    /**
     * Removes the memory block referenced by p from an internal list of ranges
     * to be scanned during a collection.  If p is null or does not represent
     * a value previously passed to add(void*, size_t) then no operation is
     * performed.
     *
     * Параметры:
     *  p  = A pointer to a valid memory address or to null.
     */
    static void removeRange( void* p )
    {
        gc_removeRange( p );
    }
    
    /**
     * Removes the memory block referenced by p from an internal list of ranges
     * to be scanned during a collection.  If p is null or does not represent
     * a value previously passed to add(void*, size_t) then no operation is
     * performed.
     *
     * Параметры:
     *  p  = A pointer to a valid memory address or to null.
     */
    static void monitor( void delegate() begin, void delegate(int, int) end )
    {
        gc_monitor( begin, end );
    }
    

    /**
     * Create a weak pointer to the given object.
     * Returns a pointer to an opaque struct allocated in C memory.
     */
    static void* weakPointerCreate( Object o )
    {
        return gc_weakpointerCreate (o);
    }


    /**
     * Destroy a weak pointer returned by weakpointerCreate().
     * If null is passed, nothing happens.
     */
    static void weakPointerDestroy( void* p )
    {
        return gc_weakpointerDestroy (p);
    }


    /**
     * Query a weak pointer and return either the object passed to
     * weakpointerCreate, or null if it was free'd in the meantime.
     * If null is passed, null is returned.
     */
    static Object weakPointerGet( void* p )
    {
        return gc_weakpointerGet (p);
    }


    /**
    * returns the amount to allocate to keep some extra space
    * for large allocations the extra allocated space decreases, but is still enough
    * so that the number of reallocations when linearly growing stays logaritmic
    * Параметры:
    * newlength = the number of elements to allocate
    * elSize = size of one element
    */
    static size_t growLength (size_t newlength, size_t elSize=1)
    {   
        return growLength (newlength, elSize, 100, 0, 1);
    }
    

    /**
    * returns the amount to allocate to keep some extra space
    * for large allocations the extra allocated space decreases, but is still enough
    * so that the number of reallocations when linearly growing stays logaritmic
    * Параметры:
    * newlength = the number of elements to allocate
    * elSize = size of one element
    * a = maximum extra space in percent (the allocated space gets rounded up, so might be larger)
    * b = flatness factor, how fast the extra space decreases with array size (the larger the more constant)
    * minBits = minimum number of bits of newlength
    */
    static size_t growLength (size_t newlength, size_t elSize, size_t a, size_t b=0, size_t minBits=1)
    {
        static size_t log2(size_t c)
        {
            // could use the bsr bit op
            size_t i=1;
            while(c >>= 1)
                  ++i;
            return i;
        }

        size_t newext = 0;
        size_t newcap = newlength*elSize;
        long mult = 100 + a*(minBits+b) / (log2(newlength)+b);
        newext = elSize*cast(size_t)(((newcap * mult)+99) / 100);
        newcap = newext > newcap ? newext : newcap; // just to handle overflows
        return newcap;
    }
}
