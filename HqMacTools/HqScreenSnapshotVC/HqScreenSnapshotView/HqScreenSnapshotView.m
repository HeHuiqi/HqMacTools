//
//  HqScreenSnapshotView.m
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/26.
//

#import "HqScreenSnapshotView.h"
#import "HqScreenSnapshotManager.h"
#import "HqScreenSnapshotUtil.h"
#import "NSImage+HqImageUtils.h"
#import "HqScreenSnapshotToolBar.h"

const int kDRAG_POINT_NUM = 8; // 几个点
const int kDRAG_POINT_LEN = 5; // 点的大小
const int kAdjustKnown = 8;


@interface HqScreenSnapshotView ()<HqScreenSnapshotToolBarProtocol>


@property (nonatomic, assign) NSRect currentRect;
@property (nonatomic, assign) NSRect lastRect;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) NSColor *strokeColor;
@property (nonatomic, assign) NSPoint startPoint;
@property (nonatomic, assign) NSPoint endPoint;

@property (nonatomic, assign) int dragDirection;
@property (nonatomic, assign) NSPoint rectBeginPoint;
@property (nonatomic, assign) NSPoint rectEndPoint;
@property (nonatomic, assign) BOOL rectDrawing;
@property (nonatomic, assign) NSRect dragWindowRect;

@property (nonatomic,strong) HqScreenSnapshotToolBar *toolBar;


@end

@implementation HqScreenSnapshotView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (HqScreenSnapshotToolBar *)toolBar {
    if (!_toolBar) {
        _toolBar = [[HqScreenSnapshotToolBar alloc] init];
        _toolBar.frame = CGRectMake(0, 0, 230, 40);
        _toolBar.hqCornerRaduis = 3;
        _toolBar.delegate = self;
        _toolBar.hidden = YES;
    }
    return _toolBar;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
    [self addSubview:self.toolBar];

}
- (void)myWindowClose{
   
    [self saveImageToPasteBoard];
}
- (void)dealloc{
}
- (void)setup {
    self.lineWidth = 2;
    self.captureState = HQ_CAPTURE_STATE_START;
    self.strokeColor = [NSColor systemBlueColor];
}
- (void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
    
    [self.screenSnapshotImage drawInRect:self.currentRect fromRect:self.currentRect operation:NSCompositingOperationCopy fraction:1.0];
    if (self.strokeColor) {
        [self.strokeColor set];
        NSBezierPath *rectPath = [NSBezierPath bezierPathWithRect:self.currentRect];
        rectPath.lineWidth = self.lineWidth;
        [rectPath stroke];
        if (self.captureState == HQ_CAPTURE_STATE_ADJUST) {
            for (int i = 0; i < kDRAG_POINT_NUM; i++) {
                [[NSColor whiteColor] set];
                NSBezierPath *adjustPath = [NSBezierPath bezierPath];
                [adjustPath removeAllPoints];
                
                [adjustPath appendBezierPathWithOvalInRect:[self pointRect:i inRect:self.currentRect]];
                [adjustPath fill];
            }
        }
    }
}
// 确定调整大小的8个点的位置
- (NSRect)pointRect:(int)index inRect:(NSRect)rect{
    double x = 0, y = 0;
    switch (index) {
        case 0:
            x = NSMinX(rect);
            y = NSMaxY(rect);
            break;
        case 1:
            x = NSMidX(rect);
            y = NSMaxY(rect);
            break;
        case 2:
            x = NSMaxX(rect);
            y = NSMaxY(rect);
            break;
        case 3:
            x = NSMinX(rect);
            y = NSMidY(rect);
            break;
        case 4:
            x = NSMaxX(rect);
            y = NSMidY(rect);
            break;
        case 5:
            x = NSMinX(rect);
            y = NSMinY(rect);
            break;
        case 6:
            x = NSMidX(rect);
            y = NSMinY(rect);
            break;
        case 7:
            x = NSMaxX(rect);
            y = NSMinY(rect);
            break;
            
        default:
            break;
    }
    return NSMakeRect(x - kDRAG_POINT_LEN, y - kDRAG_POINT_LEN, kDRAG_POINT_LEN * 2, kDRAG_POINT_LEN * 2);
}

#pragma mark - 鼠标事件 通过window鼠标事件调用传递

