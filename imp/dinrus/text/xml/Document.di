/*******************************************************************************

        Copyright: Copyright (C) 2007 Aaron Craelius и Kris Bell  
                   все rights reserved.

        License:   BSD стиль: $(LICENSE)

        version:   Initial release: February 2008      

        Authors:   Aaron, Kris

*******************************************************************************/

module text.xml.Document;

package import text.xml.PullParser;

version(Clear)
        extern (C) ук memset(ук s, цел c, т_мера n);

version=discrete;

/*******************************************************************************

        Implements a DOM atop the XML парсер, supporting document 
        parsing, дерево traversal и ad-hoc дерево manИПulation.

        The DOM API is non-conformant, yet simple и functional in 
        стиль - местоположение a дерево узел of interest и operate upon or 
        around it. In все cases you will need a document экземпляр в_ 
        begin, whereupon it may be populated either by parsing an 
        existing document or via API manИПulation.

        This particular DOM employs a simple free-список в_ размести
        each of the дерево узелs, making it quite efficient at parsing
        XML documents. The tradeoff with such a scheme is that copying
        узелs из_ one document в_ другой требует a little ещё care
        than otherwise. We felt this was a reasonable tradeoff, given
        the throughput gains vs the relative infrequency of grafting
        operations. For grafting внутри or across documents, please
        use the перемести() и копируй() methods.

        другой simplification is related в_ сущность transcoding. This
        is not performed internally, и becomes the responsibility
        of the клиент. That is, the клиент should perform appropriate
        сущность transcoding as necessary. Paying the (high) transcoding 
        cost for все documents doesn't seem appropriate.

        Parse example
        ---
        auto doc = new Документ!(сим);
        doc.разбор (контент);

        auto выведи = new ДокПринтер!(сим);
        Стдвыв(выведи(doc)).нс;
        ---

        API example
        ---
        auto doc = new Документ!(сим);

        // прикрепи an xml заголовок
        doc.заголовок;

        // прикрепи an элемент with some атрибуты, plus 
        // a ветвь элемент with an attached данные значение
        doc.дерево.элемент   (пусто, "элемент")
                .attribute (пусто, "attrib1", "значение")
                .attribute (пусто, "attrib2")
                .элемент   (пусто, "ветвь", "значение");

        auto выведи = new ДокПринтер!(сим);
        Стдвыв(выведи(doc)).нс;
        ---

        Note that the document дерево() включает все узелs in the дерево,
        и not just элементы. Use doc.элементы в_ адрес the topmost
        элемент instead. For example, добавим an interior sibling в_
        the приор illustration
        ---
        doc.элементы.элемент (пусто, "sibling");
        ---

        Printing the имя of the topmost (корень) элемент:
        ---
        Стдвыв.форматнс ("первый элемент is '{}'", doc.элементы.имя);
        ---
        
        XPath examples:
        ---
        auto doc = new Документ!(сим);

        // прикрепи an элемент with some атрибуты, plus 
        // a ветвь элемент with an attached данные значение
        doc.дерево.элемент   (пусто, "элемент")
                .attribute (пусто, "attrib1", "значение")
                .attribute (пусто, "attrib2")
                .элемент   (пусто, "ветвь", "значение");

        // выбери named-элементы
        auto установи = doc.запрос["элемент"]["ветвь"];

        // выбери все атрибуты named "attrib1"
        установи = doc.запрос.descendant.attribute("attrib1");

        // выбери элементы with one предок и a совпадают текст значение
        установи = doc.запрос[].фильтр((doc.Узел n) {return n.ветви.hasData("значение");});
        ---

        Note that путь queries are temporal - they do not retain контент
        across mulitple queries. That is, the lifetime of a запрос результат
        is limited unless you explicitly копируй it. For example, this will 
        краш
        ---
        auto элементы = doc.запрос["элемент"];
        auto ветви = элементы["ветвь"];
        ---

        The above will lose элементы because the associated document reuses 
        узел пространство for subsequent queries. In order в_ retain results, do this
        ---
        auto элементы = doc.запрос["элемент"].dup;
        auto ветви = элементы["ветвь"];
        ---

        The above .dup is generally very small (a установи of pointers only). On
        the другой hand, recursive queries are fully supported
        ---
        установи = doc.запрос[].фильтр((doc.Узел n) {return n.запрос[].счёт > 1;});
        ---

        Typical usage tends в_ follow the following образец, Where each запрос 
        результат is processed before другой is initiated
        ---
        foreach (узел; doc.запрос.ветвь("элемент"))
                {
                // do something with each узел
                }
        ---

        Note that the парсер is templated for сим, шим or дим.
            
*******************************************************************************/

class Документ(T) : package PullParser!(T)
{
        public alias NodeImpl*  Узел;

        private Узел            корень; 
        private NodeImpl[]      список;
        private NodeImpl[][]    списки;
        private цел             индекс,
                                чанки,
                                freeсписки;
        private ПутьРЯР!(T)     xpath;

        /***********************************************************************
        
                Construct a DOM экземпляр. The optional parameter indicates
                the начальное число of узелs назначено в_ the freelist

        ***********************************************************************/

        this (бцел узелs = 1000)
        {
                assert (узелs > 50);
                super (пусто);
                xpath = new ПутьРЯР!(T);

                чанки = узелs;
                новый_список;
                корень = размести;
                корень.опр = ПТипУзлаРЯР.Документ;
        }

        /***********************************************************************
        
                Return an xpath укз в_ запрос this document. This начинается
                at the document корень.

                See also Узел.запрос

        ***********************************************************************/
        
        final ПутьРЯР!(T).NodeSet запрос ()
        {
                return xpath.старт (корень);
        }

        /***********************************************************************
        
                Return the корень document узел, из_ which все другой узелs
                are descended. 

                Returns пусто where there are no узелs in the document

        ***********************************************************************/
        
        final Узел дерево ()
        {
                return корень;
        }

        /***********************************************************************
        
                Return the topmost элемент узел, which is generally the
                корень of the элемент дерево.

                Returns пусто where there are no верх-уровень элемент узелs

        ***********************************************************************/
        
        final Узел элементы ()
        {
                if (корень)
                   {
                   auto узел = корень.lastChild;
                   while (узел)
                          if (узел.опр is ПТипУзлаРЯР.Элемент)
                              return узел;
                          else
                             узел = узел.предш;
                   }
                return пусто;
        }

        /***********************************************************************
        
                Reset the freelist. Subsequent allocation of document узелs 
                will overwrite приор экземпляры.

        ***********************************************************************/
        
