/**
 * DSSS configuration stuff
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

module dsss.conf;

import stdrus, cidrus, win;

import dsss.clean;
import dsss.platform;
import dsss.system;

import sys.WinProcess;

import util.booltype;
import util.fdt;
import util.str;

version(Windows) {
    import winapi;
}

alias stdrus.система система;
alias stdrus.найди найди;
alias stdrus.пробел_ли пробел_ли;

extern (C) цел access(char*, цел);
enum праваДоступа : цел {
        F_OK = 0,
        X_OK,
        W_OK,
        R_OK
};

/** The default конфиг файл имя */
const ткст имяКонфФайла = "dsss.conf";

/** The lastbuild конфиг файл имя */
const ткст имяКонфФайлаПП = "dsss.last";

/** The ребилд строка */
ткст ребилд;

/** Options added to ребилд */
ткст дссс_опцииПостройки;

/** Is DSSS списуст, or is it being run out of the исток directory? */
бул вИсхПапке;

/** The префикс to which DSSS was списуст */
ткст префиксУстановки;

/** The provided префикс */
ткст форсПрефикс;

/** The префикс to which other binaries should be списуст */
ткст бинПрефикс;

/** The префикс to which libraries are списуст */
ткст либПрефикс;

/** The префикс to which includes are списуст */
ткст инклюдПрефикс;

/** The префикс to which докumentation is списуст */
ткст докПрефикс;

/** The префикс to which manifests are списуст */
ткст префиксМанифеста;

/** The префикс to which configuration файлы are списуст */
ткст этцетераПрефикс;

/** The префикс to which the исток список is downloaded */
ткст префиксСпискаИсх;

/** The location of candydoc.tar.gz */
ткст префиксКандиДок;

/** The location of dsss_lib_test.d */
ткст префиксДсссЛибТест;

/** Are we doing докumentation? */
бул делДоки = нет;

/** Are we doing докumentation for binaries? */
бул делДокБинари = нет;

/** Should we delete response файлы? */
бул удалитьРФайлы = да;

/** Should we generate тест binaries? */
бул тестБибс = нет;

/** Should we постройка отладка версии? */
бул строитьОтлад = нет;

/** Should we be verbose? */
бул подробнРежим = нет;

/** The префикс for scratch work */
ткст черновойПрефикс;

/** The location of stub.d (used to make stub D libraries) */
ткст стабДРасп;

/** The location of dsssdll.d (used to make DLLs откуда any библиотека) */
ткст дсссДллРасп;

/** Usedirs (dirs to import both includes and libs откуда */
ткст[] использПапки;

/** Tested версии (for the цель) */
бул[ткст] версии;

/* It's often useful to know whether we're using GNU and/or Posix, as GNU on
 * Windows tends to do some things Posixly. */
version(build) {
    version(GNU) {
        pragma(export_version, "GNU_or_Posix");
    } else version(Posix) {
        pragma(export_version, "GNU_or_Posix");
    }
}

