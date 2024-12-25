//
//  HqScreenSnapshotView.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/26.
//

#import <Cocoa/Cocoa.h>
#import "HqScreenSnapshotConfig.h"


NS_ASSUME_NONNULL_BEGIN

@interface HqScreenSnapshotView : NSView

@property (nonatomic, strong) NSImage *screenSnapshotImage;
@property (nonatomic, assign) HQ_CAPTURE_STATE captureState;

@end

NS_ASSUME_NONNULL_END
