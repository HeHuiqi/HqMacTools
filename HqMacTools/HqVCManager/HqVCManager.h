//
//  HqVCManager.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/13.
//

#import <Cocoa/Cocoa.h>

typedef void(^HqWindowVCSetBlock)(NSWindowController * _Nonnull windowVC);

NS_ASSUME_NONNULL_BEGIN

@interface HqVCManager : NSObject


+ (NSViewController *)createViewControllerUseNib:(Class)classz;
+ (void)showWindowWithVC:(NSViewController *)viewController;
+ (void)showWindowWithVCClass:(Class)classz;

+ (void)showWindowWithVC:(NSViewController *)viewController setWindowVC:(nullable HqWindowVCSetBlock)setWindowVC;

+ (void)showWindowWithVC:(NSViewController *)viewController setWindow:(void(^)(NSWindow * window))setWindow;

@end

NS_ASSUME_NONNULL_END
