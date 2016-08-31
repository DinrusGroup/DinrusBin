module rae.canvas.rtree.Sort;

import rae.canvas.rtree.Comparator;

import tango.util.container.LinkedList;

//private import std.c.math;
/**
 * Static class used for providing static methods for sorting arrays of Objects, using
 * comparators. It is needed for jdk 1.1 compatibility.
 * <p>
 * Created: Fri Jul 02 18:42:36 1999
 * <p>
 * @author Hadjieleftheriou Marios
 * @version 1.0
 */


/*

void arraycopy(Object[] src, int src_low, Object[] dest, int dest_low, uint amount)
{
	if( src !is null )
	{
		int src_high = src_low + amount;
		int src_needs.size = src_high - src_low;
		int dest_high = dest_low + amount;
		int dest_needs.size = dest_high - dest_low;

		if( dest is null )
		{
			dest = src.dup;
		}

		if( src.size < src_needs.size )
		{
			src_high = src.size;
		}
		if( dest.size < dest_needs.size )
		{
			dest_high = dest.size;
		}

		src_high = std.c.math.fminf( src_high, dest_high );

		for( int i = src_low; i < src_high; i++ )
		{
			dest[i] = src[i];
		}
	}
}

unittest()
{
	bool is_equal( int[] sr, int[] ds )
	{
		if( sr !is null && ds !is null )
		{
			int smaller.size = std.c.math.fminf( sr.size, ds.size );
			for( uint i = 0; i < smaller.size; i++ )
			{
				if( sr[i] != ds[i] )
					return false;
			}
			return true;
		}
		//else
			return false;
	}

	int[] src = new int[5];
	src[0] = 8;
	src[1] = 4;
	src[2] = 2;
	src[3] = 5;
	src[4] = 9;

	int[] dest_uninited;
	int[] dest_inited = new int[5];
	arraycopy( src, 0, dest_uninited, 0, src.size );
	arraycopy( src, 0, dest_inited, 0, src.size );

	assert( is_equal( src, dest_uninited ) );
	assert( is_equal( src, dest_inited ) );

}*/

public class Sort
{

private this()
{
}

private static void mergeSort(Object[] src, Object[] dest,
		  int low, int high, Comparator c)
{
	int length = high - low;

	// Insertion sort on smallest arrays
	if( length < 7)
	{
		for (int i=low; i<high; i++)
			for (int j=i; j>low && c.compare(dest[j-1], dest[j])>0; j--)
				swap(dest, j, j-1);
		return;
	}

        // Recursively sort halves of dest into src
        int mid = (low + high)/2;
        mergeSort(dest, src, low, mid, c);
        mergeSort(dest, src, mid, high, c);

        // If list is already sorted, just copy from src to dest.  This is an
        // optimization that results in faster sorts for nearly ordered lists.
	if (c.compare(src[mid-1], src[mid]) <= 0)
	{
		//System.
		//arraycopy(src, low, dest, low,.size);
		dest[low..high] = src[low..high];
		return;
	}

		// Merge sorted halves (now in src) into dest
	for(int i = low, p = low, q = mid; i < high; i++)
	{
		if (q>=high || p<mid && c.compare(src[p], src[q]) <= 0)
			dest[i] = src[p++];
		else
			dest[i] = src[q++];
	}
}

private static void swap(Object x[], int a, int b)
{
	Object t = x[a];
	x[a] = x[b];
	x[b] = t;
}

public static void mergeSort(Object[] a, Comparator c)
{
	Object aux[] = cast(Object[])a.dup;//clone();
	mergeSort(aux, a, 0, a.length, c);
}

} // Sort


version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-rae");
        } else version (DigitalMars) {
            pragma(link, "DD-rae");
        } else {
            pragma(link, "DO-rae");
        }
    }
}
