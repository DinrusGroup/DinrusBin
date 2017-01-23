/*******************************************************************************

        copyright:      Copyright (c) 2008 Jeff Davey. All rights reserved

        license:        BSD style: $(LICENSE)

        author:         Jeff Davey <j@submersion.com>

*******************************************************************************/

module lib.OpenSSL;

private import stdrus, stringz, cidrus, thread, sync, sys.SharedLib, io.FileSystem;

/*******************************************************************************

    This module contains all of the dynamic bindings needed to the
    OpenSSL libraries (libssl.so/libssl32.dll and libcrypto.so/libeay32.dll) 

*******************************************************************************/

/*
   XXX TODO XXX

   A lot of unsigned longs and longs were converted to бцел and цел

   These will need to be reversed to support 64bit DinrusTango.lib
   (should use c_long and c_ulong from rt.core.stdc.config)

   XXX TODO XXX
*/


version(linux)
{
    version(build)
    {
        pragma(link, "dl");
    }
}

const бцел BYTES_ENTROPY = 2048; // default bytes of entropy to загрузи on startup.
private CRYPTO_dynlock_value *last = null;
Мютекс _dynLocksMutex = null;
extern (C)
{
    const цел NID_sha1 = 64;
    const цел NID_md5 = 4;
    const цел RSA_PKCS1_OAEP_PADDING = 4;
    const цел RSA_PKCS1_PADDING = 1;
    const цел BIO_C_SET_NBIO = 102;
    const цел SHA_DIGEST_LENGTH = 20;
    const цел SSL_CTRL_SET_SESS_CACHE_MODE = 44;
    const цел MBSTRING_FLAG = 0x1000;
    const цел MBSTRING_ASC = MBSTRING_FLAG | 1;
    const цел EVP_PKEY_RSA = 6;
    const цел RSA_F4 = 0x1001;
    const цел SSL_SENT_SHUTDOWN = 1;
    const цел SSL_ПриёмD_SHUTDOWN = 2;
    const цел BIO_C_GET_SSL = 110;
    const цел BIO_CTRL_RESET = 1;
    const цел BIO_CTRL_INFO = 3;
    const цел BIO_FLAGS_READ = 0x01;
    const цел BIO_FLAGS_WRITE = 0x02;
    const цел BIO_FLAGS_IO_SPECIAL = 0x04;
    const цел BIO_FLAGS_SHOULD_RETRY = 0x08;
    const цел BIO_CLOSE = 0x00;
    const цел BIO_NOCLOSE = 0x01;
    const цел ASN1_STRFLGS_ESC_CTRL = 2;
    const цел ASN1_STRFLGS_ESC_MSB = 4;
    const цел XN_FLAG_SEP_MULTILINE = (4 << 16);
    const цел XN_FLAG_SPC_EQ = (1 << 23);
    const цел XN_FLAG_FN_LN = (1 << 21);
    const цел XN_FLAG_FN_ALIGN = (1 << 25);
    const цел XN_FLAG_MULTILINE = ASN1_STRFLGS_ESC_CTRL | ASN1_STRFLGS_ESC_MSB | XN_FLAG_SEP_MULTILINE | XN_FLAG_SPC_EQ | XN_FLAG_FN_LN | XN_FLAG_FN_ALIGN;

    const сим* PEM_STRING_EVP_PKEY = "ANY PRIVATE KEY";
    const сим* PEM_STRING_X509 = "CERTIFICATE";   
    const сим* PEM_STRING_RSA_PUBLIC = "RSA PUBLIC KEY";    

    const цел SSL_CTRL_OPTIONS = 32;

    const цел SSL_OP_ALL = 0x00000FFFL;
    const цел SSL_OP_NO_SSLv2 = 0x01000000L;

    const цел CRYPTO_LOCK = 1;
    const цел CRYPTO_UNLOCK = 2;
    const цел CRYPTO_READ = 4;
    const цел CRYPTO_WRITE = 8;

    const цел ERR_TXT_STRING = 0x02;

    const цел MD5_CBLOCK = 64;
    const цел MD5_LBLOCK = MD5_CBLOCK / 4;
    const цел MD5_DIGEST_LENGTH = 16;

    const цел EVP_MAX_BLOCK_LENGTH = 32;
    const цел EVP_MAX_IV_LENGTH = 16;

    struct MD5_CTX
    {
        бцел A;
        бцел B;
        бцел C;
        бцел D;
        бцел Nl;
        бцел Nh;
        бцел[MD5_LBLOCK] data;
        бцел num;
    };

    struct EVP_CIPHER_CTX
    {
        ук cipher;
        ук engine;
        цел зашифруй;
        цел buf_len;

        ббайт[EVP_MAX_IV_LENGTH] oiv;
        ббайт[EVP_MAX_IV_LENGTH] iv;
        ббайт buf[EVP_MAX_BLOCK_LENGTH];
        цел num;

        ук ap_data;
        цел key_len;
        c_ulong flags;
        ук cipher_data;
        цел final_used;
        цел block_mask;
        ббайт[EVP_MAX_BLOCK_LENGTH] finalv;
    };
    
    // fallback for OpenSSL 0.9.7l 28 Sep 2006 that defines only macros
    цел EVP_CIPHER_CTX_block_size_097l(EVP_CIPHER_CTX *e){
        return *((cast(цел*)e.cipher)+1);
    }

    struct BIO 
    {
        BIO_METHOD *метод;
        цел function(BIO *b, цел a, сим *c, цел d, цел e, цел f) callback;
        сим *cb_arg;
        цел init;
        цел экстрзак;
        цел flags;
        // yadda yadda
    };

    typedef BIO* function(цел сок, цел close_flag) tBIO_new_СОКЕТ;
    typedef BIO* function(SSL_CTX *ctx, цел клиент) tBIO_new_ssl;
    typedef проц function(BIO *bio) tBIO_free_all;
    typedef BIO* function(BIO *b, BIO *append) tBIO_push;

    struct SSL_CTX {};
    struct SSL {};
    struct SSL_METHOD {};
    struct EVP_PKEY 
    {
        цел тип;
        цел save_type;
        цел references;
        ук pkey;
        // yadda yadda ...        
    };
    struct X509_STORE_CTX {};
    struct EVP_CIPHER {};
    struct X509_ALGOR {};
    struct ASN1_INTEGER {};
    struct EVP_MD {};

    struct ASN1_STRING
    {
        цел length;
        цел тип;
        сим *data;
        цел flags;
    }

    typedef ASN1_STRING ASN1_GENERALIZEDTIME;
    typedef ASN1_STRING ASN1_TIME;

    struct X509_STORE {};
    struct X509_VAL
    {
        ASN1_TIME *notBefore;
        ASN1_TIME *notAfter;
    }
    struct X509_CINF  // being lazy here, only doing the first peices up to what I need
    {
        ASN1_INTEGER *vers;
        ASN1_INTEGER *серийныйНомер;
        X509_ALGOR *сигнатура;
        X509_NAME *issuer;
        X509_VAL *validity;
        // yadda yadda
    }

    struct X509  // ditto X509_CINF
    {
        X509_CINF *cert_info; 
        // yadda yadda
    };
    struct X509_NAME {};
    struct RSA {};
    struct BIO_METHOD {};

    typedef цел function(сим *buf, цел size, цел rwflag, ук userdata) pem_password_cb;
    typedef сим *function() d2i_of_void;
    typedef цел function() i2d_of_void;
    typedef SSL_CTX* function(SSL_METHOD *meth) tSSL_CTX_new;
    typedef SSL_METHOD* function() tSSLv23_method;
    typedef EVP_PKEY* function(цел тип, EVP_PKEY **a, ббайт **pp, цел length) td2i_PrivateKey;
    typedef цел function(SSL_CTX *ctx, EVP_PKEY *pkey) tSSL_CTX_use_PrivateKey;
    typedef проц function(SSL_CTX *ctx, цел mode, цел function(цел, X509_STORE_CTX *) callback) tSSL_CTX_set_verify;
    typedef проц function(EVP_PKEY *pkey) tEVP_PKEY_free;
    typedef цел function(SSL_CTX *ctx, цел cmd, цел larg, ук parg) tSSL_CTX_ctrl;
    typedef цел function(SSL_CTX *ctx, сим *str) tSSL_CTX_set_cipher_list;
    typedef проц function(SSL_CTX *) tSSL_CTX_free;
    typedef проц function() tSSL_load_error_strings;
    typedef проц function() tSSL_library_init;
    typedef проц function() tOpenSSL_add_all_digests;
    typedef цел function(сим *файл, цел max_bytes) tRAND_load_file;
    typedef цел function() tCRYPTO_num_locks;
    typedef проц function(бцел function() cb) tCRYPTO_set_id_callback;
    typedef проц function(проц function(цел mode, цел тип, сим *файл, цел строка) cb) tCRYPTO_set_locking_callback;
    typedef проц function(CRYPTO_dynlock_value *function(сим *файл, цел строка) cb) tCRYPTO_set_dynlock_create_callback;    
    typedef проц function(проц function(цел mode, CRYPTO_dynlock_value *lock, сим *файл, цел lineNo) cb) tCRYPTO_set_dynlock_lock_callback;
    typedef проц function(проц function(CRYPTO_dynlock_value *lock, сим *файл, цел строка) cb) tCRYPTO_set_dynlock_destroy_callback;
    typedef бцел function(сим **файл, цел *строка, сим **data, цел *flags) tERR_get_error_line_data;
    typedef проц function(бцел pid) tERR_remove_state;
    typedef проц function() tRAND_cleanup;
    typedef проц function() tERR_free_strings;
    typedef проц function() tEVP_cleanup;
    typedef проц function() tOBJ_cleanup;
    typedef проц function() tX509V3_EXT_cleanup;
    typedef проц function() tCRYPTO_cleanup_all_ex_data;
    typedef цел function(BIO *b, ук data, цел len) tBIO_write;
    typedef цел function(BIO *b, ук data, цел len) tBIO_read;
    typedef цел function(SSL_CTX *ctx) tSSL_CTX_check_private_key;
    typedef EVP_PKEY* function(BIO *bp, EVP_PKEY **x, pem_password_cb *cb, ук u) tPEM_read_bio_PrivateKey;
    typedef BIO* function(сим *filename, сим *mode) tBIO_new_file;
    typedef цел function() tERR_peek_error;
    typedef цел function(BIO *b, цел flags) tBIO_test_flags;
    typedef цел function(BIO *b, цел cmd, цел larg, ук parg) tBIO_ctrl; 
    typedef проц function(SSL *ssl, цел mode) tSSL_set_shutdown;
    typedef цел function(SSL *ssl) tSSL_get_shutdown;
    typedef цел function(SSL_CTX *ctx, X509 *x) tSSL_CTX_use_certificate;
    typedef проц function(SSL_CTX *CTX, X509_STORE *store) tSSL_CTX_set_cert_store;
    typedef цел function(SSL_CTX *ctx, сим *CAfile, сим *CApath) tSSL_CTX_load_verify_locations;
    typedef X509* function(X509_STORE_CTX *ctx) tX509_STORE_CTX_get_current_cert;
    typedef цел function(X509_STORE_CTX *ctx) tX509_STORE_CTX_get_error;
    typedef цел function(X509_STORE_CTX *ctx) tX509_STORE_CTX_get_error_depth;
    typedef X509_STORE* function() tX509_STORE_new;
    typedef проц function(X509_STORE *v) tX509_STORE_free;
    typedef цел function(X509_STORE *store, X509 *x) tX509_STORE_add_cert;
//    typedef цел function(X509_STORE *store, цел depth) tX509_STORE_set_depth;
    typedef BIO* function(ук buff, цел len) tBIO_new_mem_buf;
    typedef RSA* function(цел биты, бцел e, проц function(цел a, цел b, ук c) callback, ук cb_arg) tRSA_generate_key;
    typedef EVP_PKEY* function() tEVP_PKEY_new;
    typedef цел function(EVP_PKEY *pkey, цел тип, сим *key) tEVP_PKEY_assign;
    typedef проц function(RSA *r) tRSA_free;
    typedef BIO* function(BIO_METHOD *тип) tBIO_new;
    typedef BIO_METHOD* function() tBIO_s_mem;
    typedef цел function(BIO *bp, EVP_PKEY *x, EVP_CIPHER *cipher, сим *kstr, цел klen, pem_password_cb, проц *) tPEM_write_bio_PKCS8PrivateKey;
    typedef EVP_CIPHER* function() tEVP_aes_256_cbc;
    typedef проц* function(d2i_of_void d2i, сим *name, BIO *bp, проц **x, pem_password_cb cb, ук u) tPEM_ASN1_read_bio;
    typedef X509* function() tX509_new;
    typedef проц function(X509 *x) tX509_free;
    typedef цел function(X509 *x, цел ver) tX509_set_version;
    typedef цел function(ASN1_INTEGER *a, цел v) tASN1_INTEGER_set;
    typedef ASN1_INTEGER* function(X509 *x) tX509_get_serialNumber;
    typedef цел function(ASN1_INTEGER *a) tASN1_INTEGER_get;
    typedef ASN1_TIME* function(ASN1_TIME *s, цел adj) tX509_gmtime_adj;
    typedef цел function(X509 *x, EVP_PKEY *pkey) tX509_set_pubkey;
    typedef X509_NAME* function(X509 *x) tX509_get_subject_name;
    typedef цел function(BIO *b, X509_NAME *nm, цел indent, бцел flags) tX509_NAME_print_ex;
    typedef цел function(X509 *x, X509_NAME *name) tX509_set_issuer_name;
    typedef цел function(X509 *x, EVP_PKEY *pkey, EVP_MD *md) tX509_sign;
    typedef EVP_MD* function() tEVP_sha1;
    typedef X509_STORE_CTX* function() tX509_STORE_CTX_new;
    typedef цел function(X509_STORE_CTX *ctx, X509_STORE *store, X509 *x509, ук shizzle) tX509_STORE_CTX_init;
    typedef цел function(X509_STORE_CTX *ctx) tX509_verify_cert;
    typedef проц function(X509_STORE_CTX *ctx) tX509_STORE_CTX_free;
    typedef цел function(i2d_of_void i2d, сим *name, BIO *bp, сим *x, EVP_CIPHER *enc, сим *kstr, цел klen, pem_password_cb cb, ук u) tPEM_ASN1_write_bio;
    typedef цел function(X509_NAME *name, сим* field, цел тип, сим *bytes, цел len, цел loc, цел set) tX509_NAME_add_entry_by_txt;
    typedef цел function(SSL_CTX *ctx, ббайт *id, бцел len) tSSL_CTX_set_session_id_context;
    typedef цел function(EVP_PKEY *a, EVP_PKEY *b) tEVP_PKEY_cmp_parameters;
    typedef цел function(X509 *a, X509 *b) tX509_cmp;
    typedef проц function() tOPENSSL_add_all_algorithms_noconf;
    typedef ASN1_GENERALIZEDTIME *function(ASN1_TIME *t, ASN1_GENERALIZEDTIME **outTime) tASN1_TIME_to_generalizedtime;
    typedef проц function(ASN1_STRING *a) tASN1_STRING_free;
    typedef цел function() tRAND_poll;
    typedef цел function(RSA *rsa) tRSA_size;
    typedef цел function(цел flen, ббайт *from, ббайт *to, RSA *rsa, цел padding) tRSA_public_encrypt;
    typedef цел function(цел flen, ббайт *from, ббайт *to, RSA *rsa, цел padding) tRSA_private_decrypt;
    typedef цел function(цел flen, ббайт *from, ббайт *to, RSA *rsa, цел padding) tRSA_private_encrypt;
    typedef цел function(цел flen, ббайт *from, ббайт *to, RSA *rsa, цел padding) tRSA_public_decrypt;
    typedef цел function(цел тип, ббайт *m, бцел m_length, ббайт *sigret, бцел *siglen, RSA *rsa) tRSA_sign;
    typedef цел function(цел тип, ббайт *m, бцел m_length, ббайт *sigbuf, бцел siglen, RSA *rsa) tRSA_verify;
    typedef проц function(MD5_CTX *c) tMD5_Init;
    typedef проц function(MD5_CTX *c, ук data, size_t len) tMD5_Update;
    typedef проц function(ббайт *md, MD5_CTX *c) tMD5_Final;
    typedef цел function(EVP_CIPHER_CTX *ctx, EVP_CIPHER *тип, ук impl, ббайт *key, ббайт *iv) tEVP_EncryptInit_ex;
    typedef цел function(EVP_CIPHER_CTX *ctx, EVP_CIPHER *тип, ук impl, ббайт *key, ббайт*iv) tEVP_DecryptInit_ex;
    typedef цел function(EVP_CIPHER_CTX *ctx, ббайт *outv, цел *outl, ббайт *inv, цел inl) tEVP_EncryptUpdate;
    typedef цел function(EVP_CIPHER_CTX *ctx, ббайт *outv, цел *outl, ббайт *inv, цел inl) tEVP_DecryptUpdate;
    typedef цел function(EVP_CIPHER_CTX *ctx, ббайт *outv, цел *outl) tEVP_EncryptFinal_ex;
    typedef цел function(EVP_CIPHER_CTX *ctx, ббайт *outv, цел *outl) tEVP_DecryptFinal_ex;
    typedef цел function(EVP_CIPHER_CTX *ctx) tEVP_CIPHER_CTX_block_size;
    typedef EVP_CIPHER *function() tEVP_aes_128_cbc;
    typedef цел function(EVP_CIPHER_CTX *ctx) tEVP_CIPHER_CTX_cleanup;

    struct CRYPTO_dynlock_value
    {
        ЧЗМютекс lock;
        CRYPTO_dynlock_value *next;
        CRYPTO_dynlock_value *prev;
    }

    бцел идНитиССЛ()
    {
        return cast(бцел)cast(проц*)thread.Нить.дайЭту;
    }
	
    проц статичЗамокССЛ(цел mode, цел index, сим *sourceFile, цел lineNo)
    {
        if (_locks)
        {
            if (mode & CRYPTO_LOCK)
            {
                if (mode & CRYPTO_READ)
                    _locks[index].читатель.lock();
                else
                    _locks[index].писатель.lock();
            }
            else
            {
                if (mode & CRYPTO_READ)
                    _locks[index].читатель.unlock();
                else
                    _locks[index].писатель.unlock();
            }

        } 
    }
    бцел ablah = 0;
    CRYPTO_dynlock_value *создайДинамичЗамокССЛ(сим *sourceFile, цел lineNo)
    {
        auto rtn = new CRYPTO_dynlock_value;
        rtn.lock = new ЧЗМютекс;
        synchronized
        {
            if (last is null)
                last = rtn;
            else
            {
                rtn.prev = last;
                last.next = rtn;
                last = rtn;
            }        
        }
        return rtn; 
    }

    проц закройДинамичЗамокССЛ(цел mode, CRYPTO_dynlock_value *lock, сим *sourceFile, цел lineNo)
    {
        if (lock && lock.lock)
        {
            if (mode & CRYPTO_LOCK)
            {
                if (mode & CRYPTO_READ)
                    lock.lock.читатель.lock();
                else
                    lock.lock.писатель.lock();
            }
            else
            {
                if (mode & CRYPTO_READ)
                    lock.lock.читатель.unlock();
                else
                    lock.lock.писатель.unlock();
            }
        } 
    }

    проц удалиДинамичЗамокССЛ(CRYPTO_dynlock_value *lock, сим *sourceFile, цел lineNo)
    {
        synchronized
        {
            if (lock.prev)
                lock.prev.next = lock.next;
            if (lock.next)
                lock.next.prev = lock.prev;    
            if (lock is last)
                last = lock.prev;
            lock = lock.next = lock.prev = null;
        }
    }

}
private bool _bioTestFlags = true;
tBIO_test_flags BIO_test_flags;
tBIO_new_СОКЕТ BIO_new_socket;
tBIO_new_ssl BIO_new_ssl;
tBIO_free_all BIO_free_all;
tBIO_push BIO_push;
tBIO_read BIO_read;
tBIO_write BIO_write;
tSSL_CTX_new SSL_CTX_new;
tSSLv23_method SSLv23_method;
td2i_PrivateKey d2i_PrivateKey;
tSSL_CTX_use_PrivateKey SSL_CTX_use_PrivateKey;
tSSL_CTX_set_verify SSL_CTX_set_verify;
tEVP_PKEY_free EVP_PKEY_free;
tSSL_CTX_ctrl SSL_CTX_ctrl;
tSSL_CTX_set_cipher_list SSL_CTX_set_cipher_list;
tSSL_CTX_free SSL_CTX_free;
tSSL_load_error_strings SSL_load_error_strings;
tSSL_library_init SSL_library_init;
tRAND_load_file RAND_load_file;
tCRYPTO_num_locks CRYPTO_num_locks;
tCRYPTO_set_id_callback CRYPTO_set_id_callback;
tCRYPTO_set_locking_callback CRYPTO_set_locking_callback;
tCRYPTO_set_dynlock_create_callback CRYPTO_set_dynlock_create_callback;
tCRYPTO_set_dynlock_lock_callback CRYPTO_set_dynlock_lock_callback;
tCRYPTO_set_dynlock_destroy_callback CRYPTO_set_dynlock_destroy_callback;
tERR_get_error_line_data ERR_get_error_line_data;
tERR_remove_state ERR_remove_state;
tRAND_cleanup RAND_cleanup;
tERR_free_strings ERR_free_strings;
tEVP_cleanup EVP_cleanup;
tOBJ_cleanup OBJ_cleanup;
tX509V3_EXT_cleanup X509V3_EXT_cleanup;
tCRYPTO_cleanup_all_ex_data CRYPTO_cleanup_all_ex_data;
tSSL_CTX_check_private_key SSL_CTX_check_private_key;
tPEM_read_bio_PrivateKey PEM_read_bio_PrivateKey;
tBIO_new_file BIO_new_file;
tERR_peek_error ERR_peek_error;
tBIO_ctrl BIO_ctrl;
tSSL_get_shutdown SSL_get_shutdown;
tSSL_set_shutdown SSL_set_shutdown;
tSSL_CTX_use_certificate SSL_CTX_use_certificate;
tSSL_CTX_set_cert_store SSL_CTX_set_cert_store;
tSSL_CTX_load_verify_locations SSL_CTX_load_verify_locations;
tX509_STORE_CTX_get_current_cert X509_STORE_CTX_get_current_cert;
tX509_STORE_CTX_get_error_depth X509_STORE_CTX_get_error_depth;
tX509_STORE_CTX_get_error X509_STORE_CTX_get_error;
tX509_STORE_new X509_STORE_new;
tX509_STORE_free X509_STORE_free;
tX509_STORE_add_cert X509_STORE_add_cert;
//tX509_STORE_set_depth X509_STORE_set_depth;
tBIO_new_mem_buf BIO_new_mem_buf;
tRSA_generate_key RSA_generate_key;
tEVP_PKEY_new EVP_PKEY_new;
tEVP_PKEY_assign EVP_PKEY_assign;
tRSA_free RSA_free;
tBIO_new BIO_new;
tBIO_s_mem BIO_s_mem;
tPEM_write_bio_PKCS8PrivateKey PEM_write_bio_PKCS8PrivateKey;
tEVP_aes_256_cbc EVP_aes_256_cbc;
tPEM_ASN1_read_bio PEM_ASN1_read_bio;
d2i_of_void d2i_X509;
d2i_of_void d2i_RSAPublicKey;
tX509_new X509_new;
tX509_free X509_free;
tX509_set_version X509_set_version;
tASN1_INTEGER_set ASN1_INTEGER_set;
tX509_get_serialNumber X509_get_serialNumber;
tASN1_INTEGER_get ASN1_INTEGER_get;
tX509_gmtime_adj X509_gmtime_adj;
tX509_set_pubkey X509_set_pubkey;
tX509_get_subject_name X509_get_subject_name;
tX509_NAME_print_ex X509_NAME_print_ex;
tX509_set_issuer_name X509_set_issuer_name;
tX509_sign X509_sign;
tEVP_sha1 EVP_sha1;
tX509_STORE_CTX_new X509_STORE_CTX_new;
tX509_STORE_CTX_init X509_STORE_CTX_init;
tX509_verify_cert X509_verify_cert;
tX509_STORE_CTX_free X509_STORE_CTX_free;
tPEM_ASN1_write_bio PEM_ASN1_write_bio;
i2d_of_void i2d_X509;
i2d_of_void i2d_RSAPublicKey;
tX509_NAME_add_entry_by_txt X509_NAME_add_entry_by_txt;
tSSL_CTX_set_session_id_context SSL_CTX_set_session_id_context;
tEVP_PKEY_cmp_parameters EVP_PKEY_cmp_parameters;
tX509_cmp X509_cmp;
tOPENSSL_add_all_algorithms_noconf OPENSSL_add_all_algorithms_noconf;
tASN1_TIME_to_generalizedtime ASN1_TIME_to_generalizedtime;
tASN1_STRING_free ASN1_STRING_free;
tRAND_poll RAND_poll;
tRSA_size RSA_size;
tRSA_public_encrypt RSA_public_encrypt;
tRSA_private_decrypt RSA_private_decrypt;
tRSA_private_encrypt RSA_private_encrypt;
tRSA_public_decrypt RSA_public_decrypt;
tRSA_sign RSA_sign;
tRSA_verify RSA_verify;
tMD5_Init MD5_Init;
tMD5_Update MD5_Update;
tMD5_Final MD5_Final;
tEVP_EncryptInit_ex EVP_EncryptInit_ex;
tEVP_DecryptInit_ex EVP_DecryptInit_ex;
tEVP_EncryptUpdate EVP_EncryptUpdate;
tEVP_DecryptUpdate EVP_DecryptUpdate;
tEVP_EncryptFinal_ex EVP_EncryptFinal_ex;
tEVP_DecryptFinal_ex EVP_DecryptFinal_ex;
tEVP_aes_128_cbc EVP_aes_128_cbc;
tEVP_CIPHER_CTX_block_size EVP_CIPHER_CTX_block_size;
tEVP_CIPHER_CTX_cleanup EVP_CIPHER_CTX_cleanup;