        final Документ сбрось ()
        {
                корень.lastChild = корень.firstChild = пусто;
version(Clear)
{
                while (freeсписки)
                      {
                      auto список = списки[--freeсписки];
                      memset (список.ptr, 0, NodeImpl.sizeof * список.length);
                      }
}
else
{
                freeсписки = 0;
}
                новый_список;
                индекс = 1;
version(d)
{
                freeсписки = 0;          // needed в_ align the codegen!
}
                return this;
        }

        /***********************************************************************
        
               Prepend an XML заголовок в_ the document дерево

        ***********************************************************************/
        
        final Документ заголовок (T[] кодировка = пусто)
        {
                if (кодировка.length)
                    кодировка = `xml version="1.0" кодировка="`~кодировка~`"`;
                else
                   кодировка = `xml version="1.0" кодировка="UTF-8"`;

                корень.приставь (корень.создай(ПТипУзлаРЯР.ПИ, кодировка));
                return this;
        }

        /***********************************************************************
        
                Parse the given xml контент, which will reuse any existing 
                узел внутри this document. The resultant дерево is retrieved
                via the document 'дерево' attribute

        ***********************************************************************/
        
        final проц разбор(T[] xml)
        {       
                assert (xml);
                сбрось;
                super.сбрось (xml);
                auto тек = корень;
                бцел defNamespace;

                while (да) 
                      {
                      auto p = текст.точка;
                      switch (super.следщ) 
                             {
                             case ПТипТокенаРЯР.КонечныйЭлемент:
                             case ПТипТокенаРЯР.ПустойКонечныйЭлемент:
                                  assert (тек.хост);
                                  тек.конец = текст.точка;
                                  тек = тек.хост;                      
                                  break;
        
                             case ПТипТокенаРЯР.Данные:
version (discrete)
{
                                  auto узел = размести;
                                  узел.НеобрValue = super.НеобрValue;
                                  узел.опр = ПТипУзлаРЯР.Данные;
                                  тек.добавь (узел);
}
else
{
                                  if (тек.НеобрValue.length is 0)
                                      тек.НеобрValue = super.НеобрValue;
                                  else
                                     // multИПle данные sections
                                     тек.данные (super.НеобрValue);
}
                                  break;
        
                             case ПТипТокенаРЯР.НачальныйЭлемент:
                                  auto узел = размести;
                                  узел.хост = тек;
                                  узел.псеп_в_начале = super.префикс;
                                  узел.опр = ПТипУзлаРЯР.Элемент;
                                  узел.localName = super.localName;
                                  узел.старт = p;
                                
                                  // inline добавь
                                  if (тек.lastChild) 
                                     {
                                     тек.lastChild.nextSibling = узел;
                                     узел.prevSibling = тек.lastChild;
                                     тек.lastChild = узел;
                                     }
                                  else 
                                     {
                                     тек.firstChild = узел;
                                     тек.lastChild = узел;
                                     }
                                  тек = узел;
                                  break;
        
                             case ПТипТокенаРЯР.Атрибут:
                                  auto атр = размести;
                                  атр.псеп_в_начале = super.префикс;
                                  атр.НеобрValue = super.НеобрValue;
                                  атр.localName = super.localName;
                                  атр.опр = ПТипУзлаРЯР.Атрибут;
                                  тек.attrib (атр);
                                  break;
        
                             case ПТипТокенаРЯР.ПИ:
                                  тек.pi_ (super.НеобрValue, p[0..текст.точка-p]);
                                  break;
        
                             case ПТипТокенаРЯР.Комментарий:
                                  тек.comment_ (super.НеобрValue);
                                  break;
        
                             case ПТипТокенаРЯР.СиДанные:
                                  тек.cdata_ (super.НеобрValue);
                                  break;
        
                             case ПТипТокенаРЯР.Доктип:
                                  тек.doctype_ (super.НеобрValue);
                                  break;
        
                             case ПТипТокенаРЯР.Готово:
                                  return;

                             default:
                                  break;
                             }
                      }
        }
        
        /***********************************************************************
        
                размести a узел из_ the freelist

        ***********************************************************************/

        private final Узел размести ()
        {
                if (индекс >= список.length)
                    новый_список;

                auto p = &список[индекс++];
                p.doc = this;
version(Clear){}
else
{
                p.старт = p.конец = пусто;
                p.хост =
                p.prevSibling = 
                p.nextSibling = 
                p.firstChild =
                p.lastChild = 
                p.firstAttr =
                p.lastAttr = пусто;
                p.НеобрValue = 
                p.localName = 
                p.псеп_в_начале = пусто;
}
                return p;
        }

        /***********************************************************************
        
                размести a узел из_ the freelist

        ***********************************************************************/

        private final проц новый_список ()
        {
                индекс = 0;
                if (freeсписки >= списки.length)
                   {
                   списки.length = списки.length + 1;
                   списки[$-1] = new NodeImpl [чанки];
                   }
                список = списки[freeсписки++];
        }

        /***********************************************************************
        
                foreach support for visiting и selecting узелs. 
                
                A fruct is a low-overhead mechanism for capturing контекст 
                relating в_ an opApply, и we use it here в_ смети узелs
                when testing for various relationshИПs.

                See Узел.атрибуты и Узел.ветви

        ***********************************************************************/
        
        private struct Visitor
        {
                private Узел узел;
        
                public alias значение      данные;
                public alias hasValue   hasData;

                /***************************************************************
                
                        Is there anything в_ visit here?

                        Время complexity: O(1)

                ***************************************************************/
        
                бул exist ()
                {
                        return узел != пусто;
                }

                /***************************************************************
                
                        traverse sibling узелs

                ***************************************************************/
        
                цел opApply (цел delegate(ref Узел) дг)
                {
                        цел возвр;

                        for (auto n=узел; n; n = n.nextSibling)
                             if ((возвр = дг(n)) != 0) 
                                  break;
                        return возвр;
                }

                /***************************************************************
                
                        Locate a узел with a совпадают имя и/or префикс, 
                        и which проходки an optional фильтр. Each of the
                        аргументы will be ignored where they are пусто.

                        Время complexity: O(n)

                ***************************************************************/

                Узел имя (T[] префикс, T[] local, бул delegate(Узел) дг=пусто)
                {
                        for (auto n=узел; n; n = n.nextSibling)
                            {
                            if (local.ptr && local != n.localName)
                                continue;

                            if (префикс.ptr && префикс != n.псеп_в_начале)
                                continue;

                            if (дг.ptr && дг(n) is нет)
                                continue;

                            return n;
                            }
                        return пусто;
                }

                /***************************************************************
                
                        Scan узелs for a совпадают имя и/or префикс. Each 
                        of the аргументы will be ignored where they are пусто.

                        Время complexity: O(n)

                ***************************************************************/
        
