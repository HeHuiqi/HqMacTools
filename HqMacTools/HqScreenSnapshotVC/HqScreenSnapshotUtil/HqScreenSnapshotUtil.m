//
//  HqScreenSnapshotUtil.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/26.
//

#import "HqScreenSnapshotUtil.h"

@implementation HqScreenSnapshotUtil

+ (NSRect)uniformRect:(NSRect)rect {
    double x = rect.origin.x;
    double y = rect.origin.y;
    double w = rect.size.width;
    double h = rect.size.height;
    if (w < 0) {
        x += w;
        w = -w;
    }
    if (h < 0) {
        y += h;
        h = -h;
    }
    return NSMakeRect(x, y, w, h);
}
+ (BOOL)isPoint:(NSPoint)point inRect:(NSRect)rect{
    return NSPointInRect(point, rect);
}
+ (double)pointDistance:(NSPoint)p1 toPoint:(NSPoint)p2
{
    return (p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y);
}
+ (NSRect)cgWindowRectToScreenRect:(CGRect)windowRect{
    NSRect mainRect = [NSScreen mainScreen].frame;
    for (NSScreen *screen in [NSScreen screens]) {
        if ((int) screen.frame.origin.x == 0 && (int) screen.frame.origin.y == 0) {
            mainRect = screen.frame;
            break;
        }
    }
    NSRect rect = NSMakeRect(windowRect.origin.x, mainRect.size.height - windowRect.size.height - windowRect.origin.y, windowRect.size.width, windowRect.size.height);
    return rect;
}

+ (NSImage *)viewToImage:(NSView *)view inReact:(NSRect)rect{
    
    NSBitmapImageRep *brep = [view bitmapImageRepForCachingDisplayInRect:rect];
    [view cacheDisplayInRect:rect toBitmapImageRep:brep];
    
    NSImage *image = [[NSImage alloc] init];
    [image addRepresentation:brep];
    
    return image;
}
+ (NSBitmapImageRep *)viewToBitmapImage:(NSView *)view inReact:(NSRect)rect{
    
    NSBitmapImageRep *brep = [view bitmapImageRepForCachingDisplayInRect:rect];
    [view cacheDisplayInRect:rect toBitmapImageRep:brep];
    
    return brep;
}
+ (NSImage *)bitmapImageToImage:(NSBitmapImageRep *)bitmapImage {
    NSDictionary *imageProps = @{NSImageCompressionFactor : @(1.0)};
    //转化为NSData 以便存到文件中
    NSData *imageData = [bitmapImage representationUsingType:NSBitmapImageFileTypeJPEG properties:imageProps];
    NSImage *image = [[NSImage alloc] initWithData:imageData];
    
    return image;
}
@end
