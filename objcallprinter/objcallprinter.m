//
//  objcallprinter.m
//  objcallprinter
//
//  Created by Bob on 5/10/20.
//  Copyright © 2020 Ezerway. All rights reserved.
//

#import "objcallprinter.h"
#import "StarPrnt.h"

@implementation objcallprinter

- (instancetype)init
{
    self = [super init];
    if (self) {
        StarPrnt *starPrnt = [[StarPrnt alloc] init];
        _modules = [NSDictionary dictionaryWithObject: starPrnt forKey:starPrnt.Name];
    }
    return self;
}

- (NSDictionary *) GetPrintModules:(NSString *) type {
    IRNAllPrinter *module = [_modules valueForKey:type];
    if (module != nil) { 
        return @{ type: module };
    }
    
    return _modules;
}

- (NSDictionary *) GetPrintModules {
    return _modules;
}

- (void) FindAll:(NSString *) type
        callback:(RCTResponseSenderBlock)callback
{
    NSDictionary *dict = [self GetPrintModules:type];
    for (IRNAllPrinter *module in dict.allValues) {
        [module FindAll:callback];
    }
}

- (void) SelectPrinter:(NSString *)type
                  name:(NSString *)name
              callback:(RCTResponseSenderBlock)callback
{
    NSDictionary *dict = [self GetPrintModules:type];
    for (IRNAllPrinter *module in dict.allValues) {
        [module SelectPrinter:name callback:callback];
    }
}

- (void) PrintText:(NSString *)type
           content:(NSString *)content
          callback:(RCTResponseSenderBlock)callback
{
    NSDictionary *dict = [self GetPrintModules:type];
    for (IRNAllPrinter *module in dict.allValues) {
        [module PrintText:content callback:callback];
    }
}

- (void) PrintEncodedImage:(NSString *)type
                   content:(NSString *)basedImage
                  callback:(RCTResponseSenderBlock)callback
{
    NSDictionary *dict = [self GetPrintModules:type];
    for (IRNAllPrinter *module in dict.allValues) {
        [module PrintEncodedImage:basedImage callback:callback];
    }
}

- (void) Disconnect:(NSString *)type
           callback:(RCTResponseSenderBlock)callback
{
    NSDictionary *dict = [self GetPrintModules:type];
    for (IRNAllPrinter *module in dict.allValues) {
        [module Disconnect:callback];
    }
}

@end
