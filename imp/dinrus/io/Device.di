module io.device.Device;

private import  dinrus;
public  import  io.device.Conduit;

extern(D):

class Устройство : Провод, ИВыбираемый
{
        public alias Провод.ошибка ошибка;
            
        final проц ошибка ();
        override ткст вТкст ();
        override т_мера размерБуфера ();
        version (Win32)
        {
                struct ВВ
                {
                        АСИНХРОН      асинх; // must be the first attribute!!
                        Дескр          указатель;
                        бул            след;
                        ук           задача;
                }

                protected ВВ вв;

                protected проц переоткрой (Дескр указатель);
                final Дескр фукз ();
                override проц вымести ();
                override проц открепи ();
                override т_мера читай (проц[] приёмн);
                override т_мера пиши (проц[] ист);
                final т_мера жди (Фибра.Планировщик.Тип тип, бцел байты, бцел таймаут);
        }

        version (Posix)
        {
                protected цел указатель = -1;
				
                protected проц переоткрой (Дескр указатель);
                final Дескр фукз ();
                override проц открепи ();
                override т_мера читай (проц[] приёмн);
                override т_мера пиши (проц[] ист);
        }
}
