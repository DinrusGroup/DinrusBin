/** 
 Identify the characteristics of the хост CPU, provопрing information
 about cache sizes and assembly optimisation hints.
 
 Some of this information was extremely difficult в_ track down. Some of the
 documents below were найдено only in cached versions stored by search engines!
  This код relies on information найдено in:
    
  - "Intel(R) 64 and IA-32 Architectures Software Developers Manual,
      Volume 2A: Instruction Набор Reference, A-M" (2007).
  - "AMD CPUID Specification", Advanced Micro Devices, Rev 2.28 (2008).
  - "AMD Processor Recognition Application Note For Processors Prior в_ AMD Family 0Fh Processors", Advanced Micro Devices, Rev 3.13 (2005).
  - "AMD Geode(TM) GX Processors Данные Book", AMD, Publication ID 31505E, (2005).
  - "AMD K6 Processor Code Optimisation", Advanced Micro Devices, Rev D (2000).
  - "Application note 106: Software Customization for the 6x86 Family", Cyrix Corporation, Rev 1.5 (1998)
  - http://ftp.intron.ac/pub/document/cpu/cpuid.htm
  - "Geode(TM) GX1 Processor Series Low Power Integrated X86 Solution", National Semiconductor, (2002)
  - "The VIA Isaiah Architecture", G. Glenn Henry, Centaur Technology, Inc (2008).
  - http://www.sandpile.org/ia32/cpuid.htm
  - http://grafi.ii.pw.edu.pl/gbm/x86/cpuid.html
  - "What every programmer should know about память", Ulrich Depper, Red Hat, Inc. 
     (2007). 
   
AUTHORS:  Don Clugston,
          Tomas Lindquist Olsen &lt;tomas@famolsen.dk&gt;
          Fawzi Mohamed
COPYRIGHT:  Public Domain

BUGS:   Currently only works on x86 CPUs.
        Many processors have bugs in their microcode for the CPUID instruction,
        so sometimes the cache information may be incorrect.
*/

module core.Cpuid;

version(GNU){
    // GDC is a filthy liar. It can't actually do inline asm.
} else version(D_InlineAsm_X86) {
    version = Really_D_InlineAsm_X86;
}

version(X86) {
    version=X86_CPU;
} else version(X86_64) {
    version=X86_CPU;
} else version ( PPC64 )
{
    version=PPC_CPU;
} else version ( PPC ) {
    version=PPC_CPU;
} else version(ARM){
} else version(SPARC){
} else {
    static assert(0,"неизвестное cpu семейство");
}

/// Cache размер and behaviour
struct ИнфОКэше
{
    /// Size of the cache, in kilobytes, per CPU.
    /// For L1 unified (данные + код) caches, this размер is half the physical размер.
    /// (we don't halve it for larger sizes, since normally
    /// данные размер is much greater than код размер for critical loops).
    т_мера размер;
    /// Число of ways of ассоциативность, eg:
    /// 1 = direct mapped
    /// 2 = 2-way установи associative
    /// 3 = 3-way установи associative
    /// ббайт.max = fully associative
    ббайт ассоциативность;
    /// Число of байты читай преобр_в the cache when a cache miss occurs.
    бцел размерСтроки;
    /// как many threads совместно the cache, 0=unkown
    бцел чСовместнНитей;
    /// if you cannot really trust these numbers
    бул гадай;
    проц сотри(){
        размер=cast(т_мера)0;
        ассоциативность=1;
        размерСтроки=0;
        чСовместнНитей=0;
        гадай=да;
    }
}

/// the main тип of cpu
static ИнфОЦПБ mainCpu;
static this(){
    version(X86_CPU){
        mainCpu=new ИнфОЦПБX86();
        mainCpu.дайДанныеОЦпб();
    } else version(PPC_CPU){
        mainCpu=new ИнфОЦПБPpc();
    } else version(ARM){
        mainCpu=new ИнфОЦПБArm();
    } else version(SPARC){
        mainCpu=new ИнфОЦПБSparc();
    }
}

/// the current тип of cpu
ИнфОЦПБ текущийЦпб() { return mainCpu; }
/// if the system есть only one kind of cpu (at the moment hardcoded в_ да)
бул уникаленТипЦпб_ли() { return да; }

