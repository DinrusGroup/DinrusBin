/**
 * This module contains all functions related to an object's lifetime:
 * allocation, resizing, deallocation, and finalization.
 *
 * Copyright: Copyright (C) 2004-2007 Digital Mars, www.digitalmars.com.
 *            All rights reserved.
 * License:
 *  This software is provided 'as-is', without any express or implied
 *  warranty. In no event will the authors be held liable for any damages
 *  arising from the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute it
 *  freely, in both source and binary form, subject to the following
 *  restrictions:
 *
 *  o  The origin of this software must not be misrepresented; you must not
 *     claim that you wrote the original software. If you use this software
 *     in a product, an acknowledgment in the product documentation would be
 *     appreciated but is not required.
 *  o  Altered source versions must be plainly marked as such, and must not
 *     be misrepresented as being the original software.
 *  o  This notice may not be removed or altered from any source
 *     distribution.
 * Authors:   Walter Bright, Sean Kelly
 */
module lifetime;

private
{
    import rt.core.stdc.stdlib;
    import rt.core.stdc.string;
    import rt.core.stdc.stdarg;
    debug(PRINTF) import rt.core.stdc.stdio;
}


private
{
    enum BlkAttr : uint
    {
        FINALIZE = 0b0000_0001,
        NO_SCAN  = 0b0000_0010,
        NO_MOVE  = 0b0000_0100,
        ALL_BITS = 0b1111_1111
    }

    struct BlkInfo
    {
        void*  base;
        size_t size;
        uint   attr;
    }

    extern (C) uint gc_getAttr( void* p );
    extern (C) uint gc_setAttr( void* p, uint a );
    extern (C) uint gc_clrAttr( void* p, uint a );

    extern (C) void*  gc_malloc( size_t sz, uint ba = 0 );
    extern (C) void*  gc_calloc( size_t sz, uint ba = 0 );
    extern (C) size_t gc_extend( void* p, size_t mx, size_t sz );
    extern (C) void   gc_free( void* p );

    extern (C) void*   gc_addrOf( void* p );
    extern (C) size_t  gc_sizeOf( void* p );
    extern (C) BlkInfo gc_query( void* p );

    extern (C) bool onCollectResource( Object o );
    extern (C) void onFinalizeError( ClassInfo c, Exception e );
    extern (C) void onOutOfMemoryError();

    extern (C) void _d_monitordelete(Object h, bool det = true);

    enum
    {
        PAGESIZE = 4096
    }
}


extern (C) Object _d_newclass(ClassInfo ci);
extern (C) void _d_delinterface(void** p);

// used for deletion
private extern (D) alias void (*fp_t)(Object);

extern (C) void _d_delclass(Object* p);
extern (C) ulong _d_newarrayT(TypeInfo ti, size_t length);
extern (C) ulong _d_newarrayiT(TypeInfo ti, size_t length);
extern (C) ulong _d_newarraymT(TypeInfo ti, int ndims, ...);
extern (C) ulong _d_newarraymiT(TypeInfo ti, int ndims, ...);

struct Array
{
    size_t length;
    byte*  data;
}

struct Array2
{
    size_t length;
    void*  ptr;
}

void* _d_allocmemory(size_t nbytes)
{
    return gc_malloc(nbytes);
}

extern (C) void _d_delarray(Array *p);
extern (C) void _d_delmemory(void* *p);
extern (C) void _d_callfinalizer(void* p);
extern (C) void rt_finalize(void* p, bool det = true);
extern (C) byte[] _d_arraysetlengthT(TypeInfo ti, size_t newlength, Array *p);
extern (C) byte[] _d_arraysetlengthiT(TypeInfo ti, size_t newlength, Array *p);
extern (C) long _d_arrayappendT(TypeInfo ti, Array *px, byte[] y);
extern (C) byte[] _d_arrayappendcT(TypeInfo ti, inout byte[] x, ...);
extern (C) byte[] _d_arraycatT(TypeInfo ti, byte[] x, byte[] y);
extern (C) byte[] _d_arraycatnT(TypeInfo ti, uint n, ...);
extern (C) void* _d_arrayliteralT(TypeInfo ti, size_t length, ...);
extern (C) long _adDupT(TypeInfo ti, Array2 a);


size_t newCapacity(size_t newlength, size_t size)
{
    version(none)
    {
        size_t newcap = newlength * size;
    }
    else
    {
        /*
         * Better version by Dave Fladebo:
         * This uses an inverse logorithmic algorithm to pre-allocate a bit more
         * space for larger arrays.
         * - Arrays smaller than PAGESIZE bytes are left as-is, so for the most
         * common cases, memory allocation is 1 to 1. The small overhead added
         * doesn't affect small array perf. (it's virtually the same as
         * current).
         * - Larger arrays have some space pre-allocated.
         * - As the arrays grow, the relative pre-allocated space shrinks.
         * - The logorithmic algorithm allocates relatively more space for
         * mid-size arrays, making it very fast for medium arrays (for
         * mid-to-large arrays, this turns out to be quite a bit faster than the
         * equivalent realloc() code in C, on Linux at least. Small arrays are
         * just as fast as GCC).
         * - Perhaps most importantly, overall memory usage and stress on the GC
         * is decreased significantly for demanding environments.
         */
        size_t newcap = newlength * size;
        size_t newext = 0;

        if (newcap > PAGESIZE)
        {
            //double mult2 = 1.0 + (size / log10(pow(newcap * 2.0,2.0)));

            // redo above line using only integer math

            static int log2plus1(size_t c)
            {   int i;

                if (c == 0)
                    i = -1;
                else
                    for (i = 1; c >>= 1; i++)
                    {
                    }
                return i;
            }

            /* The following setting for mult sets how much bigger
             * the new size will be over what is actually needed.
             * 100 means the same size, more means proportionally more.
             * More means faster but more memory consumption.
             */
            //long mult = 100 + (1000L * size) / (6 * log2plus1(newcap));
            long mult = 100 + (1000L * size) / log2plus1(newcap);

            // testing shows 1.02 for large arrays is about the point of diminishing return
            if (mult < 102)
                mult = 102;
            newext = cast(size_t)((newcap * mult) / 100);
            newext -= newext % size;
            debug(PRINTF) printf("mult: %2.2f, alloc: %2.2f\n",mult/100.0,newext / cast(double)size);
        }
        newcap = newext > newcap ? newext : newcap;
        debug(PRINTF) printf("newcap = %d, newlength = %d, size = %d\n", newcap, newlength, size);
    }
    return newcap;
}

