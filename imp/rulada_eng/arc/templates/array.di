/******************************************************************************* 

	Useful template functions for arrays 

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:      ArcLib team 

	Description:    
		Useful template functions for arrays 

	Examples:      
	---------------------
		int[] arr;
		arr.length = 4;
		arr[3] = 3;
		
		if (arr.contains(3))
			is true; 
			
		arr.remove(3);
		
		if (arr.contains(3))
			is false; 
	---------------------

*******************************************************************************/

module arc.templates.array;

/// Array contains element 
bool contains(T)(inout T[] array, T element)
{
	foreach(inout e; array)
		if(e == element)
			return true;
	return false;
}

/// remove element form array 
void remove(T, U)(inout T[] array, U element)
{
	size_t index = 0;
	for(; index < array.length; ++index)
		if(array[index] == element)
			break;

	if(index == array.length)
		return;
		
	for(; index + 1 < array.length; ++index)
		array[index] = array[index + 1];
	
	array.length = array.length - 1;
	remove(array, element);
}

version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
