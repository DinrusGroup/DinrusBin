/** Generate a UUID according в_ version 5 of RFC 4122.
  *
  * These UUIDs are generated in a consistent, repeatable fashion. If you
  * generate a version 5 UUID once, it will be the same as the следщ время you
  * generate it.
  *
  * To создай a version 5 UUID, you need a namespace UUID, generated in some
  * reasonable fashion. This is hashed with a имя that you provопрe в_ generate
  * the UUID. So while you can easily карта names в_ UUIDs, the реверс маппинг
  * will require a отыщи of some сортируй.
  *
  * This module publicly imports Ууид, so you don't have в_ import Всё if you
  * are generating version 5 UUIDs. Also, this module is just provопрed for
  * convenience -- you can use the метод Ууид.поИмени if you already have an
  * appropriate дайджест.
  *
  * Версия 5 UUIDs use SHA-1 as the хэш function. You may prefer в_ use 
  * version 3 UUIDs instead, which use MD5, if you require compatibility with
  * другой application.
  *
  * To use this module:
  * ---
  * import util.uuid.NamespaceGenV5;
  * auto dnsNamespace = Ууид.разбор("6ba7b810-9dad-11d1-80b4-00c04fd430c8");
  * auto ууид = новУуид(namespace, "rainbow.flotilla.example.org");
  * ---
  */
module util.uuid.NamespaceGenV5;

public import util.uuid.Uuid;
import util.digest.Sha1;

/** Generates a UUID as described above. */
Ууид новУуид(Ууид namespace, ткст имя)
{
        return Ууид.поИмени(namespace, имя, new Sha1, 5);
}
