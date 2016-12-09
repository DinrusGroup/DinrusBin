module cst.ctype;
public import stdrus: числобукв_ли, буква_ли, управ_ли, цифра_ли, проп_ли, пунктзнак_ли, межбукв_ли, заг_ли, цифраикс_ли, граф_ли,  печат_ли, аски_ли, впроп, взаг;

	alias числобукв_ли isalnum;
	alias буква_ли isalpha;
	alias управ_ли iscntrl;
	alias цифра_ли isdigit;
	alias проп_ли islower;
	alias пунктзнак_ли ispunct;
	alias межбукв_ли isspace;
	alias заг_ли isupper;
	alias цифраикс_ли isxdigit;
	alias граф_ли isgraph;
	alias печат_ли isprint;
	alias аски_ли isascii;
	alias впроп tolower;
	alias взаг toupper;