- (int)dragDirectionFromPoint:(NSPoint)point {
    if (NSWidth(self.currentRect) <= kAdjustKnown * 2 || NSHeight(self.currentRect) <= kAdjustKnown * 2) {
        if (NSPointInRect(point, self.currentRect)) {
            return 8;
        }
    }
    NSRect innerRect = NSInsetRect(self.currentRect, kAdjustKnown, kAdjustKnown);
    if (NSPointInRect(point, innerRect)) {
        return 8;
    }
    NSRect outerRect = NSInsetRect(self.currentRect, -kAdjustKnown, -kAdjustKnown);
    if (!NSPointInRect(point, outerRect)) {
        return -1;
    }
    double minDistance = kAdjustKnown * kAdjustKnown;
    int ret = -1;
    for (int i = 0; i < 8; i++) {
        NSPoint dragPoint = [self dragPointCenter:i];
        double distance = [HqScreenSnapshotUtil pointDistance:dragPoint toPoint:point];
        if (distance < minDistance) {
            minDistance = distance;
            ret = i;
        }
    }
    return ret;
}
- (NSPoint)dragPointCenter:(int)index
{
    double x = 0, y = 0;
    switch (index) {
        case 0:
            x = NSMinX(self.currentRect);
            y = NSMaxY(self.currentRect);
            break;
        case 1:
            x = NSMidX(self.currentRect);
            y = NSMaxY(self.currentRect);
            break;
        case 2:
            x = NSMaxX(self.currentRect);
            y = NSMaxY(self.currentRect);
            break;
        case 3:
            x = NSMinX(self.currentRect);
            y = NSMidY(self.currentRect);
            break;
        case 4:
            x = NSMaxX(self.currentRect);
            y = NSMidY(self.currentRect);
            break;
        case 5:
            x = NSMinX(self.currentRect);
            y = NSMinY(self.currentRect);
            break;
        case 6:
            x = NSMidX(self.currentRect);
            y = NSMinY(self.currentRect);
            break;
        case 7:
            x = NSMaxX(self.currentRect);
            y = NSMinY(self.currentRect);
            break;

        default:
            break;
    }
    return NSMakePoint(x, y);
}

