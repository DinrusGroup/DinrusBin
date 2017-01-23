/*
 Файл: ArraySeq.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 2Oct95  dl@cs.oswego.edu   refactored из_ DASeq.d
 13Oct95  dl                 Changed protection statuses

*/

        
module util.collection.ArraySeq;

private import  util.collection.model.Iterator,
                util.collection.model.Sortable,
                util.collection.model.Сравнитель,
                util.collection.model.GuardIterator;

private import  util.collection.impl.SeqCollection,
                util.collection.impl.AbstractIterator;


/**
 *
 * Dynamically allocated и resized Arrays.
 * 
 * Beyond implementing its interfaces, добавьs methods
 * в_ исправь capacities. The default heuristics for resizing
 * usually work fine, but you can исправь them manually when
 * you need в_.
 *
 * ArraySeqs are generally like java.util.Vectors. But unlike them,
 * ArraySeqs do not actually размести массивы when they are constructed.
 * Among другой consequences, you can исправь the ёмкость `for free'
 * after construction but before добавим элементы. You can исправь
 * it at другой times as well, but this may lead в_ ещё expensive
 * resizing. Also, unlike Vectors, they release their internal массивы
 * whenever they are пустой.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
 *
**/

deprecated public class ArraySeq(T) : SeqCollection!(T), Sortable!(T)
{
        alias SeqCollection!(T).удали     удали;
        alias SeqCollection!(T).удалиВсе  удалиВсе;

        /**
         * The minimum ёмкость of any non-пустой буфер
        **/

        public static цел minCapacity = 16;


        // экземпляр variables

        /**
         * The элементы, or пусто if no буфер yet allocated.
        **/

        package T Массив[];


        // constructors

        /**
         * Make a new пустой ArraySeq. 
        **/

        public this ()
        {
                this (пусто, пусто, 0);
        }

        /**
         * Make an пустой ArraySeq with given элемент скринер
        **/

        public this (Предикат скринер)
        {
                this (скринер, пусто, 0);
        }

        /**
         * Special version of constructor needed by клонируй()
        **/
        package this (Предикат s, T[] b, цел c)
        {
                super(s);
                Массив = b;
                счёт = c;
        }

        /**
         * Make an independent копируй. The элементы themselves are not cloned
        **/

        public final ArraySeq!(T) дубликат()
        {
                цел cap = счёт;
                if (cap is 0)
                    return new ArraySeq!(T) (скринер, пусто, 0);
                else
                   {
                   if (cap < minCapacity)
                       cap = minCapacity;

                   T newArray[] = new T[cap];
                   //System.копируй (Массив[0].sizeof, Массив, 0, newArray, 0, счёт);

                   newArray[0..счёт] = Массив[0..счёт];
                   return new ArraySeq!(T)(скринер, newArray, счёт);
                   }
        }

        // methods introduced _in ArraySeq

        /**
         * return the текущ internal буфер ёмкость (zero if no буфер allocated).
         * Возвращает: ёмкость (always greater than or equal в_ размер())
        **/

        public final цел ёмкость()
        {
                return (Массив is пусто) ? 0 : Массив.length;
        }

        /**
         * Набор the internal буфер ёмкость в_ max(размер(), newCap).
         * That is, if given an аргумент less than the текущ
         * число of элементы, the ёмкость is just установи в_ the
         * текущ число of элементы. Thus, элементы are never lost
         * by настройка the ёмкость. 
         * 
         * @param newCap the desired ёмкость.
         * Возвращает: condition: 
         * <PRE>
         * ёмкость() >= размер() &&
         * version() != PREV(this).version() == (ёмкость() != PREV(this).ёмкость())
         * </PRE>
        **/

        public final проц ёмкость(цел newCap)
        {
                if (newCap < счёт)
                    newCap = счёт;

                if (newCap is 0)
                   {
                   очисть();
                   }
                else
                   if (Массив is пусто)
                      {
                      Массив = new T[newCap];
                      incVersion();
                      }
                   else
                      if (newCap !is Массив.length)
                         {
                         //T newArray[] = new T[newCap];
                         //newArray[0..счёт] = Массив[0..счёт];
                         //Массив = newArray;
                         Массив ~= new T[newCap - Массив.length];
                         incVersion();
                         }
        }


        // Коллекция methods

        /**
         * Implements util.collection.impl.Collection.Коллекция.содержит
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.содержит
        **/
        public final бул содержит(T элемент)
        {
                if (! действительныйАргумент (элемент))
                      return нет;

                for (цел i = 0; i < счёт; ++i)
                     if (Массив[i] == (элемент))
                         return да;
                return нет;
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.экземпляры
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.экземпляры
        **/
        public final бцел экземпляры(T элемент)
        {
                if (! действительныйАргумент(элемент))
                      return 0;

                бцел c = 0;
                for (бцел i = 0; i < счёт; ++i)
                     if (Массив[i] == (элемент))
                         ++c;
                return c;
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.элементы
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Коллекция.элементы
        **/
        public final GuardIterator!(T) элементы()
        {
                return new ArrayIterator!(T)(this);
        }

        /**
         * Implements util.collection.model.View.View.opApply
         * Время complexity: O(n).
         * See_Also: util.collection.model.View.View.opApply
        **/
        цел opApply (цел delegate (inout T значение) дг)
        {
                auto scope обходчик = new ArrayIterator!(T)(this);
                return обходчик.opApply (дг);
        }


        // Seq methods:

        /**
         * Implements util.collection.model.Seq.Seq.голова.
         * Время complexity: O(1).
         * See_Also: util.collection.model.Seq.Seq.голова
        **/
        public final T голова()
        {
                проверьИндекс(0);
                return Массив[0];
        }

        /**
         * Implements util.collection.model.Seq.Seq.хвост.
         * Время complexity: O(1).
         * See_Also: util.collection.model.Seq.Seq.хвост
        **/
        public final T хвост()
        {
                проверьИндекс(счёт -1);
                return Массив[счёт -1];
        }

        /**
         * Implements util.collection.model.Seq.Seq.получи.
         * Время complexity: O(1).
         * See_Also: util.collection.model.Seq.Seq.получи
        **/
        public final T получи(цел индекс)
        in {
           проверьИндекс(индекс);
           }
        body
        {
                return Массив[индекс];
        }

        /**
         * Implements util.collection.model.Seq.Seq.первый.
         * Время complexity: O(n).
         * See_Also: util.collection.model.Seq.Seq.первый
        **/
        public final цел первый(T элемент, цел startingIndex = 0)
        {
                if (startingIndex < 0)
                    startingIndex = 0;

                for (цел i = startingIndex; i < счёт; ++i)
                     if (Массив[i] == (элемент))
                         return i;
                return -1;
        }

        /**
         * Implements util.collection.model.Seq.Seq.последний.
         * Время complexity: O(n).
         * See_Also: util.collection.model.Seq.Seq.последний
        **/
        public final цел последний(T элемент, цел startingIndex = 0)
        {
                if (startingIndex >= счёт)
                    startingIndex = счёт -1;
 
                for (цел i = startingIndex; i >= 0; --i)
                     if (Массив[i] == (элемент))
                         return i;
                return -1;
        }


        /**
         * Implements util.collection.model.Seq.Seq.subseq.
         * Время complexity: O(length).
         * See_Also: util.collection.model.Seq.Seq.subseq
        **/
        public final ArraySeq поднабор (цел из_, цел _length)
        {
                if (_length > 0)
                   {
                   проверьИндекс(из_);
                   проверьИндекс(из_ + _length - 1);

                   T newArray[] = new T[_length];
                   //System.копируй (Массив[0].sizeof, Массив, из_, newArray, 0, _length);

                   newArray[0.._length] = Массив[из_..из_+_length];
                   return new ArraySeq!(T)(скринер, newArray, _length);
                   }
                else
                   return new ArraySeq!(T)(скринер);
        }


        // MutableCollection methods

        /**
         * Implements util.collection.impl.Collection.Коллекция.очисть.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Коллекция.очисть
        **/
        public final проц очисть()
        {
                Массив = пусто;
                устСчёт(0);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.removeOneOf.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.removeOneOf
        **/
        public final проц удали(T элемент)
        {
                удали_(элемент, нет);
        }


        /**
         * Implements util.collection.impl.Collection.Коллекция.replaceOneOf
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.replaceOneOf
        **/
        public final проц замени(T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, нет);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.replaceAllOf.
         * Время complexity: O(n * число of replacements).
         * See_Also: util.collection.impl.Collection.Коллекция.replaceAllOf
        **/
        public final проц замениВсе(T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, да);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.exclude.
         * Время complexity: O(n * экземпляры(элемент)).
         * See_Also: util.collection.impl.Collection.Коллекция.exclude
        **/
        public final проц удалиВсе(T элемент)
        {
                удали_(элемент, да);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.возьми.
         * Время complexity: O(1).
         * Takes the rightmost элемент of the Массив.
         * See_Also: util.collection.impl.Collection.Коллекция.возьми
        **/
        public final T возьми()
        {
                T v = хвост();
                удалиХвост();
                return v;
        }


        // SortableCollection methods:


        /**
         * Implements util.collection.SortableCollection.сортируй.
         * Время complexity: O(n лог n).
         * Uses a быстросорт-based algorithm.
         * See_Also: util.collection.SortableCollection.сортируй
        **/
        public проц сортируй(Сравнитель!(T) cmp)
        {
                if (счёт > 0)
                   {
                   быстрСорт(Массив, 0, счёт - 1, cmp);
                   incVersion();
                   }
        }


        // MutableSeq methods

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.приставь.
         * Время complexity: O(n)
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.приставь
        **/
        public final проц приставь(T элемент)
        {
                проверьЭлемент(элемент);
                growBy_(1);
                for (цел i = счёт -1; i > 0; --i)
                     Массив[i] = Массив[i - 1];
                Массив[0] = элемент;
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.замениГолову.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.замениГолову
        **/
        public final проц замениГолову(T элемент)
        {
                проверьЭлемент(элемент);
                Массив[0] = элемент;
                incVersion();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.удалиГолову.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.удалиГолову
        **/
        public final проц удалиГолову()
        {
                удалиПо(0);
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавь.
         * Время complexity: normally O(1), but O(n) if размер() == ёмкость().
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавь
        **/
        public final проц добавь(T элемент)
        in {
           проверьЭлемент (элемент);
           }
        body
        {
                цел последний = счёт;
                growBy_(1);
                Массив[последний] = элемент;
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.замениХвост.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.замениХвост
        **/
        public final проц замениХвост(T элемент)
        {
                проверьЭлемент(элемент);
                Массив[счёт -1] = элемент;
                incVersion();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.удалиХвост.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.удалиХвост
        **/
        public final проц удалиХвост()
        {
                проверьИндекс(0);
                Массив[счёт -1] = T.init;
                growBy_( -1);
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавьПо.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавьПо
        **/
        public final проц добавьПо(цел индекс, T элемент)
        {
                if (индекс !is счёт)
                    проверьИндекс(индекс);

                проверьЭлемент(элемент);
                growBy_(1);
                for (цел i = счёт -1; i > индекс; --i)
                     Массив[i] = Массив[i - 1];
                Массив[индекс] = элемент;
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.удали.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.удалиПо
        **/
        public final проц удалиПо(цел индекс)
        {
                проверьИндекс(индекс);
                for (цел i = индекс + 1; i < счёт; ++i)
                     Массив[i - 1] = Массив[i];
                Массив[счёт -1] = T.init;
                growBy_( -1);
        }


        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.замениПо.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.замениПо
        **/
        public final проц замениПо(цел индекс, T элемент)
        {
                проверьИндекс(индекс);
                проверьЭлемент(элемент);
                Массив[индекс] = элемент;
                incVersion();
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.приставь.
         * Время complexity: O(n + число of элементы in e) if (e 
         * instanceof CollectionIterator) else O(n * число of элементы in e)
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.приставь
        **/
        public final проц приставь(Обходчик!(T) e)
        {
                insert_(0, e);
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавь.
         * Время complexity: O(число of элементы in e) 
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавь
        **/
        public final проц добавь(Обходчик!(T) e)
        {
                insert_(счёт, e);
        }

        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.добавьПо.
         * Время complexity: O(n + число of элементы in e) if (e 
         * instanceof CollectionIterator) else O(n * число of элементы in e)
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.добавьПо
        **/
        public final проц добавьПо(цел индекс, Обходчик!(T) e)
        {
                if (индекс !is счёт)
                    проверьИндекс(индекс);
                insert_(индекс, e);
        }


        /**
         * Implements util.collection.impl.SeqCollection.SeqCollection.removeFromTo.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.SeqCollection.SeqCollection.removeFromTo
        **/
        public final проц удалиДиапазон (цел отИндекса, цел доИндекса)
        {
                проверьИндекс(отИндекса);
                проверьИндекс(доИндекса);
                if (отИндекса <= доИндекса)
                   {
                   цел gap = доИндекса - отИндекса + 1;
                   цел j = отИндекса;
                   for (цел i = доИндекса + 1; i < счёт; ++i)
                        Массив[j++] = Массив[i];
 
                   for (цел i = 1; i <= gap; ++i)
                        Массив[счёт -i] = T.init;
                   добавьToCount( -gap);
                   }
        }

        /**
         * An implementation of Quicksort using medians of 3 for partitions.
         * Used internally by сортируй.
         * It is public и static so it can be использован  в_ сортируй plain
         * массивы as well.
         * @param s, the Массив в_ сортируй
         * @param lo, the least индекс в_ сортируй из_
         * @param hi, the greatest индекс
         * @param cmp, the сравнитель в_ use for comparing элементы
        **/

        public final static проц быстрСорт(T s[], цел lo, цел hi, Сравнитель!(T) cmp)
        {
                if (lo >= hi)
                    return;

                /*
                   Use median-of-three(lo, mопр, hi) в_ pick a partition. 
                   Also обменяй them преобр_в relative order while we are at it.
                */

                цел mопр = (lo + hi) / 2;

                if (cmp(s[lo], s[mопр]) > 0)
                   {
                   T врем = s[lo];
                   s[lo] = s[mопр];
                   s[mопр] = врем; // обменяй
                   }

                if (cmp(s[mопр], s[hi]) > 0)
                   {
                   T врем = s[mопр];
                   s[mопр] = s[hi];
                   s[hi] = врем; // обменяй

                   if (cmp(s[lo], s[mопр]) > 0)
                      {
                      T tmp2 = s[lo];
                      s[lo] = s[mопр];
                      s[mопр] = tmp2; // обменяй
                      }
                   }

                цел left = lo + 1;           // старт one past lo since already handled lo
                цел right = hi - 1;          // similarly
                if (left >= right)
                    return;                  // if three or fewer we are готово

                T partition = s[mопр];

                for (;;)
                    {
                    while (cmp(s[right], partition) > 0)
                           --right;

                    while (left < right && cmp(s[left], partition) <= 0)
                           ++left;

                    if (left < right)
                       {
                       T врем = s[left];
                       s[left] = s[right];
                       s[right] = врем; // обменяй
                       --right;
                       }
                    else
                       break;
                    }

                быстрСорт(s, lo, left, cmp);
                быстрСорт(s, left + 1, hi, cmp);
        }

        /***********************************************************************

                expose collection контент as an Массив

        ************************************************************************/

        override public T[] вМассив ()
        {
                return Массив[0..счёт].dup;
        }
        
        // helper methods

        /**
         * Main метод в_ control буфер sizing.
         * The heuristic использован for growth is:
         * <PRE>
         * if out of пространство:
         *   if need less than minCapacity, grow в_ minCapacity
         *   else grow by average of requested размер и minCapacity.
         * </PRE>
         * <P>
         * For small buffers, this causes them в_ be about 1/2 full.
         * while for large buffers, it causes them в_ be about 2/3 full.
         * <P>
         * For shrinkage, the only thing we do is отвяжи the буфер if it is пустой.
         * @param inc, the amount of пространство в_ grow by. Negative значения mean shrink.
         * Возвращает: condition: исправь record of счёт, и if any of
         * the above conditions apply, размести и копируй преобр_в a new
         * буфер of the appropriate размер.
        **/

        private final проц growBy_(цел inc)
        {
                цел needed = счёт + inc;
                if (inc > 0)
                   {
                   /* heuristic: */
                   цел текущ = ёмкость();
                   if (needed > текущ)
                      {
                      incVersion();
                      цел newCap = needed + (needed + minCapacity) / 2;

                      if (newCap < minCapacity)
                          newCap = minCapacity;

                      if (Массив is пусто)
                         {
                         Массив = new T[newCap];
                         }
                      else
                         {
                         //T newArray[] = new T[newCap];
                         //newArray[0..счёт] = Массив[0..счёт];
                         //Массив = newArray;
                         Массив ~= new T[newCap - Массив.length];
                         }
                      }
                   }
                else
                   if (needed is 0)
                       Массив = пусто;

                устСчёт(needed);
        }


        /**
         * Utility в_ splice in enumerations
        **/

        private final проц insert_(цел индекс, Обходчик!(T) e)
        {
                if (cast(GuardIterator!(T)) e)
                   { 
                   // we know размер!
                   цел inc = (cast(GuardIterator!(T)) (e)).остаток();
                   цел oldcount = счёт;
                   цел oldversion = vershion;
                   growBy_(inc);

                   for (цел i = oldcount - 1; i >= индекс; --i)
                        Массив[i + inc] = Массив[i];

                   цел j = индекс;
                   while (e.ещё())
                         {
                         T элемент = e.получи();
                         if (!allows (элемент))
                            { // Ugh. Can only do full rollback
                            for (цел i = индекс; i < oldcount; ++i)
                                 Массив[i] = Массив[i + inc];

                            vershion = oldversion;
                            счёт = oldcount;
                            проверьЭлемент(элемент); // force throw
                            }
                         Массив[j++] = элемент;
                         }
                   }
                else
                   if (индекс is счёт)
                      { // следщ best; we can добавь
                      while (e.ещё())
                            {
                            T элемент = e.получи();
                            проверьЭлемент(элемент);
                            growBy_(1);
                            Массив[счёт -1] = элемент;
                            }
                      }
                   else
                      { // do it the slow way
                      цел j = индекс;
                      while (e.ещё())
                            {
                            T элемент = e.получи();
                            проверьЭлемент(элемент);
                            growBy_(1);

                            for (цел i = счёт -1; i > j; --i)
                                 Массив[i] = Массив[i - 1];
                            Массив[j++] = элемент;
                            }
                      }
        }

        private final проц удали_(T элемент, бул всеСлучаи)
        {
                if (! действительныйАргумент(элемент))
                      return;

                for (цел i = 0; i < счёт; ++i)
                    {
                    while (i < счёт && Массив[i] == (элемент))
                          {
                          for (цел j = i + 1; j < счёт; ++j)
                               Массив[j - 1] = Массив[j];

                          Массив[счёт -1] = T.init;
                          growBy_( -1);

                          if (!всеСлучаи || счёт is 0)
                               return ;
                          }
                    }
        }

        private final проц замени_(T старЭлемент, T новЭлемент, бул всеСлучаи)
        {
                if (действительныйАргумент(старЭлемент) is нет || счёт is 0)
                    return;

                for (цел i = 0; i < счёт; ++i)
                    {
                    if (Массив[i] == (старЭлемент))
                       {
                       проверьЭлемент(новЭлемент);
                       Массив[i] = новЭлемент;
                       incVersion();

                       if (! всеСлучаи)
                             return;
                       }
                    }
        }

        /**
         * Implements util.collection.model.View.View.проверьРеализацию.
         * See_Also: util.collection.model.View.View.проверьРеализацию
        **/
        public override проц проверьРеализацию()
        {
                super.проверьРеализацию();
                assert(!(Массив is пусто && счёт !is 0));
                assert((Массив is пусто || счёт <= Массив.length));

                for (цел i = 0; i < счёт; ++i)
                    {
                    assert(allows(Массив[i]));
                    assert(экземпляры(Массив[i]) > 0);
                    assert(содержит(Массив[i]));
                    }
        }

        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        static class ArrayIterator(T) : AbstractIterator!(T)
        {
                private цел ряд;
                private T[] Массив;

                public this (ArraySeq пследвтн)
                {
                        super (пследвтн);
                        Массив = пследвтн.Массив;
                }

                public final T получи()
                {
                        decRemaining();
                        return Массив[ряд++];
                }

                цел opApply (цел delegate (inout T значение) дг)
                {
                        цел результат;

                        for (auto i=остаток(); i--;)
                            {
                            auto значение = получи();
                            if ((результат = дг(значение)) != 0)
                                 break;
                            }
                        return результат;
                }
        }
}



debug (Test)
{
        import io.Console;
        
        проц main()
        {
                auto Массив = new ArraySeq!(ткст);
                Массив.добавь ("foo");
                Массив.добавь ("bar");
                Массив.добавь ("wumpus");

                foreach (значение; Массив.элементы) {}

                auto элементы = Массив.элементы();
                while (элементы.ещё)
                       auto v = элементы.получи();

                foreach (значение; Массив)
                         Квывод (значение).нс;

                auto a = Массив.вМассив;
                a.сортируй;
                foreach (значение; a)
                         Квывод (значение).нс;

                 Массив.проверьРеализацию();
        }
}
