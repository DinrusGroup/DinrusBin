module io.vfs.FileFolder;

private import io.device.File;
private import Путь = io.Path;
private import exception;
public import io.vfs.model;
private import io.model;
private import time.Time : Время;


class ФайлПапка : ПапкаВфс
{
        private ткст          путь;
        private СтатсВфс        статс;

        this (ткст путь, бул создай=нет);
        private this (ткст путь, ткст имя);
        private this (ФайлПапка предок, ткст имя, бул создай=нет);
        final ткст имя ();
        final ткст вТкст ();
        final проц проверь (ПапкаВфс папка, бул mounting);
        final ФайлВфс файл (ткст имя);
        final ЗаписьПапкиВфс папка (ткст путь);
        final ПапкаВфс очисть ();
        final бул записываемый ();
        final ПапкиВфс сам ();
        final ПапкиВфс дерево ();
        final цел opApply (цел delegate(ref ПапкаВфс) дг);
        ПапкаВфс закрой (бул подай = да);
        private ФайлПапка[] папки (бул собери);
        private ткст[] файлы (ref СтатсВфс статс, ФильтрВфс фильтр = пусто);
        private ткст ошибка (ткст сооб);
        private ткст открой (ткст путь, бул создай);
}

class ГруппаФайлов : ФайлыВфс
{
        private ткст[]        группа;          // установи of filtered filenames
        private ткст[]        хосты;          // установи of containing папки
        private СтатсВфс        статс;          // статс for contained файлы

        this (ГруппаПапок хост, ФильтрВфс фильтр);
        final цел opApply (цел delegate(ref ФайлВфс) дг);
        final бцел файлы ();
        final бдол байты ();
}


private class ГруппаПапок : ПапкиВфс
{
        private ФайлПапка[] члены;           // папки in группа

        private this () {}
        private this (ФайлПапка корень, бул рекурсия);
        final цел opApply (цел delegate(ref ПапкаВфс) дг);
        final бцел файлы ();
        final бдол байты ();
        final бцел папки ();
        final бцел записи ();
        final ПапкиВфс поднабор (ткст образец);
        final ГруппаФайлов каталог (ткст образец);
        final ГруппаФайлов каталог (ФильтрВфс фильтр = пусто);
        private final ФайлПапка[] скан (ФайлПапка корень, бул рекурсия) ;
}

private class ХостПапки : ЗаписьПапкиВфс
{       
        private ткст          путь;
        private ФайлПапка      предок;

        private this (ФайлПапка предок, ткст путь);
        final ПапкаВфс создай ();
        final ПапкаВфс открой ();
        бул есть_ли ();
}

private class ХостФайла : ФайлВфс
{
        private Путь.ПутеПарсер путь;
		
        this (ткст путь = пусто);
        final ткст имя();
        final ткст вТкст ();
        final бул есть_ли();
        final бдол размер();
        final ФайлВфс создай ();
        final ФайлВфс создай (ИПотокВвода ввод);
        ФайлВфс копируй (ФайлВфс источник);
        final ФайлВфс перемести (ФайлВфс источник);
        final ИПотокВвода ввод ();
        final ИПотокВывода вывод ();
        final ФайлВфс удали ();
        final ФайлВфс dup();
        final Время изменён ();
}
