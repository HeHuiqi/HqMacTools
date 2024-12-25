//
//  HqQrcodeUtil.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/7.
//

#import "HqQrcodeUtil.h"
#import <AppKit/AppKit.h>

#import <CoreImage/CIContext.h>
#import <CoreImage/CIImage.h>
#import <CoreImage/CIFilter.h>
#import <CoreImage/CIDetector.h>
#import <CoreImage/CIFeature.h>


@implementation HqQrcodeUtil

/// 生成原始二维码
///
/// - Parameter message: 二维码信息
/// - Returns: 二维码图片 CIImage
+ (CIImage *)generateOriginQRImage:(NSString *)message {
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    // 创建二维码滤镜
    CIFilter *qrCIFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    if(qrCIFilter == nil){
        
        return nil;
    }
    [qrCIFilter setValue:messageData forKey:@"inputMessage"];
    //L7% M15% Q25% H%30% 纠错级别. 默认值是M
    [qrCIFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    return qrCIFilter.outputImage;
}

+ (NSImage *)ciImageToNsImage:(CIImage *)ciImage{
    NSCIImageRep *rep = [NSCIImageRep imageRepWithCIImage:ciImage];
    NSImage *nsImage = [[NSImage alloc] initWithSize:rep.size];
    [nsImage addRepresentation:rep];
    
    return nsImage;
}



+ (NSImage *)createQRImage:(NSString *)message size:(CGSize)size backgroundColor:(CIColor *)backgroundColor foregroundColor:(CIColor *)foregroundColor fillImage:(NSImage *)fillImage{
    CIImage *originalImage = [self generateOriginQRImage:message];
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    //输入图片
    [colorFilter setValue:originalImage forKey:@"inputImage"];
    //输入颜色
    if(foregroundColor){
        [colorFilter setValue:foregroundColor forKey:@"inputColor0"];
    }
    if(backgroundColor){
        [colorFilter setValue:backgroundColor forKey:@"inputColor1"];
    }
    CIImage *colorImage =  [colorFilter.outputImage imageByApplyingTransform:CGAffineTransformMakeScale(size.width/originalImage.extent.size.width, size.height/originalImage.extent.size.height)];
    NSImage *image = [self ciImageToNsImage:colorImage];
    if(fillImage){
        CGRect fillRect = CGRectMake((size.width-size.width/4)/2, (size.height-size.height/4)/2, size.width/4, size.height/4);
        [image lockFocus];
        [fillImage drawInRect:fillRect];
        [image unlockFocus];
    }
    
    return  image;
}

+ (NSImage *)createQRImage:(NSString *)message size:(CGSize)size{
    CIColor *backgroundColor = [CIColor colorWithRed:1 green:1 blue:1];
    CIColor *foregroundColor = [CIColor colorWithRed:0 green:0 blue:0];
    return [self createQRImage:message size:size backgroundColor:backgroundColor foregroundColor:foregroundColor fillImage:nil];
}
+ (NSImage *)createQRImage:(NSString *)message{
    return [self createQRImage:message size:CGSizeMake(200, 200)];
}



/// 识别二维码
///
/// - Parameter targetImage: 目标图片
/// - Returns: 二维码信息字符串

+ (NSString *)recognizeQRCode:(NSImage *)targetImage{
    NSData *imageData =  [targetImage TIFFRepresentationUsingCompression:(NSTIFFCompressionNone) factor:0];
    CIImage *ciimage = [CIImage imageWithData:imageData];
    CIContext *context = [[CIContext alloc]init];
    /*创建探测器 options 是字典key:
     CIDetectorAccuracy 精度
     CIDetectorTracking 轨迹
     CIDetectorMinFeatureSize 最小特征尺寸
     CIDetectorNumberOfAngles 角度**/
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    NSArray<CIQRCodeFeature *> *ars = (NSArray<CIQRCodeFeature *> *)[detector featuresInImage:ciimage];
    return ars.lastObject.messageString;
}

@end
