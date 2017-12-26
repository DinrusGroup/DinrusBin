/*
 Файл: LLCell.d

 Originally записано by Doug Lea и released преобр_в the public домен.
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ util.collection.d  working файл

*/


module util.collection.impl.LLCell;

private import util.collection.impl.Cell;

private import util.collection.model.Comparator;

/**
 *
 *
 * LLCells extend Cells with стандарт linkedlist следщ-fields,
 * и provопрe a стандарт operations on them.
 * <P>
 * LLCells are pure implementation tools. They perform
 * no аргумент проверьing, no результат screening, и no synchronization.
 * They rely on пользователь-уровень classes (see for example LinkedList) в_ do such things.
 * Still, the class is made `public' so that you can use them в_
 * build другой kinds of собериions or whatever, not just the ones
 * currently supported.
 *
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class LLCell(T) : Cell!(T)
{
        alias Сравнитель!(T) ComparatorT;


        protected LLCell next_;

        /**
         * Return the следщ ячейка (or пусто if Неук)
        **/

        public LLCell следщ()
        {
                return next_;
        }

        /**
         * установи в_ точка в_ n as следщ ячейка
         * @param n, the new следщ ячейка
        **/

        public проц следщ(LLCell n)
        {
                next_ = n;
        }

        public this (T v, LLCell n)
        {
                super(v);
                next_ = n;
        }

        public this (T v)
        {
                this(v, пусто);
        }

        public this ()
        {
                this(T.init, пусто);
        }


        /**
         * Splice in p between текущ ячейка и whatever it was previously
         * pointing в_
         * @param p, the ячейка в_ splice
        **/

        public final проц вяжиСледщ(LLCell p)
        {
                if (p !is пусто)
                    p.next_ = next_;
                next_ = p;
        }

        /**
         * Cause текущ ячейка в_ пропусти over the текущ следщ() one,
         * effectively removing the следщ элемент из_ the список
        **/

        public final проц отвяжиСледщ()
        {
                if (next_ !is пусто)
                    next_ = next_.next_;
        }

        /**
         * Linear ищи down the список looking for элемент (using T.равно)
         * @param элемент в_ look for
         * Возвращает: the ячейка containing элемент, or пусто if no such
        **/

        public final LLCell найди(T элемент)
        {
                for (LLCell p = this; p !is пусто; p = p.next_)
                     if (p.элемент() == элемент)
                         return p;
                return пусто;
        }

        /**
         * return the число of cells traversed в_ найди первый occurrence
         * of a ячейка with элемент() элемент, or -1 if not present
        **/

        public final цел индекс(T элемент)
        {
                цел i = 0;
                for (LLCell p = this; p !is пусто; p = p.next_)
                    {
                    if (p.элемент() == элемент)
                        return i;
                    else
                       ++i;
                    }
                return -1;
        }

        /**
         * Счёт the число of occurrences of элемент in список
        **/

        public final цел счёт(T элемент)
        {
                цел c = 0;
                for (LLCell p = this; p !is пусто; p = p.next_)
                     if (p.элемент() == элемент)
                         ++c;
                return c;
        }

        /**
         * return the число of cells in the список
        **/

        public final цел _length()
        {
                цел c = 0;
                for (LLCell p = this; p !is пусто; p = p.next_)
                     ++c;
                return c;
        }

        /**
         * return the ячейка representing the последний элемент of the список
         * (i.e., the one whose следщ() is пусто
        **/

        public final LLCell хвост()
        {
                LLCell p = this;
                for ( ; p.next_ !is пусто; p = p.next_)
                    {}
                return p;
        }

        /**
         * return the н_ый ячейка of the список, or пусто if no such
        **/

        public final LLCell н_ый(цел n)
        {
                LLCell p = this;
                for (цел i = 0; i < n; ++i)
                     p = p.next_;
                return p;
        }


        /**
         * сделай a копируй of the список; i.e., a new список containing new cells
         * but включая the same элементы in the same order
        **/

        public final LLCell копируйСписок()
        {
                LLCell новый_список = пусто;
                новый_список = дубликат();
                LLCell текущ = новый_список;

                for (LLCell p = next_; p !is пусто; p = p.next_)
                    {
                    текущ.next_ = p.дубликат();
                    текущ = текущ.next_;
                    }
                текущ.next_ = пусто;
                return новый_список;
        }

        /**
         * Clone is SHALLOW; i.e., just makes a копируй of the текущ ячейка
        **/

        private final LLCell дубликат()
        {
                return new LLCell(элемент(), next_);
        }

        /**
         * Basic linkedlist merge algorithm.
         * Merges the списки голова by fst и snd with respect в_ cmp
         * @param fst голова of the первый список
         * @param snd голова of the секунда список
         * @param cmp a Сравнитель использован в_ сравни элементы
         * Возвращает: the merged ordered список
        **/

        public final static LLCell merge(LLCell fst, LLCell snd, ComparatorT cmp)
        {
                LLCell a = fst;
                LLCell b = snd;
                LLCell hd = пусто;
                LLCell текущ = пусто;
                for (;;)
                    {
                    if (a is пусто)
                       {
                       if (hd is пусто)
                           hd = b;
                       else
                          текущ.следщ(b);
                       return hd;
                       }
                    else
                       if (b is пусто)
                          {
                          if (hd is пусто)
                              hd = a;
                          else
                             текущ.следщ(a);
                          return hd;
                          }

                    цел diff = cmp (a.элемент(), b.элемент());
                    if (diff <= 0)
                       {
                       if (hd is пусто)
                           hd = a;
                       else
                          текущ.следщ(a);
                       текущ = a;
                       a = a.следщ();
                       }
                    else
                       {
                       if (hd is пусто)
                           hd = b;
                       else
                          текущ.следщ(b);
                       текущ = b;
                       b = b.следщ();
                       }
                    }
                return пусто;
        }

        /**
         * Standard список splitter, использован by сортируй.
         * Splits the список in half. Returns the голова of the секунда half
         * @param s the голова of the список
         * Возвращает: the голова of the секунда half
        **/

        public final static LLCell разбей(LLCell s)
        {
                LLCell fast = s;
                LLCell slow = s;

                if (fast is пусто || fast.следщ() is пусто)
                    return пусто;

                while (fast !is пусто)
                      {
                      fast = fast.следщ();
                      if (fast !is пусто && fast.следщ() !is пусто)
                         {
                         fast = fast.следщ();
                         slow = slow.следщ();
                         }
                      }

                LLCell r = slow.следщ();
                slow.следщ(пусто);
                return r;

        }

        /**
         * Standard merge сортируй algorithm
         * @param s the список в_ сортируй
         * @param cmp, the сравнитель в_ use for ordering
         * Возвращает: the голова of the sorted список
        **/

        public final static LLCell mergeSort(LLCell s, ComparatorT cmp)
        {
                if (s is пусто || s.следщ() is пусто)
                    return s;
                else
                   {
                   LLCell right = разбей(s);
                   LLCell left = s;
                   left = mergeSort(left, cmp);
                   right = mergeSort(right, cmp);
                   return merge(left, right, cmp);
                   }
        }

}

