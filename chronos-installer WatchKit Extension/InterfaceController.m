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
        self.session = [WCSession defaultSession];
        self.session.delegate = self;
        [self.session activateSession];
    }
    NSString *watchOSVersion = [[WKInterfaceDevice currentDevice] systemVersion];
    NSArray *installedPackages = [[NSArray alloc] init];
    NSDictionary *watchInformation = @{
                                       @"Version" : watchOSVersion,
                                       @"Installed Packages" : installedPackages
                                       };
    [self.session updateApplicationContext:watchInformation error:nil];
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



