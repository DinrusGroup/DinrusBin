
/********************************************************************************
 *	Сгенерировано автоматически функцией генерации файла-макета импорта         *
 *  на основе предоставленного программистом массива импортируемых символов.    *
 *  Автор идеи и разработчик языка 'DinRus'                                     *
 *                                 ВИТАЛИЙ КУЛИЧ                                *
 *  Дата:7.11.2011 			                              Время: 19 ч. 46 мин. 	
 *******************************************************************************/

module lib.cosyne;
import dinrus;

const РАЗМЕР_ЦИЛИНДРА = 64;
const ЧЛОСЕМПЛОВ  = 3000*РАЗМЕР_ЦИЛИНДРА; 

проц грузи(Биб биб)
{


	вяжи(ксОшСооб)("Cosyne_ErrorMessage", биб);

	вяжи(ксДайТекВрем)("Cosyne_GetCurrentTime", биб);

	вяжи(ксИниц)("Cosyne_Init", биб);

	вяжи(ксГрузиИнстр)("Cosyne_LoadInstrument", биб);

	вяжи(ксВыклНоту)("Cosyne_NoteOff", биб);

	вяжи(ксВклНоту)("Cosyne_NoteOn", биб);

	вяжи(ксИзмениПарам)("Cosyne_ParamChange", биб);

	вяжи(ксИграйНоту)("Cosyne_PlayNote", биб);

	вяжи(ксПередай)("Cosyne_Render", биб);

	вяжи(ксИницСдл)("Cosyne_SDL_Init", биб);

	вяжи(ксСдлПауза)("Cosyne_SDL_Pause", биб);

	вяжи(ксСдлИграй)("Cosyne_SDL_Play", биб);

	вяжи(ксТерм)("Cosyne_Terminate", биб);

}

ЖанБибгр КОС;

extern (C)
{
alias ук COSYNE;

//extern (Windows):

	ткст0 function()
	ксОшСооб; 

	бцел function(COSYNE c)
	ксДайТекВрем; 

	COSYNE function(цел члоКаналов)
	ксИниц; 

	цел function(COSYNE c, цел канал, ткст0 фимя)
	ксГрузиИнстр; 

	цел function(COSYNE c, бцел время, цел канал, цел нота)
	ксВыклНоту; 

	цел function(COSYNE c, бцел время, цел канал, цел нота, цел скорость)
	ксВклНоту; 

	цел function(COSYNE c, бцел время, цел канал, цел члопарам, плав знач)
	ксИзмениПарам; 

	цел function(COSYNE c, бцел стартВрем, цел продолжитсть, цел канал, цел нота, цел скорость)
	ксИграйНоту; 

	проц function(COSYNE c, крат *буфер, цел чсемплов)
	ксПередай; 

	цел function(COSYNE c, цел размБуфера)
	ксИницСдл; 

	проц function()
	ксСдлПауза; 

	проц function()
	ксСдлИграй; 

	проц function(COSYNE c)
	ксТерм; 

}


проц заполниЗаголовок(ВавЗаг *вз, бцел семплрейт, бцел члоКаналов, бцел члоСемплов)
{

	вз.размерЦилиндраФмт = 16;
	вз.аудиоФормат = 1;		// PCM
	вз.члоКаналов = члоКаналов;
	вз.семплРейт = семплрейт;
	вз.битНаСемпл = 16;
	вз.раскладкаБлока = вз.члоКаналов * (вз.битНаСемпл / 8);
	вз.байтРейт = вз.семплРейт * вз.раскладкаБлока;	
    вз.размерЦилиндраДанных = члоСемплов * вз.раскладкаБлока;	
	вз.размер = 36 + вз.размерЦилиндраДанных;
}

проц пишиВав(ткст фимя, бцел семплрейт, крат[] семплы, бцел члосемплов)
{
	ВавЗаг вз;
    фук фу;

	заполниЗаголовок(&вз, семплрейт, 1, члосемплов);

    фу = откройфл(фимя, "wb");
    пишифл(&вз, вз.sizeof, 1, фу);
    пишифл(&семплы, крат.sizeof, члосемплов, фу);
    закройфл(фу);
}