цел PEM_write_bio_RSAPublicKey(BIO *bp, RSA *x)
{
    return PEM_ASN1_write_bio(i2d_RSAPublicKey, PEM_STRING_RSA_PUBLIC, bp, cast(сим*)x, null, null, 0, null, null);
}

RSA *PEM_read_bio_RSAPublicKey(BIO *bp, RSA **x, pem_password_cb cb, ук u)
{
    return cast(RSA *)PEM_ASN1_read_bio(d2i_RSAPublicKey, PEM_STRING_RSA_PUBLIC, bp, cast(проц **)x, cb, u);
}

цел PEM_write_bio_X509(BIO *b, X509 *x)
{
    return PEM_ASN1_write_bio(i2d_X509, PEM_STRING_X509, b,cast(сим *)x, null, null, 0, null, null);
}

ASN1_TIME *X509_get_notBefore(X509 *x)
{
    return x.cert_info.validity.notBefore;
}

ASN1_TIME *X509_get_notAfter(X509 *x)
{
    return x.cert_info.validity.notAfter;
}

цел EVP_PKEY_assign_RSA(EVP_PKEY *key, RSA *rsa)
{
    return EVP_PKEY_assign(key, EVP_PKEY_RSA, cast(сим*)rsa);
}

цел BIO_get_mem_data(BIO *b, сим **data)
{
    return BIO_ctrl(b, BIO_CTRL_INFO, 0, data);
}