- (void)mouseDown:(NSEvent *)event{
    self.toolBar.hidden = YES;
    NSLog(@"mouseDown--------------self.captureState----%@",@(self.captureState));

    if (self.captureState == HQ_CAPTURE_STATE_START) {
        self.captureState = HQ_CAPTURE_STATE_FIRSTMOUSEDOWN;
        self.startPoint = NSEvent.mouseLocation;
        [self redraw];
    }
}
- (void)mouseUp:(NSEvent *)event {
    NSLog(@"mouseUp--------------self.captureState----%@",@(self.captureState));

    self.toolBar.hidden = NO;

    if (self.captureState == HQ_CAPTURE_STATE_FIRSTMOUSEDOWN ||
        self.captureState == HQ_CAPTURE_STATE_READYADJUST) {
        self.captureState = HQ_CAPTURE_STATE_ADJUST;
        
        [self startAdjustSeleted];
        
        NSLog(@"开始编辑选区");
        [self redraw];
    }
}
- (void)mouseMoved:(NSEvent *)event{
    NSLog(@"mouseMoved--------------self.captureState----%@",@(self.captureState));

    if (self.captureState == HQ_CAPTURE_STATE_START) {
        [self caputreActivityWindow];
        return;
    }
    
    if (self.captureState == HQ_CAPTURE_STATE_ADJUST) {
//        self.startPoint = [NSEvent mouseLocation];
//        self.currentRect = [HqScreenSnapshotUtil uniformRect:self.currentRect];
//        self.dragWindowRect = self.currentRect;
//        self.dragDirection = [self dragDirectionFromPoint:[NSEvent mouseLocation]];
        [self startAdjustSeleted];
    }
    
}
- (void)startAdjustSeleted {
    self.startPoint = [NSEvent mouseLocation];
    self.currentRect = [HqScreenSnapshotUtil uniformRect:self.currentRect];
    self.dragWindowRect = self.currentRect;
    self.dragDirection = [self dragDirectionFromPoint:[NSEvent mouseLocation]];
}
- (void)mouseDragged:(NSEvent *)event {
    NSLog(@"mouseDragged--------------self.captureState----%@",@(self.captureState));

    if (self.captureState == HQ_CAPTURE_STATE_FIRSTMOUSEDOWN) {

        self.captureState = HQ_CAPTURE_STATE_READYADJUST;
        self.endPoint = NSEvent.mouseLocation;
        self.currentRect = NSUnionRect(NSMakeRect(self.startPoint.x, self.startPoint.y, 1, 1), NSMakeRect(self.endPoint.x, self.endPoint.y, 1, 1));
        self.currentRect = NSIntersectionRect(self.currentRect, self.window.frame);
        [self redraw];
        return;
    }
    else if (self.captureState == HQ_CAPTURE_STATE_ADJUST) {

        if (self.dragDirection == -1) return;

        NSPoint mouseLocation = [NSEvent mouseLocation];
        self.endPoint = mouseLocation;
        CGFloat deltaX = self.endPoint.x - self.startPoint.x;
        CGFloat deltaY = self.endPoint.y - self.startPoint.y;
        NSRect rect = self.dragWindowRect;
        switch (self.dragDirection) {
            case 8: {
                rect = NSOffsetRect(rect, self.endPoint.x - self.startPoint.x, self.endPoint.y - self.startPoint.y);
                if (!NSContainsRect(self.window.frame, rect)) {
                    NSRect rcOrigin = self.window.frame;
                    if (rect.origin.x < rcOrigin.origin.x) {
                        rect.origin.x = rcOrigin.origin.x;
                    }
                    if (rect.origin.y < rcOrigin.origin.y) {
                        rect.origin.y = rcOrigin.origin.y;
                    }
                    if (rect.origin.x > rcOrigin.origin.x + rcOrigin.size.width - rect.size.width) {
                        rect.origin.x = rcOrigin.origin.x + rcOrigin.size.width - rect.size.width;
                    }
                    if (rect.origin.y > rcOrigin.origin.y + rcOrigin.size.height - rect.size.height) {
                        rect.origin.y = rcOrigin.origin.y + rcOrigin.size.height - rect.size.height;
                    }
                    self.endPoint = NSMakePoint(self.startPoint.x + rect.origin.x - self.dragWindowRect.origin.x, self.startPoint.y + rect.origin.y - self.dragWindowRect.origin.y);
                }
            }
                break;
            case 7: {
                rect.origin.y += deltaY;
                rect.size.width += deltaX;
                rect.size.height -= deltaY;

            }
                break;
            case 6: {
                rect.origin.y += deltaY;
                rect.size.height -= deltaY;
            }
                break;
            case 5: {
                rect.origin.x += deltaX;
                rect.origin.y += deltaY;
                rect.size.width -= deltaX;
                rect.size.height -= deltaY;
            }
                break;
            case 4: {
                rect.size.width += deltaX;
            }
                break;
            case 3: {
                rect.origin.x += deltaX;
                rect.size.width -= deltaX;
            }
                break;
            case 2: {
                rect.size.width += deltaX;
                rect.size.height += deltaY;
            }
                break;
            case 1: {
                rect.size.height += deltaY;
            }
                break;
            case 0: {
                rect.origin.x += deltaX;
                rect.size.width -= deltaX;
                rect.size.height += deltaY;
            }
                break;
            default:
                break;
        }
        self.dragWindowRect = rect;
        if ((int) rect.size.width == 0) rect.size.width = 1;
        if ((int) rect.size.height == 0) rect.size.height = 1;
        self.currentRect = [HqScreenSnapshotUtil uniformRect:rect];
        self.startPoint = self.endPoint;
//        NSLog(@"adjust drag :%@", NSStringFromRect(self.dragWindowRect));
//        [self.snipView showTip];
//        [self redrawView:self.originImage];
        [self redraw];
    }

}
#pragma mark -
- (void)saveImageToPasteBoard {
    //将边框和圆点去除
    self.strokeColor = nil;
    
    [self redraw];
    
    self.toolBar.hidden = YES;
    
    //将当前视图指定区域保存为图片
    NSBitmapImageRep *bitmap = [HqScreenSnapshotUtil viewToBitmapImage:self inReact:self.currentRect];
    NSImage *finalyImage = [HqScreenSnapshotUtil bitmapImageToImage:bitmap];
    [finalyImage copyToPasteboard:^{
        
    }];
    self.toolBar.hidden = NO;
    [self.window close];
    
}
- (NSImage *)resizeImage:(NSImage*)sourceImage targetFrame:(NSRect)targetFrame {

    NSImageRep *sourceImageRep = [sourceImage bestRepresentationForRect:targetFrame context:nil hints:nil];

    NSImage *targetImage = [[NSImage alloc] initWithSize:targetFrame.size];

    [targetImage lockFocus];
    [sourceImageRep drawInRect: targetFrame];
    [targetImage unlockFocus];

    return targetImage;
}
- (void)onOK1 {
    
   
    
    // 把选择的截图保存到粘贴板
    [self.screenSnapshotImage lockFocus];
    
    //先设置 下面一个实例
  
    NSBitmapImageRep *bits = [[NSBitmapImageRep alloc] initWithFocusedViewRect:self.currentRect];
    
//    CGRect rect = CGRectInset(self.currentRect,self.lineWidth, self.lineWidth);
//    bits = [self bitmapImageRepForCachingDisplayInRect:rect];
//    [self cacheDisplayInRect:rect toBitmapImageRep:bits];
    
    [self.screenSnapshotImage unlockFocus];
    
    //再设置后面要用到得 props属性
    NSDictionary *imageProps = @{NSImageCompressionFactor : @(1.0)};
    
    //之后 转化为NSData 以便存到文件中
    NSData *imageData = [bits representationUsingType:NSBitmapImageFileTypeJPEG properties:imageProps];
    NSImage *pasteImage = [[NSImage alloc] initWithData:imageData];
    if (pasteImage != nil) {
        NSPasteboard *pasteBoard = [NSPasteboard generalPasteboard];
        [pasteBoard clearContents];
        [pasteBoard writeObjects:@[pasteImage]];
    }
    [self.window close];
    
}

