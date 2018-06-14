//
//  SourceViewController.m
//  chronos-installer
//
//  Created by Sam Gardner on 6/5/18.
//  Copyright © 2018 Chronos Development. All rights reserved.
//

#import "SourcesTableViewController.h"
#import "SourceViewController.h"

@interface SourceViewController ()

@end

@implementation SourceViewController
@synthesize selectedSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *sourceplistFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-packages.plist", [selectedSource stringByReplacingOccurrencesOfString:@"/" withString:@""]]];
    NSArray *packagesFileContents = [NSMutableArray arrayWithContentsOfFile:sourceplistFilePath];
    _packages = [packagesFileContents objectAtIndex:1];
    if (_packages == NULL) {
        UIAlertController *invalidRepoAlert = [UIAlertController alertControllerWithTitle:@"Invalid repo" message:@"Unable to find packages in this repository. \n \n Try refreshing your sources from the home screen, and make sure you provide a link to a valid packages file" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *deleteRepo = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
        [invalidRepoAlert addAction:deleteRepo];
        [self presentViewController:invalidRepoAlert animated:TRUE completion:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _packages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    [[cell textLabel] setNumberOfLines:4];
    [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *packageForCell = _packages[indexPath.row];
    NSString * repoAddressLabel = [NSString stringWithFormat:@"%@ \n %@ \n Author: %@ \n Version: %@", [packageForCell objectForKey:@"Name"], [packageForCell objectForKey:@"BundleID"], [packageForCell objectForKey:@"Author"], [packageForCell objectForKey:@"Version"]];
    cell.textLabel.text = repoAddressLabel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _selectedPackage = [_packages objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"goToPackageViewController" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"goToPackageViewController"]){
        SourceViewController *destViewController = [segue destinationViewController];
        destViewController.selectedPackage = _selectedPackage;
        destViewController.selectedSource = selectedSource;
    }
}

@end
