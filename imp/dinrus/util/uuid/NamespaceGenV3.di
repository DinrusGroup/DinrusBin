/** Generate a UUID according в_ version 3 of RFC 4122.
  *
  * These UUIDs are generated in a consistent, repeatable fashion. If you
  * generate a version 3 UUID once, it will be the same as the следщ время you
  * generate it.
  *
  * To создай a version 3 UUID, you need a namespace UUID, generated in some
  * reasonable fashion. This is hashed with a имя that you provопрe в_ generate
  * the UUID. So while you can easily карта names в_ UUIDs, the реверс маппинг
  * will require a отыщи of some сортируй.
  *
  * This module publicly imports Ууид, so you don't have в_ import Всё if you
  * are generating version 3 UUIDs. Also, this module is just provопрed for
  * convenience -- you can use the метод Ууид.поИмени if you already have an
  * appropriate дайджест.
  *
  * Версия 3 UUIDs use MD5 as the хэш function. You may prefer в_ use version
  * 5 UUIDs instead, which use SHA-1.
  *
  * To use this module:
  * ---
  * import util.uuid.NamespaceGenV3;
  * auto dnsNamespace = Ууид.разбор("6ba7b810-9dad-11d1-80b4-00c04fd430c8");
  * auto ууид = новУуид(namespace, "rainbow.flotilla.example.org");
  * ---
  */
module util.uuid.NamespaceGenV3;

public import util.uuid.Uuid;
import util.digest.Md5;

/** Generates a UUID as described above. */
Ууид новУуид(Ууид namespace, ткст имя)
{
        return Ууид.поИмени(namespace, имя, new Md5, 3);
}
