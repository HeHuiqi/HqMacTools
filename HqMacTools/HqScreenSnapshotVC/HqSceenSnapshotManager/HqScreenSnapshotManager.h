//
//  HqSceenSnapshotManager.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HqScreenSnapshotManager : NSObject


+ (HqScreenSnapshotManager *)shared;
- (NSArray<NSDictionary*>*)allWindowInfoList;
- (NSRect)windowRectWithIno:(NSDictionary *)info;
- (NSInteger)windowLayerWithInfo:(NSDictionary *)info;
- (NSArray<NSValue *> *)allWindowRect;

- (void)showSnapshotVC;



@end

NS_ASSUME_NONNULL_END
