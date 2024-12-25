//
//  HqAESUtil.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HqAESUtil : NSObject

//加密
+ (NSData *)AES256EncryptWithKey:(NSString *)key originalData:(NSData *)data;
//解密
+ (NSData *)AES256DecryptWithKey:(NSString *)key encyptData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
