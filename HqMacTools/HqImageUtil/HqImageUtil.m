//
//  HqImageUtil.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/8.
//

#import "HqImageUtil.h"
#import <ScreenCaptureKit/ScreenCaptureKit.h>
@implementation HqImageUtil

+ (NSImage *)cgImageToNsImage:(CGImageRef)imgRef{
    return  [[NSImage alloc] initWithCGImage:imgRef size:CGSizeZero];
}
+ (NSImage *)ciImageToNsImage:(CIImage *)ciImage{
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:ciImage];
    NSImage *nsImage = [[NSImage alloc] initWithSize:rep.size];
    [nsImage addRepresentation:rep];
    return nsImage;
}
+ (NSImage *)viewToImage:(NSView *)view{
    
    CGRect rect = view.frame;
    NSBitmapImageRep *brep = [view bitmapImageRepForCachingDisplayInRect:rect];
    [view cacheDisplayInRect:rect toBitmapImageRep:brep];
    NSImage *image = [[NSImage alloc] init];
    [image addRepresentation:brep];
    
    return image;
}
+ (NSImage *)viewToImage:(NSView *)view inReact:(NSRect)rect{
    
    NSBitmapImageRep *brep = [view bitmapImageRepForCachingDisplayInRect:rect];
    [view cacheDisplayInRect:rect toBitmapImageRep:brep];
    
    NSImage *image = [[NSImage alloc] init];
    [image addRepresentation:brep];
    
    return image;
}

+ (NSImage *)screenShot:(NSScreen *)screen {
    CFArrayRef windowsRef = CGWindowListCreate(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);

    NSRect rect = [screen frame];
    NSRect mainRect = [NSScreen mainScreen].frame;
    for (NSScreen *subScreen in [NSScreen screens]) {
        if ((int) subScreen.frame.origin.x == 0 && (int) subScreen.frame.origin.y == 0) {
            mainRect = subScreen.frame;
        }
    }
    rect = NSMakeRect(rect.origin.x, (mainRect.size.height) - (rect.origin.y + rect.size.height), rect.size.width, rect.size.height);

    NSLog(@"screenShot: %@", NSStringFromRect(rect));
    CGImageRef imgRef = CGWindowListCreateImageFromArray(rect, windowsRef, kCGWindowImageDefault);
    CFRelease(windowsRef);
    return  [[NSImage alloc] initWithCGImage:imgRef size:rect.size];
}
+ (NSImage *)mainScreenShot {
    return [self screenShot:[NSScreen mainScreen]];
}

+ (NSImage *)currentWindowShot{
    int processID = [[NSProcessInfo processInfo] processIdentifier];
    NSArray<NSDictionary*>* windowInfoList = (__bridge_transfer id) CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    NSInteger windowID = -1;
    for (NSDictionary* info in windowInfoList) {
        NSInteger thisProcess = [info[(__bridge NSString *)kCGWindowOwnerPID] integerValue];
        if (thisProcess == processID) {
            windowID = [info[(__bridge NSString *)kCGWindowNumber] integerValue];
            break;
        }
    }

    CGImageRef imgRef = CGWindowListCreateImage(CGRectNull, kCGWindowListOptionIncludingWindow, (int)windowID, kCGWindowImageDefault);
    return [self cgImageToNsImage:imgRef];
}

// 代码不可用，未测试，待研究
+ (NSImage *)newScreenShot{

    if (@available(macOS 12.3, *)) {
        
        [SCShareableContent getShareableContentExcludingDesktopWindows:NO onScreenWindowsOnly:YES completionHandler:^(SCShareableContent * _Nullable shareableContent, NSError * _Nullable error) {
            
            for (SCWindow *window in shareableContent.windows) {
                if (@available(macOS 13.1, *)) {
                    if(window.active){
                        SCContentFilter *filter = [[SCContentFilter alloc] initWithDesktopIndependentWindow:window];;
                        SCStreamConfiguration *config = [[SCStreamConfiguration alloc] init];
                        if (@available(macOS 14.0, *)) {
                            [SCScreenshotManager captureSampleBufferWithFilter:filter configuration:config completionHandler:^(CMSampleBufferRef  _Nullable sampleBuffer, NSError * _Nullable error) {
                                
                                CVImageBufferRef cvImageBuf = CMSampleBufferGetImageBuffer(sampleBuffer);
                                
                                CVPixelBufferGetIOSurface(cvImageBuf);
                                CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:cvImageBuf];

                            }];
                        } else {
                            // Fallback on earlier versions
                        }
                        break;
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            
        }];
       
    } else {
        // Fallback on earlier versions
    }
  
    return nil;
}
@end
