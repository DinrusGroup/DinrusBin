/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release

        authors:        Kris, tsalm

        Since:          0.99.7

        Based upon Doug Lea's Java collection package

*******************************************************************************/

module util.container.RedBlack;

private import util.container.model.IContainer;

private typedef цел AttributeDummy;

/*******************************************************************************

        RedBlack реализует basic capabilities of Red-Black trees,
        an efficient kind of balanced binary дерево. The particular
        algorithms использован are adaptations of those in Corman,
        Lieserson, и Rivest's <EM>Introduction в_ Algorithms</EM>.
        This class was inspired by (и код cross-проверьed with) a 
        similar class by Chuck McManis. The implementations of
        rebalancings during insertion и deletion are
        a little trickier than those versions since they
        don't обменяй Cell contents or use special dummy nilузелs. 

        Doug Lea

*******************************************************************************/

struct RedBlack (V, A = AttributeDummy)
{
        alias RedBlack!(V, A) Тип;
        alias Тип            *Реф;

        enum : бул {RED = нет, BLACK = да}

        /**
         * Pointer в_ left ветвь
        **/

        package Реф     left;

        /**
         * Pointer в_ right ветвь
        **/

        package Реф     right;

        /**
         * Pointer в_ предок (пусто if корень)
        **/

        package Реф     предок;

        package V       значение;

        static if (!is(typeof(A) == AttributeDummy))
        {
               A        attribute;
        }

        /**
         * The узел color (RED, BLACK)
        **/

        package бул    color;

        static if (!is(typeof(A) == AttributeDummy))
        {
                final Реф установи (V v, A a)
                {
                        attribute = a;
                        return установи (v);
                }
        }

        /**
         * Make a new Cell with given значение, пусто линки, и BLACK color.
         * Normally only called в_ establish a new корень.
        **/

        final Реф установи (V v)
        {
                значение = v;
                left = пусто;
                right = пусто;
                предок = пусто;
                color = BLACK;
                return this;
        }

        /**
         * Return a new Реф with same значение и color as сам,
         * but with пусто линки. (Since it is never ОК в_ have
         * multИПle опрentical линки in a RB дерево.)
        **/ 

        protected Реф dup (Реф delegate() размести)
        {
                static if (is(typeof(A) == AttributeDummy))
                           auto t = размести().установи (значение);
                       else
                          auto t = размести().установи (значение, attribute);

                t.color = color;
                return t;
        }


        /**
         * See_Also: util.collection.model.View.View.проверьРеализацию.
        **/
        public проц проверьРеализацию ()
        {

                // It's too hard в_ проверь the property that every simple
                // путь из_ узел в_ leaf имеется same число of black узелs.
                // So ограничь в_ the following

                assert(предок is пусто ||
                       this is предок.left ||
                       this is предок.right);

                assert(left is пусто ||
                       this is left.предок);

                assert(right is пусто ||
                       this is right.предок);

                assert(color is BLACK ||
                       (colorOf(left) is BLACK) && (colorOf(right) is BLACK));

                if (left !is пусто)
                        left.проверьРеализацию();
                if (right !is пусто)
                        right.проверьРеализацию();
        }

        /**
         * Return the minimum значение of the текущ (подст)дерево
        **/

        Реф leftmost ()
        {
                auto p = this;
                for ( ; p.left; p = p.left) {}
                return p;
        }

        /**
         * Return the maximum значение of the текущ (подст)дерево
        **/
        Реф rightmost ()
        {
                auto p = this;
                for ( ; p.right; p = p.right) {}
                return p;
        }

        /**
         * Return the корень (parentless узел) of the дерево
        **/
        Реф корень ()
        {
                auto p = this;
                for ( ; p.предок; p = p.предок) {}
                return p;
        }

        /**
         * Return да if узел is a корень (i.e., имеется a пусто предок)
        **/

        бул isRoot ()
        {
                return предок is пусто;
        }


        /**
         * Return the inorder successor, or пусто if no such
        **/