                бул hasName (T[] префикс, T[] local)
                {
                        return имя (префикс, local) != пусто;
                }

                /***************************************************************
                
                        Locate a узел with a совпадают имя и/or префикс, 
                        и which совпадает a specified значение. Each of the
                        аргументы will be ignored where they are пусто.

                        Время complexity: O(n)

                ***************************************************************/
version (Фильтр)
{        
                Узел значение (T[] префикс, T[] local, T[] значение)
                {
                        if (значение.ptr)
                            return имя (префикс, local, (Узел n){return значение == n.НеобрValue;});
                        return имя (префикс, local);
                }
}
                /***************************************************************
        
                        Sweep узелs looking for a сверь, и returns either 
                        a узел or пусто. See значение(x,y,z) or имя(x,y,z) for
                        добавьitional filtering.

                        Время complexity: O(n)

                ***************************************************************/

                Узел значение (T[] сверь)
                {
                        if (сверь.ptr)
                            for (auto n=узел; n; n = n.nextSibling)
                                 if (сверь == n.НеобрValue)
                                     return n;
                        return пусто;
                }

                /***************************************************************
                
                        Sweep the узелs looking for a значение сверь. Returns 
                        да if найдено. See значение(x,y,z) or имя(x,y,z) for
                        добавьitional filtering.

                        Время complexity: O(n)

                ***************************************************************/
        
                бул hasValue (T[] сверь)
                {
                        return значение(сверь) != пусто;
                }
        }
        
        
        /***********************************************************************
        
                The узел implementation

        ***********************************************************************/
        
        private struct NodeImpl
        {
                public ук            пользователь;           /// открой for usage
                package Документ        doc;            // owning document
                package ПТипУзлаРЯР     опр;             // узел тип
                package T[]             псеп_в_начале;       // namespace
                package T[]             localName;      // имя
                package T[]             НеобрValue;       // данные значение
                
                package Узел            хост,           // предок узел
                                        prevSibling,    // приор
                                        nextSibling,    // следщ
                                        firstChild,     // голова
                                        lastChild,      // хвост
                                        firstAttr,      // голова
                                        lastAttr;       // хвост

                package T*              конец,            // срез of the  ...
                                        старт;          // original xml текст 

                /***************************************************************
                
                        Return the hosting document

                ***************************************************************/
        
                Документ document () 
                {
                        return doc;
                }
        
                /***************************************************************
                
                        Return the узел тип-опр

                ***************************************************************/
        
                ПТипУзлаРЯР тип () 
                {
                        return опр;
                }
        
                /***************************************************************
                
                        Return the предок, which may be пусто

                ***************************************************************/
        
                Узел предок () 
                {
                        return хост;
                }
        
                /***************************************************************
                
                        Return the первый ветвь, which may be пусто

                ***************************************************************/
                
                Узел ветвь () 
                {
                        return firstChild;
                }
        
                /***************************************************************
                
                        Return the последний ветвь, which may be пусто

                        Deprecated: exposes too much implementation detail. 
                                    Please файл a ticket if you really need 
                                    this functionality

                ***************************************************************/
        
                deprecated Узел childTail () 
                {
                        return lastChild;
                }
        
                /***************************************************************
                
                        Return the приор sibling, which may be пусто

                ***************************************************************/
        
                Узел предш () 
                {
                        return prevSibling;
                }
        
                /***************************************************************
                
                        Return the следщ sibling, which may be пусто

                ***************************************************************/
        
                Узел следщ () 
                {
                        return nextSibling;
                }
        
                /***************************************************************
                
                        Return the namespace префикс of this узел (may be пусто)

                ***************************************************************/
        
                T[] префикс ()
                {
                        return псеп_в_начале;
                }

                /***************************************************************
                
                        Набор the namespace префикс of this узел (may be пусто)

                ***************************************************************/
        
                Узел префикс (T[] замени)
                {
                        псеп_в_начале = замени;
                        return this;
                }

                /***************************************************************
                
                        Return the vanilla узел имя (sans префикс)

                ***************************************************************/
        
                T[] имя ()
                {
                        return localName;
                }

                /***************************************************************
                
                        Набор the vanilla узел имя (sans префикс)

                ***************************************************************/
        
                Узел имя (T[] замени)
                {
                        localName = замени;
                        return this;
                }

                /***************************************************************
                
                        Return the данные контент, which may be пусто

                ***************************************************************/
        
                T[] значение ()
                {
version(discrete)
{
                        if (тип is ПТипУзлаРЯР.Элемент)
                            foreach (ветвь; ветви)
                                     if (ветвь.опр is ПТипУзлаРЯР.Данные || 
                                         ветвь.опр is ПТипУзлаРЯР.СиДанные)
                                         return ветвь.НеобрValue;
}
                        return НеобрValue;
                }
                
                /***************************************************************
                
                        Набор the необр данные контент, which may be пусто

                ***************************************************************/
        
                проц значение (T[] знач)
                {
version(discrete)
{
                        if (тип is ПТипУзлаРЯР.Элемент)
                            foreach (ветвь; ветви)
                                     if (ветвь.опр is ПТипУзлаРЯР.Данные)
                                         return ветвь.значение (знач);
}
                        НеобрValue = знач; 
                        измени;
                }
                
                /***************************************************************
                
                        Return the full узел имя, which is a combination 
                        of the префикс & local names. Nodes without a префикс 
                        will return local-имя only

                ***************************************************************/
        
                T[] вТкст (T[] вывод = пусто)
                {
                        if (псеп_в_начале.length)
                           {
                           auto длин = псеп_в_начале.length + localName.length + 1;
                           
                           // is the префикс already attached в_ the имя?
                           if (псеп_в_начале.ptr + псеп_в_начале.length + 1 is localName.ptr &&
                               ':' is *(localName.ptr-1))
                               return псеп_в_начале.ptr [0 .. длин];
       
                           // nope, копируй the discrete segments преобр_в вывод
                           if (вывод.length < длин)
                               вывод.length = длин;
                           вывод[0..псеп_в_начале.length] = псеп_в_начале;
                           вывод[псеп_в_начале.length] = ':';
                           вывод[псеп_в_начале.length+1 .. длин] = localName;
                           return вывод[0..длин];
                           }

                        return localName;
                }
                
                /***************************************************************
                
                        Return the индекс of this узел, or как many 
                        приор siblings it имеется. 

                        Время complexity: O(n) 

                ***************************************************************/
       
                бцел позиция ()
                {
                        auto счёт = 0;
                        auto приор = prevSibling;
                        while (приор)
                               ++счёт, приор = приор.prevSibling;                        
                        return счёт;
                }
                