/** Set prefixes automatically, given argv[0] */
проц дайПрефикс(ткст argvz)
{
    ткст bname;
	префиксУстановки=дайПеремСреды("DINRUS");
	if(префиксУстановки != ""){}
    else if (!гдеЯ(argvz, префиксУстановки, bname)) {
        скажифнс("Не удалось выявить префикс установки DSSS.");
        выход(1);
    }

    префиксУстановки = канонПуть(префиксУстановки);

    // get some default usedirs
    использПапки ~= канонПуть(префиксУстановки ~ РАЗДПАП ~ "..");
    version(Posix) {
        ткст дом = дайПеремСреды("HOME");
        if (дом != "") {
            использПапки ~= канонПуть(дом ~ РАЗДПАП ~ "d");
        }
		}
	    else version(Windows) {
        ткст дом = дайПеремСреды("DINRUS");
        if (дом != "") {
            использПапки ~= канонПуть(дом ~ РАЗДПАП ~".."~ РАЗДПАП ~"imp"~ РАЗДПАП ~"dinrus"~ РАЗДПАП ~"dsss");
        }
		/*debug*/ скажинс("Дом="~дом);
    }

    // set the префикс to actually инсталлируй things to

    // using this directory, найди включить and библиотека directories
    if (естьФайл(префиксУстановки ~ РАЗДПАП ~".." ~ РАЗДПАП ~"imp"~ РАЗДПАП ~"dinrus"~ РАЗДПАП ~"dsss" ~ РАЗДПАП ~ "main.d")) {
        // this is probably the постройка префикс
        вИсхПапке = да;
        /*debug*/ скажинс("форсПрефикс ="~форсПрефикс);
        if (форсПрефикс == "") {
            форсПрефикс = префиксУстановки;
        } else {
            форсПрефикс = канонПуть(форсПрефикс);
        }
       /*debug*/ скажинс("форсПрефикс="~форсПрефикс);
        ткст сссБазовоеРасп = префиксУстановки ~ РАЗДПАП ~".." ~ РАЗДПАП ~ "imp"~ РАЗДПАП ~"dinrus"~ РАЗДПАП ~"dsss";
        стабДРасп = сссБазовоеРасп ~ "stub.d";
        дсссДллРасп = сссБазовоеРасп ~ "dssdll.d";
        /*debug*/ скажинс("сссБазовоеРасп ="~сссБазовоеРасп);
        // get rebuild environment variable
        version(Posix) {
            ребилд = префиксУстановки ~
                РАЗДПАП ~ "rebuild" ~
                РАЗДПАП ~ "rebuild";
        } else version(Windows) {
            ребилд = префиксУстановки ~
                РАЗДПАП ~ "rebuild.exe";
        }

        /*debug*/ скажинс("ребилд ="~ребилд);

        устПеремСреды("DSSS_BUILD", ребилд);

        if (!префиксКандиДок.length)
            префиксКандиДок = канонПуть(
                префиксУстановки ~ РАЗДПАП ~".." ~ РАЗДПАП ~ "imp"~ РАЗДПАП ~"dinrus"~ РАЗДПАП ~"dsss" ~ РАЗДПАП~"dsss"~ РАЗДПАП~"candydoc.tar.gz");
        if (!префиксДсссЛибТест.length)
            префиксДсссЛибТест = канонПуть(
                префиксУстановки ~ РАЗДПАП ~".." ~ РАЗДПАП ~ "imp"~ РАЗДПАП ~"dinrus"~ РАЗДПАП ~"dsss" ~ РАЗДПАП~"dsss_lib_test.d");
    } else {
        вИсхПапке = нет;

        // slightly more complicated for a real инсталлируй
        if (форсПрефикс == "") {
            форсПрефикс = извлекиПапку(префиксУстановки);

            // if this is inaccessible, we need to make a better decision
            version(Posix) {
                if (access((форсПрефикс ~ '\0').ptr, праваДоступа.W_OK) != 0) {
                    // choose $HOME/d
                    if (дом != "") {
                        ткст новыйПрефикс = канонПуть(дом ~ "/d");
                        скажифнс("Дефолтный префикс %s незаписываемый, используется %s вместо него.",
                                 форсПрефикс, новыйПрефикс);
                        форсПрефикс = новыйПрефикс;
                    }
                }
            }

        } else {
            форсПрефикс = канонПуть(форсПрефикс);
        }

        ткст сссБазовоеРасп = форсПрефикс ~ РАЗДПАП ~
            "imp" ~ РАЗДПАП ~
            "dinrus" ~ РАЗДПАП ~
            "dsss" ~ РАЗДПАП;
        стабДРасп = сссБазовоеРасп ~ "stub.d";
        дсссДллРасп = сссБазовоеРасп ~ "dsssdll.d";

        // set постройка environment variable
        version(Posix) {
            ребилд = префиксУстановки ~
                 РАЗДПАП ~ "rebuild";
        } else version(Windows) {
            ребилд = префиксУстановки ~
                РАЗДПАП ~ "rebuild.exe";
        }

        // if we don't have rebuild next to us, try to исп it without a путь
        if (!естьФайл(ребилд)) {
            version(Posix) {
                ребилд = "rebuild";
            } else version(Windows) {
                ребилд = "rebuild.exe";
			}
		}

        устПеремСреды("DSSS_BUILD", ребилд);

        if (!префиксКандиДок.length)
            префиксКандиДок = канонПуть(
                префиксУстановки ~ РАЗДПАП ~
                ".." ~ РАЗДПАП ~
                "imp" ~ РАЗДПАП ~"dinrus"~ РАЗДПАП ~"dsss"~ РАЗДПАП ~
                "dsss" ~ РАЗДПАП ~
                "candydoc.tar.gz");
				/*debug*/ скажинс("префиксКандиДок ="~префиксКандиДок);

        if (!префиксДсссЛибТест.length)
            префиксДсссЛибТест = канонПуть(
                префиксУстановки ~ РАЗДПАП ~
                ".." ~ РАЗДПАП ~
                "imp" ~ РАЗДПАП ~"dinrus"~ РАЗДПАП ~"dsss"~ РАЗДПАП ~
                "dsss_lib_test.d");
		 /*debug*/ скажинс("префиксДсссЛибТест ="~префиксДсссЛибТест);
    }

    if (!бинПрефикс.length)
        бинПрефикс = форсПрефикс;//  ~ РАЗДПАП ~".."~ РАЗДПАП ~ "bin";
		/*debug*/ скажинс("бинПрефикс ="~бинПрефикс);

    if (!либПрефикс.length)
        либПрефикс = форсПрефикс  ~ РАЗДПАП ~".."~ РАЗДПАП ~ "lib";
			/*debug*/ скажинс("либПрефикс ="~либПрефикс);
    if (!инклюдПрефикс.length)
        инклюдПрефикс = форсПрефикс ~ РАЗДПАП ~".."~ РАЗДПАП ~
                "imp" ~ РАЗДПАП ~"dinrus";
					/*debug*/ скажинс("инклюдПрефикс ="~инклюдПрефикс);

    if (!докПрефикс.length)
        докПрефикс = форсПрефикс ~ РАЗДПАП ~".."~ РАЗДПАП ~
                "imp" ~ РАЗДПАП ~"dinrus"
				~ РАЗДПАП ~"dsss"~ РАЗДПАП ~
            "doc";
				/*debug*/ скажинс("докПрефикс ="~докПрефикс);

    if (!префиксМанифеста.length)
        префиксМанифеста = форсПрефикс~ РАЗДПАП ~".." ~ РАЗДПАП ~"imp"
				~ РАЗДПАП ~"dsss"~ РАЗДПАП ~ "dsss"
				~ РАЗДПАП ~ "manifest";
				/*debug*/ скажинс("префиксМанифеста ="~префиксМанифеста);

    if (!этцетераПрефикс.length) {
        if (форсПрефикс == "/usr") {
            // in the case of /usr, исп /etc instead of /usr/etc
            этцетераПрефикс = "/etc";
        } else {
            этцетераПрефикс = форсПрефикс ~ РАЗДПАП ~".."~ РАЗДПАП ~"etc";
        }
		/*debug*/ скажинс("этцетераПрефикс ="~этцетераПрефикс);
    }
    if (!префиксСпискаИсх.length)
        префиксСпискаИсх = канонПуть(
            форсПрефикс ~ РАЗДПАП ~".."~ РАЗДПАП ~
                "imp" ~ РАЗДПАП ~"dinrus"
				~ РАЗДПАП ~"dsss"~ РАЗДПАП ~ "dsss"
				~ РАЗДПАП ~ "sources");

    // set the scratch префикс and some some environment variables
    version(Posix) {
        черновойПрефикс = "/tmp";

        устПеремСреды("DSSS", префиксУстановки ~ РАЗДПАП ~ bname);
        устПеремСреды("PREFIX", форсПрефикс);
        устПеремСреды("BIN_PREFIX", бинПрефикс);
        устПеремСреды("LIB_PREFIX", либПрефикс);
        устПеремСреды("INCLUDE_PREFIX", инклюдПрефикс);
        устПеремСреды("DOC_PREFIX", докПрефикс);
        устПеремСреды("ETC_PREFIX", этцетераПрефикс);
        устПеремСреды("EXE_EXT", "");

        // make sure components run with libraries, etc
        устПеремСреды("PATH", бинПрефикс ~ ":" ~ дайПеремСреды("PATH"));
        ткст ldlibp = дайПеремСреды("LD_LIBRARY_PATH");
        if (ldlibp == "") {
            ldlibp = либПрефикс;
        } else {
            ldlibp = либПрефикс ~ ":" ~ ldlibp;
        }
        устПеремСреды("LD_LIBRARY_PATH", ldlibp);
    } else version(Windows) {
        черновойПрефикс = канонПуть(префиксУстановки ~ РАЗДПАП ~
                                  ".." ~ РАЗДПАП ~
                                  "tmp");

        устПеремСреды("DSSS", префиксУстановки ~ РАЗДПАП ~ bname);
        устПеремСреды("PREFIX", форсПрефикс);
        устПеремСреды("BIN_PREFIX", бинПрефикс);
        устПеремСреды("LIB_PREFIX", либПрефикс);
        устПеремСреды("INCLUDE_PREFIX", инклюдПрефикс);
        устПеремСреды("DOC_PREFIX", докПрефикс);
        устПеремСреды("ETC_PREFIX", этцетераПрефикс);
        устПеремСреды("EXE_EXT", ".exe");

        // путь for both bin and lib
        устПеремСреды("PATH", бинПрефикс ~ ";" ~ либПрефикс ~ ";" ~ дайПеремСреды("PATH"));
    }

    ребилд ~= " " ~ дссс_опцииПостройки ~
        " -Idsss_imports" ~ РАЗДПАП ~
        " -I. -S." ~ РАЗДПАП ~
        " -I" ~ инклюдПрефикс ~ " -S" ~ либПрефикс ~ РАЗДПАП ~ " ";
}

