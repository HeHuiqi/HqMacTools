//
//  HqEncryptAndDecryptView.h
//  HqMacTools
//
//  Created by hbwb25942 on 2023/10/23.
//

#import <Cocoa/Cocoa.h>
#import "HqTextView.h"
#import "HqSafeToolConsts.h"

NS_ASSUME_NONNULL_BEGIN

@interface HqEncryptAndDecryptView : NSView


@property (nonatomic, assign) HqEncryptType encryptType;
@property (nonatomic, assign) HqContentType contentType;


@property (nonatomic, strong) NSTextField *infoLab;
@property (nonatomic, strong) NSTextField *keyTf;


@property (nonatomic, strong) HqTextView *inputView;
@property (nonatomic, strong) NSButton *copyInputBtn;


@property (nonatomic, strong) NSButton *encryptBtn;
@property (nonatomic, strong) NSButton *decryptBtn;
@property (nonatomic, strong) NSButton *clearBtn;
@property (nonatomic, strong) HqTextView *resultView;


@property (nonatomic, strong) NSImageView *resultImageView;

@property (nonatomic, strong) NSButton *copyOutputBtn;


- (void)clearContent;

@end

NS_ASSUME_NONNULL_END
