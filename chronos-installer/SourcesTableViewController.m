//
//  SourcesTableViewController.m
//  chronos-installer
//
//  Created by Sam Gardner on 5/26/18.
//  Copyright © 2018 Chronos Development. All rights reserved.
//

#import "SourcesTableViewController.h"
#import "HomePageViewController.h"
#import "SourceViewController.h"

@interface SourcesTableViewController (){
    UIAlertController *confirmAddNewRepoAlert;
}

@end

@implementation SourcesTableViewController
@synthesize selectedSource;
@synthesize selectedSourceName;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:FALSE animated:TRUE];
    [self.navigationItem setTitle:@"Sources"];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentsDirectory = [paths objectAtIndex:0];
    _sourcesplistFilePath = [_documentsDirectory stringByAppendingPathComponent:@"sources.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:_sourcesplistFilePath]) {
        _sources = [NSMutableArray arrayWithContentsOfFile:_sourcesplistFilePath];
        NSAssert(_sources, @"arrayWithContentsOfFile failed");
    } else {
        UIAlertController *newSourcesFile = [UIAlertController alertControllerWithTitle:@"File sources.plist not found" message:@"A new one has been created, please return to the home screen and refresh sources." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [newSourcesFile addAction:okAction];
        [self presentViewController:newSourcesFile animated:YES completion:nil];
        _sources = [[NSMutableArray alloc] initWithObjects:@"https://raw.githubusercontent.com/Samgisaninja/sample-chronos-repo/master/packages.plist", nil];
        BOOL success = [_sources writeToFile:_sourcesplistFilePath atomically:TRUE];
        NSAssert(success, @"writeToFile failed");
    }
    _changesMade = FALSE;
}

-(void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound)
    {
        [self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
        [self.navigationController popViewControllerAnimated:NO];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedSource = [_sources objectAtIndex:indexPath.row];
    NSDictionary *sourceInformation = [[NSArray arrayWithContentsOfFile:_sourcePackagesFilePath] objectAtIndex:0];
     selectedSourceName = [sourceInformation objectForKey:@"RepoName"];
    [self performSegueWithIdentifier:@"goToSourcesViewController" sender:self];
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
    [[cell textLabel] setNumberOfLines:0];
    [[cell textLabel] setLineBreakMode:NSLineBreakByWordWrapping];
    NSString * repoAddressLabel = [NSString stringWithFormat:@"%@", _sources[indexPath.row]];
    _sourcePackagesFilePath = [_documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-packages.plist", [[_sources objectAtIndex:indexPath.row] stringByReplacingOccurrencesOfString:@"/" withString:@""]]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:_sourcePackagesFilePath]) {
        NSDictionary *sourceInformation = [[NSArray arrayWithContentsOfFile:_sourcePackagesFilePath] objectAtIndex:0];
        NSString *repoName = [sourceInformation objectForKey:@"RepoName"];
        NSString *cellText = [repoName stringByAppendingString:[NSString stringWithFormat:@"\n %@", repoAddressLabel]];
        cell.textLabel.text = cellText;
    } else {
        cell.textLabel.text = repoAddressLabel;
    }
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"goToSourcesViewController"]){
        SourceViewController *destViewController = [segue destinationViewController];
        destViewController.selectedSource = selectedSource;
        destViewController.selectedSourceName = selectedSourceName;
    }
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
