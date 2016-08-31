﻿/*******************************************************************************

        Copyright: Copyright (C) 2008 Aaron Craelius & Kris Bell.  
                   все rights reserved.

        License:   BSD стиль: $(LICENSE)

        version:   Initial release: July 2008      

        Authors:   Aaron, Kris

*******************************************************************************/

module text.json.JsonParser;

private import util.container.more.Stack;

/*******************************************************************************

*******************************************************************************/

class JsonParser(T)
{
        public enum Токен
               {
               Empty, Name, Строка, Число, BeginObject, EndObject, 
               BeginArray, EndArray, Да, Нет, Пусто
               }

        private enum Состояние {Объект, Массив};

        private struct Обходчик
        {
                T*      ptr;
                T*      конец;
                T[]     текст;

                проц сбрось (T[] текст)
                {
                        this.текст = текст;
                        this.ptr = текст.ptr;
                        this.конец = ptr + текст.length;
                }
        }

        protected Обходчик              стр;
        private Стэк!(Состояние, 16)       состояние;
        private T*                      curLoc;
        private цел                     curLen;
        private Состояние                   curState; 
        protected Токен                 текТип;
        
        /***********************************************************************
        
        ***********************************************************************/
        
        this (T[] текст = пусто)
        {
                сбрось (текст);
        }
        
        /***********************************************************************
        
        ***********************************************************************/
        
        final бул следщ ()
        {
                auto p = стр.ptr;
                auto e = стр.конец;

                while (*p <= 32 && p < e) 
                       ++p; 

                if ((стр.ptr = p) >= e) 
                     return нет;

                if (curState is Состояние.Массив) 
                    return parseArrayValue;

                switch (текТип)
                       {
                       case Токен.Name:
                            return parseMemberValue;

                       default:                
                            break;
                       }

                return parseMemberName;
        }
        
        /***********************************************************************
        
        ***********************************************************************/
        
        final Токен тип ()
        {
                return текТип;
        }
        
        /***********************************************************************
        
        ***********************************************************************/
        
        final T[] значение ()
        {
                return curLoc [0 .. curLen];
        }
        
        /***********************************************************************
        
        ***********************************************************************/
        
        бул сбрось (T[] json = пусто)
        {
                состояние.очисть;
                стр.сбрось (json);
                текТип = Токен.Empty;
                curState = Состояние.Объект;

                if (json.length)
                   {
                   auto p = стр.ptr;
                   auto e = стр.конец;

                   while (*p <= 32 && p < e) 
                          ++p; 
                   if (p < e)
                       return старт (*(стр.ptr = p));
                   }
                return нет;
        }

        /***********************************************************************
        
        ***********************************************************************/
        
        protected final проц ожидалось (ткст токен)
        {
                throw new Исключение ("ожидалось " ~ токен);
        }
        
        /***********************************************************************
        
        ***********************************************************************/
        
        protected final проц ожидалось (ткст токен, T* point)
        {
                static ткст itoa (ткст буф, цел i)
                {
                        auto p = буф.ptr+буф.length;
                        do {
                           *--p = '0' + i % 10;
                           } while (i /= 10);
                        return p[0..(буф.ptr+буф.length)-p];
                }
                сим[16] врем =void;
                ожидалось (токен ~ " @ввод[" ~ itoa(врем, point-стр.текст.ptr)~"]");
        }
        
        /***********************************************************************
        
        ***********************************************************************/
        
        private проц unexpectedEOF (ткст сооб)
        {
                throw new Исключение ("неожиданный конец ввода: " ~ сооб);
        }
                
        /***********************************************************************
        
        ***********************************************************************/
        
        private бул старт (T c)
        {
                if (c is '{') 
                    return сунь (Токен.BeginObject, Состояние.Объект);

                if (c is '[') 
                    return сунь (Токен.BeginArray, Состояние.Массив);

                ожидалось ("'{' или '[' в начале документа");
        }

        /***********************************************************************
        
        ***********************************************************************/
        
