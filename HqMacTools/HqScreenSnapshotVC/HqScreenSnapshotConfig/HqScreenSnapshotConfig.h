//
//  HqScreenSnapshoConfig.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/27.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HqScreenSnapshotStatus) {
    HqScreenSnapshotStatusStart = 1, //开始截屏
    HqScreenSnapshotStatusEdit, //编辑选区
    HqScreenSnapshotStatusAdjust, //调整选区
    HqScreenSnapshotStatusEnd, // 结束
};

typedef NS_ENUM(NSInteger, HQ_CAPTURE_STATE){
    HQ_CAPTURE_STATE_START,
    HQ_CAPTURE_STATE_IDLE,
    HQ_CAPTURE_STATE_FIRSTMOUSEDOWN,
    HQ_CAPTURE_STATE_READYADJUST,
    HQ_CAPTURE_STATE_ADJUST,
    HQ_CAPTURE_STATE_EDIT,
    HQ_CAPTURE_STATE_DONE,
};

static NSString *kScreenSnapshotWindowCloseNotify = @"kScreenSnapshotWindowCloseNotify";

NS_ASSUME_NONNULL_BEGIN

@interface HqScreenSnapshotConfig : NSObject

@end

NS_ASSUME_NONNULL_END
