/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
        
        version:        Initial release: April 2004      
        
        author:         Kris

*******************************************************************************/

module net.Uri;

public  import  net.model.UriView;

//public alias Уир ОбзорУИР;

private import  exception;

private import  Целое = text.convert.Integer;

/*******************************************************************************

        external линки
        
*******************************************************************************/

extern (C) сим* memchr (сим *, сим, бцел);


/*******************************************************************************

        Implements an RFC 2396 compliant URI specification. See 
        <A HREF="http://ftp.ics.uci.edu/pub/ietf/уир/rfc2396.txt">this страница</A>
        for ещё information. 

        The implementation fails the spec on two counts: it doesn't insist
        on a scheme being present in the Уир, и it doesn't implement the
        "Relative References" support noted in section 5.2. The latter can
        be найдено in util.PathUtil instead.
        
        Note that IRI support can be implied by assuming each of userinfo,
        путь, запрос, и fragment are UTF-8 кодирован 
        (see <A HREF="http://www.w3.org/2001/Talks/0912-IUC-IRI/paper.html">
        this страница</A> for further details).

*******************************************************************************/

class Уир : ОбзорУИР
{
        // simplistic ткст добавщик
        private alias т_мера delegate(проц[]) Consumer;  
        
        /// old метод names
        public alias порт        getPort;
        public alias defaultPort getDefaultPort;
        public alias scheme      getScheme;
        public alias хост        дайХост;
        public alias valКСЕРort   дайВалидныйПорт;
        public alias userinfo    getUserInfo;
        public alias путь        дайПуть;
        public alias запрос       getQuery;
        public alias fragment    getFragment;
        public alias порт        setPort;
        public alias scheme      setScheme;
        public alias хост        setHost;
        public alias userinfo    setUserInfo;
        public alias запрос       setQuery;
        public alias путь        установиПуть;
        public alias fragment    setFragment;

        public enum {InvalКСЕРort = -1}

        private цел             port_;
        private ткст          host_,
                                путь_,
                                query_,
                                scheme_,
                                userinfo_,
                                fragment_;
        private СрезКучи       decoded;

        private static ббайт    карта[];

        private static крат[ткст] genericSchemes;

        private static const ткст hexDigits = "0123456789abcdef";

        private static const SchemePort[] schemePorts =
                [
                {"coffee",      80},
                {"файл",        InvalКСЕРort},
                {"ftp",         21},
                {"gopher",      70},
                {"hnews",       80},
                {"http",        80},
                {"http-ng",     80},
                {"https",       443},
                {"imap",        143},
                {"irc",         194}, 
                {"ldap",        389},
                {"news",        119},
                {"nfs",         2049}, 
                {"nntp",        119},
                {"вынь",         110}, 
                {"rwhois",      4321},
                {"shttp",       80},
                {"smtp",        25},
                {"snews",       563},
                {"telnet",      23},
                {"wais",        210},
                {"whois",       43},
                {"whois++",     43},
                ];

        public enum    
        {       
                ExcScheme       = 0x01,         
                ExcAuthority    = 0x02, 
                ExcPath         = 0x04, 
                IncUser         = 0x80,         // кодируй spec for User
                IncPath         = 0x10,         // кодируй spec for Путь
                IncQuery        = 0x20,         // кодируй spec for Query
                IncQueryAll     = 0x40,
                IncScheme       = 0x80,         // кодируй spec for Scheme
                IncGeneric      = IncScheme | 
                                  IncUser   | 
                                  IncPath   | 
                                  IncQuery  | 
                                  IncQueryAll
        }

        // scheme и порт pairs
        private struct SchemePort
        {
                ткст  имя;
                крат   порт;
        }

        /***********************************************************************
        
                Initialize the Уир character maps и so on

        ***********************************************************************/

