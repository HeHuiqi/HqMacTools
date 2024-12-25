//
//  HqSafeToolListVC.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/20.
//

#import <Cocoa/Cocoa.h>
#import "HqSafeToolGroup.h"

@class HqSafeToolListVC;
@protocol HqSafeToolListVCDelegate <NSObject>

@optional
- (void)safeToolListVC:(HqSafeToolListVC *_Nullable)vc selectedGroup:(HqSafeToolGroup *_Nullable)group;

@end

NS_ASSUME_NONNULL_BEGIN

@interface HqSafeToolListVC : NSViewController

@property (nonatomic, weak) id<HqSafeToolListVCDelegate> delegate;
- (void)selectTableViewRow:(NSInteger)row;
@end

NS_ASSUME_NONNULL_END
