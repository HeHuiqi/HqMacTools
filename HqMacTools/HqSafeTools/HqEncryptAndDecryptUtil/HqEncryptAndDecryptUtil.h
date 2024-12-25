//
//  HqEncryptAndDecryptUtil.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/23.
//

#import <Foundation/Foundation.h>
#import "HqSafeToolConsts.h"

NS_ASSUME_NONNULL_BEGIN

@interface HqEncryptAndDecryptUtil : NSObject


+ (NSData *)encryptData:(NSData *)data key:(NSString *)key encryptType:(HqEncryptType)type;

+ (NSData *)decryptData:(NSData *)data key:(NSString *)key encryptType:(HqEncryptType)type;

@end

NS_ASSUME_NONNULL_END
