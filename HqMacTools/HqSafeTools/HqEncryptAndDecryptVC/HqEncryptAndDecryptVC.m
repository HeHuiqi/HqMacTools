//
//  HqEncryptAdnDecryptVC.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/13.
//

#define OPENSSL_NO_DEPRECATED_3_0


#import "HqEncryptAndDecryptVC.h"
#import <Masonry/Masonry.h>
#import "HqMD5Util.h"
#import "HqSHAUtil.h"

#import "HqVCManager.h"
#import "NSView+HqViewExt.h"

#import "NSString+HqStringExt.h"
#import "HqEncodeDecodeUtil.h"
#import "NSData+HqDataExt.h"

#import "HqEncryptAndDecryptView.h"


@interface HqEncryptAndDecryptVC ()<NSComboBoxDataSource,NSComboBoxDelegate>

@property (nonatomic, strong) NSSegmentedControl *segmentControl;
@property (nonatomic, strong) NSComboBox *comboBox;
@property (nonatomic, strong) HqSafeToolItem *selectedItem;
@property (nonatomic, strong) HqEncryptAndDecryptView *encryptAndDecryptView;



@end

@implementation HqEncryptAndDecryptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.hqBackgroudColor = NSColor.whiteColor;
    [self initToolItems];
    [self setupViews];
    
}
- (void)setupViews {
    [self.view addSubview:self.comboBox];
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.encryptAndDecryptView];
    
    [self setupLayout];
}
- (void)setupLayout{
    [self.comboBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.comboBox.mas_bottom).offset(5);
        make.height.mas_equalTo(30);
    }];
    
    CGFloat inputWidth = 400;
    [self.encryptAndDecryptView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.segmentControl.mas_bottom).offset(10);
        make.width.mas_equalTo(inputWidth);
        make.bottom.equalTo(self.view).offset(-20);
    }];

}
#pragma mark - Getter / Setter
- (NSComboBox *)comboBox{
    if (!_comboBox) {
        _comboBox = [[NSComboBox alloc] init];
        _comboBox.editable = NO;
//        _comboBox.backgroundColor = NSColor.redColor;
        _comboBox.delegate = self;
        //这个值必须在设置dataSource之前设置为YES，dataSource 才能生效
        _comboBox.usesDataSource = YES;
        _comboBox.dataSource = self;
//        _comboBox.numberOfVisibleItems = 3;
    }
    return _comboBox;
}
- (NSSegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [NSSegmentedControl segmentedControlWithLabels:@[@"Text",@"Hex",@"Image"] trackingMode:(NSSegmentSwitchTrackingSelectOne) target:self action:@selector(segmentChange:)];
        _segmentControl.selectedSegment = 0;
    }
    return _segmentControl;
}

- (HqEncryptAndDecryptView *)encryptAndDecryptView {
    if (!_encryptAndDecryptView) {
        _encryptAndDecryptView = [[HqEncryptAndDecryptView alloc] init];
    }
    return _encryptAndDecryptView;
}

#pragma mark - Actions


- (void)segmentChange:(NSSegmentedControl *)segment{
    NSLog(@"segment==%@",@(segment.selectedSegment));
    self.encryptAndDecryptView.contentType = segment.selectedSegment;
    
}
- (void)initToolItems{
    HqSafeToolItem *item1 = [HqSafeToolItem new];
    item1.title = @"AES";
    item1.encryptType = HqEncryptTypeAES;
    
//    HqSafeToolItem *item2 = [HqSafeToolItem new];
//    item2.title = @"DES";
//    item2.encodeType = HqEncryptTypeAES;

    self.toolItems = @[item1];
    [self.comboBox selectItemAtIndex:0];
    [self.comboBox reloadData];
    self.selectedItem = item1;

}
- (void)setToolItems:(NSArray<HqSafeToolItem *> *)toolItems{
    _toolItems = toolItems;
    if (_toolItems.count > 0) {
        [self.comboBox selectItemAtIndex:0];
        [self.comboBox reloadData];
    }
}
#pragma mark - NSComboBoxDelegate
- (void)comboBoxSelectionDidChange:(NSNotification *)notification{
    NSComboBox *box = (NSComboBox *)notification.object;
    NSLog(@"==box==%@",@(box.indexOfSelectedItem));
    self.selectedItem = self.toolItems[box.indexOfSelectedItem];
    self.encryptAndDecryptView.encryptType = self.selectedItem.encryptType;

}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox{
    return self.toolItems.count;
}
- (id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index{
    return self.toolItems[index].title;
}
@end
