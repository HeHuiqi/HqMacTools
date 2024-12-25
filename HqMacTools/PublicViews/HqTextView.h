//
//  HqTextView.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/23.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface HqTextView : NSView

@property (nonatomic, strong) NSScrollView *scrollView;

@property (nonatomic, strong) NSTextView *inputTv;
@property (nonatomic,strong) NSFont *font;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, assign) NSBorderType borderType;

@end

NS_ASSUME_NONNULL_END
