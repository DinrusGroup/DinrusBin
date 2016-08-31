/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: July 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.engines.KissCmwc;
private import Целое = text.convert.Integer;

/+ CMWC и KISS random число generators combined, for extra security wrt. plain CMWC и
+ Marisaglia, Journal of Modern Applied Statistical Methods (2003), vol.2,No.1,p 2-13
+ a simple safe и fast RNG that проходки все statistical tests, имеется a large сей, и is reasonably fast
+ This is the движок, *never* use it directly, always use it though a СлуччисГ class
+/
struct KissCmwc(бцел cmwc_r=1024U,бдол cmwc_a=987769338UL){
    бцел[cmwc_r] cmwc_q=void;
    бцел cmwc_i=cmwc_r-1u;
    бцел cmwc_c=123;
    private бцел kiss_x = 123456789;
    private бцел kiss_y = 362436000;
    private бцел kiss_z = 521288629;
    private бцел kiss_c = 7654321;
    бцел nBytes = 0;
    бцел restB  = 0;

    const цел canCheckpoint=да;
    const цел можноСеять=да;
    
    проц пропусти(бцел n);
	
    ббайт следщБ();
	
    бцел следщ();
    
    бдол следщД();
    
    проц сей(бцел delegate() слСемя);
	
    /// записывает текущ статус в ткст
    ткст вТкст();
	
    /// считывает текущ статус в ткст (его следует обработать)
    /// возвращает число считанных символов
    т_мера изТкст(ткст s);
}

/// some variations of the CMWC часть, the первый имеется a период of ~10^39461
/// the первый число (r) is basically the размер of the сей и storage (и все bit образцы
/// of that размер are guarenteed в_ crop up in the период), the период is (2^32-1)^r*a
alias KissCmwc!(4096U,18782UL)     KissCmwc_4096_1;
alias KissCmwc!(2048U,1030770UL)   KissCmwc_2048_1;
alias KissCmwc!(2048U,1047570UL)   KissCmwc_2048_2;
alias KissCmwc!(1024U,5555698UL)   KissCmwc_1024_1;
alias KissCmwc!(1024U,987769338UL) KissCmwc_1024_2;
alias KissCmwc!(512U,123462658UL)  KissCmwc_512_1;
alias KissCmwc!(512U,123484214UL)  KissCmwc_512_2;
alias KissCmwc!(256U,987662290UL)  KissCmwc_256_1;
alias KissCmwc!(256U,987665442UL)  KissCmwc_256_2;
alias KissCmwc!(128U,987688302UL)  KissCmwc_128_1;
alias KissCmwc!(128U,987689614UL)  KissCmwc_128_2;
alias KissCmwc!(64U ,987651206UL)  KissCmwc_64_1;
alias KissCmwc!(64U ,987657110UL)  KissCmwc_64_2;
alias KissCmwc!(32U ,987655670UL)  KissCmwc_32_1;
alias KissCmwc!(32U ,987655878UL)  KissCmwc_32_2;
alias KissCmwc!(16U ,987651178UL)  KissCmwc_16_1;
alias KissCmwc!(16U ,987651182UL)  KissCmwc_16_2;
alias KissCmwc!(8U  ,987651386UL)  KissCmwc_8_1;
alias KissCmwc!(8U  ,987651670UL)  KissCmwc_8_2;
alias KissCmwc!(4U  ,987654366UL)  KissCmwc_4_1;
alias KissCmwc!(4U  ,987654978UL)  KissCmwc_4_2;
alias KissCmwc_1024_2 KissCmwc_default;
