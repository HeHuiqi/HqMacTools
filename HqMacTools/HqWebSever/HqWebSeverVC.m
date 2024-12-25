//
//  HqWebSeverVC.m
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/24.
//

#import "HqWebSeverVC.h"
#import "HqChooseFileUtils.h"
#import "HqWebSever.h"

@interface HqWebSeverVC ()
@property (nonatomic,strong) NSButton *startServerBtn;
@property (nonatomic,strong) NSTextView *tv;

@end

@implementation HqWebSeverVC

- (NSButton *)startServerBtn{
    if(!_startServerBtn){
        _startServerBtn = [NSButton buttonWithTitle:@"选择一个目录开启服务器" target:self action:@selector(choosetDir)];
    }
    return _startServerBtn;
}
- (NSTextView *)tv {
    if (!_tv) {
        _tv = [[NSTextView alloc] init];
        _tv.editable = NO;
    }
    return _tv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.startServerBtn];
    [self.view addSubview:self.tv];

    [self.startServerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.top.equalTo(self.view).offset(10);
        make.size.mas_equalTo(CGSizeMake(180, 60));
    }];
    [self.tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startServerBtn);
        make.top.equalTo(self.startServerBtn.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
}
- (void)dealloc {
    [HqWebSever.shared stopFileServer];
}
- (void)choosetDir {
    [HqChooseFileUtils chooseDirComplete:^(NSString * _Nonnull filePath) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HqWebSever.shared startFileServer:filePath];
            self.tv.string = HqWebSever.shared.localHTTPString;
        });
    }];

}
@end
