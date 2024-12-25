//
//  HqEncryptAdnDecryptVC.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/13.
//

#import <Cocoa/Cocoa.h>
#import "HqSafeToolItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface HqEncryptAndDecryptVC : NSSplitViewController

@property (nonatomic, strong) NSArray<HqSafeToolItem *> *toolItems;



@end

NS_ASSUME_NONNULL_END
