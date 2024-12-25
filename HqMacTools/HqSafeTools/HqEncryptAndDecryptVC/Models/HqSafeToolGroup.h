//
//  HqSafeToolGroup.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/20.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HqSafeToolType) {
    HqSafeToolTypeHash,
    HqSafeToolTypeEncryptDecrypt,
    HqSafeToolTypeEncodeDecode,
};

NS_ASSUME_NONNULL_BEGIN

@interface HqSafeToolGroup : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) HqSafeToolType type;

@end

NS_ASSUME_NONNULL_END
