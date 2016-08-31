/*******************************************************************************

        copyright:      Copyright (c) 2005 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: December 2005

        author:         Kris


        Text is a class for managing и manИПulating Unicode character
        массивы.

        Text maintains a текущ "selection", controlled via the выбери()
        и ищи() methods. Each of добавь(), приставь(), замени() и
        удали() operate with respect в_ the selection.

        The ищи() methods also operate with respect в_ the текущ
        selection, provопрing a means of iterating across matched образцы.
        To установи a selection across the entire контент, use the выбери()
        метод with no аргументы.

        Indexes и lengths of контент always счёт код units, not код
        points. This is similar в_ traditional аски ткст handling, yet
        indexing is rarely использован in practice due в_ the selection опрiom:
        substring indexing is generally implied as opposed в_ manИПulated
        directly. This allows for a ещё Потокlined model with regard в_
        utf-surrogates.

        Strings support a range of functionality, из_ вставь и removal
        в_ utf кодировка и decoding. There is also an immutable поднабор
        called TextView, intended в_ simplify life in a multi-threaded
        environment. However, TextView must expose the необр контент as
        needed и thus immutability depends в_ an протяженность upon so-called
        "honour" of a callee. D does not активируй immutability enforcement
        at this время, but this class will be изменён в_ support such a
        feature when it arrives - via the срез() метод.

        The class is templated for use with ткст, шим[], и дим[],
        и should migrate across encodings seamlessly. In particular, все
        functions in text.Util are compatible with Text контент in
        any of the supported encodings. In future, this class will become
        a princИПal gateway в_ the extensive ICU unicode library.

        Note that several common текст operations can be constructed through
        combining text.Text with text.Util e.g. строки of текст
        can be processed thusly:
        ---
        auto источник = new Text!(сим)("one\ntwo\nthree");

        foreach (строка; Util.строки(источник.срез))
                 // do something with строка
        ---

        Speaking a bit like Yoda might be accomplished as follows:
        ---
        auto приёмн = new Text!(сим);

        foreach (элемент; Util.delims ("все cows съешь grass", " "))
                 приёмн.приставь (элемент);
        ---

        Below is an overview of the API и class иерархия:
        ---
        class Text(T) : TextView!(T)
        {
                // установи or сбрось the контент
                Text установи (T[] chars, бул mutable=да);
                Text установи (TextView другой, бул mutable=да);

                // retrieve currently selected текст
                T[] selection ();

                // установи и retrieve текущ selection point
                Text point (бцел индекс);
                бцел point ();

                // метка a selection
                Text выбери (цел старт=0, цел length=цел.max);

                // return an обходчик в_ перемести the selection around.
                // Also exposes "замени все" functionality
                Search ищи (T chr);
                Search ищи (T[] образец);

                // форматируй аргументы behind текущ selection
                Text форматируй (T[] форматируй, ...);

                // добавь behind текущ selection
                Text добавь (T[] текст);
                Text добавь (TextView другой);
                Text добавь (T chr, цел счёт=1);
                Text добавь (ИПотокВвода источник);

                // transcode behind текущ selection
                Text кодируй (ткст);
                Text кодируй (шим[]);
                Text кодируй (дим[]);

                // вставь before текущ selection
                Text приставь (T[] текст);
                Text приставь (TextView другой);
                Text приставь (T chr, цел счёт=1);

                // замени текущ selection
                Text замени (T chr);
                Text замени (T[] текст);
                Text замени (TextView другой);

                // удали текущ selection
                Text удали ();

                // очисть контент
                Text очисть ();

                // убери leading и trailing пробел
                Text убери ();

                // убери leading и trailing chr экземпляры
                Text откинь (T chr);

                // упрости at point, or текущ selection
                Text упрости (цел point = цел.max);

                // резервируй some пространство for inserts/добавьitions
                Text резервируй (цел extra);
        
                // пиши контент в_ поток
                Text пиши (ИПотокВывода сток);
        }

        class TextView(T) : UniText
        {
                // хэш контент
                т_хэш toХэш ();

                // return length of контент
                бцел length ();

                // сравни контент
                бул равно  (T[] текст);
                бул равно  (TextView другой);
                бул ends    (T[] текст);
                бул ends    (TextView другой);
                бул starts  (T[] текст);
                бул starts  (TextView другой);
                цел сравни  (T[] текст);
                цел сравни  (TextView другой);
                цел opEquals (Объект другой);
                цел opCmp    (Объект другой);

                // копируй контент
                T[] копируй (T[] приёмн);

                // return контент
                T[] срез ();

                // return данные тип
                typeinfo кодировка ();

                // замени the сравнение algorithm
                Comparator comparator (Comparator другой);
        }

        class UniText
        {
                // преобразуй контент
                abstract ткст  вТкст   (ткст  приёмн = пусто);
                abstract шим[] вТкст16 (шим[] приёмн = пусто);
                abstract дим[] вТкст32 (дим[] приёмн = пусто);
        }

        struct Search
        {
                // выбери приор экземпляр
                бул предш();

                // выбери следщ экземпляр
                бул следщ();

                // return экземпляр счёт
                т_мера счёт();

                // содержит экземпляр?
                бул внутри();

                // замени все with сим
                проц замени(T);

                // замени все with текст (пусто == удали все)
                проц замени(T[]);
        }
        ---

*******************************************************************************/

