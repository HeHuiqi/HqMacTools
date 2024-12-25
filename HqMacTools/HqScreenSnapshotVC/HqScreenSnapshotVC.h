//
//  HqScreenSnapshotVC.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/26.
//

#import <Cocoa/Cocoa.h>
#import "HqScreenSnapshotView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HqScreenSnapshotVC : NSViewController

@property (nonatomic, strong,readonly) HqScreenSnapshotView *snapshotView;

@end

NS_ASSUME_NONNULL_END
