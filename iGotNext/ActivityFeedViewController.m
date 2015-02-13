//
//  ActivityFeedViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <Parse/Parse.h>
#import "ActivityFeedViewController.h"
#import "Event.h"

@interface ActivityFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedController;
@property NSMutableArray *gamesDisplayed;
@property PFUser *currentUser;

@end

@implementation ActivityFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currentUser = [PFUser currentUser];

    //View opens with "Events Created" higlighted
    [self loadEventsCurrentUserCreated];

    [self.segmentedController setTitle:@"Events Created" forSegmentAtIndex:0];
    [self.segmentedController setTitle:@"Events Attending" forSegmentAtIndex:1];
}

- (IBAction)onSegmentedControllerTapped:(UISegmentedControl *)sender {
    //Segmentedcontroller dictates what shows in the tableview when it is tapped
    if (sender.selectedSegmentIndex == 0) {
        [self loadEventsCurrentUserCreated];
        [self.tableView reloadData];
    } else if (sender.selectedSegmentIndex == 1) {
        [self loadEventsCurrentUserIsAttending];
        [self.tableView reloadData];
    }
}

#pragma mark ----------- Pulling UITableView Content -----------
-(void)loadEventsCurrentUserCreated {
    self.gamesDisplayed = [NSMutableArray new];

    //Pulls events based on their eventCreator property
    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    [query whereKey:@"eventCreator" equalTo:self.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedEvents, NSError *error) {

        if (!error) {
            for (Event *event in returnedEvents) {
                [self.gamesDisplayed addObject:event];
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)loadEventsCurrentUserIsAttending {
    self.gamesDisplayed = [NSMutableArray new];

    PFQuery *query = [PFQuery queryWithClassName:@"Event"];
    //[query whereKey:@"eventCreator" containsString:@""];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedEvents, NSError *error) {

        if (!error) {
            for (Event *event in returnedEvents) {
                [self.gamesDisplayed addObject:event];
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark ----------- UITableView Delegate & Data Source -----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.gamesDisplayed.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell"];
    Event *event = [self.gamesDisplayed objectAtIndex:indexPath.row];
    cell.textLabel.text = event.eventTitle;
    return cell;
}

@end