module text.Text;

private import  text.Search;

private import  io.model;

private import  text.convert.Layout;

private import  Util = text.Util;

private import  Utf = text.convert.Utf;

private import  Float = text.convert.Float;

private import  Целое = text.convert.Integer;

private import cidrus : memmove;


/*******************************************************************************

        The mutable Text class actually реализует the full API, whereas
        the superclasses are purely abstract (could be interfaces instead).

*******************************************************************************/

class Text(T) : TextView!(T)
{
        public  alias установи               opAssign;
        public  alias добавь            opCatAssign;
        private alias TextView!(T)      TextViewT;
        private alias Выкладка!(T)        LayoutT;

        private T[]                     контент;
        private бул                    mutable;
        private Comparator              comparator_;
        private бцел                    selectPoint,
                                        selectLength,
                                        contentLength;

        /***********************************************************************

                Search Обходчик

        ***********************************************************************/

        private struct Search(T)
        {
                private alias ИщиПлод!(T) Engine;
                private alias т_мера delegate(T[], т_мера) Call;

                private Text    текст;
                private Engine  движок;

                /***************************************************************

                        Construct a Search экземпляр

                ***************************************************************/

                static Search opCall (Text текст, T[] сверь)
                {
                        Search s =void;
                        s.движок.сверь = сверь;
                        текст.selectLength = 0;
                        s.текст = текст;
                        return s;
                }

                /***************************************************************

                        Search backward, starting at the character приор в_
                        the selection point

                ***************************************************************/

                бул предш ()
                {
                        return locate (&движок.реверс, текст.срез, текст.point - 1);
                }

                /***************************************************************

                        Search вперёд, starting just after the currently
                        selected текст

                ***************************************************************/

                бул следщ ()
                {
                        return locate (&движок.вперёд, текст.срез, 
                                        текст.selectPoint + текст.selectLength);
                }

                /***************************************************************

                        Returns да if there is a сверь внутри the 
                        associated текст

                ***************************************************************/

                бул внутри ()
                {       
                        return движок.внутри (текст.срез);
                }

                /***************************************************************
                
                        Returns число of совпадает внутри the associated
                        текст

                ***************************************************************/

                т_мера счёт ()
                {       
                        return движок.счёт (текст.срез);
                }

                /***************************************************************

                        Замени все совпадает with the given character

                ***************************************************************/

                проц замени (T chr)
                {     
                        замени ((&chr)[0..1]);  
                }

                /***************************************************************

                        Замени все совпадает with the given substitution

                ***************************************************************/

                проц замени (T[] подст = пусто)
                {  
                        auto приёмн = new T[текст.length];
                        приёмн.length = 0;

                        foreach (токен; движок.токены (текст.срез, подст))
                                 приёмн ~= токен;
                        текст.установи (приёмн, нет);
                }
 
                /***************************************************************

                        locate образец индекс и выбери as appropriate

                ***************************************************************/

                private бул locate (Call вызов, T[] контент, т_мера из_)
                {
                        auto индекс = вызов (контент, из_);
                        if (индекс < контент.length)
                           {
                           текст.выбери (индекс, движок.сверь.length);
                           return да;
                           }
                        return нет;
                }
        }

        /***********************************************************************

                Selection вринтервал

                deprecated: use point() instead

        ***********************************************************************/

        deprecated public struct Span
        {
                бцел    begin,                  /// индекс of selection point
                        length;                 /// length of selection
        }

        /***********************************************************************

                Созд an пустой Text with the specified available
                пространство

                Note: A character like 'a' will be implicitly преобразованый в_
                бцел и thus will be accepted for this constructor, making
                it appear like you can инициализуй a Text экземпляр with a 
                single character, something which is not supported.

        ***********************************************************************/

        this (бцел пространство = 0)
        {
                контент.length = пространство;
                this.comparator_ = &simpleComparator;
        }

        /***********************************************************************

                Созд a Text upon the provопрed контент. If saопр
                контент is immutable (читай-only) then you might consопрer
                настройка the 'копируй' parameter в_ нет. Doing so will
                avoопр allocating куча-пространство for the контент until it is
                изменён via Text methods. This can be useful when
                wrapping an Массив "temporarily" with a стэк-based Text

        ***********************************************************************/

