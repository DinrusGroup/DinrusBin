module dbi.mssql.imp;

version (Windows) {
	pragma (lib, "libct.lib");
} else version (linux) {
	pragma (lib, "libct.a");
} else version (Posix) {
	pragma (lib, "libct.a");
} else version (darwin) {
	pragma (lib, "libct.a");
} else {
	pragma (сооб, "You will need to manually link in the mSQL library.");
}


extern (C) {
  цел cs_ctx_размест(цел version_, проц * * ctx);
  цел ct_init(проц * ctx, цел version_);
  цел ct_con_размест(проц * ctx, проц * * con);
  цел ct_con_props(проц * con, цел action, цел property, проц * буфер,
		   цел buflen, цел * out_len);
  цел ct_подключись(проц * con, char * serverимя, цел sимяlen);

  цел ct_cmd_размест(проц * con, проц * * cmd);
  цел ct_command(проц * cmd, цел тип, проц * буфер, цел buflen, цел option);
  цел ct_send(проц * cmd);

  цел ct_results(проц * cmd, цел * result_type);
  цел ct_res_info(проц * cmd, цел тип, проц * буфер, цел buflen,
		  цел * out_len);
  цел ct_fetch(проц * cmd, цел тип, цел offустанови, цел option, цел * ряды_read);
  цел ct_describe(проц * cmd, цел item, _cs_datafmt * datafmt);
  цел ct_подвяз(проц * cmd, цел item, _cs_datafmt * datafmt, проц * буфер,
	      цел * copied, крат * indicator);

  цел ct_закрой(проц * con, цел option);
}

alias проц CS_CONTEXT;
alias проц CS_CONNECTION;
alias проц CS_COMMAND;

alias цел CS_RETCODE;

alias _cs_datafmt CS_DATAFMT;
struct _cs_datafmt {
  char[132] имя;
  цел имяlen;
  цел datatype;
  цел format;
  цел maxlength;
  цел scale;
  цел precision;
  цел status;
  цел счёт;
  цел usertype;
  проц * locale;
}

const цел CS_UNUSED = -99999;
const цел CS_NULLTERM = -9;

const цел CS_FAIL = 0;
const цел CS_SUCCEED = 1;
const цел CS_SET = 34;
const цел CS_VERSION_100 = 112;
const цел CS_LANG_CMD = 148;
const цел CS_NUMDATA = 803;

const цел CS_ROW_RESULT = 4040;

const цел CS_END_RESULTS = -205;
const цел CS_CMD_DONE = 4046;
const цел CS_CMD_SUCCEED = 4047;
const цел CS_CMD_FAIL = 4048;

const цел CS_USERNAME = 9100;
const цел CS_PASSWORD = 9101;
const цел CS_SERVERADDR = 9206;

// data types
const цел CS_CHAR_TYPE = 0;
const цел CS_FLOAT_TYPE = 10;
const цел CS_DATETIME_TYPE = 12;
const цел CS_DATETIME4_TYPE = 13;
const цел CS_MONEY_TYPE = 14;
const цел CS_MONEY4_TYPE = 15;

alias дво CS_FLOAT;
alias цел CS_INT;

alias _cs_daterec CS_DATEREC;
struct _cs_daterec {
  цел dateyear;
  цел datemonth;
  цел datedmonth;
  цел datedyear;
  цел datedweek;
  цел datehour;
  цел dateminute;
  цел datesecond;
  цел datemsecond;
  цел datetzone;
}


alias _cs_datetime4 CS_DATETIME4;
struct _cs_datetime4 {
  бкрат days;
  бкрат минуты;
}

alias _cs_datetime CS_DATETIME;
struct _cs_datetime {
  цел dtdays;
  цел dttime;
}

alias _cs_money4 CS_MONEY4;
struct _cs_money4 {
  цел mny4;
}

alias _cs_money CS_MONEY;
struct _cs_money {
  цел mnyhigh;
  бцел mnylow;
}