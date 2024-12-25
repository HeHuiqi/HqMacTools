//
//  HqSafeToolConsts.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/20.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HqContentType){
    HqContentTypeText,
    HqContentTypeHex,
    HqContentTypeImage
};


typedef NS_ENUM(NSInteger,HqHashType){
    HqHashTypeMD5 = 1,
    HqHashTypeSHA1,
    HqHashTypeSHA224,
    HqHashTypeSHA256,
    HqHashTypeSHA384,
    HqHashTypeSHA512
};

typedef NS_ENUM(NSInteger,HqEncodeType){
    HqEncodeTypeBase64 = 1,
    HqEncodeTypeBase58,
};

typedef NS_ENUM(NSInteger,HqEncryptType){
    HqEncryptTypeAES = 1,
    HqEncryptTypeDES

};


NS_ASSUME_NONNULL_BEGIN

@interface HqSafeToolConsts : NSObject

@end

NS_ASSUME_NONNULL_END
