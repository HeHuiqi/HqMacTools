//
//  HqWebSever.h
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/24.
//

#import <Foundation/Foundation.h>
#import <GCDWebServer/GCDWebServer.h>
#import "HqUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface HqWebSever : NSObject


@property (nonatomic,strong) GCDWebServer *webFileServer;
@property (nonatomic,copy) NSString *localHTTPString;

+ (HqWebSever *)shared;
- (void)startFileServer:(NSString *)dir;
- (void)stopFileServer;


@end

NS_ASSUME_NONNULL_END
