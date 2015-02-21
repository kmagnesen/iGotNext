//
//  GameDetailViewController.m
//  iGotNext
//
//  Created by Katelyn Schneider on 2/13/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "GameDetailViewController.h"

@interface GameDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventCategoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UITextView *eventDescriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton *attendButton;
@property NSMutableArray *currentAttendees;

@end

@implementation GameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentAttendees = [NSMutableArray new];
    self.currentAttendees = [NSMutableArray arrayWithArray:self.game.attendees];

    self.eventTitleLabel.text = self.game.title;
    self.eventCategoryLabel.text = self.game.category;
    self.startTimeLabel.text = [NSString stringWithFormat:@"Start Time: %@", self.game.startTime];
    self.endTimeLabel.text = [NSString stringWithFormat:@"End Time: %@", self.game.endTime];
    self.eventDescriptionTextView.text = self.game.description;

    [self.attendButton setTitle:[NSString stringWithFormat:@"%lu people attending", self.game.attendees.count] forState:UIControlStateNormal];
}

-(void)saveUpdatedEvent {
    //Method that updates the event parse object being referred to
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];

    [query getObjectInBackgroundWithId:self.game.objectId block:^(PFObject *game, NSError *error) {
        game[@"attendees"] = self.currentAttendees;
        [game saveInBackground];
    }];
}

- (IBAction)onAttendButtonTapped:(UIButton *)sender {
    PFUser *currentUser = [PFUser currentUser];

    //Changes the number of people attending on the button and saves the changes to the parse object
    if ([self.game.attendees containsObject:currentUser]) {
        [self.currentAttendees removeObject:currentUser];
        [self.attendButton setTitle:[NSString stringWithFormat:@"%lu people attending", self.currentAttendees.count] forState:UIControlStateNormal];
        [self saveUpdatedEvent];
    } else {
        [self.currentAttendees addObject:currentUser];
        [self.attendButton setTitle:[NSString stringWithFormat:@"%lu people attending", self.currentAttendees.count] forState:UIControlStateNormal];
        [self saveUpdatedEvent];
    }
}

@end
