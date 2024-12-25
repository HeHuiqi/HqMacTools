//
//  HqSafeToolContainerVC.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/23.
//

#import "HqSafeToolContainerVC.h"


#define OPENSSL_NO_DEPRECATED_3_0


#import "HqEncryptAndDecryptVC.h"
#import <Masonry/Masonry.h>
#import "HqMD5Util.h"
#import "HqSHAUtil.h"

#import "HqHashVC.h"

#import "HqSafeToolListVC.h"
#import "HqSafeToolImpVC.h"
#import "HqVCManager.h"
#import "NSView+HqViewExt.h"

@interface HqSafeToolContainerVC ()<HqSafeToolListVCDelegate>

@property (nonatomic, strong) HqSafeToolImpVC *impVC;
@property (nonatomic, strong) HqSafeToolListVC *listVC;

@end

@implementation HqSafeToolContainerVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupVCs];
    
    [self.listVC selectTableViewRow:1];
}
- (void)setupVCs{
   
    [self.impVC.view setHqBackgroudColor:NSColor.whiteColor];
    [self.listVC.view setHqBackgroudColor:NSColor.whiteColor];
    NSSplitViewItem *listItem = [NSSplitViewItem splitViewItemWithViewController:self.listVC];
    NSSplitViewItem *contentItem = [NSSplitViewItem splitViewItemWithViewController:self.impVC];
    [self addSplitViewItem:listItem];
    [self addSplitViewItem:contentItem];
    
    
   [self.listVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.width.greaterThanOrEqualTo(@100);
       make.width.lessThanOrEqualTo(@150);

   }];
   
   [self.impVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
       make.width.greaterThanOrEqualTo(@150);
       make.width.lessThanOrEqualTo(@1000);
   }];
       

    
//    self.splitView.vertical = YES;
//    self.splitView.dividerStyle = NSSplitViewDividerStyleThin;

}
#pragma mark - Getter / Setter
- (HqSafeToolListVC *)listVC{
    if (!_listVC) {
        _listVC = (HqSafeToolListVC *)[HqVCManager createViewControllerUseNib:HqSafeToolListVC.class];
        _listVC.delegate = self;
    }
    return _listVC;
}
- (HqSafeToolImpVC *)impVC{
    if(!_impVC){
        _impVC = (HqSafeToolImpVC *)[HqVCManager createViewControllerUseNib:HqSafeToolImpVC.class];
    }
    return _impVC;
}

#pragma mark - HqSafeToolListVCDelegate
- (void)safeToolListVC:(HqSafeToolListVC *)vc selectedGroup:(HqSafeToolGroup *)group{
    [self.impVC changeVCWithGroup:group];
}

@end

