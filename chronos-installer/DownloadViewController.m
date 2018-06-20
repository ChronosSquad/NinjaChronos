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

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLSessionDownloadTask *downloadPackage = [[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]] downloadTaskWithURL:downloadLink];
    [downloadPackage resume];
    
}

- (void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *debsDirectory = [documentsDirectory stringByAppendingPathComponent:@"downloads"];
    BOOL isDirectory;
    if ([[NSFileManager defaultManager] fileExistsAtPath:debsDirectory isDirectory: &isDirectory]) {
        if (isDirectory) {} else {
            [[NSFileManager defaultManager] removeItemAtPath:debsDirectory error:nil];
            [[NSFileManager defaultManager] createDirectoryAtPath:debsDirectory withIntermediateDirectories:FALSE attributes:nil error:nil];
        }
    } else {
        [[NSFileManager defaultManager] createDirectoryAtPath:debsDirectory withIntermediateDirectories:FALSE attributes:nil error:nil];
    }
    NSError *error;
    [[NSFileManager defaultManager] moveItemAtPath:[location path] toPath:[debsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.deb", bundleID]] error:&error];
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