        private бул parseMemberName ()
        {
                auto p = стр.ptr;
                auto e = стр.конец;

                if(*p is '}') 
                    return вынь (Токен.EndObject);
                
                if(*p is ',') 
                    ++p;
                
                while (*p <= 32) 
                       ++p;

                if (*p != '"')
                    if (*p == '}')
                        ожидалось ("an attribute-имя after (a potentially trailing) ','", p);
                    else
                       ожидалось ("'\"' before attribute-имя", p);

                curLoc = p+1;
                текТип = Токен.Name;

                while (++p < e) 
                       if (*p is '"' && !escaped(p))
                           break;

                if (p < e) 
                    curLen = p - curLoc;
                else
                   unexpectedEOF ("in attribute-имя");

                стр.ptr = p + 1;
                return да;
        }
        
        /***********************************************************************
        
        ***********************************************************************/
        
        private бул parseMemberValue ()
        {
                auto p = стр.ptr;

                if(*p != ':') 
                   ожидалось ("':' before attribute-значение", p);

                auto e = стр.конец;
                while (++p < e && *p <= 32) {}

                return разбериЗначение (*(стр.ptr = p));
        }
        
        /***********************************************************************
        
        ***********************************************************************/
        
        private бул разбериЗначение (T c)
        {                       
                switch (c)
                       {
                       case '{':
                            return сунь (Токен.BeginObject, Состояние.Объект);
         
                       case '[':
                            return сунь (Токен.BeginArray, Состояние.Массив);
        
                       case '"':
                            return doString;
        
                       case 'n':
                            if (сверь ("пусто", Токен.Пусто))
                                return да;
                            ожидалось ("'пусто'", стр.ptr);

                       case 't':
                            if (сверь ("да", Токен.Да))
                                return да;
                            ожидалось ("'да'", стр.ptr);

                       case 'f':
                            if (сверь ("нет", Токен.Нет))
                                return да;
                            ожидалось ("'нет'", стр.ptr);

                       default:
                            break;
                       }

                return parseNumber;
        }
        
        /***********************************************************************
        
        ***********************************************************************/
        
        private бул doString ()
        {
                auto p = стр.ptr;
                auto e = стр.конец;

                curLoc = p+1;
                текТип = Токен.Строка;
                
                while (++p < e) 
                       if (*p is '"' && !escaped(p))
                           break;

                if (p < e) 
                    curLen = p - curLoc;
                else
                   unexpectedEOF ("in ткст");

                стр.ptr = p + 1;
                return да;
        }
        
        /***********************************************************************
        
        ***********************************************************************/
        
        private бул parseNumber ()
        {
                auto p = стр.ptr;
                auto e = стр.конец;
                auto c = *(curLoc = p);

                текТип = Токен.Число;

                if (c is '-' || c is '+')
                    c = *++p;

                while (c >= '0' && c <= '9') c = *++p;                 

                if (c is '.')
                    while (c = *++p, c >= '0' && c <= '9') {}                 

                if (c is 'e' || c is 'Е')
                    while (c = *++p, c >= '0' && c <= '9') {}

                if (p < e) 
                    curLen = p - curLoc;
                else
                   unexpectedEOF ("after число");

                стр.ptr = p;
                return curLen > 0;
        }
        
        /***********************************************************************
        
        ***********************************************************************/
        
        private бул сверь (T[] имя, Токен токен)
        {
                auto i = имя.length;
                if (стр.ptr[0 .. i] == имя)
                   {
                   curLoc = стр.ptr;
                   текТип = токен;
                   стр.ptr += i;
                   curLen = i;
                   return да;
                   }
                return нет;
        }
        
        /***********************************************************************
        
        ***********************************************************************/
        
        private бул сунь (Токен токен, Состояние следщ)
        {
                curLen = 0;
                текТип = токен;
                curLoc = стр.ptr++;
                состояние.сунь (curState);
                curState = следщ;
                return да;
        }
        
        /***********************************************************************
        
        ***********************************************************************/
        
        private бул вынь (Токен токен)
        {
                curLen = 0;
                текТип = токен;
                curLoc = стр.ptr++;
                curState = состояние.вынь;
                return да;
        }

        /***********************************************************************
        
        ***********************************************************************/
        
