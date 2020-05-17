//
//  objcallprinter.h
//  objcallprinter
//
//  Created by Bob on 5/10/20.
//  Copyright © 2020 Ezerway. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRNAllPrinter.h"

@interface objcallprinter : NSObject

@property (nonatomic) NSDictionary *modules;

- (void) FindAll:(NSString *) type
        callback:(RCTResponseSenderBlock)callback;
- (void) SelectPrinter:(NSString *)type
                  name:(NSString *)name
              callback:(RCTResponseSenderBlock)callback;
- (void) PrintText:(NSString *)type
           content:(NSString *)content
          callback:(RCTResponseSenderBlock)callback;
- (void) PrintEncodedImage:(NSString *)type
                   content:(NSString *)basedImage callback:(RCTResponseSenderBlock)callback;
- (void) Disconnect:(NSString *)type
           callback:(RCTResponseSenderBlock)callback;
@end
