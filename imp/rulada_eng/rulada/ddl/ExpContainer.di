/**
	Array wrapper template that provides exponential reserve characteristics
	for tuning purposes.	
**/
module ddl.ExpContainer;

//import ddl.omf.OMFBinary;
/**
	Exponential reserve array template.
	
	At times, the memory reserve behavior of the GC can actually create a
	very large number of temporaries within the memory pool.  In such cases,
	overriding this behavior by creating an artifical reserve can yield 
	dramatic improvments in memory consumption and performance.
	
	This container is optimized for opCatAssign() operations, as it will
	attempt to store elements into its reserve space before reallocating.
	
	Reallocation is performed by doubling the size of the reserve array
	each time the reserve is exhausted.  Therefore, the developer must be
	very careful to only apply this container under small memory usage 
	scenarios.
	
	TODO: use malloc()/realloc() here instead of new/GC.
	TODO: set gc.scanRoot() for BaseType.sizeof >= ptr_t.sizeof
**/

struct ExpContainer(T){
	
	//auto b = T;
	alias T BaseType;//really it was typeof(T) BaseType, but it didn't compile 'cos of FIXUPP....
	alias T[] ArrayType;
	alias ExpContainer!(T) ContainerType;
	
	static DefaultReserve = 100;
	
	ArrayType data;
	uint len;
	
	public uint length();
	
	public void length(uint value);
	
	public void* ptr();
	
	public ArrayType all();

	public ArrayType dup();
	
	public void reserve(uint length);
	
	public ContainerType opCatAssign(BaseType elem);
	
	public ContainerType opCat(BaseType elem);
	
	public ContainerType opSlice(uint start,uint end);
	
	public BaseType opIndex(uint idx);

	public int opApply(int delegate(inout int,inout BaseType) dg);
	
	public int opApply(int delegate(inout BaseType) dg);
}

