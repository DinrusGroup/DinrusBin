/*
 Файл: CLCell.d

 Originally записано by Doug Lea и released преобр_в the public домен. 
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics 
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ util.collection.d  working файл
 13Oct95  dl                 Changed protection statuses

*/


module util.collection.impl.CLCell;

private import util.collection.impl.Cell;


/**
 *
 *
 * CLCells are cells that are always arranged in circular списки
 * They are pure implementation tools
 * 
        author: Doug Lea
 * @version 0.93
 *
 * <P> For an introduction в_ this package see <A HREF="индекс.html"> Overview </A>.
**/

public class CLCell(T) : Cell!(T)
{
        // экземпляр variables

        private CLCell next_;
        private CLCell prev_;

        // constructors

        /**
         * Make a ячейка with contents v, previous ячейка p, следщ ячейка n
        **/

        public this (T v, CLCell p, CLCell n)
        {
                super(v);
                prev_ = p;
                next_ = n;
        }

        /**
         * Make a singular ячейка
        **/

        public this (T v)
        {
                super(v);
                prev_ = this;
                next_ = this;
        }

        /**
         * Make a singular ячейка with пусто contents
        **/

        public this ()
        {
                super(T.init);
                prev_ = this;
                next_ = this;
        }

        /**
         * return следщ ячейка
        **/

        public final CLCell следщ()
        {
                return next_;
        }

        /**
         * Набор следщ ячейка. You probably don't want в_ вызов this
        **/

        public final проц следщ(CLCell n)
        {
                next_ = n;
        }


        /**
         * return previous ячейка
        **/
        public final CLCell предш()
        {
                return prev_;
        }

        /**
         * Набор previous ячейка. You probably don't want в_ вызов this
        **/
        public final проц предш(CLCell n)
        {
                prev_ = n;
        }


        /**
         * Return да if текущ ячейка is the only one on the список
        **/

        public final бул isSingleton()
        {
                return next_ is this;
        }

        public final проц вяжиСледщ(CLCell p)
        {
                if (p !is пусто)
                   {
                   next_.prev_ = p;
                   p.next_ = next_;
                   p.prev_ = this;
                   next_ = p;
                   }
        }

        /**
         * Make a ячейка holding v и link it immediately after текущ ячейка
        **/

        public final проц добавьСледщ(T v)
        {
                CLCell p = new CLCell(v, this, next_);
                next_.prev_ = p;
                next_ = p;
        }

        /**
         * сделай a узел holding v, link it before the текущ ячейка, и return it
        **/

        public final CLCell добавьПредш(T v)
        {
                CLCell p = prev_;
                CLCell c = new CLCell(v, p, this);
                p.next_ = c;
                prev_ = c;
                return c;
        }

        /**
         * link p before текущ ячейка
        **/

        public final проц вяжиПредш(CLCell p)
        {
                if (p !is пусто)
                   {
                   prev_.next_ = p;
                   p.prev_ = prev_;
                   p.next_ = this;
                   prev_ = p;
                   }
        }

        /**
         * return the число of cells in the список
        **/

        public final цел _length()
        {
                цел c = 0;
                CLCell p = this;
                do {
                   ++c;
                   p = p.следщ();
                   } while (p !is this);
                return c;
        }

        /**
         * return the первый ячейка holding элемент найдено in a circular traversal starting
         * at текущ ячейка, or пусто if no such
        **/

        public final CLCell найди(T элемент)
        {
                CLCell p = this;
                do {
                   if (p.элемент() == (элемент))
                       return p;
                   p = p.следщ();
                   } while (p !is this);
                return пусто;
        }

        /**
         * return the число of cells holding элемент найдено in a circular
         * traversal
        **/

        public final цел счёт(T элемент)
        {
                цел c = 0;
                CLCell p = this;
                do {
                   if (p.элемент() == (элемент))
                       ++c;
                   p = p.следщ();
                   } while (p !is this);
                return c;
        }

        /**
         * return the н_ый ячейка traversed из_ here. It may wrap around.
        **/

        public final CLCell н_ый(цел n)
        {
                CLCell p = this;
                for (цел i = 0; i < n; ++i)
                     p = p.next_;
                return p;
        }


        /**
         * Unlink the следщ ячейка.
         * This имеется no effect on the список if isSingleton()
        **/

        public final проц отвяжиСледщ()
        {
                CLCell nn = next_.next_;
                nn.prev_ = this;
                next_ = nn;
        }

        /**
         * Unlink the previous ячейка.
         * This имеется no effect on the список if isSingleton()
        **/

        public final проц отвяжиПредш()
        {
                CLCell pp = prev_.prev_;
                pp.next_ = this;
                prev_ = pp;
        }


        /**
         * Unlink сам из_ список it is in.
         * Causes it в_ be a синглтон
        **/

        public final проц отвяжи()
        {
                CLCell p = prev_;
                CLCell n = next_;
                p.next_ = n;
                n.prev_ = p;
                prev_ = this;
                next_ = this;
        }

        /**
         * Make a копируй of the список и return new голова. 
        **/

        public final CLCell копируйСписок()
        {
                CLCell hd = this;

                CLCell новый_список = new CLCell(hd.элемент(), пусто, пусто);
                CLCell текущ = новый_список;

                for (CLCell p = next_; p !is hd; p = p.next_)
                     {
                     текущ.next_ = new CLCell(p.элемент(), текущ, пусто);
                     текущ = текущ.next_;
                     }
                новый_список.prev_ = текущ;
                текущ.next_ = новый_список;
                return новый_список;
        }
}

