/*******************************************************************************

        copyright:      Copyright (c) 2005 Kris. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: 2005

        author:         Kris, Keinfarbton

        Модуль предоставляет систему общецелевого форматирования для
        преобразования значений в текст, удобный для отображения. Есть поддержка
        размещению, выравниванию и общих определеителей формата для
        чисел.

        Выкладка может быть адаптирована путём конфигурирования различных указателей
        и связанных с ней мета-данных. Это можно применить для  plug in текст.локаль
        для обработки частных форматов, дата/время и специфичных для культуры
        преобразований.

        The форматируй notation is influenced by that использован by the .NET
        и ICU frameworks, rather than C-стиль printf or D-стиль
        writef notation.

******************************************************************************/

module text.convert.Layout;

private import  exception;

private import  Utf = text.convert.Utf;

private import  Плав = text.convert.Float,
                Целое = text.convert.Integer;

private import  io.model : ИПотокВывода;

version(СВариантом)
        private import core.Variant;

version(СРасширениями)
        private import text.convert.Extentions;
else
version (СДатойВременем)
        {
        private import time.Time;
        private import text.convert.DateTime;
        }    


/*******************************************************************************

        Platform issues ...

*******************************************************************************/

version (GNU)
        {
        private import tpl.args;
        alias ук Арг;
        alias спис_ва АргСписок;
        }
else version(LDC)
        {
        private import tpl.args;
        alias ук Арг;
        alias спис_ва АргСписок;
        }
     else
        {
        alias ук Арг;
        alias ук АргСписок;
        }

/*******************************************************************************

        Contains methods for replacing форматируй items in a ткст with ткст
        equivalents of each аргумент.

*******************************************************************************/

class Выкладка(T)
{
        public alias преобразуй opCall;
        public alias бцел delegate (T[]) Сток;
       
        static if (is (typeof(МестнДатаВремя)))
                   private МестнДатаВремя* датаВремя = &ДефДатаВремя;

        /**********************************************************************

                Return shared экземпляр
                
                Note that this is not threadsafe, и that static-ctor
                usage doesn't получи invoked appropriately (compiler bug)

        **********************************************************************/

        static Выкладка экземпляр ()
        {
                static Выкладка common;

                if (common is пусто)
                    common = new Выкладка!(T);
                return common;
        }

        /**********************************************************************

        **********************************************************************/

        public final T[] sprint (T[] результат, T[] строкаФмт, ...)
        {
                return vprint (результат, строкаФмт, _arguments, _argptr);
        }

        /**********************************************************************

        **********************************************************************/

        public final T[] vprint (T[] результат, T[] строкаФмт, ИнфОТипе[] аргументы, АргСписок арги)
        {
                T*  p = результат.ptr;
                цел available = результат.length;

                бцел сток (T[] s)
                {
                        цел длин = s.length;
                        if (длин > available)
                            длин = available;

                        available -= длин;
                        p [0..длин] = s[0..длин];
                        p += длин;
                        return длин;
                }

                преобразуй (&сток, аргументы, арги, строкаФмт);
                return результат [0 .. p-результат.ptr];
        }

        /**********************************************************************

                Replaces the _format item in a ткст with the ткст
                equivalent of each аргумент.

                Параметры:
                  строкаФмт  = A ткст containing _format items.
                  арги       = A список of аргументы.

                Возвращает: A копируй of строкаФмт in which the items have been
                replaced by the ткст equivalent of the аргументы.

                Remarks: The строкаФмт parameter is embedded with _format
                items of the form: $(BR)$(BR)
                  {индекс[,alignment][:_format-ткст]}$(BR)$(BR)
                  $(UL $(LI индекс $(BR)
                    An целое indicating the элемент in a список в_ _format.)
                  $(LI alignment $(BR)
                    An optional целое indicating the minimum width. The
                    результат is псеп_в_конце with пробелы if the length of the значение
                    is less than alignment.)
                  $(LI _format-ткст $(BR)
                    An optional ткст of formatting codes.)
                )$(BR)

                The leading и trailing braces are требуется. To include a
                literal brace character, use two leading or trailing brace
                characters.$(BR)$(BR)
                If строкаФмт is "{0} bottles of beer on the wall" и the
                аргумент is an цел with the значение of 99, the return значение
                will be:$(BR) "99 bottles of beer on the wall".

        **********************************************************************/

        public final T[] преобразуй (T[] строкаФмт, ...)
        {
                return преобразуй (_arguments, _argptr, строкаФмт);
        }

        /**********************************************************************

        **********************************************************************/

        public final бцел преобразуй (Сток сток, T[] строкаФмт, ...)
        {
                return преобразуй (сток, _arguments, _argptr, строкаФмт);
        }

        /**********************************************************************

            Tentative преобразуй using an ИПотокВывода as сток - may still be
            removed.

            Since: 0.99.7

        **********************************************************************/

        public final бцел преобразуй (ИПотокВывода вывод, T[] строкаФмт, ...)
        {
                бцел сток (T[] s)
                {
                        return вывод.пиши(s);
                }

                return преобразуй (&сток, _arguments, _argptr, строкаФмт);
        }