        static this ()
        {
                // Карта known генерный schemes в_ their default порт. Specify
                // InvalКСЕРort for those schemes that don't use порты. Note
                // that a порт значение of zero is not supported ...
                foreach (SchemePort sp; schemePorts)
                         genericSchemes[sp.имя] = sp.порт;
                genericSchemes.rehash;

                карта = new ббайт[256];

                // загрузи the character карта with действителен symbols
                for (цел i='a'; i <= 'z'; ++i)  
                     карта[i] = IncGeneric;

                for (цел i='A'; i <= 'Z'; ++i)  
                     карта[i] = IncGeneric;

                for (цел i='0'; i<='9'; ++i)  
                     карта[i] = IncGeneric;

                // exclude these из_ parsing элементы
                карта[':'] |= ExcScheme;
                карта['/'] |= ExcScheme | ExcAuthority;
                карта['?'] |= ExcScheme | ExcAuthority | ExcPath;
                карта['#'] |= ExcScheme | ExcAuthority | ExcPath;

                // include these as common (unreserved) symbols
                карта['-'] |= IncUser | IncQuery | IncQueryAll | IncPath;
                карта['_'] |= IncUser | IncQuery | IncQueryAll | IncPath;
                карта['.'] |= IncUser | IncQuery | IncQueryAll | IncPath;
                карта['!'] |= IncUser | IncQuery | IncQueryAll | IncPath;
                карта['~'] |= IncUser | IncQuery | IncQueryAll | IncPath;
                карта['*'] |= IncUser | IncQuery | IncQueryAll | IncPath;
                карта['\''] |= IncUser | IncQuery | IncQueryAll | IncPath;
                карта['('] |= IncUser | IncQuery | IncQueryAll | IncPath;
                карта[')'] |= IncUser | IncQuery | IncQueryAll | IncPath;

                // include these as scheme symbols
                карта['+'] |= IncScheme;
                карта['-'] |= IncScheme;
                карта['.'] |= IncScheme;

                // include these as userinfo symbols
                карта[';'] |= IncUser;
                карта[':'] |= IncUser;
                карта['&'] |= IncUser;
                карта['='] |= IncUser;
                карта['+'] |= IncUser;
                карта['$'] |= IncUser;
                карта[','] |= IncUser;

                // include these as путь symbols
                карта['/'] |= IncPath;
                карта[';'] |= IncPath;
                карта[':'] |= IncPath;
                карта['@'] |= IncPath;
                карта['&'] |= IncPath;
                карта['='] |= IncPath;
                карта['+'] |= IncPath;
                карта['$'] |= IncPath;
                карта[','] |= IncPath;

                // include these as запрос symbols
                карта[';'] |= IncQuery | IncQueryAll;
                карта['/'] |= IncQuery | IncQueryAll;
                карта[':'] |= IncQuery | IncQueryAll;
                карта['@'] |= IncQuery | IncQueryAll;
                карта['='] |= IncQuery | IncQueryAll;
                карта['$'] |= IncQuery | IncQueryAll;
                карта[','] |= IncQuery | IncQueryAll;

                // '%' are permitted insопрe queries when constructing вывод
                карта['%'] |= IncQueryAll;
                карта['?'] |= IncQueryAll;
                карта['&'] |= IncQueryAll;
        }
        
        /***********************************************************************
        
                Созд an пустой Уир

        ***********************************************************************/

        this ()
        {
                port_ = InvalКСЕРort;
                decoded.расширь (512);
        }

        /***********************************************************************
        
                Construct a Уир из_ the provопрed character ткст

        ***********************************************************************/

        this (ткст уир)
        {
                this ();
                разбор (уир);
        }

        /***********************************************************************
        
                Construct a Уир из_ the given components. The запрос is
                optional.
                
        ***********************************************************************/

        this (ткст scheme, ткст хост, ткст путь, ткст запрос = пусто)
        {
                this ();

                this.scheme_ = scheme;
                this.query_ = запрос;
                this.host_ = хост;
                this.путь_ = путь;
        }

