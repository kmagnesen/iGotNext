//
//  GameDetailViewController.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/13/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventCategoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UITextView *eventDescriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *attendButton;
@property NSMutableArray *currentAttendees;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentAttendees = [NSMutableArray new];

    self.navigationItem.title = self.event.eventLocation;
    self.eventTitleLabel.text = self.event.eventTitle;
    self.eventCategoryLabel.text = self.event.eventCategory;
    self.startTimeLabel.text = [NSString stringWithFormat:@"Start Time: %@", self.event.eventStartTime];
    self.endTimeLabel.text = [NSString stringWithFormat:@"End Time: %@", self.event.eventEndTime];
    self.eventDescriptionTextView.text = self.event.eventDescription;

    [self.attendButton setTitle:[NSString stringWithFormat:@"%i people attending", self.event.attendees.count] forState:UIControlStateNormal];
}

-(void)saveUpdatedEvent {
    //Method that updates the event parse object being referred to
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];

    [query getObjectInBackgroundWithId:self.event.objectId block:^(PFObject *event, NSError *error) {
        event[@"attendees"] = self.currentAttendees;
        [event saveInBackground];
    }];
}

- (IBAction)onAttendButtonTapped:(UIButton *)sender {
    PFUser *currentUser = [PFUser currentUser];

    //Changes the number of people attending on the button and saves the changes to the parse object
    if ([self.event.attendees containsObject:currentUser]) {
        [self.currentAttendees removeObject:currentUser];
        [self.attendButton setTitle:[NSString stringWithFormat:@"%i people attending", self.currentAttendees.count] forState:UIControlStateNormal];
        [self saveUpdatedEvent];
    } else {
        [self.currentAttendees addObject:currentUser];
        [self.attendButton setTitle:[NSString stringWithFormat:@"%i people attending", self.currentAttendees.count] forState:UIControlStateNormal];
        [self saveUpdatedEvent];
    }
}

@end
