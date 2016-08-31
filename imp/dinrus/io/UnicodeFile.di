module io.UnicodeFile;

private import io.device.File;
public  import text.convert.UnicodeBom;

class ФайлЮ(T)
{
        private ЮникодМПБ!(T)  bom_;
        private ткст          path_;

        
        this (ткст путь, Кодировка кодировка)
        {
                bom_ = new ЮникодМПБ!(T)(кодировка);
                path_ = путь;
        }

        static ФайлЮ opCall (ткст имя, Кодировка кодировка)
        {
                return new ФайлЮ (имя, кодировка);
        }

        ткст вТкст ()
        {
                return path_;
        }

        Кодировка кодировка ()
        {
                return bom_.кодировка;
        }

        ЮникодМПБ!(T) мпб ()
        {
                return bom_;
        }

        final T[] читай ()
        {
                auto контент = Файл.получи (path_);
                return bom_.раскодируй (контент);
        }


        final проц пиши (T[] контент, бул писатьМПБ)
        {       
                // преобразуй в_ external representation (may throw an exeption)
                проц[] преобразованый = bom_.кодируй (контент);

                // открой файл after conversion ~ in case of exceptions
                scope провод = new Файл (path_, Файл.ЧитЗапСозд);  
                scope (exit)
                       провод.закрой;

                if (писатьМПБ)
                    провод.пиши (bom_.сигнатура);

                // and пиши
                провод.пиши (преобразованый);
        }


        final проц добавь (T[] контент)
        {
                // преобразуй в_ external representation (may throw an исключение)
                Файл.добавь (path_, bom_.кодируй (контент));
        }
}
