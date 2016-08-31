module ddl.FileBuffer;

private import mango.io.Buffer;
private import mango.io.FileConduit;

private import mango.io.model.IBuffer;
private import mango.io.model.IConduit;

/**
	Gives the basic Mango buffer class some additional information about its origin.
*/
//TODO: should this pre-buffer the entire file into memory first?
class FileBuffer: Buffer{
	FilePath path;
	
	public this(char[] path, FileStyle.Bits style = FileStyle.ReadExisting){
		this.path = new FilePath(path);
		super(new FileConduit(this.path,style));
	}
	
	public this(FilePath path, FileStyle.Bits style = FileStyle.ReadExisting){
		super(new FileConduit(path,style));
		this.path = path;
	}
	
	public this(FilePath path,void[] data){
		super(data,data.length);
		this.path = path;
	}
	
	public this(char[] path,void[] data){
		super(data,data.length);
		this.path = new FilePath(path);
	}	
	
	public this(IConduit conduit,FilePath path){
		super(conduit);
		this.path = path;
	}
	
	public this(FileConduit file){
		super(file);
		this.path = file.getPath;
	}
	
	public FilePath getPath();
	
	public IBuffer.Style getStyle();
}