        this (T[] контент, бул копируй = да)
        {
                установи (контент, копируй);
                this.comparator_ = &simpleComparator;
        }

        /***********************************************************************

                Созд a Text via the контент of другой. If saопр
                контент is immutable (читай-only) then you might consопрer
                настройка the 'копируй' parameter в_ нет. Doing so will avoопр
                allocating куча-пространство for the контент until it is изменён
                via Text methods. This can be useful when wrapping an Массив
                temporarily with a стэк-based Text

        ***********************************************************************/

        this (TextViewT другой, бул копируй = да)
        {
                this (другой.срез, копируй);
        }

        /***********************************************************************

                Набор the контент в_ the provопрed Массив. Parameter 'копируй'
                specifies whether the given Массив is likely в_ change. If
                not, the Массив is есть_алиас until such время it is altered via
                this class. This can be useful when wrapping an Массив
                "temporarily" with a стэк-based Text.

                Also resets the curent selection в_ пусто           

        ***********************************************************************/

        final Text установи (T[] chars, бул копируй = да)
        {
                contentLength = chars.length;
                if ((this.mutable = копируй) is да)
                     контент = chars.dup;
                else
                   контент = chars;

                // no selection
                return выбери (0, 0);
        }

        /***********************************************************************

                Замени the контент of this Text. If the new контент
                is immutable (читай-only) then you might consопрer настройка the
                'копируй' parameter в_ нет. Doing so will avoопр allocating
                куча-пространство for the контент until it is изменён via one of
                these methods. This can be useful when wrapping an Массив
                "temporarily" with a стэк-based Text.

                Also resets the curent selection в_ пусто           

        ***********************************************************************/

        final Text установи (TextViewT другой, бул копируй = да)
        {
                return установи (другой.срез, копируй);
        }

        /***********************************************************************

                Explicitly установи the текущ selection в_ the given старт и
                length. значения are pinned в_ the контент extents

        ***********************************************************************/

        final Text выбери (цел старт=0, цел length=цел.max)
        {
                pinIndices (старт, length);
                selectPoint = старт;
                selectLength = length;
                return this;
        }

        /***********************************************************************

                Return the currently selected контент

        ***********************************************************************/

        final T[] selection ()
        {
                return срез [selectPoint .. selectPoint+selectLength];
        }

        /***********************************************************************

                Return the индекс и length of the текущ selection

                deprecated: use point() instead

        ***********************************************************************/

        deprecated final Span вринтервал ()
        {
                Span s;
                s.begin = selectPoint;
                s.length = selectLength;
                return s;
        }

        /***********************************************************************

                Return the текущ selection point

        ***********************************************************************/

        final бцел point ()
        {
                return selectPoint;
        }

        /***********************************************************************

                Набор the текущ selection point, и resets selection length

        ***********************************************************************/

        final Text point (бцел индекс)
        {
                return выбери (индекс, 0);
        }

        /***********************************************************************
        
                Return a ищи обходчик for a given образец. The обходчик
                sets the текущ текст selection as appropriate. For example:
                ---
                auto t = new Text ("hello world");
                auto s = t.ищи ("world");

                assert (s.следщ);
                assert (t.selection == "world");
                ---

                Replacing образцы operates in a similar fashion:
                ---
                auto t = new Text ("hello world");
                auto s = t.ищи ("world");

                // замени все экземпляры of "world" with "everyone"
                assert (s.замени ("everyone"));
                assert (s.счёт is 0);
                ---

        ***********************************************************************/

        Search!(T) ищи (T[] сверь)
        {
                return Search!(T) (this, сверь);
        }

        Search!(T) ищи (ref T сверь)
        {
                return ищи ((&сверь)[0..1]);
        }

        /***********************************************************************

                Find и выбери the следщ occurrence of a BMP код point
                in a ткст. Returns да if найдено, нет otherwise

                deprecated: use ищи() instead

        ***********************************************************************/

        deprecated final бул выбери (T c)
        {
                auto s = срез();
                auto x = Util.locate (s, c, selectPoint);
                if (x < s.length)
                   {
                   выбери (x, 1);
                   return да;
                   }
                return нет;
        }

        /***********************************************************************

                Find и выбери the следщ substring occurrence.  Returns
                да if найдено, нет otherwise

                deprecated: use ищи() instead

        ***********************************************************************/

        deprecated final бул выбери (TextViewT другой)
        {
                return выбери (другой.срез);
        }

        /***********************************************************************

                Find и выбери the следщ substring occurrence. Returns
                да if найдено, нет otherwise

                deprecated: use ищи() instead

        ***********************************************************************/