        Реф successor ()
        {
                if (right)
                    return right.leftmost;

                auto p = предок;
                auto ch = this;
                while (p && ch is p.right)
                      {
                      ch = p;
                      p = p.предок;
                      }
                return p;
        }

        /**
         * Return the inorder predecessor, or пусто if no such
        **/

        Реф predecessor ()
        {
                if (left)
                    return left.rightmost;

                auto p = предок;
                auto ch = this;
                while (p && ch is p.left)
                      {
                      ch = p;
                      p = p.предок;
                      }
                return p;
        }

        /**
         * Return the число of узелs in the subtree
        **/
        цел размер ()
        {
                auto c = 1;
                if (left)
                    c += left.размер;
                if (right)
                    c += right.размер;
                return c;
        }


        /**
         * Return узел of текущ subtree containing значение as значение(), 
         * if it есть_ли, else пусто. 
         * Uses Сравнитель cmp в_ найди и в_ проверь equality.
        **/

        Реф найди (V значение, Сравни!(V) cmp)
        {
                auto t = this;
                for (;;)
                    {
                    auto diff = cmp (значение, t.значение);
                    if (diff is 0)
                        return t;
                    else
                       if (diff < 0)
                           t = t.left;
                       else
                          t = t.right;
                    if (t is пусто)
                        break;
                    }
                return пусто;
        }


        /**
         * Return узел of subtree совпадают "значение" 
         * or, if Неук найдено, the one just after or before  
         * if it doesn't exist, return пусто
         * Uses Сравнитель cmp в_ найди и в_ проверь equality.
        **/
        Реф findFirst (V значение, Сравни!(V) cmp, бул after = да)
        {
                auto t = this;
                auto tLower = this;
                auto tGreater  = this;
            
                for (;;)
                    {
                    auto diff = cmp (значение, t.значение);
                    if (diff is 0)
                        return t;
                   else
                      if (diff < 0)
                         {
                         tGreater = t;
                         t = t.left;
                         }
                      else
                         {
                         tLower = t;
                         t = t.right;
                         }
                   if (t is пусто)
                       break;
                   }
    
                if (after)
                   { 
                   if (cmp (значение, tGreater.значение) <= 0)
                       if (cmp (значение, tGreater.значение) < 0)
                           return tGreater;
                   }
                else
                   {
                   if (cmp (значение, tLower.значение) >= 0)
                       if (cmp (значение, tLower.значение) > 0)
                           return tLower;
                   }

                return пусто;
        }
        
        /**
         * Return число of узелs of текущ subtree containing значение.
         * Uses Сравнитель cmp в_ найди и в_ проверь equality.
        **/
        цел счёт (V значение, Сравни!(V) cmp)
        {
                auto c = 0;
                auto t = this;
                while (t)
                      {
                      цел diff = cmp (значение, t.значение);
                      if (diff is 0)
                         {
                         ++c;
                         if (t.left is пусто)
                             t = t.right;
                         else
                            if (t.right is пусто)
                                t = t.left;
                            else
                               {
                               c += t.right.счёт (значение, cmp);
                               t = t.left;
                               }
                            }
                         else
                            if (diff < 0)
                                t = t.left;
                            else
                               t = t.right;
                         }
                return c;
        }
        
        static if (!is(typeof(A) == AttributeDummy))
        {
        Реф findAttribute (A attribute, Сравни!(A) cmp)
        {
                auto t = this;

                while (t)
                      {
                      if (t.attribute == attribute)
                          return t;
                      else
                        if (t.right is пусто)
                            t = t.left;
                        else
                           if (t.left is пусто)
                               t = t.right;
                           else
                              {
                              auto p = t.left.findAttribute (attribute, cmp);

                              if (p !is пусто)
                                  return p;
                              else
                                 t = t.right;
                              }
                      }
                return пусто; // not reached
        }

        цел countAttribute (A attrib, Сравни!(A) cmp)
        {
                цел c = 0;
                auto t = this;

                while (t)
                      {
                      if (t.attribute == attribute)
                          ++c;

                      if (t.right is пусто)
                          t = t.left;
                      else
                         if (t.left is пусто)
                             t = t.right;
                         else
                            {
                            c += t.left.countAttribute (attribute, cmp);
                            t = t.right;
                            }
                      }
                return c;
        }

        /**
         * найди и return a ячейка holding (ключ, элемент), or пусто if no such
        **/
        Реф найди (V значение, A attribute, Сравни!(V) cmp)
        {
                auto t = this;

                for (;;)
                    {
                    цел diff = cmp (значение, t.значение);
                    if (diff is 0 && t.attribute == attribute)
                        return t;
                    else
                       if (diff <= 0)
                           t = t.left;
                       else
                          t = t.right;

                    if (t is пусто)
                        break;
                    }
                return пусто;
        }

        }