        /**********************************************************************

        **********************************************************************/

        public final T[] преобразуй (ИнфОТипе[] аргументы, АргСписок арги, T[] строкаФмт)
        {
                T[] вывод;

                бцел сток (T[] s)
                {
                        вывод ~= s;
                        return s.length;
                }

                преобразуй (&сток, аргументы, арги, строкаФмт);
                return вывод;
        }

version (old)
{
        /**********************************************************************

        **********************************************************************/

        public final T[] преобразуйОдин (T[] результат, ИнфОТипе иот, Арг арг)
        {
                return депешируй (результат, пусто, иот, арг);
        }
}
        /**********************************************************************

        **********************************************************************/

        public final бцел преобразуй (Сток сток, ИнфОТипе[] аргументы, АргСписок арги, T[] строкаФмт)
        {
                assert (строкаФмт, "пустой определитель формата");
                assert (аргументы.length < 64, "слишком много аргов в Выкладка.преобразуй");

                version (GNU)
                        {
                        union ArgU {цел i; байт b; дол l; крат s; проц[] a;
                                    реал r; плав f; дво d;
                                    кплав cf; кдво cd; креал вк;}

                        Арг[64] аргсписок =void;
                        ArgU[64] storedArgs =void;
        
                        foreach (i, арг; аргументы)
                                {
                                static if (is(typeof(арги.ptr)))
                                    аргсписок[i] = арги.ptr;
                                else
                                   аргсписок[i] = арги;

                                /* Since floating точка типы don't live on
                                 * the стэк, they must be использовался by the
                                 * correct тип. */
                                бул преобразованый = нет;
                                switch (арг.classinfo.имя[9])
                                       {
                                       case КодТипа.FLOAT, КодТипа.IFLOAT:
                                            storedArgs[i].f = ва_арг!(плав)(арги);
                                            аргсписок[i] = &(storedArgs[i].f);
                                            преобразованый = да;
                                            break;
                                        
                                       case КодТипа.CFLOAT:
                                            storedArgs[i].cf = ва_арг!(кплав)(арги);
                                            аргсписок[i] = &(storedArgs[i].cf);
                                            преобразованый = да;
                                            break;
        
                                       case КодТипа.DOUBLE, КодТипа.IDOUBLE:
                                            storedArgs[i].d = ва_арг!(дво)(арги);
                                            аргсписок[i] = &(storedArgs[i].d);
                                            преобразованый = да;
                                            break;
                                        
                                       case КодТипа.CDOUBLE:
                                            storedArgs[i].cd = ва_арг!(кдво)(арги);
                                            аргсписок[i] = &(storedArgs[i].cd);
                                            преобразованый = да;
                                            break;
        
                                       case КодТипа.REAL, КодТипа.IREAL:
                                            storedArgs[i].r = ва_арг!(реал)(арги);
                                            аргсписок[i] = &(storedArgs[i].r);
                                            преобразованый = да;
                                            break;

                                       case КодТипа.CREAL:
                                            storedArgs[i].вк = ва_арг!(креал)(арги);
                                            аргсписок[i] = &(storedArgs[i].вк);
                                            преобразованый = да;
                                            break;
        
                                       default:
                                            break;
                                        }
                                if (! преобразованый)
                                   {
                                   switch (арг.tsize)
                                          {
                                          case 1:
                                               storedArgs[i].b = ва_арг!(байт)(арги);
                                               аргсписок[i] = &(storedArgs[i].b);
                                               break;
                                          case 2:
                                               storedArgs[i].s = ва_арг!(крат)(арги);
                                               аргсписок[i] = &(storedArgs[i].s);
                                               break;
                                          case 4:
                                               storedArgs[i].i = ва_арг!(цел)(арги);
                                               аргсписок[i] = &(storedArgs[i].i);
                                               break;
                                          case 8:
                                               storedArgs[i].l = ва_арг!(дол)(арги);
                                               аргсписок[i] = &(storedArgs[i].l);
                                               break;
                                          case 16:
                                               assert((проц[]).sizeof==16,"Размер структуры не поддерживается"w);
                                               storedArgs[i].a = ва_арг!(проц[])(арги);
                                               аргсписок[i] = &(storedArgs[i].a);
                                               break;
                                          default:
                                               assert (нет, "Неизвестный размер: " ~ Целое.вТкст (арг.tsize));
                                          }
                                   }
                                }
                        }
                     else
                        {
                        Арг[64] аргсписок =void;
                        foreach (i, арг; аргументы)
                                {
                                аргсписок[i] = арги;
                                арги += (арг.tsize + т_мера.sizeof - 1) & ~ (т_мера.sizeof - 1);
                                }
                        }
                return разбор (строкаФмт, аргументы, аргсписок, сток);
        }

        /**********************************************************************

                Parse the форматируй-ткст, излейting formatted арги и текст
                fragments as we go

        **********************************************************************/

