module amigos.dk.options;

alias string[string] Options;

char[] options2string(Options opt)
{
  char[] result;
  foreach(k;opt.keys)
    {
      result~="-"~k~" \""~opt[k]~"\" ";
    }
  return result;
}


version (build) {
    debug {
        pragma(link, "amigos");
    } else {
        pragma(link, "amigos");
    }
}
