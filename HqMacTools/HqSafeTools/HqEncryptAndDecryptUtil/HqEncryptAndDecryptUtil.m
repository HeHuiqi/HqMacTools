//
//  HqEncryptAndDecryptUtil.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/23.
//

#import "HqEncryptAndDecryptUtil.h"
#import "HqAESUtil.h"
#import "NSData+HqDataExt.h"
#import "HqEncodeDecodeUtil.h"

@implementation HqEncryptAndDecryptUtil
+ (NSData *)encryptData:(NSData *)data key:(NSString *)key encryptType:(HqEncryptType)type{
    NSData *result;

    switch (type) {
        case HqEncryptTypeAES:
        {
            result = [HqAESUtil AES256EncryptWithKey:key originalData:data];
        }
            break;
            
        default:
            break;
    }
  

    return result;
}

+ (NSData *)decryptData:(NSData *)data key:(NSString *)key encryptType:(HqEncryptType)type {
    
    NSData *result;
    switch (type) {
        case HqEncryptTypeAES:
        {
            result = [HqAESUtil AES256DecryptWithKey:key encyptData:data];
        }
            break;
            
        default:
            break;
    }
    
    return result;
}

@end

