//
//  HqUtils.h
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HqUtils : NSObject

/** 获取ip地址 */
+ (NSString *)deviceIPAdress;

#pragma mark - 获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

@end

NS_ASSUME_NONNULL_END