        /***********************************************************************
        
                Clone другой Уир. This can be использован в_ сделай a изменяемый Уир
                из_ an immutable ОбзорУИР.

        ***********************************************************************/

        this (ОбзорУИР другой)
        {
                with (другой)
                     {
                     this (getScheme, дайХост, дайПуть, getQuery);
                     this.userinfo_ = getUserInfo;
                     this.fragment_ = getFragment;
                     this.port_ = getPort;
                     }
        }

        /***********************************************************************
        
                Return the default порт for the given scheme. InvalКСЕРort
                is returned if the scheme is неизвестное, or does not прими
                a порт.

        ***********************************************************************/

        final цел defaultPort (ткст scheme)
        {
                крат* порт = scheme in genericSchemes; 
                if (порт is пусто)
                    return InvalКСЕРort;
                return *порт;
        }

        /***********************************************************************
        
                Return the разобрано scheme, or пусто if the scheme was not
                specified

        ***********************************************************************/

        final ткст scheme()
        {
                return scheme_;
        }

        /***********************************************************************
        
                Return the разобрано хост, or пусто if the хост was not
                specified

        ***********************************************************************/

        final ткст хост()
        {
                return host_;
        }

        /***********************************************************************
        
                Return the разобрано порт число, or InvalКСЕРort if the порт
                was not provопрed.

        ***********************************************************************/

        final цел порт()
        {
                return port_;
        }

        /***********************************************************************
        
                Return a действителен порт число by performing a отыщи on the 
                known schemes if the порт was not explicitly specified.

        ***********************************************************************/

        final цел valКСЕРort()
        {
                if (port_ is InvalКСЕРort)
                    return defaultPort (scheme_);
                return port_;
        }

        /***********************************************************************
        
                Return the разобрано userinfo, or пусто if userinfo was not 
                provопрed.

        ***********************************************************************/

        final ткст userinfo()
        {
                return userinfo_;
        }

        /***********************************************************************
        
                Return the разобрано путь, or пусто if the путь was not 
                provопрed.

        ***********************************************************************/

        final ткст путь()
        {
                return путь_;
        }

        /***********************************************************************
        
                Return the разобрано запрос, or пусто if a запрос was not 
                provопрed.

        ***********************************************************************/

        final ткст запрос()
        {
                return query_;
        }

        /***********************************************************************
        
                Return the разобрано fragment, or пусто if a fragment was not 
                provопрed.

        ***********************************************************************/

        final ткст fragment()
        {
                return fragment_;
        }

        /***********************************************************************
        
                Return whether or not the Уир scheme is consопрered генерный.

        ***********************************************************************/

        final бул isGeneric ()
        {
                return (scheme_ in genericSchemes) !is пусто;
        }

        /***********************************************************************
        
                Emit the контент of this Уир via the provопрed Consumer. The
                вывод is constructed per RFC 2396.

        ***********************************************************************/

        final т_мера произведи (Consumer используй)
        {
                т_мера возвр;

                if (scheme_.length)
                    возвр += используй (scheme_), возвр += используй (":");


                if (userinfo_.length || host_.length || port_ != InvalКСЕРort)
                   {
                   возвр += используй ("//");

                   if (userinfo_.length)
                       возвр += кодируй (используй, userinfo_, IncUser), возвр +=используй ("@");

                   if (host_.length)
                       возвр += используй (host_);

                   if (port_ != InvalКСЕРort && port_ != getDefaultPort(scheme_))
                      {
                      сим[8] врем;
                      возвр += используй (":"), возвр += используй (Целое.itoa (врем, cast(бцел) port_));
                      }
                   }

                if (путь_.length)
                    возвр += кодируй (используй, путь_, IncPath);

                if (query_.length)
                   {
                   возвр += используй ("?");
                   возвр += кодируй (используй, query_, IncQueryAll);
                   }

                if (fragment_.length)
                   {
                   возвр += используй ("#");
                   возвр += кодируй (используй, fragment_, IncQuery);
                   }

                return возвр;
        }