        /**
         * Return a new subtree containing each значение of текущ subtree
        **/

        Реф copyTree (Реф delegate() размести)
        {
                auto t = dup (размести);

                if (left)
                   {
                   t.left = left.copyTree (размести);
                   t.left.предок = t;
                   }

                if (right)
                   {
                   t.right = right.copyTree (размести);
                   t.right.предок = t;
                   }

                return t;
        }


        /**
         * There's no генерный значение insertion. Instead найди the
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


        Реф insertLeft (Реф ячейка, Реф корень)
        {
                left = ячейка;
                ячейка.предок = this;
                return ячейка.fixAfterInsertion (корень);
        }

        /**
         * Insert Cell as the right ветвь of текущ узел, и then
         * rebalance the дерево it is in.
         * @param Cell the Cell в_ добавь
         * @param корень, the корень of the текущ дерево
         * Возвращает: the new корень of the текущ дерево. (Rebalancing
         * can change the корень!)
        **/

        Реф insertRight (Реф ячейка, Реф корень)
        {
                right = ячейка;
                ячейка.предок = this;
                return ячейка.fixAfterInsertion (корень);
        }


        /**
         * Delete the текущ узел, и then rebalance the дерево it is in
         * @param корень the корень of the текущ дерево
         * Возвращает: the new корень of the текущ дерево. (Rebalancing
         * can change the корень!)
        **/


        Реф удали (Реф корень)
        {
                // укз case where we are only узел
                if (left is пусто && right is пусто && предок is пусто)
                    return пусто;

                // if strictly internal, обменяй places with a successor
                if (left && right)
                   {
                   auto s = successor;

                   // To work nicely with arbitrary subclasses of Реф, we don't want в_
                   // just копируй successor's fields. since we don't know что
                   // they are.  Instead we обменяй positions _in the дерево.
                   корень = свопPosition (this, s, корень);
                   }

                // Start fixup at замена узел (normally a ветвь).
                // But if no ветви, fake it by using сам

                if (left is пусто && right is пусто)
                   {
                   if (color is BLACK)
                       корень = this.fixAfterDeletion (корень);

                   // Unlink  (Couldn't before since fixAfterDeletion needs предок ptr)
                   if (предок)
                      {
                      if (this is предок.left)
                          предок.left = пусто;
                      else
                         if (this is предок.right)
                             предок.right = пусто;
                      предок = пусто;
                      }
                   }
                else
                   {
                   auto замена = left;
                   if (замена is пусто)
                       замена = right;

                   // link замена в_ предок
                   замена.предок = предок;

                   if (предок is пусто)
                       корень = замена;
                   else
                      if (this is предок.left)
                          предок.left = замена;
                      else
                         предок.right = замена;

                   left = пусто;
                   right = пусто;
                   предок = пусто;
        
                   // fix замена
                   if (color is BLACK)
                       корень = замена.fixAfterDeletion (корень);
                   }
                return корень;
        }

        /**
         * Swap the linkages of two узелs in a дерево.
         * Return new корень, in case it изменён.
        **/