const{
ткст ТЭСТСИНТ;
ткст СНЭРСИНТ;
ткст РЕЗОБАССИНТ;
ткст ПВМСИНТ;
ткст ПАД1СИНТ;
ткст ПАД2СИНТ;
ткст ФМОРГАНСИНТ;
ткст ФМБАССИНТ;
ткст ДИСТЛИДСИНТ;
ткст ГРЯЗНЫЙБАСССИНТ;
ткст ЩЕЛЧОКСИНТ;
ткст ЧИПРЕКТСИНТ;
ткст БУРУНДУКСИНТ;
ткст ЧИПФЛЕЙТАСИНТ;
ткст СКРИПКАСИНТ;
ткст БЛАУНБОТТЛСИНТ;
ткст КОЛОКОЛЬЦЫСИНТ;
ткст БАССБАРАБАНСИНТ;
ткст АНАЛОГОВЫЙСИНТ;
}


ткст0 синт(ткст синт)
{
ткст имяф;

if(синт == ТЭСТСИНТ) имяф ="test.synth";
else if(синт == СНЭРСИНТ) имяф ="snare.synth";
else if(синт == РЕЗОБАССИНТ) имяф ="resobass.synth";
else if(синт == ПВМСИНТ) имяф ="pwm.synth";
else if(синт == ПАД1СИНТ) имяф ="pad1.synth";
else if(синт == ПАД2СИНТ) имяф ="pad2.synth";
else if(синт == ФМОРГАНСИНТ) имяф ="fmorgan.synth";
else if(синт == ФМБАССИНТ) имяф ="fmbass.synth";
else if(синт == ДИСТЛИДСИНТ) имяф ="distlead.synth";
else if(синт == ГРЯЗНЫЙБАСССИНТ) имяф ="dirtybass.synth";
else if(синт == ЩЕЛЧОКСИНТ) имяф ="click.synth";
else if(синт == ЧИПРЕКТСИНТ) имяф ="chiprect.synth";
else if(синт == БУРУНДУКСИНТ) имяф ="chipmunk.synth";
else if(синт == ЧИПФЛЕЙТАСИНТ) имяф ="chipflute.synth";
else if(синт == СКРИПКАСИНТ) имяф ="celesta.synth";
else if(синт == БЛАУНБОТТЛСИНТ) имяф ="blownbottle.synth";
else if(синт == КОЛОКОЛЬЦЫСИНТ) имяф ="bells.synth";
else if(синт == БАССБАРАБАНСИНТ) имяф ="bassdrum.synth";
else if(синт == АНАЛОГОВЫЙСИНТ) имяф ="analogous.synth";
else ошибка("Сэмпл синтезатора не распознан");

    Файл файл = new Файл;	
	файл.создай(имяф, ПФРежим.Ввод);    
	файл.пишиТкст(синт);
	файл.закрой();
	return вТкст0(фм("%s",имяф));
}

unittest
{

COSYNE c;

    short буфер[ЧЛОСЕМПЛОВ];

	
	 c = ксИниц(2);
	   if (!c) {
        скажинс("Неудачная инициализация Cosyne.\n");
        выход(1);
    }

    if (ксГрузиИнстр(c, 0, cast(ткст0)".\\instruments\\analogous.synth")) {
        скажинс(фм( "%s\n", ксОшСооб()));
        выход(1);
    }

    ксИграйНоту(c,     0, 20000, 0, 40, 0x30);
    ксИграйНоту(c, 20000, 20000, 0, 42, 0x30);
    ксИграйНоту(c, 40000, 20000, 0, 43, 0x30);
    ксИграйНоту(c, 60000, 20000, 0, 46, 0x30);
    ксИграйНоту(c, 80000, 20000, 0, 47, 0x30);
    ксИграйНоту(c,100000, 20000, 0, 50, 0x30);

    ксПередай(c, cast(крат *) буфер, ЧЛОСЕМПЛОВ);
    ксТерм(c);

    пишиВав("test.wav", 44100, буфер, ЧЛОСЕМПЛОВ);

}


