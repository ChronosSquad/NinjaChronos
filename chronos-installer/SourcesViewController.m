//
//  SourcesViewController.m
//  chronos-installer
//
//  Created by Sam Gardner on 5/26/18.
//  Copyright © 2018 Chronos Development. All rights reserved.
//

#import "SourcesViewController.h"

@interface SourcesViewController ()

@end

@implementation SourcesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:FALSE animated:TRUE];
    [self.navigationItem setTitle:@"Sources"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
}

@end
