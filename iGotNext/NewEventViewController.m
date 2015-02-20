//
//  NewEventViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "NewEventViewController.h"
#import "ParkGameViewController.h"
#import "CategoryModalViewController.h"
#import "StartTimeModalViewController.h"
#import "EndTimeModalViewController.h"
#import "Event.h"

#import "PresentingAnimation.h"
#import "DismissingAnimation.h"


@interface NewEventViewController () <UIViewControllerTransitioningDelegate, CategoryVCDelegate, StartTimeVCDelegate, EndTimeVCDelegate>
@property (strong, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *evenDescriptionTextField;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) NSArray *sportsArray;
@property NSString *category;
@property NSDate *startTime;
@property NSDate *endTime;

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.park.name;
}

//On Post button pressed, segue back saves newly created event
//TODO: segue needs to be changed to appropriate VC
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"BackToHomeFeed"]) {
        PFUser *currentUser = [PFUser currentUser];

        Event *event = [[Event alloc] initWithUser:currentUser
                                             Title:self.eventNameTextField
                                       Description:self.evenDescriptionTextField
                                          Location:self.park
                                          Category:self.category
                                         StartTime:self.startTime
                                           EndTime:self.endTime];

        [event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"New event saved, but this is a reminder to work on the event that the event does not save");
            } else {
                NSLog(@"New event never saved, work on notification that makes sense for user");
            }
        }];
    }
}

- (IBAction)onSetCategoryTapped:(id)sender {
    CategoryModalViewController *categoryViewController = [CategoryModalViewController new];
    categoryViewController.delegate = self;
    categoryViewController.transitioningDelegate = self;
    categoryViewController.modalPresentationStyle = UIModalPresentationCustom;

    [self.navigationController presentViewController:categoryViewController
                                            animated:YES
                                          completion:NULL];
}

- (IBAction)onSetStartTimeTapped:(id)sender {
    StartTimeModalViewController *startTimeVC = [StartTimeModalViewController new];
    startTimeVC.delegate = self;
    startTimeVC.transitioningDelegate = self;
    startTimeVC.modalPresentationStyle = UIModalPresentationCustom;

    [self.navigationController presentViewController:startTimeVC
                                            animated:YES
                                          completion:NULL];
}

- (IBAction)onSetEndTimeTapped:(id)sender {
    EndTimeModalViewController *endTimeVC = [EndTimeModalViewController new];
    endTimeVC.delegate = self;
    endTimeVC.transitioningDelegate = self;
    endTimeVC.modalPresentationStyle = UIModalPresentationCustom;

    [self.navigationController presentViewController:endTimeVC
                                            animated:YES
                                          completion:NULL];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return [PresentingAnimation new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [DismissingAnimation new];
}

#pragma mark -------------- Modal VC Delegate Methods --------------
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

@end