//////////////////////\
/+
class Семплер
{
private COSYNE кос;

    this(цел члоКаналов,цел буфразм =1024)
		{
		кос = ксИниц(члоКаналов);
        if (кос is пусто)
            ошибка("Не удалось инициализировать Cosyne");
		if (ксИницСдл(кос, буфразм))
           ошибка(stdrus.вТкст(ксОшСооб()));
		   
		}

    ~this(){   ксТерм(кос); кос = пусто; }

    проц грузиИнстр(цел канал, ткст имяф)
		{
        if(ксГрузиИнстр(кос, канал, stdrus._вТкст0(имяф)))
            ошибка(stdrus.вТкст(ксОшСооб()));
		}

    проц играйНоту(бцел старт, цел продолжительность, цел канал, цел нота, цел скорость)
		{
        if (ксИграйНоту(кос, старт, продолжительность, канал, нота, скорость))
            ошибка(stdrus.вТкст(ксОшСооб()));
		}

    проц включиНоту(бцел время, цел канал, цел нота, цел скорость)
		{
        if (ксВклНоту(кос, время, канал, нота, скорость))
		ошибка(stdrus.вТкст(ксОшСооб()));
		}
		
    проц выключиНоту(бцел время, цел канал, цел нота)
		{
        if (ксВыклНоту(кос, время, канал, нота))
         ошибка(stdrus.вТкст(ксОшСооб()));
		}

    проц измениПарам(бцел время, цел канал, цел члопарам, плав знач)
		{
        if (ксИзмениПарам(кос, время, канал, члопарам, знач))
           ошибка(stdrus.вТкст(ксОшСооб()));
		}
		
    проц дайТекВрем(){ return ксДайТекВрем(кос);}
			
    проц играй(){ ксСдлИграй();}       

    проц пауза(){ксСдлПауза();}
	
}
        

