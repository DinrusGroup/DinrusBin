module amigos.dk.event;

struct Event
{
  int x, y,  keycode, character, width, height, root_x, root_y;
}

version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
