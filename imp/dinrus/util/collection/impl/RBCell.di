/*
 Файл: RBCell.d

 Originally записано by Doug Lea и released преобр_в the public домен.
 Thanks for the assistance и support of Sun Microsystems Labs, Agorics
 Inc, Loral, и everyone contributing, testing, и using this код.

 History:
 Дата     Who                What
 24Sep95  dl@cs.oswego.edu   Созд из_ util.collection.d  working файл

*/


module util.collection.impl.RBCell;

private import  util.collection.impl.Cell;

private import  util.collection.model.Iterator,
                util.collection.model.Comparator;

/**
 * RBCell реализует basic capabilities of Red-Black trees,
 * an efficient kind of balanced binary дерево. The particular
 * algorithms использован are adaptations of those in Corman,
 * Lieserson, и Rivest's <EM>Introduction в_ Algorithms</EM>.
 * This class was inspired by (и код cross-проверьed with) a
 * similar class by Chuck McManis. The implementations of
 * rebalancings during insertion и deletion are
 * a little trickier than those versions since they
 * don't обменяй Cell contents or use special dummy nilузелs.
 * <P>
 * It is a pure implementation class. For harnesses, see:
 * See_Also: RBTree
 * Authors: Doug Lea
**/




public class RBCell(T) : Cell!(T)
{
        static бул RED = нет;
        static бул BLACK = да;

        /**
         * The узел color (RED, BLACK)
        **/

        package бул color_;

        /**
         * Pointer в_ left ветвь
        **/

        package RBCell left_;

        /**
         * Pointer в_ right ветвь
        **/

        package RBCell right_;

        /**
         * Pointer в_ предок (пусто if корень)
        **/

        private RBCell parent_;

        /**
         * Make a new Cell with given элемент, пусто линки, и BLACK color.
         * Normally only called в_ establish a new корень.
        **/

        public this (T элемент)
        {
                super(элемент);
                left_ = пусто;
                right_ = пусто;
                parent_ = пусто;
                color_ = BLACK;
        }

        /**
         * Return a new RBCell with same элемент и color as сам,
         * but with пусто линки. (Since it is never ОК в_ have
         * multИПle опрentical линки in a RB дерево.)
        **/

        protected RBCell дубликат()
        {
                RBCell t = new RBCell(элемент());
                t.color_ = color_;
                return t;
        }


        /**
         * Return left ветвь (or пусто)
        **/

        public final RBCell left()
        {
                return left_;
        }

        /**
         * Return right ветвь (or пусто)
        **/

        public final RBCell right()
        {
                return right_;
        }

        /**
         * Return предок (or пусто)
        **/
        public final RBCell предок()
        {
                return parent_;
        }


        /**
         * See_Also: util.collection.model.View.View.проверьРеализацию.
        **/
        public проц проверьРеализацию()
        {

                // It's too hard в_ проверь the property that every simple
                // путь из_ узел в_ leaf имеется same число of black узелs.
                // So ограничь в_ the following

                assert(parent_ is пусто ||
                       this is parent_.left_ ||
                       this is parent_.right_);

                assert(left_ is пусто ||
                       this is left_.parent_);

                assert(right_ is пусто ||
                       this is right_.parent_);

                assert(color_ is BLACK ||
                       (colorOf(left_) is BLACK) && (colorOf(right_) is BLACK));

                if (left_ !is пусто)
                        left_.проверьРеализацию();
                if (right_ !is пусто)
                        right_.проверьРеализацию();
        }

        /+
        public final проц assert(бул пред)
        {
                ImplementationError.assert(this, пред);
        }
        +/

        /**
         * Return the minimum элемент of the текущ (подст)дерево
        **/

        public final RBCell leftmost()
        {
                auto p = this;
                for ( ; p.left_ !is пусто; p = p.left_)
                    {}
                return p;
        }

        /**
         * Return the maximum элемент of the текущ (подст)дерево
        **/
        public final RBCell rightmost()
        {
                auto p = this;
                for ( ; p.right_ !is пусто; p = p.right_)
                    {}
                return p;
        }