        deprecated final бул выбери (T[] chars)
        {
                auto s = срез();
                auto x = Util.locatePattern (s, chars, selectPoint);
                if (x < s.length)
                   {
                   выбери (x, chars.length);
                   return да;
                   }
                return нет;
        }

        /***********************************************************************

                Find и выбери a приор occurrence of a BMP код point
                in a ткст. Returns да if найдено, нет otherwise

                deprecated: use ищи() instead

        ***********************************************************************/

        deprecated final бул selectPrior (T c)
        {
                auto s = срез();
                auto x = Util.locatePrior (s, c, selectPoint);
                if (x < s.length)
                   {
                   выбери (x, 1);
                   return да;
                   }
                return нет;
        }

        /***********************************************************************

                Find и выбери a приор substring occurrence. Returns
                да if найдено, нет otherwise

                deprecated: use ищи() instead

        ***********************************************************************/

        deprecated final бул selectPrior (TextViewT другой)
        {
                return selectPrior (другой.срез);
        }

        /***********************************************************************

                Find и выбери a приор substring occurrence. Returns
                да if найдено, нет otherwise

                deprecated: use ищи() instead

        ***********************************************************************/

        deprecated final бул selectPrior (T[] chars)
        {
                auto s = срез();
                auto x = Util.locatePatternPrior (s, chars, selectPoint);
                if (x < s.length)
                   {
                   выбери (x, chars.length);
                   return да;
                   }
                return нет;
        }

        /***********************************************************************

                Доб formatted контент в_ this Text

        ***********************************************************************/

        final Text форматируй (T[] форматируй, ...)
        {
                бцел излей (T[] s)
                {
                        добавь (s);
                        return s.length;
                }

                LayoutT.экземпляр.преобразуй (&излей, _arguments, _argptr, форматируй);
                return this;
        }

        /***********************************************************************

                Доб текст в_ this Text

        ***********************************************************************/

        final Text добавь (TextViewT другой)
        {
                return добавь (другой.срез);
        }

        /***********************************************************************

                Доб текст в_ this Text

        ***********************************************************************/

        final Text добавь (T[] chars)
        {
                return добавь (chars.ptr, chars.length);
        }

        /***********************************************************************

                Доб a счёт of characters в_ this Text

        ***********************************************************************/

        final Text добавь (T chr, цел счёт=1)
        {
                бцел point = selectPoint + selectLength;
                расширь (point, счёт);
                return установи (chr, point, счёт);
        }

        /***********************************************************************

                Доб an целое в_ this Text

                deprecated: use форматируй() instead

        ***********************************************************************/
        
        deprecated final Text добавь (цел v, T[] фмт = пусто)
        {
                return добавь (cast(дол) v, фмт);
        }

        /***********************************************************************

                Доб a дол в_ this Text

                deprecated: use форматируй() instead

        ***********************************************************************/

        deprecated final Text добавь (дол v, T[] фмт = пусто)
        {
                T[64] врем =void;
                return добавь (Целое.форматируй(врем, v, фмт));
        }

        /***********************************************************************

                Доб a дво в_ this Text

                deprecated: use форматируй() instead

        ***********************************************************************/

        deprecated final Text добавь (дво v, бцел decimals=2, цел e=10)
        {
                T[64] врем =void;
                return добавь (Float.форматируй(врем, v, decimals, e));
        }

        /***********************************************************************

                Доб контент из_ ввод поток at insertion point. Use
                io.stream.Utf as a wrapper в_ perform conversion as
                necessary

        ***********************************************************************/

        final Text добавь (ИПотокВвода источник)
        {
                T[8192/T.sizeof] врем =void;
                while (да) 
                      {
                      auto длин = источник.читай (врем); 
                      if (длин is источник.Кф) 
                          break; 

                      // проверь в_ ensure UTF conversion is ok
                      assert ((длин & (T.sizeof-1)) is 0);
                      добавь (врем [0 .. длин/T.sizeof]);
                      }
                return this;
        }

        /***********************************************************************

                Insert characters преобр_в this Text

        ***********************************************************************/

        final Text приставь (T chr, цел счёт=1)
        {
                расширь (selectPoint, счёт);
                return установи (chr, selectPoint, счёт);
        }

        /***********************************************************************

                Insert текст преобр_в this Text

        ***********************************************************************/

        final Text приставь (T[] другой)
        {
                расширь (selectPoint, другой.length);
                контент[selectPoint..selectPoint+другой.length] = другой;
                return this;
        }

        /***********************************************************************

                Insert другой Text преобр_в this Text

        ***********************************************************************/

        final Text приставь (TextViewT другой)
        {
                return приставь (другой.срез);
        }

        /***********************************************************************

                Доб кодирован текст at the текущ selection point. The текст
                is преобразованый as necessary в_ the appropritate utf кодировка.

        ***********************************************************************/