        /***********************************************************************
        
                Emit the контент of this Уир via the provопрed Consumer. The
                вывод is constructed per RFC 2396.

        ***********************************************************************/

        final ткст вТкст ()
        {
                проц[] s;

                s.length = 256, s.length = 0;
                произведи ((проц[] v) {return s ~= v, v.length;});
                return cast(ткст) s;
        }

        /***********************************************************************
        
                Encode уир characters преобр_в a Consumer, such that
                reserved симвы are преобразованый преобр_в their %hex version.

        ***********************************************************************/

        static т_мера кодируй (Consumer используй, ткст s, цел флаги)
        {
                т_мера  возвр;
                сим[3] hex;
                цел     метка;

                hex[0] = '%';
                foreach (цел i, сим c; s)
                        {
                        if (! (карта[c] & флаги))
                           {
                           возвр += используй (s[метка..i]);
                           метка = i+1;
                                
                           hex[1] = hexDigits [(c >> 4) & 0x0f];
                           hex[2] = hexDigits [c & 0x0f];
                           возвр += используй (hex);
                           }
                        }

                // добавь trailing section
                if (метка < s.length)
                    возвр += используй (s[метка..s.length]);

                return возвр;
        }

        /***********************************************************************
        
                Encode уир characters преобр_в a ткст, such that reserved 
                симвы are преобразованый преобр_в their %hex version.

                Returns a dup'd ткст

        ***********************************************************************/

        static ткст кодируй (ткст текст, цел флаги)
        {
                проц[] s;
                кодируй ((проц[] v) {return s ~= v, v.length;}, текст, флаги);
                return cast(ткст) s;
        }

        /***********************************************************************
        
                Decode a character ткст with potential %hex значения in it.
                The decoded strings are placed преобр_в a нить-safe expanding
                буфер, и a срез of it is returned в_ the caller.

        ***********************************************************************/

        private ткст decoder (ткст s, сим ignore=0)
        {
                static цел вЦел (сим c)
                {
                        if (c >= '0' && c <= '9')
                            c -= '0';
                        else
                        if (c >= 'a' && c <= 'f')
                            c -= ('a' - 10);
                        else
                        if (c >= 'A' && c <= 'F')
                            c -= ('A' - 10);
                        return c;
                }
                
                цел length = s.length;

                // возьми a Просмотр первый, в_ see if there's work в_ do
                if (length && memchr (s.ptr, '%', length))
                   {
                   сим* p;
                   цел   j;
                        
                   // ensure we have enough decoding пространство available
                   p = cast(сим*) decoded.расширь (length);

                   // скан ткст, strИПping % encodings as we go
                   for (цел i; i < length; ++i, ++j, ++p)
                       {
                       цел c = s[i];

                       if (c is '%' && (i+2) < length)
                          {
                          c = вЦел(s[i+1]) * 16 + вЦел(s[i+2]);

                          // покинь ignored escapes in the поток, 
                          // permitting escaped '&' в_ remain in
                          // the запрос ткст
                          if (c && (c is ignore))
                              c = '%';
                          else
                             i += 2;
                          }

                       *p = cast(сим)c;
                       }

                   // return a срез из_ the decoded ввод
                   return cast(ткст) decoded.срез (j);
                   }

                // return original контент
                return s;
        }   

        /***********************************************************************
        
                Decode a duplicated ткст with potential %hex значения in it

        ***********************************************************************/

        final ткст раскодируй (ткст s)
        {
                return decoder(s).dup;
        }

        /***********************************************************************
        
                Parsing is performed according в_ RFC 2396
                
                <pre>
                  ^(([^:/?#]+):)?(//([^/?#]*))?([^?#]*)(\?([^#]*))?(#(.*))?
                   12            3  4          5       6  7        8 9
                    
                2 isolates scheme
                4 isolates authority
                5 isolates путь
                7 isolates запрос
                9 isolates fragment
                </pre>

                This was originally a состояние-machine; it turned out в_ be a 
                lot faster (~40%) when unwound like this instead.
                
        ***********************************************************************/

