//
//  HqScreenCapture.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/11.
//

#import <AppKit/AppKit.h>

typedef NS_ENUM(NSInteger,HqScreenCaptureType) {
    //录屏
    HqScreenCaptureRecocde,
    //截屏
    HqScreenCaptureSnopshot,
};

typedef void (^HqCaptureCompletion)(NSImage * _Nullable image);
NS_ASSUME_NONNULL_BEGIN
API_AVAILABLE(macos(12.3))
@interface HqScreenCapture : NSObject

@property (nonatomic, assign) HqScreenCaptureType captureType; //默认 HqScreenCaptureRecocde
@property (nonatomic, copy) HqCaptureCompletion captureCompletion;

// 如果 captureType 是 HqScreenCaptureRecocde 需要手动调用 stopCapture: 方法
- (void)startCaptureWithCompletion:(HqCaptureCompletion)completion;
- (void)stopCapture;



@end

NS_ASSUME_NONNULL_END