- (void)redraw1 {
    NSPoint mousePoint = NSEvent.mouseLocation;
    CGRect screenFrame = self.window.frame;
    self.currentRect = screenFrame;
    double minArea = screenFrame.size.width * screenFrame.size.height;
    
    NSArray *windowInfoList = [HqScreenSnapshotManager.shared allWindowInfoList];
    
    for (NSDictionary *info in windowInfoList) {
        CGRect rect = [HqScreenSnapshotManager.shared windowRectWithIno:info];
        rect = [HqScreenSnapshotUtil cgWindowRectToScreenRect:rect];
        
        NSInteger layer = [HqScreenSnapshotManager.shared windowLayerWithInfo:info];
        if (layer < 0) continue;
        
        if ([HqScreenSnapshotUtil isPoint:mousePoint inRect:rect]) {
            if (layer == 0) {
                self.currentRect = rect;
                break;
            }
            else if (rect.size.width * rect.size.height < minArea) {
                self.currentRect = rect;
                minArea = rect.size.width * rect.size.height;
                break;
            }
            
        }
        
    }
    if (CGRectEqualToRect(self.lastRect, self.currentRect)) {
        return;
    }
    if (!CGRectEqualToRect(self.currentRect, CGRectZero)){
        [self setNeedsDisplay:YES];
        self.lastRect = self.currentRect;
    }
}


- (void)caputreActivityWindow {
    NSPoint mousePoint = NSEvent.mouseLocation;
    CGRect screenFrame = self.window.frame;
    self.currentRect = screenFrame;
    double minArea = screenFrame.size.width * screenFrame.size.height;
    for (NSValue *rectV in [HqScreenSnapshotManager.shared allWindowRect]) {
        CGRect rect = rectV.rectValue;
        rect = [HqScreenSnapshotUtil cgWindowRectToScreenRect:rect];
        if ([HqScreenSnapshotUtil isPoint:mousePoint inRect:rect]) {
            if (rect.size.width * rect.size.height < minArea) {
                self.currentRect = rect;
                minArea = rect.size.width * rect.size.height;
                break;
            }
        }
    }
    if (CGRectEqualToRect(self.lastRect, self.currentRect)) {
        return;
    }
    [self redraw];
}
- (void)redraw{
    
    if (CGRectEqualToRect(self.currentRect, CGRectZero)){
        return;
    }
    [self setNeedsDisplay:YES];
    self.lastRect = self.currentRect;
    CGRect toolBarRect = self.toolBar.frame;
    CGFloat y = CGRectGetMinY(self.lastRect) - 10 - CGRectGetHeight(toolBarRect);
    if (y <= 0) {
        y = 10;
    }
    CGFloat x = CGRectGetMaxX(self.lastRect) - toolBarRect.size.width;
    if (x - CGRectGetWidth(toolBarRect) <= 0) {
        x = 0;
    }
    toolBarRect.origin.y = y;
    toolBarRect.origin.x = x;
    
    self.toolBar.frame = toolBarRect;
    
}

#pragma mark - HqScreenSnapshotToolBarProtocol
- (void)cancelSnapshot:(HqScreenSnapshotToolBar *)toolBar {
    [self.window close];
}
- (void)confirmSanpshot:(HqScreenSnapshotToolBar *)toolBar {
    [self saveImageToPasteBoard];
}
@end
