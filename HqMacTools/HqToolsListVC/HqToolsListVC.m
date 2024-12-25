//
//  HqToolsListVC.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/11.
//

#import "HqToolsListVC.h"
#import <Masonry/Masonry.h>
#import "HqTableRowView.h"
#import "HqTableCellView.h"
#import "HqTestVC.h"
#import "HqFileOpVC.h"

#import "HqQrcodeVC.h"
#import "HqVCManager.h"

#import "HqSafeToolContainerVC.h"
#import "HqScreenSnapshotManager.h"

#import "HqRemoveAlphaVC.h"
#import "HqJsonToModelVC.h"

#import "HqWebSeverVC.h"



@interface HqToolsListVC ()<NSTableViewDelegate,NSTableViewDataSource>

@property (nonatomic, strong) NSTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HqToolsListVC


//- (void)loadView{
//    CGRect rect = CGRectMake(0, 0, 500, 200);
//    self.view = [[NSView alloc] initWithFrame:rect];
//    self.view.wantsLayer = YES;
//    self.view.layer.backgroundColor = NSColor.redColor.CGColor;
//}
#pragma mark - Getter / Setter
- (NSTableView *)tableView{
    if (!_tableView) {
        _tableView = [[NSTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.window center];
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObject:@"Test"];
    [self.dataArray addObject:@"二维码工具"];
    [self.dataArray addObject:@"加(解)密/编(解)码/Hash函数"];
    [self.dataArray addObject:@"截屏"];
    [self.dataArray addObject:@"LockFile"];
    [self.dataArray addObject:@"移除图片Alpha"];
    [self.dataArray addObject:@"HqJsonToModelVC"];
    [self.dataArray addObject:@"HqWebSeverVC"];




   
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
    column.title = @"工具列表";
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
    switch (tableView.selectedRow) {
        case 0:
        {
            NSViewController *vc = [HqVCManager createViewControllerUseNib:HqTestVC.class];
            [HqVCManager showWindowWithVC:vc setWindowVC:^(NSWindowController * _Nonnull windowVC) {
                NSWindowStyleMask styleMask = windowVC.window.styleMask;
                styleMask = styleMask | NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable;
                windowVC.window.styleMask = styleMask;
            }];
            
        }
            break;
        case 1:
        {
//            HqQrcodeVC *codeVC = [[HqQrcodeVC alloc] initWithNibName:@"HqQrcodeVC" bundle:NSBundle.mainBundle];
//            [self presentViewControllerAsSheet:codeVC];
            
            NSViewController *vc = [HqVCManager createViewControllerUseNib:HqQrcodeVC.class];
            vc.view.frame = CGRectMake(0, 0, 360, 520);
            [HqVCManager showWindowWithVC:vc setWindow:^(NSWindow * _Nonnull window) {
                window.title = @"二维码";
                
                //隐藏title
//                window.titlebarAppearsTransparent = YES;
//                window.titleVisibility = NSWindowTitleHidden;

            }];

        }
            break;
        case 2:
        {
            NSViewController *vc = [HqVCManager createViewControllerUseNib:HqSafeToolContainerVC.class];
            vc.view.frame = CGRectMake(0, 0, 680, 500);
//            [self presentViewControllerAsSheet:vc];
//            [HqVCManager showWindowWithVC:vc];
            [HqVCManager showWindowWithVC:vc setWindowVC:^(NSWindowController * _Nonnull windowVC) {
                NSWindowStyleMask styleMask = windowVC.window.styleMask;
                styleMask = styleMask | NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable;
                windowVC.window.styleMask = styleMask;
            }];

        }
            break;
        case 3:
            [HqScreenSnapshotManager.shared showSnapshotVC];

            break;
        case 4:
        {
            NSViewController *vc = [[HqFileOpVC alloc] init];
            [HqVCManager showWindowWithVC:vc setWindowVC:^(NSWindowController * _Nonnull windowVC) {
                NSWindowStyleMask styleMask = windowVC.window.styleMask;
                styleMask = styleMask | NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable;
                windowVC.window.styleMask = styleMask;
            }];
        }
            break;
        case 5:
        {
            NSViewController *vc = [[HqRemoveAlphaVC alloc] init];
            [HqVCManager showWindowWithVC:vc setWindowVC:^(NSWindowController * _Nonnull windowVC) {
                NSWindowStyleMask styleMask = windowVC.window.styleMask;
                styleMask = styleMask | NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable;
                windowVC.window.styleMask = styleMask;
            }];
        }
            break;
        case 6:
        {
            NSViewController *vc = [HqVCManager createViewControllerUseNib:HqJsonToModelVC.class];
            vc.view.frame = CGRectMake(0, 0, 1200, 800);

            [HqVCManager showWindowWithVC:vc setWindowVC:^(NSWindowController * _Nonnull windowVC) {
                NSWindowStyleMask styleMask = windowVC.window.styleMask;
                styleMask = styleMask | NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable;
                windowVC.window.styleMask = styleMask;  
            }];

        }
            break;
            
        case 7:
        {
            NSViewController *vc = [HqVCManager createViewControllerUseNib:HqWebSeverVC.class];
            vc.view.frame = CGRectMake(0, 0, 1200, 800);

            [HqVCManager showWindowWithVC:vc setWindowVC:^(NSWindowController * _Nonnull windowVC) {
                NSWindowStyleMask styleMask = windowVC.window.styleMask;
                styleMask = styleMask | NSWindowStyleMaskResizable | NSWindowStyleMaskMiniaturizable;
                windowVC.window.styleMask = styleMask;
            }];

        }
            break;
            
        default:
            break;
    }

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
    view.textField.stringValue  = self.dataArray[row];
    
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


