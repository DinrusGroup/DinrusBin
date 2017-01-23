/**
 * This module provопрes an implementation of the classical нить-обойма model.
 *
 * Copyright: Copyright (C) 2007-2008 Anders Halager. все rights reserved.
 * License:   BSD стиль: $(LICENSE)
 * Author:    Anders Halager
 */

module core.ThreadPool;

private import sync, thread;
private version = Queued;

/**
 * A нить обойма is a way в_ process multИПle jobs in parallel without creating
 * a new нить for each дело. This way the overhead of creating a нить is
 * only paопр once, and not once for each дело and you can предел the maximum
 * число of threads активное at any one точка.
 *
 * In this case a "дело" is simply a delegate and some параметры the delegate
 * will be called with after having been добавьed в_ the нить обойма's queue.
 *
 * Example:
 * --------------------
 * // создай a new обойма with two threads
 * auto обойма = new Катушка!(цел)(2);
 * проц delegate(цел) f = (цел x) { Журнал(x); };
 *
 * // Сейчас we have three ways of telling the обойма в_ выполни our jobs
 * // First we can say we just want it готово at some later точка
 * обойма.добавь(f, 1);
 * // Secondly we can ask for a дело в_ be готово as soon as possible, blocking
 * // until it is пущен by some нить
 * обойма.присвой(f, 2);
 * // Finally we can say we either want it готово immediately or not at все
 * if (обойма.пробуйПрисвоить(f, 3))
 *     Журнал("Someone took the дело!");
 * else
 *     Журнал("No one was available в_ do the дело right сейчас");
 * // After giving the обойма some jobs в_ do, we need в_ give it a chance в_
 * // финиш, so we can do one of two things.
 * // Choice no. 1 is в_ финиш what есть already been assigned в_ the threads,
 * // but ignore any remaining queued jobs
 * //   обойма.глуши();
 * // The другой choice is в_ финиш все jobs currently executing or in queue:
 * обойма.финиш();
 * --------------------
 *
 * If добавь isn't called there should be no добавьitional куча allocations after
 * initialization.
 */

class Катушка(Арги...)
{
    /// An alias for the тип of delegates this нить обойма consопрers a дело
    alias проц delegate(Арги) ДДела;

    /**
     * Create a new Катушка.
     *
     * Параметры:
     *   трудяги = The amount of threads в_ spawn
     *   q_size  = The ожидалось размер of the queue (как many elements are
     *   preallocated)
     */
    this(т_мера трудяги, т_мера q_size = 0);

    /**
      Assign the given дело в_ a нить immediately or block until one is
      available
     */
    проц присвой(ДДела дело, Арги арги);

    /**
      Assign the given дело в_ a нить immediately or return нет if Неук is
      available. (Returns да if one was available)
     */
    бул пробуйПрисвоить(ДДела дело, Арги арги);

    /**
      Put a дело преобр_в the обойма for eventual execution.

      Предупреждение: Acts as a stack, not a queue as you would expect
     */
    проц добавь(ДДела дело, Арги арги);

    /// Get the число of jobs waiting в_ be executed
    т_мера ждущиеДела();

    /// Get the число of jobs being executed
    т_мера активныеДела();

    /// Block until все pending jobs complete, but do not shut down.  This allows ещё tasks в_ be добавьed later.
    проц жди();

    /// Finish currently executing jobs and drop все pending.
    проц глуши();

    /// Complete все pending jobs and глуши.
    проц финиш();

private:
    // Our список of threads -- only used during startup and глуши
    Нить[] обойма;
    struct Дело
    {
        ДДела дг;
        Арги арги;
    }
    // Used for storing queued jobs that will be executed eventually
    Дело[] q;

    // This is в_ сохрани a single дело for immediate execution, which hopefully
    // means that any program using only присвой and пробуйПрисвоить wont need any
    // куча allocations after startup.
    Дело* приоритетное_дело;

    // This should be used when accessing the дело queue
    Стопор m;

    // Notify is called on this condition whenever we have activity in the обойма
    // that the трудяги might want в_ know about.
    Условие активностьПула;

    // Worker threads вызов сообщи on this when they are готово with a дело or are
    // completely готово.
    // This allows a graceful shut down and is necessary since присвой есть в_
    // жди for a дело в_ become available
    Условие активностьТрудяги;

    // Are we in the глуши phase?
    бул готово;

    // Counter for the число of jobs currently being calculated
    т_мера активные_дела;

    // Нить delegate:
    проц делДело();
}



/*******************************************************************************

        Invoke as "threadpool 1 2 3 4 5 6 7 10 20" or similar

*******************************************************************************/

debug (Катушка)
{
        import util.log.Trace;
        import Целое = text.convert.Integer;

        проц main(ткст[] арги)
        {
                дол дело(дол знач)
                {
                        // a 'big дело'
                        Нить.сон (3.0/знач);
                        return знач;
                }

                проц hashJob(ткст файл)
                {
                        // If we don't catch exceptions the нить-обойма will still
                        // work, but the дело will краш silently
                        try {
                            дол n = Целое.разбор(файл);
                            След.форматнс("дело({}) = {}", n, дело(n));
                            } catch (Исключение ex) {
                                    След.форматнс("Исключение: {}", ex.сооб);
                                    }
                }

                // Create new нить обойма with one трудяга нить per файл given
                auto катушка = new Катушка!(ткст)(арги.length - 1);

                Нить.сон(1);
                След.форматнс ("стартуем");

                foreach (файл; арги[1 .. арги.length])
                         катушка.присвой(&hashJob, файл);

                катушка.финиш();
        }
}
