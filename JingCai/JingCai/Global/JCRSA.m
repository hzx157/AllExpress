//
//  JCRSA.m
//  JingCai
//
//  Created by xiaowuxiaowu on 16/5/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "JCRSA.h"
#import <Security/Security.h>
#import "NSString+Base64.h"
#import "NSData+Base64.h"
#import "AESEnCryption.h"
@implementation JCRSA

/*
static NSString *base64_encode(NSString *str){
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    if(!data){
        return nil;
    }
    return base64_encode_data(data);
}


static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}
*/
+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
    // Skip ASN.1 public key header
    if (d_key == nil) return(nil);
    
    
    unsigned long len = [d_key length];
    if (!len) return(nil);
    
    unsigned char *c_key = (unsigned char *)[d_key bytes];
    unsigned int  idx	= 0;
    
    if (c_key[idx++] != 0x30) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    // PKCS #1 rsaEncryption szOID_RSA_RSA
    static unsigned char seqiod[] =
    { 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
        0x01, 0x05, 0x00 };
    if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
    
    idx += 15;
    
    if (c_key[idx++] != 0x03) return(nil);
    
    if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
    else idx++;
    
    if (c_key[idx++] != '\0') return(nil);
    
    // Now make a new NSData from this buffer
    return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

+ (SecKeyRef)addPublicKey:(NSString *)keys{
    
    NSString *resourcePath = nil;
    
    if([keys isEqualToString:@"im"]){
        resourcePath = [[NSBundle mainBundle] pathForResource:@"im_rsa_public_key" ofType:@"der"];
    }else if([keys isEqualToString:@"server"]){
        resourcePath = [[NSBundle mainBundle] pathForResource:@"biz_public_key" ofType:@"der"];
    }
    else{
        resourcePath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    }
    
    NSData *certData = [NSData dataWithContentsOfFile:resourcePath];
    
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certData);
    SecKeyRef key = NULL;
    SecTrustRef trust = NULL;
    SecPolicyRef policy = NULL;
    if (cert != NULL) {
        policy = SecPolicyCreateBasicX509();
        if (policy) {
            if (SecTrustCreateWithCertificates((CFTypeRef)cert, policy, &trust) == noErr) {
                SecTrustResultType result;
                if (SecTrustEvaluate(trust, &result) == noErr) {
                    key = SecTrustCopyPublicKey(trust);
                }
            }
        }
    }
    if (policy) CFRelease(policy);
    if (trust) CFRelease(trust);
    if (cert) CFRelease(cert);
    
    return key;
}

+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)pubKey{
    
    NSData *data = [JCRSA encryptData:[str dataUsingEncoding:NSUTF8StringEncoding] publicKey:pubKey];
    
    NSString *ret = [JCRSA base64Encode:data];
    
    return ret;
}

+ (NSString*) base64Encode:(NSData *)data
{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    int length = (int)[data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}


+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey{
    if(!data || !pubKey){
        return nil;
    }
    
    SecKeyRef keyRef = [JCRSA addPublicKey:pubKey];
    
    if(!keyRef){
        return nil;
    }
    
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    if(srclen > outlen - 11){
        CFRelease(keyRef);
        return nil;
    }
    void *outbuf = malloc(outlen);
    
    OSStatus status = noErr;
    status = SecKeyEncrypt(keyRef,
                           kSecPaddingNone,
                           srcbuf,
                           srclen,
                           outbuf,
                           &outlen
                           );
    NSData *ret = nil;
    if (status != 0) {
        //DLog(@"SecKeyEncrypt fail. Error Code: %ld", status);
    }else{
        ret = [NSData dataWithBytes:outbuf length:outlen];
    }
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}

+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey{
    //	NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSData *data = [str base64DecodedData];
    
    data = [JCRSA decryptData:data publicKey:pubKey];
    
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return ret;
}

+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey{
    
    if(!data || !pubKey){
        return nil;
    }
    
    SecKeyRef keyRef = [JCRSA addPublicKey:pubKey];
    
    if(!keyRef){
        return nil;
    }
    
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    
    size_t srclen = (size_t)data.length;
    
    size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
    if(srclen != outlen){
        //TODO currently we are able to decrypt only one block!
        CFRelease(keyRef);
        return nil;
    }
    UInt8 *outbuf = malloc(outlen);
    
    //use kSecPaddingNone in decryption mode
    OSStatus status = noErr;
    status = SecKeyDecrypt(keyRef,
                           kSecPaddingNone,
                           srcbuf,
                           srclen,
                           outbuf,
                           &outlen
                           );
    NSData *result = nil;
    if (status != 0) {
        //DLog(@"SecKeyEncrypt fail. Error Code: %ld", status);
    }else{
        //the actual decrypted data is in the middle, locate it!
        int idxFirstZero = -1;
        int idxNextZero = (int)outlen;
        for ( int i = 0; i < outlen; i++ ) {
            if ( outbuf[i] == 0 ) {
                if ( idxFirstZero < 0 ) {
                    idxFirstZero = i;
                } else {
                    idxNextZero = i;
                    break;
                }
            }
        }
        
        result = [NSData dataWithBytes:&outbuf[idxFirstZero+1] length:idxNextZero-idxFirstZero-1];
    }
    
    free(outbuf);
    CFRelease(keyRef);
    return result;
    
}


#pragma mark ----------------------- 为内容进行加密 ----------------------------
+(NSDictionary *)aes:(NSDictionary *)dic
{
    NSString *paramStr = [dic mj_JSONString];
    
    NSData *ak_data = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *resource = [[paramStr dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:ak_data];
    
    paramStr = [resource base64EncodedString];
    
    DLog(@"paramStr - %@",paramStr);
    NSDictionary *paramList = @{@"paramList":[Common getNULLString:paramStr]};
    return paramList;
    
}

#pragma mark ----------------------- 为内容进行解密 ----------------------------
+(NSDictionary *)unAes:(NSString *)paramStr
{
    //base64逆转
    NSData *resource = [NSData dataWithBase64EncodedString:paramStr];
    //aes加密key
    NSData *ak_data = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    //解密之后的utf-8数据
    NSData *data_utf = [resource AES256DecryptWithKey:ak_data];
    //utf－8数据转NSString
    NSString *jsonStr = [[NSString alloc] initWithData:data_utf encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [jsonStr mj_JSONObject];
    DLog(@"解密后的data数据 --- %@",dic);
    return dic;
}

@end
