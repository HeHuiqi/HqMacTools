//
//  HqVCManager.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/13.
//

#import "HqVCManager.h"

@implementation HqVCManager


+ (void)showWindowWithVC:(NSViewController *)viewController setWindow:(void(^)(NSWindow * window))setWindow{
    
    NSWindowController *wvc = [[NSWindowController alloc] init];
    NSWindow *_window = [[NSWindow alloc] init];
    // styleMask NSWindowStyleMaskTitled 必须和其他选项搭配才能设置成功
    // 没有设置 NSWindowStyleMaskTitled，就设置其他是不会显示titlebar的
    _window.styleMask = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable| NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable;
    if(setWindow){
        setWindow(_window);
    }
    wvc.window = _window;
    wvc.contentViewController = viewController;
   
    [wvc showWindow:nil];
    [wvc.window center];
    
}
+ (void)showWindowWithVC:(NSViewController *)viewController setWindowVC:(nullable HqWindowVCSetBlock)setWindowVC{
    
    NSWindowController *wvc = [[NSWindowController alloc] init];
    NSWindow *window = [[NSWindow alloc] init];
    window.styleMask = NSWindowStyleMaskClosable|NSWindowStyleMaskTitled;
  
    wvc.window = window;
    wvc.contentViewController = viewController;
    
    if(setWindowVC){
        setWindowVC(wvc);
    }
   
    [wvc showWindow:nil];
    [wvc.window center];
    
}
+ (void)showWindowWithVC:(NSViewController *)viewController{
    [self showWindowWithVC:viewController setWindowVC:nil];
}


+ (NSViewController *)createViewControllerUseNib:(Class)classz{
    NSViewController *vc = [[classz alloc] initWithNibName:NSStringFromClass(classz) bundle:NSBundle.mainBundle];
    return vc;
}
+ (void)showWindowWithVCClass:(Class)classz {
    NSViewController *viewController = [self createViewControllerUseNib:classz];
    [self showWindowWithVC:viewController];
}

@end
