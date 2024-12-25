//
//  HqJsonToModelVC.m
//  HqMacTools
//
//  Created by hehuiqi on 2024/12/19.
//

#import "HqJsonToModelVC.h"
#import <Masonry/Masonry.h>

#import "HqTextView.h"
#import "HqJsonToModelLogic.h"
#import "HqDialog.h"



@interface HqJsonToModelVC ()<NSComboBoxDelegate,NSComboBoxDataSource>

@property (nonatomic,strong) HqTextView *inputTv;
@property (nonatomic,strong) HqTextView *resultTv;

@property (nonatomic, strong) NSButton *convertBtn;

@property (nonatomic, strong) NSButton *formatJsonBtn;
@property (nonatomic, strong) NSButton *removeZhuanyiBtn;
@property (nonatomic, strong) NSButton *addZhuanyiBtn;

@property (nonatomic, strong) NSComboBox *comboBox;

@property (nonatomic, strong) NSButton *copyModelBtn;


@property (nonatomic,strong) HqJsonToModelLogic *logic;
@property (nonatomic,strong) NSMutableArray *languagesDatas;
@property (nonatomic,strong) NSTextField *modelNameTf;

@end

@implementation HqJsonToModelVC

- (NSMutableArray *)languagesDatas {
    if (!_languagesDatas) {
        _languagesDatas = @[@"SwiftClass",@"SwiftStruct",@"OC-Class"].mutableCopy;
    }
    return _languagesDatas;
}
- (NSTextField *)modelNameTf {
    if (!_modelNameTf) {
        _modelNameTf = [[NSTextField alloc] init];
        _modelNameTf.placeholderString = @"请输入Model名称";
    }
    return _modelNameTf;
}
- (HqTextView *)inputTv {
    if (!_inputTv) {
        _inputTv = [[HqTextView alloc] init];
        _inputTv.font = [NSFont systemFontOfSize:16];
    }
    return _inputTv;
}
- (HqTextView *)resultTv {
    if (!_resultTv) {
        _resultTv = [[HqTextView alloc] init];
        _resultTv.font = [NSFont systemFontOfSize:16];
        _resultTv.editable = NO;
    }
    return _resultTv;
}

