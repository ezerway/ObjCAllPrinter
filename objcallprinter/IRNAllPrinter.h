
//
//  IRNAllPrinter.h
//  RNAllPrinter
//
//  Created by Bob on 4/26/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * The type of a block that is capable of sending a response to a bridged
 * operation. Use this for returning callback methods to JS.
 */
typedef void (^RCTResponseSenderBlock)(NSArray *response);

@interface IRNAllPrinter : NSObject

@property (nonatomic) BOOL IsConnected;
@property (nonatomic) NSArray *printers;

//Internal Functions
- (NSString *) Name;
- (NSString *) NativeRefresh;
- (NSString *) NativeConnect;
- (NSString *) NativeDisconnect;
- (NSArray *) NativeDiscover:(NSString *) interfaceName;
- (void) NativePrintText:(NSString *) content callback:(RCTResponseSenderBlock)callback;
- (void) NativePrintBitmap:(UIImage *) bitmap callback:(RCTResponseSenderBlock)callback;

- (NSString *) PreparePrint;
- (NSArray *) Discover;
//React function
- (void) FindAll:(RCTResponseSenderBlock)callback;
- (void) SelectPrinter:(NSString *)name callback:(RCTResponseSenderBlock)callback;
- (void) PrintText:(NSString *)content callback:(RCTResponseSenderBlock)callback;
- (void) PrintEncodedImage:(NSString *)encodedImage callback:(RCTResponseSenderBlock)callback;
- (void) Disconnect:(RCTResponseSenderBlock)callback;

@end