        /**
         * Return the корень (parentless узел) of the дерево
        **/
        public final RBCell корень()
        {
                auto p = this;
                for ( ; p.parent_ !is пусто; p = p.parent_)
                    {}
                return p;
        }

        /**
         * Return да if узел is a корень (i.e., имеется a пусто предок)
        **/

        public final бул isRoot()
        {
                return parent_ is пусто;
        }


        /**
         * Return the inorder successor, or пусто if no such
        **/

        public final RBCell successor()
        {
                if (right_ !is пусто)
                        return right_.leftmost();
                else
                {
                        auto p = parent_;
                        auto ch = this;
                        while (p !is пусто && ch is p.right_)
                        {
                                ch = p;
                                p = p.parent_;
                        }
                        return p;
                }
        }

        /**
         * Return the inorder predecessor, or пусто if no such
        **/

        public final RBCell predecessor()
        {
                if (left_ !is пусто)
                        return left_.rightmost();
                else
                {
                        auto p = parent_;
                        auto ch = this;
                        while (p !is пусто && ch is p.left_)
                        {
                                ch = p;
                                p = p.parent_;
                        }
                        return p;
                }
        }

        /**
         * Return the число of узелs in the subtree
        **/
        public final цел размер()
        {
                цел c = 1;
                if (left_ !is пусто)
                        c += left_.размер();
                if (right_ !is пусто)
                        c += right_.размер();
                return c;
        }


        /**
         * Return узел of текущ subtree containing элемент as элемент(),
         * if it есть_ли, else пусто.
         * Uses Сравнитель cmp в_ найди и в_ проверь equality.
        **/

        public RBCell найди(T элемент, Сравнитель!(T) cmp)
        {
                auto t = this;
                for (;;)
                    {
                    цел diff = cmp(элемент, t.элемент());
                    if (diff is 0)
                        return t;
                    else
                       if (diff < 0)
                           t = t.left_;
                       else
                          t = t.right_;
                    if (t is пусто)
                        break;
                    }
                return пусто;
        }


        /**
         * Return число of узелs of текущ subtree containing элемент.
         * Uses Сравнитель cmp в_ найди и в_ проверь equality.
        **/
        public цел счёт(T элемент, Сравнитель!(T) cmp)
        {
                цел c = 0;
                auto t = this;
                while (t !is пусто)
                {
                        цел diff = cmp(элемент, t.элемент());
                        if (diff is 0)
                        {
                                ++c;
                                if (t.left_ is пусто)
                                        t = t.right_;
                                else
                                        if (t.right_ is пусто)
                                                t = t.left_;
                                        else
                                        {
                                                c += t.right_.счёт(элемент, cmp);
                                                t = t.left_;
                                        }
                        }
                        else
                                if (diff < 0)
                                        t = t.left_;
                                else
                                        t = t.right_;
                }
                return c;
        }




        /**
         * Return a new subtree containing each элемент of текущ subtree
        **/

        public final RBCell copyTree()
        {
                auto t = cast(RBCell)(дубликат());

                if (left_ !is пусто)
                {
                        t.left_ = left_.copyTree();
                        t.left_.parent_ = t;
                }
                if (right_ !is пусто)
                {
                        t.right_ = right_.copyTree();
                        t.right_.parent_ = t;
                }
                return t;
        }


        /**
         * There's no генерный элемент insertion. Instead найди the
         * place you want в_ добавь a узел и then invoke insertLeft
         * or insertRight.
         * <P>
         * Insert Cell as the left ветвь of текущ узел, и then
         * rebalance the дерево it is in.
         * @param Cell the Cell в_ добавь
         * @param корень, the корень of the текущ дерево
         * Возвращает: the new корень of the текущ дерево. (Rebalancing
         * can change the корень!)
        **/


        public final RBCell insertLeft(RBCell Cell, RBCell корень)
        {
                left_ = Cell;
                Cell.parent_ = this;
                return Cell.fixAfterInsertion(корень);
        }

