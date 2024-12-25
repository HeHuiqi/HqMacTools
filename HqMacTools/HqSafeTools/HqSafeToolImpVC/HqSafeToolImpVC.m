//
//  HqSafeToolImpVC.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/20.
//

#import "HqSafeToolImpVC.h"
#import <Masonry/Masonry.h>

#import "HqVCManager.h"
#import "HqHashVC.h"
#import "HqEncodeAndDecodeVC.h"
#import "HqEncryptAndDecryptVC.h"


@interface HqSafeToolImpVC ()

@property (nonatomic, strong) HqHashVC *hashVC;
@property (nonatomic, strong) HqEncryptAndDecryptVC *encryptAndDecryptVC;

@property (nonatomic, strong) HqEncodeAndDecodeVC *encodeAndDecodeVC;
@property (nonatomic, strong) NSViewController *currentVC;


@end

@implementation HqSafeToolImpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupVCs];
}
- (void)setupVCs{
    
    [self addChildViewController:self.encodeAndDecodeVC];
    [self.view addSubview:self.encodeAndDecodeVC.view];
    [self.encodeAndDecodeVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.encodeAndDecodeVC.view.hidden = YES;
    
    [self addChildViewController:self.encryptAndDecryptVC];
    [self.view addSubview:self.encryptAndDecryptVC.view];
    [self.encryptAndDecryptVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.encryptAndDecryptVC.view.hidden = YES;

    
    [self addChildViewController:self.hashVC];
    [self.view addSubview:self.hashVC.view];
    [self.hashVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.currentVC = self.hashVC;
}
- (void)changeVCWithGroup:(HqSafeToolGroup *)group {
    NSViewController *toVC;
    switch (group.type) {
        case HqSafeToolTypeHash:
        {
            toVC = self.hashVC;
        }
            break;
        case HqSafeToolTypeEncryptDecrypt:
        {
            toVC = self.encryptAndDecryptVC;
        }
            break;
        case HqSafeToolTypeEncodeDecode:
        {
            toVC = self.encodeAndDecodeVC;
        }
            break;
        default:
            break;
    }
    [self changeFromVC:self.currentVC toVC:toVC];
    
}
- (void)changeFromVC:(NSViewController *)fromVC toVC:(NSViewController *)toVC{
    fromVC.view.hidden = YES;
    toVC.view.hidden = NO;
    self.currentVC = toVC;
}
#pragma mark - Getter / Setter
- (HqHashVC *)hashVC {
    if (!_hashVC) {
        _hashVC = (HqHashVC *)[HqVCManager createViewControllerUseNib:HqHashVC.class];
    }
    return _hashVC;
}
- (HqEncryptAndDecryptVC *)encryptAndDecryptVC {
    if (!_encryptAndDecryptVC) {
        _encryptAndDecryptVC = (HqEncryptAndDecryptVC *)[HqVCManager createViewControllerUseNib:HqEncryptAndDecryptVC.class];
    }
    return _encryptAndDecryptVC;
}
- (HqEncodeAndDecodeVC *)encodeAndDecodeVC {
    if (!_encodeAndDecodeVC) {
        _encodeAndDecodeVC = (HqEncodeAndDecodeVC *)[HqVCManager createViewControllerUseNib:HqEncodeAndDecodeVC.class];
    }
    return _encodeAndDecodeVC;
}
@end