/// information on a cpu
///
/// if you think x86,sparc,arm,ppc,... should be always defined, but throw or return пусто
/// post a ticket explaining why
class ИнфОЦПБ{
protected:
    /// The данные caches. If there are fewer than 5 physical caches levels,
    /// the remaining levels are установи в_ т_мера.max/1024 (== entire память пространство)
    /// сделай this a function?
    ИнфОКэше[5] кэшДанных;
    /// cache levels
    бцел члоУровнейКэша;
    /// производитель имя (only for display purposes)
    сим [] имяПроизводителя;
    /// имя of the процессор (only for display purposes)
    сим [] имяПроцессора;
    /// tries в_ получи valid данные из_ the current cpu, return нет if it fails
    бул дайДанныеОЦпб(){
        сотри();
        фиксируйКэш();
        return нет;
    }
public:
    this(){
        this.сотри();
    }
    /// Returns производитель ткст, for display purposes only.
    /// Do NOT use this в_ determine features!
    /// Note that some CPUs have programmable vendorIDs.
    ткст производитель() { return имяПроизводителя; }
    /// Returns процессор ткст, for display purposes only
    ткст процессор() { return имяПроцессора; }
    /// Is hyperthreading supported?
    бул hyperThreading() {
        return threadsPerCPU()>coresPerCPU();
    }
    /// Returns число of threads per CPU
    бцел threadsPerCPU(){
        return 1;
    }
    /// Returns число of cores in CPU
    бцел coresPerCPU(){
        return 1;
    }
    /// clears инфо stored in this объект
    проц сотри(){
        foreach (ref el;кэшДанных){
            el.сотри();
        }
        члоУровнейКэша=0;
        имяПроизводителя="unkown";
        имяПроцессора="unkown";
    }
    /// duplicates this объект
    ИнфОЦПБ dup(){
        ИнфОЦПБ newInfo=cast(ИнфОЦПБ)this.classinfo.create();
        newInfo[]=this;
        return newInfo;
    }
    /// copies данные из_ one объект в_ the другой
    ИнфОЦПБ opSliceAssign(ИнфОЦПБ другой){
        assert(другой.classinfo is this.classinfo);
        //кэшДанных.length=другой.кэшДанных.length;
        кэшДанных[]=другой.кэшДанных;
        члоУровнейКэша=другой.члоУровнейКэша;
        имяПроизводителя=другой.имяПроизводителя;
        имяПроцессора=другой.имяПроцессора;
        return this;
    }
    /// sets unset values in cache инфо
    protected проц фиксируйКэш(){
        if (кэшДанных[0].размер==0) {
                // Guess same as Pentium 1.
                кэшДанных[0].размер = 8;
                кэшДанных[0].ассоциативность = 2;
                кэшДанных[0].размерСтроки = 32; 
                кэшДанных[0].гадай=да;    
        }
        if (кэшДанных[0].чСовместнНитей==0){
            кэшДанных[0].чСовместнНитей=threadsPerCPU()/coresPerCPU();
        }
        члоУровнейКэша = 1;
        // And сейчас заполни up все the unused levels with full память пространство.
        for (цел i=1; i< кэшДанных.length; ++i) {
            if (кэшДанных[i].размер==0) {
                // Набор все remaining levels of cache equal в_ full адрес пространство.
                кэшДанных[i].размер = т_мера.max/1024;
                кэшДанных[i].ассоциативность = 1;
                кэшДанных[i].размерСтроки = кэшДанных[i-1].размерСтроки;
                кэшДанных[i].гадай=нет;   
            } else {
                члоУровнейКэша = i+1;
            }
            if (кэшДанных[i].чСовместнНитей==0){
                кэшДанных[i].чСовместнНитей=threadsPerCPU();
            }
        }
    }
    version(X86_CPU){
        /// utility метод в_ получи information about x86 processors
        final ИнфОЦПБX86 x86(){
            if (auto рез=cast(ИнфОЦПБX86)this)
                return рез;
            throw new Исключение("non x86 cpu",__FILE__,__LINE__);
        }
    }
    version(PPC){
        /// utility метод в_ получи information about PPC processors
        final ИнфОЦПБPpc ppc(){
            if (auto рез=cast(ИнфОЦПБPpc)this)
                return рез;
            throw new Исключение("non ppc cpu",__FILE__,__LINE__);
        }
    }
    version(ARM){
        /// utility метод в_ получи information about arm processors
        final ИнфОЦПБArm arm(){
            if (auto рез=cast(ИнфОЦПБArm)this)
                return рез;
            throw new Исключение("non arm cpu",__FILE__,__LINE__);
        }
    }
    version(SPARC){
        /// utility метод в_ получи information about sparc processors
        final ИнфОЦПБSparc sparc(){
            if (auto рез=cast(ИнфОЦПБSparc)this)
                return рез;
            throw new Исключение("non sparc cpu",__FILE__,__LINE__);
        }
    }
}