/** DSSS configuration information - simply a список of секции, then an array
 * of настройки for those секции */
class ДСССКонф {
    /// Configurable секции
    ткст[] секции;

    /// Settings per секция
    char[][char[]][char[]] настройки;
}

/** Generate a ДСССКонф откуда dsss.конф, or generate a dsss.конф откуда стройЭлты */
ДСССКонф читайКонфиг(ткст[] стройЭлты, бул генконф = нет, ткст configF = имяКонфФайла)
{
    /* конфиг файл format: every строка is precisely one секция, настройка, block
     * opener or block closer. The only действительно block opener is 'версия' */

    /** A function to tokenize a single конфиг файл строка */
    ткст[] tokLine(ткст строка)
    {
        /** All токены читай thusfar */
        ткст[] токены;

        /** Current token */
        ткст ток;

        /** Add the current token */
        проц addToken()
        {
            if (ток != "") {
                токены ~= ток;
                ток = "";
            }
        }

        for (цел i = 0; i < строка.length; i++) {
            if (stdrus.числобукв_ли(строка[i]) ||
                строка[i] == '_') {
                ток ~= строка[i..i+1];
            } else if (stdrus.пробел_ли(строка[i])) {
                addToken();
            } else if (строка[i] == '=' ||
                       строка[i] == ':') {
                // the rest is all one token
                addToken();
                ток ~= строка[i];
                addToken();

                ток ~= строка[(i + 1) .. $];

                // trim whitespace of the настройка
                while (ток.length && пробел_ли(ток[0])) ток = ток[1..$];
                while (ток.length && пробел_ли(ток[$-1])) ток = ток[0..($-1)];

                if (ток.length) addToken();
                break;
            } else {
                addToken();
                ток ~= строка[i..i+1];
                addToken();
            }
        }
        addToken();

        return токены;
    }

    /// The actual configuration store
    ДСССКонф конф = new ДСССКонф();

    /// The data откуда the конфиг файл
    ткст файлКонф;

    if (естьФайл(имяКонфФайла)) {
        if (генконф) {
            // this makes no sense
            скажифнс("Поскольку файл конфигурации уже существует, он не будет сгенерирован.");
            выход(1);
        }

        // before reading the конфиг, дистчистка if it's changed
        if (configF == имяКонфФайла) {
            if (естьФайл(имяКонфФайлаПП)) {
                if (файлНовееЧем(имяКонфФайла, имяКонфФайлаПП)) {
                    // our конфиг has changed
                    дистчистка(читайКонфиг(null, нет, имяКонфФайлаПП));
                }
            }

            // copy in our new dsss.lastbuild
            копируйФайл(имяКонфФайла, имяКонфФайлаПП);
        }

        // Read the конфиг файл
        файлКонф = cast(char[]) читайФайл(имяКонфФайла);
    } else {
        if (!генконф && стройЭлты.length == 0) {
            // this makes no sense
            скажифнс("Файл конфигурации не найден, цели явно не заданы.");
            выход(1);
        }

        // Generate the конфиг файл
        if (стройЭлты.length == 0) {
            // откуда nothing - just make every directory into a библиотека
            ткст[] dires = списпап(".");
            foreach (dire; dires) {
                if (папка_ли(dire) &&
                    dire[0] != '.') {
                    файлКонф ~= "[" ~ dire ~ "]\n";
                }
            }

        } else {
            // откуда a список
            foreach (постройка; стройЭлты) {
                if (!естьФайл(постройка)) {
                    скажифнс("Файл %s не найден!", постройка);
                } else {
                    файлКонф ~= "[" ~ постройка ~ "]\n";
                }
            }
        }

        if (генконф) {
            // write it
            пишиФайл(имяКонфФайла, файлКонф);
        }

    }


    // Normalize it
    файлКонф = замени(файлКонф, "\r", "");

    // Split it by строки
    ткст[] строки = разбейдоп(файлКонф, "\n");

    /// Current секция
    ткст секция;

    // set up the defaults for the top-level секция
    конф.настройки[""] = null;
    конф.настройки[""]["name"] = извлекиИмяПути(дайтекпап());
    конф.настройки[""]["version"] = "last";

    // parse строка-by-строка
    for (цел i = 0; i < строки.length; i++) {
        ткст строка = строки[i];

        /** A function to закрой the current scope */
        проц закройМасштаб(бул ignoreElse = нет)
        {
            цел глубина = 1;
            for (i++; i < строки.length; i++) {
                ткст[] члотокенов = tokLine(строки[i]);
                if (члотокенов.length == 0) continue;

                // possibly change the глубина
                if (члотокенов[0] == "}") {
                    // check for else
                    if (члотокенов.length >= 3 &&
                        члотокенов[1] == "else") {
                        if (!ignoreElse) {
                            // rewrite this строка for later parsing
                            строки[i] = объедини(члотокенов[2 .. $], " ");
                            глубина--;
                            i--;
                        } else if (члотокенов[$ - 1] != "{") {
                            // drop the глубина even though we won't reparse it
                            глубина--;
                        }

                    } else {
                        глубина--;
                    }

                    if (глубина == 0) {
                        return; // done! :)
                    }
                } else if (члотокенов[$ - 1] == "{") {
                    глубина++;
                }
            }
            // didn't закрой!
            скажифнс("Ошибка конфигурации DSSS: незакрытый масштаб.");
            выход(1);
        }

        // combine строки
        while (i < строки.length - 1 &&
               строка.length &&
               строка[$ - 1] == '\\') {
            i++;
            строка = строка[0 .. ($ - 1)] ~ строки[i];
        }

        // then parse it
        ткст[] токены = tokLine(строка);
        if (токены.length == 0) continue;

        // then do something with it
        if (токены[0] == "[" &&
            токены[$ - 1] == "]") {
            // a секция header
            ткст путь = объедини(токены[1 .. ($ - 1)], "");
            // allow \'s for badly-written конф файлы
            путь = замени(путь, "\\\\", "/");

            секция = канонПуть(путь);
            конф.настройки[секция] = null;

            // need to have some default настройки: цель and тип
            if (секция == "*") {
                // "global" секция, no цель/тип
            } else if (секция == "") {
                // top-level секция
            } else if (секция.length > 0 &&
                       секция[0] == '+') {
                // особый секция
                конф.секции ~= секция;
                конф.настройки[секция]["type"] = "special";
                конф.настройки[секция]["target"] = секция[1..$];

            } else if (найди(секция, '+') != -1) {
                цел ploc = найди(секция, '+'); // FIXME
                // auxiliary секция
                конф.секции ~= секция;
                конф.настройки[секция]["type"] = "binary";
                конф.настройки[секция]["target"] = секция[1..$];

            } else if (!естьФайл(секция)) {
                скажифнс("ВНИМАНИЕ: Раздел для несуществующего файла %s.", секция);
            } else {
                конф.секции ~= секция;

                if (папка_ли(секция)) {
                    конф.настройки[секция]["type"] = "library";

                    // цель according to the библиотека naming convention
                    ткст пкт = замени(канонПуть(секция),
                                                    "\\\\", "/");

                    // имя it
                    конф.настройки[секция]["target"] =
                        имяБиблиотеки(секция);

                } else {
                    конф.настройки[секция]["type"] = "binary";
                    конф.настройки[секция]["target"] = дайИмяПути(секция);
                }
            }

            // FIXME: guarantee that секции aren't repeated

        } else if (токены.length == 3 &&
                   токены[1] == "=") {
            // a настройка
            конф.настройки[секция][stdrus.впроп(токены[0])] = раскройПерСреды(токены[2]);

        } else if (токены.length == 1 &&
                   stdrus.числобукв_ли(токены[0][0])) {
            // a настройка with no value
            конф.настройки[секция][stdrus.впроп(токены[0])] = "";

        } else if (токены.length == 4 &&
                   токены[1] == "+" &&
                   токены[2] == "=") {
            // append to a настройка
            ткст настройка = stdrus.впроп(токены[0]);
            if (настройка in конф.настройки[секция]) {
                конф.настройки[секция][настройка] ~= " " ~ раскройПерСреды(токены[3]);
            } else {
                конф.настройки[секция][настройка] = раскройПерСреды(токены[3]);
            }

        } else if (токены[0] == "version") {
            /* a версия statement, must be of one form:
             *  * версия(версия) {
             *  * версия(!версия) {
             */

            if ((токены.length != 5 ||
                 токены[1] != "(" ||
                 токены[3] != ")" ||
                 токены[4] != "{") &&
                (токены.length != 6 ||
                 токены[1] != "(" ||
                 токены[2] != "!" ||
                 токены[4] != ")" ||
                 токены[5] != "{")) {
                ошибка("Ошибка конфигурации DSSS: неверная строка версии.");
                выход(1);
            }

            // whether the comparison is действительно
            бул действительно = нет;
            ткст верток;
            if (токены[2] == "!") {
                // assume действительно
                действительно = да;
                верток = токены[3];
            } else {
                верток = токены[2];
            }

            проверьВерсию(верток);

            // now choose our путь
            if (версии[верток]) действительно = !действительно;
            if (!действительно) {
                // нет, найди the end to this block
                закройМасштаб();
            }

        } else if ((токены.length == 1 &&
                    (токены[0] == "}" ||
                     токены[0] == "{")) ||
                   токены[0] == "#") {
            // this is ignored, just a scope we're in or a comment

        } else if (токены.length > 2 &&
                   токены[0] == "}" &&
                   токены[1] == "else") {
            // skip this else case
            закройМасштаб(да);

        } else {
            ошибка(фм("Ошибка конфигурации DSSS:\n нераспознанная строка '%s'.", строки[i]));
            выход(1);

        }
    }

    // now apply global настройки to every other настройка
    if ("*" in конф.настройки) {
        ткст[ткст] гнастройки = конф.настройки["*"];
        конф.настройки.remove("*");

        // for each секция ...
        foreach (ключ, настройки; конф.настройки) {
            // for each global настройка ...
            foreach (skey, sval; гнастройки) {
                // if it's not overridden ...
                if (!(skey in настройки)) {
                    // then set it
                    настройки[skey] = sval;
                }
            }
        }
    }

    return конф;
}