проц BIO_get_ssl(BIO *b, SSL **объ)
{
    BIO_ctrl(b, BIO_C_GET_SSL, 0, объ);
}

цел SSL_CTX_set_options(SSL_CTX *ctx, цел larg)
{
    return SSL_CTX_ctrl(ctx, SSL_CTRL_OPTIONS, larg, null);
}

цел SSL_CTX_set_session_cache_mode(SSL_CTX *ctx, цел mode)
{
    return SSL_CTX_ctrl(ctx, SSL_CTRL_SET_SESS_CACHE_MODE, mode, null);
}

цел BIO_reset(BIO *b)
{
    return BIO_ctrl(b, BIO_CTRL_RESET, 0, null);
}

bool BIO_should_retry(BIO *b)
{
    if (_bioTestFlags)
        return cast(bool)BIO_test_flags(b, BIO_FLAGS_SHOULD_RETRY);
    return cast(bool)(b.flags & BIO_FLAGS_SHOULD_RETRY);
}

bool BIO_should_io_special(BIO *b)
{
    if (_bioTestFlags)
        return cast(bool)BIO_test_flags(b, BIO_FLAGS_IO_SPECIAL);
    return cast(bool)(b.flags & BIO_FLAGS_IO_SPECIAL);
}

bool BIO_should_read(BIO *b)
{
    if (_bioTestFlags)
        return cast(bool)BIO_test_flags(b, BIO_FLAGS_READ);
    return cast(bool)(b.flags & BIO_FLAGS_READ);
}

