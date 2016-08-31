module io.device.BitBucket;

private import io.device.Conduit;



class Битник : Провод
{
        override ткст вТкст ();
        override т_мера размерБуфера ();
        override т_мера читай (проц[] приёмн);
        override т_мера пиши (проц[] ист);
        override проц открепи ();
}