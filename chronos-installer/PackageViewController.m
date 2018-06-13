//
//  PackageViewController.m
//  chronos-installer
//
//  Created by Sam Gardner on 6/12/18.
//  Copyright © 2018 Chronos Development. All rights reserved.
//

#import "PackageViewController.h"
#import "SourceViewController.h"

@interface PackageViewController ()

@end

@implementation PackageViewController
@synthesize selectedSource;
@synthesize selectedPackage;

- (void)viewDidLoad {
    [super viewDidLoad];
    _packageBundleID = [selectedPackage objectForKey:@"BundleID"];
    [[self packageBundleIDLabel] setText:_packageBundleID];
    if ([selectedPackage objectForKey:@"Name"] != nil) {
        _packageName = [selectedPackage objectForKey:@"Name"];
        [[self packageNameLabel] setText:_packageName];
    } else {
        [[self packageNameLabel] setText:_packageBundleID];
        [[self packageBundleIDLabel] setHidden:TRUE];
    }
    if ([selectedPackage objectForKey:@"Icon"] != nil) {
         _packageIconLink = [NSURL URLWithString:[selectedPackage objectForKey:@"Icon"]];
        NSData *data = [NSData dataWithContentsOfURL:_packageIconLink];
        _packageIconImage = [[UIImage alloc] initWithData:data];
        [_packageIconView setImage:_packageIconImage];
    } else {
        [[self packageIconView] setHidden:TRUE];
    }
    if ([selectedPackage objectForKey:@"Author"] != nil) {
        _packageAuthor = [selectedPackage objectForKey:@"Author"];
        [[self packageAuthorLabel] setText:_packageAuthor];
    } else {
        //Hide repo name and set author label to name of repo
    }
    if ([selectedPackage objectForKey:@"Dependencies"] != nil) {
        _packageDependencies = [selectedPackage objectForKey:@"Dependencies"];
        [[self packageDependsLabel] setText:[NSString stringWithFormat:@"Depends: %@", [_packageDependencies componentsJoinedByString:@", "]]];
    } else {
        [[self packageDependsLabel] setText:@"This package does not depend on any other packages"];
    }
    _packageDownloadLink = [NSURL URLWithString:[selectedPackage objectForKey:@"Download Link"]];
    _packageVersion = [selectedPackage objectForKey:@"Version"];
    _packageWatchOSCompatibility = [selectedPackage objectForKey:@"compatible-watchos"];
    if ([selectedPackage objectForKey:@"Description"]) {
        _packageDescLink = [NSURL URLWithString:[selectedPackage objectForKey:@"Description"]];
        NSLog(@"%@", _packageDescLink);
        NSURLSessionDataTask *getPackageDescription = [[NSURLSession sharedSession] dataTaskWithURL:_packageDescLink
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                self->_packageDescription = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                self.packageDescLabel.text = self->_packageDescription;
            }];
        [getPackageDescription resume];
    } else {
        [[self packageDescLabel] setText:@"Chronos couldn't find a description for this package."];
    }
    
}


@end
