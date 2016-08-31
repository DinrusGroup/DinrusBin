module io.FileSystem;

private import sys.Common, io.FilePath, exception, io.Path : стандарт, исконный;


struct ФСистема
{
        deprecated static ФПуть вАбсолют (ФПуть мишень, ткст префикс=пусто);
        deprecated static ткст вАбсолют (ткст путь, ткст префикс=пусто);
        deprecated static бул равно (ткст path1, ткст path2, ткст префикс=пусто);
        private static проц исключение (ткст сооб);

        version (Windows)
        {

                version (Win32SansUnicode)
                {
                        private static проц путьВиндовс(ткст путь, ref ткст результат);
                }
                else
                {
                        private static проц путьВиндовс(ткст путь, ref шим[] результат);
                }

                deprecated static проц установиПапку (ткст путь);
                deprecated static ткст дайПапку ();
                static ткст[] корни ();
                static дол свободноеМесто(ткст папка, бул superuser = нет);
                static бдол всегоМеста(ткст папка, бул superuser = нет);
        }

        version (Posix)
        {

                deprecated static проц установиПапку (ткст путь);
                deprecated static ткст дайПапку ();
                static ткст[] корни ();
                static дол свободноеМесто(ткст папка, бул superuser = нет);
                static дол всегоМеста(ткст папка, бул superuser = нет);
        }
}