bool BIO_should_write(BIO *b)
{
    if (_bioTestFlags)
        return cast(bool)BIO_test_flags(b, BIO_FLAGS_WRITE);
    return cast(bool)(b.flags & BIO_FLAGS_WRITE);
}

X509* PEM_read_bio_X509(BIO *b, X509 **x, pem_password_cb cb, ук u)
{
    return cast(X509 *)PEM_ASN1_read_bio(d2i_X509, PEM_STRING_X509, b, cast(проц**)x, cb, u);
}


private проц вяжиФ(T)(inout T func, ткст funcName, Длл биб)
in
{
    assert(funcName);
    assert(биб);
}
body
{
    ук funcPtr = биб.дайСимвол(stringz.вТкст0(funcName));
    if (funcPtr)
    {
        проц **точка = cast(проц **)&func;
        *точка = funcPtr;
    }
    else
        throw new Исключение("Не удалось загрузить символ: " ~ funcName);
}

static Длл ssllib = null;
version(Win32)
{
    static Длл eaylib = null;
}
version(darwin){
    static Длл cryptolib = null;
}
static ЧЗМютекс[] _locks = null;


проц выдайОшибкуОпенССЛ()
{
    if (ERR_peek_error())
    {
        ткст строкаИскл;

        цел flags, строка;
        сим *данные;
        сим *файл;
        бцел код;

        код = ERR_get_error_line_data(&файл, &строка, &данные, &flags);
        while (код != 0)
        {
            if (данные && (flags & ERR_TXT_STRING))
                строкаИскл ~= фм("код ошибки ssl: %s %s:%s - %s\r\n", код, stringz.изТкст0(файл), строка, stringz.изТкст0(данные));
            else
                строкаИскл ~= фм("код ошибки ssl: %s %s:%s\r\n", код, stringz.изТкст0(файл), строка); 
            код = ERR_get_error_line_data(&файл, &строка, &данные, &flags);
        }
        throw new Исключение(строкаИскл);
    }
    else
        throw new Исключение("Неизвестная ошибка OpenSSL.");
}

