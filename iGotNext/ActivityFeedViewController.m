//
//  ActivityFeedViewController.m
//  iGotNext
//
//  Created by Kyle Magnesen on 2/9/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//
#import <Parse/Parse.h>
#import "ActivityFeedViewController.h"
#import "Game.h"
#import "ActivityTableViewCell.h"

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
//    [self loadEventsCurrentUserCreated];

    [self.segmentedController setTitle:@"Events Created" forSegmentAtIndex:0];
    [self.segmentedController setTitle:@"Events Attending" forSegmentAtIndex:1];
}

-(void)viewWillAppear:(BOOL)animated {
    //View opens with "Events Created" higlighted
    [self segmentedControllerLogic];
}

- (IBAction)onSegmentedControllerTapped:(UISegmentedControl *)sender {
    [self segmentedControllerLogic];
}

-(void)segmentedControllerLogic {
    //Segmentedcontroller dictates what shows in the tableview when it is tapped
    if (self.segmentedController.selectedSegmentIndex == 0) {
        [self loadEventsCurrentUserCreated];
        [self.tableView reloadData];
    } else if (self.segmentedController.selectedSegmentIndex == 1) {
        [self loadEventsCurrentUserIsAttending];
        [self.tableView reloadData];
    }
}

#pragma mark ----------- Pulling UITableView Content -----------
-(void)loadEventsCurrentUserCreated {
    self.gamesDisplayed = [NSMutableArray new];

    //Pulls events based on their eventCreator property
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query whereKey:@"eventCreator" equalTo:self.currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedEvents, NSError *error) {

        if (!error) {
            for (Game *game in returnedEvents) {
                [self.gamesDisplayed addObject:game];
            }
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)loadEventsCurrentUserIsAttending {
    self.gamesDisplayed = [NSMutableArray new];

    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedEvents, NSError *error) {

        if (!error) {
            for (Game *game in returnedEvents) {
                if([game.attendees containsObject:self.currentUser]) {
                    [self.gamesDisplayed addObject:game];
                } else {
                    ;
                }
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
    ActivityTableViewCell *activityCell = [tableView dequeueReusableCellWithIdentifier:@"ActivityCell"];
    Game *game = [self.gamesDisplayed objectAtIndex:indexPath.row];
    activityCell.game = game;
    return activityCell;
}

@end