- (NSButton *)convertBtn{
    if(!_convertBtn){
        _convertBtn = [NSButton buttonWithTitle:@"转换Model" target:self action:@selector(btnClick:)];
        _convertBtn.tag = 0;
    }
    return _convertBtn;
}
- (NSComboBox *)comboBox {
    if (!_comboBox) {
        _comboBox = [[NSComboBox alloc] init];
        _comboBox.usesDataSource = YES;
        _comboBox.delegate = self;
        _comboBox.dataSource = self;
        _comboBox.editable = false;
        //默认选中第一个
        [_comboBox selectItemAtIndex:0];
    }
    return _comboBox;
}
- (NSButton *)copyModelBtn {
    if(!_copyModelBtn){
        _copyModelBtn = [NSButton buttonWithTitle:@"复制Model" target:self action:@selector(copyBtnClick)];
    }
    return _copyModelBtn;
}
- (NSButton *)addZhuanyiBtn {
    if(!_addZhuanyiBtn){
        _addZhuanyiBtn = [NSButton buttonWithTitle:@"添加转义" target:self action:@selector(addZhuanyiClick)];
    }
    return _addZhuanyiBtn;
}
- (NSButton *)removeZhuanyiBtn {
    if(!_removeZhuanyiBtn){
        _removeZhuanyiBtn = [NSButton buttonWithTitle:@"去除转义" target:self action:@selector(removeZhuanyiClick)];
    }
    return _removeZhuanyiBtn;
}
- (NSButton *)formatJsonBtn {
    if(!_formatJsonBtn){
        _formatJsonBtn = [NSButton buttonWithTitle:@"格式化Json" target:self action:@selector(formatClick)];
    }
    return _formatJsonBtn;
}
- (void)formatClick{
    NSString *json = self.inputTv.text;
    if (json.length ==  0) {
        [HqDialog showMessage:@"请输入json数据" inView:self.view];
        return;
    }
    json = [json stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSString *formatJson = [self.logic formatJSONString:json];
    if (formatJson.length > 0) {
        self.inputTv.text = formatJson;
    } else {
        self.inputTv.text = json;
    }
    
    self.inputTv.text = json;
}
- (void)removeZhuanyiClick{
    NSString *json = self.inputTv.text;
    if (json.length ==  0) {
        [HqDialog showMessage:@"请输入json数据" inView:self.view];
        return;
    }
    json = [json stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    self.inputTv.text = json;
}
- (void)addZhuanyiClick{
    NSString *json = self.inputTv.text;
    if (json.length ==  0) {
        [HqDialog showMessage:@"请输入json数据" inView:self.view];
        return;
    }
    json = [json stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    self.inputTv.text = json;
}
- (void)copyBtnClick {
    NSString *copyText = self.resultTv.text;
    
    if (copyText.length == 0) {
        [HqDialog showMessage:@"请转换后再复制" inView:self.view];

        return;
    }
    NSPasteboard *ps = [NSPasteboard generalPasteboard];
    [ps clearContents];
    [ps writeObjects:@[copyText]];
    [HqDialog showMessage:@"复制成功" inView:self.view];
    
}
- (void)btnClick:(NSButton *)btn {
    
    if (self.inputTv.text.length ==  0) {
        [HqDialog showMessage:@"请输入json数据" inView:self.view];

        return;
    }
    NSString *json = self.inputTv.text;

    NSDictionary *dic = [self.logic dictionaryWithJsonString:json];
    if (dic.count == 0) {
        [HqDialog showMessage:@"Json不合法" inView:self.view];
        return;
    }
    NSString *modelName = self.modelNameTf.stringValue;
    if (modelName.length == 0) {
        modelName = @"HqModel";
    }
    NSString *result = @"";
    NSInteger index = self.comboBox.indexOfSelectedItem;
    switch (index) {
        case 0:
            result = [self.logic makeSwiftModelWithName:modelName isToClass:YES  dic:dic];
            break;
        case 1:
            result = [self.logic makeSwiftModelWithName:modelName isToClass:NO  dic:dic];
            break;
        case 2:
            result = [self.logic makeOCModelWithName:modelName dic:dic];
            break;
            
        default:
            break;
    }
   self.resultTv.text = result;
}
- (HqJsonToModelLogic *)logic {
    if (!_logic) {
        _logic = [[HqJsonToModelLogic alloc] init];
    }
    return _logic;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
  
}

- (void)setupUI {
    [self.view addSubview:self.modelNameTf];

    [self.view addSubview:self.inputTv];
    
    [self.view addSubview:self.comboBox];
    [self.view addSubview:self.convertBtn];

    [self.view addSubview:self.resultTv];
    [self.view addSubview:self.addZhuanyiBtn];
    [self.view addSubview:self.removeZhuanyiBtn];
    [self.view addSubview:self.formatJsonBtn];

    [self.view addSubview:self.copyModelBtn];

  
    [self.comboBox mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_centerY).offset(-20);
        make.width.mas_equalTo(100);
    }];
    
    [self.convertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.comboBox.mas_bottom).offset(40);
        make.width.mas_equalTo(100);

    }];
    [self.modelNameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.convertBtn.mas_left).offset(-10);
        make.height.mas_equalTo(25);
    }];
    
    [self.inputTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modelNameTf.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(20);
        make.right.equalTo(self.convertBtn.mas_left).offset(-10);
        make.bottom.equalTo(self.view).offset(-50);

    }];

    
    [self.removeZhuanyiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.inputTv.mas_left);
        make.top.equalTo(self.inputTv.mas_bottom).offset(10);
        
    }];
    [self.formatJsonBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.inputTv.mas_centerX);
        make.top.equalTo(self.removeZhuanyiBtn.mas_top);
        
    }];
    [self.addZhuanyiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.inputTv.mas_right);
        make.top.equalTo(self.removeZhuanyiBtn.mas_top);
        
    }];
    

    [self.resultTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTv.mas_top);
        make.right.equalTo(self.view).offset(-20);
        make.left.equalTo(self.convertBtn.mas_right).offset(10);
        make.bottom.equalTo(self.view).offset(-50);

    }];
    [self.copyModelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.resultTv.inputTv);
        make.top.equalTo(self.resultTv.mas_bottom).offset(10);

    }];

}


#pragma mark - NSComboBoxDelegate,NSComboBoxDataSource
// NSComboBoxDelegate
- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    NSLog(@"notification.object:%@",@(self.comboBox.indexOfSelectedItem));
}
// NSComboBoxDataSource
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox {
    
    return self.languagesDatas.count;
    
}
- (nullable id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index {
    return self.languagesDatas[index];
}

//- (NSUInteger)comboBox:(NSComboBox *)comboBox indexOfItemWithStringValue:(NSString *)string {
//    return 0;
//}
//- (nullable NSString *)comboBox:(NSComboBox *)comboBox completedString:(NSString *)string {
//    return  string;
//}

@end
