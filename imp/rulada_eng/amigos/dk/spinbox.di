module amigos.dk.spinbox;

import amigos.dk.options;
import amigos.dk.widget;

class Spinbox: public Widget
{
  this(Widget master)
    {
      Options o;
      o["from"]="0";
      o["to"]="10";
      super(master,"spinbox",o);
    }
  
  string get()
  {
    return eval("get");
  }
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