                /***************************************************************
                
                        Detach this узел из_ its предок и siblings

                ***************************************************************/
        
                Узел открепи ()
                {
                        return удали;
                }

                /***************************************************************
        
                        Return an xpath укз в_ запрос this узел

                        See also Документ.запрос

                ***************************************************************/
        
                final ПутьРЯР!(T).NodeSet запрос ()
                {
                        return doc.xpath.старт (this);
                }

                /***************************************************************
                
                        Return a foreach обходчик for узел ветви

                ***************************************************************/
        
                Visitor ветви () 
                {
                        Visitor v = {firstChild};
                        return v;
                }
        
                /***************************************************************
                
                        Return a foreach обходчик for узел атрибуты

                ***************************************************************/
        
                Visitor атрибуты () 
                {
                        Visitor v = {firstAttr};
                        return v;
                }
        
                /***************************************************************
                
                        Returns whether there are атрибуты present or not

                        Deprecated: use узел.атрибуты.exist instead

                ***************************************************************/
        
                deprecated бул hasAttributes () 
                {
                        return firstAttr !is пусто;
                }
                               
                /***************************************************************
                
                        Returns whether there are ветви present or nor

                        Deprecated: use узел.ветвь or узел.ветви.exist
                        instead

                ***************************************************************/
        
                deprecated бул hasChildren () 
                {
                        return firstChild !is пусто;
                }
                
                /***************************************************************
                
                        Duplicate the given подст-дерево преобр_в place as a ветвь 
                        of this узел. 
                        
                        Returns a reference в_ the subtree

                ***************************************************************/
        
                Узел копируй (Узел дерево)
                {
                        assert (дерево);
                        дерево = дерево.клонируй;
                        дерево.migrate (document);

                        if (дерево.опр is ПТипУзлаРЯР.Атрибут)
                            attrib (дерево);
                        else
                            добавь (дерево);
                        return дерево;
                }

                /***************************************************************
                
                        Relocate the given подст-дерево преобр_в place as a ветвь 
                        of this узел. 
                        
                        Returns a reference в_ the subtree

                ***************************************************************/
        
                Узел перемести (Узел дерево)
                {
                        дерево.открепи;
                        if (дерево.doc is doc)
                           {
                           if (дерево.опр is ПТипУзлаРЯР.Атрибут)
                               attrib (дерево);
                           else
                              добавь (дерево);
                           }
                        else
                           дерево = копируй (дерево);
                        return дерево;
                }

                /***************************************************************
        
                        Appends a new (ветвь) Элемент и returns a reference 
                        в_ it.

                ***************************************************************/
        
                Узел элемент (T[] префикс, T[] local, T[] значение = пусто)
                {
                        return element_ (префикс, local, значение).измени;
                }
        
                /***************************************************************
        
                        Attaches an Атрибут и returns this, the хост 

                ***************************************************************/
        
                Узел attribute (T[] префикс, T[] local, T[] значение = пусто)
                { 
                        return attribute_ (префикс, local, значение).измени;
                }
        
                /***************************************************************
        
                        Attaches a Данные узел и returns this, the хост

                ***************************************************************/
        
                Узел данные (T[] данные)
                {
                        return data_ (данные).измени;
                }
        
                /***************************************************************
        
                        Attaches a СиДанные узел и returns this, the хост

                ***************************************************************/
        
                Узел cdata (T[] cdata)
                {
                        return cdata_ (cdata).измени;
                }
        
                /***************************************************************
        
                        Attaches a Комментарий узел и returns this, the хост

                ***************************************************************/
        
                Узел коммент (T[] коммент)
                {
                        return comment_ (коммент).измени;
                }
        
                /***************************************************************
        
                        Attaches a Доктип узел и returns this, the хост

                ***************************************************************/
        
                Узел doctype (T[] doctype)
                {
                        return doctype_ (doctype).измени;
                }
        
                /***************************************************************
        
                        Attaches a ПИ узел и returns this, the хост

                ***************************************************************/
        
                Узел pi (T[] pi)
                {
                        return pi_ (pi, пусто).измени;
                }

                /***************************************************************
        
                        Attaches a ветвь Элемент, и returns a reference 
                        в_ the ветвь

                ***************************************************************/
        
                private Узел element_ (T[] префикс, T[] local, T[] значение = пусто)
                {
                        auto узел = создай (ПТипУзлаРЯР.Элемент, пусто);
                        добавь (узел.установи (префикс, local));
version(discrete)
{
                        if (значение.length)
                            узел.data_ (значение);
}
else
{
                        узел.НеобрValue = значение;
}
                        return узел;
                }
        
                /***************************************************************
        
                        Attaches an Атрибут, и returns the хост

                ***************************************************************/
        
                private Узел attribute_ (T[] префикс, T[] local, T[] значение = пусто)
                { 
                        auto узел = создай (ПТипУзлаРЯР.Атрибут, значение);
                        attrib (узел.установи (префикс, local));
                        return this;
                }
        
                /***************************************************************
        
                        Attaches a Данные узел, и returns the хост

                ***************************************************************/
        
                private Узел data_ (T[] данные)
                {
                        добавь (создай (ПТипУзлаРЯР.Данные, данные));
                        return this;
                }
        
                /***************************************************************
        
                        Attaches a СиДанные узел, и returns the хост

                ***************************************************************/
        
                private Узел cdata_ (T[] cdata)
                {
                        добавь (создай (ПТипУзлаРЯР.СиДанные, cdata));
                        return this;
                }
        
                /***************************************************************
        
                        Attaches a Комментарий узел, и returns the хост

                ***************************************************************/
        
                private Узел comment_ (T[] коммент)
                {
                        добавь (создай (ПТипУзлаРЯР.Комментарий, коммент));
                        return this;
                }
        
                /***************************************************************
        
                        Attaches a ПИ узел, и returns the хост

                ***************************************************************/
        
                private Узел pi_ (T[] pi, T[] patch)
                {
                        добавь (создай(ПТипУзлаРЯР.ПИ, pi).patch(patch));
                        return this;
                }
        
                /***************************************************************
        
                        Attaches a Доктип узел, и returns the хост

                ***************************************************************/
        
                private Узел doctype_ (T[] doctype)
                {
                        добавь (создай (ПТипУзлаРЯР.Доктип, doctype));
                        return this;
                }
        
                /***************************************************************
                
                        Доб an attribute в_ this узел, The given attribute
                        cannot have an existing предок.

                ***************************************************************/
        
