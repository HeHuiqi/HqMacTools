//
//  HqDialog.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/23.
//

#import "HqDialog.h"

@implementation HqDialog

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)setup{
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor blackColor].CGColor;
    self.layer.cornerRadius = 5;
    [self addSubview:self.tv];
    [self hqLayout];
    
}
- (void)hqLayout{
    [self.tv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(10);
        make.bottom.equalTo(self).offset(-10);

    }];
}
- (NSTextView *)tv{
    if (!_tv) {
        _tv = [[NSTextView alloc] init];
        _tv.font = [NSFont systemFontOfSize:17];
        _tv.textColor = NSColor.whiteColor;
        _tv.backgroundColor = NSColor.clearColor;
        _tv.editable = NO;
        _tv.alignment = NSTextAlignmentCenter;
    }
    return _tv;
}
- (void)showInView:(NSView *)view message:(NSString *)message{
    self.message = message;
    [self showInView:view];
}
- (void)showInView:(NSView *)view {
    [view addSubview:self];
    CGFloat maxWidth = 200;

    NSRect rect =  [self.message boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:self.tv.font}];
    CGFloat height = rect.size.height + 20;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view);
        make.width.mas_equalTo(maxWidth);
        make.height.mas_equalTo(height);
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
+ (void)showMessage:(NSString *)message inView:(NSView *)view {
    HqDialog *d = [[HqDialog alloc] init];
    d.message = message;
    [d showInView:view];
}

- (void)setMessage:(NSString *)message {
    _message = message;
    self.tv.string = message;
}
@end
