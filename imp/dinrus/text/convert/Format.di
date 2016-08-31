/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)
        
        version:        Sep 2007: Initial release
        version:        Nov 2007: добавьed поток wrappers

        author:         Kris

*******************************************************************************/

module text.convert.Format;

private import text.convert.Layout;

/******************************************************************************

        Constructs a global utf8 экземпляр of Выкладка

******************************************************************************/

public Выкладка!(сим) Формат;

static this()
{
        Формат = Выкладка!(сим).экземпляр;
}

