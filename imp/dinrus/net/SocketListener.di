/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: June 2004      
        
        author:         Kris

*******************************************************************************/

module net.SocketListener;

private import  thread;

private import         io.model;

/******************************************************************************

        Abstract class в_ asynchronously слушай for incoming данные on a 
        сокет. This can be использован with DatagramСОКЕТ & MulticastСОКЕТ, 
        и might possibly be useful with a basic СокетПровод also.
        Note that DatagramСОКЕТ must первый be bound в_ a local network
        адрес via вяжи(), и MulticastСОКЕТ should первый be made a 
        member of a multicast группа via its объедини() метод. Note also
        that the underlying нить is not пущен by the constructor;
        you should do that manually via the старт() метод.

******************************************************************************/

class СОКЕТListener
{
        private бул                    quit;
        private Нить                  нить;
        private ИБуфер                 буфер;
        private ИПровод                провод;
        private цел                     предел = 3;

        /**********************************************************************
               
                Construct a listener with the requisite аргументы. The
                specified буфер is populated via the provопрed экземпляр
                of IСОКЕТЧитатель before being passed в_ the сообщи()
                метод. все аргументы are требуется.

        **********************************************************************/

        this (ИБуфер буфер)
        {
                assert (буфер);
                this (буфер.ввод, буфер);
        }

        /**********************************************************************
               
                Construct a listener with the requisite аргументы. The
                specified буфер is populated via the provопрed экземпляр
                of IСОКЕТЧитатель before being passed в_ the сообщи()
                метод. все аргументы are требуется.

        **********************************************************************/

        this (ИПотокВвода поток, ИБуфер буфер)
        {
                assert (поток);
                this.буфер = буфер;
                this.провод = поток.провод;
                нить = new Нить (&run);
                нить.демон_ли = да;
        }

        /***********************************************************************
                
                Notification обрвызов invoked whenever the listener имеется
                anything в_ report. The буфер will have whatever контент
                was available из_ the читай() operation

        ***********************************************************************/

        abstract проц сообщи (ИБуфер буфер);

        /***********************************************************************

                Дескр ошибка conditions из_ the listener нить.

        ***********************************************************************/

        abstract проц исключение (ткст сооб);

        /**********************************************************************
             
                Start this listener

        **********************************************************************/

        проц выполни ()
        {
                нить.старт;
        }

        /**********************************************************************
             
                Cancel this listener. The нить will quit only after the 
                текущ читай() request responds, or is interrrupted.

        **********************************************************************/

        проц cancel ()
        {
                quit = да;
        }

        /**********************************************************************
             
                Набор the maximum contiguous число of exceptions this 
                listener will survive. Setting a предел of zero will 
                not survive any ошибки at все, whereas a предел of two
                will survive as дол as two consecutive ошибки don't 
                arrive back в_ back.

        **********************************************************************/

        проц setErrorLimit (бкрат предел)
        {
                this.предел = предел + 1;
        }

        /**********************************************************************

                Execution of this нить is typically stalled on the
                читай() метод belonging в_ the провод specified
                during construction. You can invoke cancel() в_ indicate
                execution should not proceed further, but that will not
                actually interrupt a блокed читай() operation.

                Note that exceptions are все directed towards the handler
                implemented by the class экземпляр. 

        **********************************************************************/

        private проц run ()
        {
                цел lives = предел;

                while (lives > 0)
                       try {
                           // старт with a clean slate
                           буфер.сожми;

                           // жди for incoming контент
                           auto результат = буфер.писатель (&провод.ввод.читай);

                           // время в_ quit? Note that a v0.95 compiler bug 
                           // prohibits 'break' из_ exiting the try{} блок
                           if (quit || 
                              (результат is провод.Кф && !провод.жив_ли))
                               lives = 0;
                           else
                              {
                              // invoke обрвызов                        
                              сообщи (буфер);
                              lives = предел;
                              }
                           } catch (Объект x)
                                    // время в_ quit?
                                    if (quit || !провод.жив_ли)
                                        break;
                                    else
                                       {
                                       исключение (x.вТкст);
                                       if (--lives is 0)
                                           исключение ("listener нить aborting");
                                       }
        }
}



