/**
 * DSSS команда "сеть"
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

module dsss.net;

import stdrus;

import dsss.build;
import dsss.clean;
import dsss.conf;
import dsss.install;
import dsss.system;
import dsss.uninstall;
import sys.DProcess;
/// If set, the given зеркало will be used
ткст форсЗеркало;

/*import mango.http.client.HttpClient;
import mango.http.client.HttpGet;*/

/** Entry to the "сеть" команда */
цел сеть(ткст[] арги)
{
    // cannot be used откуда the исток dir
    if (вИсхПапке) {
        скажифнс(" Подкоманда 'сеть' не может использоваться из DSSS, запущенного в исходной");
        скажифнс(" папке. Требуется инсталляция DSSS.");
        return 1;
    }
    
    // make sure our sources список is up to date
    static бул srcListUpdated = нет;
    if (!srcListUpdated) {
        srcListUpdated = да;
        
        // check for cruft откуда pre-0.3 DSSS
        if (естьФайл(префиксСпискаИсх ~ РАЗДПАП ~ ".svn")) {
            удалиРек(префиксСпискаИсх);
        }
        
        скажифнс("Выполняется синхронизация...");
        
        if (!естьФайл(префиксСпискаИсх ~ РАЗДПАП ~ "зеркало")) {
            // найди the full список.list файл имя
            ткст listlist = префиксУстановки ~ РАЗДПАП ~
                ".." ~ РАЗДПАП ~
                "etc" ~ РАЗДПАП ~
                "dsss" ~ РАЗДПАП ~
                "list.list";
            version(Posix) {
                if (!естьФайл(listlist)) {
                    listlist = "/etc/dsss/list.list";
                }
            }
            
            // select a исток список зеркало
            ткст[] списокЗеркал = разбей(
                замени(
                    cast(char[]) читайФайл(listlist),
                    "\r", ""),
                "\n");
            while (списокЗеркал[$-1] == "") списокЗеркал = списокЗеркал[0..$-1];
            
            цел sel = -1;
            
            if (форсЗеркало.length == 0) {
                if (списокЗеркал.length == 1) {
                    // easy choice :)
                    sel = 0;
                } else {
                    скажифнс("Пожалуйста, выберите зеркало для получения списка исходников:");
                    скажифнс("(Внимание: можно в любое время выбрать другое зеркало, удалив папку");
                    скажифнс("%s)", префиксСпискаИсх);
                    скажифнс("");
                    
                    foreach (i, зеркало; списокЗеркал) {
                        скажифнс("%d) %s", i + 1, зеркало);
                    }
                    
                    // choose
                    ткст csel;
                    while (sel < 0 || sel >= списокЗеркал.length) {
                        csel = двхо.читайСтр();
                        sel = stdrus.ткствцел(csel) - 1;
                    }
                }
            }
            
            ткст зеркало;
            if (sel == -1) {
                зеркало = форсЗеркало;
            } else {
                зеркало = списокЗеркал[sel];
            }
            
            // get it
            сделпапР(префиксСпискаИсх);
            пишиФайл(префиксСпискаИсх ~ РАЗДПАП ~ "mirror",
                           зеркало);
            скажиИСис("curl -s -S -k " ~ зеркало ~ "/source.list "
                        "-o " ~ префиксСпискаИсх ~ РАЗДПАП ~ "source.list");
            скажиИСис("curl -s -S -k " ~ зеркало ~ "/pkgs.list "
                        "-o " ~ префиксСпискаИсх ~ РАЗДПАП ~ "pkgs.list");
            скажиИСис("curl -s -S -k " ~ зеркало ~ "/mirrors.list "
                        "-o " ~ префиксСпискаИсх ~ РАЗДПАП ~ "mirrors.list");
        } else {
            ткст зеркало;
            if (форсЗеркало.length == 0) {
                зеркало = cast(char[]) читайФайл(
                    префиксСпискаИсх ~ РАЗДПАП ~ "mirror");
            } else {
                зеркало = форсЗеркало;
            }
            
            ткст srcList = префиксСпискаИсх ~ РАЗДПАП ~ "source.list";
            ткст pkgsList = префиксСпискаИсх ~ РАЗДПАП ~ "pkgs.list";
            ткст списокЗеркал = префиксСпискаИсх ~ РАЗДПАП ~ "mirrors.list";
            
            скажиИСис("curl -s -S -k " ~ зеркало ~ "/source.list "
                        "-o " ~ srcList ~
                        " -z " ~ srcList);
            скажиИСис("curl -s -S -k " ~ зеркало ~ "/pkgs.list "
                        "-o " ~ pkgsList ~
                        " -z " ~ pkgsList);
            скажиИСис("curl -s -S -k " ~ зеркало ~ "/mirrors.list "
                        "-o " ~ списокЗеркал ~
                        " -z " ~ списокЗеркал);
        }
        
        скажифнс("");
    }
    
    // load it
    КонфигСети конф = читайКонфигСети();
    
    // now switch on the команда
    if (арги.length < 1) {
        скажифнс("Команда сеть требует в качестве параметра другую команду.");
        return 1;
    }
    switch (арги[0]) {
        case "зависимости", "deps":
        case "завсписок", "depslist":
        {
            ДСССКонф dconf = читайКонфиг(null);
            ткст[] зависимости;
            if (арги[0] == "зависимости"||арги[0] == "deps") {
                зависимости = истокВЗависимости(да, конф, dconf);
            } else {
                зависимости = истокВЗависимости(нет, конф, dconf);
            }
            
            if (арги[0] == "зависимости"||арги[0] == "deps") {
                // инсталлируй dependencies
                foreach (dep; зависимости) {
                    if (dep == "" || dep == dconf.настройки[""]["name"]) continue;
                
                    ткст[] netcommand;
                    netcommand ~= "assert";
                    netcommand ~= dep;
                
                    скажифнс("\n\nУстанавливается %s\n", dep);
                    цел netret = сеть(netcommand);
                    if (netret) return netret;
                }
                
            } else {
                // just список them
                зависимости = зависимости.dup.sort;
                ткст last = "";
                foreach (dep; зависимости) {
                    if (dep != last && dep != "" &&
                        dep != dconf.настройки[""]["name"]) {
                        скажифнс("%s", dep);
                        last = dep;
                    }
                }
                
            }
            
            return 0;
        }
        
        case "проверь", "assert":
        {
            // make sure that the инстр is списуст, инсталлируй it if not
            
            // check for манифест файлы in every usedir
            бул found = нет;
            ткст файлМанифеста = префиксМанифеста ~ РАЗДПАП ~ арги[1] ~ ".manifest";
            if (естьФайл(файлМанифеста)) {
                found = да;
            } else {
                
                foreach (dir; использПапки) {
                    файлМанифеста = dir ~ РАЗДПАП ~
                        "share" ~ РАЗДПАП ~
                        "dsss" ~ РАЗДПАП ~
                        "manifest" ~ РАЗДПАП ~
                        арги[1] ~ ".manifest";
                    if (естьФайл(файлМанифеста)) {
                        found = да;
                        break;
                    }
                }
            }
            
            if (found) {
                скажифнс("%s уже установлен.\n", арги[1]);
                return 0;
            }
            
            // fall through
        }
        
        case "скачать", "fetch":
        case "инсталлируй", "install":
        {
            // download and инсталлируй the specified package and its dependencies
            if (арги.length < 2) {
                скажифнс("Имя пакета не указано.");
                return 1;
            }
            
            // 0) sanity
            if (!(арги[1] in конф.верс)) {
                скажифнс("Такого пакета, кажется, нет!");
                return 1;
            }
            
            // 1) make the исток directory
            ткст srcDir = черновойПрефикс ~ РАЗДПАП ~ "DSSS_" ~ арги[1];
            ткст tmpDir = srcDir;
            сделпапР(srcDir);
            скажифнс("Работа ведётся в %s", srcDir);
            
            // 2) сменипап
            ткст исхтрп = дайтекпап();
            сменипап(srcDir);
            
            // make sure the directory gets removed
            scope(exit) {
                сменипап(исхтрп);
                удалиРек(tmpDir);
            }
            
            // 3) get sources
            if (!дайИсходники(арги[1], конф)) return 1;
            srcDir = дайтекпап();
            
            // if we're just fetching, make the archive
            if (арги[0] == "скачать"||арги[0] == "fetch") {
                ткст archname = арги[1] ~ ".tar.gz";
                
                // compress
                version(Windows) {
                    // CyberShadow 2007.02.21: this code actually works now
                    ткст[] файлы = списпап("");
                    auto regexp = РегВыр(r"^[^\.]");
                    ткст cmdline = "bsdtar -zcf " ~ archname;
                    foreach(файл;файлы)
                        if(regexp.проверь(файл))
                            cmdline ~= " " ~ файл;
                    пСкажиСисАборт(cmdline);
                } else {
                    пСкажиСисАборт("tar -cf - * | gzip -c > " ~ archname);
                }
                
                // move into place
                try {
                    переименуйФайл(archname,
                                    исхтрп ~ РАЗДПАП ~ archname);
                } catch (Исключение x) {
                    // can't rename, copy
                    копируйФайл(archname,
                                  исхтрп ~ РАЗДПАП ~ archname);
                    удалиФайл(archname);
                }
                
                скажифнс("Создан архив %s", archname);
                return 0;
            } else {
                // 4) make sure it's not списуст
                if (арги[1] != "dsss")
                    деинсталлируй(арги[1..2], да);
                
                // 5) инсталлируй prerequisites
                ткст[] netcmd;
                netcmd ~= "deps";
                цел netret = сеть(netcmd);
                if (netret) return netret;
                сменипап(srcDir);
                
                // 6) постройка
                ДСССКонф dconf = читайКонфиг(null);
                цел резпостроя = строй(арги[2..$], dconf);
                if (резпостроя) return резпостроя;
                
                // 7) инсталлируй
                return инсталлируй(арги[2..$]);
            }
        }
        
        case "список":
        {
            // Just список installable packages
            foreach (пкт; конф.исхУЛР.keys.sort) {
                скажифнс("%s", пкт);
            }
            return 0;
        }
        
        case "поиск":
        {
            // List matching packages
            if (арги.length < 2) {
                скажифнс("Найти что?");
                return 1;
            }
            
            foreach (пкт; конф.исхУЛР.keys.sort) {
                if (найди(пкт, арги[1]) != -1) {
                    скажифнс("%s", пкт);
                }
            }
            
            return 0;
        }
        
        default:
            скажифнс("Нераспознанная команда: %s", арги[0]);
            return 1;
    }
}

