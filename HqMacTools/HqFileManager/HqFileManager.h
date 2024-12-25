//
//  HqFileManager.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/9/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HqFileManager : NSObject

+ (BOOL)lockFile:(NSString *)filePath;
+ (BOOL)unlockFile:(NSString *)filePath;
@end

NS_ASSUME_NONNULL_END
