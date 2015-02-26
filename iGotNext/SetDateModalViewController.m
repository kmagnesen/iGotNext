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
    self.view.backgroundColor = [UIColor whiteColor];

    [self addStartDateButton];
    [self addTitleLabel];
    [self datePickerView];
}

#pragma mark -------------- Set Title Label --------------
- (void)addTitleLabel {
    UILabel *titleLabel = [UILabel new];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textColor = [UIColor colorWithRed:0 green:0.722 blue:0.851 alpha:1];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Regular" size:18];
    titleLabel.text = @"Select Start Time";

    [self.view addSubview:titleLabel];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-8-[titleLabel]"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(titleLabel)]];
}

#pragma mark -------------- Set Start Time Button --------------

- (void)addStartDateButton {
    UIButton *startDateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    startDateButton.translatesAutoresizingMaskIntoConstraints = NO;
    startDateButton.tintColor = [UIColor colorWithRed:0 green:0.722 blue:0.851 alpha:1];
    [startDateButton.layer setBorderWidth:2.0f];
    [startDateButton.layer setCornerRadius:5.0f];
    [startDateButton.layer setBorderColor:[UIColor colorWithRed:0 green:0.722 blue:0.851 alpha:1].CGColor];

    startDateButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Regular" size:18];
    [startDateButton setTitle:@"Set" forState:UIControlStateNormal];
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
                               constraintsWithVisualFormat:@"V:[startDateButton(30)]-8-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(startDateButton)]];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:[startDateButton(100)]"
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

//    [self.view addConstraints:[NSLayoutConstraint
//                               constraintsWithVisualFormat:@"V:|-50-[_datePicker]"
//                               options:0
//                               metrics:nil
//                               views:NSDictionaryOfVariableBindings(_datePicker)]];

}


#pragma mark -------------- Delegate --------------

-(void)startDatePicked {
    self.gameDay = [_datePicker date];
    [self.delegate startDateSetWith:self.gameDay];
}

@end
