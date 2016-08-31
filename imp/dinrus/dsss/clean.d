/**
 * DSSS commands "очисть" an "дистчистка"
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

module dsss.clean;

import stdrus, sys.inc.kernel32;
import dsss.conf;


/** A utility function to attempt removal of a файл but not fail on error */
проц пробуйУдалить(ткст fn)
{
    try {
        УдалиФайлА(fn);
    } catch (Исключение e) {
        // ignored
    }
}

/** Clean a tree: Remove all empty directories in the tree */
проц очистьДерево(ткст dirn)
{
    try {
        удалипап(dirn);
        очистьДерево(извлекиПапку(dirn));
    } catch (Исключение e) {
        // ignored
    }
}

/** The entry function to the DSSS "очисть" команда */
цел очисть(ДСССКонф конф = null) {
    // fairly simple, get rid of easy things - dsss_objs and dsss_imports
    if (естьФайл("dsss_objs"))
        удалиРек("dsss_objs");
    if (естьФайл("dsss_imports"))
        удалиРек("dsss_imports");
    if (естьФайл("dsss_docs"))
        удалиРек("dsss_docs");
    return 0;
}

/** The entry function to the DSSS "дистчистка" команда */
цел дистчистка(ДСССКонф конф = null)
{
    // get the configuration
    if (конф is null)
        конф = читайКонфиг(null);
    
    // дистчистка implies очисть
    цел рез = очисть(конф);
    if (рез) return рез;
    скажифнс("");
    
    // get the sources
    ткст[] стройИсходники = исходникиПоЭлтам(null, конф);
    
    // then go through and delete actual файлы
    foreach (постройка; стройИсходники) {
        ткст[ткст] настройки = конф.настройки[постройка];
        
        // basic info
        ткст тип = настройки["type"];
        ткст цель = настройки["target"];
        
        // tell what we're doing
        скажифнс("Удаляется %s", цель);
        
        // do the предочистка шаг
        if ("preclean" in настройки) {
            шагСценарияДссс(конф, настройки["preclean"]);
        }
        
        if (тип == "library" || тип == "sourcelibrary") {
            if (цельГНУИлиПосикс()) {
                // first удалиФайл the static библиотека
                пробуйУдалить("lib" ~ цель ~ ".a");

                // then any testing бинарный
                пробуйУдалить("test_" ~ цель);
                
                // then удалиФайл the совместная libraries
                ткст имяСовмБиб = дайИмяСовмБиб(настройки);
                ткст[] краткиеИменаСовмБиб = дайКраткиеИменаСовмБиб(настройки);
                
                пробуйУдалить(имяСовмБиб);
                foreach (ssln; краткиеИменаСовмБиб) {
                    пробуйУдалить(ssln);
                }
                
            } else if (целеваяВерсия("Windows")) {
                // first удалиФайл the static библиотека
                пробуйУдалить(цель ~ ".lib");

                // then any testing бинарный
                пробуйУдалить("test_" ~ цель);
                
                // then удалиФайл the совместная libraries
                ткст имяСовмБиб = дайИмяСовмБиб(настройки);
                ткст[] краткиеИменаСовмБиб = дайКраткиеИменаСовмБиб(настройки);
                
                пробуйУдалить(имяСовмБиб);
                foreach (ssln; краткиеИменаСовмБиб) {
                    пробуйУдалить(ssln);
                }
            } else {
                assert(0);
            }
            
        } else if (тип == "binary") {
            if (целеваяВерсия("Posix")) {
                пробуйУдалить(цель);
            } else if (целеваяВерсия("Windows")) {
                пробуйУдалить(цель ~ ".exe");
            } else {
                assert(0);
            }
            
        } else if (тип == "subdir") {
            // recurse
            ткст исхтрп = дайтекпап();
            сменипап(постройка);
            цел cleanret = дистчистка();
            if (cleanret) return cleanret;
            сменипап(исхтрп);
            
        }
        
        // do the посточистка шаг
        if ("postclean" in настройки) {
            шагСценарияДссс(конф, настройки["postclean"]);
        }
        
        скажифнс("");
    }
    
    // and the lastbuild файл if it естьФайл
    if (естьФайл(имяКонфФайлаПП)) {
        пробуйУдалить(имяКонфФайлаПП);
    }
    
    return 0;
}
