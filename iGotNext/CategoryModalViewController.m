//
//  CategoryModalViewController.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/17/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "CategoryModalViewController.h"


@interface CategoryModalViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
- (void)addSetSportButton;
- (void)setSport:(id)sender ;

@property NSString *category;
@property NSArray *sportsArray;

@end

@implementation CategoryModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.layer.cornerRadius = 5.f;
    self.view.backgroundColor = [UIColor whiteColor];
    [self addSetSportButton];
    [self addTitleLabel];

    self.sportsArray = @[@"Baseball", @"Basketball", @"Dodgeball", @"Football", @"Hockey", @"Soccer", @"Tennis", @"VolleyBall", @"Other"];

    [self categoryPickerView];

    //Default setting without moving picker is "Basketball"
    self.category = @"Baseball";
}

#pragma mark -------------- Set Title Label --------------
- (void)addTitleLabel {
    UILabel *titleLabel = [UILabel new];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textColor = [UIColor colorWithRed:0 green:0.722 blue:0.851 alpha:1]
    ;
    [titleLabel.layer setBorderColor:[UIColor colorWithRed:0 green:0.722 blue:0.851 alpha:1].CGColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Regular" size:18];
    titleLabel.text = @"Select Sport";

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


#pragma mark -------------- Set Sport Button --------------

- (void)addSetSportButton {
    UIButton *setSportButton = [UIButton buttonWithType:UIButtonTypeSystem];
    setSportButton.translatesAutoresizingMaskIntoConstraints = NO;
    setSportButton.tintColor = [UIColor colorWithRed:0 green:0.722 blue:0.851 alpha:1]
    ;
    [setSportButton.layer setBorderWidth:2.0f];
    [setSportButton.layer setCornerRadius:5.0f];
    [setSportButton.layer setBorderColor:[UIColor colorWithRed:0 green:0.722 blue:0.851 alpha:1].CGColor];
    setSportButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Regular" size:18];
    [setSportButton setTitle:@"Set" forState:UIControlStateNormal];
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
                               constraintsWithVisualFormat:@"V:[setSportButton(30)]-8-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(setSportButton)]];

    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:[setSportButton(100)]"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(setSportButton)]];

}

- (void)setSport:(id)sender {
    [self categoryPicked];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -------------- CategoryPickerView --------------

-(void)categoryPickerView {
    UIPickerView *categoryPickerView = [UIPickerView new];
    categoryPickerView.translatesAutoresizingMaskIntoConstraints = NO;

    categoryPickerView.delegate = self;
    categoryPickerView.showsSelectionIndicator = YES;
    categoryPickerView.transform = CGAffineTransformMakeScale(0.7, 0.7);

    [self.view addSubview:categoryPickerView];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:categoryPickerView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];
//
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[categoryPickerView]"
//                                                                      options:0
//                                                                      metrics:nil
//                                                                        views:NSDictionaryOfVariableBindings(categoryPickerView)]];

}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component {
    return self.sportsArray.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.sportsArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    switch(row) {
        case 0:
            self.category = @"Baseball";
            break;
        case 1:
            self.category = @"Basketball";
            break;
        case 2:
            self.category = @"Dodgeball";
            break;
        case 3:
            self.category = @"Football";
            break;
        case 4:
            self.category = @"Hockey";
            break;
        case 5:
            self.category = @"Soccer";
            break;
        case 6:
            self.category = @"Tennis";
            break;
        case 7:
            self.category = @"VolleyBall";
            break;
        case 8:
            self.category = @"Other";
            break;
    }
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 300;
}

#pragma mark -------------- Delegate --------------

-(void)categoryPicked {
    [self.delegate categorySetWith:self.category];
}



@end
