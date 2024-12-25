//
//  HqEncryptAndDecryptView.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/23.
//

#import "HqEncryptAndDecryptView.h"

#import "NSString+HqStringExt.h"
#import "HqEncodeDecodeUtil.h"
#import "NSData+HqDataExt.h"
#import "HqDialog.h"
#import "HqEncryptAndDecryptUtil.h"

@interface HqEncryptAndDecryptView ()


@end


@implementation HqEncryptAndDecryptView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)setup{
    self.contentType = HqContentTypeText;
    self.encryptType = HqEncryptTypeAES;
    
    [self addSubview:self.infoLab];
    [self addSubview:self.keyTf];
    
    [self addSubview:self.inputView];
    [self addSubview:self.copyInputBtn];
    
    [self addSubview:self.encryptBtn];
    [self addSubview:self.decryptBtn];
    [self addSubview:self.clearBtn];
    
    [self addSubview:self.resultView];
    [self addSubview:self.resultImageView];
    [self addSubview:self.copyOutputBtn];



    [self hqLayout];
    
    self.keyTf.stringValue = @"123456";
    self.inputView.text = @"123456";


}
- (void)hqLayout{
    CGFloat inputWidth = 400;
    CGFloat inputHeight = 150;
    
    [self.infoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).offset(0);
    }];
    
    [self.keyTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.infoLab.mas_right).offset(5);
        make.centerY.equalTo(self.infoLab.mas_centerY);
        make.right.equalTo(self);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.keyTf.mas_bottom).offset(5);
        make.width.mas_equalTo(inputWidth);
        make.height.mas_equalTo(inputHeight);
    }];
    
    [self.copyInputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputView.mas_right);
        make.top.equalTo(self.inputView.mas_bottom).offset(5);
    }];
    
    [self.encryptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputView.mas_left);
        make.top.equalTo(self.inputView.mas_bottom).offset(5);
    }];
    [self.decryptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.encryptBtn.mas_right).offset(5);
        make.top.equalTo(self.inputView.mas_bottom).offset(5);
    }];
    
    
    
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.decryptBtn.mas_right).offset(5);
        make.top.equalTo(self.inputView.mas_bottom).offset(5);
    }];

    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.encryptBtn.mas_bottom).offset(5);
        make.width.mas_equalTo(inputWidth);
        make.height.mas_equalTo(inputHeight);
    }];
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.encryptBtn.mas_bottom).offset(5);
        make.width.mas_equalTo(inputWidth);
        make.height.mas_equalTo(inputHeight);
    }];
    [self.copyOutputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.resultView.mas_right);
        make.top.equalTo(self.resultImageView.mas_bottom).offset(5);
    }];
}

#pragma mark - Getter / Setter

- (NSTextField *)infoLab {
    if (!_infoLab) {
        _infoLab = [[NSTextField alloc] init];
        _infoLab.stringValue = @"密钥：";
        _infoLab.editable = NO;
        _infoLab.bordered = NO;
    }
    return _infoLab;
}
- (NSTextField *)keyTf {
    if (!_keyTf) {
        _keyTf = [[NSTextField alloc] init];
        _keyTf.placeholderString = @"请输入密钥";
        _keyTf.bezelStyle = NSTextFieldRoundedBezel;
        

    }
    return _keyTf;
}

