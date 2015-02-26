//
//  RootViewController.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/23/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <Parse/Parse.h>
#import "MainTabBarController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0 green:0.722 blue:0.851 alpha:1]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:YES];
//    //if no current user exists go back to login page
//    //PFUser *currentUser = [PFUser ];
//    if ([PFUser currentUser]) {
//        ;
//    } else {
//        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
//    }
//}



@end
