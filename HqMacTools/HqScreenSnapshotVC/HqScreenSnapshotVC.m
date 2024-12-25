//
//  HqScreenSnapshotVC.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/26.
//

#import "HqScreenSnapshotVC.h"
@interface HqScreenSnapshotVC ()


@end

@implementation HqScreenSnapshotVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.snapshotView.hqBackgroudColor = [NSColor.blackColor colorWithAlphaComponent:0.1];

}
- (void)closeWindow{
    [self.view.window close];
}

- (HqScreenSnapshotView *)snapshotView {
    return (HqScreenSnapshotView *)self.view;
}

@end
