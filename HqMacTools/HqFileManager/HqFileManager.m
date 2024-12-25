//
//  HqFileManager.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/9/28.
//

#import "HqFileManager.h"
//#include <sys/stat.h>
//#include <unistd.h>
#import <Security/Security.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#import <MPPermissionsKit.h>

@implementation HqFileManager

+(void)runShellFile:(NSString *)filePath completeBlock:(dispatch_block_t)completeBlock{
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"HqUtils.sh" ofType:nil];
//    path = [[NSBundle mainBundle] pathForResource:@"HqLockScript.command" ofType:nil];
    

    NSTask *task = [[NSTask alloc] init];
    task.launchPath = @"/bin/sh";
//    task.launchPath = @"/usr/bin/osascript";

    task.arguments = @[filePath];
//    task.environment = @{@"PATH": @"/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:"};
    task.terminationHandler = ^(NSTask * task){
        NSLog(@"standardError:%@",task.standardError);
        NSLog(@"standardOutput:%@",task.standardOutput);
            completeBlock();
    };
//        NSPipe *outputPipe = [[NSPipe alloc] init];
//        task.standardOutput = outputPipe;
//        [outputPipe.fileHandleForReading waitForDataInBackgroundAndNotify];
    
    [task launch];
    [task waitUntilExit];
}
+(void)runShellWithCommand:(NSString *)command completeBlock:(dispatch_block_t)completeBlock{
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{
        NSString *prompt = @"需要您授权才能继续操作";
        NSString *script = [NSString stringWithFormat:@"do shell script \"%@\" with prompt \"%@\" with administrator privileges",command,prompt];
        script =  [NSString stringWithFormat:@"do shell script \"%@\" ",command];
        NSLog(@"script:%@",script);
    
        NSAppleScript *appScript = [[NSAppleScript alloc] initWithSource:script];
        NSDictionary *error;
        NSAppleEventDescriptor *result =   [appScript executeAndReturnError:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            
          
            if(error == nil && completeBlock){
                NSLog(@"[appScript executeAndReturn]=%@",result);
                completeBlock();

            }else{
                NSLog(@"[appScript executeAndReturnError]=%@",error);
            }
        });
        
    });
}

+ (BOOL)lockFile:(NSString *)filePath {
 
    NSLog(@"lockFile:%@",filePath);
    
//    [self testCodeLockFile:filePath];
//    [self testCodeUnLockFile:filePath];

    //执行applescript
    [self testCodeLockFile1:filePath];
    
//    [self testCodeWithFilePath:filePath];
//    [self testCodeWithFilePath1:filePath];
//    [self testCodeWithFilePath2:filePath];


    
    return YES;

}
+ (BOOL)unlockFile:(NSString *)filePath{
    [self testCodeUnLockFile:filePath];
    return YES;
}

+ (void)testCodeLockFile1:(NSString *)filePath{
    /*
     sudo chflags -Rv schg    系统级别锁定
     sudo chflags -Rv noschg  系统级别解锁
     chflags -Rv uchg    用户级别锁定
     chflags -Rv nouchg  用户级别解锁
     
     do shell script "chflags -Rv uchg /Users/hbwb25942/Desktop/1file_lock_unlock.sh" with administrator privileges
     
     */
    NSString *command = [NSString stringWithFormat:@"chflags -Rv uchg %@",filePath];
    command = [NSString stringWithFormat:@"sudo chflags -Rv schg %@",filePath];

    [self runShellWithCommand:command completeBlock:^{
        NSFileManager *nfManager = [NSFileManager defaultManager];

        NSDictionary *attributes = [nfManager attributesOfItemAtPath:filePath error:nil];
        NSLog(@"attributes%@",attributes);

    }];
}

+ (void)testCodeLockFile:(NSString *)filePath{
    NSFileManager *nfManager = [NSFileManager defaultManager];
    //用户级别锁定
    NSDictionary *newAttributes = @{NSFileImmutable:@(1)};
    NSError *error;
    [nfManager setAttributes:newAttributes ofItemAtPath:filePath error:&error];
    if(error){
        NSLog(@"setAttributes-error:%@",error);
        return;
    }

    NSDictionary *attributes = [nfManager attributesOfItemAtPath:filePath error:nil];
    NSLog(@"attributes%@",attributes);
    
}
+ (void)testCodeUnLockFile:(NSString *)filePath{
    NSFileManager *nfManager = [NSFileManager defaultManager];
    //用户级别解锁
    NSDictionary *newAttributes = @{NSFileImmutable:@(0)};
    NSError *error;
    [nfManager setAttributes:newAttributes ofItemAtPath:filePath error:&error];
    if(error){
        NSLog(@"setAttributes-error:%@",error);
        return;
    }

    NSDictionary *attributes = [nfManager attributesOfItemAtPath:filePath error:nil];
    NSLog(@"attributes%@",attributes);
    
}
+ (int)testCodeWithFilePath:(NSString *)filePath{
    // 打开一个文件并获取其属性标志
    int fileId = open(filePath.UTF8String, O_RDONLY);
    struct stat file_stat;
    if (fstat(fileId, &file_stat) == -1) {
        perror("fstat-error");
        return -1;
    }
    printf("Current flags: %o\n", file_stat.st_flags);

    // 添加 IMMUTABLE 权限标志
    int imutable_flag = SF_IMMUTABLE;
    int new_flags = file_stat.st_flags | imutable_flag;
    if (chflags(filePath.UTF8String, new_flags) == -1) {
        perror("chflags-error");
        return -1;
    }

    // 再次获取文件的属性标志以确认更改
    int updated_flags = fstat(fileId, &file_stat);
    if (updated_flags == -1) {
        perror("fstat-error");
        return -1;
    }
    printf("Updated flags: %o\n", updated_flags);

    // 关闭文件
    close(fileId);

    return 0;

}

+ (void)testCodeWithFilePath1:(NSString *)filePath{
    
   
    //获取用户权限代码 -- 需要包含#import <Security/Security.h> 和导入 Security.framework
    AuthorizationRef authRef;
    OSStatus status = AuthorizationCreate(NULL, kAuthorizationEmptyEnvironment, kAuthorizationFlagDefaults, &authRef);
    if (status != errAuthorizationSuccess)
    {
  
    }
    
    AuthorizationItem right = {kAuthorizationRightExecute,0,NULL,0};
//    AuthorizationItem right = {0,0,0,0};
//    right.name = "lock";

    AuthorizationRights rights = {1,&right};

    AuthorizationFlags flags = kAuthorizationFlagDefaults | kAuthorizationFlagInteractionAllowed |
    kAuthorizationFlagPreAuthorize | kAuthorizationFlagExtendRights;
    status = AuthorizationCopyRights(authRef, &rights, NULL, flags, NULL);
    if (status != errAuthorizationSuccess)
    {
  
    }else{
        int result =  chflags(filePath.UTF8String, SF_IMMUTABLE);
        NSLog(@"result==%@",@(result));
//        [self testCodeLockFile:filePath];
    }

    // Dispose of the authorization object when done
    AuthorizationFree(authRef, kAuthorizationFlagDefaults);

}


+ (void)testCodeWithFilePath2:(NSString *)filePath{
    [MPPermissionsKit requestAuthorizationForPermissionType:(MPPermissionTypeFullDiskAccess) withCompletion:^(MPAuthorizationStatus status) {
        if(status == MPAuthorizationStatusAuthorized){
            //有 Full Disk Access 权限才能修改成功
            int result =  chflags(filePath.UTF8String, SF_IMMUTABLE);
            NSLog(@"result==%@",@(result));
        }
    }];
}
@end