        /**
         * Insert Cell as the right ветвь of текущ узел, и then
         * rebalance the дерево it is in.
         * @param Cell the Cell в_ добавь
         * @param корень, the корень of the текущ дерево
         * Возвращает: the new корень of the текущ дерево. (Rebalancing
         * can change the корень!)
        **/

        public final RBCell insertRight(RBCell Cell, RBCell корень)
        {
                right_ = Cell;
                Cell.parent_ = this;
                return Cell.fixAfterInsertion(корень);
        }


        /**
         * Delete the текущ узел, и then rebalance the дерево it is in
         * @param корень the корень of the текущ дерево
         * Возвращает: the new корень of the текущ дерево. (Rebalancing
         * can change the корень!)
        **/


        public final RBCell удали (RBCell корень)
        {

                // укз case where we are only узел
                if (left_ is пусто && right_ is пусто && parent_ is пусто)
                        return пусто;

                // if strictly internal, обменяй places with a successor
                if (left_ !is пусто && right_ !is пусто)
                {
                        auto s = successor();
                        // To work nicely with arbitrary subclasses of RBCell, we don't want в_
                        // just копируй successor's fields. since we don't know что
                        // they are.  Instead we обменяй positions _in the дерево.
                        корень = свопPosition(this, s, корень);
                }

                // Start fixup at замена узел (normally a ветвь).
                // But if no ветви, fake it by using сам

                if (left_ is пусто && right_ is пусто)
                {

                        if (color_ is BLACK)
                                корень = this.fixAfterDeletion(корень);

                        // Unlink  (Couldn't before since fixAfterDeletion needs предок ptr)

                        if (parent_ !is пусто)
                        {
                                if (this is parent_.left_)
                                        parent_.left_ = пусто;
                                else
                                        if (this is parent_.right_)
                                                parent_.right_ = пусто;
                                parent_ = пусто;
                        }

                }
                else
                {
                        auto замена = left_;
                        if (замена is пусто)
                                замена = right_;

                        // link замена в_ предок
                        замена.parent_ = parent_;

                        if (parent_ is пусто)
                                корень = замена;
                        else
                                if (this is parent_.left_)
                                        parent_.left_ = замена;
                                else
                                        parent_.right_ = замена;

                        left_ = пусто;
                        right_ = пусто;
                        parent_ = пусто;

                        // fix замена
                        if (color_ is BLACK)
                                корень = замена.fixAfterDeletion(корень);

                }

                return корень;
        }

        /**
         * Swap the linkages of two узелs in a дерево.
         * Return new корень, in case it изменён.
        **/

        static final RBCell свопPosition(RBCell x, RBCell y, RBCell корень)
        {

                /* Too messy. TODO: найди sequence of assigments that are always ОК */

                auto px = x.parent_;
                бул xpl = px !is пусто && x is px.left_;
                auto lx = x.left_;
                auto rx = x.right_;

                auto py = y.parent_;
                бул ypl = py !is пусто && y is py.left_;
                auto ly = y.left_;
                auto ry = y.right_;

                if (x is py)
                {
                        y.parent_ = px;
                        if (px !is пусто)
                                if (xpl)
                                        px.left_ = y;
                                else
                                        px.right_ = y;
                        x.parent_ = y;
                        if (ypl)
                        {
                                y.left_ = x;
                                y.right_ = rx;
                                if (rx !is пусто)
                                        rx.parent_ = y;
                        }
                        else
                        {
                                y.right_ = x;
                                y.left_ = lx;
                                if (lx !is пусто)
                                        lx.parent_ = y;
                        }
                        x.left_ = ly;
                        if (ly !is пусто)
                                ly.parent_ = x;
                        x.right_ = ry;
                        if (ry !is пусто)
                                ry.parent_ = x;
                }
                else
                        if (y is px)
                        {
                                x.parent_ = py;
                                if (py !is пусто)
                                        if (ypl)
                                                py.left_ = x;
                                        else
                                                py.right_ = x;
                                y.parent_ = x;
                                if (xpl)
                                {
                                        x.left_ = y;
                                        x.right_ = ry;
                                        if (ry !is пусто)
                                                ry.parent_ = x;
                                }
                                else
                                {
                                        x.right_ = y;
                                        x.left_ = ly;
                                        if (ly !is пусто)
                                                ly.parent_ = x;
                                }
                                y.left_ = lx;
                                if (lx !is пусто)
                                        lx.parent_ = y;
                                y.right_ = rx;
                                if (rx !is пусто)
                                        rx.parent_ = y;
                        }
                        else
                        {
                                x.parent_ = py;
                                if (py !is пусто)
                                        if (ypl)
                                                py.left_ = x;
                                        else
                                                py.right_ = x;
                                x.left_ = ly;
                                if (ly !is пусто)
                                        ly.parent_ = x;
                                x.right_ = ry;
                                if (ry !is пусто)
                                        ry.parent_ = x;

                                y.parent_ = px;
                                if (px !is пусто)
                                        if (xpl)
                                                px.left_ = y;
                                        else
                                                px.right_ = y;
                                y.left_ = lx;
                                if (lx !is пусто)
                                        lx.parent_ = y;
                                y.right_ = rx;
                                if (rx !is пусто)
                                        rx.parent_ = y;
                        }

                бул c = x.color_;
                x.color_ = y.color_;
                y.color_ = c;

                if (корень is x)
                        корень = y;
                else
                        if (корень is y)
                                корень = x;
                return корень;
        }



