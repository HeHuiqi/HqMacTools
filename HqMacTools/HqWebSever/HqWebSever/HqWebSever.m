//
//  HqWebSever.m
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/24.
//

#import "HqWebSever.h"
#import "HqUtils.h"

@implementation HqWebSever

+ (HqWebSever *)shared {
    static HqWebSever *ws = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ws = [[self alloc] init];
    });
    return ws;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.webFileServer =  [[GCDWebServer alloc] init];
    }
    return self;
}
- (NSString *)localHTTPString {
    NSString *ip = [HqUtils deviceIPAdress];
    NSString *serverURL = self.webFileServer.serverURL.absoluteString;
    if (serverURL == nil) {
        serverURL = [[NSString alloc] initWithFormat:@"http://%@:%@",ip,@(self.webFileServer.port)];
        NSLog(@"local:%@",serverURL);
    }
    NSLog(@"serverURL:%@",serverURL);


    return serverURL;
}

- (void)startFileServer:(NSString *)dir {
    
    [self stopFileServer];
    
    [self.webFileServer addGETHandlerForBasePath:@"/" directoryPath:dir indexFilename:nil cacheAge:360000 allowRangeRequests:YES];

    [self.webFileServer startWithPort:9000 bonjourName:nil];
    
    [self localHTTPString];

}
- (void)stopFileServer {
    if (self.webFileServer.isRunning) {
        [self.webFileServer stop];

    }
}

@end
