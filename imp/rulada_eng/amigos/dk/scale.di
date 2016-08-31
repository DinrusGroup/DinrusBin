module amigos.dk.scale;

import amigos.dk.widget;
import amigos.dk.options;
import std.conv;
import std.string;

class Scale: public Widget
{
  this(Widget master,string text)
    {
      Options o;
      o["label"]=text;
      super(master,"scale",o);
    }
  
  int get() { return .toInt(eval("get")); }

  void set(int value)  { eval("set "~.toString(value)); }
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
