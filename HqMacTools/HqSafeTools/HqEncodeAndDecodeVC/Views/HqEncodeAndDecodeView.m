//
//  HqTextEncodeAndDecodeView.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/23.
//

#import "HqEncodeAndDecodeView.h"
#import "NSString+HqStringExt.h"
#import "HqEncodeDecodeUtil.h"
#import "NSData+HqDataExt.h"
#import "HqDialog.h"

@interface HqEncodeAndDecodeView ()


@end


@implementation HqEncodeAndDecodeView


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)setup{
    self.contentType = HqContentTypeText;
    self.encodeType = HqEncodeTypeBase64;
    
    [self addSubview:self.inputView];
    [self addSubview:self.copyInputBtn];
    
    [self addSubview:self.encodeBtn];
    [self addSubview:self.decodeBtn];
    [self addSubview:self.clearBtn];
    
    [self addSubview:self.resultView];
    [self addSubview:self.resultImageView];
    [self addSubview:self.copyOutputBtn];



    [self hqLayout];
}
- (void)hqLayout{
    CGFloat inputWidth = 400;
    CGFloat inputHeight = 150;
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(0);
        make.width.mas_equalTo(inputWidth);
        make.height.mas_equalTo(inputHeight);
    }];
    
    [self.copyInputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.inputView.mas_right);
        make.top.equalTo(self.inputView.mas_bottom).offset(5);
    }];
    
    [self.encodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.inputView.mas_left);
        make.top.equalTo(self.inputView.mas_bottom).offset(5);
    }];
    [self.decodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.encodeBtn.mas_right).offset(5);
        make.top.equalTo(self.inputView.mas_bottom).offset(5);
    }];
    
    
    
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.decodeBtn.mas_right).offset(5);
        make.top.equalTo(self.inputView.mas_bottom).offset(5);
    }];

    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.encodeBtn.mas_bottom).offset(5);
        make.width.mas_equalTo(inputWidth);
        make.height.mas_equalTo(inputHeight);
    }];
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.encodeBtn.mas_bottom).offset(5);
        make.width.mas_equalTo(inputWidth);
        make.height.mas_equalTo(inputHeight);
    }];
    [self.copyOutputBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.resultView.mas_right);
        make.top.equalTo(self.resultImageView.mas_bottom).offset(5);
    }];
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
- (NSButton *)encodeBtn {
    if (!_encodeBtn) {
        _encodeBtn = [NSButton buttonWithTitle:@"Encode" target:self action:@selector(encodeBtnClick)];
    }
    return _encodeBtn;
}
- (NSButton *)decodeBtn {
    if (!_decodeBtn) {
        _decodeBtn = [NSButton buttonWithTitle:@"Decode" target:self action:@selector(decodeBtnClick)];
    }
    return _decodeBtn;
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

#pragma mark 点击计算编码
- (void)encodeBtnClick{
    
    if (self.contentType == HqContentTypeImage) {
        [self chooseFileComplete:^(NSString *filePath) {
            self.inputView.text = filePath;
            NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
            NSString *result = [HqEncodeDecodeUtil encodeData:data encodeType:self.encodeType];
            self.resultView.text = result;
        }];
        return;
    }
    
    NSString *input = self.inputView.inputTv.string;
    if(input.length > 0){
        NSData *data;
        if (self.contentType == HqContentTypeText) {
            data = [input dataUsingEncoding:NSUTF8StringEncoding];
        } else {
            data = input.hexData;
        }
        if(data){
            NSString *result = [HqEncodeDecodeUtil encodeData:data encodeType:self.encodeType];
            self.resultView.text = result;
        }
    }
}
#pragma mark 点击计算解码
- (void)decodeBtnClick{
    
    NSString *input = self.inputView.inputTv.string;
    if(input.length > 0){
        NSData *data = [HqEncodeDecodeUtil decodeString:input encodeType:self.encodeType];
        if (self.contentType == HqContentTypeImage) {
            NSImage *image = [[NSImage alloc] initWithData:data];
            self.resultImageView.image = image;
            return;
        }
        
        NSString *result;
        if (self.contentType == HqContentTypeText) {
            result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }else{
            result = data.hex;
        }
        self.resultView.text = result;
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
