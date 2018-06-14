//
//  SourcesTableViewController.h
//  chronos-installer
//
//  Created by Sam Gardner on 5/26/18.
//  Copyright © 2018 Chronos Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SourcesTableViewController : UITableViewController
<UIAlertViewDelegate>
@property (strong, nonatomic) NSMutableArray * sources;
@property (strong, nonatomic) IBOutlet UITableView *sourcesTableView;
@property BOOL changesMade;
@property (strong, nonatomic) NSString *sourcesplistFilePath;
@property (copy, nonatomic) NSString *selectedSource;
@property (strong, nonatomic) NSString *documentsDirectory;
@property (strong, nonatomic) NSString *sourcePackagesFilePath;
@property (strong, nonatomic) NSString *selectedSourceName;

@end
