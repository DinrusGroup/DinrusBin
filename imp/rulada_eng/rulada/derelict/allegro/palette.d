/***************************************************************
                           palette.h
 ***************************************************************/

module derelict.allegro.palette;

alias RGB КЗС;
struct RGB
{
   ubyte r, g, b;
   ubyte filler;
}

const int PAL_SIZE    = 256;
alias PAL_SIZE РАЗМЕР_ПАЛИТРЫ;

alias RGB[PAL_SIZE] PALETTE;
alias PALETTE ПАЛИТРА;