        private бцел разбор (T[] выкладка, ИнфОТипе[] иот, Арг[] арги, Сток сток)
        {
                T[512] результат =void;
                цел length, nextIndex;


                T* s = выкладка.ptr;
                T* fragment = s;
                T* конец = s + выкладка.length;

                while (да)
                      {
                      while (s < конец && *s != '{')
                             ++s;

                      // излей fragment
                      length += сток (fragment [0 .. s - fragment]);

                      // все готово?
                      if (s is конец)
                          break;

                      // проверь for "{{" и пропусти if so
                      if (*++s is '{')
                         {
                         fragment = s++;
                         continue;
                         }

                      цел индекс = 0;
                      бул indexed = нет;

                      // выкинь индекс
                      while (*s >= '0' && *s <= '9')
                            {
                            индекс = индекс * 10 + *s++ -'0';
                            indexed = да;
                            }

                      // пропусти пробелы
                      while (s < конец && *s is ' ')
                             ++s;

                      бул crop;
                      бул left;
                      бул right;
                      цел  width;

                      // имеется minimum or maximum width?
                      if (*s is ',' || *s is '.')
                         {
                         if (*s is '.')
                             crop = да;

                         while (++s < конец && *s is ' ') {}
                         if (*s is '-')
                            {
                            left = да;
                            ++s;
                            }
                         else
                            right = да;

                         // получи width
                         while (*s >= '0' && *s <= '9')
                                width = width * 10 + *s++ -'0';

                         // пропусти пробелы
                         while (s < конец && *s is ' ')
                                ++s;
                         }

                      T[] форматируй;

                      // имеется a форматируй ткст?
                      if (*s is ':' && s < конец)
                         {
                         T* fs = ++s;

                         // съешь everything up в_ closing brace
                         while (s < конец && *s != '}')
                                ++s;
                         форматируй = fs [0 .. s - fs];
                         }

                      // insist on a closing brace
                      if (*s != '}')
                         {
                         length += сток ("{ошибочный формат}");
                         continue;
                         }

                      // проверь for default индекс & установи следщ default counter
                      if (! indexed)
                            индекс = nextIndex;
                      nextIndex = индекс + 1;

                      // следщ сим is старт of following fragment
                      fragment = ++s;

                      // укз alignment
                      проц излей (T[] стр)
                      {
                                цел паддинг = width - стр.length;

                                if (crop)
                                   {
                                   if (паддинг < 0)
                                      {
                                      if (left)
                                         {
                                         length += сток ("...");
                                         length += сток (Utf.отрежьЛево (стр[-паддинг..$]));
                                         }
                                      else
                                         {
                                         length += сток (Utf.отрежьПраво (стр[0..width]));
                                         length += сток ("...");
                                         }
                                      }
                                   else
                                       length += сток (стр);
                                   }
                                else
                                   {
                                   // if right aligned, pad out with пробелы
                                   if (right && паддинг > 0)
                                       length += пробелы (сток, паддинг);

                                   // излей formatted аргумент
                                   length += сток (стр);

                                   // finally, pad out on right
                                   if (left && паддинг > 0)
                                       length += пробелы (сток, паддинг);
                                   }
                      }

                      // an astonishing число of typehacks needed в_ укз массивы :(
                      проц process (ИнфОТипе _ti, Арг _arg)
                      {
                                // Because Вариантs can contain AAs (и maybe
                                // even static массивы someday), we need в_
                                // process them here.
version (СВариантом)
{
                                if (_ti is typeid(Вариант))
                                   {
                                   // Unpack the variant и вперёд
                                   auto vptr = cast(Вариант*)_arg;
                                   auto innerTi = vptr.тип;
                                   auto innerArg = vptr.ptr;
                                   process (innerTi, innerArg);
                                   }
}
                                if (_ti.classinfo.имя.length is 20 && _ti.classinfo.имя[9..$] == "StaticArray" )
                                   {
                                   auto tiStat = cast(TypeInfo_StaticArray)_ti;
                                   auto p = _arg;
                                   length += сток ("[");
                                   for (цел i = 0; i < tiStat.длин; i++)
                                       {
                                       if (p !is _arg )
                                           length += сток (", ");
                                       process (tiStat.значение, p);
                                       p += tiStat.tsize/tiStat.длин;
                                       }
                                   length += сток ("]");
                                   }
                                else 
                                if (_ti.classinfo.имя.length is 25 && _ti.classinfo.имя[9..$] == "AssociativeArray")
                                   {
                                   auto tiAsso = cast(TypeInfo_AssociativeArray)_ti;
                                   auto tiKey = tiAsso.ключ;
                                   auto tiVal = tiAsso.следщ();
                                   // the knowledge of the internal k/v storage is использован
                                   // so this might break if, that internal storage changes
                                   alias ббайт AV; // any тип for ключ, значение might be ok, the размеры are corrected later
                                   alias ббайт AK;
                                   auto aa = *cast(AV[AK]*) _arg;

                                   length += сток ("{");
                                   бул первый = да;
                                  
                                   цел roundUp (цел sz)
                                   {
                                        return (sz + (ук).sizeof -1) & ~((ук).sizeof - 1);
                                   }

                                   foreach (ref v; aa)
                                           {
                                           // the ключ is befor the значение, so substrace with fixed ключ размер из_ above
                                           auto pk = cast(Арг)( &v - roundUp(AK.sizeof));
                                           // сейчас the реал значение поз is plus the реал ключ размер
                                           auto pv = cast(Арг)(pk + roundUp(tiKey.tsize()));

                                           if (!первый)
                                                length += сток (", ");
                                           process (tiKey, pk);
                                           length += сток (" => ");
                                           process (tiVal, pv);
                                           первый = нет;
                                           }
                                   length += сток ("}");
                                   }
                                else 
                                if (_ti.classinfo.имя[9] is КодТипа.ARRAY)
                                   {
                                   if (_ti is typeid(ткст))
                                       излей (Utf.изТкст8 (*cast(ткст*) _arg, результат));
                                   else
                                   if (_ti is typeid(шим[]))        
                                       излей (Utf.изТкст16 (*cast(шим[]*) _arg, результат));
                                   else
                                   if (_ti is typeid(дим[]))
                                       излей (Utf.изТкст32 (*cast(дим[]*) _arg, результат));
                                   else
                                      {
                                      // for все non ткст Массив типы (включая ткст[])
                                      auto масс = *cast(проц[]*)_arg;
                                      auto длин = масс.length;
                                      auto ptr = cast(Арг) масс.ptr;
                                      auto elTi = _ti.следщ();
                                      auto размер = elTi.tsize();
                                      length += сток ("[");
                                      while (длин > 0)
                                            {
                                            if (ptr !is масс.ptr)
                                                length += сток (", ");
                                            process (elTi, ptr);
                                            длин -= 1;
                                            ptr += размер;
                                            }
                                      length += сток ("]");
                                      }
                                   }
                                else
                                   // the стандарт processing
                                   излей (депешируй (результат, форматируй, _ti, _arg));
                      }

                      
                      // process this аргумент
                      if (индекс >= иот.length)
                          излей ("{неверный индекс}");
                      else
                         process (иот[индекс], арги[индекс]);
                      }
                return length;
        }