проц _initOpenSSL()
{
    SSL_load_error_strings();
    SSL_library_init();
    OPENSSL_add_all_algorithms_noconf();
    version(Posix)
        RAND_load_file("/dev/urandom", BYTES_ENTROPY);
    version(Win32)
    {
        RAND_poll();
    }

    бцел numLocks = CRYPTO_num_locks();
    if ((_locks = new ЧЗМютекс[numLocks]) !is null)
    {
        бцел i = 0;
        for (; i < numLocks; i++)
        {
            if((_locks[i] = new ЧЗМютекс()) is null)
                break;
        }
        if (i == numLocks)
        {
            CRYPTO_set_id_callback(&идНитиССЛ);
            CRYPTO_set_locking_callback(&статичЗамокССЛ);

            CRYPTO_set_dynlock_create_callback(&создайДинамичЗамокССЛ);
            CRYPTO_set_dynlock_lock_callback(&закройДинамичЗамокССЛ);
            CRYPTO_set_dynlock_destroy_callback(&удалиДинамичЗамокССЛ);

        }
    } 
}

static this()
{
    version(Win32)
        loadEAY32();
    загрузиОпенССЛ();
}
// Though it would be nice to do this, it can't be закрыт until all the СОКЕТs and etc have been collected.. not sure how to do that.
/*static ~this()
{
    закройОпенССЛ();
}*/


