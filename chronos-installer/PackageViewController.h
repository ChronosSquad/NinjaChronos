//
//  PackageViewController.h
//  chronos-installer
//
//  Created by Sam Gardner on 6/12/18.
//  Copyright © 2018 Chronos Development. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchKit/WatchKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PackageViewController : UIViewController
@property (strong, nonatomic) NSDictionary *selectedPackage;
@property (strong, nonatomic) NSString *selectedSource;
@property (strong, nonatomic) IBOutlet UILabel *packageNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *packageAuthorLabel;
@property (strong, nonatomic) IBOutlet UILabel *packageRepoLabel;
@property (strong, nonatomic) IBOutlet UILabel *packageDescLabel;
@property (strong, nonatomic) IBOutlet UILabel *packageDependsLabel;
@property (strong, nonatomic) IBOutlet UILabel *packageBundleIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *watchOSCompatibilityLabel;
@property (strong, nonatomic) IBOutlet UIImageView *packageIconView;
@property (strong, nonatomic) IBOutlet UIButton *downloadButtonOutlet;
@property (strong, nonatomic) NSString *packageName;
@property (strong, nonatomic) NSString *packageAuthor;
@property (strong, nonatomic) NSString *selectedSourceName;
@property (strong, nonatomic) NSURL *packageDescLink;
@property (strong, nonatomic) NSArray *packageDependencies;
@property (strong, nonatomic) NSString *packageBundleID;
@property (strong, nonatomic) NSURL *packageIconLink;
@property (strong, nonatomic) NSURL *packageDownloadLink;
@property (strong, nonatomic) NSString *packageVersion;
@property (strong, nonatomic) NSArray *packageWatchOSCompatibility;
@property (strong, nonatomic) NSString *packageDescription;
@property (strong, nonatomic) UIImage *packageIconImage;
@end

NS_ASSUME_NONNULL_END
