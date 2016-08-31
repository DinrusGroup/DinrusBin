/******************************************************************************* 

	Serializer abstracts serialization of any data type. 

	Authors:       ArcLib team, see AUTHORS file 
	Maintainer:    Clay Smith (clayasaurus at gmail dot com) 
	License:       zlib/libpng license: $(LICENSE) 
	Copyright:      ArcLib team 

	Description:    
		Serializer abstracts serialization of any data type. Simplifies
		saving and loading of a file.

	Examples:      
	---------------------
	
	Serializer.registerClass!(A)();
	Serializer.registerClass!(B)();
	Serializer.registerClassConstructor!(C)({ return new C(0); });
	
	S sv, svr;
	sv.a = 3;
	sv.b = 2;
	
	A av = new A, avr;
	av.a = 99;
	
	B bv = new B, bvr;
	bv.a = 12;
	bv.b = 99999;
	
	A b_in_av = bv, b_in_avr;
	A b_in_a_notrackv = bv, b_in_a_notrackvr;
	
	C cv = new C(3), cvr;

	{
		Serializer s = new Serializer("class_struct_unittest", FileMode.Out);
			
		s.describe(sv);
		s.describe(av);
		s.describe(bv);
		s.describe(b_in_av);
		s.describe(b_in_a_notrackv, Serializer.Tracking.Off);
		s.describe(cv);
		
		delete s;
	}

	{
		Serializer s = new Serializer("class_struct_unittest", FileMode.In);
		
		s.describe(svr);
		s.describe(avr);
		s.describe(bvr);
		s.describe(b_in_avr);
		s.describe(b_in_a_notrackvr, Serializer.Tracking.Off);
		s.describe(cvr);
		
		delete s;
	}

	---------------------

*******************************************************************************/

module arc.serialization.serializer; 

import 
	arc.serialization.basicarchive,
	arc.serialization.classregister,
	arc.types;

import 
	std.stream;
	
debug import 
	std.io,
	std.gc;

//TODO-FEATURE: Allow for non-intrusive out-of-class/struct describe functions. How?
//TODO-FIX: Exception safety. Currently the Exceptions destroy BasicArchive's internal state

/*******************************************************************************

	Simplifies saving and loading to a file

*******************************************************************************/
class Serializer
{
public:
	/// open file with given name and filemode (FileMode.In or FileMode.Out)
	this(char[] argFileName, FileMode mode)
	{
			// serializer doesn't work with filemodes besides these two
			assert(mode == FileMode.In || mode == FileMode.Out, "Serializer.open only works with FileMode.In and FileMode.Out"); 
			if(mode == FileMode.In)
				write_or_read = WriteRead.Read;
			else if(mode == FileMode.Out)
				write_or_read = WriteRead.Write;
			
			file = new File(argFileName, mode); 
	}
	
	~this()
	{
		//delete file;
	}
	
	mixin TBasicArchive!(Serializer);	

private:
	/// write data as array of bytes
	void describe_primitive(T)(inout T x)
	{
		if (file.readable) 
		{
			ubyte* ptr = cast(ubyte*)&x;
			file.read(ptr[0 .. x.sizeof]);
		} 
		else
		{
			ubyte* ptr = cast(ubyte*)&x;
			file.write(ptr[0 .. x.sizeof]);
		}
	}

private:
	/// filestream
	File file;	
}



version (build) {
    debug {
        pragma(link, "arc");
    } else {
        pragma(link, "arc");
    }
}
