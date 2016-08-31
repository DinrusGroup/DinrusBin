module text.locale.Win32;

version (Windows)
{

цел дайКультуруПользователя();

проц установиКультуруПользователя(цел lcid);

цел сравниСтроку(цел lcid, ткст stringA, бцел offsetA, бцел lengthA, ткст stringB, бцел offsetB, бцел lengthB, бул ignoreCase);

}
