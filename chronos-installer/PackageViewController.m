//
//  PackageViewController.m
//  chronos-installer
//
//  Created by Sam Gardner on 6/12/18.
//  Copyright © 2018 Chronos Development. All rights reserved.
//

#import "PackageViewController.h"
#import "SourceViewController.h"
#import "DownloadViewController.h"

@interface PackageViewController ()

@end

@implementation PackageViewController
@synthesize selectedSource;
@synthesize selectedPackage;
@synthesize selectedSourceName;

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([WCSession isSupported]) {
        WCSession *session = [WCSession defaultSession];
        session.delegate = self;
        [session activateSession];
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    UIAlertController *invalidPackage = [UIAlertController alertControllerWithTitle:@"Invalid Package" message:@"Repo does not have the required information for this package" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^ (UIAlertAction * action){
        [self performSegueWithIdentifier:@"goToSourceViewController" sender:self];
    }];
    [invalidPackage addAction:cancelButton];
    if ([selectedPackage objectForKey:@"BundleID"] != nil) {
        _packageBundleID = [selectedPackage objectForKey:@"BundleID"];
    } else {
        [self presentViewController:invalidPackage animated:TRUE completion:nil];
    }
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
        [[self packageRepoLabel] setText:selectedSourceName];
    } else {
        [[self packageAuthorLabel] setText:selectedSourceName];
        [[self packageRepoLabel] setHidden:TRUE];
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
        NSURLSessionDataTask *getPackageDescription = [[NSURLSession sharedSession] dataTaskWithURL:_packageDescLink
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                if (error == nil) {
                self->_packageDescription = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                } else {
                    self->_packageDescription = [error localizedDescription];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.packageDescLabel.text = self->_packageDescription;
                });
            }];
        [getPackageDescription resume];
    } else {
        [[self packageDescLabel] setText:@"Chronos Installer couldn't find a description for this package."];
    }
    NSDictionary *watchInfo = [NSDictionary dictionaryWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"watchInfo.plist"]];
    NSString *pairedWatchVersion = [watchInfo objectForKey:@"Version"];
    if (pairedWatchVersion == NULL) {
        [[self watchOSCompatibilityLabel] setText:@"Please open the Chronos app on your apple watch to check compatibility."];
    } else {
        BOOL isCompatible = [_packageWatchOSCompatibility containsObject:pairedWatchVersion];
        if (isCompatible == TRUE) {
        [[self watchOSCompatibilityLabel] setText:[NSString stringWithFormat:@"Compatible with your watchOS version (%@)", pairedWatchVersion]];
        } else {
            [[self watchOSCompatibilityLabel] setText:@"Not compatible with your watchOS version"];
            [[self watchOSCompatibilityLabel] setTextColor:[UIColor redColor]];
            [[self downloadButtonOutlet] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}
- (IBAction)downloadButton:(id)sender {
    if (_isCompatible == TRUE) {
        [self performSegueWithIdentifier:@"goToDownloadViewController" sender:self];
    } else {
        UIAlertController *notCompatibleWarning = [UIAlertController alertControllerWithTitle:@"This package may not be compatible with your watchOS version" message:@"The developer of this package has not marked this package as compatible with your watchOS version. Installing this package may lead to system instability or may render your device inoperable." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelDownloadAction = [UIAlertAction actionWithTitle:@"Cancel download" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *downloadIncompatiblePackageAction = [UIAlertAction actionWithTitle:@"Download anyways" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self performSegueWithIdentifier:@"goToDownloadViewController" sender:self];
        }];
        [notCompatibleWarning addAction:cancelDownloadAction];
        [notCompatibleWarning addAction:downloadIncompatiblePackageAction];
        [self presentViewController:notCompatibleWarning animated:TRUE completion:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goToDownloadViewController"]) {
        DownloadViewController *destViewController = [segue destinationViewController];
        destViewController.downloadLink = _packageDownloadLink;
        destViewController.bundleID = _packageBundleID;
    }
}

- (void) session:(nonnull WCSession *)session didReceiveApplicationContext:(nonnull NSDictionary<NSString *,id> *)applicationContext {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    [[NSFileManager defaultManager] removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:@"watchInfo.plist"] error:nil];
    [applicationContext writeToFile:[documentsDirectory stringByAppendingPathComponent:@"watchInfo.plist"] atomically:TRUE];
    NSDictionary *watchInfo = [NSDictionary dictionaryWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:@"watchInfo.plist"]];
    NSString *pairedWatchVersion = [watchInfo objectForKey:@"Version"];
    if (pairedWatchVersion == NULL) {
        [[self watchOSCompatibilityLabel] setText:@"Please open the Chronos app on your apple watch to check compatibility."];
    } else {
        _isCompatible = [_packageWatchOSCompatibility containsObject:pairedWatchVersion];
        if (_isCompatible == TRUE) {
            [[self watchOSCompatibilityLabel] setText:[NSString stringWithFormat:@"Compatible with your watchOS version (%@)", pairedWatchVersion]];
        } else {
            [[self watchOSCompatibilityLabel] setText:@"Not compatible with your watchOS version"];
            [[self watchOSCompatibilityLabel] setTextColor:[UIColor redColor]];
            [[self downloadButtonOutlet] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
    }
}

@end
