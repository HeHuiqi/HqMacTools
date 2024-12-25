//
//  HqHashUtil.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/20.
//

#import <Foundation/Foundation.h>
#import "HqSafeToolConsts.h"

NS_ASSUME_NONNULL_BEGIN

@interface HqHashUtil : NSObject

+ (NSString *)hashWithData:(NSData *)data hashType:(HqHashType)type;

@end

NS_ASSUME_NONNULL_END
