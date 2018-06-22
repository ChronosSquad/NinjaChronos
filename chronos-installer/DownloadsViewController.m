//
//  DownloadsViewController.m
//  chronos-installer
//
//  Created by Sam Gardner on 6/20/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//

#import "DownloadsViewController.h"

@interface DownloadsViewController ()

@end

@implementation DownloadsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *packageInfoFolderPath = [[documentsDirectory stringByAppendingPathComponent:@"downloads"] stringByAppendingPathComponent:@"packageInfo"];
    NSURL *packageInfoFolderURL = [NSURL URLWithString:packageInfoFolderPath];
    _downloadedPackages = [[NSFileManager defaultManager]  contentsOfDirectoryAtURL:packageInfoFolderURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _downloadedPackages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    [[cell textLabel] setNumberOfLines:4];
    [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    NSString *packageInfoFilePath = [[[_downloadedPackages objectAtIndex:indexPath.row] absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    NSDictionary *packageForCell = [[NSDictionary alloc] initWithContentsOfFile:packageInfoFilePath];
    NSString * packageLabel = [NSString stringWithFormat:@"%@ \n %@ \n Author: %@ \n Version: %@", [packageForCell objectForKey:@"Name"], [packageForCell objectForKey:@"BundleID"], [packageForCell objectForKey:@"Author"], [packageForCell objectForKey:@"Version"]];
    cell.textLabel.text = packageLabel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *selectedPackage = [[[_downloadedPackages objectAtIndex:indexPath.row] absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    NSDictionary *selectedPackageInformation = [[NSDictionary alloc] initWithContentsOfFile:selectedPackage];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathToDebsFolder = [[documentsDirectory stringByAppendingPathComponent:@"downloads"] stringByAppendingPathComponent:@"packages"];
    NSString *packageFileName = [NSString stringWithFormat:@"%@-%@.deb", [selectedPackageInformation objectForKey:@"BundleID"], [selectedPackageInformation objectForKey:@"Version"]];
    NSString *pathToPackage = [pathToDebsFolder stringByAppendingPathComponent:packageFileName];
    NSString *packageName = [selectedPackageInformation objectForKey:@"Name"];
    UIAlertController *packageSelectedPopUp = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"What would you like to do with package: %@?", packageName] message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sendPackage = [UIAlertAction actionWithTitle:@"Send to watchOS" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Send to watchOS here
    }];
    UIAlertAction *deletePackage = [UIAlertAction actionWithTitle:@"Delete this package" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[NSFileManager defaultManager] removeItemAtPath:pathToPackage error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:selectedPackage error:nil];
        [self->_downloadsTableView reloadData];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [packageSelectedPopUp addAction:sendPackage];
    [packageSelectedPopUp addAction:deletePackage];
    [packageSelectedPopUp addAction:cancelAction];
    [self presentViewController:packageSelectedPopUp animated:TRUE completion:nil];
}

@end