/** Net конфиг object */
class КонфигСети {
    /** The зеркало in исп */
    ткст зеркало;
    
    /** Versions of packages */
    ткст[ткст] верс;
    
    /** Dependencies of packages */
    char[][][char[]] зависимости;
    
    /** Source formats of packages */
    ткст[ткст] исхФормат;
    
    /** Source URL of packages */
    ткст[ткст] исхУЛР;
    
    /** Patches */
    char[][][char[]] исхПатчи;
}

/** Read the сеть configuration info */
КонфигСети читайКонфигСети()
{
    КонфигСети конф = new КонфигСети();
    
    // читай in the зеркало
    конф.зеркало = cast(char[]) читайФайл(префиксСпискаИсх ~ РАЗДПАП ~ "mirror");
    
    // читай in the main инстр/dep/версия список
    ткст списокпкт = замени(
        cast(char[]) читайФайл(префиксСпискаИсх ~ РАЗДПАП ~ "pkgs.list"),
        "\r", "");
    foreach (пкт; разбей(списокпкт, "\n")) {
        if (пкт.length == 0 || пкт[0] == '#') continue;
        
        ткст[] пктинфо = разбей(пкт, " ");
        
        // format: пкт ver зависимости
        if (пктинфо.length < 2) continue;
        конф.верс[пктинфо[0]] = пктинфо[1];
        конф.зависимости[пктинфо[0]] = пктинфо[2..$];
    }
    
    // then читай in the исток список
    ткст списисх = cast(char[]) читайФайл(префиксСпискаИсх ~ РАЗДПАП ~ "source.list");
    foreach (пкт; разбей(списисх, "\n")) {
        if (пкт.length == 0 || пкт[0] == '#') continue;
        
        ткст[] пктинфо = разбей(пкт, " ");
        
        //format: пкт protocol/format URL [patches]
        if (пктинфо.length < 3) continue;
        конф.исхФормат[пктинфо[0]] = пктинфо[1];
        конф.исхУЛР[пктинфо[0]] = пктинфо[2];
        конф.исхПатчи[пктинфо[0]] = пктинфо[3..$];
    }
    
    return конф;
}

