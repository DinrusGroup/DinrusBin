module time.StopWatch;


public struct Секундомер
{
        private бдол  пущен;
        private static дво множитель = 1.0 / 1_000_000.0;

        version (Win32)
                 private static дво микросекунда;

        проц старт ();
        дво стоп ();
        бдол микросек ();
        static this();
        private static бдол таймер ();
}

debug (Секундомер)
{
        import io.Stdout;

        проц main() 
        {
                Секундомер t;
                t.старт;

                for (цел i=0; i < 100_000_000; ++i)
                    {}
                Стдвыв.форматируй ("{:f9}", t.стоп).нс;
        }
}
