//
//  RootViewController.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/23/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <Parse/Parse.h>
#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    //if no current user exists go back to login page
    //PFUser *currentUser = [PFUser ];
    if ([PFUser currentUser]) {
        ;
    } else {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}



@end
