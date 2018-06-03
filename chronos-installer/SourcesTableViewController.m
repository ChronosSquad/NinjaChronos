//
//  SourcesTableViewController.m
//  chronos-installer
//
//  Created by Sam Gardner on 5/26/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//

#import "SourcesTableViewController.h"

@interface SourcesTableViewController (){
    UIAlertController *confirmAddNewRepoAlert;
}

@end

@implementation SourcesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:FALSE animated:TRUE];
    [self.navigationItem setTitle:@"Sources"];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    _sourcesplistFilePath = [documentsDirectory stringByAppendingPathComponent:@"sources.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:_sourcesplistFilePath]) {
        _sources = [NSMutableArray arrayWithContentsOfFile:_sourcesplistFilePath];
        NSAssert(_sources, @"arrayWithContentsOfFile failed");
    } else {
        UIAlertController *newSourcesFile = [UIAlertController alertControllerWithTitle:@"File sources.plist not found" message:@"A new one has been created" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [newSourcesFile addAction:okAction];
        [self presentViewController:newSourcesFile animated:YES completion:nil];
        _sources = [[NSMutableArray alloc] initWithObjects:@"https://raw.githubusercontent.com/Samgisaninja/sample-chronos-repo/master/packages.plist", nil];
        BOOL success = [_sources writeToFile:_sourcesplistFilePath atomically:YES];
        NSAssert(success, @"writeToFile failed");
    }
    _changesMade = FALSE;
    

}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
    if (_changesMade == TRUE) {
        BOOL success = [_sources writeToFile:_sourcesplistFilePath atomically:YES];
        NSAssert(success, @"writeToFile failed");
        confirmAddNewRepoAlert = [UIAlertController alertControllerWithTitle:@"Would you like to refresh sources now?" message:@"You have made changes to your source list, would you like to refresh your sources now?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dontRefreshNow = [UIAlertAction actionWithTitle:@"Not now" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *refreshNow = [UIAlertAction actionWithTitle:@"Refresh" style:UIAlertActionStyleDefault handler:nil];
        [confirmAddNewRepoAlert addAction:dontRefreshNow];
        [confirmAddNewRepoAlert addAction:refreshNow];
        [self presentViewController:confirmAddNewRepoAlert animated:TRUE completion:nil];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sources.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"reuseIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    // Configure the cell...
    NSString * repoAddressLabel = [NSString stringWithFormat:@"%@", _sources[indexPath.row]];
    cell.textLabel.text = repoAddressLabel;
    return cell;
}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [_sourcesTableView setEditing:editing animated:animated];
    UIBarButtonItem * addEditingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewRepo)];
    UIBarButtonItem *doneEditingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(confirmNewRepo)];
    self.navigationItem.rightBarButtonItem = addEditingButton;
    self.navigationItem.leftBarButtonItem = doneEditingButton;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_sources removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        _changesMade = TRUE;
    }
}

-(void)addNewRepo{
    UIAlertController *getRepoAddress = [UIAlertController alertControllerWithTitle:@"Enter URL of packages.plist file" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [getRepoAddress addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = @"https://";
        textField.keyboardType = UIKeyboardTypeURL;
    }];
    UIAlertAction *addRepoAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self->_sources insertObject:getRepoAddress.textFields.firstObject.text atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.sourcesTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        self->_changesMade = TRUE;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [getRepoAddress addAction:addRepoAction];
    [getRepoAddress addAction:cancelAction];
    [self presentViewController:getRepoAddress animated:TRUE completion:nil];
}

-(void)confirmNewRepo {
    [super setEditing:FALSE animated:TRUE];
    self.navigationItem.leftBarButtonItem = nil;
}


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

@end
