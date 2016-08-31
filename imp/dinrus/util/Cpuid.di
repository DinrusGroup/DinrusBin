﻿/** 
 Identify the characteristics of the хост CPU, provопрing information
 about cache sizes and assembly optimisation hints.

 Some of this information was extremely difficult в_ track down. Some of the
 documents below were найдено only in cached versions stored by search engines!
  This код relies on information найдено in:
    
  - "Intel(R) 64 and IA-32 Architectures Software Developers Manual,
      Volume 2A: Instruction Набор Reference, A-M" (2007).
  - "AMD CPUID Specification", Advanced Micro Devices, Rev 2.28 (2008).
  - "AMD Processor Recognition Application Note For Processors Prior в_ AMD
      Family 0Fh Processors", Advanced Micro Devices, Rev 3.13 (2005).
  - "AMD Geode(TM) GX Processors Данные Book",
      Advanced Micro Devices, Publication ID 31505E, (2005).
  - "AMD K6 Processor Code Optimisation", Advanced Micro Devices, Rev D (2000).
  - "Application note 106: Software Customization for the 6x86 Family",
      Cyrix Corporation, Rev 1.5 (1998)
  - http://ftp.intron.ac/pub/document/cpu/cpuid.htm
  - "Geode(TM) GX1 Processor Series Low Power Integrated X86 Solution",
      National Semiconductor, (2002)
  - "The VIA Isaiah Architecture", G. Glenn Henry, Centaur Technology, Inc (2008).
  - http://www.sandpile.org/ia32/cpuid.htm
  - http://grafi.ii.pw.edu.pl/gbm/x86/cpuid.html
  - "What every programmer should know about память",
     Ulrich Depper, Red Hat, Inc., (2007). 
  - "CPU Identification by the Windows Kernel", G. Chappell (2009).
    http://www.geoffchappell.com/viewer.htm?doc=studies/windows/km/cpu/cx8.htm
  - "Intel(R) Processor Identification and the CPUID Instruction, Application
     Note 485" (2009).

AUTHORS:  Don Clugston,
          Tomas Lindquist Olsen &lt;tomas@famolsen.dk&gt;
COPYRIGHT:  Public Domain

BUGS:   Currently only works on x86 CPUs.
        Many processors have bugs in their microcode for the CPUID instruction,
        so sometimes the cache information may be incorrect.
*/

module util.Cpuid;

// If optimizing for a particular процессор, it is generally better
// в_ опрentify based on features rather than model. NOTE: Normally
// it's only worthwhile в_ optimise for the latest Intel and AMD CPU,
// with a backup for другой CPUs.
// Pentium    -- preferPentium1()
// PMMX       --   + mmx()
// PPro       -- default
// PII        --   + mmx()
// PIII       --   + mmx() + sse()
// PentiumM   --   + mmx() + sse() + sse2()
// Pentium4   -- preferPentium4()
// PentiumD   --   + isX86_64()
// Core2      -- default + isX86_64()
// AMD K5     -- preferPentium1()
// AMD K6     --   + mmx()
// AMD K6-II  --   + mmx() + 3dnow()
// AMD K7     -- preferAthlon()
// AMD K8     --   + sse2()
// AMD K10    --   + isX86_64()
// Cyrix 6x86 -- preferPentium1()
//    6x86MX  --   + mmx()

public:

/// Cache размер and behaviour
struct ИнфОКэше
{
    /// Size of the cache, in kilobytes, per CPU.
    /// For L1 unified (данные + код) caches, this размер is half the physical размер.
    /// (we don't halve it for larger sizes, since normally
    /// данные размер is much greater than код размер for critical loops).
    бцел размер;
    /// Число of ways of ассоциативность, eg:
    /// 1 = direct mapped
    /// 2 = 2-way установи associative
    /// 3 = 3-way установи associative
    /// ббайт.max = fully associative
    ббайт ассоциативность;
    /// Число of байты читай преобр_в the cache when a cache miss occurs.
    бцел размерСтроки;
}

