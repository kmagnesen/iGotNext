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
@property BOOL attending;

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = self.event.eventLocation;
    self.eventTitleLabel.text = self.event.eventTitle;
    self.eventCategoryLabel.text = self.event.eventCategory;
    self.startTimeLabel.text = [NSString stringWithFormat:@"Start Time: %@", self.event.eventStartTime];
    self.endTimeLabel.text = [NSString stringWithFormat:@"End Time: %@", self.event.eventEndTime];
    self.eventDescriptionTextView.text = self.event.eventDescription;

    self.currentAttendees = [NSMutableArray arrayWithArray:self.event.attendees];
}

-(void)findUsersAttendingEvent {
    
}

- (IBAction)onAttendButtonTapped:(UIButton *)sender {
    PFUser *currentUser = [PFUser object];
    NSMutableArray *currentAttendees = [NSMutableArray arrayWithArray:self.event.attendees];

    if ([self.currentAttendees containsObject:currentUser]) {
        [self.currentAttendees removeObject:currentUser];
    } else {
        [self.currentAttendees addObject:currentUser];
    }

    self.event.attendees = [NSArray arrayWithArray:currentAttendees];

    [self.event saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"New event saved, but this is a reminder to work on the event that the event does not save");
        } else {
            NSLog(@"Updated event never saved, work on notification that makes sense for user");
        }
    }];
}

@end
