//
//  NSData+HqDataExt.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/19.
//

#import "NSData+HqDataExt.h"

@implementation NSData (HqDataExt)


- (NSString *)hex{
    
    
    NSMutableString* outPutStr = [NSMutableString string];
    const char *bytes = (const char *)self.bytes;
    for(int  i =0; i<self.length;i++){
        [outPutStr appendFormat:@"%02x",bytes[i]&0x000000FF];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
    }
    return outPutStr;
 
}

@end