/** Generate a список of dependencies for the current исток */
ткст[] истокВЗависимости(бул толькоНераспозн, КонфигСети nconf = null, ДСССКонф конф = null)
{
    if (nconf is null) {
        nconf = читайКонфигСети();
    }
    if (конф is null) {
        конф = читайКонфиг(null);
    }
    
    // start with the требует настройка
    ткст[] зависимости;
    if ("requires" in конф.настройки[""]) {
        зависимости ~= разбей(конф.настройки[""]["requires"]);
    }
    
    // then trace uses
    foreach (секция; конф.секции) {
        ткст[] файлы;
        ткст тип = конф.настройки[секция]["type"];
        if (тип == "binary") {
            файлы ~= секция;
        } else if (тип == "library" || тип == "sourecelibrary") {
            файлы ~= цельКФайлам(секция, конф);
        } else if (тип == "subdir") {
            // recurse
            ткст исхтрп = дайтекпап();
            сменипап(секция);
            зависимости ~= истокВЗависимости(толькоНераспозн, nconf);
            сменипап(исхтрп);
            continue;
        } else {
            // ignore
            continue;
        }
        
        // исп ребилд -файлы or -notfound to get the список of файлы
        ткст флагФайлы = "-files";
        if (толькоНераспозн)
            флагФайлы = "-notfound";
        сисРеспонс(ребилд ~ " " ~ флагФайлы ~ " -offiles.tmp " ~
                       объедини(файлы, " "), "-rf", "temp.rf", да);
        
        // читай the uses
        ткст[] uses = разбей(cast(char[]) читайФайл("files.tmp"),
                                         "\n");
        foreach (исп; uses) {
            if (исп.length == 0) break;

            // get rid of any trailing \r's or \n's
            while (исп.length &&
                   (исп[$-1] == '\n' ||
                    исп[$-1] == '\r')) {
                исп = исп[0..$-1];
            }
            if (исп.length == 0) break;
            
            // add the dep
            зависимости ~= канонИсходник(исп, nconf);
        }
        
        пробуйУдалить("files.tmp");
    }
    
    return зависимости;
}