        /***********************************************************************

        ***********************************************************************/

        private T[] депешируй (T[] результат, T[] формат, ИнфОТипе тип, Арг p)
        {
                switch (тип.classinfo.имя[9])
                       {
                       case КодТипа.BOOL:
                            static T[] t = "да";
                            static T[] f = "нет";
                            return (*cast(бул*) p) ? t : f;

                       case КодТипа.BYTE:
                            return целое (результат, *cast(байт*) p, формат, ббайт.max);

                       case КодТипа.VOID:
                       case КодТипа.UBYTE:
                            return целое (результат, *cast(ббайт*) p, формат, ббайт.max, "u");

                       case КодТипа.SHORT:
                            return целое (результат, *cast(крат*) p, формат, бкрат.max);

                       case КодТипа.USHORT:
                            return целое (результат, *cast(бкрат*) p, формат, бкрат.max, "u");

                       case КодТипа.INT:
                            return целое (результат, *cast(цел*) p, формат, бцел.max);

                       case КодТипа.UINT:
                            return целое (результат, *cast(бцел*) p, формат, бцел.max, "u");

                       case КодТипа.ULONG:
                            return целое (результат, *cast(дол*) p, формат, бдол.max, "u");

                       case КодТипа.LONG:
                            return целое (результат, *cast(дол*) p, формат, бдол.max);

                       case КодТипа.FLOAT:
                            return плавающее (результат, *cast(плав*) p, формат);

                       case КодТипа.IFLOAT:
                            return мнимое (результат, *cast(вплав*) p, формат);

                       case КодТипа.IDOUBLE:
                            return мнимое (результат, *cast(вдво*) p, формат);

                       case КодТипа.IREAL:
                           return мнимое (результат, *cast(вреал*) p, формат);

                       case КодТипа.CFLOAT:
                            return комплексное (результат, *cast(кплав*) p, формат);

                       case КодТипа.CDOUBLE:
                            return комплексное (результат, *cast(кдво*) p, формат);

                       case КодТипа.CREAL:
                            return комплексное (результат, *cast(креал*) p, формат);

                       case КодТипа.DOUBLE:
                            return плавающее (результат, *cast(дво*) p, формат);

                       case КодТипа.REAL:
                            return плавающее (результат, *cast(реал*) p, формат);

                       case КодТипа.CHAR:
                            return Utf.изТкст8 ((cast(сим*) p)[0..1], результат);

                       case КодТипа.WCHAR:
                            return Utf.изТкст16 ((cast(шим*) p)[0..1], результат);

                       case КодТипа.DCHAR:
                            return Utf.изТкст32 ((cast(дим*) p)[0..1], результат);

                       case КодТипа.POINTER:
                            return целое (результат, *cast(т_мера*) p, формат, т_мера.max, "x");

                       case КодТипа.CLASS:
                            auto c = *cast(Объект*) p;
                            if (c)
                                return Utf.изТкст8 (c.вТкст, результат);
                            break;

                       case КодТипа.STRUCT:
                            auto s = cast(TypeInfo_Struct) тип;
                            if (s.xtoString) 
                               {
                               ткст delegate() вТкст;
                               вТкст.ptr = p;
                               вТкст.funcptr = cast(ткст function())s.xtoString;
                               return Utf.изТкст8 (вТкст(), результат);
                               }
                            goto default;

                       case КодТипа.INTERFACE:
                            auto x = *cast(ук*) p;
                            if (x)
                               {
                               auto pi = **cast(Interface ***) x;
                               auto o = cast(Объект)(*cast(ук*)p - pi.смещение);
                               return Utf.изТкст8 (o.вТкст, результат);
                               }
                            break;

                       case КодТипа.ENUM:
                            return депешируй (результат, формат, (cast(TypeInfo_Enum) тип).основа, p);

                       case КодТипа.TYPEDEF:
                            return депешируй (результат, формат, (cast(TypeInfo_Typedef) тип).основа, p);

                       default:
                            return неизвестное (результат, формат, тип, p);
                       }

                return cast(T[]) "{пусто}"w;
        }