                private проц attrib (Узел узел)
                {
                        assert (узел.предок is пусто);
                        узел.хост = this;
                        if (lastAttr) 
                           {
                           lastAttr.nextSibling = узел;
                           узел.prevSibling = lastAttr;
                           lastAttr = узел;
                           }
                        else 
                           firstAttr = lastAttr = узел;
                }
        
                /***************************************************************
                
                        Доб a узел в_ this one. The given узел cannot
                        have an existing предок.

                ***************************************************************/
        
                private проц добавь (Узел узел)
                {
                        assert (узел.предок is пусто);
                        узел.хост = this;
                        if (lastChild) 
                           {
                           lastChild.nextSibling = узел;
                           узел.prevSibling = lastChild;
                           lastChild = узел;
                           }
                        else 
                           firstChild = lastChild = узел;                  
                }

                /***************************************************************
                
                        Prepend a узел в_ this one. The given узел cannot
                        have an existing предок.

                ***************************************************************/
        
                private проц приставь (Узел узел)
                {
                        assert (узел.предок is пусто);
                        узел.хост = this;
                        if (firstChild) 
                           {
                           firstChild.prevSibling = узел;
                           узел.nextSibling = firstChild;
                           firstChild = узел;
                           }
                        else 
                           firstChild = lastChild = узел;
                }
                
                /***************************************************************
        
                        Configure узел значения
        
                ***************************************************************/
        
                private Узел установи (T[] префикс, T[] local)
                {
                        this.localName = local;
                        this.псеп_в_начале = префикс;
                        return this;
                }
        
                /***************************************************************
        
                        Creates и returns a ветвь Элемент узел

                ***************************************************************/
        
                private Узел создай (ПТипУзлаРЯР тип, T[] значение)
                {
                        auto узел = document.размести;
                        узел.НеобрValue = значение;
                        узел.опр = тип;
                        return узел;
                }
        
                /***************************************************************
                
                        Detach this узел из_ its предок и siblings

                ***************************************************************/
        
                private Узел удали()
                {
                        if (! хост) 
                              return this;
                        
                        измени;
                        if (prevSibling && nextSibling) 
                           {
                           prevSibling.nextSibling = nextSibling;
                           nextSibling.prevSibling = prevSibling;
                           prevSibling = пусто;
                           nextSibling = пусто;
                           хост = пусто;
                           }
                        else 
                           if (nextSibling)
                              {
                              debug assert(хост.firstChild == this);
                              предок.firstChild = nextSibling;
                              nextSibling.prevSibling = пусто;
                              nextSibling = пусто;
                              хост = пусто;
                              }
                           else 
                              if (тип != ПТипУзлаРЯР.Атрибут)
                                 {
                                 if (prevSibling)
                                    {
                                    debug assert(хост.lastChild == this);
                                    хост.lastChild = prevSibling;
                                    prevSibling.nextSibling = пусто;
                                    prevSibling = пусто;
                                    хост = пусто;
                                    }
                                 else
                                    {
                                    debug assert(хост.firstChild == this);
                                    debug assert(хост.lastChild == this);
                                    хост.firstChild = пусто;
                                    хост.lastChild = пусто;
                                    хост = пусто;
                                    }
                                 }
                              else
                                 {
                                 if (prevSibling)
                                    {
                                    debug assert(хост.lastAttr == this);
                                    хост.lastAttr = prevSibling;
                                    prevSibling.nextSibling = пусто;
                                    prevSibling = пусто;
                                    хост = пусто;
                                    }
                                 else
                                    {
                                    debug assert(хост.firstAttr == this);
                                    debug assert(хост.lastAttr == this);
                                    хост.firstAttr = пусто;
                                    хост.lastAttr = пусто;
                                    хост = пусто;
                                    }
                                 }

                        return this;
                }

                /***************************************************************
        
                        Patch the serialization текст, causing ДокПринтер
                        в_ ignore the subtree of this узел, и instead
                        излей the provопрed текст as необр XML вывод.

                        Предупреждение: this function does *not* копируй the provопрed 
                        текст, и may be removed из_ future revisions

                ***************************************************************/
        
                private Узел patch (T[] текст)
                {
                        конец = текст.ptr + текст.length;
                        старт = текст.ptr;
                        return this;
                }
        
                /***************************************************************

                        purge serialization кэш for this узел и its
                        ancestors

                ***************************************************************/
        
                private Узел измени ()
                {
                        auto узел = this;
                        do {
                           узел.конец = пусто;
                           } while ((узел = узел.хост) !is пусто);

                        return this;
                }

                /***************************************************************
                
                        Duplicate a single узел

                ***************************************************************/
        
                private Узел dup ()
                {
                        return создай(тип, НеобрValue.dup).установи(псеп_в_начале.dup, localName.dup);
                }

                /***************************************************************
                
                        Duplicate a subtree

                ***************************************************************/
        
                private Узел клонируй ()
                {
                        auto p = dup;

                        foreach (атр; атрибуты)
                                 p.attrib (атр.dup);
                        foreach (ветвь; ветви)
                                 p.добавь (ветвь.клонируй);
                        return p;
                }

                /***************************************************************

                        Reset the document хост for this subtree

                ***************************************************************/
        
                private проц migrate (Документ хост)
                {
                        this.doc = хост;
                        foreach (атр; атрибуты)
                                 атр.migrate (хост);
                        foreach (ветвь; ветви)
                                 ветвь.migrate (хост);
                }
        }
}


