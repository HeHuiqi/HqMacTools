//
//  HqMD5Util.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/19.
//

#import "HqMD5Util.h"
#import "NSData+HqDataExt.h"
#import "NSString+HqStringExt.h"


#define HqFileHashDefaultChunkSizeForReadingData 1024*8 // 8K

@implementation HqMD5Util


+ (NSString*)MD5WithString:(NSString *)string {
    return [self MD5WithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString*)MD5WithData:(NSData *)data {
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    CC_MD5_CTX ctx;
    CC_MD5_Init(&ctx);
    CC_MD5_Update(&ctx, data.bytes, (CC_LONG)data.length);
    CC_MD5_Final(digist, &ctx);
    
//    CC_MD5(data.bytes, (CC_LONG)data.length, digist);
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        [outPutStr appendFormat:@"%02x",digist[i]];//小写x表示输出的是小写MD5，大写X表示输出的是大写MD5
        long number = digist[i] & 0xff000000;
    }
    return outPutStr;
    
}
+ (NSString*)fileMD5WithPath:(NSString*)path{
    return (__bridge_transfer NSString *)FileMD5HashCreateWithPath((__bridge CFStringRef)path,HqFileHashDefaultChunkSizeForReadingData);
}
CFStringRef FileMD5HashCreateWithPath(CFStringRef filePath,
                                      size_t chunkSizeForReadingData) {
    
    // Declare needed variables
    CFStringRef result = NULL;
    CFReadStreamRef readStream = NULL;
    
    // Get the file URL
    CFURLRef fileURL =
    CFURLCreateWithFileSystemPath(kCFAllocatorDefault,
                                  (CFStringRef)filePath,
                                  kCFURLPOSIXPathStyle,
                                  (Boolean)false);
    
    CC_MD5_CTX hashObject;
    bool hasMoreData = true;
    bool didSucceed;
    
    if (!fileURL) goto done;
    
    // Create and open the read stream
    readStream = CFReadStreamCreateWithFile(kCFAllocatorDefault,
                                            (CFURLRef)fileURL);
    if (!readStream) goto done;
        didSucceed = (bool)CFReadStreamOpen(readStream);
        if (!didSucceed) goto done;
        
        // Initialize the hash object
        CC_MD5_Init(&hashObject);
        
        // Make sure chunkSizeForReadingData is valid
        if (!chunkSizeForReadingData) {
            chunkSizeForReadingData = HqFileHashDefaultChunkSizeForReadingData;
        }
        
        // Feed the data to the hash object
    while (hasMoreData) {
        uint8_t buffer[chunkSizeForReadingData];
        CFIndex readBytesCount = CFReadStreamRead(readStream,
                                                  (UInt8 *)buffer,
                                                  (CFIndex)sizeof(buffer));
        if (readBytesCount == -1)break;
        if (readBytesCount == 0) {
            hasMoreData =false;
            continue;
        }
        CC_MD5_Update(&hashObject,(const void *)buffer,(CC_LONG)readBytesCount);
    }
    
    
    // Check if the read operation succeeded
    didSucceed = !hasMoreData;
    // Compute the hash digest
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &hashObject);
    
    // Abort if the read operation failed
    if (!didSucceed) goto done;
    
    // Compute the string result
    char hash[2 *sizeof(digest) + 1];
    for (size_t i =0; i < sizeof(digest); ++i) {
        snprintf(hash + (2 * i),3, "%02x", (int)(digest[i]));
    }
    result = CFStringCreateWithCString(kCFAllocatorDefault,
                                       (const char *)hash,
                                       kCFStringEncodingUTF8);
    done:
        
        if (readStream) {
            CFReadStreamClose(readStream);
            CFRelease(readStream);
        }
        if (fileURL) {
            CFRelease(fileURL);
        }
        return result;
}
@end
