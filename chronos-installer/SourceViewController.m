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
    _packages = [NSMutableArray arrayWithContentsOfFile:sourceplistFilePath];
    if (_packages == NULL) {
        UIAlertController *invalidRepoAlert = [UIAlertController alertControllerWithTitle:@"Invalid repo" message:@"Unable to find packages in this repo, make sure you provide a link to a valid packages file" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *deleteRepo = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
        [invalidRepoAlert addAction:deleteRepo];
        [self presentViewController:invalidRepoAlert animated:TRUE completion:nil];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
