//
//  ProductPresenter.h
//  RNAllPrinter
//
//  Created by Bob on 4/27/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <StarIO/SMPort.h>

@interface ProductPresenter : NSObject

    @property (nonatomic) NSString *ModelName;
    @property (nonatomic) NSString *MacAddress;
    @property (nonatomic) NSString *PortName;

- (instancetype) initWithProductInfomation:(PortInfo *)item;
- (instancetype) initWithModelName:(NSString *)modelName macAddress:(NSString *)macAddress;
@end