        final Text кодируй (ткст s)
        {
                T[1024] врем =void;

                static if (is (T == сим))
                           return добавь(s);

                static if (is (T == шим))
                           return добавь (Utf.вТкст16(s, врем));

                static if (is (T == дим))
                           return добавь (Utf.вТкст32(s, врем));
        }

        /// ditto
        final Text кодируй (шим[] s)
        {
                T[1024] врем =void;

                static if (is (T == сим))
                           return добавь (Utf.вТкст(s, врем));

                static if (is (T == шим))
                           return добавь (s);

                static if (is (T == дим))
                           return добавь (Utf.вТкст32(s, врем));
        }

        /// ditto
        final Text кодируй (дим[] s)
        {
                T[1024] врем =void;

                static if (is (T == сим))
                           return добавь (Utf.вТкст(s, врем));

                static if (is (T == шим))
                           return добавь (Utf.вТкст16(s, врем));

                static if (is (T == дим))
                           return добавь (s);
        }

        /// ditto
        final Text кодируй (Объект o)
        {
                return кодируй (o.вТкст);
        }

        /***********************************************************************

                Замени a section of this Text with the specified
                character

        ***********************************************************************/

        final Text замени (T chr)
        {
                return установи (chr, selectPoint, selectLength);
        }

        /***********************************************************************

                Замени a section of this Text with the specified
                Массив

        ***********************************************************************/

        final Text замени (T[] chars)
        {
                цел чанк = chars.length - selectLength;
                if (чанк >= 0)
                    расширь (selectPoint, чанк);
                else
                   удали (selectPoint, -чанк);

                контент [selectPoint .. selectPoint+chars.length] = chars;
                return выбери (selectPoint, chars.length);
        }

        /***********************************************************************

                Замени a section of this Text with другой

        ***********************************************************************/

        final Text замени (TextViewT другой)
        {
                return замени (другой.срез);
        }

        /***********************************************************************

                Удали the selection из_ this Text и сбрось the
                selection в_ zero length (at the текущ позиция)

        ***********************************************************************/

        final Text удали ()
        {
                удали (selectPoint, selectLength);
                return выбери (selectPoint, 0);
        }

        /***********************************************************************

                Удали the selection из_ this Text

        ***********************************************************************/

        private Text удали (цел старт, цел счёт)
        {
                pinIndices (старт, счёт);
                if (счёт > 0)
                   {
                   if (! mutable)
                         realloc ();

                   бцел i = старт + счёт;
                   memmove (контент.ptr+старт, контент.ptr+i, (contentLength-i) * T.sizeof);
                   contentLength -= счёт;
                   }
                return this;
        }

        /***********************************************************************

                Truncate this ткст at an optional индекс. Default behaviour
                is в_ упрости at the текущ добавь point. Текущий selection
                is moved в_ the truncation point, with length 0

        ***********************************************************************/

        final Text упрости (цел индекс = цел.max)
        {
                if (индекс is цел.max)
                    индекс = selectPoint + selectLength;

                pinIndex (индекс);
                return выбери (contentLength = индекс, 0);
        }

        /***********************************************************************

                Clear the ткст контент

        ***********************************************************************/

        final Text очисть ()
        {
                return выбери (contentLength = 0, 0);
        }

        /***********************************************************************

                Удали leading и trailing пробел из_ this Text,
                и сбрось the selection в_ the trimmed контент

        ***********************************************************************/

        final Text убери ()
        {
                контент = Util.убери (срез);
                выбери (0, contentLength = контент.length);
                return this;
        }

        /***********************************************************************

                Удали leading и trailing совпадает из_ this Text,
                и сбрось the selection в_ the очищенный контент

        ***********************************************************************/

        final Text откинь (T совпадает)
        {
                контент = Util.откинь (срез, совпадает);
                выбери (0, contentLength = контент.length);
                return this;
        }

        /***********************************************************************

                Reserve some extra room

        ***********************************************************************/

        final Text резервируй (бцел extra)
        {
                realloc (extra);
                return this;
        }

        /***********************************************************************

                Зап контент в_ вывод поток

        ***********************************************************************/

        Text пиши (ИПотокВывода сток)
        {
                сток.пиши (срез);
                return this;
        }

        /* ======================== TextView methods ======================== */



        /***********************************************************************

                Get the кодировка тип

        ***********************************************************************/

        final ИнфОТипе кодировка()
        {
                return typeid(T);
        }

        /***********************************************************************

                Набор the comparator delegate. Where другой is пусто, we behave
                as a getter only

        ***********************************************************************/

        final Comparator comparator (Comparator другой)
        {
                auto врем = comparator_;
                if (другой)
                    comparator_ = другой;
                return врем;
        }

