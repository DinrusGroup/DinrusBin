/*
 Файл: RBPair.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.impl.RBPair;

private import util.collection.impl.RBCell;

private import util.collection.model.Сравнитель;


/**
 *
 * RBPairs are RBCells with ключи.
 *
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class RBPair(K, T) : RBCell!(T) 
{
        alias RBCell!(T).элемент элемент;

        // экземпляр переменная

        private K key_;

        /**
         * Make a ячейка with given ключ и элемент значения, и пусто линки
        **/

        public this (K k, T v)
        {
                super(v);
                key_ = k;
        }

        /**
         * Make a new узел with same ключ и элемент значения, but пусто линки
        **/

        protected final RBPair дубликат()
        {
                auto t = new RBPair(key_, элемент());
                t.color_ = color_;
                return t;
        }

        /**
         * return the ключ
        **/

        public final K ключ()
        {
                return key_;
        }


        /**
         * установи the ключ
        **/

        public final проц ключ(K k)
        {
                key_ = k;
        }

        /**
         * Implements RBCell.найди.
         * Overrопрe RBCell version since we are ordered on ключи, not элементы, so
         * элемент найди имеется в_ ищи whole дерево.
         * сравнитель аргумент not actually использован.
         * See_Also: RBCell.найди
        **/

        public final override RBCell!(T) найди(T элемент, Сравнитель!(T) cmp)
        {
                RBCell!(T) t = this;

                while (t !is пусто)
                      {
                      if (t.элемент() == (элемент))
                          return t;
                      else
                        if (t.right_ is пусто)
                            t = t.left_;
                        else
                           if (t.left_ is пусто)
                               t = t.right_;
                           else
                              {
                              auto p = t.left_.найди(элемент, cmp);

                              if (p !is пусто)
                                  return p;
                              else
                                 t = t.right_;
                              }
                      }
                return пусто; // not reached
        }

        /**
         * Implements RBCell.счёт.
         * See_Also: RBCell.счёт
        **/
        public final override цел счёт(T элемент, Сравнитель!(T) cmp)
        {
                цел c = 0;
                RBCell!(T) t = this;

                while (t !is пусто)
                      {
                      if (t.элемент() == (элемент))
                          ++c;

                      if (t.right_ is пусто)
                          t = t.left_;
                      else
                         if (t.left_ is пусто)
                             t = t.right_;
                         else
                            {
                            c += t.left_.счёт(элемент, cmp);
                            t = t.right_;
                            }
                      }
                return c;
        }

        /**
         * найди и return a ячейка holding ключ, or пусто if no such
        **/

        public final RBPair найдиКлюч(K ключ, Сравнитель!(K) cmp)
        {
                auto t = this;

                for (;;)
                    {
                    цел diff = cmp(ключ, t.key_);
                    if (diff is 0)
                        return t;
                    else
                       if (diff < 0)
                           t = cast(RBPair)(t.left_);
                       else
                          t = cast(RBPair)(t.right_);

                    if (t is пусто)
                        break;
                    }
                return пусто;
        }

        /**
         * найди и return a ячейка holding (ключ, элемент), or пусто if no such
        **/
        public final RBPair найди(K ключ, T элемент, Сравнитель!(K) cmp)
        {
                auto t = this;

                for (;;)
                    {
                    цел diff = cmp(ключ, t.key_);
                    if (diff is 0 && t.элемент() == (элемент))
                        return t;
                    else
                       if (diff <= 0)
                           t = cast(RBPair)(t.left_);
                       else
                          t = cast(RBPair)(t.right_);

                    if (t is пусто)
                        break;
                    }
                return пусто;
        }

        /**
         * return число of узелs of subtree holding ключ
        **/
        public final цел учтиКлюч(K ключ, Сравнитель!(K) cmp)
        {
                цел c = 0;
                auto t = this;

                while (t !is пусто)
                      {
                      цел diff = cmp(ключ, t.key_);
                      // rely on вставь в_ always go left on <=
                      if (diff is 0)
                          ++c;

                      if (diff <= 0)
                          t = cast(RBPair)(t.left_);
                      else
                         t = cast(RBPair)(t.right_);
                      }
                return c;
        }

        /**
         * return число of узелs of subtree holding (ключ, элемент)
        **/
        public final цел счёт(K ключ, T элемент, Сравнитель!(K) cmp)
        {
                цел c = 0;
                auto t = this;
                
                while (t !is пусто)
                      {
                      цел diff = cmp(ключ, t.key_);
                      if (diff is 0)
                         {
                         if (t.элемент() == (элемент))
                             ++c;

                         if (t.left_ is пусто)
                             t = cast(RBPair)(t.right_);
                         else
                            if (t.right_ is пусто)
                                t = cast(RBPair)(t.left_);
                            else
                               {
                               c += (cast(RBPair)(t.right_)).счёт(ключ, элемент, cmp);
                               t = cast(RBPair)(t.left_);
                               }
                         }
                      else
                         if (diff < 0)
                             t = cast(RBPair)(t.left());
                         else
                            t = cast(RBPair)(t.right());
                      }
                return c;
        }
}

