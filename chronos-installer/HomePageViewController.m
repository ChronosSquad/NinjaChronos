//
//  ViewController.m
//  chronos-installer
//
//  Created by Sam Gardner on 5/11/18.
//  Copyright © 2018 Chronos Development. All rights reserved.
//

#import "HomePageViewController.h"
#import <spawn.h>
#include <sys/sysctl.h>
extern char **environ;

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
    // Do any additional setup after loading the view, typically from a nib.
    self.refreshProgressBar.progress = 0;
    [_refreshProgressBar setHidden:TRUE];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *sourcesplistFilePath = [documentsDirectory stringByAppendingPathComponent:@"sources.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:sourcesplistFilePath]) {
    } else {
        [_refreshProgressLabel setHidden:TRUE];
        [_refreshProgressLabel setEnabled:FALSE];
    }
}


- (IBAction)infoButton:(id)sender {
    UIAlertController *teamInfo = [UIAlertController alertControllerWithTitle:@"Chronos Installer" message:@"Created by EthanR, FoxletFox, Lepidus, PsychoTea, and Samg_is_a_Ninja" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
    [teamInfo addAction:okAction];
    [self presentViewController:teamInfo animated:YES completion:nil];
}
- (IBAction)refreshSourcesButton:(id)sender {
    [self refreshSources];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.navigationController setNavigationBarHidden:FALSE animated:TRUE];
}
-(void)refreshSources{
    [_refreshProgressLabel setEnabled:FALSE];
    [_refreshProgressLabel setTintColor:[UIColor darkGrayColor]];
    [_refreshProgressLabel setTitle:@"Reading sources" forState:UIControlStateNormal];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *sourcesplistFilePath = [documentsDirectory stringByAppendingPathComponent:@"sources.plist"];
    _sourceList = [NSArray arrayWithContentsOfFile:sourcesplistFilePath];
    _sourceBeingUpdated = 0;
    [self downloadPackagesFile];
}
- (void) URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float totalSize = (totalBytesExpectedToWrite/1024)/1024.f;
    float writtenSize = (totalBytesWritten/1024)/1024.f;
    float downloadProgress = (writtenSize/totalSize);
    self.refreshProgressBar.progress = downloadProgress;
}
-(void)downloadPackagesFile{
    [_refreshProgressLabel setTitle:[NSString stringWithFormat:@"Downloading package info from %@", [_sourceList objectAtIndex:_sourceBeingUpdated]] forState:UIControlStateNormal];
    NSURL *sourceURL = [NSURL URLWithString:[_sourceList objectAtIndex:_sourceBeingUpdated]];
    NSURLSessionDownloadTask *task = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]] downloadTaskWithURL:sourceURL];
    [_refreshProgressBar setHidden:FALSE];
    [task resume];
}
- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    [_refreshProgressLabel setTitle:[NSString stringWithFormat:@"Updating source %@", [_sourceList objectAtIndex:_sourceBeingUpdated]] forState:UIControlStateNormal];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *sourcePackagesFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-packages.plist", [[_sourceList objectAtIndex:_sourceBeingUpdated] stringByReplacingOccurrencesOfString:@"/" withString:@""]]];
    [[NSFileManager defaultManager] moveItemAtPath:[location path] toPath:sourcePackagesFilePath error:nil];
    if (_sourceBeingUpdated == ([_sourceList count] - 1) ) {
        [_refreshProgressLabel setTitle:@"Refresh Sources" forState:UIControlStateNormal];
        [_refreshProgressLabel setEnabled:TRUE];
        [_refreshProgressLabel setTintColor:[UIColor colorWithRed:0/255.0 green:117.0/255.0 blue:251.0/255.0 alpha:1.0]];
        self.refreshProgressBar.progress = 0;
        [_refreshProgressBar setHidden:TRUE];
    }
    else {
        _sourceBeingUpdated = _sourceBeingUpdated + 1;
        [self downloadPackagesFile];
    }

}
@end