        final Уир разбор (ткст уир, бул relative = нет)
        {
                сим    c;
                цел     i, 
                        метка;
                auto    префикс = путь_;
                auto    длин = уир.length;

                if (! relative)
                      сбрось;

                // isolate scheme (note that it's ОК в_ not specify a scheme)
                for (i=0; i < длин && !(карта[c = уир[i]] & ExcScheme); ++i) {}
                if (c is ':')
                   {
                   scheme_ = уир [метка .. i];   
                   вПроп (scheme_);
                   метка = i + 1;
                   }

                // isolate authority
                if (метка < длин-1 && уир[метка] is '/' && уир[метка+1] is '/')
                   {
                   for (метка+=2, i=метка; i < длин && !(карта[уир[i]] & ExcAuthority); ++i) {}
                   parseAuthority (уир[метка .. i]); 
                   метка = i;
                   }
                else
                   if (relative)
                      {
                      auto голова = (уир[0] is '/') ? host_ : toLastSlash(префикс);
                      query_ = fragment_ = пусто;
                      уир = голова ~ уир;
                      длин = уир.length;
                      метка = голова.length;
                      }

                // isolate путь
                for (i=метка; i < длин && !(карта[уир[i]] & ExcPath); ++i) {}
                путь_ = decoder (уир[метка .. i]);
                метка = i;

                // isolate запрос
                if (метка < длин && уир[метка] is '?')
                   {
                   for (++метка, i=метка; i < длин && уир[i] != '#'; ++i) {}
                   query_ = decoder (уир[метка .. i], '&');
                   метка = i;
                   }

                // isolate fragment
                if (метка < длин && уир[метка] is '#')
                    fragment_ = decoder (уир[метка+1 .. длин]);

                return this;
        }

        /***********************************************************************
        
                Clear everything в_ пусто.

        ***********************************************************************/

        final проц сбрось()
        {
                decoded.сбрось;
                port_ = InvalКСЕРort;
                host_ = путь_ = query_ = scheme_ = userinfo_ = fragment_ = пусто;
        }

        /***********************************************************************
        
                Parse the given уир, with support for relative URLs

        ***********************************************************************/

        final Уир отнРазбор (ткст уир)
        {
                return разбор (уир, да);
        }
        
        /***********************************************************************
                
                Набор the Уир scheme

        ***********************************************************************/

        final Уир scheme (ткст scheme)
        {
                this.scheme_ = scheme;
                return this;
        }

        /***********************************************************************
        
                Набор the Уир хост

        ***********************************************************************/

        final Уир хост (ткст хост)
        {
                this.host_ = хост;
                return this;
        }

        /***********************************************************************
        
                Набор the Уир порт

        ***********************************************************************/

        final Уир порт (цел порт)
        {
                this.port_ = порт;
                return this;
        }

        /***********************************************************************
        
                Набор the Уир userinfo

        ***********************************************************************/

        final Уир userinfo (ткст userinfo)
        {
                this.userinfo_ = userinfo;
                return this;
        }

        /***********************************************************************
        
                Набор the Уир запрос

        ***********************************************************************/

        final Уир запрос (ткст запрос)
        {
                this.query_ = запрос;
                return this;
        }

        /***********************************************************************
        
                Extend the Уир запрос

        ***********************************************************************/

        final ткст extendQuery (ткст хвост)
        {
                if (хвост.length)
                    if (query_.length)
                        query_ = query_ ~ "&" ~ хвост;
                    else
                       query_ = хвост;
                return query_;
        }

        /***********************************************************************
        
                Набор the Уир путь

        ***********************************************************************/
        
        final Уир путь (ткст путь)
        {
                this.путь_ = путь;
                return this;
        }

