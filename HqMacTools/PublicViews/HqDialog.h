//
//  HqDialog.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/23.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface HqDialog : NSView

@property (nonatomic, strong) NSTextView *tv;
@property (nonatomic, copy) NSString *message;

+ (void)showMessage:(NSString *)message inView:(NSView *)view;
- (void)showInView:(NSView *)view;
- (void)showInView:(NSView *)view message:(NSString *)message;
@end

NS_ASSUME_NONNULL_END