        /**********************************************************************

                укз "неизвестное-тип" ошибки

        **********************************************************************/

        protected T[] неизвестное (T[] результат, T[] формат, ИнфОТипе тип, Арг p)
        {
        version (СРасширениями)
                {
                результат = Расширения!(T).run (тип, результат, p, формат);
                return (результат) ? результат : 
                       "{необрабатываемый тип аргумента: " ~ Utf.изТкст8 (тип.вТкст, результат) ~ "}";
                }
             else
                version (СДатойВременем)
                {
                if (тип is typeid(Время))
                   {
                   static if (is (T == сим))
                              return датаВремя.форматируй(результат, *cast(Время*) p, формат);
                          else
                             {
                             // TODO: this needs в_ be cleaned up
                             сим[128] tmp0 =void;
                             сим[128] tmp1 =void;
                             return Utf.изТкст8(датаВремя.форматируй(tmp0, *cast(Время*) p, Utf.вТкст(формат, tmp1)), результат);
                             }
                   }
                }
                return "{необрабатываемый тип аргумента: " ~ Utf.изТкст8 (тип.вТкст, результат) ~ "}";
        }

        /**********************************************************************

                Формат an целое значение

        **********************************************************************/

        protected T[] целое (T[] вывод, дол v, T[] формат, бдол маска = бдол.max, T[] def="d")
        {
                if (формат.length is 0)
                    формат = def;
                if (формат[0] != 'd')
                    v &= маска;

                return Целое.форматируй (вывод, v, формат);
        }

        /**********************************************************************

                форматируй a floating-точка значение. Defaults в_ 2 decimal places

        **********************************************************************/

        protected T[] плавающее (T[] вывод, реал v, T[] формат)
        {
                бцел dec = 2,
                     эксп = 10;
                бул pad = да;

                for (auto p=формат.ptr, e=p+формат.length; p < e; ++p)
                     switch (*p)
                            {
                            case '.':
                                 pad = нет;
                                 break;
                            case 'e':
                            case 'Е':
                                 эксп = 0;
                                 break;
                            case 'x':
                            case 'X':
                                 дво d = v;
                                 return целое (вывод, *cast(дол*) &d, "x#");
                            default:
                                 auto c = *p;
                                 if (c >= '0' && c <= '9')
                                    {
                                    dec = c - '0', c = p[1];
                                    if (c >= '0' && c <= '9' && ++p < e)
                                        dec = dec * 10 + c - '0';
                                    }
                                 break;
                            }
                
                return Плав.форматируй (вывод, v, dec, эксп, pad);
        }

        /**********************************************************************

        **********************************************************************/

        private проц ошибка (ткст сооб)
        {
                throw new ИсклНелегальногоАргумента (сооб);
        }

        /**********************************************************************

        **********************************************************************/

        private бцел пробелы (Сток сток, цел счёт)
        {
                бцел возвр;

                static const T[32] Spaces = ' ';
                while (счёт > Spaces.length)
                      {
                      возвр += сток (Spaces);
                      счёт -= Spaces.length;
                      }
                return возвр + сток (Spaces[0..счёт]);
        }

        /**********************************************************************

                форматируй an мнимое значение

        **********************************************************************/

        private T[] мнимое (T[] результат, вреал знач, T[] формат)
        {
                return плавающийХвост (результат, знач.im, формат, "*1i");
        }
        
        /**********************************************************************

                форматируй a комплексное значение

        **********************************************************************/

        private T[] комплексное (T[] результат, креал знач, T[] формат)
        {
                static бул signed (реал x)
                {
                        static if (реал.sizeof is 4) 
                                   return ((*cast(бцел *)&x) & 0x8000_0000) != 0;
                        else
                        static if (реал.sizeof is 8) 
                                   return ((*cast(бдол *)&x) & 0x8000_0000_0000_0000) != 0;
                               else
                                  {
                                  auto pe = cast(ббайт *)&x;
                                  return (pe[9] & 0x80) != 0;
                                  }
                }
                static T[] plus = "+";

                auto длин = плавающийХвост (результат, знач.re, формат, signed(знач.im) ? пусто : plus).length;
                return результат [0 .. длин + плавающийХвост (результат[длин..$], знач.im, формат, "*1i").length];
        }

