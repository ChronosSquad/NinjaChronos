//
//  DownloadViewController.m
//  chronos-installer
//
//  Created by Sam Gardner on 6/18/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//

#import "DownloadViewController.h"

@interface DownloadViewController ()

@end

@implementation DownloadViewController
@synthesize downloadLink;
@synthesize bundleID;
@synthesize version;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLSessionDownloadTask *downloadPackage = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]] downloadTaskWithURL:downloadLink];
    [downloadPackage resume];
    [[self navigationController] setNavigationBarHidden:TRUE animated:TRUE];
    
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *downloadsDirectory = [documentsDirectory stringByAppendingPathComponent:@"downloads"];
    NSString *debsDirectory = [downloadsDirectory stringByAppendingPathComponent:@"packages"];
    NSString *pathToDownload = [debsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.deb", bundleID, version]];
    [[NSFileManager defaultManager] moveItemAtPath:[location path] toPath:pathToDownload error:nil];
    [[self progressLabel] setText:@"Download complete!"];
    UIAlertController *finishedDownloadingAlert = [UIAlertController alertControllerWithTitle:@"Finished downloading package" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *goToHomePageViewControllerAction = [UIAlertAction actionWithTitle:@"Back to home page" style:UIAlertActionStyleCancel handler:^ (UIAlertAction * _Nonnull action) {
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }];
    UIAlertAction *goToDownloadsViewControllerAction = [UIAlertAction actionWithTitle:@"Manage downloads" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *deleteDownloadAction = [UIAlertAction actionWithTitle:@"Delete this package" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action){
        [[NSFileManager defaultManager] removeItemAtPath:pathToDownload error:nil];
    }];
    [finishedDownloadingAlert addAction:goToHomePageViewControllerAction];
    [finishedDownloadingAlert addAction:goToDownloadsViewControllerAction];
    [finishedDownloadingAlert addAction:deleteDownloadAction];
    [self presentViewController:finishedDownloadingAlert animated:TRUE completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void) URLSession:(NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float totalSize = (totalBytesExpectedToWrite/1024)/1024.f;
    float writtenSize = (totalBytesWritten/1024)/1024.f;
    float downloadProgress = (writtenSize/totalSize);
    self.progressBar.progress = downloadProgress;
    float downloadProgressPercent = downloadProgress * 100;
    self.progressLabel.text = [NSString stringWithFormat:@"Downloading... %.f%%", downloadProgressPercent];
}

@end