public:
    /// Returns производитель ткст, for display purposes only.
    /// Do NOT use this в_ determine features!
    /// Note that some CPUs have programmable vendorIDs.
    ткст производитель()     {return cast(ткст) vendorID;}
    /// Returns процессор ткст, for display purposes only
    ткст процессор()  {return processorName;}    
    
    /// The данные caches. If there are fewer than 5 physical caches levels,
    /// the remaining levels are установи в_ бцел.max (== entire память пространство)
    ИнфОКэше[5] datacache;
    /// Does it have an x87 FPU on-chИП?
    бул x87onChИП()    {return (features&FPU_BIT)!=0;}
    /// Is MMX supported?
    бул mmx()          {return (features&MMX_BIT)!=0;}
    /// Is SSE supported?
    бул sse()          {return (features&SSE_BIT)!=0;}
    /// Is SSE2 supported?
    бул sse2()         {return (features&SSE2_BIT)!=0;}
    /// Is SSE3 supported?
    бул sse3()         {return (miscfeatures&SSE3_BIT)!=0;}
    /// Is SSSE3 supported?
    бул ssse3()        {return (miscfeatures&SSSE3_BIT)!=0;}
    /// Is SSE4.1 supported?
    бул sse41()        {return (miscfeatures&SSE41_BIT)!=0;}
    /// Is SSE4.2 supported?
    бул sse42()        {return (miscfeatures&SSE42_BIT)!=0;}
    /// Is SSE4a supported?
    бул sse4a()        {return (amdmiscfeatures&SSE4A_BIT)!=0;}
    /// Is AMD 3DNOW supported?
    бул amd3dnow()     {return (amdfeatures&AMD_3DNOW_BIT)!=0;}
    /// Is AMD 3DNOW Ext supported?
    бул amd3dnowExt()  {return (amdfeatures&AMD_3DNOW_EXT_BIT)!=0;}
    /// Are AMD extensions в_ MMX supported?
    бул amdMmx()       {return (amdfeatures&AMD_MMX_BIT)!=0;}
    /// Is fxsave/fxrstor supported?
    бул hasFxsr()          {return (features&FXSR_BIT)!=0;}
    /// Is cmov supported?
    бул hasCmov()          {return (features&CMOV_BIT)!=0;}
    /// Is rdtsc supported?
    бул hasRdtsc()         {return (features&TIMESTAMP_BIT)!=0;}
    /// Is cmpxchg8b supported?
    бул hasCmpxchg8b()     {return (features&CMPXCHG8B_BIT)!=0;}
    /// Is cmpxchg8b supported?
    бул hasCmpxchg16b()    {return (miscfeatures&CMPXCHG16B_BIT)!=0;}
    /// Is SYSENTER/SYSEXIT supported?
    бул hasSysEnterSysExit()     {
        // The SYSENTER/SYSEXIT features were buggy on Pentium Pro and early PentiumII.
        // (REF: www.geoffchappell.com).
        if (probablyIntel && (семейство < 6 || (семейство==6 && (model< 3 || (model==3 && stepping<3)))))
            return нет;
        return (features & SYSENTERSYSEXIT_BIT)!=0;
    }
    
    /// Is 3DNow prefetch supported?
    бул has3dnowPrefetch()
        {return (amdmiscfeatures&AMD_3DNOW_PREFETCH_BIT)!=0;}
    /// Are LAHF and SAHF supported in 64-bit режим?
    бул hasLahfSahf()          {return (amdmiscfeatures&LAHFSAHF_BIT)!=0;}
    /// Is POPCNT supported?
    бул hasPopcnt()        {return (miscfeatures&POPCNT_BIT)!=0;}    
    /// Is LZCNT supported?
    бул hasLzcnt()         {return (amdmiscfeatures&LZCNT_BIT)!=0;}
    /// Is this an Intel64 or AMD 64?
    бул isX86_64()         {return (amdfeatures&AMD64_BIT)!=0;}
            
    /// Is this an IA64 (Itanium) процессор?
    бул isItanium()        { return (features&IA64_BIT)!=0; }

    /// Is hyperthreading supported?
    бул hyperThreading()   { return maxThreads>maxCores; }
    /// Returns число of threads per CPU
    бцел threadsPerCPU()    {return maxThreads;}
    /// Returns число of cores in CPU
    бцел coresPerCPU()      {return maxCores;}
    
    /// Optimisation hints for assembly код.
    /// For forward compatibility, the CPU is compared against different
    /// microarchitectures. For 32-bit X86, comparisons are made against
    /// the Intel PPro/PII/PIII/PM семейство.
    ///
    /// The major 32-bit x86 microarchitecture 'dynasties' have been:
    /// (1) Intel P6 (PentiumPro, PII, PIII, PM, Core, Core2).
    /// (2) AMD Athlon (K7, K8, K10).
    /// (3) Intel NetBurst (Pentium 4, Pentium D).
    /// (4) In-order Pentium (Pentium1, PMMX, Atom)
    /// Other early CPUs (Nx586, AMD K5, K6, Centaur C3, Transmeta,
    ///   Cyrix, Rise) were mostly in-order.
    /// Some new processors do not fit преобр_в the existing categories:
    /// Intel Atom 230/330 (семейство 6, model 0x1C) is an in-order core.
    /// Centaur Isiah = VIA Nano (семейство 6, model F) is an out-of-order core.
    ///
    /// Within each dynasty, the optimisation techniques are largely
    /// опрentical (eg, use instruction pairing for группа 4). Major
    /// instruction установи improvements occur within each dynasty.
    
    /// Does this CPU perform better on AMD K7 код than PentiumPro..Core2 код?
    бул preferAthlon() { return probablyAMD && семейство >=6; }
    /// Does this CPU perform better on Pentium4 код than PentiumPro..Core2 код?
    бул preferPentium4() { return probablyIntel && семейство == 0xF; }
    /// Does this CPU perform better on Pentium I код than Pentium Pro код?
    бул preferPentium1() { return семейство < 6 || (семейство==6 && model < 0xF && !probablyIntel); }