        /**********************************************************************

                форматы a floating-точка значение, и appends a хвост в_ it

        **********************************************************************/

        private T[] плавающийХвост (T[] результат, реал знач, T[] формат, T[] хвост)
        {
                assert (результат.length > хвост.length);

                auto рез = плавающее (результат[0..$-хвост.length], знач, формат);
                auto длин=рез.length;
                if (рез.ptr!is результат.ptr)
                    результат[0..длин]=рез;
                результат [длин .. длин + хвост.length] = хвост;
                return результат [0 .. длин + хвост.length];
        }
}


/*******************************************************************************

*******************************************************************************/

private enum КодТипа
{
        EMPTY = 0,
        VOID = 'v',
        BOOL = 'b',
        UBYTE = 'h',
        BYTE = 'g',
        USHORT = 't',
        SHORT = 's',
        UINT = 'k',
        INT = 'i',
        ULONG = 'm',
        LONG = 'l',
        REAL = 'e',
        FLOAT = 'f',
        DOUBLE = 'd',
        CHAR = 'a',
        WCHAR = 'u',
        DCHAR = 'w',
        ARRAY = 'A',
        CLASS = 'C',
        STRUCT = 'S',
        ENUM = 'Е',
        CONST = 'x',
        INVARIANT = 'y',
        DELEGATE = 'D',
        FUNCTION = 'F',
        POINTER = 'P',
        TYPEDEF = 'T',
        INTERFACE = 'I',
        CFLOAT = 'q',
        CDOUBLE = 'r',
        CREAL = 'c',
        IFLOAT = 'o',
        IDOUBLE = 'p',
        IREAL = 'j'  
}



/*******************************************************************************

*******************************************************************************/