/// If optimizing for a particular процессор, it is generally better
/// в_ опрentify based on features rather than model. NOTE: Normally
/// it's only worthwhile в_ optimise for the latest Intel and AMD CPU,
/// with a backup for другой CPUs.
/// Pentium    -- preferPentium1()
/// PMMX       --   + mmx()
/// PPro       -- default
/// PII        --   + mmx()
/// PIII       --   + mmx() + sse()
/// PentiumM   --   + mmx() + sse() + sse2()
/// Pentium4   -- preferPentium4()
/// PentiumD   --   + isX86_64()
/// Core2      -- default + isX86_64()
/// AMD K5     -- preferPentium1()
/// AMD K6     --   + mmx()
/// AMD K6-II  --   + mmx() + 3dnow()
/// AMD K7     -- preferAthlon()
/// AMD K8     --   + sse2()
/// AMD K10    --   + isX86_64()
/// Cyrix 6x86 -- preferPentium1()
///    6x86MX  --   + mmx()
final class ИнфОЦПБX86: ИнфОЦПБ {
private:
    бул probablyIntel; // да = _probably_ an Intel процессор, might be faking
    бул probablyAMD; // да = _probably_ an AMD процессор
    бцел features;     // mmx, sse, sse2, hyperthreading, etc
    бцел miscfeatures; // sse3, etc.
    бцел amdfeatures;  // 3DNow!, mmxext, etc
    бцел amdmiscfeatures; // sse4a, sse5, svm, etc
    бцел maxCores;
    бцел maxThreads;
    бцел max_cpuid, max_extended_cpuid;
public:
    // Note that this may indicate multi-core rather than hyperthreading.
    бул hyperThreadingBit()    { return (features&HTT_BIT)!=0;}
    /// Processor тип (производитель-dependent).
    /// This should be visible ONLY for display purposes.
    бцел stepping, model, семейство;
    /// Does it have an x87 FPU on-chИП?
    бул x87onChИП()          {return (features&FPU_BIT)!=0;}
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
    бул sse4a()            {return (amdmiscfeatures&SSE4A_BIT)!=0;}
    /// Is SSE5 supported?
    бул sse5()         {return (amdmiscfeatures&SSE5_BIT)!=0;}
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
    бцел threadsPerCPU()    { return maxThreads; }
    /// Returns число of cores in CPU
    бцел coresPerCPU()      { return maxCores; }
    
    /// Optimisation hints for assembly код.
    /// For forward compatibility, the CPU is compared against different
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
    /// instruction установи improvements occur within each группа.
    
