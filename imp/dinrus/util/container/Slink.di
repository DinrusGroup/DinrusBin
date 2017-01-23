/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release

        authors:        Kris

        Since:          0.99.7

        Based upon Doug Lea's Java collection package

*******************************************************************************/

module util.container.Slink;

private import util.container.model.IContainer;

/*******************************************************************************

        Slink экземпляры provопрe стандарт linked список следщ-fields, и
        support стандарт operations upon them. Slink structures are pure
        implementation tools, и perform no аргумент проверьing, no результат
        screening, и no synchronization. They rely on пользователь-уровень classes
        (see HashSet, for example) в_ do such things.

        Still, Slink is made `public' so that you can use it в_ build другой
        kinds of containers
        
        Note that when K is specified, support for ключи are включен. When
        Идентичность is stИПulated as 'да', those ключи are compared using an
        опрentity-сравнение instead of equality (using 'is'). Similarly, if
        ХэшКэш is установи да, an добавьitional attribute is создай in order в_
        retain the хэш of K

*******************************************************************************/

private typedef цел KeyDummy;

struct Slink (V, K=KeyDummy, бул Идентичность = нет, бул ХэшКэш = нет)
{
        alias Slink!(V, K, Идентичность, ХэшКэш) Тип;
        alias Тип                              *Реф;
        alias Сравни!(V)                       Сравнитель;

        Реф             следщ;           // pointer в_ следщ
        V               значение;          // элемент значение

        static if (ХэшКэш == да)
        {
        т_хэш       кэш;             // retain хэш значение?
        }
                
        /***********************************************************************

                добавь support for ключи also?
                
        ***********************************************************************/

