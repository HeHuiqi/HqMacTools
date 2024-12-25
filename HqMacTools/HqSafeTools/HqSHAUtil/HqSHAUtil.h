//
//  HqSHAUtil.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/19.
//

#import <Foundation/Foundation.h>
#import "HqSafeToolConsts.h"

NS_ASSUME_NONNULL_BEGIN

@interface HqSHAUtil : NSObject

+ (NSString *)shaWithData:(NSData *)data hashType:(HqHashType)type;

@end

NS_ASSUME_NONNULL_END
