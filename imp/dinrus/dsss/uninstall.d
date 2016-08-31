/**
 * DSSS команда "деинсталлировать"
 * 
 * Authors:
 *  Gregor Richards
 * 
 * License:
 *  Copyright (c) 2006  Gregor Richards
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a
 *  copy of this software and associated докumentation файлы (the "Software"),
 *  to deal in the Software without restriction, including without limitation
 *  the rights to исп, copy, modify, merge, publish, distribute, sublicense,
 *  and/or sell copies of the Software, and to permit persons to whom the
 *  Software is furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 *  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 *  DEALINGS IN THE SOFTWARE.
 */

module dsss.uninstall;

import dsss.clean;
import dsss.conf;
import stdrus;

/** Entry to the "деинсталлировать" function */
цел деинсталлируй(ткст[] списИнструментов, бул тихо = нет)
{
    if (списИнструментов.length == 0) {
        скажифнс("Деинсталлировать что?");
        return 1;
    }
    
    foreach (инстр; списИнструментов)
    {
        // деинсталлировать this инстр
        ткст файлМанифеста = префиксМанифеста ~ РАЗДПАП ~ инстр ~ ".manifest";
        if (!естьФайл(файлМанифеста)) {
            if(!тихо)
            	скажифнс("Пакет " ~ инстр ~ " не установлен.");
            return 1;
        }
        
        скажифнс("Деинсталлируется %s", инстр);
        
        // get the список
        ткст[] манифест = разбей(
            cast(ткст) читайФайл(файлМанифеста),
            "\n");
        
        // then delete them
        foreach (файл; манифест) {
            if (файл != "") {
                // if it's not absolute, infer the absolute путь
                if (!абсПуть_ли(файл)) {
                    файл = форсПрефикс ~ РАЗДПАП ~ файл;
                }
                
                скажифнс("Удаляется %s", файл);
                пробуйУдалить(файл);
                очистьДерево(извлекиПапку(файл));
            }
        }
        
        скажифнс("");
    }
    
    return 0;
}

/** Entry to the "списуст" function */
цел списуст()
{
    foreach (пкт; списпап(префиксМанифеста).sort)
    {
        if (пкт.length < 9 || пкт[$-9 .. $]  != ".manifest") continue;
        пкт = пкт[0 .. $-9];
        
        скажифнс("%s", пкт);
    }
    
    return 0;
}
