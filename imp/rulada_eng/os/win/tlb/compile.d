import std.file;
import std.process;
import std.io;
import std.console;

void main(){

scope files = std.file.listdir(".", "*.d"); 
     foreach (d; files){
 	sys("dmd -c "~d);	
	say("Попытка компилировать модуль:"); writefln(d);
	 //if(exists((d)~".obj"){writefln("Failed.");}
	 //if(0){writefln("Successful.");}
	 }
	 sys("del *.map *.exe");	
	 
	}