//
//  HqScreenSnapshotToolBar.h
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/20.
//

#import <Cocoa/Cocoa.h>

@class HqScreenSnapshotToolBar;
@protocol HqScreenSnapshotToolBarProtocol <NSObject>

@optional
- (void)cancelSnapshot:(HqScreenSnapshotToolBar *_Nullable)toolBar;
- (void)confirmSanpshot:(HqScreenSnapshotToolBar *_Nonnull)toolBar;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HqScreenSnapshotToolBar : NSView

@property(nonatomic,weak) id<HqScreenSnapshotToolBarProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
