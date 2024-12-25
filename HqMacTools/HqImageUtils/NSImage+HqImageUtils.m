//
//  NSImage+HqImageUtils.m
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/17.
//

#import "NSImage+HqImageUtils.h"

@implementation NSImage (HqImageUtils)
+ (NSImage *)imageFromFilePath:(NSString *)filePath {
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSImage *srcImage =[[NSImage alloc] initWithContentsOfURL:url];
    return srcImage;
}
- (NSImage *)removeAlpha {
    
    CGImageSourceRef source;
    NSImage *srcImage = self;
    source = CGImageSourceCreateWithData((__bridge CFDataRef)[srcImage TIFFRepresentation], NULL);
    CGImageRef imageRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    CGRect rect = CGRectMake(0.f, 0.f, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                        rect.size.width,
                                                        rect.size.height,
                                                        CGImageGetBitsPerComponent(imageRef),
                                                        CGImageGetBytesPerRow(imageRef),
                                                        CGImageGetColorSpace(imageRef),
                                                        kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Little
                                                       );
        
    CGContextDrawImage(bitmapContext, rect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(bitmapContext);
    NSImage *finalImage = [[NSImage alloc] initWithCGImage:decompressedImageRef size:NSZeroSize];
    NSData *imageData = [finalImage  TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
//    imageData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
    imageData = [imageRep representationUsingType:NSBitmapImageFileTypePNG properties:imageProps];
    NSImage *newImage = [[NSImage alloc] initWithData:imageData];
    CGImageRelease(decompressedImageRef);
    CGContextRelease(bitmapContext);
        
    return newImage;
}

- (void)copyToPasteboard:(void(^)(void))complete {
    
    NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
    [pasteBoard clearContents];
    [pasteBoard writeObjects:@[self]];
    complete();

}

@end
