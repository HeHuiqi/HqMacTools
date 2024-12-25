//
//  HqScanVC.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/8.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(macos(13.0))
@interface HqScanVC : NSViewController

@property (nonatomic,strong) AVCaptureSession *captureSession;//捕捉会话

@property (nonatomic,strong) AVCaptureDeviceInput *deviceInput;//输入流

@property (nonatomic,strong) AVCaptureMetadataOutput *metaDataOutput;//输出流

@property (nonatomic,strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;//预览涂层

@end

NS_ASSUME_NONNULL_END
