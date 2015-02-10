//
//  RootViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/10/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "RootViewController.h"
#import <Parse/Parse.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([PFUser currentUser] == nil) {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"ByPassSegue" sender:self];
    }
}
@end
