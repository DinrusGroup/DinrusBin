/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
      
        version:        Nov 2005: разбей из_ Configurator.d
        verison:        Feb 2007: removed default console configuration
         
        author:         Kris

*******************************************************************************/

module util.log.ConfigProps;

private import  util.log.Log;

private import  io.stream.Map,
                io.device.File;

/*******************************************************************************

        A utility class for initializing the basic behaviour of the 
        default logging иерархия.

        Св_ваКонф parses a much simplified version of the property файл. 
        Dinrus.лог only supports the settings of Логгер levels at this время,
        и установи of Appenders и Layouts are currently готово "in the код"

*******************************************************************************/

struct Св_ваКонф
{
        /***********************************************************************
        
                Добавь a default StdioAppender, with a SimpleTimerLayout, в_ 
                the корень узел. The activity levels of все узелs are установи
                via a property файл with имя=значение pairs specified in the
                following форматируй:

                    имя: the actual logger имя, in dot notation
                          форматируй. The имя "корень" is reserved в_
                          сверь the корень logger узел.

                   значение: one of TRACE, INFO, WARN, ERROR, FATAL
                          or Неук (or the lowercase equivalents).

                For example, the declaration

                ---
                unittest = INFO
                myApp.СОКЕТActivity = TRACE
                ---
                
                sets the уровень of the loggers called unittest и
                myApp.СОКЕТActivity

        ***********************************************************************/

        static проц opCall (ткст путь);
}

