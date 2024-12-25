//
//  HqRemoveAlphaVC.m
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/17.
//

#import "HqRemoveAlphaVC.h"
#import <Masonry/Masonry.h>
#import "HqFileManager.h"
#import "NSImage+HqImageUtils.h"

@interface HqRemoveAlphaVC ()

@property (nonatomic, strong) NSButton *lockFileBtn;


@end



@implementation HqRemoveAlphaVC

- (void)loadView{
    //自定义实现view就可以不用xib了
    self.view = [[NSView alloc] initWithFrame:CGRectMake(0, 0, 400, 600)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

#pragma mark -  setup

- (void)setupViews{
    [self.view addSubview:self.lockFileBtn];
    [self.lockFileBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(100, 60));

    }];
}

#pragma mark - Getter / Setter

- (NSButton *)lockFileBtn{
    if(!_lockFileBtn){
        _lockFileBtn = [NSButton buttonWithTitle:@"选择文件" target:self action:@selector(lockFileClick)];
    }
    return _lockFileBtn;
}

#pragma mark - Actions
- (void)lockFileClick{
    [self chooseFileComplete:^(NSString * filePath) {
        
        NSImage *srcImage = [NSImage imageFromFilePath:filePath];
        if (srcImage) {
            NSImage *newImage =  [srcImage removeAlpha];
            NSData *newImageData = [newImage TIFFRepresentation];
            [newImageData writeToFile:filePath atomically:YES];
        }
        
    }];

}
- (void)chooseFileComplete:(void(^)(NSString * filePath))complete {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt:@"选择文件"];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanChooseDirectories:YES];

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
