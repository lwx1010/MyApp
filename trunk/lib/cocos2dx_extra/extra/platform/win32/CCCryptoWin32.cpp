
#include "crypto/CCCrypto.h"
#include "crypto/aes/aes.h"

NS_CC_EXTRA_BEGIN

// aes√ÿ‘ø≥§∂»
static const int AES_KEY_LEN = 16;

// aesº”√‹º‰∏Ù
static const int AES_STEP_LEN = AES_KEY_LEN;

int CCCrypto::getAES256KeyLength(void)
{
    //CCLOG("CCCrypto::getAES256KeyLength() - not support this platform.");
    return AES_KEY_LEN;
}

int CCCrypto::cryptAES256(bool isDecrypt,
                          unsigned char* input,
                          int inputLength,
                          unsigned char* output,
                          int outputBufferLength,
                          unsigned char* key,
                          int keyLength)
{
	//CCLOG("CCCrypto::cryptAES256() - not support this platform.");

	if( inputLength<=0 || keyLength<=0 )
	{
		return 0;
	}

	unsigned char userKey[AES_KEY_LEN];
	memset(userKey, 0xa, sizeof(userKey));
	memcpy(userKey, key, keyLength>AES_KEY_LEN?AES_KEY_LEN:keyLength);

	AES_KEY aesKey;
	memset(&aesKey, 0, sizeof(aesKey));
	if( isDecrypt )
	{
		X6AES_set_decrypt_key((const unsigned char*)userKey, 128, &aesKey);
	}
	else
	{
		X6AES_set_encrypt_key((const unsigned char*)userKey, 128, &aesKey);
	}

	int paddingCnt = 0;

	// ÃÓ≥‰
	if( !isDecrypt )
	{
		paddingCnt = AES_STEP_LEN*(int(inputLength/AES_STEP_LEN)+1)-inputLength;
	}

	memset(output, paddingCnt, outputBufferLength);
	memcpy(output, input, inputLength);

	unsigned char* cur;
	for( int i=0; i<inputLength; i+=AES_STEP_LEN )
	{
		cur = (unsigned char*)output+i;
		if( isDecrypt )
		{
			X6AES_decrypt(cur, cur, &aesKey);
		}
		else
		{
			X6AES_encrypt(cur, cur, &aesKey);
		}
	}

	// »•µÙÃÓ≥‰
	if( isDecrypt )
	{
		paddingCnt = -((char*)output)[inputLength-1];
	}
	
	inputLength += paddingCnt;
    
    return inputLength;
}

NS_CC_EXTRA_END
