//
//  HqHashVC.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/20.
//

#import "HqHashVC.h"
#import <Masonry/Masonry.h>
#import "HqHashUtil.h"
#import "HqTextView.h"
#import "HqHashUtil.h"
#import "NSString+HqStringExt.h"

@interface HqHashVC ()<NSComboBoxDataSource,NSComboBoxDelegate>

@property (nonatomic, strong) NSSegmentedControl *segmentControl;
@property (nonatomic, strong) NSComboBox *comboBox;

@property (nonatomic, strong) HqTextView *inputView;
@property (nonatomic, strong) NSButton *hashBtn;
@property (nonatomic, strong) NSButton *clearBtn;

@property (nonatomic, strong) HqTextView *resultView;
@property (nonatomic, strong) HqSafeToolItem *selectedItem;
@property (nonatomic, assign) BOOL inputIsText;

@end

@implementation HqHashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.hqBackgroudColor = NSColor.whiteColor;
    [self initToolItems];
    [self setupViews];
    
}
- (void)setupViews {
    [self.view addSubview:self.comboBox];
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.hashBtn];
    [self.view addSubview:self.clearBtn];
    [self.view addSubview:self.resultView];

    [self setupLayout];
    [self.inputView.inputTv becomeFirstResponder];
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
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    CGFloat inputWidth = 400;
    CGFloat inputHeight = 150;
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.segmentControl.mas_bottom).offset(10);
        make.width.mas_equalTo(inputWidth);
        make.height.mas_equalTo(inputHeight);
    }];
    [self.hashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_centerX).offset(-4);
        make.top.equalTo(self.inputView.mas_bottom).offset(5);
    }];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_centerX).offset(4);
        make.top.equalTo(self.inputView.mas_bottom).offset(5);
    }];

    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.hashBtn.mas_bottom).offset(5);
        make.width.mas_equalTo(inputWidth);
        make.height.mas_equalTo(inputHeight);
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
        _segmentControl = [NSSegmentedControl segmentedControlWithLabels:@[@"Text",@"Hex"] trackingMode:(NSSegmentSwitchTrackingSelectOne) target:self action:@selector(segmentChange:)];
        _segmentControl.selectedSegment = 0;
    }
    return _segmentControl;
}
- (HqTextView *)inputView {
    if (!_inputView) {
        _inputView = [[HqTextView alloc] init];
    }
    return _inputView;
}
- (NSButton *)hashBtn {
    if (!_hashBtn) {
        _hashBtn = [NSButton buttonWithTitle:@"Hash" target:self action:@selector(hashBtnClick)];
    }
    return _hashBtn;
}
- (NSButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [NSButton buttonWithTitle:@"Clear" target:self action:@selector(clearBtnClick)];
    }
    return _clearBtn;
}
- (HqTextView *)resultView {
    if (!_resultView) {
        _resultView = [[HqTextView alloc] init];
        _resultView.editable = NO;

    }
    return _resultView;
}
#pragma mark - Actions

#pragma mark 点击计算hash
- (void)hashBtnClick{
    NSString *input = self.inputView.inputTv.string;
    if(input.length > 0){
        NSData *data;
        if (self.inputIsText) {
            data = [input dataUsingEncoding:NSUTF8StringEncoding];
        } else {
            data = input.hexData;
        }
        if(data){
            NSString *result = [HqHashUtil hashWithData:data hashType:self.selectedItem.hashType];
            self.resultView.text = result;
        }
    }
}
- (void)clearBtnClick{
    self.inputView.text = @"";
    self.resultView.text = @"";
}
- (void)segmentChange:(NSSegmentedControl *)segment{
    NSLog(@"segment==%@",@(segment.selectedSegment));
    self.inputIsText = segment.selectedSegment == 0;
}
- (void)initToolItems{
    HqSafeToolItem *item1 = [HqSafeToolItem new];
    item1.title = @"MD5";
    item1.hashType = HqHashTypeMD5;
    
    HqSafeToolItem *item2 = [HqSafeToolItem new];
    item2.title = @"SHA1";
    item2.hashType = HqHashTypeSHA1;

    HqSafeToolItem *item3 = [HqSafeToolItem new];
    item3.title = @"SHA224";
    item3.hashType = HqHashTypeSHA224;

    HqSafeToolItem *item4 = [HqSafeToolItem new];
    item4.title = @"SHA256";
    item4.hashType = HqHashTypeSHA256;

    HqSafeToolItem *item5 = [HqSafeToolItem new];
    item5.title = @"SHA384";
    item5.hashType = HqHashTypeSHA384;
    
    HqSafeToolItem *item6 = [HqSafeToolItem new];
    item6.title = @"SHA512";
    item6.hashType = HqHashTypeSHA512;


    self.toolItems = @[item1,item2,item3,item4,item5,item6];
    [self.comboBox selectItemAtIndex:0];
    [self.comboBox reloadData];
    self.inputIsText = YES;
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
//    NSLog(@"==box==%@",@(box.indexOfSelectedItem));
    self.selectedItem = self.toolItems[box.indexOfSelectedItem];
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox{
    return self.toolItems.count;
}
- (id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index{
    return self.toolItems[index].title;
}
@end
