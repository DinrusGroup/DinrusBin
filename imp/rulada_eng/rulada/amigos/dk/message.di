module amigos.dk.message;

import amigos.dk.widget;
import amigos.dk.options;

class Message: public Widget
{
  this(Widget master,string text)
    {
      Options o;
      o["text"]=text;
      super(master,"message",o);
    }
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
