module std.zip;

private import stdrus;

alias stdrus.ЧленАрхиваЗИП ArchiveMember;

class ZipArchive:stdrus.АрхивЗИП
{
    this()   {super();    }

    void addMember(ArchiveMember de)
    {
	super.добавьЧлен(de);
    }

    void удалиЧлен(ArchiveMember de)
    {
	super.добавьЧлен(de);
    }

    void[] build()
    {	
	return super.строй();
	}

    this(void[] buffer)
    {	
	super(buffer);
	}
	
    ubyte[] expand(ArchiveMember de)
    {	
	return super.расжать(de);
    }

    /* ============ Utility =================== */

    ushort getUshort(int i)
    {
	return super.getUshort(i);
    }

    uint getUint(int i)
    {
	return super.getUint(i);
    }

    void putUshort(int i, ushort us)
    {
	super.putUshort(i,  us);
    }

    void putUint(int i, uint ui)
    {
	super.putUint(i, ui);
	}
}
