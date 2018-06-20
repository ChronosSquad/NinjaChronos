//
//  DownloadViewController.h
//  chronos-installer
//
//  Created by Sam Gardner on 6/18/18.
//  Copyright © 2018 Sam Gardner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadViewController : UIViewController
@property (strong, nonatomic) NSURL *downloadLink;
@property (strong, nonatomic) NSString *bundleID;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@end

NS_ASSUME_NONNULL_END
