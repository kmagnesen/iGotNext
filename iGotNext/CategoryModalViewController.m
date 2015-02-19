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
    self.view.backgroundColor = [UIColor colorWithRed:0.106 green:0.529 blue:0.722 alpha:1];
    [self addSetSportButton];

    self.sportsArray = @[@"Basketball", @"Disc Golf", @"Dodgeball", @"Football", @"Hockey (Street/Ice)", @"Soccer", @"Ultimate Frisbee", @"VolleyBall (Beach/Bar)", @"All Other Sports"];

    [self categoryPickerView];

    //Default setting without moving picker is "Basketball"
    self.category = @"Basketball";
}

#pragma mark -------------- Set Sport Button --------------

- (void)addSetSportButton {
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
    [self categoryPicked];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -------------- CategoryPickerView --------------

-(void)categoryPickerView {
    UIPickerView *categoryPickerView = [UIPickerView new];
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

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[categoryPickerView(50)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(categoryPickerView)]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[categoryPickerView]-8-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(categoryPickerView)]];
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
            self.category = @"Basketball";
            break;
        case 1:
            self.category = @"Disc Golf";
            break;
        case 2:
            self.category = @"Dodgeball";
            break;
        case 3:
            self.category = @"Football";
            break;
        case 4:
            self.category = @"Hockey (Street/Ice)";
            break;
        case 5:
            self.category = @"Soccer";
            break;
        case 6:
            self.category = @"Ultimate Frisbee";
            break;
        case 7:
            self.category = @"VolleyBall (Beach/Bar)";
            break;
        case 8:
            self.category = @"All Other Sports";
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
