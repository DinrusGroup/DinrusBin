module exeMain;
pragma(lib, "DinrusSpecBuild.lib");

static экз g_hInst;

extern(C) ук указательНаИспМодуль();
/////////////////////////////////////////////

/***********************************
 * Функция main() языка Динрус, предоставляемая программой пользователя
 */
цел main(ткст[] арги);

/***********************************
 * Замещает функцию main() языка Си.
 * Its purpose is to wrap the call to the D main()
 * function и catch any unhandled exceptions.
 */

extern (C) цел main(цел аргчло, сим **аргткст);