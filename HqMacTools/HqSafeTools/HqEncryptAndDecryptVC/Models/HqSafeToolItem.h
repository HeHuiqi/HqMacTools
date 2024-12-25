//
//  HqSafeToolItem.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/20.
//

#import <Foundation/Foundation.h>
#import "HqSafeToolConsts.h"

NS_ASSUME_NONNULL_BEGIN

@interface HqSafeToolItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) HqHashType hashType;
@property (nonatomic, assign) HqEncodeType encodeType;
@property (nonatomic, assign) HqEncryptType encryptType;



@end

NS_ASSUME_NONNULL_END
