//
//  AppDelegate.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/9/28.
//

#import "AppDelegate.h"
#import "HqScreenSnapshotManager.h"
#import "HqWebSever/HqWebSever/HqWebSever.h"
@interface AppDelegate ()

@property (nonatomic, strong) NSStatusItem *statusItem;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self addMenus];
//    [self addMenus2];
    [self statusMenu];

}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


//点击关闭按钮后 在dock上可以继续打开
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    if (!flag){
        if (theApplication.windows.firstObject) {
            [[theApplication windows].firstObject makeKeyAndOrderFront:self];
        }
        return YES;
    }
    return NO;
    
}
- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

- (void)addMenus{
  
    NSMenuItem *cutItem = [NSMenuItem new];
    
    NSMenu *subMenu = [NSMenu new];
    subMenu.title = @"我的工具";
    NSMenuItem *subMenuItem = [[NSMenuItem alloc] initWithTitle:@"截屏" action:@selector(cutScreen) keyEquivalent:@"X"];
    [subMenu addItem:subMenuItem];
    
    cutItem.submenu = subMenu;
    
    NSMenu *mainMenu = NSApplication.sharedApplication.mainMenu;
    
    [mainMenu addItem:cutItem];
    //更新menu
    [mainMenu update];
    

}
- (void)addMenus2{
  
    NSMenuItem *cutItem = [NSMenuItem new];
    
    NSMenu *subMenu = [NSMenu new];
    subMenu.title = @"我的工具";
    NSMenuItem *subMenuItem = [[NSMenuItem alloc] initWithTitle:@"截屏" action:@selector(cutScreen) keyEquivalent:@"X"];
    [subMenu addItem:subMenuItem];
    
    cutItem.submenu = subMenu;

    
    NSMenu *customeMainMenu = [NSMenu new];
    customeMainMenu.title = @"我的工具";
    [customeMainMenu addItem:cutItem];
    //直接替换
    NSApplication.sharedApplication.mainMenu = customeMainMenu;
    NSMenu *mainMenu = NSApplication.sharedApplication.mainMenu;

    NSLog(@"mainMenu:%@",mainMenu);
    

}
- (void)cutScreen {
    NSLog(@"cutScreen");
    [HqScreenSnapshotManager.shared showSnapshotVC];

}
- (void)statusMenu {
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    if (self.statusItem.button) {
        [self.statusItem.button setImage:[NSImage imageNamed:@"icon"]];
        [self.statusItem.button setAction:@selector(showMenu:)];
        NSMenu *menu = [[NSMenu alloc] init];
        NSMenuItem *menuItem1 = [[NSMenuItem alloc] initWithTitle:@"截屏" action:@selector(option1Selected:) keyEquivalent:@"X"];
        [menu addItem:menuItem1];
        self.statusItem.menu = menu;
    }
}

- (void)showMenu:(id)sender {
    if (self.statusItem.menu) {
        [NSMenu popUpContextMenu:self.statusItem.menu withEvent:[NSApp currentEvent] forView:nil];
    }
}

- (void)option1Selected:(id)sender {
    NSLog(@"选项1被选中");
    [self cutScreen];
}


@end