public:
    /// Processor тип (производитель-dependent).
    /// This should be visible ONLY for display purposes.
    бцел stepping, model, семейство;
    бцел numCacheУровеньs = 1;
private:
    бул probablyIntel; // да = _probably_ an Intel процессор, might be faking
    бул probablyAMD; // да = _probably_ an AMD процессор
    сим[12] vendorID;
    ткст processorName;
    сим[48] processorNameBuffer;
    бцел features = 0;     // mmx, sse, sse2, hyperthreading, etc
    бцел miscfeatures = 0; // sse3, etc.
    бцел amdfeatures = 0;  // 3DNow!, mmxext, etc
    бцел amdmiscfeatures = 0; // sse4a, sse5, svm, etc
    бцел maxCores = 1;
    бцел maxThreads = 1;
    // Note that this may indicate multi-core rather than hyperthreading.
    бул hyperThreadingBit()    { return (features&HTT_BIT)!=0;}
    
    // feature флаги CPUID1_EDX
    enum : бцел
    {
        FPU_BIT = 1,
        TIMESTAMP_BIT = 1<<4, // rdtsc
        MDSR_BIT = 1<<5,      // НДСSR/WRMSR
        CMPXCHG8B_BIT = 1<<8,
        SYSENTERSYSEXIT_BIT = 1<<11,
        CMOV_BIT = 1<<15,
        MMX_BIT = 1<<23,
        FXSR_BIT = 1<<24,
        SSE_BIT = 1<<25,
        SSE2_BIT = 1<<26,
        HTT_BIT = 1<<28,
        IA64_BIT = 1<<30
    }
    // feature флаги misc CPUID1_ECX
    enum : бцел
    {
        SSE3_BIT = 1,
        PCLMULQDQ_BIT = 1<<1, // из_ AVX
        MWAIT_BIT = 1<<3,
        SSSE3_BIT = 1<<9,
        FMA_BIT = 1<<12,     // из_ AVX
        CMPXCHG16B_BIT = 1<<13,
        SSE41_BIT = 1<<19,
        SSE42_BIT = 1<<20,
        POPCNT_BIT = 1<<23,
        AES_BIT = 1<<25, // AES instructions из_ AVX
        OSXSAVE_BIT = 1<<27, // Used for AVX
        AVX_BIT = 1<<28
    }
