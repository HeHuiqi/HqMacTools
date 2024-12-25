//
//  HqImageUtil.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/8.
//

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HqImageUtil : NSObject

+ (NSImage *)cgImageToNsImage:(CGImageRef)imgRef;
+ (NSImage *)ciImageToNsImage:(CIImage *)ciImage;
+ (NSImage *)viewToImage:(NSView *)view;
+ (NSImage *)screenShot:(NSScreen *)screen;
+ (NSImage *)mainScreenShot;

@end

NS_ASSUME_NONNULL_END