        static if (!is(typeof(K) == KeyDummy))
        {
                K ключ;

                final Реф установи (K k, V v, Реф n)
                {
                        ключ = k;
                        return установи (v, n);
                }

                final цел хэш()
                {
                        return typeid(K).дайХэш(&ключ);
                }

                final Реф найдиКлюч (K ключ)
                {
                        static if (Идентичность == да)
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ is p.ключ)
                                    return p;
                        }
                        else
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ == p.ключ)
                                    return p;
                        }
                        return пусто;
                }

                final Реф найдиПару (K ключ, V значение)
                {
                        static if (Идентичность == да)
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ is p.ключ && значение == p.значение)
                                    return p;
                        }
                        else
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ == p.ключ && значение == p.значение)
                                    return p;
                        }
                        return пусто;
                }

                final цел индексируйКлюч (K ключ)
                {
                        цел i = 0;
                        static if (Идентичность == да)
                        {
                           for (auto p=this; p; p = p.следщ, ++i)
                                if (ключ is p.ключ)
                                    return i;
                        }
                        else
                        {
                           for (auto p=this; p; p = p.следщ, ++i)
                                if (ключ == p.ключ)
                                    return i;
                        }
                        return -1;
                }

                final цел индексируйПару (K ключ, V значение)
                {
                        цел i = 0;
                        static if (Идентичность == да)
                        {
                           for (auto p=this; p; p = p.следщ, ++i)
                                if (ключ is p.ключ && значение == p.значение)
                                    return i;
                        }
                        else
                        {
                           for (auto p=this; p; p = p.следщ, ++i)
                                if (ключ == p.ключ && значение == p.значение)
                                    return i;
                        }
                        return -1;
                }

                final цел учтиКлюч (K ключ)
                {
                        цел c = 0;
                        static if (Идентичность == да)
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ is p.ключ)
                                    ++c;
                        }
                        else
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ == p.ключ)
                                    ++c;
                        }
                        return c;
                }

                final цел учтиПару (K ключ, V значение)
                {
                        цел c = 0;
                        static if (Идентичность == да)
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ is p.ключ && значение == p.значение)
                                    ++c;
                        }
                        else
                        {
                           for (auto p=this; p; p = p.следщ)
                                if (ключ == p.ключ && значение == p.значение)
                                    ++c;
                        }
                        return c;
                }
        }
        
        /***********************************************************************

                 Набор в_ точка в_ n as следщ ячейка

                 param: n, the new следщ ячейка
                        
        ***********************************************************************/

        final Реф установи (V v, Реф n)
        {
                следщ = n;
                значение = v;
                return this;
        }

        /***********************************************************************

                 Splice in p between текущ ячейка и whatever it was
                 previously pointing в_

                 param: p, the ячейка в_ splice
                        
        ***********************************************************************/

        final проц прикрепи (Реф p)
        {
                if (p)
                    p.следщ = следщ;
                следщ = p;
        }

        /***********************************************************************

                Cause текущ ячейка в_ пропусти over the текущ следщ() one, 
                effectively removing the следщ элемент из_ the список
                        
        ***********************************************************************/

        final проц отторочьСледщ()
        {
                if (следщ)
                    следщ = следщ.следщ;
        }

        /***********************************************************************

                 Linear ищи down the список looking for элемент
                 
                 param: элемент в_ look for
                 Возвращает: the ячейка containing элемент, or пусто if no such
                 
        ***********************************************************************/

        final Реф найди (V элемент)
        {
                for (auto p = this; p; p = p.следщ)
                     if (элемент == p.значение)
                         return p;
                return пусто;
        }

        /***********************************************************************

                Return the число of cells traversed в_ найди первый occurrence
                of a ячейка with элемент() элемент, or -1 if not present
                        
        ***********************************************************************/

        final цел индекс (V элемент)
        {
                цел i;
                for (auto p = this; p; p = p.следщ, ++i)
                     if (элемент == p.значение)
                         return i;

                return -1;
        }

        /***********************************************************************

                Счёт the число of occurrences of элемент in список
                        
        ***********************************************************************/

        final цел счёт (V элемент)
        {
                цел c;
                for (auto p = this; p; p = p.следщ)
                     if (элемент == p.значение)
                         ++c;
                return c;
        }

        /***********************************************************************

                 Return the число of cells in the список
                        
        ***********************************************************************/

        final цел счёт ()
        {
                цел c;
                for (auto p = this; p; p = p.следщ)
                     ++c;
                return c;
        }

        /***********************************************************************

                Return the ячейка representing the последний элемент of the список
                (i.e., the one whose следщ() is пусто
                        
        ***********************************************************************/

        final Реф хвост ()
        {
                auto p = this;
                while (p.следщ)
                       p = p.следщ;
                return p;
        }

        /***********************************************************************

                Return the н_ый ячейка of the список, or пусто if no such
                        
        ***********************************************************************/

        final Реф н_ый (цел n)
        {
                auto p = this;
                for (цел i; i < n; ++i)
                     p = p.следщ;
                return p;
        }

        /***********************************************************************

                Make a копируй of the список; i.e., a new список containing new cells
                but включая the same элементы in the same order
                        
        ***********************************************************************/

        final Реф копируй (Реф delegate() размести)
        {
                auto новый_список = dup (размести);
                auto текущ = новый_список;

                for (auto p = следщ; p; p = p.следщ)
                    {
                    текущ.следщ = p.dup (размести);
                    текущ = текущ.следщ;
                    }
                текущ.следщ = пусто;
                return новый_список;
        }

        /***********************************************************************

                dup is shallow; i.e., just makes a копируй of the текущ ячейка
                        
        ***********************************************************************/

        private Реф dup (Реф delegate() размести)
        {
                auto возвр = размести();
                static if (is(typeof(K) == KeyDummy))
                           возвр.установи (значение, следщ);
                       else
                          возвр.установи (ключ, значение, следщ);
                return возвр;
        }

        /***********************************************************************

                Basic linkedlist merge algorithm.
                Merges the списки голова by fst и snd with respect в_ cmp
         
                param: fst голова of the первый список
                param: snd голова of the секунда список
                param: cmp a Сравнитель использован в_ сравни элементы
                Возвращает: the merged ordered список
                        
        ***********************************************************************/

        static Реф merge (Реф fst, Реф snd, Сравнитель cmp)
        {
                auto a = fst;
                auto b = snd;
                Реф hd = пусто;
                Реф текущ = пусто;

                for (;;)
                    {
                    if (a is пусто)
                       {
                       if (hd is пусто)
                           hd = b;
                       else
                          текущ.следщ = b;
                       return hd;
                       }
                    else
                       if (b is пусто)
                          {
                          if (hd is пусто)
                              hd = a;
                          else
                             текущ.следщ = a;
                          return hd;
                          }

                    цел diff = cmp (a.значение, b.значение);
                    if (diff <= 0)
                       {
                       if (hd is пусто)
                           hd = a;
                       else
                          текущ.следщ = a;
                       текущ = a;
                       a = a.следщ;
                       }
                    else
                       {
                       if (hd is пусто)
                           hd = b;
                       else
                          текущ.следщ = b;
                       текущ = b;
                       b = b.следщ;
                       }
                    }
        }

        /***********************************************************************

                Standard список splitter, использован by сортируй.
                Splits the список in half. Returns the голова of the секунда half

                param: s the голова of the список
                Возвращает: the голова of the секунда half

        ***********************************************************************/

        static Реф разбей (Реф s)
        {
                auto fast = s;
                auto slow = s;

                if (fast is пусто || fast.следщ is пусто)
                    return пусто;

                while (fast)
                      {
                      fast = fast.следщ;
                      if (fast && fast.следщ)
                         {
                         fast = fast.следщ;
                         slow = slow.следщ;
                         }
                      }

                auto r = slow.следщ;
                slow.следщ = пусто;
                return r;

        }

        /***********************************************************************

                 Standard merge сортируй algorithm
                 
                 param: s the список в_ сортируй
                 param: cmp, the сравнитель в_ use for ordering
                 Возвращает: the голова of the sorted список
                        
        ***********************************************************************/

        static Реф сортируй (Реф s, Сравнитель cmp)
        {
                if (s is пусто || s.следщ is пусто)
                    return s;
                else
                   {
                   auto right = разбей (s);
                   auto left = s;
                   left = сортируй (left, cmp);
                   right = сортируй (right, cmp);
                   return merge (left, right, cmp);
                   }
        }

}

