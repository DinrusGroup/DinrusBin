module io.stream.Data;

private import io.device.Conduit;
private import io.stream.Buffered;

class ВводДанных : ФильтрВвода
{
        public alias массив     получи;             /// old имя alias
        public alias булево   получиБул;         /// ditto
        public alias цел8      получиБайт;         /// ditto
        public alias цел16     получиКрат;        /// ditto
        public alias цел32     получиЦел;          /// ditto
        public alias цел64     получиДол;         /// ditto
        public alias плав32   получиПлав;        /// ditto
        public alias плав64   получиДво;       /// ditto

        public enum                             /// эндиан variations
        {
                Натив  = 0,
                Сеть = 1,
                Биг     = 1,
                Литл  = 2
        }

        private бул            флип;
        protected ИПотокВвода   ввод;
        private Размести        разместитель;

        private alias проц[] delegate (бцел) Размести;

        this (ИПотокВвода поток);
        final ВводДанных размести (Размести размести);
        final ВводДанных эндиан (цел e);
        final бцел массив (проц[] приёмн);
        final проц[] массив ();
        final бул булево ();
        final байт цел8 ();
        final крат цел16 ();
        final цел цел32 ();
        final дол цел64 ();
        final плав плав32 ();
        final дво плав64 ();
        final override т_мера читай (проц[] данные);
        private final проц съешь (ук  приёмн, т_мера байты);
}

class ВыводДанных : ФильтрВывода
{       
        public alias массив      помести;            /// old имя alias
        public alias булево    поместиБул;        /// ditto
        public alias цел8       поместиБайт;        /// ditto
        public alias цел16      поместиКрат;       /// ditto
        public alias цел32      поместиЦел;         /// ditto
        public alias цел64      поместиДол;        /// ditto
        public alias плав32    поместиПлав;       /// ditto
        public alias плав64    поместиПлав;       /// ditto

        public enum                             /// эндиан variations
        {
                Натив  = 0,
                Сеть = 1,
                Биг     = 1,
                Литл  = 2
        }

        private бул            флип;
        private ИПотокВывода    вывод;


        this (ИПотокВывода поток);
        final ВыводДанных эндиан (цел e);
        final бцел массив (проц[] ист);
        final проц булево (бул x);
        final проц цел8 (байт x);
        final проц цел16 (крат x);
        final проц цел32 (цел x);
        final проц цел64 (дол x);
        final проц плав32 (плав x);
        final проц плав64 (дво x);
        final override т_мера пиши (проц[] данные);
        private final проц съешь (ук  ист, т_мера байты);
}