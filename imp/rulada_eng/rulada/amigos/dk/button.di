module amigos.dk.button;

import amigos.dk.widget;
import amigos.dk.callback;
import amigos.dk.options;

alias Button Кнопка;
class Button:public Widget
{
alias flash вспышка;

  this(Widget master,string text,Callback callback)
    {
      Options o;
      o["text"]=text;
      super(master,"button",o,callback);
    }

  void flash()        {eval("flash");}
  void tkButtonEnter(){pure_eval("tkButtonEnter "~m_name);}
  void tkButtonLeave(){pure_eval("tkButtonLeave "~m_name);}
  void tkButtonDown() {pure_eval("tkButtonDown "~m_name);}
  void tkButtonUp()   {pure_eval("tkButtonUp "~m_name);}
  void tkButtonInvoke()   {pure_eval("tkButtonInvoke "~m_name);}
}


version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
