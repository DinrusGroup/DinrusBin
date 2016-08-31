module io.vfs.LinkedFolder;


class LinkedFolder : ВиртуальнаяПапка
{
        private Link* голова;

        private struct Link
        {
                Link*     следщ;
                ПапкаВфс папка;

                static Link* opCall(ПапкаВфс папка);
        }

        this (ткст имя);
        final ХостВфс прикрепи (ПапкаВфс папка, ткст имя=пусто);
        final ХостВфс открепи (ПапкаВфс папка);
        final override ФайлВфс файл (ткст путь);
}