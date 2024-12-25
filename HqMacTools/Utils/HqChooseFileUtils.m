//
//  HqChooseFileUtils.m
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/24.
//

#import "HqChooseFileUtils.h"

@implementation HqChooseFileUtils

+ (void)chooseFileComplete:(void(^)(NSString * filePath))complete {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt:@"选择文件"];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanChooseDirectories:NO];

    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
        switch (result) {
            case NSModalResponseOK:
                if (result == NSModalResponseOK){
                    NSLog(@"选择的文件路径:%@",openPanel.URL);
                    complete(openPanel.URL.path);
                }
                break;
            case NSModalResponseCancel:

                break;
                
            default:
                break;
        }

    }];
}
+ (void)chooseDirComplete:(void(^)(NSString * filePath))complete {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    openPanel.prompt = @"选择目录";
    openPanel.canChooseFiles = NO;
    openPanel.allowsMultipleSelection = NO;
    openPanel.canChooseDirectories = YES;
  

    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
        switch (result) {
            case NSModalResponseOK:
                if (result == NSModalResponseOK){
                    NSLog(@"选择的文件路径:%@",openPanel.URL);
                    complete(openPanel.URL.path);
                }
                break;
            case NSModalResponseCancel:

                break;
                
            default:
                break;
        }

    }];
}
@end