/+    
version(X86_64) {    
    бул hasAVXinHardware() {
        // This only indicates hardware support, not OS support.
        return (miscfeatures&AVX_BIT) && (miscfeatures&OSXSAVE_BIT);
    }
    // Is AVX supported (in Всё hardware & OS)?
    бул Avx() {
        if (!hasAVXinHardware()) return нет;
        // Check for OS support
        бцел xfeatures;
        asm {mov ECX, 0; xgetbv; mov xfeatures, EAX; }
        return (xfeatures&0x6)==6;
    }
    бул hasAvxFma() {
        if (!AVX()) return нет;
        return (features&FMA_BIT)!=0;        
    }
}
+/    
    // AMD feature флаги CPUID80000001_EDX
    enum : бцел
    {
        AMD_MMX_BIT = 1<<22,
//      FXR_OR_CYRIXMMX_BIT = 1<<24, // Cyrix/NS: 6x86MMX instructions. 
        FFXSR_BIT = 1<<25,
        PAGE1GB_BIT = 1<<26, // support for 1GB pages
        RDTSCP_BIT = 1<<27,
        AMD64_BIT = 1<<29,
        AMD_3DNOW_EXT_BIT = 1<<30,
        AMD_3DNOW_BIT = 1<<31
    }
    // AMD misc feature флаги CPUID80000001_ECX
    enum : бцел
    {
        LAHFSAHF_BIT = 1,
        LZCNT_BIT = 1<<5,
        SSE4A_BIT = 1<<6,       
        AMD_3DNOW_PREFETCH_BIT = 1<<8
    }

version(GNU){
    // GDC is a filthy liar. It can't actually do inline asm.
} else version(D_InlineAsm_X86) {
    version = Really_D_InlineAsm_X86;
}

