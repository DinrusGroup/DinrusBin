/*******************************************************************************

        copyright:      Copyright (c) 2008 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Apr 2008: Initial release

        authors:        Kris

        Since:          0.99.7

        Based upon Doug Lea's Java collection package

*******************************************************************************/

module util.container.Clink;

/*******************************************************************************

        ЦСвязки из_ линки, всегда организуемые в циркулярные списки.

*******************************************************************************/

struct ЦСвязка (V)
{
        alias ЦСвязка!(V)    Тип;
        alias Тип         *Реф;

        Реф     предш,           // указадель на предш
                следщ;           // указатель на следщ
        V       значение;          // значение элемента

        /***********************************************************************

                 Набор в_ точка в_ ourselves
                        
        ***********************************************************************/

        Реф установи (V v)
        {
                return установи (v, this, this);
        }

        /***********************************************************************

                 Набор в_ точка в_ n as следщ ячейка и p as the приор ячейка

                 param: n, the new следщ ячейка
                 param: p, the new приор ячейка
                        
        ***********************************************************************/

        Реф установи (V v, Реф p, Реф n)
        {
                значение = v;
                предш = p;
                следщ = n;
                return this;
        }

        /**
         * Return да if текущ ячейка is the only one on the список
        **/

        бул синглтон()
        {
                return следщ is this;
        }

        проц вяжиСледщ (Реф p)
        {
                if (p)
                   {
                   следщ.предш = p;
                   p.следщ = следщ;
                   p.предш = this;
                   следщ = p;
                   }
        }

        /**
         * Make a ячейка holding v и link it immediately after текущ ячейка
        **/

        проц добавьСледщ (V v, Реф delegate() размести)
        {
                auto p = размести().установи (v, this, следщ);
                следщ.предш = p;
                следщ = p;
        }

        /**
         * сделай a узел holding v, link it before the текущ ячейка, и return it
        **/

        Реф добавьПредш (V v, Реф delegate() размести)
        {
                auto p = предш;
                auto c = размести().установи (v, p, this);
                p.следщ = c;
                предш = c;
                return c;
        }

        /**
         * link p before текущ ячейка
        **/

        проц вяжиПредш (Реф p)
        {
                if (p)
                   {
                   предш.следщ = p;
                   p.предш = предш;
                   p.следщ = this;
                   предш = p;
                   }
        }

        /**
         * return the число of cells in the список
        **/

        цел размер()
        {
                цел c = 0;
                auto p = this;
                do {
                   ++c;
                   p = p.следщ;
                   } while (p !is this);
                return c;
        }

        /**
         * return the первый ячейка holding элемент найдено in a circular traversal starting
         * at текущ ячейка, or пусто if no such
        **/

        Реф найди (V элемент)
        {
                auto p = this;
                do {
                   if (элемент == p.значение)
                       return p;
                   p = p.следщ;
                   } while (p !is this);
                return пусто;
        }

        /**
         * return the число of cells holding элемент найдено in a circular
         * traversal
        **/

        цел счёт (V элемент)
        {
                цел c = 0;
                auto p = this;
                do {
                   if (элемент == p.значение)
                       ++c;
                   p = p.следщ;
                   } while (p !is this);
                return c;
        }

        /**
         * return the н_ый ячейка traversed из_ here. It may wrap around.
        **/

        Реф н_ый (цел n)
        {
                auto p = this;
                for (цел i = 0; i < n; ++i)
                     p = p.следщ;
                return p;
        }


        /**
         * Unlink the следщ ячейка.
         * This имеется no effect on the список if isSingleton()
        **/

        проц отвяжиСледщ ()
        {
                auto nn = следщ.следщ;
                nn.предш = this;
                следщ = nn;
        }

        /**
         * Unlink the previous ячейка.
         * This имеется no effect on the список if isSingleton()
        **/

        проц отвяжиПредш ()
        {
                auto pp = предш.предш;
                pp.следщ = this;
                предш = pp;
        }


        /**
         * Unlink сам из_ список it is in.
         * Causes it в_ be a синглтон
        **/

        проц отвяжи ()
        {
                auto p = предш;
                auto n = следщ;
                p.следщ = n;
                n.предш = p;
                предш = this;
                следщ = this;
        }

        /**
         * Make a копируй of the список и return new голова. 
        **/

        Реф копируйСписок (Реф delegate() размести)
        {
                auto hd = this;

                auto новый_список = размести().установи (hd.значение, пусто, пусто);
                auto текущ = новый_список;

                for (auto p = следщ; p !is hd; p = p.следщ)
                     {
                     текущ.следщ = размести().установи (p.значение, текущ, пусто);
                     текущ = текущ.следщ;
                     }
                новый_список.предш = текущ;
                текущ.следщ = новый_список;
                return новый_список;
        }
}


