//
//  HqEncodeDecodeUtil.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/23.
//

#import "HqEncodeDecodeUtil.h"


@implementation HqEncodeDecodeUtil

+ (NSString *)encodeData:(NSData *)data encodeType:(HqEncodeType)type {
    NSString *result;
    switch (type) {
        case HqEncodeTypeBase64:
            result = [self base64Encode:data];
            break;
            
        default:
            break;
    }
    return result;
    
}
+ (NSData *)decodeString:(NSString *)string encodeType:(HqEncodeType)type {
    
    NSData *result;
    switch (type) {
        case HqEncodeTypeBase64:
            result = [self base64Decode:string];
            break;
            
        default:
            break;
    }
    return result;
}

+ (NSString *)base64Encode:(NSData *)data {
    data = [data base64EncodedDataWithOptions:(NSDataBase64EncodingEndLineWithLineFeed)];
    return  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
+ (NSData *)base64Decode:(NSString *)string {
    NSData *encodeData = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSData alloc] initWithBase64EncodedData:encodeData options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
}


@end
