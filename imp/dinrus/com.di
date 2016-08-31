module com;
public import tpl.com, sys.com, sys.COM.all;

бул КОМАктивен;

extern(C) extern бул комАктивен(бул данет = нет);

static this()
 {
 
 if(!комАктивен)
	{
		откройКОМ();
		комАктивен(да);
		КОМАктивен = да;
	}
}

static ~this()
 {
  if(!комАктивен)
	{
	  закройКОМ();
	  комАктивен(нет);
	  КОМАктивен = нет;
	}
}
