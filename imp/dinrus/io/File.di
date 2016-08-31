module io.File;

private import Провод = io.device.File;


class Файл
{

        this (ткст путь);
        static Файл opCall (ткст путь);
        final проц[] читай ();
        final Файл пиши (проц[] контент);
        final Файл добавь (проц[] контент);
        private Файл пиши (проц[] контент, Провод.Файл.Стиль стиль);
}
