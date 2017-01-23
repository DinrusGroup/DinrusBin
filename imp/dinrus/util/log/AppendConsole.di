﻿/*******************************************************************************

        copyright:      Copyright (c) 2004 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
      
        version:        Initial release: May 2004
        
        author:         Kris

*******************************************************************************/

module util.log.AppendConsole;

private import  io.Console;

private import  util.log.Log;

/*******************************************************************************

        Добавщик для отправки форматированного вывода на консоль

*******************************************************************************/

public class ДобВКонсоль : ДобПоток
{
        /***********************************************************************
                
                Создать с заданной выкладкой

        ***********************************************************************/

        this (Добавщик.Выкладка как = пусто);

        /***********************************************************************
                
                Возвращает имя класса

        ***********************************************************************/

        override ткст имя ();
}