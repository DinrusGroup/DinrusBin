/*******************************************************************************
        copyright:      Copyright (c) 2008. Fawzi Mohamed
        license:        BSD стиль: $(LICENSE)
        version:        Initial release: July 2008
        author:         Fawzi Mohamed
*******************************************************************************/
module math.random.engines.CMWC;
private import Целое=text.convert.Integer;

/+ CMWC генератор случайных чисел,
+ Marisaglia, Journal of Modern Applied Statistical Methods (2003), vol.2,No.1,p 2-13
+ a simple и fast RNG that проходки все statistical tests, имеется a large сей, и is very fast
+ By default ComplimentaryMultИПlyWithCarry with r=1024, a=987769338, b=2^32-1, период a*b^r>10^9873
+ This is the движок, *never* use it directly, always use it though a СлуччисГ class
+/
struct CMWC(бцел cmwc_r=1024U,бдол cmwc_a=987769338UL){
    бцел[cmwc_r] cmwc_q=void;
    бцел cmwc_i=cmwc_r-1u;
    бцел cmwc_c=123;
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

/// some variations, the первый имеется a период of ~10^39461, the первый число (r) is basically the размер of the сей
/// (и все bit образцы of that размер are guarenteed в_ crop up in the период), the период is 2^(32*r)*a
alias CMWC!(4096U,18782UL)     CMWC_4096_1;
alias CMWC!(2048U,1030770UL)   CMWC_2048_1;
alias CMWC!(2048U,1047570UL)   CMWC_2048_2;
alias CMWC!(1024U,5555698UL)   CMWC_1024_1;
alias CMWC!(1024U,987769338UL) CMWC_1024_2;
alias CMWC!(512U,123462658UL)  CMWC_512_1;
alias CMWC!(512U,123484214UL)  CMWC_512_2;
alias CMWC!(256U,987662290UL)  CMWC_256_1;
alias CMWC!(256U,987665442UL)  CMWC_256_2;
alias CMWC!(128U,987688302UL)  CMWC_128_1;
alias CMWC!(128U,987689614UL)  CMWC_128_2;
alias CMWC!(64U ,987651206UL)  CMWC_64_1;
alias CMWC!(64U ,987657110UL)  CMWC_64_2;
alias CMWC!(32U ,987655670UL)  CMWC_32_1;
alias CMWC!(32U ,987655878UL)  CMWC_32_2;
alias CMWC!(16U ,987651178UL)  CMWC_16_1;
alias CMWC!(16U ,987651182UL)  CMWC_16_2;
alias CMWC!(8U  ,987651386UL)  CMWC_8_1;
alias CMWC!(8U  ,987651670UL)  CMWC_8_2;
alias CMWC!(4U  ,987654366UL)  CMWC_4_1;
alias CMWC!(4U  ,987654978UL)  CMWC_4_2;
alias CMWC_1024_2 CMWC_default;
