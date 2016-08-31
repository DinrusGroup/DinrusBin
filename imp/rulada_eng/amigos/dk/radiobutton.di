module amigos.dk.radiobutton;

import amigos.dk.widget;
import amigos.dk.options;

import std.string;


class Radiobutton:public Widget
{
  this(Widget master,string text,int value)
    {
      Options o;
      o["text"]=text;
      o["value"]=.toString(value);
      super(master,"radiobutton",o);
    }

  void flash(){eval("flash");}
  void deselect(){eval("deselect");}
  void select(){eval("select");}
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