/*******************************************************************************

        XPath support 

        Provопрes support for common XPath axis и filtering functions,
        via a исконный-D interface instead of typical interpreted notation.

        The general опрea here is в_ generate a NodeSet consisting of those
        дерево-узелs which satisfy a filtering function. The direction, or
        axis, of дерево traversal is governed by one of several predefined
        operations. все methods facilitiate вызов-chaining, where each step 
        returns a new NodeSet экземпляр в_ be operated upon.

        The установи of узелs themselves are собериed in a freelist, avoопрing
        куча-activity и making good use of D Массив-slicing facilities.

        XPath examples
        ---
        auto doc = new Документ!(сим);

        // прикрепи an элемент with some атрибуты, plus 
        // a ветвь элемент with an attached данные значение
        doc.дерево.элемент   (пусто, "элемент")
                .attribute (пусто, "attrib1", "значение")
                .attribute (пусто, "attrib2")
                .элемент   (пусто, "ветвь", "значение");

        // выбери named-элементы
        auto установи = doc.запрос["элемент"]["ветвь"];

        // выбери все атрибуты named "attrib1"
        установи = doc.запрос.descendant.attribute("attrib1");

        // выбери элементы with one предок и a совпадают текст значение
        установи = doc.запрос[].фильтр((doc.Узел n) {return n.ветви.hasData("значение");});
        ---

        Note that путь queries are temporal - they do not retain контент
        across mulitple queries. That is, the lifetime of a запрос результат
        is limited unless you explicitly копируй it. For example, this will 
        краш в_ operate as one might expect
        ---
        auto элементы = doc.запрос["элемент"];
        auto ветви = элементы["ветвь"];
        ---

        The above will lose элементы, because the associated document reuses 
        узел пространство for subsequent queries. In order в_ retain results, do this
        ---
        auto элементы = doc.запрос["элемент"].dup;
        auto ветви = элементы["ветвь"];
        ---

        The above .dup is generally very small (a установи of pointers only). On
        the другой hand, recursive queries are fully supported
        ---
        установи = doc.запрос[].фильтр((doc.Узел n) {return n.запрос[].счёт > 1;});
        ---
  
        Typical usage tends в_ exhibit the following образец, Where each запрос 
        результат is processed before другой is initiated
        ---
        foreach (узел; doc.запрос.ветвь("элемент"))
                {
                // do something with each узел
                }
        ---

        Supported axis include:
        ---
        .ветвь                  immediate ветви
        .предок                 immediate предок 
        .следщ                   following siblings
        .предш                   приор siblings
        .ancestor               все parents
        .descendant             все descendants
        .данные                   текст ветви
        .cdata                  cdata ветви
        .attribute              attribute ветви
        ---

        Each of the above прими an optional ткст, which is использован in an
        axis-specific way в_ фильтр узелs. For экземпляр, a .ветвь("food") 
        will фильтр <food> ветвь элементы. These variants are shortcuts
        в_ using a фильтр в_ post-process a результат. Each of the above also
        have variants which прими a delegate instead.

        In general, you traverse an axis и operate upon the results. The
        operation applied may be другой axis traversal, or a filtering 
        step. все steps can be, и generally should be chained together. 
        Filters are implemented via a delegate mechanism
        ---
        .фильтр (бул delegate(Узел))
        ---

        Where the delegate returns да if the узел проходки the фильтр. An
        example might be selecting все узелs with a specific attribute
        ---
        auto установи = doc.запрос.descendant.фильтр (
                    (doc.Узел n){return n.атрибуты.hasName (пусто, "тест");}
                   );
        ---

        Obviously this is not as clean и tопрy as да XPath notation, but 
        that can be wrapped atop this API instead. The benefit here is one 
        of необр throughput - important for some applications. 

        Note that every operation returns a discrete результат. Methods первый()
        и последний() also return a установи of one or zero элементы. Some language
        specific extensions are provопрed for too
        ---
        * .ветвь() can be substituted with [] notation instead

        * [] notation can be использован в_ индекс a specific элемент, like .н_ый()

        * the .узелs attribute exposes an underlying Узел[], which may be
          sliced or traversed in the usual D manner
        ---

       Other (запрос результат) utility methods include
       ---
       .dup
       .первый
       .последний
       .opIndex
       .н_ый
       .счёт
       .opApply
       ---

       ПутьРЯР itself needs в_ be a class in order в_ avoопр вперёд-ref issues.

*******************************************************************************/

private class ПутьРЯР(T)
{       
        public alias Документ!(T) Док;          /// the typed document
        public alias Док.Узел     Узел;         /// генерный document узел
         
        private Узел[]          freelist;
        private бцел            freeIndex,
                                markIndex;
        private бцел            recursion;

        /***********************************************************************
        
                Prime a запрос

                Returns a NodeSet containing just the given узел, which
                can then be использован в_ cascade results преобр_в subsequent NodeSet
                экземпляры.

        ***********************************************************************/
        
        final NodeSet старт (Узел корень)
        {
                // we have в_ support recursion which may occur внутри
                // a фильтр обрвызов
                if (recursion is 0)
                   {
                   if (freelist.length is 0)
                       freelist.length = 256;
                   freeIndex = 0;
                   }

                NodeSet установи = {this};
                auto метка = freeIndex;
                размести(корень);
                return установи.присвой (метка);
        }

        /***********************************************************************
        
                This is the meat of XPath support. все of the NodeSet
                operators exist here, in order в_ активируй вызов-chaining.

                Note that some of the axis do дво-duty as a фильтр 
                also. This is just a convenience factor, и doesn't 
                change the underlying mechanisms.

        ***********************************************************************/
        
        struct NodeSet
        {
                private ПутьРЯР хост;
                public  Узел[]  узелs;  /// Массив of selected узелs
               
                /***************************************************************
        
                        Return a дубликат NodeSet

                ***************************************************************/
        
                NodeSet dup ()
                {
                        NodeSet копируй = {хост};
                        копируй.узелs = узелs.dup;
                        return копируй;
                }

                /***************************************************************
        
                        Return the число of selected узелs in the установи

                ***************************************************************/
        
                бцел счёт ()
                {
                        return узелs.length;
                }

                /***************************************************************
        
                        Return a установи containing just the первый узел of
                        the текущ установи

                ***************************************************************/
        
                NodeSet первый ()
                {
                        return н_ый (0);
                }

                /***************************************************************
       
                        Return a установи containing just the последний узел of
                        the текущ установи

                ***************************************************************/
        
                NodeSet последний ()
                {       
                        auto i = узелs.length;
                        if (i > 0)
                            --i;
                        return н_ый (i);
                }

                /***************************************************************
        
                        Return a установи containing just the н_ый узел of
                        the текущ установи

                ***************************************************************/
        
                NodeSet opIndex (бцел i)
                {
                        return н_ый (i);
                }

                /***************************************************************
        
                        Return a установи containing just the н_ый узел of
                        the текущ установи
        
                ***************************************************************/
        
                NodeSet н_ый (бцел индекс)
                {
                        NodeSet установи = {хост};
                        auto метка = хост.метка;
                        if (индекс < узелs.length)
                            хост.размести (узелs [индекс]);
                        return установи.присвой (метка);
                }

                /***************************************************************
        
                        Return a установи containing все ветвь элементы of the 
                        узелs внутри this установи
        
                ***************************************************************/
        
                NodeSet opSlice ()
                {
                        return ветвь();
                }

                /***************************************************************
        
                        Return a установи containing все ветвь элементы of the 
                        узелs внутри this установи, which сверь the given имя

                ***************************************************************/
        
                NodeSet opIndex (T[] имя)
                {
                        return ветвь (имя);
                }

                /***************************************************************
        
                        Return a установи containing все предок элементы of the 
                        узелs внутри this установи, which сверь the optional имя

                ***************************************************************/
        
                NodeSet предок (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return предок ((Узел узел){return узел.имя == имя;});
                        return предок (&always);
                }