/** Test if a версия is set in the цель (put into версии array) */
проц проверьВерсию(ткст верток)
{
    if (!(верток in версии)) {
        /* now check if this версия is defined by making a .d файл and
         * building it */
        цел возвр = система(ребилд ~ "-testversion=" ~ верток);

        if (возвр == 0) {
            // да версия
            версии[верток] = да;
        } else {
            версии[верток] = нет;
        }
    }
}

/** Check a цель версия */
бул целеваяВерсия(ткст верток)
{
    проверьВерсию(верток);
    return версии[верток];
}

/** If the цель matches GNU OR Posix, this returns да */
бул цельГНУИлиПосикс()
{
    проверьВерсию("GNU");
    проверьВерсию("Posix");
    return (версии["GNU"] || версии["Posix"]);
}

/** Получить список фалов из цели */
ткст[] цельКФайлам(ткст цель, ДСССКонф конф, бул includeDi = нет)
in {
    assert(цель in конф.настройки);
}
body {
    ткст[ткст] настройки = конф.настройки[цель];
    ткст[] файлы;

    // 1) get the exclusion список
    ткст[] исключить;
    if ("exclude" in настройки) {
        исключить = разбей(настройки["exclude"]);

        // canonicalize and un-Windows-ize the paths
        for (цел i = 0; i < исключить.length; i++) {
            исключить[i] = замени(канонПуть(исключить[i]),
                                            "\\\\", "/");
        }
    }
    бул исключено(ткст путь)
    {
        for (цел i = 0; i < исключить.length; i++) {
            if (сравниПутьОбразец(замени(путь, "\\\\", "/"), исключить[i])) {
                return да;
            }
        }
        return нет;
    }

    // and inclusion список
    ткст[] включить;
    if ("include" in настройки) {
        // get the dependencies
        файлы = разбей(настройки["include"]);
        ткст[] rawFiles;
        сисРеспонс(ребилд ~ "-files -offiles.tmp " ~ настройки["include"],
                       "-rf", "temp.rf", да);
        rawFiles = разбей(cast(char[]) читайФайл("files.tmp"));
        foreach (f; rawFiles) {
            while (f.length &&
                   (f[$-1] == '\r' ||
                    f[$-1] == '\n')) {
                f = f[0..$-1];
            }
            if (f.length && f[$-1] != 'i' && f[$-1] != 'I') {
                // the файл естьФайл and is not a .di файл, so it's part of this постройка
                файлы ~= f;
            }
        }
        пробуйУдалить("files.tmp");

        // done!
        return файлы;
    }

    // 2) stomp through the directory добавляется файлы
    проц добавьПап(ткст ndir, бул force = нет)
    {
        // make sure it's not исключено for any reason
        if (!force &&
            (ndir in конф.настройки || // a separate цель
             исключено(канонПуть(ndir)))) {
            return;
        }

        // not исключено, get the список of файлы
        ткст[] dirFiles = списпап(ndir);
        foreach (файл; dirFiles) {
            if (!файл.length) continue; // shouldn't happen

            // ignore dotfiles (mainly to ignore . and ..)
            if (файл[0] == '.') continue;

            // make this the full путь
            файл = ndir ~ РАЗДПАП ~ файл;

            // get the extension
            ткст ext = stdrus.впроп(извлекиРасш(файл)).dup;

            if (папка_ли(файл)) {
                // perhaps recurse
                добавьПап(файл);

            } else if (ext == "d") {
                // or just add it
                if (!исключено(канонПуть(файл))) {
                    файлы ~= файл;
                }

            } else if (ext == "di") {
                // only add .di файлы if we should
                if (includeDi && !исключено(канонПуть(файл))) {
                    файлы ~= файл;
                }
            }
        }
    }

    if (папка_ли(цель)) {
        добавьПап(цель, да);
    } else {
        файлы ~= цель;
    }

    return файлы;
}

