//
//  StarPrnt.m
//  RNAllPrinter
//
//  Created by Bob on 4/26/20.
//  Copyright © 2020 Facebook. All rights reserved.
//
#import "StarPrnt.h"
#import "ModelCapability.h"
#import "PrinterInfo+Builder.h"
#import "Communications/Communication.h"
#import "Functions/PrinterFunctions.h"
#import "LocalizeReceipts/ILocalizeReceipts.h"
#import "GlobalQueueManager.h"


@implementation StarPrnt

- (instancetype)init {
    _printerSettings = [[PrinterSetting alloc] init];
    return [super init];
}

- (NSString *) NativeRefresh
{
    [self NativeDisconnect];
    return [self NativeConnect];
}

- (NSString *) NativeConnect
{
    if (self.starIoExtManager != nil && [self.starIoExtManager connect] == NO) {
        return @"Fail to openPort";
    }
    self.IsConnected = YES;
    return nil;
}
- (NSString *) NativeDisconnect
{
    if (self.starIoExtManager != nil) {
        [self.starIoExtManager disconnect];
    }
    self.IsConnected = NO;
    return nil;
}
- (NSArray *) NativeDiscover:(NSString *) interfaceName
{
    NSArray *BTPortList;
    NSArray *TCPPortList;
    NSArray *USBPortList;
    NSMutableArray *arrayDiscovery = [[NSMutableArray alloc] init];
    NSError *error;
    
    if ([interfaceName isEqualToString:@"Bluetooth"] || [interfaceName isEqualToString:@"All"]) {
        BTPortList = [SMPort searchPrinter:@"BT:" :&error];
        if (error != nil) {
            @throw error.description;
        }
        [arrayDiscovery addObjectsFromArray:BTPortList];
    }
    if ([interfaceName isEqualToString:@"LAN"] || [interfaceName isEqualToString:@"All"]) {
        TCPPortList = [SMPort searchPrinter:@"TCP:" :&error];
        if (error != nil) {
            @throw error.description;
        }
        [arrayDiscovery addObjectsFromArray:TCPPortList];
    }
    if ([interfaceName isEqualToString:@"USB"] || [interfaceName isEqualToString:@"All"]) {
        USBPortList = [SMPort searchPrinter:@"USB:" :&error];
        if (error != nil) {
            @throw error.description;
        }
        [arrayDiscovery addObjectsFromArray:USBPortList];
    }
    
    return arrayDiscovery;
}
- (void) NativePrintText:(NSString *) content callback:(RCTResponseSenderBlock)callback
{
    // print
    StarIoExtEmulation emulation = self.printerSettings.emulation;
    PaperSizeIndex paperSize = self.printerSettings.selectedPaperSize;
    ILocalizeReceipts *localizeReceipts = [ILocalizeReceipts createLocalizeReceipts:0 paperSizeIndex:paperSize];
    
    NSData *buffer = nil;
    buffer = [PrinterFunctions createContentReceiptData:emulation localizeReceipts:localizeReceipts content:content utf8:YES];
    
    //    [_starIoExtManager.lock lock];
    dispatch_async(GlobalQueueManager.sharedManager.serialQueue, ^{
        [Communication sendCommands:buffer
                               port:self->_starIoExtManager.port
                  completionHandler:^(CommunicationResult *communicationResult) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(@[[Communication getCommunicationResultMessage:communicationResult]]);
                //                    [self->_starIoExtManager.lock unlock];
            });
        }];
        
    });
}
- (void) NativePrintBitmap:(UIImage *) bitmap callback:(RCTResponseSenderBlock)callback
{
    // print
    StarIoExtEmulation emulation = self.printerSettings.emulation;
    PaperSizeIndex paperSize = self.printerSettings.selectedPaperSize;
    
    NSData *buffer = nil;
    buffer = [PrinterFunctions createBitmapData:emulation bitmap:bitmap paperSize:paperSize];
    
    //    [_starIoExtManager.lock lock];
    dispatch_async(GlobalQueueManager.sharedManager.serialQueue, ^{
        [Communication sendCommands:buffer
                               port:self->_starIoExtManager.port
                  completionHandler:^(CommunicationResult *communicationResult) {
            dispatch_async(dispatch_get_main_queue(), ^{
                callback(@[[Communication getCommunicationResultMessage:communicationResult]]);
                //                    [self->_starIoExtManager.lock unlock];
            });
        }];
        
    });
}
- (NSString *) PreparePrint
{
    if (self.printerSettings.portName == nil) {
        return @"No selected printer!";
    }
    self.starIoExtManager = [[StarIoExtManager alloc] initWithType:StarIoExtManagerTypeStandard portName:self.printerSettings.portName portSettings:self.printerSettings.portSettings ioTimeoutMillis:30000];
    self.starIoExtManager.delegate = self;
    return [self NativeConnect];
}
- (NSArray *) Discover
{
    self.printers = [self NativeDiscover:@"All"];
    return self.printers;
}
//React function
- (void) FindAll:(RCTResponseSenderBlock)callback
{
    NSString *msg = nil;
    
    @try {
        if (self.starIoExtManager != nil && self.starIoExtManager.port != nil) {
            [self NativeDisconnect];
        }
        [self Discover];
    } @catch (NSError *err) {
        callback(@[err.description]);
        return;
    }
    if (msg != nil) {
        return callback(@[msg]);
    }
    
    NSMutableArray *arrayPorts = [[NSMutableArray alloc] init];
    for (PortInfo *discovery in self.printers) {
        NSMutableDictionary *port = [[NSMutableDictionary alloc] init];
        [port setValue:discovery.portName forKey:@"Name"];
        [port setValue:discovery.macAddress forKey:@"MacAddress"];
        [port setValue:discovery.modelName forKey:@"ModelName"];
        [arrayPorts addObject:port];
    }
    
    callback(@[arrayPorts]);
}

