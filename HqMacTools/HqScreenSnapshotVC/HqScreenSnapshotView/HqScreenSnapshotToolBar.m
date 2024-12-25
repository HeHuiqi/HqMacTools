//
//  HqScreenSnapshotToolBar.m
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/20.
//

#import "HqScreenSnapshotToolBar.h"
#import "NSView+HqViewExt.h"

@interface HqScreenSnapshotToolBar()

@property (nonatomic,strong) NSButton *cancelBtn;
@property (nonatomic,strong) NSButton *confirmBtn;


@end

@implementation HqScreenSnapshotToolBar
- (NSButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [NSButton buttonWithTitle:@"Close" target:self action:@selector(cancelBtnClick)];

    }
    return _cancelBtn;
}
- (NSButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [NSButton buttonWithTitle:@"Confirm" target:self action:@selector(confirmBtnClick)];

    }
    return _confirmBtn;
}
- (void)cancelBtnClick {
    if ([self.delegate respondsToSelector:@selector(cancelSnapshot:)] && self.delegate) {
        [self.delegate cancelSnapshot:self];
    }
}
- (void)confirmBtnClick {
    if ([self.delegate respondsToSelector:@selector(confirmSanpshot:)] && self.delegate) {
        [self.delegate confirmSanpshot:self];
    }
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.hqBackgroudColor = [NSColor colorWithRed:90/255.0 green:147/255.9 blue:245/255.0 alpha:0.8];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.confirmBtn];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(100);
    }];
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.cancelBtn.mas_left).offset(-10);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(100);
    }];
    
}

@end
