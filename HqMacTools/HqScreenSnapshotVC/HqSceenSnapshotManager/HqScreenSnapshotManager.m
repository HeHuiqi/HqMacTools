//
//  HqScreenSnapshotManager.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/26.
//

#import "HqScreenSnapshotManager.h"
#import "HqVCManager.h"
#import "HqScreenSnapshotVC.h"
#import "HqScreenSnapshotWindow.h"
#import "NSImage+HqImageUtils.h"

@implementation HqScreenSnapshotManager

+ (HqScreenSnapshotManager *)shared {
    static HqScreenSnapshotManager *ssm;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ssm = [[self alloc] init];
    });
    return ssm;
}


- (NSArray<NSDictionary*>*)allWindowInfoList{
    NSArray<NSDictionary*>* windowInfoList = (__bridge_transfer id) CGWindowListCopyWindowInfo(kCGWindowListOptionOnScreenOnly, kCGNullWindowID);
    return windowInfoList;
}
- (NSDictionary *)currentWindowInfo{
    int processID = [[NSProcessInfo processInfo] processIdentifier];
    NSArray<NSDictionary*>* windowInfoList = [self allWindowInfoList];
    NSDictionary *currentWindowInfo;
    for (NSDictionary* info in windowInfoList) {
        NSInteger thisProcessID = [info[(__bridge NSString *)kCGWindowOwnerPID] integerValue];
        if (thisProcessID == processID) {
            currentWindowInfo = info;
            break;
        }
    }
    return currentWindowInfo;
}
- (NSRect)windowRectWithIno:(NSDictionary *)info {
    CGRect windowRect = CGRectZero;
    CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)info[(id) kCGWindowBounds], &windowRect);
    return windowRect;
}
- (NSInteger)windowLayerWithInfo:(NSDictionary *)info {
    NSInteger layer = 0;
    CFNumberRef numberRef = (__bridge CFNumberRef) info[(id) kCGWindowLayer];
    CFNumberGetValue(numberRef, kCFNumberSInt32Type, &layer);
    return layer;
}
- (NSArray<NSValue *> *)allWindowRect{
    NSArray<NSDictionary*>* windowInfoList = [self allWindowInfoList];
    NSMutableArray *rectArray = @[].mutableCopy;
    for (NSDictionary* info in windowInfoList) {
        CGRect windowRect = CGRectZero;
        CGRectMakeWithDictionaryRepresentation((__bridge CFDictionaryRef)info[(id) kCGWindowBounds], &windowRect);
        [rectArray addObject:@(windowRect)];
    }
    return rectArray;
}
- (NSImage *)mainScreenSnapshot{
    return [self screenSnaphot:NSScreen.mainScreen];
}
- (NSImage *)screenSnaphot:(NSScreen *)screen {
    
    NSRect rect = screen.frame;
    CGWindowListOption opt = kCGWindowListOptionAll;
    
    
//    CFArrayRef windowsRef = CGWindowListCreate(opt, kCGNullWindowID);
//    CGImageRef imgRef = CGWindowListCreateImageFromArray(rect, windowsRef, kCGWindowImageDefault);
//    CFRelease(windowsRef);

    CGImageRef imgRef = CGWindowListCreateImage(rect, opt, kCGNullWindowID, kCGWindowImageDefault);

    return  [[NSImage alloc] initWithCGImage:imgRef size:screen.frame.size];
}

- (void)showSnapshotVC {
    
    NSScreen *screen = NSScreen.mainScreen;
    screen = NSScreen.screens.lastObject;
    //一定要在设置window之前获取屏幕截图
    NSImage *image = [self screenSnaphot:screen];

//    [image copyToPasteboard:^{
//        
//    }];
    
    
    
    HqScreenSnapshotVC *vc = (HqScreenSnapshotVC *)[HqVCManager createViewControllerUseNib:HqScreenSnapshotVC.class];
    
    vc.snapshotView.frame = screen.frame;
    
    vc.snapshotView.screenSnapshotImage = image;
    
    NSWindowController *wvc = [[NSWindowController alloc] init];
    wvc.contentViewController = vc;
    HqScreenSnapshotWindow *window = [HqScreenSnapshotWindow snapshotWindowWithScreen:screen];
    wvc.window = window;
    
    [wvc showWindow:nil];

    
}

@end
