//
//  HqChooseFileUtils.h
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/24.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface HqChooseFileUtils : NSObject

+ (void)chooseFileComplete:(void(^)(NSString * filePath))complete;
+ (void)chooseDirComplete:(void(^)(NSString * filePath))complete;
@end

NS_ASSUME_NONNULL_END
