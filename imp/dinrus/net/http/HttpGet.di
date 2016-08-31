/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: January 2006
        
        author:         Kris

*******************************************************************************/

module net.http.HttpGet;

public import   net.Uri;

private import  net.http.HttpClient,
                net.http.HttpHeaders;

/*******************************************************************************

        Supports the basic needs of a клиент making requests of an HTTP
        сервер. The following is a usage example:
        ---
        // открой a web-страница for reading (see ПостППГТ for writing)
        auto страница = new ГетППГТ ("http://www.digitalmars.com/d/intro.html");

        // retrieve и слей display контент
        Квывод (cast(ткст) страница.читай) ();
        ---

*******************************************************************************/

class ГетППГТ : КлиентППГТ
{      
        alias КлиентППГТ.читай читай;

        /***********************************************************************
        
                Созд a клиент for the given URL. The аргумент should be
                fully qualified with an "http:" or "https:" scheme, or an
                явный порт should be provопрed.

        ***********************************************************************/

        this (ткст url);

        /***********************************************************************
        
                Созд a клиент with the provопрed Уир экземпляр. The Уир should 
                be fully qualified with an "http:" or "https:" scheme, or an
                явный порт should be provопрed. 

        ***********************************************************************/

        this (Уир уир);

        /***********************************************************************
        
        ***********************************************************************/

        проц[] читай ();
}


/*******************************************************************************

*******************************************************************************/

debug (ГетППГТ)
{       
        import io.Console;

        проц main()
        {
                // открой a web-страница for reading (see ПостППГТ for writing)
                auto страница = new ГетППГТ ("http://www.digitalmars.com/d/intro.html");

                // retrieve и слей display контент
                Квывод (cast(ткст) страница.читай) ();

                foreach (заголовок; страница.дайЗаголовкиОтвета)
                         Квывод (заголовок.имя.значение) (заголовок.значение).нс;
        }
}