/** Исключение to be thrown when a scripted шаг fails */
class ХукИскл : Исключение {
    this(ткст smsg)
    {
        super(smsg);
    }
}

/** Perform a pre- or post- script шаг. Returns a список of списуст файлы (if
 * applicable) */
ткст[] шагСценарияДссс(ДСССКонф конф, ткст шаг)
{
    // список of списуст файлы
    ткст[] манифест;

    // since parts of the script can potentially change the directory, store it
    ткст исхтрп = дайтекпап();

    // разбей the steps by ;
    ткст[] кмнды = разбей(шаг, ";");

    foreach (кмнд; кмнды) {
        // очисть кмнд
        while (кмнд.length > 0 && пробел_ли(кмнд[0])) кмнд = кмнд[1..$];
        while (кмнд.length > 0 && пробел_ли(кмнд[$-1])) кмнд = кмнд[0..($-1)];
        if (подробнРежим) скажифнс("Команда: %s", кмнд);

        // run it
        ткст ext = stdrus.впроп(извлекиРасш(кмнд));
        if (найди(кмнд, ' ') == -1 && ext == "d") {
            // if it's a .d файл, -exec it
            пСкажиСисАборт(ребилд ~ "-full -exec " ~ кмнд);

        } else if (кмнд.length > 5 &&
                   кмнд[0..5] == "warn ") {
            скажифнс("ВНИМАНИЕ: %s", кмнд[5..$]);

        } else if (кмнд.length > 6 &&
                   кмнд[0..6] == "error ") {
            скажифнс("ОШИБКА: %s", кмнд[6..$]);
            throw new ХукИскл("хук столкнулся с ошибкой.");

        } else if (кмнд.length > 8 &&
                   кмнд[0..8] == "инсталлируй ") {
            // doing an инсталлируй
            ткст[] comps = разбей(кмнд);
            if (comps.length != 3) continue; // FIXME: not действительно

            // do this инсталлируй
            // check for / or \
            цел slloc = найдрек(comps[1], '/');
            if (slloc == -1)
                slloc = найдрек(comps[1], '\\');

            // убери off the префикс откуда our манифест путь
            ткст путьКМанифесту = comps[2] ~ РАЗДПАП;
            if (путьКМанифесту.length > форсПрефикс.length &&
                путьКМанифесту[0 .. форсПрефикс.length] == форсПрефикс)
                путьКМанифесту = путьКМанифесту[форсПрефикс.length + 1 .. $];

            if (slloc != -1) {
                // путь provided
                ткст f = comps[1][(slloc + 1) .. $];
                копируйВхФайл(f,
                           comps[2],
                           comps[1][0 .. (slloc + 1)]);
                манифест ~= (путьКМанифесту ~ f);
            } else {
                копируйВхФайл(comps[1], comps[2]);
                манифест ~= (путьКМанифесту ~ comps[1]);
            }

        } else if (кмнд.length > 11 &&
                   кмнд[0..11] == "installdir ") {
            // crawl for файлы, installing each
            ткст[] comps = разбей(кмнд);
            if (comps.length != 3) continue; // FIXME: not действительно

            /// инсталлируй the файлы in this directory
            проц устВПап(ткст ndir, ткст ipostfix = "") {
                ткст[] dirFiles = списпап(ndir);
                foreach (файл; dirFiles) {
                    // either recurse,
                    if (папка_ли(ndir ~ РАЗДПАП ~ файл)) {
                        устВПап(ndir ~ РАЗДПАП ~ файл, ipostfix ~ РАЗДПАП ~ файл);

                    } else {
                        // or инсталлируй this файл
                        манифест ~= шагСценарияДссс(конф, "install " ~
                            ndir ~ РАЗДПАП ~ файл ~ " " ~
                            comps[2] ~ ipostfix);

                    }
                }
            }

            // start with the base
            устВПап(comps[1]);

        } else if (кмнд.length > 3 &&
                   кмнд[0..3] == "cd ") {
            // change directories
            ткст[] comps = разбей(кмнд);
            if (comps.length != 2) continue; // FIXME: not действительно

            // change our directory
            сменипап(comps[1]);

        } else if (кмнд.length > 5 &&
                   кмнд[0..5] == "eval ") {
            // run the команда, execute its output
            ППоток proc;

            кмнд = кмнд[5..$];
            if (stdrus.впроп(извлекиРасш(кмнд)) == "d") {
                proc = new ППоток(ребилд ~ "-full -exec " ~ кмнд);
            } else {
                proc = new ППоток(кмнд);
            }

            // now catch its output
            ткст readbuf;
            char readc;
            while (да) {
                try {
                    proc.читай(readc);
                } catch (Exception e) {
                    break;
                }
                readbuf ~= readc;
            }

            // and run it
            манифест ~= шагСценарияДссс(конф, readbuf);

            proc.закрой();

        } else if (кмнд.length > 4 &&
                   (кмнд[0..4] == "set " ||
                    кмнд[0..4] == "add ")) {
            цел i;

            бул добавляется = (кмнд[0..4] == "add ");

            // set <секция>.<настройка> <value>
            кмнд = кмнд[4..$];

            // 1) get the <секция>:<настройка>
            ткст sset = кмнд.dup;
            for (i = 0; i < кмнд.length; i++) {
                if (кмнд[i] == ' ') {
                    sset = sset[0 .. i];
                    кмнд = кмнд[i+1 .. $];
                    i = 0;
                    break;
                }
            }

            if (i == кмнд.length) кмнд = "";

            // 2) divide <секция>:<настройка>
            ткст секция, настройка;
            цел dotloc = найди(sset, ':');
            if (dotloc == -1) {
                секция = "";
                настройка = sset;
            } else {
                секция = sset[0..dotloc].dup;
                настройка = sset[dotloc+1 .. $].dup;
            }

            // 3) perhaps get a список of секции
            ткст[] испСекции;
            if (секция == "*") {
                испСекции = конф.секции;
            } else {
                испСекции ~= секция;
            }

            // 4) set
            foreach (секц; испСекции) {
                if (секц in конф.настройки) {
                    // perhaps add
                    if (добавляется) {
                        if (настройка in конф.настройки[секц]) {
                            кмнд = конф.настройки[секц][настройка] ~ " " ~ кмнд;
                        }
                    }
                    конф.настройки[секц][настройка] = кмнд.dup;
                }
            }

        } else {
            // hopefully we can just run it
            пСкажиСисАборт(кмнд);
        }
    }

    сменипап(исхтрп);

    return манифест;
}

