/// Author: Aziz Köksal
/// License: GPL3
/// $(Maturity high)
module common;

public import tango.io.Stdout;
public import tango.text.convert.Layout;

/// Ткст aliases.
//alias сим[] ткст;
//alias шим[] wstring; /// ditto
//alias дим[] dstring; /// ditto

/// Global formatter instance.
static Layout!(сим) Формат;
static this()
{
  Формат = new typeof(Формат);
}