unittest{

Семплер синт = new Семплер(2);
синт.грузиИнстр(0, ".\\instruments\\analogous.synth");
синт.играйНоту(0, 20000, 0, 40, 0x30);
синт.играйНоту(     0, 20000, 0, 40, 0x30);
синт.играйНоту( 20000, 20000, 0, 42, 0x30);
синт.играйНоту( 40000, 20000, 0, 43, 0x30);
синт.играйНоту( 60000, 20000, 0, 46, 0x30);
синт.играйНоту( 80000, 20000, 0, 47, 0x30);
синт.играйНоту(100000, 20000, 0, 50, 0x30);

}
+/



	static this()
	{
		КОС.заряжай("Dinrus.Cosyne.dll", &грузи );
		КОС.загружай();

ТЭСТСИНТ =
"
osc1(
    type(rectangle)
    shape({0.6 + 0.35 * lfo1})
)
osc2(
    type(saw)
    tune(0.01)
)
mix({0.5 * lfo2})

envelope(1.0 0.4 0.7 1.0)

filter(
    type(lp12)
    cutoff({f * (9 + 3*lfo3)})
    resonance(0)
)



lfo1(
    type(triangle)
    rate(0.64)
)
lfo2(
    type(sine)
    rate(0.37)
)
lfo3(
    type(sine)
    rate(0.13)
)


effects(
    chorus(
        voices(4)
        time(0.07)
        depth(0.03)
        rate(0.09)
    )

    delay(
        time(0.4)
        feedback(0.55)
        amount(0.5)
    )
)
";
СНЭРСИНТ =
"
osc1(
    type(pinknoise)
)

envelope (0.01 0.1 0.01 0.01)

filter(
    type(hp12)
    cutoff(350)
    resonance(1)
)
";
РЕЗОБАССИНТ =
"
osc1(
    type(saw)
)
osc2(
    type(rectangle)
    shape(0.2)
    tune(0.01)
)
mix(-0.5)
envelope(0.05 0.05 0.5 0.1)

filter(
    type(mooglp)
    //cutoff({1.5*f + 10 * env1})
    cutoff({f * (2 + 10*env1)})
    resonance(0.7)
)

env1( 0.1 0.3 0.01 0.01 )
";
ПВМСИНТ =
"
osc1(
    type(rectangle)
    shape({0.4 + 0.3*lfo1})
)

osc2(
    type(rectangle)
    shape({0.5 + 0.3*lfo2})
    tune(7)
)

mix(0)
envelope( 0.8 0.1 0.8 0.2 )

lfo1(
    type(sine)
    rate(0.5)
)

lfo2(
    type(sine)
    rate(0.41937)
)
";
ПАД1СИНТ =
"
osc1(
    type(rectangle)
    shape(0.6)
    //freqmod({1 + 0.5 * lfo1})
)

osc2(
    type(triangle)
    shape(0.9)
    tune(12.01)
)

mix(0)

envelope(
    2.0 0.2 0.9 1.5
)

filter(
    cutoff({f * (1.5 + 0.2*lfo1 + param1)})
    resonance({0.25 + 0.75 * param2})
)

lfo1(
    type(sine)
    rate(2)
)

param1(0)
param2(0)
";		
ПАД2СИНТ =
"
osc1(
    type(rectangle)
    shape(0.6)
    //freqmod({1 + 0.5 * lfo1})
)

osc2(
    type(triangle)
    shape(0.9)
    tune(12.005)
)

mix(0)

envelope(
    2.0 0.2 0.9 1.5
)

filter(
    //cutoff(2.5)
    cutoff({f * (0.8 + env1)})
    resonance(.2)
)

/// Custom modulation sources ////////////////////////////// 

lfo1(
    type(triangle)
    rate(1.5)
)

env1(0.5 1 0.5 0.5)


effects(
    chorus(
        voices(3)
        time (0.030)
        depth(0.005)
        rate(2)
        amount(0.2)
    )
)
";
ФМОРГАНСИНТ =
"
osc1(
    type(sine)
    freqmod({1 + 0.01 * lfo1})
)

osc2(
    type(sine)
    tune(12)
    freqmod({1 + 0.01 * lfo1})
)

fm({0.010 * (1 + 5*env1)})
mix(-1)

envelope(0.01 0.1 0.75 0.1)

lfo1(
    type(sine)
    rate(2)
)

env1(0.01 0.1 0.01 0.01)
";
ФМБАССИНТ =
"
osc1(
    type(sine)
)

osc2(
    type(sine)
    tune(24.1)
)

fm(0.002)
mix(-1)

envelope(0.02 0 1 0.15)
";
ДИСТЛИДСИНТ =
"
osc1(
    type(saw)
)
osc2(
    type(saw)
    tune(0.002)
)
mix(0)

envelope(0.05 0.15 0.75 0.3)

effects(
    chorus(
        voices(4)
        time(0.030)
        depth(0.015)
        rate(0.10)
        amount(1)
    )

    delay(
        time(0.07)
        amount(0.8)
        feedback(0.5)
    )

    waveshaper(
        type(rational)
        pregain(15)
        postgain(0.25)
    )
)
";
ГРЯЗНЫЙБАСССИНТ=
"
osc1(
    type(sine)
    freqmod({1 + 0.3*env1})
)
env1(0.05 0.1 0 0)

osc2(
    type(triangle)
)

envelope(0.05 0.2 0.4 0.2)

mix(-0.4)
fm({0.002 * (1 + env1)})

filter(
    type(mooglp)
    cutoff({f * 5})
    resonance(0)
)

effects(
    waveshaper( type(tanh) pregain(10) postgain(0.2) )
)
";
ЩЕЛЧОКСИНТ =
"
osc1(
    type(whitenoise)
)

envelope(0.001 0.02 0.01 0.01)

filter(
    type(bp12)
    cutoff({18000})
    resonance(10)
)
";
ЧИПРЕКТСИНТ =
"
osc1(
    type(rectangle)
    shape({0.2 + 0.3 * env1})
)

//osc2(type(sine) tune(24))
//fm({0.02 + 0.05 * env1})

mix(-1)

envelope(0.02 0 1 0.1)

env1(0 0.1 0 0)

effects
(
    waveshaper(
        type(tanh)
        pregain(7)
        postgain(0.25)
    )

    delay(
        time(0.15)
        amount(0.15)
        feedback(0.3)
    )
)
";
БУРУНДУКСИНТ =
"
osc1(
    type(rectangle)
    shape({0.2 + 0.2 * env1})
)

//osc2(type(sine) tune(24))
//fm({0.02 + 0.05 * env1})

mix(-1)

envelope(0.02 0 1 0.1)

filter(
    type(mooglp)
    cutoff({f * 2})
    resonance(1)
)

env1(0 0.1 0 0)

effects
(
    decimator(factor(7))

    chorus(
        voices(2)
        time(0.030)
        depth(0.010)
        rate(1)
        amount(0.9)
    )

    delay(
        time(0.20)
        amount(0.15)
        feedback(0.5)
    )

)
";
ЧИПФЛЕЙТАСИНТ =
"
osc1(
    type(rectangle)
)
osc2(
    type(saw)
    tune(12)
)


ringmod(1)
mix(1)

";
СКРИПКАСИНТ =
 "
osc1(
    type(sine)
)

osc2(
    type(sine)
    tune(36)
)

mix(-1)
fm({0.1 + 0.1 * env1})

envelope(0.01 0.02 0.5 0.65)
env1(0.01 0.02 0.5 0.35)
";
БЛАУНБОТТЛСИНТ =
"
osc1(
    type(pinknoise)
)

envelope( 0.25 0.2 0.8 0.3 )
gain(0.5)

filter(
    type(bp12)
    resonance(50)
)
";
КОЛОКОЛЬЦЫСИНТ=
"
osc1(
    type(sine)
)

osc2(
    type(triangle)
    tune(5.45)
)

fm({0.001 + 0.01*env1})
mix(-1)

env1(0 0.05 0.01 0.1)

envelope(0.05 0.7 0.05 0.1)

effects(
    delay(
        time(0.25)
        amount(0.4)
        feedback(0.6)
    )

    chorus(
        depth(0.002)
        amount(0.3)
    )
)
";
БАССБАРАБАНСИНТ =
"
osc1(
    type(sine)
    freqmod({0.2 + 0.8 * env1})
)

osc2(
    type(triangle)
    freqmod({0.2 + 0.8 * env1})
)

// try different ratios (in [-1,1]) here
mix(-0.5)

envelope(0.01 0.1 0 0)

// pitch envelope
env1(0 0.1 0 0)
";	

АНАЛОГОВЫЙСИНТ =
"
// Blatant ripoff of the eponymous patch for Synth1

osc1(
    type(saw)
)

osc2(
    type(rectangle)
    shape({0.25 + 0.15*lfo1})
    tune(-11.95)
)

mix(0)
gain(0.5)
//fm(0.08)

envelope(0.10 0.15 0.75 0.15)
env1    (0.25 0.15 0.15 0.15)   // filter envelope

filter(
    type(lp12)
    cutoff({f * (0.65 + 15*env1)})
    resonance(0.5)
)

lfo1(
    type(triangle)
    rate(2)
)


effects(
    chorus(
        voices(2)
        depth(0.005)
        amount(0.3)
        rate(1)
    )

    delay(
        time(0.25)
        amount(0.5)
        feedback(0.35)
    )
)
";
	}
	
	static ~this()
	{
		КОС.выгружай();
		сис("del *.synth");
	}
	
	
