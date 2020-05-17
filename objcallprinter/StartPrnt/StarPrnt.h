//
//  StarPrnt.h
//  RNAllPrinter
//
//  Created by Bob on 4/27/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
#import "IRNAllPrinter.h"
#import <StarIO/SMPort.h>
#import <StarIO_Extension/StarIoExtManager.h>
#import "PrinterSetting.h"

@interface StarPrnt : IRNAllPrinter<StarIoExtManagerDelegate>

    @property (nonatomic) StarIoExtManager *starIoExtManager;
    @property (nonatomic) PrinterSetting *printerSettings;

@end
