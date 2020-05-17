//
//  ILocalizeReceipts.h
//  ObjectiveC SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StarIO_Extension/StarIoExt.h>
#import "PrinterSetting.h"

typedef NS_ENUM(NSInteger, LanguageIndex) {
    LanguageIndexEnglish = 0,
    LanguageIndexJapanese,
    LanguageIndexFrench,
    LanguageIndexPortuguese,
    LanguageIndexSpanish,
    LanguageIndexGerman,
    LanguageIndexRussian,
    LanguageIndexSimplifiedChinese,
    LanguageIndexTraditionalChinese,
    LanguageIndexCJKUnifiedIdeograph
};

@interface ILocalizeReceipts : NSObject

@property (nonatomic) NSString               *languageCode;
@property (nonatomic) NSString               *paperSize;
@property (nonatomic) NSString               *scalePaperSize;
@property (nonatomic) StarIoExtCharacterCode  characterCode;

+ (ILocalizeReceipts *)createLocalizeReceipts:(LanguageIndex)languageIndex paperSizeIndex:(PaperSizeIndex)paperSizeIndex;

- (void)appendTextReceiptData:(ISCBBuilder *)builder utf8:(BOOL)utf8;

- (void)appendContentReceiptData:(ISCBBuilder *)builder content:(NSString *)content utf8:(BOOL)utf8;

- (void)appendAllSizeContentReceiptData:(ISCBBuilder *)builder content:(NSString *)content utf8:(BOOL)utf8;

- (UIImage *)createRasterReceiptImage;

- (UIImage *)createScaleRasterReceiptImage;

- (UIImage *)createCouponImage;

- (void)appendTextLabelData:(ISCBBuilder *)builder utf8:(BOOL)utf8;

- (NSString *)createPasteTextLabelString;

- (void)appendPasteTextLabelData:(ISCBBuilder *)builder pasteText:(NSString *)pasteText utf8:(BOOL)utf8;

+ (UIImage *)imageWithString:(NSString *)string font:(UIFont *)font width:(CGFloat)width;

@end