/** Get sources откуда a список of elements (sources or targets) */
ткст[] исходникиПоЭлтам(ткст[] стройЭлты, ДСССКонф конф)
{
    ткст[] стройИсходники;

    if (стройЭлты.length == 0 && "deftargets" in конф.настройки[""]) {
        стройЭлты = разбей(конф.настройки[""]["deftargets"], " ");
    }

    if (стройЭлты.length) {
        if (стройЭлты.length == 1 && стройЭлты[0] == "all") {
            стройИсходники = конф.секции;

        } else {
            // now select the builds that have been requested
            foreach (be; стройЭлты) {
                // on Windows, make sure the имя is sensible
                version(Windows) {
                    be = замени(be, "\\\\", "/");
                }

                // поиск for a секция or цель with this имя
                бул found = нет;

                foreach (секция; конф.секции) {
                    if (сравниПутьОбразец(замени(секция, "\\\\", "/"), be)) {
                        // постройка this
                        стройИсходники ~= секция;
                        found = да;
                        continue;
                    }

                    // not the секция имя, so try "цель"
                    if (сравниПутьОбразец(замени(конф.настройки[секция]["target"], "\\\\", "/"), be)) {

                        // постройка this (by секция имя)
                        стройИсходники ~= секция;
                        found = да;
                    }
                }

                if (!found) {
                    // didn't match anything!
                    ошибка(фм("%s не имеет описания в файле конфигурации.", be));
                    выход(1);
                }
            }

        }
    } else {
        // no builds selected, постройка them all
        стройИсходники = конф.секции;
    }

    return стройИсходники;
}

