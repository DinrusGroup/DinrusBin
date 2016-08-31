/* *************************************************************************

        @file fdt.d

        Copyright (c) 2005 Derek Parnell

                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


        @version        Initial version, January 2005
        @author         Derek Parnell


**************************************************************************/

/**
 * A File Date-Time тип.

 * This data тип is used to compare and фм date-time data associated
 * with files.

 * Authors: Derek Parnell
 * Date: 08 aug 2006
 * History:
 * Licence:
        This software is provided 'as-is', without any express or implied
        warranty. In no event will the authors be held liable for damages
        of any kind arising from the use of this software.

        Permission is hereby granted to anyone to use this software for any
        purpose, including commercial applications, and to alter it and/or
        redistribute it freely, subject to the following restrictions:

        1. The origin of this software must not be misrepresented; you must
           not claim that you wrote the original software. If you use this
           software in a product, an acknowledgment within documentation of
           said product would be appreciated but is not required.

        2. Altered source versions must be plainly marked as such, and must
           not be misrepresented as being the original software.

        3. This notice may not be removed or altered from any distribution
           of the source.

        4. Derivative works are permitted, but they must carry this notice
           in full and credit the original source.

**/

module util.fdt;

        class ФайлДатаВремя
        {

            this();
            this(ткст имяФ);
            this(шткст имяФ);
            this(юткст имяФ);
            цел opEquals(ФайлДатаВремя др) ;
            цел opCmp(ФайлДатаВремя др) ;
            цел сравни(ФайлДатаВремя др, бул точно = нет);
            ткст вТкст(бул точно = нет);
        } // End of class definition.

