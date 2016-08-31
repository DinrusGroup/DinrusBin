module sys.Environment;
private import  io.Path,
                io.FilePath;




struct Среда
{
        public alias текрабпап дир;
		
        private static проц исключение (ткст сооб);
        static ткст вАбсолют(ткст путь);
        static ФПуть путьКЭкзэ (ткст файл);
        static ткст получи (ткст переменная, ткст def = пусто);
        static проц установи (ткст переменная, ткст значение = пусто);
        static ткст[ткст] получи ();
        static проц текрабпап (ткст путь);
        static ткст текрабпап ();

}
