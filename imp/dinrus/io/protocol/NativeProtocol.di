module io.protocol.NativeProtocol;

private import  io.Buffer;
private import  io.protocol.model;



class ПротоколНатив : ИПротокол
{
        protected бул          prefix_;
        protected ИБуфер       buffer_;

        this (ИПровод провод, бул префикс=да);
        ИБуфер буфер ();
        проц[] читай (ук приёмн, бцел байты, Тип тип);
        проц пиши (ук ист, бцел байты, Тип тип);
        проц[] читайМассив (ук приёмн, бцел байты, Тип тип, Разместитель размести);
        проц пишиМассив (ук ист, бцел байты, Тип тип);
}
