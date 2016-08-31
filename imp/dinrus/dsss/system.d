/**
 * System functions, tempered by конф.подробнРежим.
 * 
 * Authors:
 *  Gregor Richards
 * 
 * License:
 *  Copyright (c) 2006, 2007  Gregor Richards
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

module dsss.system;
import dsss.conf;

import sys.DProcess;

/** система + output */
цел пСкажиИСис(ткст кмнд)
{
    if (подробнРежим)
        return скажиИСис(кмнд);
    else
        return система(кмнд);
}

/** сисИлиАборт + output */
проц пСкажиСисАборт(ткст кмнд)
{
    if (подробнРежим)
        скажиСисАборт(кмнд);
    else
        сисИлиАборт(кмнд);
}

/** сисРеспонс + output */
цел пСкажиИСисР(ткст кмнд, ткст рфлаг, ткст рфайл, бул удалитьРФайл)
{
    if (подробнРежим)
        return скажиИСисР(кмнд, рфлаг, рфайл, удалитьРФайл);
    else
        return сисРеспонс(кмнд, рфлаг, рфайл, удалитьРФайл);
}

/** сисРИлиАборт + output */
проц пСкажиСисРАборт(ткст кмнд, ткст рфлаг, ткст рфайл, бул удалитьРФайл)
{
    if (подробнРежим)
        скажиСисРАборт(кмнд, рфлаг, рфайл, удалитьРФайл);
    else
        сисРИлиАборт(кмнд, рфлаг, рфайл, удалитьРФайл);
}
