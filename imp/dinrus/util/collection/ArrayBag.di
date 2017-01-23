/*
 Файл: ArrayBag.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ сохрани.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.ArrayBag;

private import  exception;

private import  util.collection.model.GuardIterator;

private import  util.collection.impl.CLCell,
                util.collection.impl.BagCollection,
                util.collection.impl.AbstractIterator;



/**
 *
 * Linked Буфер implementation of Bags. The Рюкзак consists of
 * any число of buffers holding элементы, arranged in a список.
 * Each буфер holds an Массив of элементы. The размер of each
 * буфер is the значение of размЧанка that was текущ during the
 * operation that caused the Рюкзак в_ grow. The размЧанка() may
 * be adjusted at any время. (It is not consопрered a version change.)
 * 
 * <P>
 * все but the final буфер is always kept full.
 * When a буфер имеется no элементы, it is released (so is
 * available for garbage collection).
 * <P>
 * ArrayBags are good choices for собериions in which
 * you merely помести a lot of things in, и then look at
 * them via enumerations, but don't often look for
 * particular элементы.
 * 
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

deprecated public class ArrayBag(T) : BagCollection!(T)
{
        alias CLCell!(T[]) CLCellT;

        alias BagCollection!(T).удали     удали;
        alias BagCollection!(T).удалиВсе  удалиВсе;

        /**
         * The default чанк размер в_ use for buffers
        **/

        public static цел дефРазмЧанка = 32;

        // экземпляр variables

        /**
         * The последний узел of the circular список of чанки. Пусто if пустой.
        **/

        package CLCellT хвост;

        /**
         * The число of элементы of the хвост узел actually использован. (все другие
         * are kept full).
        **/
        protected цел lastCount;

        /**
         * The чанк размер в_ use for making следщ буфер
        **/

        protected цел размерЧанка_;

        // constructors

        /**
         * Make an пустой буфер.
        **/
        public this ()
        {
                this (пусто, 0, пусто, 0, дефРазмЧанка);
        }

        /**
         * Make an пустой буфер, using the supplied элемент скринер.
        **/

        public this (Предикат s)
        {
                this (s, 0, пусто, 0, дефРазмЧанка);
        }

        /**
         * Special version of constructor needed by клонируй()
        **/
        protected this (Предикат s, цел n, CLCellT t, цел lc, цел cs)
        {
                super (s);
                счёт = n;
                хвост = t;
                lastCount = lc;
                размерЧанка_ = cs;
        }

        /**
         * Make an independent копируй. Does not клонируй элементы.
        **/ 

        public final ArrayBag!(T) дубликат ()
        {
                if (счёт is 0)
                    return new ArrayBag!(T) (скринер);
                else
                   {
                   CLCellT h = хвост.копируйСписок();
                   CLCellT p = h;

                   do {
                      T[] obuff = p.элемент();
                      T[] nbuff = new T[obuff.length];

                      for (цел i = 0; i < obuff.length; ++i)
                           nbuff[i] = obuff[i];

                      p.элемент(nbuff);
                      p = p.следщ();
                      } while (p !is h);

                   return new ArrayBag!(T) (скринер, счёт, h, lastCount, размерЧанка_);
                   }
        }


        /**
         * Report the чанк размер использован when добавим new buffers в_ the список
        **/

        public final цел размЧанка()
        {
                return размерЧанка_;
        }

        /**
         * Набор the чанк размер в_ be использован when добавим new buffers в_ the 
         * список during future добавь() operations.
         * Any значение greater than 0 is ОК. (A значение of 1 makes this a
         * преобр_в very slow simulation of a linked список!)
        **/

        public final проц размЧанка (цел newЧанкРазмер)
        {
                if (newЧанкРазмер > 0)
                    размерЧанка_ = newЧанкРазмер;
                else
                   throw new ИсклНелегальногоАргумента("Attempt в_ установи негатив чанк размер значение");
        }

        // Коллекция methods

        /*
          This код is pretty repetitive, but I don't know a nice way в_
          separate traversal logic из_ actions
        */

        /**
         * Implements util.collection.impl.Collection.Коллекция.содержит
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.содержит
        **/
        public final бул содержит(T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                     return нет;

                CLCellT p = хвост.следщ();

                for (;;)
                    {
                    T[] buff = p.элемент();
                    бул isLast = p is хвост;

                    цел n;
                    if (isLast)
                        n = lastCount;
                    else
                       n = buff.length;

                    for (цел i = 0; i < n; ++i)
                        {
                        if (buff[i] == (элемент))
                        return да;
                        }

                    if (isLast)
                        break;
                    else
                       p = p.следщ();
                    }
                return нет;
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.экземпляры
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.экземпляры
        **/
        public final бцел экземпляры(T элемент)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                    return 0;

                бцел c = 0;
                CLCellT p = хвост.следщ();

                for (;;)
                    {
                    T[] buff = p.элемент();
                    бул isLast = p is хвост;

                    цел n;
                    if (isLast)
                        n = lastCount;
                    else
                       n = buff.length;

                    for (цел i = 0; i < n; ++i)
                       {
                       if (buff[i] == (элемент))
                           ++c;
                       }

                    if (isLast)
                        break;
                    else
                       p = p.следщ();
                    }
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

        // MutableCollection methods

        /**
         * Implements util.collection.impl.Collection.Коллекция.очисть.
         * Время complexity: O(1).
         * See_Also: util.collection.impl.Collection.Коллекция.очисть
        **/
        public final проц очисть()
        {
                устСчёт(0);
                хвост = пусто;
                lastCount = 0;
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.удалиВсе.
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.удалиВсе
        **/
        public final проц удалиВсе (T элемент)
        {
                удали_(элемент, да);
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
         * Время complexity: O(n).
         * See_Also: util.collection.impl.Collection.Коллекция.replaceAllOf
        **/
        public final проц замениВсе(T старЭлемент, T новЭлемент)
        {
                замени_(старЭлемент, новЭлемент, да);
        }

        /**
         * Implements util.collection.impl.Collection.Коллекция.возьми.
         * Время complexity: O(1).
         * Takes the least элемент.
         * See_Also: util.collection.impl.Collection.Коллекция.возьми
        **/
        public final T возьми()
        {
                if (счёт !is 0)
                   {
                   T[] buff = хвост.элемент();
                   T v = buff[lastCount -1];
                   buff[lastCount -1] = T.init;
                   shrink_();
                   return v;
                   }
                проверьИндекс(0);
                return T.init; // not reached
        }



        // MutableBag methods

        /**
         * Implements util.collection.MutableBag.добавьIfAbsent.
         * Время complexity: O(n).
         * See_Also: util.collection.MutableBag.добавьIfAbsent
        **/
        public final проц добавьЕсли(T элемент)
        {
                if (!содержит(элемент))
                     добавь (элемент);
        }


        /**
         * Implements util.collection.MutableBag.добавь.
         * Время complexity: O(1).
         * See_Also: util.collection.MutableBag.добавь
        **/
        public final проц добавь (T элемент)
        {
                проверьЭлемент(элемент);

                incCount();
                if (хвост is пусто)
                   {
                   хвост = new CLCellT(new T[размерЧанка_]);
                   lastCount = 0;
                   }

                T[] buff = хвост.элемент();
                if (lastCount is buff.length)
                   {
                   buff = new T[размерЧанка_];
                   хвост.добавьСледщ(buff);
                   хвост = хвост.следщ();
                   lastCount = 0;
                   }

                buff[lastCount++] = элемент;
        }

        /**
         * helper for удали/exclude
        **/

        private final проц удали_(T элемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(элемент) || счёт is 0)
                     return ;

                CLCellT p = хвост;

                for (;;)
                    {
                    T[] buff = p.элемент();
                    цел i = (p is хвост) ? lastCount - 1 : buff.length - 1;
                    
                    while (i >= 0)
                          {
                          if (buff[i] == (элемент))
                             {
                             T[] lastBuff = хвост.элемент();
                             buff[i] = lastBuff[lastCount -1];
                             lastBuff[lastCount -1] = T.init;
                             shrink_();
        
                             if (!всеСлучаи || счёт is 0)
                                  return ;
        
                             if (p is хвост && i >= lastCount)
                                 i = lastCount -1;
                             }
                          else
                             --i;
                          }

                    if (p is хвост.следщ())
                        break;
                    else
                       p = p.предш();
                }
        }

        private final проц замени_(T старЭлемент, T новЭлемент, бул всеСлучаи)
        {
                if (!действительныйАргумент(старЭлемент) || счёт is 0 || старЭлемент == (новЭлемент))
                     return ;

                CLCellT p = хвост.следщ();

                for (;;)
                    {
                    T[] buff = p.элемент();
                    бул isLast = p is хвост;

                    цел n;
                    if (isLast)
                        n = lastCount;
                    else
                       n = buff.length;

                    for (цел i = 0; i < n; ++i)
                        {
                        if (buff[i] == (старЭлемент))
                           {
                           проверьЭлемент(новЭлемент);
                           incVersion();
                           buff[i] = новЭлемент;
                           if (!всеСлучаи)
                           return ;
                           }
                        }

                    if (isLast)
                        break;
                    else
                       p = p.следщ();
                    }
        }

        private final проц shrink_()
        {
                decCount();
                lastCount--;
                if (lastCount is 0)
                   {
                   if (счёт is 0)
                       очисть();
                   else
                      {
                      CLCellT врем = хвост;
                      хвост = хвост.предш();
                      врем.отвяжи();
                      T[] buff = хвост.элемент();
                      lastCount = buff.length;
                      }
                   }
        }

        // ImplementationCheckable methods

        /**
         * Implements util.collection.model.View.View.проверьРеализацию.
         * See_Also: util.collection.model.View.View.проверьРеализацию
        **/
        public override проц проверьРеализацию()
        {

                super.проверьРеализацию();
                assert(размерЧанка_ >= 0);
                assert(lastCount >= 0);
                assert(((счёт is 0) is (хвост is пусто)));

                if (хвост is пусто)
                    return ;

                цел c = 0;
                CLCellT p = хвост.следщ();

                for (;;)
                    {
                    T[] buff = p.элемент();
                    бул isLast = p is хвост;

                    цел n;
                    if (isLast)
                        n = lastCount;
                    else
                       n = buff.length;
   
                    c += n;
                    for (цел i = 0; i < n; ++i)
                        {
                        auto v = buff[i];
                        assert(allows(v) && содержит(v));
                        }
   
                    if (isLast)
                        break;
                    else
                       p = p.следщ();
                    }

                assert(c is счёт);

        }



        /***********************************************************************

                opApply() имеется migrated here в_ mitigate the virtual вызов
                on метод получи()
                
        ************************************************************************/

        static class ArrayIterator(T) : AbstractIterator!(T)
        {
                private CLCellT ячейка;
                private T[]     buff;
                private цел     индекс;

                public this (ArrayBag bag)
                {
                        super(bag);
                        ячейка = bag.хвост;
                        
                        if (ячейка)
                            buff = ячейка.элемент();  
                }

                public final T получи()
                {
                        decRemaining();
                        if (индекс >= buff.length)
                           {
                           ячейка = ячейка.следщ();
                           buff = ячейка.элемент();
                           индекс = 0;
                           }
                        return buff[индекс++];
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
                auto bag = new ArrayBag!(ткст);
                bag.добавь ("foo");
                bag.добавь ("bar");
                bag.добавь ("wumpus");

                foreach (значение; bag.элементы) {}

                auto элементы = bag.элементы();
                while (элементы.ещё)
                       auto v = элементы.получи();

                foreach (значение; bag)
                         Квывод (значение).нс;

                bag.проверьРеализацию();

                Квывод (bag).нс;
        }
}