debug (UnitTest)
{
        unittest
        {
        auto Форматировщик = Выкладка!(сим).экземпляр;

        // basic выкладка tests
        assert( Форматировщик( "abc" ) == "abc" );
        assert( Форматировщик( "{0}", 1 ) == "1" );
        assert( Форматировщик( "{0}", -1 ) == "-1" );

        assert( Форматировщик( "{}", 1 ) == "1" );
        assert( Форматировщик( "{} {}", 1, 2) == "1 2" );
        assert( Форматировщик( "{} {0} {}", 1, 3) == "1 1 3" );
        assert( Форматировщик( "{} {0} {} {}", 1, 3) == "1 1 3 {не_годится индекс}" );
        assert( Форматировщик( "{} {0} {} {:x}", 1, 3) == "1 1 3 {не_годится индекс}" );

        assert( Форматировщик( "{0}", да ) == "да" , Форматировщик( "{0}", да ));
        assert( Форматировщик( "{0}", нет ) == "нет" );

        assert( Форматировщик( "{0}", cast(байт)-128 ) == "-128" );
        assert( Форматировщик( "{0}", cast(байт)127 ) == "127" );
        assert( Форматировщик( "{0}", cast(ббайт)255 ) == "255" );

        assert( Форматировщик( "{0}", cast(крат)-32768  ) == "-32768" );
        assert( Форматировщик( "{0}", cast(крат)32767 ) == "32767" );
        assert( Форматировщик( "{0}", cast(бкрат)65535 ) == "65535" );
        assert( Форматировщик( "{0:x4}", cast(бкрат)0xafe ) == "0afe" );
        assert( Форматировщик( "{0:X4}", cast(бкрат)0xafe ) == "0AFE" );

        assert( Форматировщик( "{0}", -2147483648 ) == "-2147483648" );
        assert( Форматировщик( "{0}", 2147483647 ) == "2147483647" );
        assert( Форматировщик( "{0}", 4294967295 ) == "4294967295" );

        // large целыйs
        assert( Форматировщик( "{0}", -9223372036854775807L) == "-9223372036854775807" );
        assert( Форматировщик( "{0}", 0x8000_0000_0000_0000L) == "9223372036854775808" );
        assert( Форматировщик( "{0}", 9223372036854775807L ) == "9223372036854775807" );
        assert( Форматировщик( "{0:X}", 0xFFFF_FFFF_FFFF_FFFF) == "FFFFFFFFFFFFFFFF" );
        assert( Форматировщик( "{0:x}", 0xFFFF_FFFF_FFFF_FFFF) == "ffffffffffffffff" );
        assert( Форматировщик( "{0:x}", 0xFFFF_1234_FFFF_FFFF) == "ffff1234ffffffff" );
        assert( Форматировщик( "{0:x19}", 0x1234_FFFF_FFFF) == "00000001234ffffffff" );
        assert( Форматировщик( "{0}", 18446744073709551615UL ) == "18446744073709551615" );
        assert( Форматировщик( "{0}", 18446744073709551615UL ) == "18446744073709551615" );

        // fragments before и after
        assert( Форматировщик( "d{0}d", "s" ) == "dsd" );
        assert( Форматировщик( "d{0}d", "1234567890" ) == "d1234567890d" );

        // brace escaping
        assert( Форматировщик( "d{0}d", "<ткст>" ) == "d<ткст>d");
        assert( Форматировщик( "d{{0}d", "<ткст>" ) == "d{0}d");
        assert( Форматировщик( "d{{{0}d", "<ткст>" ) == "d{<ткст>d");
        assert( Форматировщик( "d{0}}d", "<ткст>" ) == "d<ткст>}d");

        // hex conversions, where width indicates leading zeroes
        assert( Форматировщик( "{0:x}", 0xafe0000 ) == "afe0000" );
        assert( Форматировщик( "{0:x7}", 0xafe0000 ) == "afe0000" );
        assert( Форматировщик( "{0:x8}", 0xafe0000 ) == "0afe0000" );
        assert( Форматировщик( "{0:X8}", 0xafe0000 ) == "0AFE0000" );
        assert( Форматировщик( "{0:X9}", 0xafe0000 ) == "00AFE0000" );
        assert( Форматировщик( "{0:X13}", 0xafe0000 ) == "000000AFE0000" );
        assert( Форматировщик( "{0:x13}", 0xafe0000 ) == "000000afe0000" );

        // decimal width
        assert( Форматировщик( "{0:d6}", 123 ) == "000123" );
        assert( Форматировщик( "{0,7:d6}", 123 ) == " 000123" );
        assert( Форматировщик( "{0,-7:d6}", 123 ) == "000123 " );

        // width & знак combinations
        assert( Форматировщик( "{0:d7}", -123 ) == "-0000123" );
        assert( Форматировщик( "{0,7:d6}", 123 ) == " 000123" );
        assert( Форматировщик( "{0,7:d7}", -123 ) == "-0000123" );
        assert( Форматировщик( "{0,8:d7}", -123 ) == "-0000123" );
        assert( Форматировщик( "{0,5:d7}", -123 ) == "-0000123" );

        // Negative numbers in various bases
        assert( Форматировщик( "{:b}", cast(байт) -1 ) == "11111111" );
        assert( Форматировщик( "{:b}", cast(крат) -1 ) == "1111111111111111" );
        assert( Форматировщик( "{:b}", cast(цел) -1 )
                == "11111111111111111111111111111111" );
        assert( Форматировщик( "{:b}", cast(дол) -1 )
                == "1111111111111111111111111111111111111111111111111111111111111111" );

        assert( Форматировщик( "{:o}", cast(байт) -1 ) == "377" );
        assert( Форматировщик( "{:o}", cast(крат) -1 ) == "177777" );
        assert( Форматировщик( "{:o}", cast(цел) -1 ) == "37777777777" );
        assert( Форматировщик( "{:o}", cast(дол) -1 ) == "1777777777777777777777" );

        assert( Форматировщик( "{:d}", cast(байт) -1 ) == "-1" );
        assert( Форматировщик( "{:d}", cast(крат) -1 ) == "-1" );
        assert( Форматировщик( "{:d}", cast(цел) -1 ) == "-1" );
        assert( Форматировщик( "{:d}", cast(дол) -1 ) == "-1" );

        assert( Форматировщик( "{:x}", cast(байт) -1 ) == "ff" );
        assert( Форматировщик( "{:x}", cast(крат) -1 ) == "ffff" );
        assert( Форматировщик( "{:x}", cast(цел) -1 ) == "ffffffff" );
        assert( Форматировщик( "{:x}", cast(дол) -1 ) == "ffffffffffffffff" );

        // аргумент индекс
        assert( Форматировщик( "a{0}b{1}c{2}", "x", "y", "z" ) == "axbycz" );
        assert( Форматировщик( "a{2}b{1}c{0}", "x", "y", "z" ) == "azbycx" );
        assert( Форматировщик( "a{1}b{1}c{1}", "x", "y", "z" ) == "aybycy" );

        // alignment does not ограничь the length
        assert( Форматировщик( "{0,5}", "hellohello" ) == "hellohello" );

        // alignment fills with пробелы
        assert( Форматировщик( "->{0,-10}<-", "hello" ) == "->hello     <-" );
        assert( Форматировщик( "->{0,10}<-", "hello" ) == "->     hello<-" );
        assert( Форматировщик( "->{0,-10}<-", 12345 ) == "->12345     <-" );
        assert( Форматировщик( "->{0,10}<-", 12345 ) == "->     12345<-" );

        // chop at maximum specified length; вставь ellИПses when chopped
        assert( Форматировщик( "->{.5}<-", "hello" ) == "->hello<-" );
        assert( Форматировщик( "->{.4}<-", "hello" ) == "->hell...<-" );
        assert( Форматировщик( "->{.-3}<-", "hello" ) == "->...llo<-" );

        // width specifier indicates число of decimal places
        assert( Форматировщик( "{0:f}", 1.23f ) == "1.23" );
        assert( Форматировщик( "{0:f4}", 1.23456789L ) == "1.2346" );
        assert( Форматировщик( "{0:e4}", 0.0001) == "1.0000e-04");

        assert( Форматировщик( "{0:f}", 1.23f*1i ) == "1.23*1i");
        assert( Форматировщик( "{0:f4}", 1.23456789L*1i ) == "1.2346*1i" );
        assert( Форматировщик( "{0:e4}", 0.0001*1i) == "1.0000e-04*1i");

        assert( Форматировщик( "{0:f}", 1.23f+1i ) == "1.23+1.00*1i" );
        assert( Форматировщик( "{0:f4}", 1.23456789L+1i ) == "1.2346+1.0000*1i" );
        assert( Форматировщик( "{0:e4}", 0.0001+1i) == "1.0000e-04+1.0000e+00*1i");
        assert( Форматировщик( "{0:f}", 1.23f-1i ) == "1.23-1.00*1i" );
        assert( Форматировщик( "{0:f4}", 1.23456789L-1i ) == "1.2346-1.0000*1i" );
        assert( Форматировщик( "{0:e4}", 0.0001-1i) == "1.0000e-04-1.0000e+00*1i");

        // 'f.' & 'e.' форматируй truncates zeroes из_ floating decimals
        assert( Форматировщик( "{:f4.}", 1.230 ) == "1.23" );
        assert( Форматировщик( "{:f6.}", 1.230 ) == "1.23" );
        assert( Форматировщик( "{:f1.}", 1.230 ) == "1.2" );
        assert( Форматировщик( "{:f.}", 1.233 ) == "1.23" );
        assert( Форматировщик( "{:f.}", 1.237 ) == "1.24" );
        assert( Форматировщик( "{:f.}", 1.000 ) == "1" );
        assert( Форматировщик( "{:f2.}", 200.001 ) == "200");
        
        // Массив вывод
        цел[] a = [ 51, 52, 53, 54, 55 ];
        assert( Форматировщик( "{}", a ) == "[51, 52, 53, 54, 55]" );
        assert( Форматировщик( "{:x}", a ) == "[33, 34, 35, 36, 37]" );
        assert( Форматировщик( "{,-4}", a ) == "[51  , 52  , 53  , 54  , 55  ]" );
        assert( Форматировщик( "{,4}", a ) == "[  51,   52,   53,   54,   55]" );
        цел[][] b = [ [ 51, 52 ], [ 53, 54, 55 ] ];
        assert( Форматировщик( "{}", b ) == "[[51, 52], [53, 54, 55]]" );

        бкрат[3] c = [ cast(бкрат)51, 52, 53 ];
        assert( Форматировщик( "{}", c ) == "[51, 52, 53]" );

        // целое AA 
        бкрат[дол] d;
        d[234] = 2;
        d[345] = 3;
        assert( Форматировщик( "{}", d ) == "{234 => 2, 345 => 3}" ||
                Форматировщик( "{}", d ) == "{345 => 3, 234 => 2}");
        
        // бул/ткст AA 
        бул[ткст] e;
        e[ "ключ".dup ] = да;
        e[ "значение".dup ] = нет;
        assert( Форматировщик( "{}", e ) == "{ключ => да, значение => нет}" ||
                Форматировщик( "{}", e ) == "{значение => нет, ключ => да}");

        // ткст/дво AA 
        ткст[ дво ] f;
        f[ 1.0 ] = "one".dup;
        f[ 3.14 ] = "ПИ".dup;
        assert( Форматировщик( "{}", f ) == "{1.00 => one, 3.14 => ПИ}" ||
                Форматировщик( "{}", f ) == "{3.14 => ПИ, 1.00 => one}");
        }
}



