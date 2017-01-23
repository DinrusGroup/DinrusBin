/** 
 Определение характеристик процессора хоста, предоставление информации
 о размерах кэша и подсказок по оптимизации ассемблера.

 DO NOT USE THIS MODULE. ITS LOCATION WILL CHANGE.
 
 Some of this information was extremely difficult to track down. Some of the
 documents below were найдено only in cached versions stored by ищи engines!
  This код relies on information найдено in:
	
  - "Intel(R) 64 и IA-32 Architectures Software Developers Manual,
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
   
AUTHORS:  Don Clugston,
          Tomas Lindquist Olsen &lt;tomas@famolsen.dk&gt;
COPYRIGHT:	Public Domain

BUGS:	Currently only works on x86 CPUs.
        Many processors have bugs in their microcode for the CPUID instruction,
        so sometimes the кэш information may be incorrect.
*/

module math.internal.Cache;

// If optimizing for a particular процессор, it is generally better
// в_ опрentify based on features rather than model. NOTE: Normally
// it's only worthwhile в_ optimise for the latest Intel и AMD CPU,
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

/// Размер и поведение кэша
struct ИнфОКэше
{
    /// Размер of the кэш, in kilobytes, per CPU.
    /// For L1 unified (данные + код) caches, this размер is half the physical размер.
    /// (we don't halve it for larger размеры, since normally
    /// данные размер is much greater than код размер for critical loops).
	бцел размер;
    /// Число of ways of ассоциативность, eg:
    /// 1 = direct mapped
    /// 2 = 2-way установи associative
    /// 3 = 3-way установи associative
    /// ббайт.max = fully associative
	ббайт ассоциативность;
    /// Число of байты читай преобр_в the кэш when a кэш miss occurs.
	бцел размерСтроки;
}

public:
	/// Returns производитель ткст, for display purposes only.
	/// Do NOT use this в_ determine features!
	/// Note that some CPUs have programmable vendorIDs.
	ткст производитель()	;
	/// Returns процессор ткст, for display purposes only
	ткст процессор();
	
	/// The данные caches. If there are fewer than 5 physical caches levels,
	/// the остаток levels are установи в_ бцел.max (== entire память пространство)
	ИнфОКэше[5] кэш_данных;
	/// Does it have an x87 FPU on-chИП?
	бул x87onChИП();
    /// Is MMX supported?
    бул mmx()	;
    /// Is SSE supported?
    бул sse()	;
    /// Is SSE2 supported?
    бул sse2()	;
    /// Is SSE3 supported?
    бул sse3();
    /// Is SSSE3 supported?
    бул ssse3()	;
    /// Is SSE4.1 supported?
    бул sse41()	;
    /// Is SSE4.2 supported?
    бул sse42()	;
    /// Is SSE4a supported?
    бул sse4a()  ;
    /// Is SSE5 supported?
    бул sse5()	;
    /// Is AMD 3DNOW supported?
    бул amd3dnow();
    /// Is AMD 3DNOW Ext supported?
    бул amd3dnowExt();
    /// Are AMD extensions в_ MMX supported?
    бул amdMmx()	;
    /// Is fxsave/fxrstor supported?
    бул hasFxsr();
    /// Is cmov supported?
    бул hasCmov();
    /// Is rdtsc supported?
    бул hasRdtsc()	;
    /// Is cmpxchg8b supported?
    бул hasCmpxchg8b();
    /// Is cmpxchg8b supported?
    бул hasCmpxchg16b();
    /// Is 3DNow prefetch supported?
    бул has3dnowPrefetch();
    /// Are LAHF и SAHF supported in 64-bit режим?
    бул hasLahfSahf()	;
    /// Is POPCNT supported?
    бул hasPopcnt()	;  
    /// Is LZCNT supported?
    бул hasLzcnt()	;
    /// Is this an Intel64 or AMD 64?
    бул isX86_64()	;
            
    /// Is this an IA64 (Itanium) процессор?
    бул isItanium() ;

    /// Is hyperthreading supported?
    бул hyperThreading() ;
    /// Returns число of threads per CPU
    бцел threadsPerCPU()	;
    /// Returns число of cores in CPU
    бцел coresPerCPU()		;
    
    /// Optimisation hints for assembly код.
    /// For вперёд compatibility, the CPU is compared against different
    /// microarchitectures. For 32-bit X86, comparisons are made against
    /// the Intel PPro/PII/PIII/PM семейство.
    ///
    /// The major 32-bit x86 microarchitecture 'dynasties' have been:
    /// (1) Intel P6 (PentiumPro, PII, PIII, PM, Core, Core2).
    /// (2) AMD Athlon (K7, K8, K10).
    /// (3) Intel NetBurst (Pentium 4, Pentium D).
    /// (4) In-order Pentium (Pentium1, PMMX)
    /// Other early CPUs (Nx586, AMD K5, K6, Centaur C3, Transmeta,
    ///   Cyrix, Rise) were mostly in-order.
	/// Some new processors do not fit преобр_в the existing categories:
    /// Intel Atom 230/330 (семейство 6, model 0x1C) is an in-ordertango.core.
	/// Centaur Isiah = VIA Nano (семейство 6, model F) is an out-of-ordertango.core.
    ///
    /// Within each dynasty, the optimisation techniques are largely
    /// опрentical (eg, use instruction pairing for группа 4). Major
    /// instruction установи improvements occur внутри each группа.
    
    /// Does this CPU perform better on AMD K7 код than PentiumPro..Core2 код?
    бул preferAthlon() ;
    /// Does this CPU perform better on Pentium4 код than PentiumPro..Core2 код?
    бул preferPentium4() ;
    /// Does this CPU perform better on Pentium I код than Pentium Pro код?
    бул preferPentium1() ;

