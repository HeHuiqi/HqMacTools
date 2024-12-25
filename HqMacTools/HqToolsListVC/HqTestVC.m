//
//  HqTestVC.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/12.
//

#import "HqTestVC.h"
#import <Security/Security.h>
#import <SecurityInterface/SecurityInterface.h>
#import <Masonry/Masonry.h>
#include <stdio.h>
#include <stdlib.h>
#include <CoreFoundation/CoreFoundation.h>
#include <Security/Authorization.h>
#include <Security/AuthorizationDB.h>
@interface HqTestVC ()

@property (nonatomic,strong) SFAuthorizationView *authorizationView ;
@property (nonatomic,strong) NSButton *btn ;

@end

@implementation HqTestVC

   
const char kTestActionRightName[] = "com.osxbook.Test.DoSomething";
   
int
qmain(void)
{
    OSStatus            err;
    AuthorizationRef    authRef;
    AuthorizationItem   authorization = { 0, 0, 0, 0 };
    AuthorizationRights rights = { 1, &authorization };
    AuthorizationFlags  flags = kAuthorizationFlagInteractionAllowed |kAuthorizationFlagExtendRights;
    // Create a new authorization reference
    err = AuthorizationCreate(NULL, NULL, 0, &authRef);
    if (err != noErr) {
        fprintf(stderr, "failed to connect to Authorization Services\n");
        return err;
    }
   
    // Check if the right is defined
    err = AuthorizationRightGet(kTestActionRightName, NULL);
    if (err != noErr) {
        if (err == errAuthorizationDenied) {
            // Create right in the policy database
            err = AuthorizationRightSet(
                      authRef,
                      kTestActionRightName,
                      CFSTR(kAuthorizationRuleAuthenticateAsSessionUser),
                      CFSTR("You must be authorized to perform DoSomething."),
                      NULL,
                      NULL
                  );
            if (err != noErr) {
                fprintf(stderr, "failed to set up right\n");
                return err;
            }
        }
        else {
            // Give up
            fprintf(stderr, "failed to check right definition (%ld)\n", err);
            return err;
        }
    }
   
    // Authorize right
    authorization.name = kTestActionRightName;
    err = AuthorizationCopyRights(authRef, &rights, NULL, flags, NULL);
    if (err != noErr)
        fprintf(stderr, "failed to acquire right (%s)\n", kTestActionRightName);
    else
        fprintf(stderr, "right acquired (%s)\n", kTestActionRightName);
   
    // Free the memory associated with the authorization reference
    AuthorizationFree(authRef, kAuthorizationFlagDefaults);
   
    return 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.authorizationView = [[SFAuthorizationView alloc] init];
    self.authorizationView.delegate = self;
    [self.authorizationView setString:"需要访问系统事件权限，用于提供更好的用户体验。"];
//    [self.authorizationView setAuthorizationRights:NULL];
//    [self.authorizationView setAutoupdate:YES];
    [self.view addSubview:self.authorizationView];
    



    [self.authorizationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(20);
        make.top.equalTo(self.view).offset(100);
        make.width.mas_equalTo(200);
    }];
  
    
    
}
- (IBAction)testBtnClick:(NSButton *)sender {
    for (NSScreen *screen in NSScreen.screens) {
        NSLog(@"screen==%@",screen);
        NSLog(@"screen.frame==%@",@(screen.frame));

    }
//    [self simulateClick:self.authorizationView];
    
//   id btn =  [self.authorizationView valueForKey:@"textButton"];
    
//    for (NSView *view in self.authorizationView.subviews) {
//        NSLog(@"view:%@",view.subviews);
//        if ([view isKindOfClass:NSClassFromString(@"SFAnimatedLockButton")]) {
//            NSButton *btn = (NSButton *)view;
//            NSLog(@"sendActionOn");
//            [btn sendActionOn:(NSEventMaskKeyUp)];
//
////            break;
//        }
//    }
    qmain();
}

- (void)simulateClick:(NSView *)view {
    CGPoint point = [view convertPoint:view.bounds.origin toView:nil];
    NSLog(@"point:%@",@(point));
    CGEventRef downEvent = CGEventCreateMouseEvent(nil, kCGEventLeftMouseDown, point, kCGMouseButtonLeft);
    CGEventRef upEvent = CGEventCreateMouseEvent(nil, kCGEventLeftMouseUp, point, kCGMouseButtonLeft);
    CGEventPost(kCGSessionEventTap,downEvent);
    CGEventPost(kCGSessionEventTap, upEvent);


    
}
- (void)authorizationViewDidAuthorize:(SFAuthorizationView *)authorizationView
{
    NSLog(@"授权成功");
    // 授权成功后的操作，例如启用相关功能
}

- (void)authorizationViewDidDeauthorize:(SFAuthorizationView *)authorizationView
{
    NSLog(@"授权失败");
    // 授权失败后的操作，例如提示用户需要授权才能使用某些功能
}

@end