    /// Does this CPU perform better on AMD K7 код than PentiumPro..Core2 код?
    бул preferAthlon() { return probablyAMD && семейство >=6; }
    /// Does this CPU perform better on Pentium4 код than PentiumPro..Core2 код?
    бул preferPentium4() { return probablyIntel && семейство == 0xF; }
    /// Does this CPU perform better on Pentium I код than Pentium Pro код?
    бул preferPentium1() { return семейство < 6 || (семейство==6 && model < 0xF && !probablyIntel); }
    this(){
        super();
    }
    override проц сотри(){
        super.сотри();
        stepping=0;
        model=0;
        семейство=0;
        probablyIntel=нет;
        probablyAMD=нет;
        имяПроизводителя="UnknownX86";
        имяПроцессора="UnknownX86";
        features=0;
        miscfeatures=0;
        amdmiscfeatures=0;
        amdfeatures=0;
        maxCores=1;
        maxThreads=1;
    }
    /// copies данные из_ one объект в_ the другой
    ИнфОЦПБX86 opSliceAssign(ИнфОЦПБ o){
        auto другой=cast(ИнфОЦПБX86)o;
        assert(другой !is пусто);
        super.opSliceAssign(o);
        stepping=другой.stepping;
        model=другой.model;
        семейство=другой.семейство;
        probablyIntel=другой.probablyIntel;
        probablyAMD=другой.probablyAMD;
        имяПроизводителя=другой.имяПроизводителя;
        имяПроцессора=другой.имяПроцессора;
        features=другой.features;
        miscfeatures=другой.miscfeatures;
        amdmiscfeatures=другой.amdmiscfeatures;
        amdfeatures=другой.amdfeatures;
        maxCores=другой.maxCores;
        maxThreads=другой.maxThreads;
        return this;
    }
    
