//
//  HqScreenSnapshotUtil.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HqScreenSnapshotUtil : NSObject

+ (NSRect)uniformRect:(NSRect)rect;
+ (BOOL)isPoint:(NSPoint)point inRect:(NSRect)rect;
+ (double)pointDistance:(NSPoint)p1 toPoint:(NSPoint)p2;
+ (NSRect)cgWindowRectToScreenRect:(CGRect)windowRect;

+ (NSBitmapImageRep *)viewToBitmapImage:(NSView *)view inReact:(NSRect)rect;
+ (NSImage *)bitmapImageToImage:(NSBitmapImageRep *)bitmapImage;

@end

NS_ASSUME_NONNULL_END
