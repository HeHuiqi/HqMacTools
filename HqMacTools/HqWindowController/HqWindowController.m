//
//  HqWindowController.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/11.
//
// 启动控制器，在storyboard中查看设置
#import "HqWindowController.h"

@interface HqWindowController ()

@end

@implementation HqWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.title = @"HqMacTools";
    //设置Window内容的最小大小，初始显示
    self.window.contentMinSize = CGSizeMake(800, 600);
    //是window显示在屏幕中央
    [self.window center];
}

@end
