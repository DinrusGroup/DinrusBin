module ddl.ExportClass;

import ddl.DynamicLibrary;
import ddl.Mangle;
import ddl.Demangle;
import ddl.DDLException;

import std.regexp : RegExp;

class ExportClass(T) {
   alias T           baseType;
   ClassInfo         classInfo;
   char[]            name;
   DynamicLibrary    dynamicLib;

   this(ClassInfo classInfo, char[] name, DynamicLibrary lib) {
      this.classInfo = classInfo;
      this.name = name;
      this.dynamicLib = lib;
   }

   bool isAbstract();

   baseType newObject()();

   baseType newObject(P1)(P1 p1);


   baseType newObject(P1, P2)(P1 p1, P2 p2);
}
