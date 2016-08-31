/** Most people who want UUIDs will generate small numbers of them (maybe a 
  * few hundred thousand) и not require a huge amount of uniqueness (just
  * for this one application). This module provопрes a convenient way в_ obtain
  * that behavior. 
  *
  * To Потокline your usage, this module publicly imports Ууид, so you can
  * import this module alone.
  *
  * To use this module, just:
  * ---
  * import  util.uuid.RandomGen;
  *
  * Ууид опр = randUuопр.следщ;
  * ---
  */
module  util.uuid.RandomGen;

public import util.uuid.Uuid;
import math.random.Twister;

/** The default random UUID generator. You can установи this if you need в_ generate
  * UUIDs in другой manner и already have код pointing в_ this module.
  *
  * This uses a unique PRNG экземпляр. If you want repeatable results, you
  * should инъекцируй your own UUID generator и reseed it as necessary:
  * ---
  * auto случ = getRand();
  * randUuопр = new СлучГен!(typeof(случ))(случ);
  * doStuff();
  * случ.reseed();
  * ---
  *
  * The default PRNG is the Mersenne twister. If you need скорость, KISS is about
  * 30 times faster. I chose the Mersenne twister because it's reasonably fast
  * (I can generate 150,000 per секунда on my machine) и имеется a дол период.
  * The KISS generator can произведи 5 million per секунда on my machine.
  */
УуидГен randUuопр;

static this ()
{
        Твистер случ;
        случ.сей;
        randUuопр = new СлучГен!(Твистер)(случ);
}

