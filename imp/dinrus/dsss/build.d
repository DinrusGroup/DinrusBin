/**
 * DSSS команда "постройка"
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

module dsss.build;
import stdrus, cidrus, sys.WinProcess;

import dsss.conf;
import dsss.system;

/** The entry function to the DSSS "постройка" команда */
цел строй(ткст[] стройЭлты, ДСССКонф конф = null, ткст форсФлаги = "") {
    // get the configuration
    if (конф is null)
        конф = читайКонфиг(стройЭлты);

    // стройЭлты are by either soure or цель, so we need one by исток only
    ткст[] стройИсходники;

    // get the sources
    стройИсходники = исходникиПоЭлтам(стройЭлты, конф);

    // also get a complete список, since some steps need it
    ткст[] всеИсходники = исходникиПоЭлтам(null, конф);

    /* building is fairly complicated, involves these steps:
     * 1) Make .di файлы
     *    (so that you link against your own libraries)
     * 2) Make fake совместная libraries
     *    (they need to exist so that other libraries can link against them)
     * 3) Make real совместная libraries
     * 4) Make binaries
     */

    // make the basic постройка строка
    ткст bl = ребилд ~ форсФлаги ~ " ";

    // add -oq if we don't have such a настройка
    if (найди(форсФлаги, "-o") == -1) {
        сделпапР("dsss_objs" ~ РАЗДПАП ~ краткоОКомпиляторе());
        bl ~= "-oqdsss_objs" ~ РАЗДПАП ~ краткоОКомпиляторе() ~ " ";
    }

    // 1) Make .di файлы for everything
    foreach (постройка; всеИсходники) {
        ткст[ткст] настройки = конф.настройки[постройка];

        // basic info
        ткст тип = настройки["type"];
        ткст цель = настройки["target"];

        if (тип == "library" && бибсБезоп_ли()) {

            // do the предиген
            if ("predigen" in настройки) {
                шагСценарияДссс(конф, настройки["predigen"]);
            }

            // this is a библиотека, so make .di файлы
            ткст[] исхФайлы = цельКФайлам(постройка, конф);

            // generate .di файлы
            foreach (файл; исхФайлы) {
                ткст ifile = "dsss_imports" ~ РАЗДПАП ~ файл ~ "i";
                if (!естьФайл(ifile) ||
                    файлНовееЧем(файл, ifile)) {
                    /* BIG FAT NOTE slash FIXME:
                     * .di файлы do NOT включить interfaces! So, we need to just
                     * cast .d файлы as .di until that's fixed */
                    сделпапР(извлекиПапку(ifile));

                    // now edit the .di файл to reference the appropriate библиотека

                    // usname = name_with_underscores
                    ткст usname = замени(постройка, "\\\\", "_");

                    // if we aren't building a отладка библиотека, the отладка conditional will fall through
                    ткст отладПрефикс = null;
                    if (строитьОтлад)
                        отладПрефикс = "debug-";

                    /* generate the pragmas (FIXME: this should be done in a
                     * nicer way) */
                    ткст имяДефБиблиотеки = имяБиблиотеки(постройка);
                    if (имяДефБиблиотеки == цель) {
                        пишиФайл(ifile, читайФайл(файл) ~ `
version(build) {
    debug {
        version(GNU) {
            pragma(link, "` ~ отладПрефикс ~ `DG` ~ цель[2..$] ~ `");
        } else version(DigitalMars) {
            pragma(link, "` ~ отладПрефикс ~ `DD` ~ цель[2..$] ~ `");
        } else {
            pragma(link, "` ~ отладПрефикс ~ `DO` ~ цель[2..$] ~ `");
        }
    } else {
        version(GNU) {
            pragma(link, "DG` ~ цель[2..$] ~ `");
        } else version(DigitalMars) {
            pragma(link, "DD` ~ цель[2..$] ~ `");
        } else {
            pragma(link, "DO` ~ цель[2..$] ~ `");
        }
    }
}
`);
                    } else {
                        пишиФайл(ifile, читайФайл(файл) ~ `
version(build) {
    debug {
        pragma(link, "` ~ отладПрефикс ~ цель ~ `");
    } else {
        pragma(link, "` ~ цель ~ `");
    }
}
`);
                    }
                }
            }

            // do the постдиген
            if ("postdigen" in настройки) {
                шагСценарияДссс(конф, настройки["postdigen"]);
            }

            скажифнс("");

        }
    }

    // 2) Make fake совместная libraries
    if (поддержкаСовмБиб()) {
        foreach (постройка; всеИсходники) {
            ткст[ткст] настройки = конф.настройки[постройка];

            // ignore this if we're not building a совместная библиотека
            if (!("shared" in настройки)) continue;

            // basic info
            ткст тип = настройки["type"];
            ткст цель = настройки["target"];

            if (тип == "library" && бибсБезоп_ли()) {
                ткст имяСовмБиб = дайИмяСовмБиб(настройки);
                ткст[] краткиеИменаСовмБиб = дайКраткиеИменаСовмБиб(настройки);
                ткст флагСовмБиб = дайФлагСовмБиб(настройки);

                if (естьФайл(имяСовмБиб)) continue;

                скажифнс("Постройка стержня совместной библиотеки для %s", цель);

                // make the stub
                if (цельГНУИлиПосикс()) {
                    ткст stubbl = bl ~ "-fPIC -shlib " ~ стабДРасп ~ " -of" ~ имяСовмБиб ~
                        " " ~ флагСовмБиб;
                    пСкажиСисРАборт(stubbl, "-rf", имяСовмБиб ~ "_stub.rf", удалитьРФайлы);
                    if (целеваяВерсия("Posix")) {
                        foreach (ssln; краткиеИменаСовмБиб) {
                            пСкажиСисАборт("ln -sf " ~ имяСовмБиб ~ " " ~ ssln);
                        }
                    }
                } else {
                    assert(0);
                }

                скажифнс("");
            }
        }
    }

    ткст докбл = "";
    /// A function to prepare for creating докumentation for this постройка
    проц приготовьДоки(ткст постройка, бул док) {
        // prepare for докumentation
        докбл = "";
        if (док) {
            ткст папдок = "dsss_docs" ~ РАЗДПАП ~ постройка;
            сделпапР(папдок);
            докбл ~= "-full -Dq" ~ папдок ~ " -candydoc ";

            // now extract candydoc there
            ткст исхтрп = дайтекпап();
            сменипап(папдок);

            version(Windows) {
                пСкажиИСис("bsdtar -xf " ~ префиксКандиДок);
            } else {
                пСкажиИСис("gunzip -c " ~ префиксКандиДок ~ " | tar -xf -");
            }

            сменипап(исхтрп);
        }
    }

    // 3) Make real libraries and do особый steps and subdirs
    foreach (постройка; стройИсходники) {
        ткст[ткст] настройки = конф.настройки[постройка];

        // basic info
        ткст тип = настройки["type"];
        ткст цель = настройки["target"];

        if (тип == "library" || тип == "sourcelibrary") {
            ткст dotname = замени(постройка, "\\\\", ".");

            // get the список of файлы
            ткст[] файлы = цельКФайлам(постройка, конф);

            // and other necessary data
            ткст бфлаги, отладфлаги, релизфлаги;
            if ("buildflags" in настройки) {
                бфлаги = настройки["buildflags"] ~ " ";
            }
            if ("debugflags" in настройки) {
                отладфлаги = настройки["debugflags"] ~ " ";
            } else {
                отладфлаги = "-debug -gc ";
            }
            if ("releaseflags" in настройки) {
                релизфлаги = настройки["releaseflags"] ~ " ";
            }

            // output what we're building
            скажифнс("%s => %s", постройка, цель);
            if (файлы.length == 0) {
                скажифнс("ВНИМАНИЕ: В разделе %s отсутствуют файлы.", постройка);
                continue;
            }

            // prepare to do докumentation
            приготовьДоки(постройка, делДоки);

            // do the предпостройка
            if ("prebuild" in настройки) {
                шагСценарияДссс(конф, настройки["prebuild"]);
            }

            // get the файл список
            ткст списокФайлов = объедини(цельКФайлам(постройка, конф), " ");

            // if we should, постройка the библиотека
            if ((тип == "library" && бибсБезоп_ли()) ||
                делДоки /* need to постройка the библиотека to get докs */ ||
                тестБибс /* need to постройка the ilbrary to тест it */) {

                if (строитьОтлад)
                    стройБиб("debug-" ~ цель, bl, бфлаги ~ отладфлаги, докбл, списокФайлов, настройки);
                стройБиб(цель, bl, бфлаги ~ релизфлаги, докбл, списокФайлов, настройки);
            }

            // do the постпостройка
            if ("postbuild" in настройки) {
                шагСценарияДссс(конф, настройки["postbuild"]);
            }

            // an extra строка for clarity
            скажифнс("");

        } else if (тип == "special") {
            // особый тип, do pre/post
            скажифнс("%s", цель);
            if ("prebuild" in настройки) {
                шагСценарияДссс(конф, настройки["prebuild"]);
            }

            if ("postbuild" in настройки) {
                шагСценарияДссс(конф, настройки["postbuild"]);
            }
            скажифнс("");

        } else if (тип == "subdir") {
            // recurse
            ткст исхтрп = дайтекпап();
            сменипап(постройка);

            // the one thing that's passed in is постройка flags
            ткст ориг_ребилд = ребилд.dup;
            if ("buildflags" in настройки) {
                ребилд ~= настройки["buildflags"] ~ " ";
            }

            цел резпостроя = dsss.build.строй(null);
            сменипап(исхтрп);

            ребилд = ориг_ребилд;

        }
    }

    // 4) Binaries
    foreach (постройка; стройИсходники) {
        ткст[ткст] настройки = конф.настройки[постройка];

        // basic info
        ткст бфайл = постройка;
        ткст тип = настройки["type"];
        ткст цель = настройки["target"];
        цел бфайлплюс = найди(бфайл, '+');
        if (бфайлплюс != -1) {
            бфайл = бфайл[0..бфайлплюс];
        }

        if (тип == "binary") {
            // our бинарный постройка строка
            ткст бфлаги;
            if ("buildflags" in настройки) {
                бфлаги = настройки["buildflags"];
            }
            if (строитьОтлад) {
                if ("debugflags" in настройки) {
                    бфлаги ~= " " ~ настройки["debugflags"];
                } else {
                    бфлаги ~= " -debug -gc";
                }
            } else {
                if ("releaseflags" in настройки) {
                    бфлаги ~= " " ~ настройки["releaseflags"];
                }
            }

            ткст bbl = bl ~ бфлаги ~ " ";

            // output what we're building
            скажифнс("%s => %s", бфайл, цель);

            // prepare for докumentation
            приготовьДоки(постройка, делДоки && делДокБинари);
            bbl ~= докбл;

            // do the предпостройка
            if ("prebuild" in настройки) {
                шагСценарияДссс(конф, настройки["prebuild"]);
            }

            // постройка a постройка строка
            ткст ext = stdrus.впроп(извлекиРасш(бфайл));
            if (ext == "d") {
                bbl ~= бфайл ~ " -of" ~ цель ~ " ";
            } else if (ext == "brf") {
                bbl ~= "@" ~ дайИмяПути(бфайл) ~ " ";
            } else {
                скажифнс("ОШИБКА: нет сведений о построении файлов с расширением %s", ext);
                return 1;
            }

            // then do it
            пСкажиСисРАборт(bbl, "-rf", цель ~ ".rf", удалитьРФайлы);

            // do the постпостройка
            if ("postbuild" in настройки) {
                шагСценарияДссс(конф, настройки["postbuild"]);
            }

            // an extra строка for clarity
            скажифнс("");

        }
    }

    return 0;
}

