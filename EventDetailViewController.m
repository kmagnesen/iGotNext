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
}

- (IBAction)onAttendButtonTapped:(UIButton *)sender {
}

@end
