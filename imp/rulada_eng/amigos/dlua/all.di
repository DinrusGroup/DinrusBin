module amigos.dlua.all;

public import amigos.dlua.lua, amigos.dlua.lauxlib, amigos.dlua.lualib;

public import amigos.dlua.state, amigos.dlua.mixins, amigos.dlua.error;



version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
