module io.stream.DataFile;

private import io.device.File;
private import io.stream.Data;

class ВводФайлаДанных : ВводДанных
{
        private Файл провод;

        this (ткст путь, Файл.Стиль стиль = Файл.ЧитСущ);
        this (Файл файл);
        final Файл файл ();
}

class ВыводФайлаДанных : ВыводДанных
{
        private Файл провод;

        this (ткст путь, Файл.Стиль стиль = Файл.ЗапСозд);
        this (Файл файл);
        final Файл файл ();
}

debug (DataFile)
{
        import io.Stdout;

        проц main()
        {
                auto myFile = new ВыводФайлаДанных("Hello.txt");
                myFile.пиши("some текст");
                myFile.слей;
                Стдвыв.форматнс ("{}:{}", myFile.файл.позиция, myFile.сместись(myFile.Якорь.Тек));
        }
}