version(Really_D_InlineAsm_X86) {
// Note that this код will also work for Itanium in x86 режим.

бцел max_cpuid, max_extended_cpuid;

// CPUID2: "cache and tlb information"
проц getcacheinfoCPUID2()
{
    // CPUID2 is a dog's breakfast. What was Intel thinking???
    // We are only interested in the данные caches
    проц decИПherCpuid2(ббайт x) {
        if (x==0) return;
        // Values из_ http://www.sandpile.org/ia32/cpuid.htm.
        // Includes Itanium and non-Intel CPUs.
        //
        static ббайт[63] опрs = [
            0x0A, 0x0C, 0x0D, 0x2C, 0x60, 0x0E, 0x66, 0x67, 0x68,
            // уровень 2 cache
            0x41, 0x42, 0x43, 0x44, 0x45, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0x7F,
            0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x49, 0x4E,
            0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x48, 0x80, 0x81,
            // уровень 3 cache
            0x22, 0x23, 0x25, 0x29, 0x46, 0x47, 0x4A, 0x4B, 0x4C, 0x4D,
            
            0xD0, 0xD1, 0xD2, 0xD6, 0xD7, 0xD8, 0xDC, 0xDD, 0xDE,
            0xE2, 0xE3, 0xE4, 0xEA, 0xEB, 0xEC
        ];
        static бцел[63] sizes = [
            8, 16, 16, 64, 16, 24, 8, 16, 32,
            128, 256, 512, 1024, 2048, 1024, 128, 256, 512, 1024, 2048, 512,
            256, 512, 1024, 2048, 512, 1024, 4096, 6*1024,
            128, 192, 128, 256, 384, 512, 3072, 512, 128,           
            512, 1024, 2048, 4096, 4096, 8192, 6*1024, 8192, 12*1024, 16*1024,
            
            512, 1024, 2048, 1024, 2048, 4096, 1024+512, 3*1024, 6*1024,
            2*1024, 4*1024, 8*1024, 12*1024, 28*1024, 24*1024
        ];
    // CPUBUG: Pentium M reports 0x2C but tests show it is only 4-way associative
        static ббайт[63] ways = [
            2, 4, 4, 8, 8, 6, 4, 4, 4,
            4, 4, 4, 4, 4, 4, 8, 8, 8, 8, 8, 2,
            8, 8, 8, 8, 4, 8, 16, 24,
            4, 6, 2, 4, 6, 4, 12, 8, 8,
            4, 8, 8, 8, 4, 8, 12, 16, 12, 16,
            4, 4, 4, 8, 8, 8, 12, 12, 12,
            16, 16, 16, 24, 24, 24            
        ];
        enum { FIRSTDATA2 = 8, FIRSTDATA3 = 28+9 }
        for (цел i=0; i< опрs.length; ++i) {
            if (x==опрs[i]) {
                цел уровень = i< FIRSTDATA2 ? 0: i<FIRSTDATA3 ? 1 : 2;
                if (x==0x49 && семейство==0xF && model==0x6) уровень=2;
                datacache[уровень].размер=sizes[i];
                datacache[уровень].ассоциативность=ways[i];
                if (уровень == 3 || x==0x2C || x==0x0D || (x>=0x48 && x<=0x80) 
                                   || x==0x86 || x==0x87
                                   || (x>=0x66 && x<=0x68) || (x>=0x39 && x<=0x3E)){
                    datacache[уровень].размерСтроки = 64;
                } else datacache[уровень].размерСтроки = 32;
            }
        }
    }

    бцел[4] a;  
    бул firstTime = да;
    // On a multi-core system, this could theoretically краш, but it's only used
    // for old single-core CPUs.
    бцел numinfos = 1;
    do {
        asm {
            mov EAX, 2;
            cpuid;
            mov a, EAX;
            mov a+4, EBX;
            mov a+8, ECX;
            mov a+12, EDX;
        }
        if (firstTime) {
            if (a[0]==0x0000_7001 && a[3]==0x80 && a[1]==0 && a[2]==0) {
        // Cyrix MediaGX MMXEnhanced returns: EAX= 00007001, EDX=00000080.
        // These are NOT стандарт Intel values
        // (TLB = 32 Запись, 4 way associative, 4K pages)
        // (L1 cache = 16K, 4way, linesize16)
                datacache[0].размер=8;
                datacache[0].ассоциативность=4;
                datacache[0].размерСтроки=16;
                return;             
            }
            // lsb of a is как many times в_ loop.
            numinfos = a[0] & 0xFF;
            // and otherwise it should be ignored
            a[0] &= 0xFFFF_FF00;
            firstTime = нет;
        }
        for (цел c=0; c<4;++c) {
            // high bit установи == no инфо.
            if (a[c] & 0x8000_0000) continue;
            decИПherCpuid2(cast(ббайт)(a[c] & 0xFF));
            decИПherCpuid2(cast(ббайт)((a[c]>>8) & 0xFF));
            decИПherCpuid2(cast(ббайт)((a[c]>>16) & 0xFF));
            decИПherCpuid2(cast(ббайт)((a[c]>>24) & 0xFF));
        }
    } while (--numinfos);
}

// CPUID4: "Deterministic cache параметры" leaf
проц getcacheinfoCPUID4()
{
    цел cachenum = 0;
    for(;;) {
        бцел a, b, number_of_sets;  
        asm {
            mov EAX, 4;
            mov ECX, cachenum;
            cpuid;
            mov a, EAX;
            mov b, EBX;
            mov number_of_sets, ECX;
        }
        ++cachenum;
        if ((a&0x1F)==0) break; // no ещё caches
        бцел numthreads = ((a>>14) & 0xFFF)  + 1;
        бцел numcores = ((a>>26) & 0x3F) + 1;
        if (numcores > maxCores) maxCores = numcores;
        if ((a&0x1F)!=1 && ((a&0x1F)!=3)) continue; // we only want данные & unified caches
        
        ++number_of_sets;
        ббайт уровень = cast(ббайт)(((a>>5)&7)-1);
        if (уровень > datacache.length) continue; // ignore deep caches
        datacache[уровень].ассоциативность = a & 0x200 ? ббайт.max :cast(ббайт)((b>>22)+1);
        datacache[уровень].размерСтроки = (b & 0xFFF)+ 1; // system coherency строка размер
        бцел line_partitions = ((b >> 12)& 0x3FF) + 1;
        // Size = число of sets * ассоциативность * cachelinesize * linepartitions
        // and must преобразуй в_ Kb, also divопрing by the число of hyperthreads using this cache.
        бдол sz = (datacache[уровень].ассоциативность< ббайт.max)? number_of_sets *
            datacache[уровень].ассоциативность : number_of_sets;        
        datacache[уровень].размер = cast(бцел)(
                (sz * datacache[уровень].размерСтроки * line_partitions ) / (numthreads *1024));
        if (уровень == 0 && (a&0xF)==3) {
            // Halve the размер for unified L1 caches
            datacache[уровень].размер/=2;
        }
    }
}

// CPUID8000_0005 & 6
проц getAMDcacheinfo()
{
    бцел c5, c6, d6;
    asm {
        mov EAX, 0x8000_0005; // L1 cache
        cpuid;
        // EAX есть L1_TLB_4M.
        // EBX есть L1_TLB_4K
        // EDX есть L1 instruction cache
        mov c5, ECX;
    }

    datacache[0].размер = ( (c5>>24) & 0xFF);
    datacache[0].ассоциативность = cast(ббайт)( (c5 >> 16) & 0xFF);
    datacache[0].размерСтроки = c5 & 0xFF;

    if (max_extended_cpuid >= 0x8000_0006) {
        // AMD K6-III or K6-2+ or later.
        ббайт numcores = 1;
        if (max_extended_cpuid >=0x8000_0008) {
            asm {
                mov EAX, 0x8000_0008;
                cpuid;
                mov numcores, CL;
            }
            ++numcores;
            if (numcores>maxCores) maxCores = numcores;
        }
        asm {
            mov EAX, 0x8000_0006; // L2/L3 cache
            cpuid;
            mov c6, ECX; // L2 cache инфо
            mov d6, EDX; // L3 cache инфо
        }
    
        ббайт [] assocmap = [ 0, 1, 2, 0, 4, 0, 8, 0, 16, 0, 32, 48, 64, 96, 128, 0xFF ];
        datacache[1].размер = (c6>>16) & 0xFFFF;
        datacache[1].ассоциативность = assocmap[(c6>>12)&0xF];
        datacache[1].размерСтроки = c6 & 0xFF;
        
        // The L3 cache значение is TOTAL, not per core.
        datacache[2].размер = ((d6>>18)*512)/numcores; // could be up в_ 2 * this, -1.
        datacache[2].ассоциативность = assocmap[(d6>>12)&0xF];
        datacache[2].размерСтроки = d6 & 0xFF;
    }
}

// For Intel CoreI7 and later, use function 0x0B
// в_ determine число of processors.
проц getИнфОЦПБ0B()
{
    цел уровень=0;
    бцел a, b, c, d;
    do {
        asm {
            mov EAX, 0x0B;
            mov ECX, уровень;
            cpuid;
            mov a, EAX;
            mov b, EBX;
            mov c, ECX;
            mov d, EDX;        
        }
        if (b!=0) {
           // I'm not sure about this. The docs состояние that there
           // are 2 hyperthreads per core if HT is factory включен.
            if (уровень==0) maxThreads = b & 0xFFFF;
            else if (уровень==1) maxCores = b & 0xFFFF;
            
        }
        ++уровень;
    } while (a!=0 || b!=0);
}

проц cpuidX86()
{
    сим * venptr = vendorID.ptr;
    бцел a, b, c, d, a2;
    asm {
        mov EAX, 0;
        cpuid;
        mov a, EAX;
        mov EAX, venptr;
        mov [EAX], EBX;
        mov [EAX + 4], EDX;
        mov [EAX + 8], ECX;
        mov EAX, 0x8000_0000;
        cpuid;
        mov a2, EAX;
    }
    
    max_cpuid = a;
    max_extended_cpuid = a2;
    
    probablyIntel = vendorID == "GenuineIntel";
    probablyAMD = vendorID == "AuthenticAMD";
    бцел apic = 0; // brand индекс, apic опр
    asm {
        mov EAX, 1; // model, stepping
        cpuid;
        mov a, EAX;
        mov apic, EBX;
        mov c, ECX;
        mov d, EDX;
    }
    features = d;
    miscfeatures = c;
    amdfeatures = 0;
    amdmiscfeatures = 0;
    if (max_extended_cpuid >= 0x8000_0001) {
        asm {
            mov EAX, 0x8000_0001;
            cpuid;
            mov c, ECX;
            mov d, EDX;
        }
        amdmiscfeatures = c;
        amdfeatures = d;
    }
    // Try в_ detect fraudulent vendorIDs
    if (amd3dnow) probablyIntel = нет;
    
    stepping = a & 0xF;
    бцел fbase = (a >> 8) & 0xF;
    бцел mbase = (a >> 4) & 0xF;
    семейство = ((fbase == 0xF) || (fbase == 0)) ? fbase + (a >> 20) & 0xFF : fbase;
    model = ((fbase == 0xF) || (fbase == 6 && probablyIntel) ) ?
         mbase + ((a >> 12) & 0xF0) : mbase;
         
    if (!probablyIntel && max_extended_cpuid >= 0x8000_0008) {
        // determine max число of cores for AMD
        asm {
            mov EAX, 0x8000_0008;
            cpuid;
            mov c, ECX;
        }
        бцел apicsize = (c>>12) & 0xF;
        if (apicsize == 0) {
            // use legacy метод
            if (hyperThreadingBit)  maxCores = c & 0xFF;
            else maxCores = 1;
        } else {
            // maxcores = 2^ apicsize
            maxCores = 1;
            while (apicsize) { maxCores<<=1; --apicsize; }
        }
    }
    
    if (max_extended_cpuid >= 0x8000_0004) {
        сим *procptr = processorNameBuffer.ptr;
        asm {
            push ESI;
            mov ESI, procptr;
            mov EAX, 0x8000_0002;
            cpuid;
            mov [ESI], EAX;
            mov [ESI+4], EBX;
            mov [ESI+8], ECX;
            mov [ESI+12], EDX;
            mov EAX, 0x8000_0003;
            cpuid;
            mov [ESI+16], EAX;
            mov [ESI+20], EBX;
            mov [ESI+24], ECX;
            mov [ESI+28], EDX;
            mov EAX, 0x8000_0004;
            cpuid;
            mov [ESI+32], EAX;
            mov [ESI+36], EBX;
            mov [ESI+40], ECX;
            mov [ESI+44], EDX;
            pop ESI;            
        }
        // Intel P4 and PM pad at front with пробелы.
        // Other CPUs pad at конец with nulls.
        цел старт = 0, конец = 0;
        while (processorNameBuffer[старт] == ' ') { ++старт; }
        while (processorNameBuffer[$-конец-1] == 0) { ++конец; }
        processorName = processorNameBuffer[старт..$-конец];
    } else {
        processorName = "Unknown CPU";
    }
    // Determine cache sizes
    
    // Intel docs specify that they return 0 for 0x8000_0005.
    // AMD docs do not specify the behaviour for 0004 and 0002.
    // Centaur/VIA and most другой manufacturers use the AMD метод,
    // except Cyrix MediaGX MMX Enhanced uses their OWN form of CPUID2!
    // NS Geode GX1 provопрes CyrixCPUID2 _and_ does the same wrong behaviour
    // for CPUID80000005. But Geode GX uses the AMD метод
    
    // Deal with опрiotic Geode GX1 - сделай it same as MediaGX MMX.
    if (max_extended_cpuid==0x8000_0005 && max_cpuid==2) {      
        max_extended_cpuid = 0x8000_0004;
    }
    // Therefore, we try the AMD метод unless it's an Intel chИП.
    // If we still have no инфо, try the Intel methods.
    datacache[0].размер = 0;
    if (max_cpuid<2 || !probablyIntel) {
        if (max_extended_cpuid >= 0x8000_0005) {
            getAMDcacheinfo();
        } else if (probablyAMD) {       
            // According в_ AMDProcRecognitionAppNote, this means CPU
            // K5 model 0, or Am5x86 (model 4), or Am4x86DX4 (model 4)
            // Am5x86 есть 16Kb 4-way unified данные & код cache.
            datacache[0].размер = 8;
            datacache[0].ассоциативность = 4;
            datacache[0].размерСтроки = 32;     
        } else {
            // Some obscure CPU.
            // Values for Cyrix 6x86MX (семейство 6, model 0)
            datacache[0].размер = 64;
            datacache[0].ассоциативность = 4;
            datacache[0].размерСтроки = 32;     
        }
    }   
    if ((datacache[0].размер == 0) && max_cpuid>=4) {
        getcacheinfoCPUID4();
    }
    if ((datacache[0].размер == 0) && max_cpuid>=2) {     
        getcacheinfoCPUID2();
    }
    if (datacache[0].размер == 0) {
        // Pentium, PMMX, late model 486, or an obscure CPU
        if (mmx) { // Pentium MMX. Also есть 8kB код cache.
            datacache[0].размер = 16;
            datacache[0].ассоциативность = 4;
            datacache[0].размерСтроки = 32;     
        } else { // Pentium 1 (which also есть 8kB код cache)
                 // or 486.
            // Cyrix 6x86: 16, 4way, 32 linesize
            datacache[0].размер = 8;
            datacache[0].ассоциативность = 2;
            datacache[0].размерСтроки = 32;
        }       
    }
    if (max_cpuid >=0x0B) {
        // For Intel i7 and later, use function 0x0B в_ determine
        // cores and hyperthreads.
        getИнфОЦПБ0B();    
    } else {
        if (hyperThreadingBit) maxThreads = (apic>>>16) & 0xFF;
        else maxThreads = maxCores;
    }
}

// Return да if the cpuid instruction is supported.
// BUG(WONTFIX): Returns нет for Cyrix 6x86 and 6x86L. They will be treated as 486 machines.
бул hasCPUID()
{
    бцел флаги;
    asm {
        pushfd;
        pop EAX;
        mov флаги, EAX;
        xor EAX, 0x0020_0000;
        push EAX;
        popfd;
        pushfd;
        pop EAX;
        xor флаги, EAX;
    }
    return (флаги & 0x0020_0000) !=0;
}

} else { // inline asm X86

    бул hasCPUID() { return нет; }

    проц cpuidX86()
    {
            datacache[0].размер = 8;
            datacache[0].ассоциативность = 2;
            datacache[0].размерСтроки = 32;     
    }   
}