        static Реф свопPosition (Реф x, Реф y, Реф корень)
        {
                /* Too messy. TODO: найди sequence of assigments that are always ОК */

                auto px = x.предок;
                бул xpl = px !is пусто && x is px.left;
                auto lx = x.left;
                auto rx = x.right;

                auto py = y.предок;
                бул ypl = py !is пусто && y is py.left;
                auto ly = y.left;
                auto ry = y.right;

                if (x is py)
                   {
                   y.предок = px;
                   if (px !is пусто)
                       if (xpl)
                           px.left = y;
                       else
                          px.right = y;

                   x.предок = y;
                   if (ypl)
                      {
                      y.left = x;
                      y.right = rx;
                      if (rx !is пусто)
                      rx.предок = y;
                      }
                   else
                      {
                      y.right = x;
                      y.left = lx;
                      if (lx !is пусто)
                      lx.предок = y;
                      }

                   x.left = ly;
                   if (ly !is пусто)
                       ly.предок = x;

                   x.right = ry;
                   if (ry !is пусто)
                       ry.предок = x;
                   }
                else
                   if (y is px)
                      {
                      x.предок = py;
                      if (py !is пусто)
                          if (ypl)
                              py.left = x;
                          else
                             py.right = x;

                      y.предок = x;
                      if (xpl)
                         {
                         x.left = y;
                         x.right = ry;
                         if (ry !is пусто)
                             ry.предок = x;
                         }
                      else
                         {
                         x.right = y;
                         x.left = ly;
                         if (ly !is пусто)
                             ly.предок = x;
                         }

                      y.left = lx;
                      if (lx !is пусто)
                          lx.предок = y;

                      y.right = rx;
                      if (rx !is пусто)
                          rx.предок = y;
                      }
                   else
                      {
                      x.предок = py;
                      if (py !is пусто)
                          if (ypl)
                              py.left = x;
                          else
                             py.right = x;

                      x.left = ly;
                      if (ly !is пусто)
                          ly.предок = x;

                      x.right = ry;
                      if (ry !is пусто)
                          ry.предок = x;
        
                      y.предок = px;
                      if (px !is пусто)
                          if (xpl)
                              px.left = y;
                          else
                             px.right = y;

                      y.left = lx;
                      if (lx !is пусто)
                          lx.предок = y;

                      y.right = rx;
                      if (rx !is пусто)
                          rx.предок = y;
                      }

                бул c = x.color;
                x.color = y.color;
                y.color = c;

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

        static бул colorOf (Реф p)
        {
                return (p is пусто) ? BLACK : p.color;
        }

        /**
         * return предок of узел p, or пусто if p is пусто
        **/
        static Реф parentOf (Реф p)
        {
                return (p is пусто) ? пусто : p.предок;
        }

        /**
         * Набор the color of узел p, or do nothing if p is пусто
        **/

        static проц setColor (Реф p, бул c)
        {
                if (p !is пусто)
                    p.color = c;
        }

        /**
         * return left ветвь of узел p, or пусто if p is пусто
        **/

        static Реф leftOf (Реф p)
        {
                return (p is пусто) ? пусто : p.left;
        }

        /**
         * return right ветвь of узел p, or пусто if p is пусто
        **/

        static Реф rightOf (Реф p)
        {
                return (p is пусто) ? пусто : p.right;
        }


        /** ОтКого CLR **/
        package Реф вращайВлево (Реф корень)
        {
                auto r = right;
                right = r.left;

                if (r.left)
                    r.left.предок = this;

                r.предок = предок;
                if (предок is пусто)
                    корень = r;
                else
                   if (предок.left is this)
                       предок.left = r;
                   else
                      предок.right = r;

                r.left = this;
                предок = r;
                return корень;
        }

        /** ОтКого CLR **/
        package Реф вращайВправо (Реф корень)
        {
                auto l = left;
                left = l.right;

                if (l.right !is пусто)
                   l.right.предок = this;

                l.предок = предок;
                if (предок is пусто)
                    корень = l;
                else
                   if (предок.right is this)
                       предок.right = l;
                   else
                      предок.left = l;

                l.right = this;
                предок = l;
                return корень;
        }


        /** ОтКого CLR **/
        package Реф fixAfterInsertion (Реф корень)
        {
                color = RED;
                auto x = this;

                while (x && x !is корень && x.предок.color is RED)
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
                корень.color = BLACK;
                return корень;
        }



        /** ОтКого CLR **/
        package Реф fixAfterDeletion(Реф корень)
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