    /// auto конфиг for current cpu
    protected override бул дайДанныеОЦпб(){
        if (hasCPUID()) {
            cpuidX86();
            фиксируйКэш();
            return да;
        } else {
            // it's a 386 or 486, or a Cyrix 6x86.
            //Probably still есть an external cache.
            сотри();
            фиксируйКэш();
            return нет;
        }
    }
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
        AMD_3DNOW_PREFETCH_BIT = 1<<8,
        SSE5_BIT = 1<<11
    }


    version(Really_D_InlineAsm_X86) {
        // Note that this код will also work for Itanium, after changing the
        // регистрируй names in the asm код.

        // CPUID2: "cache and tlb information"
        проц getcacheinfoCPUID2()
        {
            // CPUID2 is a dog's breakfast. What was Intel thinking???
            // We are only interested in the данные caches
            проц расшифруйИдцпб2(ббайт x) {
                if (x==0) return;
                // Values из_ http://www.sandpile.org/ia32/cpuid.htm.
                // Includes Itanium and non-Intel CPUs.
                //
                ббайт [] опрs = [
                    0x0A, 0x0C, 0x2C, 0x60, 0x0E, 0x66, 0x67, 0x68,
                    // уровень 2 cache
                    0x41, 0x42, 0x43, 0x44, 0x45, 0x78, 0x79, 0x7A, 0x7B, 0x7C, 0x7D, 0x7F,
                    0x82, 0x83, 0x84, 0x85, 0x86, 0x87, 0x49, 0x4E,
                    0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x48, 0x80, 0x81,
                    // уровень 3 cache
                    0x22, 0x23, 0x25, 0x29, 0x46, 0x47, 0x4A, 0x4B, 0x4C, 0x4D
                ];
                бцел [] sizes = [
                    8, 16, 32, 16, 24, 8, 16, 32,
                    128, 256, 512, 1024, 2048, 1024, 128, 256, 512, 1024, 2048, 512,
                    256, 512, 1024, 2048, 512, 1024, 4096, 6*1024,
                    128, 192, 128, 256, 384, 512, 3072, 512, 128,           
                    512, 1024, 2048, 4096, 4096, 8192, 6*1024, 8192, 12*1024, 16*1024
                ];
            // CPUBUG: Pentium M reports 0x2C but tests show it is only 4-way associative
                ббайт [] ways = [
                    2, 4, 8, 8, 6, 4, 4, 4,
                    4, 4, 4, 4, 4, 4, 8, 8, 8, 8, 8, 2,
                    8, 8, 8, 8, 4, 8, 16, 24,
                    4, 6, 2, 4, 6, 4, 12, 8, 8,
                    4, 8, 8, 8, 4, 8, 12, 16, 12, 16
                ];
                enum { FIRSTDATA2 = 8, FIRSTDATA3 = 28+9 }
                for (цел i=0; i< опрs.length; ++i) {
                    if (x==опрs[i]) {
                        цел уровень = i< FIRSTDATA2 ? 0: i<FIRSTDATA3 ? 1 : 2;
                        if (x==0x49 && семейство==0xF && model==0x6) уровень=2;
                        кэшДанных[уровень].размер=sizes[i];
                        кэшДанных[уровень].ассоциативность=ways[i];
                        if (уровень == 3 || x==0x2C || (x>=0x48 && x<=0x80) 
                            || x==0x86 || x==0x87
                            || (x>=0x66 && x<=0x68) || (x>=0x39 && x<=0x3E) ){
                            кэшДанных[уровень].размерСтроки = 64;
                        } else кэшДанных[уровень].размерСтроки = 32;
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
                        кэшДанных[0].размер=8;
                        кэшДанных[0].ассоциативность=4;
                        кэшДанных[0].размерСтроки=16;
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
                    расшифруйИдцпб2(cast(ббайт)(a[c] & 0xFF));
                    расшифруйИдцпб2(cast(ббайт)((a[c]>>8) & 0xFF));
                    расшифруйИдцпб2(cast(ббайт)((a[c]>>16) & 0xFF));
                    расшифруйИдцпб2(cast(ббайт)((a[c]>>24) & 0xFF));
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
                if (уровень > кэшДанных.length) continue; // ignore deep caches
                кэшДанных[уровень].ассоциативность = a & 0x200 ? ббайт.max :cast(ббайт)((b>>22)+1);
                кэшДанных[уровень].размерСтроки = (b & 0xFFF)+ 1; // system coherency строка размер
                бцел line_partitions = ((b >> 12)& 0x3FF) + 1;
                // Size = число of sets * ассоциативность * cachelinesize * linepartitions
                // and must преобразуй в_ Kb, also divопрing by the число of cores.
                бдол sz = (кэшДанных[уровень].ассоциативность< ббайт.max)? number_of_sets *
                    кэшДанных[уровень].ассоциативность : number_of_sets;        
                кэшДанных[уровень].размер = cast(бцел)(
                        (sz * кэшДанных[уровень].размерСтроки * line_partitions ) / (numcores *1024));
                if (уровень == 0 && (a&0xF)==3) {
                    // Halve the размер for unified L1 caches
                    кэшДанных[уровень].размер/=2;
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

            кэшДанных[0].размер = ( (c5>>24) & 0xFF);
            кэшДанных[0].ассоциативность = cast(ббайт)( (c5 >> 16) & 0xFF);
            кэшДанных[0].размерСтроки = c5 & 0xFF;

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
                кэшДанных[1].размер = (c6>>16) & 0xFFFF;
                кэшДанных[1].ассоциативность = assocmap[(c6>>12)&0xF];
                кэшДанных[1].размерСтроки = c6 & 0xFF;
        
                // The L3 cache значение is TOTAL, not pertango.core.
                кэшДанных[2].размер = ((d6>>18)*512)/numcores; // could be up в_ 2 * this, -1.
                кэшДанных[2].ассоциативность = assocmap[(d6>>12)&0xF];
                кэшДанных[2].размерСтроки = d6 & 0xFF;
            }
        }


        проц cpuidX86()
        {
            сим [12] vendorID;
            сим [48] processorNameBuffer;
            бцел m_1, m_2;
            сим * venptr = vendorID.ptr;
            asm {
                mov EAX, 0;
                cpuid;
                mov m_1, EAX;
                mov EAX, venptr;
                mov [EAX], EBX;
                mov [EAX + 4], EDX;
                mov [EAX + 8], ECX;
                mov EAX, 0x8000_0000;
                cpuid;
                mov m_2, EAX;
            }
            max_cpuid=m_1;
            max_extended_cpuid=m_2;
            
            probablyIntel = vendorID == "GenuineIntel";
            probablyAMD = vendorID == "AuthenticAMD";
            имяПроизводителя=vendorID.dup;
            бцел a, b, c, d;
            бцел apic = 0; // brand индекс, apic опр
            asm {
                mov EAX, 1; // model, stepping
                cpuid;
                mov a, EAX;
                mov apic, EBX;
                mov m_1, ECX;
                mov m_2, EDX;
            }
            miscfeatures=m_1;
            features=m_2;
            amdfeatures = 0;
            amdmiscfeatures = 0;
            if (max_extended_cpuid >= 0x8000_0001) {
                asm {
                    mov EAX, 0x8000_0001;
                    cpuid;
                    mov m_1, ECX;
                    mov m_2, EDX;
                }
                amdmiscfeatures=m_1;
                amdfeatures=m_2;
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
                имяПроцессора = processorNameBuffer[старт..$-конец].dup;
            } else {
                имяПроцессора = "Unknown CPU";
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
            кэшДанных[0].размер = 0;
            if (max_cpuid<2 || !probablyIntel) {
                if (max_extended_cpuid >= 0x8000_0005) {
                    getAMDcacheinfo();
                } else if (probablyAMD) {       
                    // According в_ AMDProcRecognitionAppNote, this means CPU
                    // K5 model 0, or Am5x86 (model 4), or Am4x86DX4 (model 4)
                    // Am5x86 есть 16Kb 4-way unified данные & код cache.
                    кэшДанных[0].размер = 8;
                    кэшДанных[0].ассоциативность = 4;
                    кэшДанных[0].размерСтроки = 32;     
                } else {
                    // Some obscure CPU.
                    // Values for Cyrix 6x86MX (семейство 6, model 0)
                    кэшДанных[0].размер = 64;
                    кэшДанных[0].ассоциативность = 4;
                    кэшДанных[0].размерСтроки = 32;     
                }
            }   
            if ((кэшДанных[0].размер == 0) && max_cpuid>=4) {
                getcacheinfoCPUID4();
            }
            if ((кэшДанных[0].размер == 0) && max_cpuid>=2) {     
                getcacheinfoCPUID2();
            }
            if (кэшДанных[0].размер == 0) {
                // Pentium, PMMX, late model 486, or an obscure CPU
                if (mmx) { // Pentium MMX. Also есть 8kB код cache.
                    кэшДанных[0].размер = 16;
                    кэшДанных[0].ассоциативность = 4;
                    кэшДанных[0].размерСтроки = 32;     
                } else { // Pentium 1 (which also есть 8kB код cache)
                         // or 486.
                    // Cyrix 6x86: 16, 4way, 32 linesize
                    кэшДанных[0].размер = 8;
                    кэшДанных[0].ассоциативность = 2;
                    кэшДанных[0].размерСтроки = 32;
                }       
            }
            if (hyperThreadingBit) maxThreads = (apic>>>16) & 0xFF;
            else maxThreads = maxCores;
        }

        // Return да if the cpuid instruction is supported.
        // BUG(WONTFIX): Doesn't work for Cyrix 6x86 and 6x86L.
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
                кэшДанных[0].размер = 8;
                кэшДанных[0].ассоциативность = 2;
                кэшДанных[0].размерСтроки = 32;     
        }   
    }
}

final class ИнфОЦПБPpc: ИнфОЦПБ{
    бул hasfloatingpoint; // Floating Point Instructions
    бул hasaltivec;       // AltiVec Instructions
    бул hasgraphicsops;   // Graphics Operations
    бул has64bitops;      // 64-bit Instructions
    бул hasfsqrt;         // HW Floating Point Square Root Instruction
    бул hasstfiwx;        // Store Floating Point as Целое Word Indexed Instructions
    бул hasdcba;          // Данные Cache Block Размести Instruction
    бул hasdataПотокs;   // Данные Потокs Instructions
    бул hasdcbtПотокs;   // Данные Cache Block Touch Steams Instruction Form
    
    this(){
        super();
    }
    override проц сотри(){
        super.сотри();
        имяПроизводителя="Unknown";
        имяПроцессора="UnknownPPC";
        hasfloatingpoint= нет;
        hasaltivec      = нет;
        hasgraphicsops  = нет;
        has64bitops  = нет;
        hasfsqrt        = нет;
        hasstfiwx       = нет;
        hasdcba         = нет;
        hasdataПотокs  = нет;
        hasdcbtПотокs  = нет;
        фиксируйКэш();
    }
    override ИнфОЦПБPpc opSliceAssign(ИнфОЦПБ o){
        auto другой=cast(ИнфОЦПБPpc)o;
        assert(другой !is пусто);
        super.opSliceAssign(o);
        hasfloatingpoint= другой.hasfloatingpoint;
        hasaltivec      = другой.hasaltivec;
        hasgraphicsops  = другой.hasgraphicsops;
        has64bitops     = другой.has64bitops;
        hasfsqrt        = другой.hasfsqrt;
        hasstfiwx       = другой.hasstfiwx;
        hasdcba         = другой.hasdcba;
        hasdataПотокs  = другой.hasdataПотокs;
        hasdcbtПотокs  = другой.hasdcbtПотокs;
        return this;
    }
    enum PPC_Cputype:цел  { PPC601, PPC603, PPC603E, PPC604,
                 PPC604E, PPC620, PPCG3, PPCG4, PPCG5 };
    // TODO: Implement this function with OS support
    проц cpuКСЕРPC(PPC_Cputype cputype)
    {
        // TODO:
        // asm { mfpvr; } returns the CPU version but unfortunately it can
        // only be used in kernel режим. So OS support is required.
    
        // 601 есть a 8KB combined данные & код L1 cache.
        бцел sizes[] = [4, 8, 16, 16, 32, 32, 32, 32, 64];
        ббайт ways[] = [8, 2,  4,  4,  4,  8,  8,  8,  8];
        бцел L2size[]= [0, 0,  0,  0,  0,  0,  0,  256,  512];
        бцел L3size[]= [0, 0,  0,  0,  0,  0,  0,  2048,  0];
    
        кэшДанных[0].размер = sizes[cputype];
        кэшДанных[0].ассоциативность = ways[cputype]; 
        кэшДанных[0].размерСтроки = (cputype==PPC_Cputype.PPCG5)? 128 : 
            (cputype == PPC_Cputype.PPC620 || cputype == PPC_Cputype.PPCG3)? 64 : 32;
        кэшДанных[1].размер = L2size[cputype];
        кэшДанных[2].размер = L3size[cputype];
        кэшДанных[1].размерСтроки = кэшДанных[0].размерСтроки;
        кэшДанных[2].размерСтроки = кэшДанных[0].размерСтроки;
        фиксируйКэш();
    }
    
}

/// this should be expanded by someone using sparc
final class ИнфОЦПБSparc: ИнфОЦПБ{
    this(){ super(); }
    override проц сотри(){
        super.сотри();
        имяПроизводителя="неизвестное";
        имяПроцессора="неизвестныйSparc";
    }
    override ИнфОЦПБSparc opSliceAssign(ИнфОЦПБ o){
        auto другой=cast(ИнфОЦПБSparc)o;
        assert(другой !is пусто);
        super.opSliceAssign(o);
        return this;
    }
    enum Sparc_Cputype:цел {
        UltraSparcIIi, UltraSparcIII, UltraSparcIIIi,UltraSparcIV,
        UltraSparcIVplus, Sparc64V
    }
    // TODO: Implement this function with OS support
    проц cpuidSparc(Sparc_Cputype cputype)
    {
        т_мера l1,l2;
        ббайт way1,way2;
        switch(cputype){
        case Sparc_Cputype.UltraSparcIIi:
            l1 = 16;  way1=2; l2 = 512; way2=4;
            break;
        case Sparc_Cputype.UltraSparcIII:
            l1 = 64;  way1=4; l2= 4096; way2=4; // or l2=8192;
            break;
        case Sparc_Cputype.UltraSparcIIIi:
            l1 = 64;  way1=4; l2= 1024; way2=4;
            break;
        case Sparc_Cputype.UltraSparcIV:
            l1 = 64;  way1=4; l2= 16*1024; way2=1;
            break;
        case Sparc_Cputype.UltraSparcIVplus:
            l1 = 64;  way1=4; l2 = 2048; way2=1;
            кэшДанных[3].размер=32*1024;
            break;
        case Sparc_Cputype.Sparc64V:
            l1 = 128; way1=2; l2 = 4096; way2=4;
            break;
        default:
            throw new Исключение("не_годится cputype",__FILE__,__LINE__);
        }
        кэшДанных[1].размер=l1;
        кэшДанных[1].ассоциативность=way1;
        кэшДанных[2].размер=l2;
        кэшДанных[2].ассоциативность=way2;
        фиксируйКэш();
    }
}