        /**
         * Return color of узел p, or BLACK if p is пусто
         * (In the CLR version, they use
         * a special dummy `nil' узел for such purposes, but that doesn't
         * work well here, since it could lead в_ creating one such special
         * узел per реал узел.)
         *
        **/

        static final бул colorOf(RBCell p)
        {
                return (p is пусто) ? BLACK : p.color_;
        }

        /**
         * return предок of узел p, or пусто if p is пусто
        **/
        static final RBCell parentOf(RBCell p)
        {
                return (p is пусто) ? пусто : p.parent_;
        }

        /**
         * Набор the color of узел p, or do nothing if p is пусто
        **/

        static final проц setColor(RBCell p, бул c)
        {
                if (p !is пусто)
                        p.color_ = c;
        }

        /**
         * return left ветвь of узел p, or пусто if p is пусто
        **/

        static final RBCell leftOf(RBCell p)
        {
                return (p is пусто) ? пусто : p.left_;
        }

        /**
         * return right ветвь of узел p, or пусто if p is пусто
        **/

        static final RBCell rightOf(RBCell p)
        {
                return (p is пусто) ? пусто : p.right_;
        }


        /** ОтКого CLR **/
        protected final RBCell вращайВлево(RBCell корень)
        {
                auto r = right_;
                right_ = r.left_;
                if (r.left_ !is пусто)
                        r.left_.parent_ = this;
                r.parent_ = parent_;
                if (parent_ is пусто)
                        корень = r;
                else
                        if (parent_.left_ is this)
                                parent_.left_ = r;
                        else
                                parent_.right_ = r;
                r.left_ = this;
                parent_ = r;
                return корень;
        }

        /** ОтКого CLR **/
        protected final RBCell вращайВправо(RBCell корень)
        {
                auto l = left_;
                left_ = l.right_;
                if (l.right_ !is пусто)
                        l.right_.parent_ = this;
                l.parent_ = parent_;
                if (parent_ is пусто)
                        корень = l;
                else
                        if (parent_.right_ is this)
                                parent_.right_ = l;
                        else
                                parent_.left_ = l;
                l.right_ = this;
                parent_ = l;
                return корень;
        }


