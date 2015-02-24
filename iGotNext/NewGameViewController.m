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
#import "StartTimeModalViewController.h"
#import "EndTimeModalViewController.h"
#import "Game.h"

#import "PresentingAnimation.h"
#import "DismissingAnimation.h"


@interface NewGameViewController () <UIViewControllerTransitioningDelegate, CategoryVCDelegate, StartTimeVCDelegate, EndTimeVCDelegate>
@property (strong, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *evenDescriptionTextField;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) NSArray *sportsArray;

@property NSString *category;
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
}


#pragma mark ----- Game Parse Object Management -----

-(void)saveUpdatedGame {
    self.game[@"title"] = self.eventNameTextField.text;
    self.game[@"description"] = self.evenDescriptionTextField.text;
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

-(void)startTimeSetWith:(NSDate *)eventStartDate {
    self.startTime = [NSDate new];
    self.startTime = eventStartDate;

    self.startTimeLabel.text = [NSDateFormatter localizedStringFromDate:self.startTime
                                                              dateStyle:NSDateFormatterShortStyle
                                                              timeStyle:NSDateFormatterFullStyle];
}

-(void)endTimeSetWith:(NSDate *)eventEndDate {
    self.endTime = [NSDate new];
    self.endTime = eventEndDate;

    self.endTimeLabel.text = [NSDateFormatter localizedStringFromDate:self.endTime
                                                            dateStyle:NSDateFormatterShortStyle
                                                            timeStyle:NSDateFormatterFullStyle];
}


#pragma mark ----- Pre-Unwind action -----

- (IBAction)onCreateTapped:(UIButton *)sender {
    [self saveUpdatedGame];
}

@end
