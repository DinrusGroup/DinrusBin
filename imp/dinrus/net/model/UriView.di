/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
        
        version:        Initial release: April 2004      
        
        author:         Kris

*******************************************************************************/

module net.model.UriView;

/*******************************************************************************

        Implements an RFC 2396 compliant URI specification. See 
        <A HREF="http://ftp.ics.uci.edu/pub/ietf/уир/rfc2396.txt">this страница</A>
        for ещё information. 

        The implementation fails the spec on two counts: it doesn't insist
        on a scheme being present in the ОбзорУИР, и it doesn't implement the
        "Relative References" support noted in section 5.2. 
        
        Note that IRI support can be implied by assuming each of userinfo, путь, 
        запрос, и fragment are UTF-8 кодирован 
        (see <A HREF="http://www.w3.org/2001/Talks/0912-IUC-IRI/paper.html">
        this страница</A> for further details).

        Use a Уир instead where you need в_ alter specific уир атрибуты. 

*******************************************************************************/

abstract class ОбзорУИР
{
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

        /***********************************************************************
        
                Return the default порт for the given scheme. InvalКСЕРort
                is returned if the scheme is неизвестное, or does not прими
                a порт.

        ***********************************************************************/

        abstract цел defaultPort (ткст scheme);

        /***********************************************************************
        
                Return the разобрано scheme, or пусто if the scheme was not
                specified

        ***********************************************************************/

        abstract ткст scheme();

        /***********************************************************************
        
                Return the разобрано хост, or пусто if the хост was not
                specified

        ***********************************************************************/

        abstract ткст хост();

        /***********************************************************************
        
                Return the разобрано порт число, or InvalКСЕРort if the порт
                was not provопрed.

        ***********************************************************************/

        abstract цел порт();

        /***********************************************************************
        
                Return a действителен порт число by performing a отыщи on the 
                known schemes if the порт was not explicitly specified.

        ***********************************************************************/

        abstract цел valКСЕРort();

        /***********************************************************************
        
                Return the разобрано userinfo, or пусто if userinfo was not 
                provопрed.

        ***********************************************************************/

        abstract ткст userinfo();

        /***********************************************************************
        
                Return the разобрано путь, or пусто if the путь was not 
                provопрed.

        ***********************************************************************/

        abstract ткст путь();

        /***********************************************************************
        
                Return the разобрано запрос, or пусто if a запрос was not 
                provопрed.

        ***********************************************************************/

        abstract ткст запрос();

        /***********************************************************************
        
                Return the разобрано fragment, or пусто if a fragment was not 
                provопрed.

        ***********************************************************************/

        abstract ткст fragment();

        /***********************************************************************
        
                Return whether or not the ОбзорУИР scheme is consопрered генерный.

        ***********************************************************************/

        abstract бул isGeneric ();

        /***********************************************************************
        
                Emit the контент of this ОбзорУИР. Вывод is constructed per
                RFC 2396.

        ***********************************************************************/

        abstract ткст вТкст ();
}

