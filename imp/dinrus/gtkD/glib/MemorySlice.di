/*
 * This file is part of gtkD.
 *
 * gtkD is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2.1 of the License, or
 * (at your option) any later version.
 *
 * gtkD is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with gtkD; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
 
// generated automatically - do not change
// find conversion definition on APILookup.txt
// implement new conversion functionalities on the wrap.utils pakage

/*
 * Conversion parameters:
 * inFile  = glib-Memory-Slices.html
 * outPack = glib
 * outFile = MemorySlice
 * strct   = 
 * realStrct=
 * ctorStrct=
 * clss    = MemorySlice
 * interf  = 
 * class Code: No
 * interface Code: No
 * template for:
 * extend  = 
 * implements:
 * prefixes:
 * 	- g_slice_
 * omit structs:
 * omit prefixes:
 * omit code:
 * omit signals:
 * imports:
 * structWrap:
 * module aliases:
 * local aliases:
 * overrides:
 */

module gtkD.glib.MemorySlice;

public  import gtkD.gtkc.glibtypes;

private import gtkD.gtkc.glib;
private import gtkD.glib.ConstructionException;






/**
 * Description
 * Memory slices provide a space-efficient and multi-processing scalable
 * way to allocate equal-sized pieces of memory, just like the original
 * GMemChunks (from GLib <= 2.8), while avoiding their excessive
 * memory-waste, scalability and performance problems.
 * To achieve these goals, the slice allocator uses a sophisticated,
 * layered design that has been inspired by Bonwick's slab allocator
 * [6].
 * It uses posix_memalign() to optimize allocations of many equally-sized
 * chunks, and has per-thread free lists (the so-called magazine layer)
 * to quickly satisfy allocation requests of already known structure sizes.
 * This is accompanied by extra caching logic to keep freed memory around
 * for some time before returning it to the system. Memory that is unused
 * due to alignment constraints is used for cache colorization (random
 * distribution of chunk addresses) to improve CPU cache utilization. The
 * caching layer of the slice allocator adapts itself to high lock contention
 * to improve scalability.
 * The slice allocator can allocate blocks as small as two pointers, and
 * unlike malloc(), it does not reserve extra space per block. For large block
 * sizes, g_slice_new() and g_slice_alloc() will automatically delegate to the
 * system malloc() implementation. For newly written code it is recommended
 * to use the new g_slice API instead of g_malloc() and
 * friends, as long as objects are not resized during their lifetime and the
 * object size used at allocation time is still available when freeing.
 * Example 15. Using the slice allocator
 *  gchar *mem[10000];
 *  gint i;
 *  /+* Allocate 10000 blocks. +/
 *  for (i = 0; i < 10000; i++)
 *  {
	 *  mem[i] = g_slice_alloc (50);
	 *  /+* Fill in the memory with some junk. +/
	 *  for (j = 0; j < 50; j++)
	 * 	mem[i][j] = i * j;
 *  }
 *  /+* Now free all of the blocks. +/
 *  for (i = 0; i < 10000; i++)
 *  {
	 *  g_slice_free1 (50, mem[i]);
 *  }
 * Example 16. Using the slice allocator with data structures
 *  GRealArray *array;
 *  /+* Allocate one block, using the g_slice_new() macro. +/
 *  array = g_slice_new (GRealArray);
 *  /+* We can now use array just like a normal pointer to a structure. +/
 *  array->data = NULL;
 *  array->len = 0;
 *  array->alloc = 0;
 *  array->zero_terminated = (zero_terminated ? 1 : 0);
 *  array->clear = (clear ? 1 : 0);
 *  array->elt_size = elt_size;
 *  /+* We can free the block, so it can be reused. +/
 *  g_slice_free (GRealArray, array);
 */
public class MemorySlice
{
	
	/**
	 */
	
	/**
	 * Allocates a block of memory from the slice allocator.
	 * The block adress handed out can be expected to be aligned
	 * to at least 1 * sizeof (void*),
	 * though in general slices are 2 * sizeof (void*) bytes aligned,
	 * if a malloc() fallback implementation is used instead,
	 * the alignment may be reduced in a libc dependent fashion.
	 * Note that the underlying slice allocation mechanism can
	 * be changed with the G_SLICE=always-malloc
	 * environment variable.
	 * Since 2.10
	 * Params:
	 * blockSize = the number of bytes to allocate
	 * Returns:a pointer to the allocated memory block
	 */
	public static void* alloc(uint blockSize)
	{
		// gpointer g_slice_alloc (gsize block_size);
		return g_slice_alloc(blockSize);
	}
	
	/**
	 * Allocates a block of memory via g_slice_alloc()
	 * and initialize the returned memory to 0.
	 * Note that the underlying slice allocation mechanism can
	 * be changed with the G_SLICE=always-malloc
	 * environment variable.
	 * Since 2.10
	 * Params:
	 * blockSize = the number of bytes to allocate
	 * Returns:a pointer to the allocated block
	 */
	public static void* alloc0(uint blockSize)
	{
		// gpointer g_slice_alloc0 (gsize block_size);
		return g_slice_alloc0(blockSize);
	}
	
	/**
	 * Allocates a block of memory from the slice allocator and copies
	 * block_size bytes into it from mem_block.
	 * Since 2.14
	 * Params:
	 * blockSize = the number of bytes to allocate
	 * memBlock = the memory to copy
	 * Returns:a pointer to the allocated memory block
	 */
	public static void* copy(uint blockSize, void* memBlock)
	{
		// gpointer g_slice_copy (gsize block_size,  gconstpointer mem_block);
		return g_slice_copy(blockSize, memBlock);
	}
	
	/**
	 * Frees a block of memory. The memory must have been allocated via
	 * g_slice_alloc() or g_slice_alloc0()
	 * and the block_size has to match the size specified upon allocation.
	 * Note that the exact release behaviour can be changed with the
	 * G_DEBUG=gc-friendly environment variable,
	 * also see G_SLICE for related debugging options.
	 * Since 2.10
	 * Params:
	 * blockSize = the size of the block
	 * memBlock = a pointer to the block to free
	 */
	public static void free1(uint blockSize, void* memBlock)
	{
		// void g_slice_free1 (gsize block_size,  gpointer mem_block);
		g_slice_free1(blockSize, memBlock);
	}
	
	/**
	 * Frees a linked list of memory blocks of structure type type.
	 * The memory blocks must be equal-sized, allocated via
	 * g_slice_alloc() or g_slice_alloc0()
	 * and linked together by a next pointer (similar to GSList). The offset
	 * of the next field in each block is passed as third argument.
	 * Note that the exact release behaviour can be changed with the
	 * G_DEBUG=gc-friendly environment variable,
	 * also see G_SLICE for related debugging options.
	 * Since 2.10
	 * Params:
	 * blockSize = the size of the blocks
	 * memChain =  a pointer to the first block of the chain
	 * nextOffset = the offset of the next field in the blocks
	 */
	public static void freeChainWithOffset(uint blockSize, void* memChain, uint nextOffset)
	{
		// void g_slice_free_chain_with_offset (gsize block_size,  gpointer mem_chain,  gsize next_offset);
		g_slice_free_chain_with_offset(blockSize, memChain, nextOffset);
	}
}

version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-glib");
        } else version (DigitalMars) {
            pragma(link, "DD-glib");
        } else {
            pragma(link, "DO-glib");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-glib");
        } else version (DigitalMars) {
            pragma(link, "DD-glib");
        } else {
            pragma(link, "DO-glib");
        }
    }
}
