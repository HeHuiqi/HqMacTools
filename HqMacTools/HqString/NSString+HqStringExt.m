//
//  NSString+HqStringExt.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/19.
//

#import "NSString+HqStringExt.h"

@implementation NSString (HqStringExt)


- (NSData *)hexData {
    if (![self isKindOfClass:[NSString class]]) {
        return [NSData data];
    }
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [self length]/2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    return commandToSend;
}


@end
