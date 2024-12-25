//
//  HqMD5Util.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/19.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

NS_ASSUME_NONNULL_BEGIN


@interface HqMD5Util :NSObject


+ (NSString*)MD5WithData:(NSData *)data;
+ (NSString*)MD5WithString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
