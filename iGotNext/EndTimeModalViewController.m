//
//  EndTimeModalViewController.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/18/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "EndTimeModalViewController.h"

@interface EndTimeModalViewController ()
- (void)addEndTimeButton;
- (void)setEndTime:(id)sender ;

@property NSDate *endDate;

@end

@implementation EndTimeModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.layer.cornerRadius = 8.f;
    self.view.backgroundColor = [UIColor colorWithRed:0.106 green:0.529 blue:0.722 alpha:1];

    [self addEndTimeButton];
    [self datePickerView];
}


#pragma mark -------------- Set End Time Button --------------

- (void)addEndTimeButton {
    UIButton *endTimeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    endTimeButton.translatesAutoresizingMaskIntoConstraints = NO;
    endTimeButton.tintColor = [UIColor whiteColor];
    endTimeButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [endTimeButton setTitle:@"Set End Time" forState:UIControlStateNormal];
    [endTimeButton addTarget:self action:@selector(setEndTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:endTimeButton];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:endTimeButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[endTimeButton]-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(endTimeButton)]];
}

- (void)setEndTime:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -------------- DatePicker --------------

-(void)datePickerView {
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 210, 320, 216)];
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];

    [self.view addSubview:datePicker];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:datePicker
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-[datePicker(>=100)]-|"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(datePicker)]];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:[datePicker(==50)]"
                               options:NSLayoutFormatDirectionLeadingToTrailing
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(datePicker)]];
}


#pragma mark -------------- Delegate --------------

-(void)endTimePicked {
    [self.delegate endTimeSetWith:self.endDate];
}

@end
