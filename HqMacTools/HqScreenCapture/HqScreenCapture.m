//
//  HqScreenCapture.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/11.
//

#import "HqScreenCapture.h"
#import <ScreenCaptureKit/ScreenCaptureKit.h>
@interface HqScreenCapture ()<SCStreamOutput,SCStreamDelegate>

@property (nonatomic, strong) SCStream *stream;

@end

@implementation HqScreenCapture

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.captureType = HqScreenCaptureRecocde;
    }
    return self;
}

// 排除掉本应用程序
- (NSArray<SCRunningApplication *> *)excludedApps:(NSArray<SCRunningApplication *> *)apps{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(SCRunningApplication *  _Nullable app, NSDictionary<NSString *,id> * _Nullable bindings) {
        
        NSString *bundleIdentifier = NSBundle.mainBundle.bundleIdentifier;
        return [app.bundleIdentifier isEqualToString:bundleIdentifier];
    }];
    return [apps filteredArrayUsingPredicate:predicate];;
}
// 排除掉本应用程序的window
- (NSArray<SCWindow *> *)includingWindows:(NSArray<SCWindow *> *)windows{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(SCWindow *  _Nullable window, NSDictionary<NSString *,id> * _Nullable bindings) {
        NSString *bundleIdentifier = NSBundle.mainBundle.bundleIdentifier;
        return [window.owningApplication.bundleIdentifier isEqualToString:bundleIdentifier] ? NO:YES;
    }];
    return [windows filteredArrayUsingPredicate:predicate];;
}

- (void)startCaptureWithCompletion:(HqCaptureCompletion)completion{
    self.captureCompletion = completion;
    [SCShareableContent getShareableContentExcludingDesktopWindows:NO onScreenWindowsOnly:YES completionHandler:^(SCShareableContent * _Nullable shareableContent, NSError * _Nullable error) {
        NSArray *windows = shareableContent.windows; //活动的窗口
        NSArray *displays = shareableContent.displays; //可用的显示器
        NSArray *apps = shareableContent.applications; //打开的应用
        NSArray *excludedApps = [self excludedApps:apps];
        NSArray *includingWindows = [self includingWindows:windows];
        
        SCDisplay *display = displays.firstObject;
        //方式1
        SCContentFilter *filter = [[SCContentFilter alloc] initWithDisplay:display includingWindows:includingWindows];
        //方式2
        filter = [[SCContentFilter alloc] initWithDisplay:display excludingApplications:excludedApps exceptingWindows:@[]];
        
        //stream配置
        SCStreamConfiguration *config = [[SCStreamConfiguration alloc] init];
        //设置图像宽高和显示器尺寸宽高一直
        config.width = display.width;
        config.height = display.height;
        
        SCStream *stream = [[SCStream alloc] initWithFilter:filter configuration:config delegate:self];
        dispatch_queue_t video_queue = dispatch_queue_create(@"video_queue".UTF8String, nil);
        NSError *qerror;
        //仅添加视频输出
        [stream addStreamOutput:self type:(SCStreamOutputTypeScreen) sampleHandlerQueue:video_queue error:&qerror];
        //开始捕捉屏幕
        [stream startCaptureWithCompletionHandler:^(NSError * _Nullable error) {
            
        }];
        self.stream = stream;

        
    }];
}
- (void)stopCapture{
    if(self.stream){
        [self.stream stopCaptureWithCompletionHandler:nil];
    }
}

#pragma mark - SCStreamDelegate
- (void)stream:(SCStream *)stream didStopWithError:(NSError *)error{
    NSLog(@"didStopWithError");
    [stream stopCaptureWithCompletionHandler:nil];
    
}
#pragma mark - SCStreamOutput
- (void)stream:(SCStream *)stream didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer ofType:(SCStreamOutputType)type{
    NSLog(@"didOutputSampleBuffer");

    if (type == SCStreamOutputTypeScreen){
        CVImageBufferRef cvImageBuf = CMSampleBufferGetImageBuffer(sampleBuffer);
        if(cvImageBuf && self.captureCompletion) {
            CIImage *ciImage = [[CIImage alloc] initWithCVPixelBuffer:cvImageBuf];
            NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:ciImage];
            NSImage *nsImage = [[NSImage alloc] initWithSize:rep.size];
            [nsImage addRepresentation:rep];
            if(self.captureType == HqScreenCaptureSnopshot) {
                [stream stopCaptureWithCompletionHandler:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.captureCompletion(nsImage);
            });
        }
    }
}

@end
