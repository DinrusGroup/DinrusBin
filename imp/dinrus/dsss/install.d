/**
 * DSSS команда "инсталлируй"
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

module dsss.install;

import stdrus;
import sys.DProcess;

import dsss.conf;
import dsss.system;

/** Entry into the "инсталлируй" команда */
цел инсталлируй(ткст[] стройЭлты, ДСССКонф конф = null, ткст pname = null, char[][]* subManifest = null)
{
    // get the configuration
    if (конф is null)
        конф = читайКонфиг(стройЭлты);
    
    // get the corresponding sources
    ткст[] стройИсходники = исходникиПоЭлтам(стройЭлты, конф);
    
    // prepare to make a манифест
    if (pname.length == 0) {
        pname = конф.настройки[""]["name"].dup;
    }
    ткст[] манифест;
    ткст файлМанифеста;
    файлМанифеста = префиксМанифеста ~ РАЗДПАП ~ конф.настройки[""]["name"] ~ ".manifest";
    манифест ~= "imp" ~ РАЗДПАП ~"dinrus"~ РАЗДПАП ~"dsss"~ РАЗДПАП ~ "dsss" ~ РАЗДПАП ~ "manifest" ~ РАЗДПАП ~
        pname ~ ".manifest";
    
    /// Copy in the файл and add it to the манифест
    проц копируйИМанифестуй(ткст файл, ткст префикс, ткст откуда = "")
    {
        копируйВхФайл(файл, префикс, откуда);
        
        // if the префикс starts with the installation префикс, убери it
        if (префикс.length > форсПрефикс.length &&
            префикс[0..форсПрефикс.length] == форсПрефикс)
            префикс = префикс[форсПрефикс.length + 1 .. $];
        
        манифест ~= префикс ~ РАЗДПАП ~ файл;
    }
    
    // now инсталлируй the requested things
    foreach (постройка; стройИсходники) {
        ткст[ткст] настройки = конф.настройки[постройка];
        
        // basic info
        ткст тип = настройки["type"];
        ткст цель = настройки["target"];

        // maybe we shouldn't инсталлируй it
        if ("noinstall" in настройки)
            continue;
        
        // say what we're doing
        скажифнс("Устанавливается %s", цель);
        
        // do предустановка
        if ("preinstall" in настройки) {
            манифест ~= шагСценарияДссс(конф, настройки["preinstall"]);
        }
        
        // figure out what it is
        if (тип == "library" && бибсБезоп_ли()) {
            // far more complicated
            ткст[] исхФайлы = цельКФайлам(постройка, конф, да);
            if (исхФайлы.length == 0) {
                // warning is in dsss.build
                continue;
            }
            
            // 1) copy in библиотека файлы
            if (цельГНУИлиПосикс()) {
                // copy in the .a and .so/.dll файлы
                
                // 1) .a
                копируйИМанифестуй("lib" ~ цель ~ ".a", либПрефикс);

                // and perhaps the отладка версия as well
                if (строитьОтлад)
                    копируйИМанифестуй("libdebug-" ~ цель ~ ".a", либПрефикс);
                
                ткст имяСовмБиб = дайИмяСовмБиб(настройки);
                
                if (поддержкаСовмБиб() &&
                    ("shared" in настройки)) {
                    if (целеваяВерсия("Posix")) {
                        // 2) .so
                        ткст[] краткиеИменаСовмБиб = дайКраткиеИменаСовмБиб(настройки);
                
                        // copy in
                        копируйИМанифестуй(имяСовмБиб, либПрефикс);
                
                        // make softlinks
                        foreach (ssln; краткиеИменаСовмБиб) {
                            // make it
                            пСкажиСисАборт("ln -sf " ~ имяСовмБиб ~ " " ~
                                         либПрефикс ~ РАЗДПАП ~ ssln);
                            манифест ~= либПрефикс ~ РАЗДПАП ~ ssln;
                        }
                    } else if (целеваяВерсия("Windows")) {
                        // 2) .dll
                        копируйИМанифестуй(имяСовмБиб, либПрефикс);
                    } else {
                        assert(0);
                    }
                }
            } else if (целеваяВерсия("Windows")) {
                // copy in the .lib and .dll файлы
                
                // 1) .lib
                копируйИМанифестуй(цель ~ ".lib", либПрефикс);
                
                ткст имяСовмБиб = дайИмяСовмБиб(настройки);
                
                if (поддержкаСовмБиб() &&
                    ("shared" in настройки)) {
                    // 2) .dll
                    копируйИМанифестуй(имяСовмБиб, либПрефикс);
                }
            } else {
                assert(0);
            }
            
            // 2) инсталлируй generated .di файлы
            foreach (файл; исхФайлы) {
                // if it's already a .di файл, this is simpler
                if (stdrus.впроп(извлекиРасш(файл)) == "di") {
                    копируйИМанифестуй(извлекиИмяПути(файл),
                                    инклюдПрефикс ~ РАЗДПАП ~ извлекиПапку(файл),
                                    извлекиПапку(файл) ~ РАЗДПАП);

                } else {
                    // инсталлируй the generated .di файл
                    копируйИМанифестуй(извлекиИмяПути(файл ~ "i"),
                                    инклюдПрефикс ~ РАЗДПАП ~ извлекиПапку(файл),
                                    "dsss_imports" ~ РАЗДПАП ~ извлекиПапку(файл) ~ РАЗДПАП);
                }
            }
            
        } else if (тип == "binary") {
            // fairly easy
            if (целеваяВерсия("Posix")) {
                копируйИМанифестуй(цель, бинПрефикс);
            } else if (целеваяВерсия("Windows")) {
                копируйИМанифестуй(цель ~ ".exe", бинПрефикс);
            } else {
                assert(0);
            }
            
        } else if (тип == "sourcelibrary" ||
                   (тип == "library" && !бибсБезоп_ли())) {
            // also fairly easy
            ткст[] исхФайлы = цельКФайлам(постройка, конф, да);
            foreach (файл; исхФайлы) {
                ткст fdir = извлекиПапку(файл);
                ткст pdir = fdir.dup;
                if (fdir != "") fdir ~= РАЗДПАП;
                if (pdir != "") pdir = РАЗДПАП ~ pdir;
                
                копируйИМанифестуй(извлекиИмяПути(файл),
                                инклюдПрефикс ~ pdir,
                                fdir);
            }
            
        } else if (тип == "subdir") {
            // recurse
            ткст исхтрп = дайтекпап();
            сменипап(постройка);
            цел installret = инсталлируй(null, null, pname, &манифест);
            if (installret) return installret;
            сменипап(исхтрп);
        }
        
        // do постустановка
        if ("postinstall" in настройки) {
            манифест ~= шагСценарияДссс(конф, настройки["postinstall"]);
        }
        
        // инсталлируй the манифест itself
        if (subManifest) {
            (*subManifest) ~= манифест;
        } else {
            сделпапР(префиксМанифеста);
            пишиФайл(файлМанифеста, объедини(манифест, "\n") ~ "\n");
        }
        
        // extra строка for clarity
        скажифнс("");
    }
    
    // then инсталлируй докumentation
    if (делДоки && естьФайл("dsss_docs")) {
        скажифнс("Устанавливается документация...");
        
        ткст докs = докПрефикс ~ РАЗДПАП ~ pname;
        сделпапР(докs);
        
        сменипап("dsss_docs");
        
        // copy in everything
        проц копируйПап(ткст cdir)
        {
            ткст поддоки = докs ~ РАЗДПАП ~ cdir;
            сделпапР(поддоки);
            
            foreach (файл; списпап(cdir)) {
                ткст full = cdir ~ РАЗДПАП ~ файл;
                if (папка_ли(full)) {
                    копируйПап(full);
                } else {
                    копируйВхФайл(файл, поддоки, cdir ~ РАЗДПАП);
                }
            }
        }
        
        foreach (файл; списпап(".")) {
            if (папка_ли(файл)) {
                копируйПап(файл);
            } else {
                копируйВхФайл(файл, докs);
            }
        }
        
        сменипап("..");
    }
    
    return 0;
}