/** Get the соверсия откуда a configuration */
ткст дайСоверсию(ткст[ткст] настройки)
{
    // get the соверсия
    if ("soversion" in настройки) {
        return настройки["soversion"];
    } else {
        return "0.0.0";
    }
}

/** Get a full совместная библиотека файл имя откуда configuration */
ткст дайИмяСовмБиб(ткст[ткст] настройки)
{
    ткст цель = настройки["target"];

    if (целеваяВерсия("Posix")) {
        // lib<цель>.so.<соверсия>
        return "lib" ~ цель ~ ".so." ~ дайСоверсию(настройки);
    } else if (целеваяВерсия("Windows")) {
        // <цель>.dll
        return цель ~ ".dll";
    } else {
        assert(0);
    }
}

/** Get a short совместная библиотека файл names */
ткст[] дайКраткиеИменаСовмБиб(ткст[ткст] настройки)
{
    ткст цель = настройки["target"];

    if (целеваяВерсия("Posix")) {
        // lib<цель>.so.<first part of соверсия>
        ткст соверсия = дайСоверсию(настройки);
        ткст[] рез;
        цел dotloc;

        // cut off each dot one-by-one
        while ((dotloc = найдрек(соверсия, '.')) != -1) {
            соверсия = соверсия[0..dotloc];
            рез ~= ("lib" ~ цель ~ ".so." ~ соверсия);
        }
        рез ~= "lib" ~ цель ~ ".so";

        return рез;
    } else {
        // no short версия
        return null;
    }
}

