//
//  NewEventViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "NewGameViewController.h"
#import "CategoryModalViewController.h"
#import "SetDateModalViewController.h"
#import "StartTimeModalViewController.h"
#import "EndTimeModalViewController.h"
#import "Game.h"

#import "PresentingAnimation.h"
#import "DismissingAnimation.h"


@interface NewGameViewController () <UIViewControllerTransitioningDelegate, CategoryVCDelegate, StartDateVCDelegate, StartTimeVCDelegate, EndTimeVCDelegate>

@property (strong, nonatomic) IBOutlet UIButton *createButton;
@property (strong, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *evenDescriptionTextField;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) NSArray *sportsArray;

@property NSString *category;
@property NSDate *startDate;
@property NSDate *startTime;
@property NSDate *endTime;

@end

@implementation NewGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.eventNameTextField.text = @"";
    self.evenDescriptionTextField.text = @"";
    self.category = @"";
    self.startTime = [NSDate new];
    self.endTime = [NSDate new];

    [[self.createButton layer] setBorderWidth:2.0f];
    [[self.createButton layer] setBorderColor:[UIColor colorWithRed:0 green:0.722 blue:0.851 alpha:1].CGColor];

    UITapGestureRecognizer *tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
}

-(void)dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark ----- Game Parse Object Management -----

-(void)saveUpdatedGame {
    self.game[@"title"] = self.eventNameTextField.text;
    self.game[@"gameDescription"] = self.evenDescriptionTextField.text;
    self.game[@"startDate"] = self.startDate;
    self.game[@"startTime"] = self.startTime;
    self.game[@"endTime"] = self.endTime;
    self.game[@"category"] = self.category;
    [self.game saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self.delegate updateGames];
        } else {
            // There was a problem, check error.description
        }
    }];
}


#pragma mark ----- UIButton Action -----

- (IBAction)onSetCategoryTapped:(id)sender {
    CategoryModalViewController *categoryViewController = [CategoryModalViewController new];
    categoryViewController.delegate = self;
    categoryViewController.transitioningDelegate = self;
    categoryViewController.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:categoryViewController
                                            animated:YES
                                          completion:NULL];
}

- (IBAction)onDateTapped:(UIButton *)sender {
    SetDateModalViewController *startDateVC = [SetDateModalViewController new];
    startDateVC.delegate = self;
    startDateVC.transitioningDelegate = self;
    startDateVC.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:startDateVC
                                            animated:YES
                                          completion:NULL];
}

- (IBAction)onSetStartTimeTapped:(id)sender {
    StartTimeModalViewController *startTimeVC = [StartTimeModalViewController new];
    startTimeVC.delegate = self;
    startTimeVC.transitioningDelegate = self;
    startTimeVC.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:startTimeVC
                                            animated:YES
                                          completion:NULL];
}

- (IBAction)onSetEndTimeTapped:(id)sender {
    EndTimeModalViewController *endTimeVC = [EndTimeModalViewController new];
    endTimeVC.delegate = self;
    endTimeVC.transitioningDelegate = self;
    endTimeVC.modalPresentationStyle = UIModalPresentationCustom;

    [self presentViewController:endTimeVC
                                            animated:YES
                                          completion:NULL];
}


#pragma mark ----- UIViewControllerTransitioningDelegate -----

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return [PresentingAnimation new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [DismissingAnimation new];
}


#pragma mark ----- Modal VC Delegate Methods -----

-(void)categorySetWith:(NSString *)sportCategory {
    self.category = [NSString new];
    self.category = sportCategory;

    self.categoryLabel.text = self.category;
}

-(void)startDateSetWith:(NSDate *)eventStartDate {
    self.startDate = [NSDate new];
    self.startDate = eventStartDate;

    self.dateLabel.text = [NSDateFormatter localizedStringFromDate:self.startDate
                                                         dateStyle:NSDateFormatterMediumStyle
                                                         timeStyle:NSDateFormatterNoStyle];
}

-(void)startTimeSetWith:(NSDate *)eventStartTime {
    self.startTime = [NSDate new];
    self.startTime = eventStartTime;

    self.startTimeLabel.text = [NSDateFormatter localizedStringFromDate:self.startTime
                                                              dateStyle:NSDateFormatterNoStyle
                                                              timeStyle:NSDateFormatterShortStyle];
}

-(void)endTimeSetWith:(NSDate *)eventEndDate {
    self.endTime = [NSDate new];
    self.endTime = eventEndDate;

    self.endTimeLabel.text = [NSDateFormatter localizedStringFromDate:self.endTime
                                                            dateStyle:NSDateFormatterNoStyle
                                                            timeStyle:NSDateFormatterShortStyle];
}


#pragma mark ----- Pre-Unwind action -----

- (IBAction)onCreateTapped:(UIButton *)sender {
    [self saveUpdatedGame];
}

@end
