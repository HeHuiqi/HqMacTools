//
//  HqEncodeDecodeUtil.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/23.
//

#import <Foundation/Foundation.h>
#import "HqSafeToolConsts.h"

NS_ASSUME_NONNULL_BEGIN

@interface HqEncodeDecodeUtil : NSObject

+ (NSString *)encodeData:(NSData *)data encodeType:(HqEncodeType)type;
+ (NSData *)decodeString:(NSString *)string encodeType:(HqEncodeType)type;

@end

NS_ASSUME_NONNULL_END
