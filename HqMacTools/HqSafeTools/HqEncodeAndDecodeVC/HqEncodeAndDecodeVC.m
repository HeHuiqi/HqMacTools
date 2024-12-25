//
//  HqEncodeAndDecodeVC.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/23.
//

#import "HqEncodeAndDecodeVC.h"
#import <Masonry/Masonry.h>

#import "NSString+HqStringExt.h"
#import "HqEncodeDecodeUtil.h"
#import "NSData+HqDataExt.h"

#import "HqEncodeAndDecodeView.h"


@interface HqEncodeAndDecodeVC ()<NSComboBoxDataSource,NSComboBoxDelegate>

@property (nonatomic, strong) NSSegmentedControl *segmentControl;
@property (nonatomic, strong) NSComboBox *comboBox;
@property (nonatomic, strong) HqSafeToolItem *selectedItem;
@property (nonatomic, strong) HqEncodeAndDecodeView *encodeAndDecodeView;



@end

@implementation HqEncodeAndDecodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.hqBackgroudColor = NSColor.whiteColor;
    [self initToolItems];
    [self setupViews];
    
}
- (void)setupViews {
    [self.view addSubview:self.comboBox];
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.encodeAndDecodeView];
    
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
    [self.encodeAndDecodeView mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (HqEncodeAndDecodeView *)encodeAndDecodeView {
    if (!_encodeAndDecodeView) {
        _encodeAndDecodeView = [[HqEncodeAndDecodeView alloc] init];
    }
    return _encodeAndDecodeView;
}

#pragma mark - Actions


- (void)segmentChange:(NSSegmentedControl *)segment{
    NSLog(@"segment==%@",@(segment.selectedSegment));
    self.encodeAndDecodeView.contentType = segment.selectedSegment;
    
}
- (void)initToolItems{
    HqSafeToolItem *item1 = [HqSafeToolItem new];
    item1.title = @"Base64";
    item1.encodeType = HqEncodeTypeBase64;
    
    HqSafeToolItem *item2 = [HqSafeToolItem new];
    item2.title = @"Base58";
    item2.encodeType = HqEncodeTypeBase58;

    self.toolItems = @[item1,item2];
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
    self.encodeAndDecodeView.encodeType = self.selectedItem.encodeType;

}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox{
    return self.toolItems.count;
}
- (id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index{
    return self.toolItems[index].title;
}
@end