// TODO: Implement this function with OS support
проц cpuКСЕРPC()
{
    enum :цел  { PPC601, PPC603, PPC603E, PPC604,
                 PPC604E, PPC620, PPCG3, PPCG4, PPCG5 };

    // TODO:
    // asm { mfpvr; } returns the CPU version but unfortunately it can
    // only be used in kernel режим. So OS support is required.
    цел cputype = PPC603;
    
    // 601 есть a 8KB combined данные & код L1 cache.
    бцел sizes[] = [4, 8, 16, 16, 32, 32, 32, 32, 64];
    ббайт ways[] = [8, 2,  4,  4,  4,  8,  8,  8,  8];
    бцел L2size[]= [0, 0,  0,  0,  0,  0,  0,  256,  512];
    бцел L3size[]= [0, 0,  0,  0,  0,  0,  0,  2048,  0];
    
    datacache[0].размер = sizes[cputype];
    datacache[0].ассоциативность = ways[cputype]; 
    datacache[0].размерСтроки = (cputype==PPCG5)? 128 : 
        (cputype == PPC620 || cputype == PPCG3)? 64 : 32;
    datacache[1].размер = L2size[cputype];
    datacache[2].размер = L3size[cputype];
    datacache[1].размерСтроки = datacache[0].размерСтроки;
    datacache[2].размерСтроки = datacache[0].размерСтроки;
}

