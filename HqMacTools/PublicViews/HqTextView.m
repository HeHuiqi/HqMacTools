//
//  HqTextView.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/23.
//

#import "HqTextView.h"
#import <Masonry/Masonry.h>

@implementation HqTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)setup{
    [self addSubview:self.self.scrollView];
    [self hqLayout];
}
- (void)hqLayout{
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
        
    }];
    self.scrollView.documentView = self.inputTv;

}
- (NSScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[NSScrollView alloc] init];
        _scrollView.borderType = NSLineBorder;
        _scrollView.hasHorizontalScroller = NO;
        //默认是NO，设置才会显示滚动条
        _scrollView.hasVerticalScroller = YES;
        _scrollView.horizontalScrollElasticity = NSScrollElasticityNone; //水平的弹性属性
        _scrollView.verticalScrollElasticity = NSScrollElasticityAllowed; //垂直的弹性属性
        _scrollView.wantsLayer = YES;
        _scrollView.layer.cornerRadius = 4;
    }
    return _scrollView;
}
#pragma mark - Getter / Setter
- (NSTextView *)inputTv{
    if (!_inputTv) {
        _inputTv = [[NSTextView alloc] init];
        //这一行很关键，不然不会自动计算高度
        _inputTv.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    }
    return _inputTv;
}
- (void)setText:(NSString *)text{
    self.inputTv.string = text;
}
- (void)setEditable:(BOOL)editable {
    _editable = editable;
    self.inputTv.editable = editable;
}
- (NSString *)text {
    return self.inputTv.string;
}
- (void)setBorderType:(NSBorderType)borderType {
    _borderType = borderType;
    self.scrollView.borderType = borderType;
}
- (void)setFont:(NSFont *)font {
    self.inputTv.font = font;
}
@end

