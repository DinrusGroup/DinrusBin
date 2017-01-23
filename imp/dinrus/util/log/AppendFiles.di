﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
      
        version:        Initial release: May 2004
        
        author:         Kris

*******************************************************************************/

module util.log.AppendFiles;

private import  time.Time;

private import  Путь = io.Path,
                io.device.File;

private import  io.model;

private import  util.log.Log,
                util.log.AppendFile;

/*******************************************************************************

        Добавка сообщений-логов в набор файлов. 

*******************************************************************************/

public class ДобВФайлы : Файлер
{
        private Маска            маска_;
        private ткст[]        пути;
        private цел             индекс;
        private дол            максРазм,
                                размерФайла;

        /***********************************************************************
                
                Создать ДобВФайлы для набора файлов с указанным путём к нему и 
                необязательной выкладкой. Минимальное число файлов равно двум, 
                максимальное 1000 (точнее 999). Заметьте, что файлы нумеруются
                начиная с нуля, а не единицы.

        ***********************************************************************/

        this (ткст путь, цел счёт, дол максРазм, Добавщик.Выкладка как = пусто);

        /***********************************************************************
                
                Вернуть fingerprint для этого класса

        ***********************************************************************/

        final Маска маска ();

        /***********************************************************************
                
                Вернуть имя данного класса

        ***********************************************************************/

        final ткст имя ();

        /***********************************************************************
                
                Добавить событие на вывод
                 
        ***********************************************************************/

        final synchronized проц добавь (СобытиеЛога событие);

        /***********************************************************************
                
               Переключиться на следующий файл в наборе

        ***********************************************************************/

        private проц следщФайл (бул сбрось);
}

/*******************************************************************************

*******************************************************************************/
unittest
{
        проц main()
        {
                Журнал.корень.добавь (new ДобВФайлы ("foo", 5, 6));
                auto лог = Журнал.отыщи ("fu.bar");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");
                лог.след ("hello {}", "world");

        }
}