// TODO: Implement this function with OS support
проц cpuidSparc()
{
    // UltaSparcIIi  : L1 = 16,  2way. L2 = 512, 4 way.
    // UltraSparcIII : L1 = 64,  4way. L2= 4096 or 8192.
    // UltraSparcIIIi: L1 = 64,  4way. L2= 1024, 4 way
    // UltraSparcIV  : L1 = 64,  4way. L2 = 16*1024.
    // UltraSparcIV+ : L1 = 64,  4way. L2 = 2048, L3=32*1024.
    // Sparc64V      : L1 = 128, 2way. L2 = 4096 4way.  
}


static this()
{
    if (hasCPUID()) {
        cpuidX86();
    } else {
        // it's a 386 or 486, or a Cyrix 6x86.
        //Probably still есть an external cache.
    }
    if (datacache[0].размер==0) {
            // Guess same as Pentium 1.
            datacache[0].размер = 8;
            datacache[0].ассоциативность = 2;
            datacache[0].размерСтроки = 32;     
    }
    numCacheУровеньs = 1;
    // And сейчас заполни up все the unused levels with full память пространство.
    for (цел i=1; i< datacache.length; ++i) {
        if (datacache[i].размер==0) {
            // Набор все remaining levels of cache equal в_ full адрес пространство.
            datacache[i].размер = бцел.max/1024;
            datacache[i].ассоциативность = 1;
            datacache[i].размерСтроки = datacache[i-1].размерСтроки;
        } else numCacheУровеньs = i+1;
    }
}




debug (Cpuid)
{
        private import io.Stdout;

        проц main()
        {
            Стдвыв.форматнс ("{}, {} threads, {} cores", процессор, threadsPerCPU, coresPerCPU);
        }
}
