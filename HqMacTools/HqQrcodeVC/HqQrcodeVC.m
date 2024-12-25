//
//  HqQrcodeVC.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/7.
//

#import "HqQrcodeVC.h"
#import <Masonry/Masonry.h>
#import "HqTextView.h"

#import "HqFileManager.h"
#import "HqQrcodeUtil/HqQrcodeUtil.h"
#import "HqScanVC/HqScanVC.h"

@interface HqQrcodeVC ()

@property (nonatomic, strong) NSButton *makeQrcodeBtn;
@property (nonatomic, strong) HqTextView *tf;
@property (nonatomic, strong) NSImageView *qrcodeImageView;

@property (nonatomic, strong) NSButton *closeBtn;

@property (nonatomic, strong) NSButton *recognizeQrcodeBtn;

@property (nonatomic, strong) HqTextView *qrcodeInfoTv;

//@property (nonatomic, strong) NSView *qrcodeInfoTv;



@end


@implementation HqQrcodeVC



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
}

#pragma mark -  setup

- (void)setupViews{
    [self.view addSubview:self.tf];
    [self.view addSubview:self.makeQrcodeBtn];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.recognizeQrcodeBtn];
    [self.view addSubview:self.qrcodeImageView];
    [self.view addSubview:self.qrcodeInfoTv];
    
    [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(20);
        make.size.mas_equalTo(CGSizeMake(260, 60));

    }];
    CGFloat btnW = 80;
    [self.makeQrcodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tf.mas_left);
        make.top.equalTo(self.tf.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(btnW, 20));

    }];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.tf);
        make.top.equalTo(self.tf.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(btnW, 20));

    }];
    [self.recognizeQrcodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tf.mas_right);
        make.top.equalTo(self.tf.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(btnW, 20));

    }];
    
    [self.qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tf.mas_left);
        make.top.equalTo(self.makeQrcodeBtn.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(260, 260));
    }];
    
    [self.qrcodeInfoTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tf.mas_left);
        make.top.equalTo(self.qrcodeImageView.mas_bottom).offset(10);
        make.right.equalTo(self.tf.mas_right);
        make.height.mas_equalTo(100);
    }];
    

}

#pragma mark - Getter / Setter

- (HqTextView *)tf {
    if(!_tf){
        _tf = [[HqTextView alloc] init];
    }
    return _tf;
}
- (NSImageView *)qrcodeImageView {
    if(!_qrcodeImageView){
        _qrcodeImageView = [[NSImageView alloc] init];
        _qrcodeImageView.wantsLayer = YES;
        _qrcodeImageView.layer.backgroundColor = NSColor.grayColor.CGColor;
        _qrcodeImageView.layer.cornerRadius = 4;
    }
    return _qrcodeImageView;
}
- (HqTextView *)qrcodeInfoTv{
    if (!_qrcodeInfoTv) {
        _qrcodeInfoTv = [[HqTextView alloc] init];
        _qrcodeInfoTv.text = @"二维码内容:";
        _qrcodeInfoTv.editable = NO;
        _qrcodeInfoTv.borderType = NSNoBorder;
    }
    
    return _qrcodeInfoTv;
}
- (NSButton *)makeQrcodeBtn{
    if(!_makeQrcodeBtn){
        _makeQrcodeBtn = [NSButton buttonWithTitle:@"生成二维码" target:self action:@selector(makeQrcodeBtnClick)];
    }
    return _makeQrcodeBtn;
}
- (NSButton *)closeBtn{
    if(!_closeBtn){
        _closeBtn = [NSButton buttonWithTitle:@"关闭" target:self action:@selector(closeBtnClick)];
    }
    return _closeBtn;
}

- (NSButton *)recognizeQrcodeBtn{
    if(!_recognizeQrcodeBtn){
        _recognizeQrcodeBtn = [NSButton buttonWithTitle:@"识别二维码" target:self action:@selector(recognizeQrcodeBtnClick)];
    }
    return _recognizeQrcodeBtn;
}




#pragma mark - Actions
- (void)makeQrcodeBtnClick{
    NSLog(@"makeQrcodeBtnClick");
    if (self.tf.text.length > 0) {
        NSImage *image = [HqQrcodeUtil createQRImage:self.tf.text];
        [self showQrcodeContentWithImage:image];
    }
}
- (void)closeBtnClick{
    NSLog(@"closeBtnClick");
    
//    [self.presentingViewController dismissViewController:self];
//    [self dismissController:nil];
    [self.view.window close];
    
}
- (void)recognizeQrcodeBtnClick{
    NSLog(@"recognizeQrcodeBtnClick");
    [self chooseFileComplete:^(NSString *filePath) {
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:filePath];
        [self showQrcodeContentWithImage:image];
    }];

}
- (void)showQrcodeContentWithImage:(NSImage *)image{
    self.qrcodeImageView.image = image;
    NSString *content = [HqQrcodeUtil recognizeQRCode:image];
    if(content.length > 0){
        self.qrcodeInfoTv.text = [NSString stringWithFormat:@"二维码内容:\n%@",content];
        self.tf.text = content;
    }
}
- (void)chooseFileComplete:(void(^)(NSString * filePath))complete {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt:@"选择文件"];
    [openPanel setAllowsMultipleSelection:NO];
    //不允许选择目录
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

@end

