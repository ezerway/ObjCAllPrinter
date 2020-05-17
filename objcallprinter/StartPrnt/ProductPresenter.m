//
//  ProductPresenter.m
//  RNAllPrinter
//
//  Created by Bob on 4/27/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "ProductPresenter.h"

@implementation ProductPresenter

- (instancetype)initWithProductInfomation:(PortInfo *)item {
    self = [super init];
    _MacAddress = item.macAddress;
    _ModelName = item.modelName;
    _PortName = item.portName;
    return self;
}

- (instancetype) initWithModelName:(NSString *)modelName macAddress:(NSString *)macAddress {
    self = [super init];
    _MacAddress = macAddress;
    if ([modelName hasPrefix:@"BT:"]) {
        _ModelName = [modelName substringFromIndex:3];
        _PortName = [NSString stringWithFormat:@"%@%@", @"BT:", macAddress];
    } else {
        _ModelName = modelName;
        _PortName = _ModelName;
    }
    return self;
}

@end