        /***********************************************************************
        
                Набор the Уир fragment

        ***********************************************************************/

        final Уир fragment (ткст fragment)
        {
                this.fragment_ = fragment;
                return this;
        }
        
        /***********************************************************************
        
                Authority is the section after the scheme, but before the 
                путь, запрос or fragment; it typically represents a хост.
               
                ---
                    ^(([^@]*)@?)([^:]*)?(:(.*))?
                     12         3       4 5
                  
                2 isolates userinfo
                3 isolates хост
                5 isolates порт
                ---

        ***********************************************************************/

        private проц parseAuthority (ткст auth)
        {
                цел     метка,
                        длин = auth.length;

                // получи userinfo: (([^@]*)@?)
                foreach (цел i, сим c; auth)
                         if (c is '@')
                            {
                            userinfo_ = decoder (auth[0 .. i]);
                            метка = i + 1;
                            break;
                            }

                // получи порт: (:(.*))?
                for (цел i=метка; i < длин; ++i)
                     if (auth [i] is ':')
                        {
                        port_ = Целое.atoi (auth [i+1 .. длин]);
                        длин = i;
                        break;
                        }

                // получи хост: ([^:]*)?
                host_ = auth [метка..длин];
        }

        /**********************************************************************

        **********************************************************************/

        private final ткст toLastSlash (ткст путь)
        {
                if (путь.ptr)
                    for (auto p = путь.ptr+путь.length; --p >= путь.ptr;)
                         if (*p is '/')
                             return путь [0 .. (p-путь.ptr)+1];
                return путь;
        }

        /**********************************************************************

                in-place conversion в_ lowercase 

        **********************************************************************/

        private final static ткст вПроп (ref ткст ист)
        {
                foreach (ref сим c; ист)
                         if (c >= 'A' && c <= 'Z')
                             c = cast(сим)(c + ('a' - 'A'));
                return ист;
        }
}


/*******************************************************************************
        
*******************************************************************************/

private struct СрезКучи
{
        private бцел    использован;
        private проц[]  буфер;

        /***********************************************************************
        
                Reset контент length в_ zero

        ***********************************************************************/

        final проц сбрось ()
        {
                использован = 0;
        }

        /***********************************************************************
        
                Potentially расширь the контент пространство, и return a pointer
                в_ the старт of the пустой section.

        ***********************************************************************/

        final ук расширь (бцел размер)
        {
                auto длин = использован + размер;
                if (длин > буфер.length)
                    буфер.length = длин + длин/2;

                return &буфер [использован];
        }

        /***********************************************************************
        
                Return a срез of the контент из_ the текущ позиция 
                with the specified размер. Adjusts the текущ позиция в_ 
                точка at an пустой зона.

        ***********************************************************************/

        final проц[] срез (цел размер)
        {
                бцел i = использован;
                использован += размер;
                return буфер [i..использован];
        }
}

/*******************************************************************************
      
    Unittest
        
*******************************************************************************/