                /***************************************************************
        
                        Return a установи containing все данные узелs of the 
                        узелs внутри this установи, which сверь the optional
                        значение

                ***************************************************************/
        
                NodeSet данные (T[] значение = пусто)
                {
                        if (значение.ptr)
                            return ветвь ((Узел узел){return узел.значение == значение;}, 
                                           ПТипУзлаРЯР.Данные);
                        return ветвь (&always, ПТипУзлаРЯР.Данные);
                }

                /***************************************************************
        
                        Return a установи containing все cdata узелs of the 
                        узелs внутри this установи, which сверь the optional
                        значение

                ***************************************************************/
        
                NodeSet cdata (T[] значение = пусто)
                {
                        if (значение.ptr)
                            return ветвь ((Узел узел){return узел.значение == значение;}, 
                                           ПТипУзлаРЯР.СиДанные);
                        return ветвь (&always, ПТипУзлаРЯР.СиДанные);
                }

                /***************************************************************
        
                        Return a установи containing все атрибуты of the 
                        узелs внутри this установи, which сверь the optional
                        имя

                ***************************************************************/
        
                NodeSet attribute (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return attribute ((Узел узел){return узел.имя == имя;});
                        return attribute (&always);
                }

                /***************************************************************
        
                        Return a установи containing все descendant элементы of 
                        the узелs внутри this установи, which сверь the given имя

                ***************************************************************/
        
                NodeSet descendant (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return descendant ((Узел узел){return узел.имя == имя;});
                        return descendant (&always);
                }

                /***************************************************************
        
                        Return a установи containing все ветвь элементы of the 
                        узелs внутри this установи, which сверь the optional имя

                ***************************************************************/
        
                NodeSet ветвь (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return ветвь ((Узел узел){return узел.имя == имя;});
                        return  ветвь (&always);
                }

                /***************************************************************
        
                        Return a установи containing все ancestor элементы of 
                        the узелs внутри this установи, which сверь the optional
                        имя

                ***************************************************************/
        
                NodeSet ancestor (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return ancestor ((Узел узел){return узел.имя == имя;});
                        return ancestor (&always);
                }

                /***************************************************************
        
                        Return a установи containing все приор sibling элементы of 
                        the узелs внутри this установи, which сверь the optional
                        имя

                ***************************************************************/
        
                NodeSet предш (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return предш ((Узел узел){return узел.имя == имя;});
                        return предш (&always);
                }

                /***************************************************************
        
                        Return a установи containing все subsequent sibling 
                        элементы of the узелs внутри this установи, which 
                        сверь the optional имя

                ***************************************************************/
        
                NodeSet следщ (T[] имя = пусто)
                {
                        if (имя.ptr)
                            return следщ ((Узел узел){return узел.имя == имя;});
                        return следщ (&always);
                }

                /***************************************************************
        
                        Return a установи containing все узелs внутри this установи
                        which пароль the filtering тест

                ***************************************************************/
        
                NodeSet фильтр (бул delegate(Узел) фильтр)
                {
                        NodeSet установи = {хост};
                        auto метка = хост.метка;

                        foreach (узел; узелs)
                                 тест (фильтр, узел);
                        return установи.присвой (метка);
                }

                /***************************************************************
        
                        Return a установи containing все ветвь узелs of 
                        the узелs внутри this установи which пароль the 
                        filtering тест

                ***************************************************************/
        
                NodeSet ветвь (бул delegate(Узел) фильтр, 
                               ПТипУзлаРЯР тип = ПТипУзлаРЯР.Элемент)
                {
                        NodeSet установи = {хост};
                        auto метка = хост.метка;

                        foreach (предок; узелs)
                                 foreach (ветвь; предок.ветви)
                                          if (ветвь.опр is тип)
                                              тест (фильтр, ветвь);
                        return установи.присвой (метка);
                }

                /***************************************************************
        
                        Return a установи containing все attribute узелs of 
                        the узелs внутри this установи which пароль the given
                        filtering тест

                ***************************************************************/
        
                NodeSet attribute (бул delegate(Узел) фильтр)
                {
                        NodeSet установи = {хост};
                        auto метка = хост.метка;

                        foreach (узел; узелs)
                                 foreach (атр; узел.атрибуты)
                                          тест (фильтр, атр);
                        return установи.присвой (метка);
                }

                /***************************************************************
        
                        Return a установи containing все descendant узелs of 
                        the узелs внутри this установи, which пароль the given
                        filtering тест

                ***************************************************************/
        
                NodeSet descendant (бул delegate(Узел) фильтр, 
                                    ПТипУзлаРЯР тип = ПТипУзлаРЯР.Элемент)
                {
                        проц traverse (Узел предок)
                        {
                                 foreach (ветвь; предок.ветви)
                                         {
                                         if (ветвь.опр is тип)
                                             тест (фильтр, ветвь);
                                         if (ветвь.firstChild)
                                             traverse (ветвь);
                                         }                                                
                        }

                        NodeSet установи = {хост};
                        auto метка = хост.метка;

                        foreach (узел; узелs)
                                 traverse (узел);
                        return установи.присвой (метка);
                }

                /***************************************************************
        
                        Return a установи containing все предок узелs of 
                        the узелs внутри this установи which пароль the given
                        filtering тест

                ***************************************************************/
        
                NodeSet предок (бул delegate(Узел) фильтр)
                {
                        NodeSet установи = {хост};
                        auto метка = хост.метка;

                        foreach (узел; узелs)
                                {
                                auto p = узел.предок;
                                if (p && p.опр != ПТипУзлаРЯР.Документ && !установи.имеется(p))
                                   {
                                   тест (фильтр, p);
                                   // continually обнови our установи of узелs, so
                                   // that установи.имеется() can see a приор Запись.
                                   // Ideally we'd avoопр invoking тест() on
                                   // приор узелs, but I don't feel the добавьed
                                   // complexity is warranted
                                   установи.узелs = хост.срез (метка);
                                   }
                                }
                        return установи.присвой (метка);
                }

                /***************************************************************
        
                        Return a установи containing все ancestor узелs of 
                        the узелs внутри this установи, which пароль the given
                        filtering тест

                ***************************************************************/
        
                NodeSet ancestor (бул delegate(Узел) фильтр)
                {
                        NodeSet установи = {хост};
                        auto метка = хост.метка;

                        проц traverse (Узел ветвь)
                        {
                                auto p = ветвь.хост;
                                if (p && p.опр != ПТипУзлаРЯР.Документ && !установи.имеется(p))
                                   {
                                   тест (фильтр, p);
                                   // continually обнови our установи of узелs, so
                                   // that установи.имеется() can see a приор Запись.
                                   // Ideally we'd avoопр invoking тест() on
                                   // приор узелs, but I don't feel the добавьed
                                   // complexity is warranted
                                   установи.узелs = хост.срез (метка);
                                   traverse (p);
                                   }
                        }

                        foreach (узел; узелs)
                                 traverse (узел);
                        return установи.присвой (метка);
                }

