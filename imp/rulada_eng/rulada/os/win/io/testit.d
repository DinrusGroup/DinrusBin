import os.win.io.fs;
import std.io, std.string;
import std.intrinsic;

void main(){
uint v;
     int x;

     v = 0x21;
     x = bsf(v);
     writefln("bsf(x%x) = %d", v, x);
     x = bsr(v);
     writefln("bsr(x%x) = %d", v, x);
     
скажи(форматируй("Местные логические диски: %s", logicalDrives())).нс;
скажи(форматируй("Папка <c:\\dm> существует: %s", directoryExists("C:\\dm"))).нс;
скажи(форматируй("Общее свободное пространство диска C равно %s", getTotalFreeSpace("C:"))).нс;
скажи(форматируй("Атрибуты файла <c:\\dm\\dmd.txt> следующие: %s", getFileAttributes("c:\\dm\\dmd.txt"))).нс;
}
version (build) {
    debug {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    } else {
        version (GNU) {
            pragma(link, "DG-win");
        } else version (DigitalMars) {
            pragma(link, "rulada");
        } else {
            pragma(link, "DO-win");
        }
    }
}
