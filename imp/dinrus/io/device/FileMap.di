module io.device.FileMap;
private import io.device.File,
               io.device.Array;


class ФайлМэп : Массив
{
        private КартированныйФайл файл;

        this (ткст путь, Файл.Стиль стиль = Файл.ЧитЗапОткр);
        final ббайт[] перемерь (дол размер);
        override проц закрой ();
}

class КартированныйФайл
{
        private Файл хост;

        this (ткст путь, Файл.Стиль стиль = Файл.ЧитЗапОткр);
        final дол длина ();		alias длина length ;
        final ткст путь ();
        final ббайт[] перемерь (дол размер);

        version (Win32)
        {
                private ук    основа;            // Массив pointer
                private HANDLE  mmFile;          // mapped файл

                final ббайт[] карта();
                final проц закрой ();
                private проц сбрось ();
                КартированныйФайл слей ();
        }

        version (Posix)
        {               
                // Linux код: not yet tested on другой POSIX systems.
                private ук    основа;           // Массив pointer
                private т_мера  размер;           // length of файл

                final ббайт[] карта ();
                final проц закрой ();
                private проц сбрось ();
                final КартированныйФайл слей () ;
        }
}