        /** ОтКого CLR **/
        protected final RBCell fixAfterInsertion(RBCell корень)
        {
                color_ = RED;
                auto x = this;

                while (x !is пусто && x !is корень && x.parent_.color_ is RED)
                {
                        if (parentOf(x) is leftOf(parentOf(parentOf(x))))
                        {
                                auto y = rightOf(parentOf(parentOf(x)));
                                if (colorOf(y) is RED)
                                {
                                        setColor(parentOf(x), BLACK);
                                        setColor(y, BLACK);
                                        setColor(parentOf(parentOf(x)), RED);
                                        x = parentOf(parentOf(x));
                                }
                                else
                                {
                                        if (x is rightOf(parentOf(x)))
                                        {
                                                x = parentOf(x);
                                                корень = x.вращайВлево(корень);
                                        }
                                        setColor(parentOf(x), BLACK);
                                        setColor(parentOf(parentOf(x)), RED);
                                        if (parentOf(parentOf(x)) !is пусто)
                                                корень = parentOf(parentOf(x)).вращайВправо(корень);
                                }
                        }
                        else
                        {
                                auto y = leftOf(parentOf(parentOf(x)));
                                if (colorOf(y) is RED)
                                {
                                        setColor(parentOf(x), BLACK);
                                        setColor(y, BLACK);
                                        setColor(parentOf(parentOf(x)), RED);
                                        x = parentOf(parentOf(x));
                                }
                                else
                                {
                                        if (x is leftOf(parentOf(x)))
                                        {
                                                x = parentOf(x);
                                                корень = x.вращайВправо(корень);
                                        }
                                        setColor(parentOf(x), BLACK);
                                        setColor(parentOf(parentOf(x)), RED);
                                        if (parentOf(parentOf(x)) !is пусто)
                                                корень = parentOf(parentOf(x)).вращайВлево(корень);
                                }
                        }
                }
                корень.color_ = BLACK;
                return корень;
        }



        /** ОтКого CLR **/
        protected final RBCell fixAfterDeletion(RBCell корень)
        {
                auto x = this;
                while (x !is корень && colorOf(x) is BLACK)
                {
                        if (x is leftOf(parentOf(x)))
                        {
                                auto sib = rightOf(parentOf(x));
                                if (colorOf(sib) is RED)
                                {
                                        setColor(sib, BLACK);
                                        setColor(parentOf(x), RED);
                                        корень = parentOf(x).вращайВлево(корень);
                                        sib = rightOf(parentOf(x));
                                }
                                if (colorOf(leftOf(sib)) is BLACK && colorOf(rightOf(sib)) is BLACK)
                                {
                                        setColor(sib, RED);
                                        x = parentOf(x);
                                }
                                else
                                {
                                        if (colorOf(rightOf(sib)) is BLACK)
                                        {
                                                setColor(leftOf(sib), BLACK);
                                                setColor(sib, RED);
                                                корень = sib.вращайВправо(корень);
                                                sib = rightOf(parentOf(x));
                                        }
                                        setColor(sib, colorOf(parentOf(x)));
                                        setColor(parentOf(x), BLACK);
                                        setColor(rightOf(sib), BLACK);
                                        корень = parentOf(x).вращайВлево(корень);
                                        x = корень;
                                }
                        }
                        else
                        {
                                auto sib = leftOf(parentOf(x));
                                if (colorOf(sib) is RED)
                                {
                                        setColor(sib, BLACK);
                                        setColor(parentOf(x), RED);
                                        корень = parentOf(x).вращайВправо(корень);
                                        sib = leftOf(parentOf(x));
                                }
                                if (colorOf(rightOf(sib)) is BLACK && colorOf(leftOf(sib)) is BLACK)
                                {
                                        setColor(sib, RED);
                                        x = parentOf(x);
                                }
                                else
                                {
                                        if (colorOf(leftOf(sib)) is BLACK)
                                        {
                                                setColor(rightOf(sib), BLACK);
                                                setColor(sib, RED);
                                                корень = sib.вращайВлево(корень);
                                                sib = leftOf(parentOf(x));
                                        }
                                        setColor(sib, colorOf(parentOf(x)));
                                        setColor(parentOf(x), BLACK);
                                        setColor(leftOf(sib), BLACK);
                                        корень = parentOf(x).вращайВправо(корень);
                                        x = корень;
                                }
                        }
                }
                setColor(x, BLACK);
                return корень;
        }
}

