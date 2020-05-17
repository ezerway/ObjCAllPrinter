//
//  AbstractRNAllPrinter.m
//  RNAllPrinter
//
//  Created by Bob on 4/26/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
#import "IRNAllPrinter.h"
#import <Foundation/Foundation.h>

@implementation IRNAllPrinter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _IsConnected = NO;
        _printers = [[NSMutableArray alloc] init];
    }
    return self;
}

//Internal Functions
- (NSString *) Name {
    return @"IRNAllPrinter";
}

- (NSString *) NativeRefresh
{
    return nil;
}
- (NSString *) NativeConnect
{
    return nil;
}
- (NSString *) NativeDisconnect
{
    return nil;
}
- (NSArray *) NativeDiscover:(NSString *) interfaceName
{
    return nil;
}
- (void) NativePrintText:(NSString *) content callback:(RCTResponseSenderBlock)callback
{
    
}
- (void) NativePrintBitmap:(UIImage *) bitmap callback:(RCTResponseSenderBlock)callback
{
    
}
- (NSString *) PreparePrint
{
    return nil;
}
- (NSArray *) Discover
{
    return nil;
}
//React function
- (void) FindAll:(RCTResponseSenderBlock)callback
{
    callback(@[[NSString stringWithFormat: @"FindAll"]]);
}

- (void) SelectPrinter:(NSString *)name callback:(RCTResponseSenderBlock)callback
{
    callback(@[[NSString stringWithFormat: @"SelectPrinter: %@", name]]);
}

- (void) PrintText:(NSString *)content callback:(RCTResponseSenderBlock)callback
{
    callback(@[[NSString stringWithFormat: @"PrintText: %@", content]]);
}

- (void) PrintEncodedImage:(NSString *)encodedImage callback:(RCTResponseSenderBlock)callback
{
    callback(@[[NSString stringWithFormat: @"PrintEncodedImage: %@", encodedImage]]);
}

- (void) Disconnect:(RCTResponseSenderBlock)callback
{
    callback(@[[NSString stringWithFormat: @"Disconnect"]]);
}

@end
