//
//  HqTableCellView.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/12.
//

#import "HqTableCellView.h"
#import <Masonry/Masonry.h>


@implementation HqTableCellView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
- (NSTextField *)textField{
    if (!_textField) {
        _textField = [[NSTextField alloc] init];
        _textField.editable = NO;
        _textField.bordered = NO;
        _textField.backgroundColor = NSColor.clearColor;
        _textField.textColor = NSColor.systemBlueColor;
    }
    return _textField;
}
- (void)setup{
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

#pragma mark - Getter / Setter


@end