Длл грузиБиб(ткст[] путьЗагрузки)
{
    Длл rtn;
    foreach(путь; путьЗагрузки)
    {
        try
            rtn = Длл.загрузи(путь);
        catch (ИсклДлл ex)
        {
            ткст текрабпап = ФСистема.дайПапку();
            try
                rtn = Длл.загрузи(текрабпап ~ путь);
            catch (ИсклДлл ex)
            {}
        }
    }
    return rtn;
}

version (Win32)
{
    проц loadEAY32()
    {
        ткст[] путьЗагрузки = [ "libeay32.dll" ];
        if ((eaylib = грузиБиб(путьЗагрузки)) !is null)
        {
            вяжиКрипто(eaylib);    
        }
    }

}

проц вяжиКрипто(Длл ssllib)
{
    if (ssllib)
    {
        вяжиФ(X509_cmp, "X509_cmp", ssllib);
        вяжиФ(OPENSSL_add_all_algorithms_noconf, "OPENSSL_add_all_algorithms_noconf", ssllib);
        вяжиФ(ASN1_TIME_to_generalizedtime, "ASN1_TIME_to_generalizedtime", ssllib);
        вяжиФ(ASN1_STRING_free, "ASN1_STRING_free", ssllib);
        вяжиФ(EVP_PKEY_cmp_parameters, "EVP_PKEY_cmp_parameters", ssllib);
        вяжиФ(X509_STORE_CTX_get_current_cert, "X509_STORE_CTX_get_current_cert", ssllib);
        вяжиФ(X509_STORE_CTX_get_error_depth, "X509_STORE_CTX_get_error_depth", ssllib);
        вяжиФ(X509_STORE_CTX_get_error, "X509_STORE_CTX_get_error", ssllib);
        вяжиФ(X509_STORE_new, "X509_STORE_new", ssllib);
        вяжиФ(X509_STORE_free, "X509_STORE_free", ssllib);
        вяжиФ(X509_STORE_add_cert, "X509_STORE_add_cert", ssllib);
//        вяжиФ(X509_STORE_set_depth, "X509_STORE_set_depth", ssllib);
        вяжиФ(BIO_new_mem_buf, "BIO_new_mem_buf", ssllib);
        вяжиФ(RSA_generate_key, "RSA_generate_key", ssllib);
        вяжиФ(EVP_PKEY_new, "EVP_PKEY_new", ssllib);
        вяжиФ(EVP_PKEY_assign, "EVP_PKEY_assign", ssllib);
        вяжиФ(RSA_free, "RSA_free", ssllib);
        вяжиФ(BIO_new, "BIO_new", ssllib);
        вяжиФ(BIO_s_mem, "BIO_s_mem", ssllib);
        вяжиФ(PEM_write_bio_PKCS8PrivateKey, "PEM_write_bio_PKCS8PrivateKey", ssllib);
        вяжиФ(EVP_aes_256_cbc, "EVP_aes_256_cbc", ssllib);
        вяжиФ(PEM_ASN1_read_bio, "PEM_ASN1_read_bio", ssllib);
        вяжиФ(d2i_X509, "d2i_X509", ssllib);
        вяжиФ(d2i_RSAPublicKey, "d2i_RSAPublicKey", ssllib);
        вяжиФ(X509_new, "X509_new", ssllib);
        вяжиФ(X509_free, "X509_free", ssllib);
        вяжиФ(X509_set_version, "X509_set_version", ssllib);
        вяжиФ(ASN1_INTEGER_set, "ASN1_INTEGER_set", ssllib);
        вяжиФ(X509_get_serialNumber, "X509_get_serialNumber", ssllib);
        вяжиФ(ASN1_INTEGER_get, "ASN1_INTEGER_get", ssllib);
        вяжиФ(X509_gmtime_adj, "X509_gmtime_adj", ssllib);
        вяжиФ(X509_set_pubkey, "X509_set_pubkey", ssllib);
        вяжиФ(X509_get_subject_name, "X509_get_subject_name", ssllib);
        вяжиФ(X509_NAME_print_ex, "X509_NAME_print_ex", ssllib);
        вяжиФ(X509_set_issuer_name, "X509_set_issuer_name", ssllib);
        вяжиФ(X509_sign, "X509_sign", ssllib);
        вяжиФ(EVP_sha1, "EVP_sha1", ssllib);
        вяжиФ(X509_STORE_CTX_new, "X509_STORE_CTX_new", ssllib);
        вяжиФ(X509_STORE_CTX_init, "X509_STORE_CTX_init", ssllib);
        вяжиФ(X509_verify_cert, "X509_verify_cert", ssllib);
        вяжиФ(X509_STORE_CTX_free, "X509_STORE_CTX_free", ssllib);
        вяжиФ(PEM_ASN1_write_bio, "PEM_ASN1_write_bio", ssllib);
        вяжиФ(i2d_X509, "i2d_X509", ssllib);
        вяжиФ(i2d_RSAPublicKey, "i2d_RSAPublicKey", ssllib);
        вяжиФ(X509_NAME_add_entry_by_txt, "X509_NAME_add_entry_by_txt", ssllib);
        вяжиФ(PEM_read_bio_PrivateKey, "PEM_read_bio_PrivateKey", ssllib);
        вяжиФ(BIO_new_file, "BIO_new_file", ssllib);
        вяжиФ(ERR_peek_error, "ERR_peek_error", ssllib);
        try
            вяжиФ(BIO_test_flags, "BIO_test_flags", ssllib); // 0.9.7 doesn't have this function, it access the struct directly
        catch (Исключение ex)
            _bioTestFlags = false;
        вяжиФ(BIO_ctrl, "BIO_ctrl", ssllib);
        вяжиФ(RAND_load_file, "RAND_load_file", ssllib);
        вяжиФ(CRYPTO_num_locks, "CRYPTO_num_locks", ssllib);
        вяжиФ(CRYPTO_set_id_callback, "CRYPTO_set_id_callback", ssllib);
        вяжиФ(CRYPTO_set_locking_callback, "CRYPTO_set_locking_callback", ssllib);
        вяжиФ(CRYPTO_set_dynlock_create_callback, "CRYPTO_set_dynlock_create_callback", ssllib);
        вяжиФ(CRYPTO_set_dynlock_lock_callback, "CRYPTO_set_dynlock_lock_callback", ssllib);
        вяжиФ(CRYPTO_set_dynlock_lock_callback, "CRYPTO_set_dynlock_lock_callback", ssllib);
        вяжиФ(CRYPTO_set_dynlock_destroy_callback, "CRYPTO_set_dynlock_destroy_callback", ssllib);
        вяжиФ(ERR_get_error_line_data, "ERR_get_error_line_data", ssllib);
        вяжиФ(ERR_remove_state, "ERR_remove_state", ssllib);
        вяжиФ(RAND_cleanup, "RAND_cleanup", ssllib);
        вяжиФ(ERR_free_strings, "ERR_free_strings", ssllib);
        вяжиФ(EVP_cleanup, "EVP_cleanup", ssllib);
        вяжиФ(OBJ_cleanup, "OBJ_cleanup", ssllib);
        вяжиФ(X509V3_EXT_cleanup, "X509V3_EXT_cleanup", ssllib);
        вяжиФ(CRYPTO_cleanup_all_ex_data, "CRYPTO_cleanup_all_ex_data", ssllib);
        вяжиФ(BIO_read, "BIO_read", ssllib);
        вяжиФ(BIO_write, "BIO_write", ssllib);
        вяжиФ(EVP_PKEY_free, "EVP_PKEY_free", ssllib);
        вяжиФ(d2i_PrivateKey, "d2i_PrivateKey", ssllib);    
        вяжиФ(BIO_free_all, "BIO_free_all", ssllib);
        вяжиФ(BIO_push, "BIO_push", ssllib);    
        вяжиФ(BIO_new_socket, "BIO_new_socket", ssllib);
        вяжиФ(RAND_poll, "RAND_poll", ssllib);
        вяжиФ(RSA_size, "RSA_size", ssllib);
        вяжиФ(RSA_public_encrypt, "RSA_public_encrypt", ssllib);
        вяжиФ(RSA_private_decrypt, "RSA_private_decrypt", ssllib);
        вяжиФ(RSA_private_encrypt, "RSA_private_encrypt", ssllib);
        вяжиФ(RSA_public_decrypt, "RSA_public_decrypt", ssllib);
        вяжиФ(RSA_sign, "RSA_sign", ssllib);
        вяжиФ(RSA_verify, "RSA_verify", ssllib);
        вяжиФ(MD5_Init, "MD5_Init", ssllib);
        вяжиФ(MD5_Update, "MD5_Update", ssllib);
        вяжиФ(MD5_Final, "MD5_Final", ssllib);
        вяжиФ(EVP_EncryptInit_ex, "EVP_EncryptInit_ex", ssllib);
        вяжиФ(EVP_DecryptInit_ex, "EVP_DecryptInit_ex", ssllib);
        вяжиФ(EVP_EncryptUpdate, "EVP_EncryptUpdate", ssllib);
        вяжиФ(EVP_DecryptUpdate,  "EVP_DecryptUpdate", ssllib);
        вяжиФ(EVP_EncryptFinal_ex, "EVP_EncryptFinal_ex", ssllib);
        вяжиФ(EVP_DecryptFinal_ex, "EVP_DecryptFinal_ex", ssllib);
        вяжиФ(EVP_aes_128_cbc, "EVP_aes_128_cbc", ssllib);
        try {
            вяжиФ(EVP_CIPHER_CTX_block_size, "EVP_CIPHER_CTX_block_size", ssllib);
        } catch (Исключение e){
            // openSSL 0.9.7l defines only macros, not the function
            EVP_CIPHER_CTX_block_size=&EVP_CIPHER_CTX_block_size_097l;
        }
        вяжиФ(EVP_CIPHER_CTX_cleanup, "EVP_CIPHER_CTX_cleanup", ssllib);
    }
}

