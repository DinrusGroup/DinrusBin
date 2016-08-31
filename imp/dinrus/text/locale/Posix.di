/*******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. все rights reserved

        license:        BSD стиль: $(LICENSE)

        version:        Initial release: 2005

        author:         John Chapman

******************************************************************************/

module text.locale.Posix;

version (Posix)
{
alias text.locale.Posix nativeMethods;

private import exception;
private import text.locale.Data;
private import rt.core.stdc.ctype;
private import rt.core.stdc.posix.stdlib;
private import cidrus;
private import stringz;
private import rt.core.stdc.локаль;

/*private extern(C) сим* setlocale(цел тип, сим* локаль);
private extern(C) проц putenv(сим*);

private enum {LC_CTYPE, LC_NUMERIC, LC_TIME, LC_COLLATE, LC_MONETARY, LC_MESSAGES, LC_ALL, LC_PAPER, LC_NAME, LC_добавьRESS, LC_TELEPHONE, LC_MEASUREMENT, LC_IDENTIFICATION};*/

цел дайКультуруПользователя() {
  сим* среда = getenv("LC_ALL");
  if (!среда || *среда == '\0') {
    среда = getenv("LANG");
  }

  // getenv returns a ткст of the form <language>_<region>.
  // Therefore we need в_ замени underscores with hyphens.
  ткст s;
  if (среда){
      s = изТкст0(среда).dup;
      foreach (ref c; s)
               if (c == '.')
                   break;
               else
                  if (c == '_')
                      c = '-';
  } else {
      s="en-US";
  }
  foreach (Запись; ДанныеОКультуре.cultureDataTable) {
    // todo: there is also a local сравниСтроку defined. Is it correct that here 
    // we use text.locale.Data, which совпадает the сигнатура?
    if (text.locale.Data.сравниСтроку(Запись.имя, s) == 0)
      return Запись.lcid;
  }
  
  foreach (Запись; ДанныеОКультуре.cultureDataTable) {
    // todo: there is also a local сравниСтроку defined. Is it correct that here 
    // we use text.locale.Data, which совпадает the сигнатура?
    if (text.locale.Data.сравниСтроку(Запись.имя, "en-US") == 0)
      return Запись.lcid;
  }
  return 0;
}

проц установиКультуруПользователя(цел lcid) {
  ткст имя;
  try {
    имя = ДанныеОКультуре.дайДанныеИзИДКультуры(lcid).имя ~ ".utf-8";
  }
  catch(Исключение e) {
    return;
  }
  
  for(цел i = 0; i < имя.length; i++) {
    if(имя[i] == '.') break;
    if(имя[i] == '-') имя[i] = '_';
  }
  
  putenv(("LANG=" ~ имя).ptr);
  setlocale(LC_CTYPE, имя.ptr);
  setlocale(LC_NUMERIC, имя.ptr);
  setlocale(LC_TIME, имя.ptr);
  setlocale(LC_COLLATE, имя.ptr);
  setlocale(LC_MONETARY, имя.ptr);

  version (GNU) {} else {
/*      setlocale(LC_MESSAGES, имя.ptr); */
  }

  setlocale(LC_PAPER, имя.ptr);
  setlocale(LC_NAME, имя.ptr);
  setlocale(LC_добавьRESS, имя.ptr);
  setlocale(LC_TELEPHONE, имя.ptr);
  setlocale(LC_MEASUREMENT, имя.ptr);
  setlocale(LC_IDENTIFICATION, имя.ptr);
}

цел сравниСтроку(цел lcid, ткст stringA, бцел offsetA, бцел lengthA, ткст stringB, бцел offsetB, бцел lengthB, бул ignoreCase) {

  проц strToLower(ткст ткст) {
    for(цел i = 0; i < ткст.length; i++) {
      ткст[i] = cast(сим)(tolower(cast(цел)ткст[i]));
    }
  }

  сим* tempCol = setlocale(LC_COLLATE, пусто), tempCType = setlocale(LC_CTYPE, пусто);
  ткст локаль;
  try {
    локаль = ДанныеОКультуре.дайДанныеИзИДКультуры(lcid).имя ~ ".utf-8";
  }
  catch(Исключение e) {
    return 0;
  }
  
  setlocale(LC_COLLATE, локаль.ptr);
  setlocale(LC_CTYPE, локаль.ptr);
  
  ткст s1 = stringA[offsetA..offsetA+lengthA].dup,
         s2 = stringB[offsetB..offsetB+lengthB].dup;
  if(ignoreCase) {
    strToLower(s1);
    strToLower(s2);
  }
  
  цел возвр = strcoll(s1[offsetA..offsetA+lengthA].ptr, s2[offsetB..offsetB+lengthB].ptr);
  
  setlocale(LC_COLLATE, tempCol);
  setlocale(LC_CTYPE, tempCType);
  
  return возвр;
}

debug(UnitTest)
{
    unittest
    {
        цел c = дайКультуруПользователя();
        assert(сравниСтроку(c, "Alphabet", 0, 8, "Alphabet", 0, 8, нет) == 0);
        assert(сравниСтроку(c, "Alphabet", 0, 8, "alphabet", 0, 8, да) == 0);
        assert(сравниСтроку(c, "Alphabet", 0, 8, "alphabet", 0, 8, нет) != 0);
        assert(сравниСтроку(c, "lphabet", 0, 7, "alphabet", 0, 8, да) != 0);
        assert(сравниСтроку(c, "Alphabet", 0, 8, "lphabet", 0, 7, да) != 0);
    }
}
}