        /***********************************************************************

                Хэш this Text

        ***********************************************************************/

        override т_хэш toХэш ()
        {
                return Util.jhash (cast(ббайт*) контент.ptr, contentLength * T.sizeof);
        }

        /***********************************************************************

                Return the length of the действителен контент

        ***********************************************************************/

        final бцел length ()
        {
                return contentLength;
        }

        /***********************************************************************

                Is this Text equal в_ другой?

        ***********************************************************************/

        final бул равно (TextViewT другой)
        {
                if (другой is this)
                    return да;
                return равно (другой.срез);
        }

        /***********************************************************************

                Is this Text equal в_ the provопрed текст?

        ***********************************************************************/

        final бул равно (T[] другой)
        {
                if (другой.length == contentLength)
                    return Util.совпадают (другой.ptr, контент.ptr, contentLength);
                return нет;
        }

        /***********************************************************************

                Does this Text конец with другой?

        ***********************************************************************/

        final бул ends (TextViewT другой)
        {
                return ends (другой.срез);
        }

        /***********************************************************************

                Does this Text конец with the specified ткст?

        ***********************************************************************/

        final бул ends (T[] chars)
        {
                if (chars.length <= contentLength)
                    return Util.совпадают (контент.ptr+(contentLength-chars.length), chars.ptr, chars.length);
                return нет;
        }

        /***********************************************************************

                Does this Text старт with другой?

        ***********************************************************************/

        final бул starts (TextViewT другой)
        {
                return starts (другой.срез);
        }

        /***********************************************************************

                Does this Text старт with the specified ткст?

        ***********************************************************************/

        final бул starts (T[] chars)
        {
                if (chars.length <= contentLength)
                    return Util.совпадают (контент.ptr, chars.ptr, chars.length);
                return нет;
        }

        /***********************************************************************

                Сравни this Text старт with другой. Returns 0 if the
                контент совпадает, less than zero if this Text is "less"
                than the другой, or greater than zero where this Text
                is "bigger".

        ***********************************************************************/

        final цел сравни (TextViewT другой)
        {
                if (другой is this)
                    return 0;

                return сравни (другой.срез);
        }

        /***********************************************************************

                Сравни this Text старт with an Массив. Returns 0 if the
                контент совпадает, less than zero if this Text is "less"
                than the другой, or greater than zero where this Text
                is "bigger".

        ***********************************************************************/

        final цел сравни (T[] chars)
        {
                return comparator_ (срез, chars);
        }

        /***********************************************************************

                Return контент из_ this Text

                A срез of приёмн is returned, representing a копируй of the
                контент. The срез is clИПped в_ the minimum of either
                the length of the provопрed Массив, or the length of the
                контент minus the stИПulated старт point

        ***********************************************************************/

        final T[] копируй (T[] приёмн)
        {
                бцел i = contentLength;
                if (i > приёмн.length)
                    i = приёмн.length;

                return приёмн [0 .. i] = контент [0 .. i];
        }

        /***********************************************************************

                Return an alias в_ the контент of this TextView. Note
                that you are bound by honour в_ покинь this контент wholly
                unmolested. D surely needs some way в_ enforce immutability
                upon Массив references

        ***********************************************************************/

        final T[] срез ()
        {
                return контент [0 .. contentLength];
        }

        /***********************************************************************

                Convert в_ the UniText типы. The optional аргумент
                приёмн will be resized as требуется в_ house the conversion.
                To minimize куча allocation during subsequent conversions,
                apply the following образец:
                ---
                Text  ткст;

                шим[] буфер;
                шим[] результат = ткст.utf16 (буфер);

                if (результат.length > буфер.length)
                    буфер = результат;
                ---
                You can also provопрe a буфер из_ the стэк, but the вывод
                will be moved в_ the куча if saопр буфер is not large enough

        ***********************************************************************/

        final ткст вТкст (ткст приёмн = пусто)
        {
                static if (is (T == сим))
                           return срез();

                static if (is (T == шим))
                           return Utf.вТкст (срез, приёмн);

                static if (is (T == дим))
                           return Utf.вТкст (срез, приёмн);
        }

        /// ditto
        final шим[] вТкст16 (шим[] приёмн = пусто)
        {
                static if (is (T == сим))
                           return Utf.вТкст16 (срез, приёмн);

                static if (is (T == шим))
                           return срез;

                static if (is (T == дим))
                           return Utf.вТкст16 (срез, приёмн);
        }

        /// ditto
        final дим[] вТкст32 (дим[] приёмн = пусто)
        {
                static if (is (T == сим))
                           return Utf.вТкст32 (срез, приёмн);

                static if (is (T == шим))
                           return Utf.вТкст32 (срез, приёмн);

                static if (is (T == дим))
                           return срез;
        }