/** Get a necessary flag while building совместная libraries */
ткст дайФлагСовмБиб(ткст[ткст] настройки)
{
    version(Posix) {
        // need a soname
        ткст[] краткиеИменаСовмБиб = дайКраткиеИменаСовмБиб(настройки);
        ткст sonver;
        if (краткиеИменаСовмБиб.length >= 2) {
            sonver = краткиеИменаСовмБиб[1];
        } else {
            sonver = дайИмяСовмБиб(настройки);
        }
        return "-L-soname=" ~ sonver;
    }
    return "";
}

/** Return да or нет for whether libraries are безопасно  */
бул бибсБезоп_ли()
{
    static бул проверено = нет;
    static бул безопасно = нет;

    if (!проверено) {
        цел возвр = система(ребилд ~ "-libs-safe");
        безопасно = (возвр == 0);
        проверено = да;
    }

    return безопасно;
}

/** Return да or нет for whether совместная libraries are supported */
бул поддержкаСовмБиб()
{
    static бул проверено = нет;
    static бул supported = нет;

    if (!проверено) {
        // ask ребилд
        цел возвр = система(ребилд ~ "-shlib-support");

        supported = (возвр == 0);

        проверено = да;
    }

    return supported;
}

/** Is файл a newer than файл b? */
бул файлНовееЧем(ткст a, ткст b)
{
    ФайлДатаВремя fdta = new ФайлДатаВремя(a);
    ФайлДатаВремя fdtb = new ФайлДатаВремя(b);
    return (fdta > fdtb);
}

/** Copy a файл into a directory */
проц копируйВхФайл(ткст файл, ткст префикс, ткст откуда = "")
{
    if (!естьФайл(префикс)) {
        скажифнс("+ создаётся папка %s", префикс);
        сделпапР(префикс);
    }

    скажифнс("+ копируется %s", файл);
    version(Posix) {
        ткст цель = префикс ~ РАЗДПАП ~ файл;

        // preserve permissions
        пСкажиСисАборт("cp -fpRL " ~ откуда ~ файл ~ " " ~ цель);

        // but then guarantee the permissions we made aren't too bad (ignore errors)
        система("chmod a+rX " ~ цель ~ " 2> /dev/null");

    } else {
        копируйФайл(откуда ~ файл, префикс ~ РАЗДПАП ~ файл);
    }
}

/** раскрой environment variables in the provided string */
ткст раскройПерСреды(ткст откуда)
{
    ткст возвр = откуда ~ "";

    // now expand
    for (цел i = 0; i < возвр.length; i++) {
        if (возвр[i] == '$') {
            // найди the end
            цел j;
            for (j = i + 1; j < возвр.length &&
                 (stdrus.числобукв_ли(возвр[j]) || возвр[j] == '_');
                 j++) {}

            // expand
            ткст envvar;
            envvar = дайПеремСреды(возвр[(i + 1) .. j]);
            возвр = возвр[0 .. i] ~
            envvar ~
            возвр[j .. $];
        }
    }

    return возвр;
}

/** Read .dsssrc файл */
ткст[] читайДСССРС()
{
    ткст dsssrc;

    version(Windows) {
        // on Windows, just look in бинпапка
        ткст бинпапка, бинъимя;
        if (гдеЯ("dsss", бинпапка, бинъимя)) {
            if (естьФайл(бинпапка ~ "\\dsss.rc")) {
                dsssrc = cast(char[]) читайФайл(бинпапка ~ "\\dsss.rc");
            }
        }

    } else {
        ткст дом = дайПеремСреды("HOME");
        if (естьФайл(дом ~ "/.dsssrc")) {
            dsssrc = cast(char[]) читайФайл(дом ~ "/.dsssrc");
        }

    }

    // now разбей it up
    ткст[] rcsplit = разбей(dsssrc);
    ткст[] возвр;
    foreach (se; rcsplit) {
        if (se != "") {
            возвр ~= se;
        }
    }
    return возвр;
}

/// Get the short имя for the compiler
ткст краткоОКомпиляторе()
{
    if (целеваяВерсия("GNU")) {
        return DSSS_PLATFORM_GDC;
    } else if (целеваяВерсия("DigitalMars")) {
        return DSSS_PLATFORM_DMD;
    } else {
        return DSSS_PLATFORM_OTHER;
    }
}

/// Генерировать из секции имя библиотеки
ткст имяБиблиотеки(ткст пкт)
{
    пкт = замени(канонПуть(пкт),
                             "\\\\", "/");

    // LNC:
    // D<compiler>-<package-with-hyphens>

    // D
    ткст lname = "D";

    // <compiler>
    // FIXME: this should check with ребилд
    lname ~= краткоОКомпиляторе() ~ "-";

    // <package>
    // swap out /'s
    lname ~=
        замени(пкт, "/", "-");
    return lname;
}
