module io.FileSystem;

private import sys.Common, io.FilePath, exception, io.Path : стандарт, исконный;


struct ФСистема
{
        static ФПуть вАбсолют (ФПуть мишень, ткст префикс=пусто);
        static ткст вАбсолют (ткст путь, ткст префикс=пусто);
        static бул равно (ткст path1, ткст path2, ткст префикс=пусто);
        static проц установиПапку (ткст путь);
        static ткст дайПапку ();
        static ткст[] корни ();
        static дол свободноеМесто(ткст папка, бул superuser = нет);
        static бдол всегоМеста(ткст папка, бул superuser = нет);

}