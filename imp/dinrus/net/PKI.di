module net.PKI;

private import time.Time;
private import lib.OpenSSL;

const цел SSL_VERIFY_NONE = 0x00;
const цел SSL_VERIFY_PEER = 0x01;
const цел SSL_VERIFY_FAIL_IF_NO_PEER_CERT = 0x02;
const цел SSL_VERIFY_CLIENT_ONCE = 0x04;
const цел SSL_SESS_CACHE_SERVER = 0x0002;

extern (C) typedef цел function(цел, X509_STORE_CTX *ctx) SSLVerifyCallback;

class КонтекстССЛ
{
    package SSL_CTX *_ctx = пусто;
    private Сертификат _cert = пусто;
    private ЧастныйКлюч _key = пусто;
    private ХранилищеСертификатов _store = пусто;

    this();
    ~this();
    КонтекстССЛ сертификат(Сертификат серт);
    КонтекстССЛ частныйКлюч(ЧастныйКлюч ключ);
    КонтекстССЛ проверьКлюч();
    КонтекстССЛ настройВерификацию(цел флаги, SSLVerifyCallback ов);
    КонтекстССЛ сохрани(ХранилищеСертификатов сохрани) ;
    КонтекстССЛ путьКСертСА(ткст путь);
	 SSL_CTX* исконный();
}


class КонтекстХраненияСертификатов
{
    private X509_STORE_CTX *_ctx = пусто;


    this(X509_STORE_CTX *ctx);
    цел ошибка();
    цел глубинаОшибки();

}

class ХранилищеСертификатов
{
    package X509_STORE *_store = пусто;
    Сертификат[] _certs;


    this();
    ~this();
    ХранилищеСертификатов добавь(Сертификат серт);
}


class ПубличныйКлюч
{
    package RSA *_evpKey = пусто;
    private ЧастныйКлюч _existingKey = пусто;

    this (ткст publicPemData);	
    package this(ЧастныйКлюч ключ) ;
    ~this();
    ткст вФорматПЕМ();
    бул проверь(ббайт[] данные, ббайт[] сигнатура);
    ббайт[] зашифруй(ббайт[] данные);
    ббайт[] расшифруй(ббайт[] данные);

}

class ЧастныйКлюч
{
    package EVP_PKEY *_evpKey = пусто;

    this (ткст privatePemData, ткст certPass = пусто);
    this(цел биты);    
    ~this();
    override цел opEquals(Объект об);
    ткст вФорматПЕМ(ткст пароль = пусто);
    ПубличныйКлюч публичныйКлюч();
    ббайт[] знак(ббайт[] данные, ббайт[] sigbuf);
    ббайт[] зашифруй(ббайт[] данные);
    ббайт[] расшифруй(ббайт[] данные);

}

class Сертификат
{
    package X509 *_cert = пусто;
    private бул readOnly = да;
    private бул freeIt = да;

    package this (X509 *серт);
    this(ткст publicPemData);
    this();
    ~this();
    Сертификат серийныйНомер(бцел serial);
    бцел серийныйНомер();
    Сертификат смещениеКДатеДо(ИнтервалВремени t);
    Сертификат смещениеКДатеПосле(ИнтервалВремени t);
    ткст датаПосле();
    ткст датаДо()  ;
    Сертификат частныйКлюч(ЧастныйКлюч ключ);
    Сертификат установиСубъект(ткст country, ткст stateProvince, ткст city, ткст organization, ткст cn, ткст organizationalUnit = пусто, ткст email = пусто);
    ткст субъект() ;
    Сертификат знак(Сертификат caCert, ЧастныйКлюч caKey);
    override цел opEquals(Объект об);
    бул проверь(ХранилищеСертификатов сохрани);
    ткст вФорматПЕМ();
    private проц добавьЗаписьИмени(X509_NAME *имя, сим *тип, ткст значение);
    private проц проверьФлаг();
}


