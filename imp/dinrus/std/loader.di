module std.loader;
private import stdrus;

alias stdrus.иницМодуль ExeModule_Init;
alias stdrus.деиницМодуль ExeModule_Uninit;
alias stdrus.загрузиМодуль ExeModule_Load;
alias stdrus.добавьСсылНаМодуль ExeModule_AddRef;
alias stdrus.отпустиМодуль ExeModule_Release;
alias stdrus.дайСимволИМодуля ExeModule_GetSymbol;
alias stdrus.ошибкаИМодуля ExeModule_Error;