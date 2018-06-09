//
//  SourceViewController.h
//  chronos-installer
//
//  Created by Sam Gardner on 6/5/18.
//  Copyright © 2018 Chronos Development. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SourceViewController : UITableViewController
@property (strong, nonatomic) NSString *selectedSource;
@property (strong, nonatomic) NSArray *packages;

@end

NS_ASSUME_NONNULL_END