/** Canonicalize a dependency (.d -> исток) */
ткст канонИсходник(ткст origsrc, КонфигСети nconf)
{
    ткст ист = origsrc.dup;
    version(Windows) {
        ист = замени(ист, "\\\\", "/");
    }
    
    if ((ист.length > 2 &&
         stdrus.впроп(ист[$-2 .. $]) == ".d") ||
        (ист.length > 3 &&
         stdrus.впроп(ист[$-3 .. $]) == ".di")) {
        // convert to a proper исток
        if (ист in nconf.зависимости &&
            nconf.зависимости[ист].length == 1) {
            ист = nconf.зависимости[ист][0].dup;
        } else {
            ист = "";
        }
    }
    
    return ист;
}

/** Get the исток for a given package
 * Returns да on success, нет on failure
 * NOTE: Your сменипап can change! */
бул дайИсходники(ткст пкт, КонфигСети конф)
{
    /// get sources откуда upstream, return нет on failure
    бул getUpstream() {
        // 1) get исток
        ткст исхФормат = конф.исхФормат[пкт];
        цел рез;
        switch (исхФормат) {
            case "svn":
                // Subversion, check it out
                рез = пСкажиИСис("svn export " ~ конф.исхУЛР[пкт]);
                break;
                
            default:
            {
                /* download ...
                HttpGet dlhttp = new HttpGet(конф.исхУЛР[пкт]);
                
                // save it to a исток файл
                write("src." ~ исхФормат, dlhttp.читай());*/
                
                // mango doesn't work properly for me :(
                рез = пСкажиИСис("curl -k " ~ конф.исхУЛР[пкт] ~ " -o src." ~ исхФормат);
                if (рез != 0) return нет;
                
                // extract it
                switch (исхФормат) {
                    case "tar.gz":
                    case "tgz":
                        version(Windows) {
                            // assume BsdTar
                            пСкажиИСис("bsdtar -xf src." ~ исхФормат);
                            рез = 0;
                        } else {
                            рез = пСкажиИСис("gunzip -c src." ~ исхФормат ~ " | tar -xf -");
                        }
                        break;
                        
                    case "tar.bz2":
                        version(Windows) {
                            // assume BsdTar
                            пСкажиИСис("bsdtar -xf src.tar.bz2");
                            рез = 0;
                        } else {
                            рез = пСкажиИСис("bunzip2 -c src.tar.bz2 | tar -xf -");
                        }
                        break;
                        
                    case "zip":
                        version(Windows) {
                            // assume BsdTar
                            пСкажиИСис("bsdtar -xf src.zip");
                            рез = 0;
                        } else {
                            // assume InfoZip
                            рез = пСкажиИСис("unzip src.zip");
                        }
                        break;
                        
                    default:
                        скажифнс("Нераспознанный формат исходника: %s", исхФормат);
                        return нет;
                }
            }
        }
        
        if (рез != 0) return нет;
        
        // 2) apply patches
        ткст srcDir = дайтекпап();
        foreach (patch; конф.исхПатчи[пкт]) {
            ткст[] pinfo = разбей(patch, ":");
            ткст dir;
            ткст pfile;
            
            // разбей into dir:файл or just файл
            if (pinfo.length < 2) {
                dir = srcDir;
                pfile = pinfo[0];
            } else {
                dir = pinfo[0];
                pfile = pinfo[1];
            }
            
            сменипап(dir);
            
            // download the patch файл
            пСкажиСисАборт("curl -k " ~ конф.зеркало ~ "/" ~ pfile ~
                         " -o " ~ pfile);
            
            // convert it to DOS строка endings if necessary
            version(Windows) {
                пСкажиСисАборт("unix2dos " ~ pfile);
            }
            
            // инсталлируй the patch
            система("patch -p0 -N -i " ~ pfile);    // CyberShadow 2007.02.21: added -N to prevent useless questions ("apply reverse patch?") when re-running "сеть инсталлируй"
            
            сменипап(srcDir);
        }
        
        return да;
    }
    
    if (!getUpstream()) {
        // failed to get откуда upstream, try a зеркало
        ткст[] списокЗеркал = разбей(
            cast(char[]) читайФайл(
                префиксСпискаИсх ~ РАЗДПАП ~ "mirrors.list"
                ),
            "\n");
        while (списокЗеркал[$-1] == "") списокЗеркал = списокЗеркал[0..$-1];
        
        // fail with zero mirrors
        if (списокЗеркал.length > 0) {
            // choose a random one
            uint sel = cast(uint) ((cast(double) списокЗеркал.length) * (случайно() / (uint.max + 1.0)));
            ткст зеркало = списокЗеркал[sel];
            
            пСкажиСисАборт("curl -k " ~ зеркало ~ "/" ~ пкт ~ ".tar.gz " ~
                         "-o " ~ пкт ~ ".tar.gz");
            
            // extract
            version(Windows) {
                пСкажиИСис("bsdtar -xf " ~ пкт ~ ".tar.gz");
            } else {
                пСкажиСисАборт("gunzip -c " ~ пкт ~ ".tar.gz | tar -xf -");
            }
        }
    }
    
    // 3) figure out where the исток is and сменипап
    if (!естьФайл(имяКонфФайла)) {
        ткст[] sub = списпап(".");
        foreach (entr; sub) {
            if (entr[0] == '.') continue;
                    
            // check if it's a исток directory
            if (папка_ли(entr)) {
                if (естьФайл(entr ~ РАЗДПАП ~ имяКонфФайла)) {
                    // found
                    сменипап(entr);
                    break;
                }
            }
        }
    }
    
    return да;
}


