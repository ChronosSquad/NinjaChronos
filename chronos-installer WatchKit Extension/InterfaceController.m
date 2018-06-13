//
//  InterfaceController.m
//  chronos-installer WatchKit Extension
//
//  Created by Sam Gardner on 5/11/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//

#import "InterfaceController.h"


@interface InterfaceController ()

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
        NSDictionary *transfer = @{@"Version" : [[WKInterfaceDevice currentDevice] systemVersion]};
        NSError *error;
        [[WCSession defaultSession] updateApplicationContext:transfer error:&error];
        NSLog(@"%@ Sent by watchOS", transfer);
    }
    
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



