//
//  EditInterestsModalViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/19/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Parse/Parse.h>

#import "EditInterestsModalViewController.h"

@interface EditInterestsModalViewController ()
- (void)addEditInterestsButton;
- (void)setSport:(id)sender;

@property NSMutableArray *selections;
@property NSMutableArray *interests;

@end

@implementation EditInterestsModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.layer.cornerRadius = 5.f;
    self.view.backgroundColor = [UIColor colorWithRed:0.106 green:0.529 blue:0.722 alpha:1];
    [self addEditInterestsButton];
    
}

- (void) saveInterests {
    PFUser *currentUser  = [PFUser currentUser];
    currentUser[@"interests"] = self.selections;
    [currentUser saveInBackground];
}

- (void)addEditInterestsButton {
    UIButton *setSportButton = [UIButton buttonWithType:UIButtonTypeSystem];
    setSportButton.translatesAutoresizingMaskIntoConstraints = NO;
    setSportButton.tintColor = [UIColor whiteColor];
    setSportButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [setSportButton setTitle:@"Set Sport" forState:UIControlStateNormal];
    [setSportButton addTarget:self action:@selector(setSport:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:setSportButton];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:setSportButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[setSportButton]-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(setSportButton)]];
}

- (void)setSport:(id)sender {
//    [self categoryPicked];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
