module io.device.TempFile;

import Путь = io.Path;
import math.random.Kiss : Kiss;
import io.device.Device : Устройство;
import io.device.File;



class ВремФайл : Файл
{
    
    enum ОпцУдаления : ббайт
    {
        ВКорзину,
        Навсегда
    }

    align(1) struct СтильВремфл
    {
        //Visibility visibility;      ///
        ОпцУдаления удаление;        ///
        //Sensitivity sensitivity;    ///
        //Общ совместно;                ///
        //Кэш кэш;                ///
        ббайт попытки = 10;          ///
    }

    static const СтильВремфл ВКорзину = {ОпцУдаления.ВКорзину};
    static const СтильВремфл Навсегда = {ОпцУдаления.Навсегда};

    private ткст _path;
    private СтильВремфл _style;

    this(СтильВремфл стиль = СтильВремфл.init);
    this(ткст префикс, СтильВремфл стиль = СтильВремфл.init);
    СтильВремфл стильВремфл();
    private проц открой (СтильВремфл стиль);
    private проц открой (ткст префикс, СтильВремфл стиль);

    version( Win32 )
    {

    public static ткст времфлПуть();
    private бул окройВремфл(ткст путь, СтильВремфл стиль)    ;
    }
    else version( Posix )
    {

        public static ткст времфлПуть();
        private бул окройВремфл(ткст путь, СтильВремфл стиль);
    }
    else
    {
        static assert(нет, "Unsupported platform");
    }

   // private ткст randomName(бцел length=DEFAULT_LENGTH,
         //   ткст префикс=DEFAULT_PREFIX,
          //  ткст суффикс=DEFAULT_SUFFIX);
    
    override проц открепи();
}
