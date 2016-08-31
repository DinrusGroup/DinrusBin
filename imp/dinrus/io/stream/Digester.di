module io.stream.Digester;

private import io.device.Conduit;
private import util.digest.Digest;
import util.digest.Crc32 : Crc32;


class ДайджестВвод : ФильтрВвода , ФильтрВвода.Переключатель
{
        private Дайджест фильтр;
        
        this (ИПотокВвода поток, Дайджест дайджест);		
		this (ИПотокВвода поток, Crc32 дайджест);
        final override т_мера читай (проц[] приёмн);
        final ДайджестВвод slurp (проц[] приёмн = пусто);
        final Дайджест дайджест();
}

class ДайджестВывод : ФильтрВывода, ФильтрВвода.Переключатель
{
        private Дайджест фильтр;

        this (ИПотокВывода поток, Дайджест дайджест);
        final override т_мера пиши (проц[] ист);
        final Дайджест дайджест();
}

debug (DigestПоток)
{
        import io.Stdout;
        import io.device.Array;
        import util.digest.Md5;
        import io.device.File;

        проц main()
        {
                auto вывод = new ДайджестВывод(new Массив(1024, 1024), new Md5);
                вывод.копируй (new ФайлВвод("Digester.d"));

                Стдвыв.форматнс ("гекс дайджест:{}", вывод.дайджест.гексДайджест);
        }
}