/**
 * Helper function to постройка libraries
 *
 * Params:
 *  цель   = цель файл имя (minus platform-specific parts)
 *  bl       = the base постройка строка
 *  бфлаги   = постройка flags
 *  докбл    = постройка flags for докumentation ("" for no докs)
 *  списокФайлов = список of файлы to be compiled into the библиотека
 *  настройки = настройки for this секция откуда ДСССКонф
 */
проц стройБиб(ткст цель, ткст bl, ткст бфлаги, ткст докбл,
                 ткст списокФайлов, ткст[ткст] настройки)
{
                ткст имяСовмБиб = дайИмяСовмБиб(настройки);
                ткст[] краткиеИменаСовмБиб = дайКраткиеИменаСовмБиб(настройки);
                ткст флагСовмБиб = дайФлагСовмБиб(настройки);

                if (цельГНУИлиПосикс()) {
                    // first do a static библиотека
                    if (естьФайл("lib" ~ цель ~ ".a")) удалиФайл("lib" ~ цель ~ ".a");
                    ткст stbl = bl ~ докбл ~ бфлаги ~ " -explicit -lib " ~ списокФайлов ~ " -oflib" ~ цель ~ ".a";
                    if (тестБибс || (поддержкаСовмБиб() && ("shared" in настройки)))
                        stbl ~= " -full";
                    пСкажиСисРАборт(stbl, "-rf", цель ~ "_static.rf", удалитьРФайлы);

                    // perhaps тест the static библиотека
                    if (тестБибс) {
                        скажифнс("Тестируется %s", цель);
                        ткст tbl = bl ~ бфлаги ~ " -unittest -full " ~ списокФайлов ~ " " ~ префиксДсссЛибТест ~ " -oftest_" ~ цель;
                        пСкажиСисРАборт(tbl, "-rf", цель ~ "_test.rf", удалитьРФайлы);
                        пСкажиСисАборт("test_" ~ цель);
                    }

                    if (поддержкаСовмБиб() &&
                        ("shared" in настройки)) {
                        // then make the совместная библиотека
                        if (естьФайл(имяСовмБиб)) удалиФайл(имяСовмБиб);
                        ткст shbl = bl ~ бфлаги ~ " -fPIC -explicit -shlib -full " ~ списокФайлов ~ " -of" ~ имяСовмБиб ~
                        " " ~ флагСовмБиб;

                        // finally, the совместная compile
                        пСкажиСисРАборт(shbl, "-rf", цель ~ "_static.rf", удалитьРФайлы);
                    }

                } else if (целеваяВерсия("Windows")) {
                    // for the moment, only do a static библиотека
                    if (естьФайл(цель ~ ".lib")) удалиФайл(цель ~ ".lib");
                    ткст stbl = bl ~ докбл ~ бфлаги ~ " -explicit -lib " ~ списокФайлов ~ " -of" ~ цель ~ ".lib";
                    if (тестБибс)
                        stbl ~= " -full";
                    пСкажиСисРАборт(stbl, "-rf", цель ~ "_static.rf", удалитьРФайлы);

                    // perhaps тест the static библиотека
                    if (тестБибс) {
                        скажифнс("Тестируется %s", цель);
                        ткст tbl = bl ~ бфлаги ~ " -unittest -full " ~ списокФайлов ~ " " ~ префиксДсссЛибТест ~ " -oftest_" ~ цель ~ ".exe";
                        пСкажиСисРАборт(tbl, "-rf", цель ~ "_test.rf", удалитьРФайлы);
                        пСкажиСисАборт("test_" ~ цель ~ ".exe");
                    }

                } else {
                    assert(0);
                }
}
