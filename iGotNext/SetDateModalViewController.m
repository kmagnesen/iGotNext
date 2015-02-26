//
//  SetDateModalViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/24/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "SetDateModalViewController.h"

@interface SetDateModalViewController ()

- (void)addStartDateButton;
- (void)setStartDate:(id)sender ;

@property NSDate *gameDay;

@end

@implementation SetDateModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.layer.cornerRadius = 8.f;
    self.view.backgroundColor = [UIColor colorWithRed:0.106 green:0.529 blue:0.722 alpha:1];

    [self addStartDateButton];
    [self datePickerView];
}


#pragma mark -------------- Set Start Time Button --------------

- (void)addStartDateButton {
    UIButton *startDateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    startDateButton.translatesAutoresizingMaskIntoConstraints = NO;
    startDateButton.tintColor = [UIColor whiteColor];
    startDateButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [startDateButton setTitle:@"Set Start Time" forState:UIControlStateNormal];
    [startDateButton addTarget:self action:@selector(setStartDate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startDateButton];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:startDateButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[startDateButton]-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(startDateButton)]];
}

- (void)setStartDate:(id)sender {
    [self startDatePicked];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -------------- DatePicker --------------

-(void)datePickerView {
    _datePicker = [UIDatePicker new];
    _datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];

    _datePicker.minimumDate = [NSDate date];
    _datePicker.transform = CGAffineTransformMakeScale(0.75, 0.75);

    [self.view addSubview:_datePicker];

    //This in theory should be centering the datePicker to horizontal center of the view
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_datePicker
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-50-[_datePicker]"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(_datePicker)]];

}


#pragma mark -------------- Delegate --------------

-(void)startDatePicked {
    self.gameDay = [_datePicker date];
    [self.delegate startDateSetWith:self.gameDay];
}

@end
