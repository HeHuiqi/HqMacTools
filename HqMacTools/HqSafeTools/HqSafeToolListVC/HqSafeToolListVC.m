//
//  HqSafeToolListVC.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/20.
//

#import "HqSafeToolListVC.h"
#import <Masonry/Masonry.h>
#import "HqTableRowView.h"
#import "HqTableCellView.h"

@interface HqSafeToolListVC ()<NSTableViewDelegate,NSTableViewDataSource>

@property (nonatomic, strong) NSTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger selecteRow;

@end

@implementation HqSafeToolListVC


//- (void)loadView{
//    CGRect rect = CGRectMake(0, 0, 600, 400);
//    self.view = [[NSView alloc] initWithFrame:rect];
//}
#pragma mark - Getter / Setter
- (NSTableView *)tableView{
    if (!_tableView) {
        _tableView = [[NSTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.allowsMultipleSelection = NO;
    }
    return _tableView;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.window center];
    [self setupDatas];
    [self setupViews];
    self.selecteRow = 0;
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:self.selecteRow];
    [self.tableView selectRowIndexes:set byExtendingSelection:YES];
    
    
}
- (void)setupDatas{
    self.dataArray = [NSMutableArray array];
    HqSafeToolGroup *group1 = [HqSafeToolGroup new];
    group1.title = @"Hash函数";
    group1.type = HqSafeToolTypeHash;
    
    HqSafeToolGroup *group2 = [HqSafeToolGroup new];
    group2.title = @"加/解密";
    group2.type = HqSafeToolTypeEncryptDecrypt;
    
    HqSafeToolGroup *group3 = [HqSafeToolGroup new];
    group3.title = @"编/解码";
    group3.type = HqSafeToolTypeEncodeDecode;
    
    
    [self.dataArray addObject:group1];
    [self.dataArray addObject:group2];
    [self.dataArray addObject:group3];
    

   
}
- (void)setupViews{
    NSScrollView * scrollView  = [[NSScrollView alloc] init];

    scrollView.hasVerticalScroller  = YES;
    [self.view addSubview:scrollView];
    scrollView.contentView.documentView = self.tableView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.width.equalTo(self.view);
        make.height.equalTo(self.view);

    }];
    //隐藏头部
//    self.tableView.headerView = nil;
    NSTableColumn * column = [[NSTableColumn alloc]initWithIdentifier:@"first_column"];
    column.title = @"功能列表";
    column.minWidth = 80;
    [self.tableView addTableColumn:column];
    
    [self.tableView reloadData];
    self.tableView.action = @selector(doClick:);
//    self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;
    self.tableView.gridColor = NSColor.purpleColor;
}
- (void)doClick:(NSTableView *)tableView{
//    NSLog(@"doClick-tableView.clickedRow=%@",@(tableView.clickedRow));
//    NSLog(@"doClick-tableView.selectedRow=%@",@(tableView.selectedRow));
    [self callDelegateWithRow:tableView.selectedRow];
}
- (void)callDelegateWithRow:(NSInteger)row{
    if (row >=0 && self.delegate && [self.delegate respondsToSelector:@selector(safeToolListVC:selectedGroup:)]) {
        [self.delegate safeToolListVC:self selectedGroup:self.dataArray[row]];
    }
    self.selecteRow = row;
}
- (void)selectTableViewRow:(NSInteger)row {
    [self.tableView deselectRow:self.selecteRow];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:row];
    [self.tableView selectRowIndexes:set byExtendingSelection:YES];
    [self callDelegateWithRow:row];
}
#pragma mark - NSTableViewDelegate,NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return self.dataArray.count;
}

// "Cell Based" 必须实现
//- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
//    return self.dataArray[row];
//}
//"Cell Based"
//- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
//    NSCell *cell = [[NSCell alloc] initTextCell:self.dataArray[row]];
////    cell.title = self.dataArray[row];
//    return cell;
//}

// "view Based"
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{

    static NSString *cellId = @"cellView";
    HqTableCellView *view = [tableView makeViewWithIdentifier:cellId owner:nil];
    if (!view) {
        view = [[HqTableCellView alloc] init];
        view.identifier = cellId;
    }
    HqSafeToolGroup *gp = self.dataArray[row];
    view.textField.stringValue  = gp.title;
    
    return view;
}
//设置每行容器视图
- (nullable NSTableRowView *)tableView:(NSTableView *)tableView rowViewForRow:(NSInteger)row {
    HqTableRowView * rowView = [[HqTableRowView alloc]init];
    rowView.backgroundColor = NSColor.redColor;
    return rowView;
}
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    return NO;
}
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 40;
}


@end



