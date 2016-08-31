// A minimal "hello world" Pyd module.
module hello;

import amigos.pyd.pyd;
import std.stdio;
import amigos.pyd.def;
import amigos.pyd.exception;

void hello() {
    say("Hello, world! Привет, питоны!");
}

extern(C) void PydMain() {
    def!(hello);
    module_init();
}

extern(C)
export void inithello() {
    amigos.pyd.exception.exception_catcher(delegate void() {
        amigos.pyd.def.pyd_module_name = "hello";
        PydMain();
    });
}
