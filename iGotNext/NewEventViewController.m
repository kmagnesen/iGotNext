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
#import "Event.h"

@interface NewEventViewController () <UIViewControllerTransitioningDelegate>
@property (strong, nonatomic) IBOutlet UITextField *eventNameTextField;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;
//@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
//@property (strong, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (strong, nonatomic) IBOutlet UIPickerView *sportPicker;
@property (strong, nonatomic) IBOutlet UILabel *sportLabel;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurredView;
@property (strong, nonatomic) NSArray *sportsArray;
@property NSString *category;

@end

@implementation NewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.category = [NSString new];

    self.navigationItem.title = self.park.name;

}

//On Post button pressed, segue back saves newly created event
//TODO: segue needs to be changed to appropriate VC
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"BackToHomeFeed"]) {
        PFUser *currentUser = [PFUser currentUser];

        Event *event = [[Event alloc] initWithUser:currentUser
                                             Title:self.eventNameTextField
                                       Description:self.descriptionTextView
                                          Location:self.park
                                          Category:self.category
                                         StartTime:nil
                                           EndTime:nil];

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
    categoryViewController.transitioningDelegate = self;
    categoryViewController.modalPresentationStyle = UIModalPresentationCustom;

    [self.navigationController presentViewController:categoryViewController
                                            animated:YES
                                          completion:NULL];
}



@end