version (Test)
{
      import io.Stdout;

    auto t1 = ИнтервалВремени.нуль;
    auto t2 = ИнтервалВремени.изДней(365); // can't установи this up in delegate ..??
	
    void main()
    {
        Test.Status _pkeyGenTest(inout ткст[] messages)
        {
            auto pkey = new ЧастныйКлюч(2048);
            ткст pem = pkey.вФорматПЕМ;
            auto pkey2 = new ЧастныйКлюч(pem);
            if (pkey == pkey2)
            {
                auto pkey3 = new ЧастныйКлюч(2048);
                ткст pem2 = pkey3.вФорматПЕМ("hello");
                try
                    auto pkey4 = new ЧастныйКлюч(pem2, "badpass");
                catch (Исключение ex)
                {
                    auto pkey4 = new ЧастныйКлюч(pem2, "hello");
                    return Test.Status.Success;
                }
            }
                
            return Test.Status.Failure;
        }

        Test.Status _certGenTest(inout ткст[] messages)
        {
            auto серт = new Сертификат();
            auto pkey = new ЧастныйКлюч(2048);
            серт.частныйКлюч(pkey).серийныйНомер(123).смещениеКДатеДо(t1).смещениеКДатеПосле(t2);
            серт.установиСубъект("CA", "Alberta", "Place", "Нет", "First Last", "no unit", "email@example.com").знак(серт, pkey);
            ткст pemData = серт.вФорматПЕМ;
            auto cert2 = new Сертификат(pemData);
//            Стдвыв.форматнс("{}\n{}\n{}\n{}", cert2.серийныйНомер, cert2.субъект, cert2.датаДо, cert2.датаПосле);
            if (cert2 == серт)
                return Test.Status.Success;
            return Test.Status.Failure;
        }

        Test.Status _chainValопрation(inout ткст[] messages)
        {
            auto caCert = new Сертификат();
            auto caPkey = new ЧастныйКлюч(2048);
            caCert.серийныйНомер = 1;
            caCert.частныйКлюч = caPkey;
            caCert.смещениеКДатеДо = t1;
            caCert.смещениеКДатеПосле = t2;
            caCert.установиСубъект("CA", "Alberta", "CA Place", "Super CACerts Anon", "CA Manager");
            caCert.знак(caCert, caPkey);
            auto сохрани = new ХранилищеСертификатов();
            сохрани.добавь(caCert);

            auto subCert = new Сертификат();
            auto subPkey = new ЧастныйКлюч(2048);
            subCert.серийныйНомер = 2;
            subCert.частныйКлюч = subPkey;
            subCert.смещениеКДатеДо = t1;
            subCert.смещениеКДатеПосле = t2;
            subCert.установиСубъект("US", "California", "Customer Place", "Penny-Pincher", "IT Director");
            subCert.знак(caCert, caPkey);

            if (subCert.проверь(сохрани))
            {
                auto fakeCert = new Сертификат();
                auto fakePkey = new ЧастныйКлюч(2048);
                fakeCert.серийныйНомер = 1;
                fakeCert.частныйКлюч = fakePkey;
                fakeCert.смещениеКДатеДо = t1;
                fakeCert.смещениеКДатеПосле = t2;
                fakeCert.установиСубъект("CA", "Alberta", "CA Place", "Super CACerts Anon", "CA Manager");
                fakeCert.знак(caCert, caPkey);
                auto store2 = new ХранилищеСертификатов();
                if (!subCert.проверь(store2))
                    return Test.Status.Success;
            }

            return Test.Status.Failure;
        }   

        Test.Status _rsaCrypto(inout ткст[] messages)
        {
            auto ключ = new ЧастныйКлюч(2048);
            ткст pemData = ключ.публичныйКлюч.вФорматПЕМ;
            auto pub = new ПубличныйКлюч(pemData);
            auto encrypted = pub.зашифруй(cast(ббайт[])"Hello, как are you today?");
            auto decrypted = ключ.расшифруй(encrypted);
            if (cast(ткст)decrypted == "Hello, как are you today?")
            {
                encrypted = ключ.зашифруй(cast(ббайт[])"Hello, как are you today, mister?");
                decrypted = pub.расшифруй(encrypted);
                if (cast(ткст)decrypted == "Hello, как are you today, mister?")
                    return Test.Status.Success;
            }
            return Test.Status.Failure;
        }

        Test.Status _rsaSignVerify(inout ткст[] messages)
        {
            auto ключ = new ЧастныйКлюч(1024);
            auto key2 = new ЧастныйКлюч(1024);
            ббайт[] данные = cast(ббайт[])"I am some special данные, да I am.";
            ббайт[512] sigBuf;
            ббайт[512] sigBuf2;
            auto sig1 = ключ.знак(данные, sigBuf);
            auto sig2 = key2.знак(данные, sigBuf2);
            if (ключ.публичныйКлюч.проверь(данные, sig1))
            {
                if (!ключ.публичныйКлюч.проверь(данные, sig2))
                {
                    if (key2.публичныйКлюч.проверь(данные, sig2))
                    {
                        if (!key2.публичныйКлюч.проверь(данные, sig1))
                            return Test.Status.Success;
                    }
                }
            }

            return Test.Status.Failure;
        }


        auto t = new Test("tetra.net.PKI");
        t["Public/Private Keypair"] = &_pkeyGenTest;
        t["Self-Signed Сертификат"] = &_certGenTest;
        t["Chain Valопрation"] = &_chainValопрation;
        t["RSA Crypto"] = &_rsaCrypto;
        t["RSA знак/проверь"] = &_rsaSignVerify;
        t.run();
    }
}