- (void) SelectPrinter:(NSString *)name callback:(RCTResponseSenderBlock)callback
{
    if (self.printers == nil || self.printers.count < 1) {
        [self Discover];
    }
    for (PortInfo *printer in self.printers) {
        if (![printer.portName isEqualToString: name]) {
            continue;
        }
        NSString *portName   = printer.portName;
        NSString *modelName  = printer.modelName;
        NSString *macAddress = printer.macAddress;
        
        ModelIndex modelIndex = [ModelCapability modelIndexAtModelName:printer.modelName];
        
        NSString *portSettings = [ModelCapability portSettingsAtModelIndex:modelIndex];
        StarIoExtEmulation emulation    = [ModelCapability emulationAtModelIndex   :modelIndex];
        ModelIndex selectedModelIndex = modelIndex;
        PaperSizeIndex paperSizeIndex;
        
        switch (emulation) {
            case StarIoExtEmulationStarDotImpact:
                paperSizeIndex = PaperSizeIndexDotImpactThreeInch;
                break;
            case StarIoExtEmulationEscPos:
                paperSizeIndex = PaperSizeIndexEscPosThreeInch;
                break;
            default:
                paperSizeIndex = PaperSizeIndexThreeInch;
                break;
        }
        
        self.printerSettings = [[PrinterSetting alloc] initWithPortName:portName portSettings:portSettings modelName:modelName macAddress:macAddress emulation:emulation cashDrawerOpenActiveHigh:YES allReceiptsSettings:0x00000001 selectedPaperSize:paperSizeIndex selectedModelIndex:selectedModelIndex];
        callback(@[@""]);
        return;
    }
    
    callback(@[[NSString stringWithFormat:@"Cannot to select %@", name]]);
}

- (void) PrintText:(NSString *)content callback:(RCTResponseSenderBlock)callback
{
    @try {
        if (self.starIoExtManager == nil || self.starIoExtManager.port == nil) {
            NSString *msg = [self PreparePrint];
            if (msg != nil) {
                self.starIoExtManager = nil;
                callback(@[msg]);
                return;
            }
        }
        
        [self NativePrintText:content callback:callback];
    } @catch (NSError *err) {
        callback(@[err.description]);
    }
}

- (void) PrintEncodedImage:(NSString *)encodedImage callback:(RCTResponseSenderBlock)callback
{
    @try {
        if (self.starIoExtManager == nil || self.starIoExtManager.port == nil) {
            NSString *msg = [self PreparePrint];
            if (msg != nil) {
                callback(@[msg]);
                return;
            }
        }
        NSData *data = [[NSData alloc] initWithBase64EncodedString:encodedImage options:NSDataBase64DecodingIgnoreUnknownCharacters];
        [self NativePrintBitmap:[UIImage imageWithData:data] callback:callback];
    } @catch (NSError *err) {
        callback(@[err.description]);
    }
}

- (void) Disconnect:(RCTResponseSenderBlock)callback
{
    NSString *msg = [self NativeDisconnect];
    callback(@[msg.length > 0 ? msg : @""]);
}


//Star Delegate
- (void)didPrinterImpossible:(StarIoExtManager *)manager {
    NSLog(@"%s Printer Impossible.", __PRETTY_FUNCTION__);
}

- (void)didPrinterOnline:(StarIoExtManager *)manager {
    NSLog(@"%s Printer Online.", __PRETTY_FUNCTION__);
}

- (void)didPrinterOffline:(StarIoExtManager *)manager {
    NSLog(@"%s Printer Offline.", __PRETTY_FUNCTION__);
}

- (void)didPrinterPaperReady:(StarIoExtManager *)manager {
    NSLog(@"%s Printer Paper Ready.", __PRETTY_FUNCTION__);
}

- (void)didPrinterPaperNearEmpty:(StarIoExtManager *)manager {
    NSLog(@"%s Printer Paper Near Empty.", __PRETTY_FUNCTION__);
}

- (void)didPrinterPaperEmpty:(StarIoExtManager *)manager {
    NSLog(@"%s Printer Paper Empty.", __PRETTY_FUNCTION__);
}

- (void)didPrinterCoverOpen:(StarIoExtManager *)manager {
    NSLog(@"%s Printer Cover Open.", __PRETTY_FUNCTION__);
}

- (void)didPrinterCoverClose:(StarIoExtManager *)manager {
    NSLog(@"%s Printer Cover Close.", __PRETTY_FUNCTION__);
}

- (void)didAccessoryConnectSuccess:(StarIoExtManager *)manager {
    NSLog(@"%s Accessory Connect Success.", __PRETTY_FUNCTION__);
}

- (void)didAccessoryConnectFailure:(StarIoExtManager *)manager {
    NSLog(@"%s Accessory Connect Failure.", __PRETTY_FUNCTION__);
}

- (void)didAccessoryDisconnect:(StarIoExtManager *)manager {
    NSLog(@"%s Accessory Disconnect.", __PRETTY_FUNCTION__);
}

- (void)didStatusUpdate:(StarIoExtManager *)manager status:(NSString *)status {
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, status);
}
@end