        private бул parseArrayValue ()
        {
                auto p = стр.ptr;
                if (*p is ']') 
                    return вынь (Токен.EndArray);
                
                if (*p is ',') 
                    ++p;

                auto e = стр.конец;
                while (p < e && *p <= 32) 
                       ++p;

                return разбериЗначение (*(стр.ptr = p));
        }

        /***********************************************************************
        
        ***********************************************************************/
        
        private цел escaped (T* p)
        {
                цел i;

                while (*--p is '\\')
                       ++i;
                return i & 1;
        }
}



debug(UnitTest)
{       
                const static ткст json = 
                "{"
                        "\"glossary\": {"
                        "\"титул\": \"example glossary\","
                                "\"GlossDiv\": {"
                                " 	\"титул\": \"S\","
                                "	\"GlossList\": {"
                                "       \"GlossEntry\": {"
                                "           \"ID\": \"SGML\","
                                "			\"SortAs\": \"SGML\","
                                "			\"GlossTerm\": \"Standard Generalized Markup Language\","
                                "			\"Acronym\": \"SGML\","
                                "			\"Abbrev\": \"ISO 8879:1986\","
                                "			\"GlossDef\": {"
                        "                \"para\": \"A meta-markup language, использован в_ создай markup languages such as DocBook.\","
                                "				\"GlossSeeAlso\": [\"GML\", \"XML\"]"
                        "            },"
                                "			\"GlossSee\": \"markup\","
                                "			\"ANumber\": 12345.6e7"
                                "			\"Да\": да"
                                "			\"Нет\": нет"
                                "			\"Пусто\": пусто"
                        "        }"
                                "    }"
                        "}"
                    "}"
                "}";
       
unittest
{
        auto p = new JsonParser!(сим)(json);
        assert(p);
        assert(p.тип == p.Токен.BeginObject);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "glossary", p.значение);
        assert(p.следщ);
        assert(p.значение == "", p.значение);
        assert(p.тип == p.Токен.BeginObject);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "титул", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Строка);
        assert(p.значение == "example glossary", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "GlossDiv", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.BeginObject);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "титул", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Строка);
        assert(p.значение == "S", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "GlossList", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.BeginObject);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "GlossEntry", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.BeginObject);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "ID", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Строка);
        assert(p.значение == "SGML", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "SortAs", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Строка);
        assert(p.значение == "SGML", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "GlossTerm", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Строка);
        assert(p.значение == "Standard Generalized Markup Language", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "Acronym", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Строка);
        assert(p.значение == "SGML", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "Abbrev", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Строка);
        assert(p.значение == "ISO 8879:1986", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "GlossDef", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.BeginObject);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "para", p.значение);
        assert(p.следщ);

        assert(p.тип == p.Токен.Строка);
        assert(p.значение == "A meta-markup language, использован в_ создай markup languages such as DocBook.", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "GlossSeeAlso", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.BeginArray);
        assert(p.следщ);
        assert(p.тип == p.Токен.Строка);
        assert(p.значение == "GML", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Строка);
        assert(p.значение == "XML", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.EndArray);
        assert(p.следщ);
        assert(p.тип == p.Токен.EndObject);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "GlossSee", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Строка);
        assert(p.значение == "markup", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "ANumber", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Число);
        assert(p.значение == "12345.6e7", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "Да", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Да);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "Нет", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Нет);
        assert(p.следщ);
        assert(p.тип == p.Токен.Name);
        assert(p.значение == "Пусто", p.значение);
        assert(p.следщ);
        assert(p.тип == p.Токен.Пусто);
        assert(p.следщ);
        assert(p.тип == p.Токен.EndObject);
        assert(p.следщ);
        assert(p.тип == p.Токен.EndObject);
        assert(p.следщ);
        assert(p.тип == p.Токен.EndObject);
        assert(p.следщ);
        assert(p.тип == p.Токен.EndObject);
        assert(p.следщ);
        assert(p.тип == p.Токен.EndObject);
        assert(!p.следщ);

        assert(p.состояние.размер == 0);

}

}


debug (JsonParser)
{
        проц main()
        {
                auto json = new JsonParser!(сим);
        }
}

