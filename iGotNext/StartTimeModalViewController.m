//
//  StartTimeModalViewController.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/18/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "StartTimeModalViewController.h"

@interface StartTimeModalViewController ()
- (void)addStartTimeButton;
- (void)setStartTime:(id)sender ;

@property NSDate *startDate;

@end

@implementation StartTimeModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.layer.cornerRadius = 8.f;
    self.view.backgroundColor = [UIColor colorWithRed:0.106 green:0.529 blue:0.722 alpha:1];

    [self addStartTimeButton];
    [self datePickerView];
}


#pragma mark -------------- Set Start Time Button --------------

- (void)addStartTimeButton {
    UIButton *startTimeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    startTimeButton.translatesAutoresizingMaskIntoConstraints = NO;
    startTimeButton.tintColor = [UIColor whiteColor];
    startTimeButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [startTimeButton setTitle:@"Set Start Time" forState:UIControlStateNormal];
    [startTimeButton addTarget:self action:@selector(setStartTime:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startTimeButton];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:startTimeButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[startTimeButton]-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(startTimeButton)]];
}

- (void)setStartTime:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -------------- DatePicker --------------

-(void)datePickerView {
    UIDatePicker *datePicker = [UIDatePicker new];
    datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    [datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
    datePicker.minimumDate = [NSDate date];
    datePicker.transform = CGAffineTransformMakeScale(0.7, 0.7);

    [self.view addSubview:datePicker];

    //This in theory should be centering the datePicker to horizontal center of the view
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:datePicker
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-50-[datePicker]"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(datePicker)]];
}

#pragma mark -------------- Delegate --------------

-(void)startTimePicked {
    [self.delegate startTimeSetWith:self.startDate];
}

@end