debug (Layout)
{
       import io.Stdout;

        static if (is (typeof(Время)))
                   import time.WallClock;

        проц main ()
        {
                auto выкладка = Выкладка!(сим).экземпляр;

                выкладка.преобразуй (Стдвыв.поток, "hi {}", "there\n");

                Стдвыв (выкладка.sprint (new сим[1], "hi")).нс;
                Стдвыв (выкладка.sprint (new сим[10], "{.4}", "hello")).нс;
                Стдвыв (выкладка.sprint (new сим[10], "{.-4}", "hello")).нс;

                Стдвыв (выкладка ("{:f1}", 3.0)).нс;
                Стдвыв (выкладка ("{:g}", 3.00)).нс;
                Стдвыв (выкладка ("{:f1}", -0.0)).нс;
                Стдвыв (выкладка ("{:g1}", -0.0)).нс;
                Стдвыв (выкладка ("{:d2}", 56)).нс;
                Стдвыв (выкладка ("{:d4}", cast(байт) -56)).нс;
                Стдвыв (выкладка ("{:f4}", 1.0e+12)).нс;
                Стдвыв (выкладка ("{:f4}", 1.23e-2)).нс;
                Стдвыв (выкладка ("{:f8}", 3.14159)).нс;
                Стдвыв (выкладка ("{:e20}", 1.23e-3)).нс;
                Стдвыв (выкладка ("{:e4.}", 1.23e-07)).нс;
                Стдвыв (выкладка ("{:.}", 1.2)).нс;
                Стдвыв (выкладка ("ptr:{}", &выкладка)).нс;
                Стдвыв (выкладка ("бдол.max {}", бдол.max)).нс;

                struct S
                {
                   ткст вТкст () {return "foo";}      
                }

                S s;
                Стдвыв (выкладка ("struct: {}", s)).нс;

                static if (is (typeof(Время)))
                           Стдвыв (выкладка ("время: {}", Куранты.сейчас)).нс;
        }
}
