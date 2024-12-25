//
//  HqScreenSnapshotWindow.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/26.
//

#import "HqScreenSnapshotWindow.h"

#import "HqScreenSnapshotConfig.h"

@implementation HqScreenSnapshotWindow

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [NSColor.blackColor colorWithAlphaComponent:0.1];
//        self.backgroundColor = [NSColor clearColor];

        self.styleMask = NSWindowStyleMaskNonactivatingPanel;
        //设置允许接受鼠标事件
        self.acceptsMouseMovedEvents = YES;
        self.floatingPanel = YES;
        self.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorFullScreenAuxiliary;
        self.excludedFromWindowsMenu = YES;
        self.hidesOnDeactivate = NO;
        self.restorable = NO;
        [self disableSnapshotRestoration];
        self.movable = NO;

        //关键代码，可以使window填充整个屏幕
        self.level = kCGMaximumWindowLevel;


    }
    return self;
}

+ (HqScreenSnapshotWindow *)snapshotWindowWithScreen:(NSScreen *)screen{
//    HqScreenSnapshotWindow *window = [[self alloc] initWithContentRect:screen.frame styleMask:NSWindowStyleMaskNonactivatingPanel backing:(NSBackingStoreBuffered) defer:NO];
//    window.backgroundColor = [NSColor.blackColor colorWithAlphaComponent:0.5];
    
    HqScreenSnapshotWindow *window = [[HqScreenSnapshotWindow alloc] init];
    [window setFrame:screen.frame display:YES];
    
    
    return window;
}
/*
- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag screen:(NSScreen *)screen {
    if (self = [super initWithContentRect:contentRect styleMask:aStyle backing:NSBackingStoreBuffered defer:NO screen:screen]) {
        [self setAcceptsMouseMovedEvents:YES];
        [self setFloatingPanel:YES];
        [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces | NSWindowCollectionBehaviorFullScreenAuxiliary];
        [self setMovableByWindowBackground:NO];
        [self setExcludedFromWindowsMenu:YES];
        [self setAlphaValue:1.0];
        [self setOpaque:NO];
        [self setHasShadow:NO];
        [self setHidesOnDeactivate:NO];
        [self setLevel:kCGMaximumWindowLevel];
        [self setRestorable:NO];
        [self disableSnapshotRestoration];
        [self setLevel:kCGMaximumWindowLevel];

        self.movable = NO;
    }
    return self;
}
*/
#pragma mark - 鼠标事件
- (void)mouseMoved:(NSEvent *)event{
    [super mouseMoved:event];
    //将事件传递给 contentView
    [self.contentView mouseMoved:event];

}
- (void)mouseDown:(NSEvent *)event{
    //将事件传递给 contentView
    [self.contentView moveDown:event];
}
- (void)mouseDragged:(NSEvent *)event{
    //将事件传递给 contentView
    [self.contentView mouseDragged:event];
}
- (void)mouseUp:(NSEvent *)event{
    //将事件传递给 contentView
    [self.contentView mouseUp:event];
}
- (BOOL)canBecomeKeyWindow{
    return YES;
}

- (BOOL)canBecomeMainWindow{
    return YES;
}
@end
