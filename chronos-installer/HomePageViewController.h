//
//  ViewController.h
//  chronos-installer
//
//  Created by Sam Gardner on 5/11/18.
//  Copyright © 2018 Chronos Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *refreshProgressLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *refreshProgressBar;
@property int sourceBeingUpdated;
@property (strong, nonatomic) NSArray *sourceList;
@end

