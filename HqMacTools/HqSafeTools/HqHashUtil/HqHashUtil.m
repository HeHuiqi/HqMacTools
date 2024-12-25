//
//  HqHashUtil.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/20.
//

#import "HqHashUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "HqSHAUtil.h"
#import "HqMD5Util.h"

@implementation HqHashUtil

+ (NSString *)hashWithData:(NSData *)data hashType:(HqHashType)type{
    NSString *result = @"";
    switch (type) {
        case HqHashTypeMD5:
            result = [HqMD5Util MD5WithData:data];
            break;
        case HqHashTypeSHA1:
        case HqHashTypeSHA224:
        case HqHashTypeSHA256:
        case HqHashTypeSHA384:   
        case HqHashTypeSHA512:
            result = [HqSHAUtil shaWithData:data hashType:type];
            break;
            
        default:
            break;
    }
    return result;
}

@end
