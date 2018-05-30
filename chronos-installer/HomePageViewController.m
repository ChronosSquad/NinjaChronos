//
//  ViewController.m
//  chronos-installer
//
//  Created by Sam Gardner on 5/11/18.
//  Copyright © 2018 Chronos Development. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:TRUE animated:FALSE];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)infoButton:(id)sender {
    UIAlertController *teamInfo = [UIAlertController alertControllerWithTitle:@"Chronos Installer" message:@"Created by EthanR, FoxletFox, Lepidus, PsychoTea, and Samg_is_a_Ninja" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
    [teamInfo addAction:okAction];
    [self presentViewController:teamInfo animated:YES completion:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [self.navigationController setNavigationBarHidden:FALSE animated:TRUE];
}


@end