                /***************************************************************
        
                        Return a установи containing все following siblings 
                        of the ones внутри this установи, which пароль the given
                        filtering тест

                ***************************************************************/
        
                NodeSet следщ (бул delegate(Узел) фильтр, 
                              ПТипУзлаРЯР тип = ПТипУзлаРЯР.Элемент)
                {
                        NodeSet установи = {хост};
                        auto метка = хост.метка;

                        foreach (узел; узелs)
                                {
                                auto p = узел.nextSibling;
                                while (p)
                                      {
                                      if (p.опр is тип)
                                          тест (фильтр, p);
                                      p = p.nextSibling;
                                      }
                                }
                        return установи.присвой (метка);
                }

                /***************************************************************
        
                        Return a установи containing все приор sibling узелs 
                        of the ones внутри this установи, which пароль the given
                        filtering тест

                ***************************************************************/
        
                NodeSet предш (бул delegate(Узел) фильтр, 
                              ПТипУзлаРЯР тип = ПТипУзлаРЯР.Элемент)
                {
                        NodeSet установи = {хост};
                        auto метка = хост.метка;

                        foreach (узел; узелs)
                                {
                                auto p = узел.prevSibling;
                                while (p)
                                      {
                                      if (p.опр is тип)
                                          тест (фильтр, p);
                                      p = p.prevSibling;
                                      }
                                }
                        return установи.присвой (метка);
                }

                /***************************************************************
                
                        Traverse the узелs of this установи

                ***************************************************************/
        
                цел opApply (цел delegate(ref Узел) дг)
                {
                        цел возвр;

                        foreach (узел; узелs)
                                 if ((возвр = дг (узел)) != 0) 
                                      break;
                        return возвр;
                }

                /***************************************************************
        
                        Common predicate
                                
                ***************************************************************/
        
                private бул always (Узел узел)
                {
                        return да;
                }

                /***************************************************************
        
                        Assign a срез of the freelist в_ this NodeSet

                ***************************************************************/
        
                private NodeSet присвой (бцел метка)
                {
                        узелs = хост.срез (метка);
                        return *this;
                }

                /***************************************************************
        
                        Execute a фильтр on the given узел. We have в_
                        deal with potential запрос recusion, so we установи
                        все kinda crap в_ recover из_ that

                ***************************************************************/
        
                private проц тест (бул delegate(Узел) фильтр, Узел узел)
                {
                        auto вынь = хост.сунь;
                        auto добавь = фильтр (узел);
                        хост.вынь (вынь);
                        if (добавь)
                            хост.размести (узел);
                }

                /***************************************************************
        
                        We typically need в_ фильтр ancestors in order
                        в_ avoопр duplicates, so this is использован for those
                        purposes                        

                ***************************************************************/
        
                private бул имеется (Узел p)
                {
                        foreach (узел; узелs)
                                 if (узел is p)
                                     return да;
                        return нет;
                }
        }

        /***********************************************************************

                Return the текущ freelist индекс
                        
        ***********************************************************************/
        
        private бцел метка ()
        {       
                return freeIndex;
        }

        /***********************************************************************

                Recurse и save the текущ состояние
                        
        ***********************************************************************/
        
        private бцел сунь ()
        {       
                ++recursion;
                return freeIndex;
        }

        /***********************************************************************

                Restore приор состояние
                        
        ***********************************************************************/
        
        private проц вынь (бцел приор)
        {       
                freeIndex = приор;
                --recursion;
        }

        /***********************************************************************
        
                Return a срез of the freelist

        ***********************************************************************/
        
        private Узел[] срез (бцел метка)
        {
                assert (метка <= freeIndex);
                return freelist [метка .. freeIndex];
        }

        /***********************************************************************
        
                Размести an Запись in the freelist, expanding as necessary

        ***********************************************************************/
        
        private бцел размести (Узел узел)
        {
                if (freeIndex >= freelist.length)
                    freelist.length = freelist.length + freelist.length / 2;

                freelist[freeIndex] = узел;
                return ++freeIndex;
        }
}


version (Old)
{
/*******************************************************************************

        Specification for an XML serializer

*******************************************************************************/

interface IXmlPrinter(T)
{
        public alias Документ!(T) Док;          /// the typed document
        public alias Док.Узел Узел;             /// генерный document узел
        public alias выведи opCall;              /// alias for выведи метод

        /***********************************************************************
        
                Generate a текст representation of the document дерево

        ***********************************************************************/
        
        T[] выведи (Док doc);
        
        /***********************************************************************
        
                Generate a representation of the given узел-subtree 

        ***********************************************************************/
        
        проц выведи (Узел корень, проц delegate(T[][]...) излей);
}
}



/*******************************************************************************

*******************************************************************************/

debug (Документ)
{
        import io.Stdout;
        import text.xml.DocPrinter;

        проц main()
        {
                auto doc = new Документ!(сим);

                // прикрепи an xml заголовок
                doc.заголовок;

                // прикрепи an элемент with some атрибуты, plus 
                // a ветвь элемент with an attached данные значение
                doc.дерево.элемент   (пусто, "корень")
                        .attribute (пусто, "attrib1", "значение")
                        .attribute (пусто, "attrib2", "другой")
                        .элемент   (пусто, "ветвь")
                        .cdata     ("some текст");

                // прикрепи a sibling в_ the interior элементы
                doc.элементы.элемент (пусто, "sibling");
        
                бул foo (doc.Узел узел)
                {
                        узел = узел.атрибуты.имя(пусто, "attrib1");
                        return узел && "значение" == узел.значение;
                }

                foreach (узел; doc.запрос.descendant("корень").фильтр(&foo).ветвь)
                         Стдвыв.форматнс(">> {}", узел.имя);

                foreach (узел; doc.элементы.атрибуты)
                         Стдвыв.форматнс("<< {}", узел.имя);
                         
                foreach (узел; doc.элементы.ветви)
                         Стдвыв.форматнс("<< {}", узел.имя);
                         
                foreach (узел; doc.запрос.descendant.cdata)
                         Стдвыв.форматнс ("{}: {}", узел.предок.имя, узел.значение);

                // излей the результат
                auto printer = new ДокПринтер!(сим);
                printer.выведи (doc, стдвыв);
                doc.сбрось;
        }
}
