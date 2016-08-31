/*******************************************************************************

        Copyright: Copyright (C) 2008 Kris Bell.  все rights reserved.

        License:   BSD стиль: $(LICENSE)

        version:   Initial release: March 2008      

        Authors:   Kris

*******************************************************************************/

module text.xml.DocPrinter;

private import io.model;

private import text.xml.Document;

/*******************************************************************************

        Simple Документ printer, with support for serialization caching 
        where the latter avoопрs having в_ generate unchanged подст-trees

*******************************************************************************/

class ДокПринтер(T)
{
        public alias Документ!(T) Док;          /// the typed document
        public alias Док.Узел Узел;             /// генерный document узел

        private бул быстро = да;
        private бцел indentation = 2;

        version (Win32)
                 private const T[] Кс = "\r\n";
           else
              private const T[] Кс = "\n";

        /***********************************************************************
        
                Sets the число of пробелы использован when increasing indentation
                levels. Use a значение of zero в_ disable явный formatting

        ***********************************************************************/
        
        final ДокПринтер indent (бцел indentation);

        /***********************************************************************

                Enable or disable use of cached document snИПpets. These
                represent document branches that remain unaltered, и
                can be излейted verbatim instead of traversing the дерево
                        
        ***********************************************************************/
        
        final ДокПринтер кэш (бул да);

        /***********************************************************************
        
                Generate a текст representation of the document дерево

        ***********************************************************************/
        
        final T[] выведи (Док doc, T[] контент=пусто)
        {                      
                if(контент !is пусто)  
                    выведи (doc.дерево, (T[][] s...)
                        {
                            т_мера i=0; 
                            foreach(t; s) 
                            { 
                                if(i+t.length >= контент.length) 
                                    throw new ИсклРЯР ("Буфер is в_ small"); 
                                
                                контент[i..t.length] = t; 
                                i+=t.length; 
                            } 
                            контент.length = i; 
                        });
                else
                    выведи (doc.дерево, (T[][] s...){foreach(t; s) контент ~= t;});
                return контент;
        }
        
        /***********************************************************************
        
                Generate a текст representation of the document дерево

        ***********************************************************************/
        
        final проц выведи (Док doc, ИПотокВывода поток);
        
        /***********************************************************************
        
                Generate a representation of the given узел-subtree 

        ***********************************************************************/
        
        final проц выведи (Узел корень, проц delegate(T[][]...) излей);
}


debug import text.xml.Document;
debug import util.log.Trace;

unittest
{

    ткст document = "<blah><xml>foo</xml></blah>";

    auto doc = new Документ!(сим);
    doc.разбор (document);

    auto p = new ДокПринтер!(сим);
    сим[1024] буф;
    auto newbuf = p.выведи (doc, буф);
    assert(document == newbuf);
    assert(буф.ptr == newbuf.ptr);
    assert(document == p.выведи(doc));
    

}