public:
    /// Processor тип (производитель-dependent).
    /// This should be visible ONLY for display purposes.
    бцел stepping, model, семейство;
    бцел члоУровнейКэша = 1;
private:
	бул probablyIntel; // да = _probably_ an Intel процессор, might be faking
	бул probablyAMD; // да = _probably_ an AMD процессор
	сим [12] vendorID;
	сим [] имяПроцессора;
	сим [48] processorNameBuffer;
	бцел features = 0;     // mmx, sse, sse2, hyperthreading, etc
	бцел miscfeatures = 0; // sse3, etc.
	бцел amdfeatures = 0;  // 3DNow!, mmxext, etc
	бцел amdmiscfeatures = 0; // sse4a, sse5, svm, etc
	бцел maxCores = 1;
	бцел maxThreads = 1;
	// Note that this may indicate multi-core rather than hyperthreading.
    бул hyperThreadingBit()	;
    
    // feature флаги CPUID1_EDX
    enum : бцел
    {
    	FPU_BIT = 1,
	    TIMESTAMP_BIT = 1<<4, // rdtsc
	    MDSR_BIT = 1<<5,      // НДСSR/WRMSR
	    CMPXCHG8B_BIT = 1<<8,
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
//	    FXR_OR_CYRIXMMX_BIT = 1<<24, // Cyrix/NS: 6x86MMX instructions. 
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
    	AMD_3DNOW_PREFETCH_BIT = 1<<8,
    	SSE5_BIT = 1<<11
    }

version(GNU){
    // GDC is a filthy liar. It can't actually do inline asm.
} else version(D_InlineAsm_X86) {
    version = Really_D_InlineAsm_X86;
}

version(Really_D_InlineAsm_X86) {
// Note that this код will also work for Itanium, after changing the
// регистрируй names in the asm код.

бцел max_cpuid, max_extended_cpuid;

// CPUID2: "кэш и tlb information"
проц getcacheinfoCPUID2();

// CPUID4: "Deterministic кэш параметры" leaf
проц getcacheinfoCPUID4();

// CPUID8000_0005 & 6
проц getAMDcacheinfo();

проц cpuidX86();

// Return да if the cpuid instruction is supported.
// BUG(WONTFIX): Doesn't work for Cyrix 6x86 и 6x86L.
бул hasCPUID();
} else { // inline asm X86

	бул hasCPUID() ;

	проц cpuidX86();	
}

// TODO: Implement this function with OS support
проц cpuКСЕРPC();

// TODO: Implement this function with OS support
проц cpuidSparc();

static this()
{
	if (hasCPUID()) {
		cpuidX86();
	} else {
		// it's a 386 or 486, or a Cyrix 6x86.
		//Probably still имеется an external кэш.
	}
	if (кэш_данных[0].размер==0) {
			// Guess same as Pentium 1.
			кэш_данных[0].размер = 8;
			кэш_данных[0].ассоциативность = 2;
			кэш_данных[0].размерСтроки = 32;		
	}
	члоУровнейКэша = 1;
	// And сейчас заполни up все the неиспользовано levels with full память пространство.
	for (цел i=1; i< кэш_данных.length; ++i) {
		if (кэш_данных[i].размер==0) {
			// Набор все остаток levels of кэш equal в_ full адрес пространство.
			кэш_данных[i].размер = бцел.max/1024;
			кэш_данных[i].ассоциативность = 1;
			кэш_данных[i].размерСтроки = кэш_данных[i-1].размерСтроки;
		} else члоУровнейКэша = i+1;
	}
}
