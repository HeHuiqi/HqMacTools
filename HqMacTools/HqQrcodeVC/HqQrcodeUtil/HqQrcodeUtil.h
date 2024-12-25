//
//  HqQrcodeUtil.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HqQrcodeUtil : NSObject

/// 生成原始二维码
///
/// - Parameter message: 二维码信息
/// - Returns: 二维码图片 NSImage
+ (NSImage *)createQRImage:(NSString *)message;
+ (NSImage *)createQRImage:(NSString *)message size:(CGSize)size;

/// 识别二维码
///
/// - Parameter targetImage: 目标图片
/// - Returns: 二维码信息字符串

+ (NSString *)recognizeQRCode:(NSImage *)targetImage;
@end

NS_ASSUME_NONNULL_END
