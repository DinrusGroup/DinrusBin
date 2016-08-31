/*******************************************************************************

        copyright:      Copyright (c) 2007 Kris Bell. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Jan 2007 : начальное release
        
        author:         Kris 

*******************************************************************************/

module io.protocol.EndianProtocol;

private import  stdrus;

private import           io.model;

private import  io.protocol.NativeProtocol;



class ПротоколЭндиан : ПротоколНатив
{

        this (ИПровод провод, бул префикс=да);
        override проц[] читай (ук приёмн, бцел байты, Тип тип);
        override проц пиши (ук ист, бцел байты, Тип тип);
}
