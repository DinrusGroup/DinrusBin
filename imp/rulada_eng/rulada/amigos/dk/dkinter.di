module amigos.dk.dkinter;

public
{
  import amigos.dk.event;
  import amigos.dk.options;
  import amigos.dk.widget;
  import amigos.dk.tk;

  import amigos.dk.label;
  import amigos.dk.entry;
  import amigos.dk.listbox;
  import amigos.dk.radiobutton;
  import amigos.dk.message;
  import amigos.dk.scale;
  import amigos.dk.button;
  import amigos.dk.spinbox;
  import amigos.dk.canvas;
}

class Text: public Widget
{
  this(Widget master)
    {
      Options o;
      super(master,"text",o);
    }
}

class Frame:public Widget
{
  this(Widget master)
    {
      Options o;
      super(master,"frame",o);
    }
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
