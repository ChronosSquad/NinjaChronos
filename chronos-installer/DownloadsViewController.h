//
//  DownloadsViewController.h
//  chronos-installer
//
//  Created by Sam Gardner on 6/20/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadsViewController : UITableViewController
@property (strong, nonatomic) NSArray * downloadedPackages;
@property (strong, nonatomic) IBOutlet UITableView *downloadsTableView;

@end

NS_ASSUME_NONNULL_END
