//
//  HqScreenSnapshotWindow.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/26.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface HqScreenSnapshotWindow : NSPanel

+ (HqScreenSnapshotWindow *)snapshotWindowWithScreen:(NSScreen *)screen;

@end

NS_ASSUME_NONNULL_END
