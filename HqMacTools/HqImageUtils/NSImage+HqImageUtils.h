//
//  NSImage+HqImageUtils.h
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/17.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSImage (HqImageUtils)

+ (NSImage *)imageFromFilePath:(NSString *)filePath;
- (NSImage *)removeAlpha;
- (void)copyToPasteboard:(void(^)(void))complete;
@end

NS_ASSUME_NONNULL_END