        /***********************************************************************

                Сравни this Text в_ другой. We сравни against другой
                Strings only. Literals и другой objects are not supported

        ***********************************************************************/

        override цел opCmp (Объект o)
        {
                auto другой = cast (TextViewT) o;

                if (другой is пусто)
                    return -1;

                return сравни (другой);
        }

        /***********************************************************************

                Is this Text equal в_ the текст of something else?

        ***********************************************************************/

        override цел opEquals (Объект o)
        {
                auto другой = cast (TextViewT) o;

                if (другой)
                    return равно (другой);

                // this can become expensive ...
                сим[1024] врем =void;
                return this.вТкст(врем) == o.вТкст;
        }

        /// ditto
        final цел opEquals (T[] s)
        {
                return срез == s;
        }

        /***********************************************************************

                Pin the given индекс в_ a действителен позиция.

        ***********************************************************************/

        private проц pinIndex (ref цел x)
        {
                if (x > contentLength)
                    x = contentLength;
        }

        /***********************************************************************

                Pin the given индекс и length в_ a действителен позиция.

        ***********************************************************************/

        private проц pinIndices (ref цел старт, ref цел length)
        {
                if (старт > contentLength)
                    старт = contentLength;

                if (length > (contentLength - старт))
                    length = contentLength - старт;
        }

        /***********************************************************************

                Сравни two массивы. Returns 0 if the контент совпадает, less
                than zero if A is "less" than B, or greater than zero where
                A is "bigger". Where the substrings сверь, the shorter is
                consопрered "less".

        ***********************************************************************/

        private цел simpleComparator (T[] a, T[] b)
        {
                бцел i = a.length;
                if (b.length < i)
                    i = b.length;

                for (цел j, k; j < i; ++j)
                     if ((k = a[j] - b[j]) != 0)
                          return k;

                return a.length - b.length;
        }

        /***********************************************************************

                Make room available в_ вставь or добавь something

        ***********************************************************************/

        private проц расширь (бцел индекс, бцел счёт)
        {
                if (!mutable || (contentLength + счёт) > контент.length)
                     realloc (счёт);

                memmove (контент.ptr+индекс+счёт, контент.ptr+индекс, (contentLength - индекс) * T.sizeof);
                selectLength += счёт;
                contentLength += счёт;
        }

        /***********************************************************************

                Замени a section of this Text with the specified
                character

        ***********************************************************************/

        private Text установи (T chr, бцел старт, бцел счёт)
        {
                контент [старт..старт+счёт] = chr;
                return this;
        }

        /***********************************************************************

                Размести память due в_ a change in the контент. We укз
                the distinction between mutable и immutable here.

        ***********************************************************************/

        private проц realloc (бцел счёт = 0)
        {
                бцел размер = (контент.length + счёт + 127) & ~127;

                if (mutable)
                    контент.length = размер;
                else
                   {
                   mutable = да;
                   T[] x = контент;
                   контент = new T[размер];
                   if (contentLength)
                       контент[0..contentLength] = x;
                   }
        }

        /***********************************************************************

                Internal метод в_ support Text appending

        ***********************************************************************/

        private Text добавь (T* chars, бцел счёт)
        {
                бцел point = selectPoint + selectLength;
                расширь (point, счёт);
                контент[point .. point+счёт] = chars[0 .. счёт];
                return this;
        }
}



/*******************************************************************************

        Immutable ткст

*******************************************************************************/

class TextView(T) : UniText
{
        public typedef цел delegate (T[] a, T[] b) Comparator;

        /***********************************************************************

                Return the length of the действителен контент

        ***********************************************************************/

        abstract бцел length ();

        /***********************************************************************

                Is this Text equal в_ другой?

        ***********************************************************************/

        abstract бул равно (TextView другой);

        /***********************************************************************

                Is this Text equal в_ the the provопрed текст?

        ***********************************************************************/

        abstract бул равно (T[] другой);

        /***********************************************************************

                Does this Text конец with другой?

        ***********************************************************************/

        abstract бул ends (TextView другой);

        /***********************************************************************

                Does this Text конец with the specified ткст?

        ***********************************************************************/

        abstract бул ends (T[] chars);

        /***********************************************************************

                Does this Text старт with другой?

        ***********************************************************************/

        abstract бул starts (TextView другой);

        /***********************************************************************

                Does this Text старт with the specified ткст?

        ***********************************************************************/

        abstract бул starts (T[] chars);

        /***********************************************************************

                Сравни this Text старт with другой. Returns 0 if the
                контент совпадает, less than zero if this Text is "less"
                than the другой, or greater than zero where this Text
                is "bigger".

        ***********************************************************************/

        abstract цел сравни (TextView другой);

