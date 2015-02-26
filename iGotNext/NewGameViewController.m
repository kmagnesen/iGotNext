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

#import "Game.h"

#import "NewGameAnimation.h"
#import "DismissingAnimation.h"


@interface NewGameViewController () <UIViewControllerTransitioningDelegate, CategoryVCDelegate, StartDateVCDelegate>

@property (strong, nonatomic) IBOutlet UIButton *createButton;
@property (strong, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *evenDescriptionTextField;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;

@property (strong, nonatomic) NSArray *sportsArray;

@property NSString *category;
@property NSDate *startTime;


@property BOOL unwind;

@end

@implementation NewGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.eventNameTextField.text = @"";
    self.evenDescriptionTextField.text = @"";
    self.categoryLabel.text = @"";
    self.startTimeLabel.text = @"";
    self.category = @"";
    self.startTime = [NSDate new];

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
    self.game[@"startTime"] = self.startTime;
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


#pragma mark ----- UIViewControllerTransitioningDelegate -----

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return [NewGameAnimation new];
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
    self.startTime = [NSDate new];
    self.startTime = eventStartDate;

    self.startTimeLabel.text = [NSDateFormatter localizedStringFromDate:self.startTime
                                                              dateStyle:NSDateFormatterNoStyle
                                                              timeStyle:NSDateFormatterShortStyle];
}


#pragma mark ----- Pre-Unwind action -----

- (IBAction)onCreateTapped:(UIButton *)sender {
    [self checkGameInputs];

}

#pragma mark ----- Check Inputs -----

-(void)checkGameInputs {
    if ([self.eventNameTextField.text isEqualToString:@""] || [self.evenDescriptionTextField.text isEqualToString:@""] || [self.categoryLabel.text isEqualToString:@""] || [self.startTimeLabel.text isEqualToString:@""]) {

        [self checkInputsAlert];
        
        self.unwind = NO;

        [self shouldPerformSegueWithIdentifier:@"unwindToGameFeed" sender:nil];

    } else {
        [self saveUpdatedGame];

        self.unwind = YES;

        [self shouldPerformSegueWithIdentifier:@"unwindToGameFeed" sender:nil];

    }
}

-(void)checkInputsAlert{
    UIAlertController *inputAlert = [UIAlertController alertControllerWithTitle:@"Oops" message:@"It seems at least one of fields was not set." preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];

    [inputAlert addAction:cancelAction];

    [self presentViewController:inputAlert animated:true completion:nil];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (self.unwind == NO) {
        return NO;
    }
    return YES;
}


@end
