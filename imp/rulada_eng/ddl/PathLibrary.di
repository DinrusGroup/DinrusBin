module ddl.PathLibrary;

private import ddl.DynamicLibrary;
private import ddl.DynamicModule;
private import ddl.LoaderRegistry;
private import ddl.Linker;
private import ddl.Demangle;
private import ddl.Attributes;
private import ddl.ExportSymbol;
private import ddl.Utils;

private import mango.io.FileScan;
private import mango.io.File;
private import mango.io.FilePath;
private import mango.io.FileConduit;
private import mango.text.Text;

private import std.ctype : isdigit;
private import std.string : rfind;
private import std.path : joinPaths = join;
private import std.file : isFile = isfile, fileExists = exists;
   

//TODO: insensitive to file time/date changes
//TODO: use delegate pass-forward to eliminate double-looping with processing file listings
class PathLibrary : DynamicLibrary{
   LoaderRegistry loaderRegistry;
   DynamicLibrary[] rootLibraries;
   DynamicLibrary[char[]] cachedLibraries; // libraries by namespace
   Attributes attributes;
   FilePath root;
   protected char[] delegate(char[])[]   namespaceTranslators;
      
   void addNamespaceTranslator(char[] delegate(char[]) dg);   
   
   debug protected void debugPathList(char[] prompt,FilePath[] list);
   
   protected FilePath[] getRootFiles();
   
   protected FilePath[] getFiles(char[] subDirectory);
   
   protected FilePath[] getAllFiles();
   
   protected char[] convertPathToNamespace(char[] path);
   
   protected char[] convertNamespaceToPath(char[] namespace);   
   
   private static bool dSymbolStripType(char[] s, inout char[] res);   
   
   private static char[] parseNamespace(char[] symbolName) ;   
   
   private static char[] getParentNamespace(char[] name);
   
   public this(char[] rootPath,LoaderRegistry loaderRegistry, bool preloadRootLibs = true);
   
   public ExportSymbolPtr getSymbol(char[] name);
   
   public ExportSymbol[] getSymbols();
      
   public DynamicModule[] getModules();
   
   public char[] getType();
   
   public char[][char[]] getAttributes();

   public DynamicModule getModuleForSymbol(char[] name);
   // expects resource in file-path format
   public ubyte[] getResource(char[] name);
}