- (HqTextView *)inputView {
    if (!_inputView) {
        _inputView = [[HqTextView alloc] init];
    }
    return _inputView;
}
- (NSButton *)copyInputBtn {
    if (!_copyInputBtn) {
        _copyInputBtn = [NSButton buttonWithTitle:@"Copy Input" target:self action:@selector(copyInputBtnClick)];
    }
    return _copyInputBtn;
}
- (NSButton *)encryptBtn {
    if (!_encryptBtn) {
        _encryptBtn = [NSButton buttonWithTitle:@"Encrypt" target:self action:@selector(encryptBtnClick)];
    }
    return _encryptBtn;
}
- (NSButton *)decryptBtn {
    if (!_decryptBtn) {
        _decryptBtn = [NSButton buttonWithTitle:@"Decrypt" target:self action:@selector(decryptBtnClick)];
    }
    return _decryptBtn;
}
- (NSButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [NSButton buttonWithTitle:@"Clear" target:self action:@selector(clearBtnClick)];
    }
    return _clearBtn;
}
- (HqTextView *)resultView {
    if (!_resultView) {
        _resultView = [[HqTextView alloc] init];
        _resultView.editable = NO;

    }
    return _resultView;
}
- (NSImageView *)resultImageView {
    if (!_resultImageView) {
        _resultImageView = [[NSImageView alloc] init];
    }
    return _resultImageView;
}
- (NSButton *)copyOutputBtn {
    if (!_copyOutputBtn) {
        _copyOutputBtn = [NSButton buttonWithTitle:@"Copy Result" target:self action:@selector(copyOutputBtnClick)];
    }
    return _copyOutputBtn;
}

#pragma mark 点击计算加密
- (void)encryptBtnClick{
    
    NSString *key = self.keyTf.stringValue;

    if (self.contentType == HqContentTypeImage && key.length > 0) {
        [self chooseFileComplete:^(NSString *filePath) {
            self.inputView.text = filePath;
            NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
            NSData *result = [HqEncryptAndDecryptUtil encryptData:data key:key encryptType:self.encryptType];
            self.resultView.text = result.hex;
        }];
        return;
    }
    
    NSString *input = self.inputView.inputTv.string;
    if(input.length > 0 && key.length > 0 ){
        NSData *data;
        if (self.contentType == HqContentTypeText) {
            data = [input dataUsingEncoding:NSUTF8StringEncoding];
        } else {
            data = input.hexData;
        }
        if(data){
            NSData *result = [HqEncryptAndDecryptUtil encryptData:data key:key encryptType:self.encryptType];
            self.resultView.text = result.hex;
        }
    }
}
#pragma mark 点击计算解密
- (void)decryptBtnClick{
    
    NSString *key = self.keyTf.stringValue;
    NSString *input = self.inputView.inputTv.string;
    if(input.length > 0){
        NSData *result;
        NSData *inputData = input.hexData;
        if (self.contentType == HqContentTypeImage) {
            
            result = [HqEncryptAndDecryptUtil decryptData:inputData key:key encryptType:self.encryptType];
            NSImage *image = [[NSImage alloc] initWithData:result];
            self.resultImageView.image = image;
            return;
        }
        
        result = [HqEncryptAndDecryptUtil decryptData:inputData key:key encryptType:self.encryptType];
        if (self.contentType == HqContentTypeText) {
            self.resultView.text = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
            return;
        }
        self.resultView.text = result.hex;
    }
    
}
- (void)copyInputBtnClick {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    if(self.inputView.text.length > 0){
        [pasteboard clearContents];
        [pasteboard setString:self.inputView.text forType:NSPasteboardTypeString];
        HqDialog *dialog = [[HqDialog alloc] init];
        [dialog showInView:self message:@"复制成功"];
    }
}
- (void)clearBtnClick{
    [self clearContent];

}
- (void)copyOutputBtnClick {
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    [pasteboard clearContents];
    
    if (self.contentType == HqContentTypeImage && self.resultImageView.image) {

        NSData *imageData = [self.resultImageView.image TIFFRepresentation];
        [pasteboard setData:imageData forType:NSPasteboardTypePNG];
        HqDialog *dialog = [[HqDialog alloc] init];
        [dialog showInView:self message:@"复制成功"];
        return;
    }
    if(self.resultView.text.length > 0){
        [pasteboard setString:self.resultView.text forType:NSPasteboardTypeString];
        HqDialog *dialog = [[HqDialog alloc] init];
        [dialog showInView:self message:@"复制成功"];
    }
}

- (void)clearContent {
    self.inputView.text = @"";
    self.resultView.text = @"";
    self.resultImageView.image = nil ;
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
- (void)setContentType:(HqContentType)contentType {
    _contentType = contentType;
    [self clearContent];
}

@end
