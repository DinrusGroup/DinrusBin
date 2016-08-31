/**
 * Authors: The D DBI project
 * Copyright: BSD license
 */

module dbi.model.Statement;

private import dbi.model.Result,
               dbi.model.Constants;

// TODO : Consider if Инструкция should stop inheriting Результат, the original
// reasoning being that the concepts are difficult to split in for instance
// Mysql.
interface Инструкция : Результат
{
    проц типыПарамов(ТипДби[] типыПарамов ...);
    проц типыРезультата(ТипДби[] типыРез ...);

    // TODO : proper variadics here
    проц выполни(ук[] вяжи ...);

    бул добудь(ук[] вяжи ...);

    бдол задействованныеРяды();
    бцел члоПарамов();
    бдол идПоследнейВставки();

    проц сбрось();
    проц закрой();
}

interface Преддоб
{
    проц преддобудь();
    бдол члоРядов();
}
