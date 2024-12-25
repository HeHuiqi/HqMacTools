//
//  HqSHAUtil.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/19.
//

#import "HqSHAUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HqSHAUtil


+ (NSString *)shaWithData:(NSData *)data hashType:(HqHashType)type {
    NSString *result = nil;
    switch (type) {
        case HqHashTypeSHA1:
            result = [self sha1WithData:data];
            break;
        case HqHashTypeSHA224:
            result = [self sha224WithData:data];
            break;

        case HqHashTypeSHA256:
            result = [self sha256WithData:data];

            break;
        case HqHashTypeSHA384:
            result = [self sha384WithData:data];

            break;
        case HqHashTypeSHA512:
            result = [self sha512WithData:data];

            break;
            
        default:
            break;
    }
    return result;
}

+ (NSString *)hexBytesToString:(unsigned char *)hexBytes len:(NSInteger)len{
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(NSInteger  i =0; i<len;i++){
        [outPutStr appendFormat:@"%02x",hexBytes[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return outPutStr;
}
+ (NSString *)sha1WithData:(NSData *)data{
    NSInteger len = CC_SHA1_DIGEST_LENGTH;
    unsigned char digist[len];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digist);
    return [self hexBytesToString:digist len:len];
}
+ (NSString *)sha224WithData:(NSData *)data{
    NSInteger len = CC_SHA224_DIGEST_LENGTH;
    unsigned char digist[len];
    CC_SHA224(data.bytes, (CC_LONG)data.length, digist);
    return [self hexBytesToString:digist len:len];
}
+ (NSString *)sha256WithData:(NSData *)data{
    NSInteger len = CC_SHA256_DIGEST_LENGTH;
    unsigned char digist[len];
    CC_SHA256(data.bytes, (CC_LONG)data.length, digist);
    return [self hexBytesToString:digist len:len];
}
+ (NSString *)sha384WithData:(NSData *)data{
    NSInteger len = CC_SHA384_DIGEST_LENGTH;
    unsigned char digist[len];
    CC_SHA384(data.bytes, (CC_LONG)data.length, digist);
    return [self hexBytesToString:digist len:len];
}

+ (NSString *)sha512WithData:(NSData *)data{
    NSInteger len = CC_SHA512_DIGEST_LENGTH;
    unsigned char digist[len];
    CC_SHA512(data.bytes, (CC_LONG)data.length, digist);
    return [self hexBytesToString:digist len:len];
}



@end
