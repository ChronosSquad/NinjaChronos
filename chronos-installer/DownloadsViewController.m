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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
