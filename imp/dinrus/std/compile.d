import dinrus;


void main(){

scope флы = списпап(".", "*.d"); 
     foreach (ф; флы){
	 if(ф==".\\compile.d"){;}
	 else 	сис("%DINRUS%\\dmd -c "~ф);	
	 	 if(ф==".\\compile.d"){скажифнс("Пропуск модуля:"~ф);}
	 else 	сис("%DINRUS%\\dmd -c "~ф);	
	скажифнс("Попытка компилировать модуль:"~ф);
	 //if(exists((d)~".obj"){writefln("Failed.");}
	 //if(0){writefln("Successful.");}
	 }
	 сис("%DINRUS%\\ls2 -d *.obj>>objs.rsp");
	  сис("%DINRUS%\\dmd -lib -ofstd.lib @objs.rsp");
	 сис("del *.map *.obj");	
	 
	}