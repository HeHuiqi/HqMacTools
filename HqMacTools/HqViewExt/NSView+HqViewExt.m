//
//  NSView+HqViewExt.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/20.
//

#import "NSView+HqViewExt.h"
#import <objc/message.h>

const char * HqBackgroundColorKey = "HqBackgroundColorKey";
const char * HqCornerRaduisKey = "HqCornerRaduisKey";

@implementation NSView (HqViewExt)

- (void)setHqBackgroudColor:(NSColor *)hqBackgroudColor{
    objc_setAssociatedObject(self, HqBackgroundColorKey, hqBackgroudColor, OBJC_ASSOCIATION_RETAIN);
    if ([self respondsToSelector:@selector(backgroundColor)]) {
        [self setValue:hqBackgroudColor forKey:@"backgroundColor"];
        return;
    }
    self.wantsLayer = YES;
    self.layer.backgroundColor = hqBackgroudColor.CGColor;
}
- (NSColor *)hqBackgroudColor {
    return  objc_getAssociatedObject(self, HqBackgroundColorKey);
}

- (void)setHqCornerRaduis:(CGFloat)hqCornerRaduis {
    objc_setAssociatedObject(self, HqCornerRaduisKey, @(hqCornerRaduis), OBJC_ASSOCIATION_ASSIGN);
    self.wantsLayer = YES;
    self.layer.cornerRadius = hqCornerRaduis;
}
- (CGFloat)hqCornerRaduis {
    return [objc_getAssociatedObject(self, HqCornerRaduisKey) floatValue];
}

@end
