/**
 * The signal module provопрes a basic implementation of the listener образец
 * using the "Signals and Slots" model из_ Qt.
 *
 * Copyright: Copyright (C) 2005-2006 Sean Kelly.  все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Authors:   Sean Kelly
 */
module core.Signal;


private import core.Array;


/**
 * A signal is an событие which содержит a collection of listeners (called
 * slots).  When a signal is called, that вызов will be propagated в_ each
 * attached slot in a синхронно manner.  It is legal for a slot в_ вызов a
 * signal's прикрепи and открепи methods when it is signaled.  When this occurs,
 * прикрепи события will be queued and processed after the signal есть propagated
 * в_ все slots, but открепи события are processed immediately.  This ensures
 * that it is safe for slots в_ be deleted at any время, even within a slot
 * routine.
 *
 * Example:
 * -----------------------------------------------------------------------------
 *
 * class Кнопка
 * {
 *     Сигнал!(Кнопка) нажми;
 * }
 *
 * проц wasPressed( Кнопка b )
 * {
 *     printf( "Кнопка was pressed.\n" );
 * }
 *
 * Кнопка b = new Кнопка;
 *
 * b.нажми.прикрепи( &wasPressed );
 * b.нажми( b );
 *
 * -----------------------------------------------------------------------------
 *
 * Please note that this implementation does not use weak pointers в_ сохрани
 * references в_ slots.  This design was chosen because weak pointers are
 * inherently unsafe when combined with non-deterministic destruction, with
 * many of the same limitations as destructors in the same situation.  It is
 * still possible в_ obtain weak-pointer behavior, but this must be готово
 * through a proxy объект instead.
 */
struct Сигнал( Арги... )
{
    alias проц delegate(Арги) СлотДг; ///
    alias проц function(Арги) СлотФн; ///

    alias opCall вызов; /// Alias в_ simplify chained calling.


    /**
     * The signal procedure.  When called, each of the attached slots will be
     * called synchronously.
     *
     * арги = The signal аргументы.
     */
    проц opCall( Арги арги )
    {
        synchronized
        {
            m_blk = да;

            for( т_мера i = 0; i < m_dgs.length; ++i )
            {
                if( m_dgs[i] !is пусто )
                    m_dgs[i]( арги );
            }
            m_dgs.length = m_dgs.удали( cast(СлотДг) пусто );

            for( т_мера i = 0; i < m_fns.length; ++i )
            {
                if( m_fns[i] !is пусто )
                    m_fns[i]( арги );
            }
            m_fns.length = m_fns.удали( cast(СлотФн) пусто );

            m_blk = нет;

            процады();
        }
    }


    /**
     * Attaches a delegate в_ this signal.  A delegate may be either attached
     * or detached, so successive calls в_ прикрепи for the same delegate will
     * have no effect.
     *
     * дг = The delegate в_ прикрепи.
     */
    проц прикрепи( СлотДг дг )
    {
        synchronized
        {
            if( m_blk )
            {
                m_add ~= Добавка( дг );
            }
            else
            {
                auto поз = m_dgs.найди( дг );
                if( поз == m_dgs.length )
                    m_dgs ~= дг;
            }
        }
    }


    /**
     * Attaches a function в_ this signal.  A function may be either attached
     * or detached, so successive calls в_ прикрепи for the same function will
     * have no effect.
     *
     * фн = The function в_ прикрепи.
     */
    проц прикрепи( СлотФн фн )
    {
        synchronized
        {
            if( m_blk )
            {
                m_add ~= Добавка( фн );
            }
            else
            {
                auto поз = m_fns.найди( фн );
                if( поз == m_fns.length )
                    m_fns ~= фн;
            }
        }
    }


    /**
     * Detaches a delegate из_ this signal.
     *
     * дг = The delegate в_ открепи.
     */
    проц открепи( СлотДг дг )
    {
        synchronized
        {
            auto поз = m_dgs.найди( дг );
            if( поз < m_dgs.length )
                m_dgs[поз] = пусто;
        }
    }


    /**
     * Detaches a function из_ this signal.
     *
     * фн = The function в_ открепи.
     */
    проц открепи( СлотФн фн )
    {
        synchronized
        {
            auto поз = m_fns.найди( фн );
            if( поз < m_fns.length )
                m_fns[поз] = пусто;
        }
    }


private:
    struct Добавка
    {
        enum Тип
        {
            ДГ,
            ФН
        }

        static Добавка opCall( СлотДг d )
        {
            Добавка e;
            e.ty = Тип.ДГ;
            e.дг = d;
            return e;
        }

        static Добавка opCall( СлотФн f )
        {
            Добавка e;
            e.ty = Тип.ФН;
            e.фн = f;
            return e;
        }

        union
        {
            СлотДг  дг;
            СлотФн  фн;
        }
        Тип        ty;
    }


    проц процады()
    {
        foreach( a; m_add )
        {
            if( a.ty == Добавка.Тип.ДГ )
                m_dgs ~= a.дг;
            else
                m_fns ~= a.фн;
        }
        m_add.length = 0;
    }


    СлотДг[]    m_dgs;
    СлотФн[]    m_fns;
    Добавка[]       m_add;
    бул        m_blk;
}


debug( UnitTest )
{
  unittest
  {
    class Кнопка
    {
        Сигнал!(Кнопка) нажми;
    }

    цел счёт = 0;

    проц wasPressedA( Кнопка b )
    {
        ++счёт;
    }

    проц wasPressedB( Кнопка b )
    {
        ++счёт;
    }

    Кнопка b = new Кнопка;

    b.нажми.прикрепи( &wasPressedA );
    b.нажми( b );
    assert( счёт == 1 );

    счёт = 0;
    b.нажми.прикрепи( &wasPressedB );
    b.нажми( b );
    assert( счёт == 2 );

    счёт = 0;
    b.нажми.прикрепи( &wasPressedA );
    b.нажми( b );
    assert( счёт == 2 );

    счёт = 0;
    b.нажми.открепи( &wasPressedB );
    b.нажми( b );
    assert( счёт == 1 );

    счёт = 0;
    b.нажми.открепи( &wasPressedA );
    b.нажми( b );
    assert( счёт == 0 );
  }
}
