module auxd.com;

public import os.win.com.all;

  abstract final class InternetExplorer {

   static class Application : DispatchObject {

     this() {
       super("InternetExplorer.Application");
     }

     void visible(bool value) {
       set("Visible", value);
     }

     bool visible() {
       return get!(bool)("Visible");
     }

     void navigate(string url) {
       call("Navigate", url);
     }

   }

 }

  