        /***********************************************************************

                Сравни this Text старт with an Массив. Returns 0 if the
                контент совпадает, less than zero if this Text is "less"
                than the другой, or greater than zero where this Text
                is "bigger".

        ***********************************************************************/

        abstract цел сравни (T[] chars);

        /***********************************************************************

                Return контент из_ this Text. A срез of приёмн is
                returned, representing a копируй of the контент. The
                срез is clИПped в_ the minimum of either the length
                of the provопрed Массив, or the length of the контент
                minus the stИПulated старт point

        ***********************************************************************/

        abstract T[] копируй (T[] приёмн);

        /***********************************************************************

                Сравни this Text в_ другой

        ***********************************************************************/

        abstract цел opCmp (Объект o);

        /***********************************************************************

                Is this Text equal в_ другой?

        ***********************************************************************/

        abstract цел opEquals (Объект другой);

        /***********************************************************************

                Is this Text equal в_ другой?

        ***********************************************************************/

        abstract цел opEquals (T[] другой);

        /***********************************************************************

                Get the кодировка тип

        ***********************************************************************/

        abstract ИнфОТипе кодировка();

        /***********************************************************************

                Набор the comparator delegate

        ***********************************************************************/

        abstract Comparator comparator (Comparator другой);

        /***********************************************************************

                Хэш this Text

        ***********************************************************************/

        abstract т_хэш toХэш ();

        /***********************************************************************

                Return an alias в_ the контент of this TextView. Note
                that you are bound by honour в_ покинь this контент wholly
                unmolested. D surely needs some way в_ enforce immutability
                upon Массив references

        ***********************************************************************/

        abstract T[] срез ();
}


/*******************************************************************************

        A ткст abstraction that converts в_ anything

*******************************************************************************/

class UniText
{
        abstract ткст  вТкст  (ткст  приёмн = пусто);

        abstract шим[] вТкст16 (шим[] приёмн = пусто);

        abstract дим[] вТкст32 (дим[] приёмн = пусто);

        abstract ИнфОТипе кодировка();
}



/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{       
        import io.device.Array;

        //проц main() {}
        unittest
        {
        auto s = new Text!(сим);
        s = "hello";

        auto Массив = new Массив(1024);
        s.пиши (Массив);
        assert (Массив.срез == "hello");
        s.выбери (1, 0);
        assert (s.добавь(Массив) == "hhelloello");

        s = "hello";
        s.ищи("hello").следщ;
        assert (s.selection == "hello");
        s.замени ("1");
        assert (s.selection == "1");
        assert (s == "1");

        assert (s.очисть == "");

        assert (s.форматируй("{}", 12345) == "12345");
        assert (s.selection == "12345");

        s ~= "fubar";
        assert (s.selection == "12345fubar");
        assert (s.ищи("5").следщ);
        assert (s.selection == "5");
        assert (s.удали == "1234fubar");
        assert (s.ищи("fubar").следщ);
        assert (s.selection == "fubar");
        assert (s.ищи("wumpus").следщ is нет);
        assert (s.selection == "");

        assert (s.очисть.форматируй("{:f4}", 1.2345) == "1.2345");

        assert (s.очисть.форматируй("{:b}", 0xf0) == "11110000");

        assert (s.очисть.кодируй("one"d).вТкст == "one");

        assert (Util.рабейнастр(s.очисть.добавь("a\nb").срез).length is 2);

        assert (s.выбери.замени("almost ") == "almost ");
        foreach (элемент; Util.образцы ("все cows съешь grass", "съешь", "chew"))
                 s.добавь (элемент);
        assert (s.selection == "almost все cows chew grass");
        assert (s.очисть.форматируй("{}:{}", 1, 2) == "1:2");
        }
}


debug (Text)
{
        проц main()
        {
                auto t = new Text!(сим);
                t = "hello world";
                auto s = t.ищи ("o");
                assert (s.следщ);
                assert (t.selection == "o");
                assert (t.point is 4);
                assert (s.следщ);
                assert (t.selection == "o");
                assert (t.point is 7);
                assert (!s.следщ);

                t.point = 9;
                assert (s.предш);
                assert (t.selection == "o");
                assert (t.point is 7);
                assert (s.предш);
                assert (t.selection == "o");
                assert (t.point is 4);
                assert (s.следщ);
                assert (t.point is 7);
                assert (s.предш);
                assert (t.selection == "o");
                assert (t.point is 4);
                assert (!s.предш);
                assert (s.счёт is 2);
                s.замени ('O');
                assert (t.срез == "hellO wOrld");
                assert (s.счёт is 0);

                t.point = 0;
                assert (t.ищи("hellO").следщ);
                assert (t.selection == "hellO");
                assert (t.ищи("hellO").следщ);
                assert (t.selection == "hellO");
        }
}