debug (UnitTest)
{ 
    import util.log.Trace;

unittest
{
    auto уир = new Уир;
    auto uristring = "http://www.example.com/click.html/c=37571:RoS_Intern_search-link3_LB_Sky_Rec/b=98983:news-время-ищи-link_leader_neu/l=68%7C%7C%7C%7Cde/url=http://ads.ad4max.com/adclick.aspx?опр=cf722624-efd5-4b10-ad53-88a5872a8873&pubad=b9c8acc4-e396-4b0b-b665-8bb3078128e6&avопр=963171985&adcpc=xrH%2f%2bxVeFaPVkbVCMufB5A%3d%3d&a1v=6972657882&a1lang=de&a1ou=http%3a%2f%2fad.ищи.ch%2fiframe_ad.html%3fcampaignname%3dRoS_Intern_search-link3_LB_Sky_Rec%26bannername%3dnews-время-ищи-link_leader_neu%26iframeопр%3dsl_if1%26content%3dvZLLbsIwEEX3%2bQo3aqUW1XEgkAckSJRuKqEuoDuELD%2bmiSEJyDEE%2fr7h0cKm6q6SF9bVjH3uzI3vMOaVYdpgPIwrodXGIHPYQGIb2BuyZDt2Vu2hRUh8Nx%2b%2fjj5Gc4u0UNAJ95H7jCbAJGi%2bZlqix3eoqyfUIhaT3YLtabpVEiXI5pEImRBdDF7k4y53Oea%2b38Mh554bhO1OCL49%2bO6qlTTZsa3546pmoNLMHOXIvaoapNIgTnpmzKZPCJNOBUyLzBEZEbkSKyczRU5E4gW9oN2frmf0rTSgS3quw7kqVx6dvNDZ6kCnIAhPojAKvX7Z%2bMFGFYBvKml%2bskxL2JI88cOHYPxzJJCtzpP79pXQaCZWqkxppcVvlDsF9b9CqiJNLiB1Xd%2bQqIKlUBHXSdWnjQbN1heLoRWTcwz%2bCAlqLCZXg5VzHoEj1gW5XJeVffOcFR8TCKVs8vcF%26crc%3dac8cc2fa9ec2e2de9d242345c2d40c25";
    
    
    уир.разбор(uristring);
    
    with(уир)
    {
        assert(scheme == "http");
        assert(хост == "www.example.com");
        assert(порт == InvalКСЕРort);
        assert(userinfo == пусто);
        assert(fragment == пусто);
        assert(путь == "/click.html/c=37571:RoS_Intern_search-link3_LB_Sky_Rec/b=98983:news-время-ищи-link_leader_neu/l=68||||de/url=http://ads.ad4max.com/adclick.aspx");
        assert(запрос == "опр=cf722624-efd5-4b10-ad53-88a5872a8873&pubad=b9c8acc4-e396-4b0b-b665-8bb3078128e6&avопр=963171985&adcpc=xrH/+xVeFaPVkbVCMufB5A==&a1v=6972657882&a1lang=de&a1ou=http://ad.ищи.ch/iframe_ad.html?campaignname=RoS_Intern_search-link3_LB_Sky_Rec%26bannername=news-время-ищи-link_leader_neu%26iframeопр=sl_if1%26content=vZLLbsIwEEX3+Qo3aqUW1XEgkAckSJRuKqEuoDuELD+miSEJyDEE/r7h0cKm6q6SF9bVjH3uzI3vMOaVYdpgPIwrodXGIHPYQGIb2BuyZDt2Vu2hRUh8Nx+/jj5Gc4u0UNAJ95H7jCbAJGi+Zlqix3eoqyfUIhaT3YLtabpVEiXI5pEImRBdDF7k4y53Oea+38Mh554bhO1OCL49+O6qlTTZsa3546pmoNLMHOXIvaoapNIgTnpmzKZPCJNOBUyLzBEZEbkSKyczRU5E4gW9oN2frmf0rTSgS3quw7kqVx6dvNDZ6kCnIAhPojAKvX7Z+MFGFYBvKml+skxL2JI88cOHYPxzJJCtzpP79pXQaCZWqkxppcVvlDsF9b9CqiJNLiB1Xd+QqIKlUBHXSdWnjQbN1heLoRWTcwz+CAlqLCZXg5VzHoEj1gW5XJeVffOcFR8TCKVs8vcF%26crc=ac8cc2fa9ec2e2de9d242345c2d40c25");
    
    
        разбор("psyc://example.net/~marenz?что#_presence");
        
        assert(scheme == "psyc");
        assert(хост == "example.net");
        assert(порт == InvalКСЕРort);
        assert(fragment == "_presence");
        assert(путь == "/~marenz");
        assert(запрос == "что");
   
    }
   
    //Квывод (уир).нс;
    //Квывод (уир.кодируй ("&#$%", уир.IncQuery)).нс;
        
}

}