проц загрузиОпенССЛ()
{
    version (linux)
    {
        ткст[] путьЗагрузки = [ "libssl.so.0.9.8", "libssl.so" ];
    }
    version (Win32)
    {
        ткст[] путьЗагрузки = [ "libssl32.dll" ];
    }
    version (darwin)
    {
        ткст[] путьЗагрузки = [ "/usr/lib/libssl.dylib", "libssl.dylib" ];
    }
    version (freebsd)
    {
        ткст[] путьЗагрузки = [ "libssl.so.5", "libssl.so" ];
    }
    version (solaris)
    {
        ткст[] путьЗагрузки = [ "libssl.so.0.9.8", "libssl.so" ];
    }
    if ((ssllib = грузиБиб(путьЗагрузки)) !is null)
    {

        вяжиФ(BIO_new_ssl, "BIO_new_ssl", ssllib);
        вяжиФ(SSL_CTX_free, "SSL_CTX_free", ssllib);
        вяжиФ(SSL_CTX_new, "SSL_CTX_new", ssllib);
        вяжиФ(SSLv23_method, "SSLv23_method", ssllib);
        вяжиФ(SSL_CTX_use_PrivateKey, "SSL_CTX_use_PrivateKey", ssllib);
        вяжиФ(SSL_CTX_set_verify, "SSL_CTX_set_verify", ssllib);
        вяжиФ(SSL_CTX_ctrl, "SSL_CTX_ctrl", ssllib);
        вяжиФ(SSL_CTX_set_cipher_list, "SSL_CTX_set_cipher_list", ssllib);
        вяжиФ(SSL_load_error_strings, "SSL_load_error_strings", ssllib);
        вяжиФ(SSL_library_init, "SSL_library_init", ssllib);
        вяжиФ(SSL_CTX_check_private_key, "SSL_CTX_check_private_key", ssllib);
        вяжиФ(SSL_get_shutdown, "SSL_get_shutdown", ssllib);
        вяжиФ(SSL_set_shutdown, "SSL_set_shutdown", ssllib);
        вяжиФ(SSL_CTX_use_certificate, "SSL_CTX_use_certificate", ssllib);
        вяжиФ(SSL_CTX_set_cert_store, "SSL_CTX_set_cert_store", ssllib);
        вяжиФ(SSL_CTX_load_verify_locations, "SSL_CTX_load_verify_locations", ssllib);
        вяжиФ(SSL_CTX_set_session_id_context, "SSL_CTX_set_session_id_context", ssllib);
        version(Posix)
        {
            version(darwin){
                ткст[] loadPathCrypto = [ "/usr/lib/libcrypto.dylib", "libcrypto.dylib" ];
                cryptolib = грузиБиб(loadPathCrypto);
                if (cryptolib !is null) вяжиКрипто(cryptolib);
            } else {
                вяжиКрипто(ssllib);
            }
        }

        _initOpenSSL();
    }
    else
        throw new Исключение("Не удалась загрузка библиотеки OpenSSL.");
}

проц закройОпенССЛ()
{
    CRYPTO_set_id_callback(null);
    CRYPTO_set_locking_callback(null);
    CRYPTO_set_dynlock_create_callback(null);
    CRYPTO_set_dynlock_lock_callback(null);
    CRYPTO_set_dynlock_destroy_callback(null);
    ERR_remove_state(0);
    RAND_cleanup();
    ERR_free_strings();
    EVP_cleanup();
    OBJ_cleanup();
    X509V3_EXT_cleanup();
    CRYPTO_cleanup_all_ex_data();
    if (ssllib)
        ssllib.выгрузи();
    version(darwin){
        if (cryptolib)
            cryptolib.выгрузи();
    }
    version(Win32)
    {
        if (eaylib)
            eaylib.выгрузи();
    }
}
